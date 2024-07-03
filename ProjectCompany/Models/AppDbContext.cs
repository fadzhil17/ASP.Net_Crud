using Microsoft.EntityFrameworkCore;

namespace ProjectCompany.Models
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
        : base(options) { }

        public DbSet<Department> Departments { get; set; }
        public DbSet<Employee> Employees { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);

            modelBuilder.Entity<Department>(entity =>
            {
                entity.ToTable("Department"); // Ensure it matches the actual table name
            });
            modelBuilder.Entity<Employee>(entity =>
            {
                entity.ToTable("Employee"); 
            });

            modelBuilder.Entity<Employee>()
                .Property(e => e.Salary)
                .HasColumnType("decimal(18,2)");

        }
    }
}
