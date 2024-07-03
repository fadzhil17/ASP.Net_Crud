namespace ProjectCompany.Models
{
    public class EmployeeViewModel
    {
        public int Id { get; set; }
        public string Name { get; set; }
        public string Address { get; set; }
        public int Age { get; set; }
        public string TelNo { get; set; }
        public decimal Salary { get; set; }
        public string DepartmentName { get; set; }

        public int DepartmentId { get; set; }

    }
}
