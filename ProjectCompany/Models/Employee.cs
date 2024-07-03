using System.ComponentModel.DataAnnotations;

namespace ProjectCompany.Models
{
    public class Employee
    {
        public int Id { get; set; }

        [Required]
        public string Name { get; set; }

        [Required]
        public string Address { get; set; }

        [Range(18, 65)]
        public int Age { get; set; }

        [Phone]
        public string TelNo { get; set; }

        [DataType(DataType.Currency)]
        public decimal Salary { get; set; }

        [Required]
        public int DepartmentId { get; set; }

        public Department Department { get; set; }
    }
}
