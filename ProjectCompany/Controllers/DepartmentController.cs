// Controllers/DepartmentController.cs
using Microsoft.AspNetCore.Mvc;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using ProjectCompany.Models;
using System.Threading.Tasks;
using System.Linq;

public class DepartmentController : Controller
{
    private readonly AppDbContext _context;

    public DepartmentController(AppDbContext context)
    {
        _context = context;
    }

    public async Task<IActionResult> Index()
    {
        var departments = await _context.Departments
            .FromSqlRaw("EXEC SP_GET_Departments")
            .ToListAsync();
        return View(departments);
    }

    [HttpGet]
    public IActionResult Add()
    {
        return View();
    }

    [HttpPost]
    public async Task<IActionResult> Add(Department department)
    {
        if (ModelState.IsValid)
        {
            var parameters = new[]
            {
                new SqlParameter("@Name", department.Name),
                new SqlParameter("@CreatedDate", department.CreatedDate),
                new SqlParameter("@UpdateDate", department.UpdateDate)
            };

            await _context.Database.ExecuteSqlRawAsync("EXEC SP_Insert_Department @Name, @CreatedDate, @UpdateDate", parameters);
            return RedirectToAction(nameof(Index));
        }
        return View(department);
    }

    [HttpGet]
    public async Task<IActionResult> Edit(int id)
    {
        var department = await _context.Departments.FindAsync(id);
        return department == null ? NotFound() : View(department);
    }

    [HttpPost]
    public async Task<IActionResult> Edit(int id, Department department)
    {
        if (id != department.Id)
        {
            return NotFound();
        }

        if (ModelState.IsValid)
        {
            var parameters = new[]
            {
                new SqlParameter("@Id", department.Id),
                new SqlParameter("@Name", department.Name),
                new SqlParameter("@UpdateDate", department.UpdateDate)
            };

            await _context.Database.ExecuteSqlRawAsync("EXEC SP_Edit_Department @Id, @Name, @UpdateDate", parameters);
            return RedirectToAction(nameof(Index));
        }
        return View(department);
    }

    public async Task<IActionResult> Delete(int id)
    {
        var parameters = new SqlParameter("@Id", id);
        await _context.Database.ExecuteSqlRawAsync("EXEC SP_Remove_Department @Id", parameters);
        return RedirectToAction(nameof(Index));
    }
}
