// Controllers/EmployeeController.cs
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using ProjectCompany.Models;
using System.Threading.Tasks;
using System.Linq;
using Microsoft.AspNetCore.Mvc.Rendering;

public class EmployeeController : Controller
{
    private readonly AppDbContext _context;

    public EmployeeController(AppDbContext context)
    {
        _context = context;
    }

    [HttpGet]
    public async Task<IActionResult> Index()
    {
        var employees = await _context.Employees
            .Include(e => e.Department)
            .Select(e => new EmployeeViewModel
            {
                Id = e.Id,
                Name = e.Name,
                Address = e.Address,
                Age = e.Age,
                TelNo = e.TelNo,
                Salary = e.Salary,
                DepartmentName = e.Department.Name // Fetch department name
            })
            .ToListAsync();

        return View(employees);
    }

    [HttpGet]
    public async Task<IActionResult> Add()
    {
        var departments = await _context.Departments
            .FromSqlRaw("EXEC SP_GET_Departments")
            .ToListAsync();

        ViewBag.Departments = departments.Select(d => new SelectListItem
        {
            Value = d.Id.ToString(),
            Text = d.Name
        }).ToList();

        return View();
    }

    [HttpPost]
    public async Task<IActionResult> Add(EmployeeViewModel model)
    {
        if (ModelState.IsValid)
        {
            await _context.Database.ExecuteSqlRawAsync("EXEC SP_Insert_Employee @p0, @p1, @p2, @p3, @p4, @p5",
                parameters: new object[] {
                model.Name,
                model.Address,
                model.Age,
                model.TelNo,
                model.Salary,
                model.DepartmentId
                });

            return RedirectToAction("Index");
        }

        // Repopulate ViewBag.Departments in case of validation failure
        var departments = await _context.Departments
            .FromSqlRaw("EXEC SP_GET_Departments")
            .ToListAsync();

        ViewBag.Departments = departments.Select(d => new SelectListItem
        {
            Value = d.Id.ToString(),
            Text = d.Name
        }).ToList();

        return View(model);
    }

    [HttpGet]
    public async Task<IActionResult> Edit(int id)
    {
        var employee = await _context.Employees
            .FromSqlRaw("EXEC SP_GET_Employee_ById @p0", id)
            .AsNoTracking()
            .FirstOrDefaultAsync();

        if (employee == null)
        {
            return NotFound();
        }

        var departments = await _context.Departments
            .FromSqlRaw("EXEC SP_GET_Departments")
            .AsNoTracking()
            .ToListAsync();

        ViewBag.Departments = departments.Select(d => new SelectListItem
        {
            Value = d.Id.ToString(),
            Text = d.Name
        }).ToList();

        var viewModel = new EmployeeViewModel
        {
            Id = employee.Id,
            Name = employee.Name,
            Address = employee.Address,
            Age = employee.Age,
            TelNo = employee.TelNo,
            Salary = employee.Salary,
            DepartmentId = employee.DepartmentId
        };

        return View(viewModel);
    }

    [HttpPost]
    public async Task<IActionResult> Edit(int id, EmployeeViewModel model)
    {
        if (ModelState.IsValid)
        {
            await _context.Database.ExecuteSqlRawAsync("EXEC SP_Update_Employee @p0, @p1, @p2, @p3, @p4, @p5, @p6",
                parameters: new object[] {
                    id,
                    model.Name,
                    model.Address,
                    model.Age,
                    model.TelNo,
                    model.Salary,
                    model.DepartmentId
                });

            return RedirectToAction("Index");
        }

        var departments = await _context.Departments
            .FromSqlRaw("EXEC SP_GET_Departments")
            .AsNoTracking()
            .ToListAsync();

        ViewBag.Departments = departments.Select(d => new SelectListItem
        {
            Value = d.Id.ToString(),
            Text = d.Name
        }).ToList();

        return View(model);
    }



    private bool EmployeeExists(int id)
    {
        return _context.Employees.Any(e => e.Id == id);
    }

    public async Task<IActionResult> Delete(int id)
    {
        var parameters = new SqlParameter("@Id", id);
        await _context.Database.ExecuteSqlRawAsync("EXEC SP_Remove_Employee @Id", parameters);
        return RedirectToAction(nameof(Index));
    }
}
