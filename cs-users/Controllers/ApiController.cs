using Microsoft.AspNetCore.Mvc;
using Dapper;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using Npgsql;

namespace web.Controllers
{
  public class MyContext : DbContext
  {
      public DbSet<User> Users { get; set; }

      protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
      {
        optionsBuilder.UseNpgsql("Server=localhost;Database=cgweb_dev;Uid=postgres;Pwd=password;");
      }
  }

  [Table("users")]
  public class User
  {
    [Column("name")]
    public string Name { get; set; }
    [Column("email")]
    public string Email { get; set; }
    [Column("id")]
    public int Id { get; set; }
  }

  public class ApiController : Controller
  {
    public async Task<IActionResult> Users(int max = 10)
    {
      using (var db = new MyContext())
      {
        var users = await db.Users.Select(u => new {u.Id, u.Email})
          .Take(max)
          .ToListAsync();

        return Json(users);
      }
    }

    public async Task<IActionResult> UsersDapp()
    {
      using(var dbConnection = new NpgsqlConnection("Server=localhost;Database=cgweb_dev;Uid=postgres;Pwd=password;"))
      {
          var users = await dbConnection.QueryAsync<User>("SELECT id, email FROM users LIMIT 10");

          return Json(users);
      }
    }
  }
}
