using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace WebApp.Controllers
{
    public class DraftController : Controller
    {
        //
        // GET: /Draft/

        [Authorize]
        public ActionResult Index()
        {
            var authorId = Session["au_id"] as string;
            if (String.IsNullOrEmpty(authorId))
                return View();
            else
            {
                var data = Session["pubs"] as DataAccess.Data;
                var d = data.Drafts(authorId);
                return View(d);
            }
        }

        //
        // GET: /Draft/Details/5

        [HttpPost]
        [Authorize]
        public ActionResult Details(string encKey)
        {
            return View();
        }

        [HttpPost]
        [Authorize]
        public ActionResult Details(FormCollection collection)
        {
            return View();
        }

        [Authorize]
        public ActionResult Crypto(int id)
        {
            var authorId = Session["au_id"] as string;
            if (String.IsNullOrEmpty(authorId))
                return View();
            else
            {
                var data = Session["pubs"] as DataAccess.Data;
                return View();
            }
            return View();
        }

        //
        // GET: /Draft/Create

        [Authorize]
        public ActionResult Create()
        {
            return View();
        } 

        //
        // POST: /Draft/Create

        [HttpPost]
        [Authorize]
        public ActionResult Create(FormCollection collection)
        {
            try
            {
                // TODO: Add insert logic here

                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
        
        //
        // GET: /Draft/Edit/5

        [Authorize]
        public ActionResult Edit(int id)
        {
            return View();
        }

        //
        // POST: /Draft/Edit/5

        [HttpPost]
        [Authorize]
        public ActionResult Edit(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add update logic here
 
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }

        //
        // GET: /Draft/Delete/5

        [Authorize]
        public ActionResult Delete(int id)
        {
            return View();
        }

        //
        // POST: /Draft/Delete/5

        [HttpPost]
        [Authorize]
        public ActionResult Delete(int id, FormCollection collection)
        {
            try
            {
                // TODO: Add delete logic here
 
                return RedirectToAction("Index");
            }
            catch
            {
                return View();
            }
        }
    }
}
