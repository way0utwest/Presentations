using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WebApp.Controllers
{
    public class UserController : Controller
    {
        //
        // GET: /User/

        [Authorize]
        public ActionResult Index()
        {
            var authorId = Session["au_id"] as string;
            if (String.IsNullOrEmpty(authorId))
                return View();
            else
            {
                var data = Session["pubs"] as DataAccess.Data;
                var auth = data.GetAuthor(authorId);
                return View(auth);

            }
        }

    }
}
