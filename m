From: Peter Crosthwaite <peter.crosthwaite@xilinx.com>
Subject: Re: [PATCH v2] sysbus: add irq_routing_notifier
Date: Mon, 27 Apr 2015 10:43:51 -0700
Message-ID: <CAEgOgz61=-jvDGg7BWWAJSVCceaCJ21t_7jjqF_H_B5BuhVdXg@mail.gmail.com>
References: <1429879153-23476-1-git-send-email-eric.auger@linaro.org>
	<CAEgOgz5rBLZD1U0iodZvytb_RYjH7a04attgZxZ-WbuFOkPxpA@mail.gmail.com>
	<553DF2AA.2070102@linaro.org> <553E11E7.7070704@redhat.com>
	<553E297F.4020706@linaro.org> <553E3B7E.9080009@redhat.com>
	<CAEgOgz6eFLhkwm7qto=j=p3L5+cz5s_McUyZUcqeN265CgXSdg@mail.gmail.com>
	<553E4E05.1010405@linaro.org> <553E4F2D.7060808@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org>
In-Reply-To: <553E4F2D.7060808@redhat.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
Sender: qemu-devel-bounces+gceq-qemu-devel=gmane.org@nongnu.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: eric.auger@st.com, Patch Tracking <patches@linaro.org>, Eric Auger <eric.auger@linaro.org>, "qemu-devel@nongnu.org Developers" <qemu-devel@nongnu.org>, Alex Williamson <alex.williamson@redhat.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Apr 27, 2015 at 8:01 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
>
>
> On 27/04/2015 16:56, Eric Auger wrote:
>> Peter, Paolo,
>>
>> After your feedbacks, I feel I need to spend some more time on the
>> original check() track. I would prefer not to introduce any patch that
>> will make issue in the future.
>
> Peter, see the other threads between me and Eric.  See in particular
> http://lists.gnu.org/archive/html/qemu-devel/2015-04/msg02749.html
> starting at "The notifier actually is not even necessary" and the
> replies from there.
>

Thanks,

I see the problem with check. In this reply

http://lists.gnu.org/archive/html/qemu-devel/2015-04/msg02956.html

Eric says that the problem with the check hook is it happens before
the setting. I think this can be solved with a RYO link setter for
GPIOs. We almost have an in-tree precedent with MemoryRegion and the
container property (memory.c):

 960     op = object_property_add(OBJECT(mr), "container",
 961                              "link<" TYPE_MEMORY_REGION ">",
 962                              memory_region_get_container,
 963                              NULL, /* memory_region_set_container */
 964                              NULL, NULL, &error_abort);

Now in reality we could have done this link normal style as it is only
a trivial getter, but the reason the link was done this way in the
first place, is because I have a follow up patch to memory.c that adds
a customer Link setter:

+static void memory_region_set_container(Object *obj, Visitor *v, void *opaque,
+                                        const char *name, Error **errp)
+{
+    MemoryRegion *mr = MEMORY_REGION(obj);
+    Error *local_err = NULL;
+    MemoryRegion *old_container = mr->container;
+    MemoryRegion *new_container = NULL;
+    char *path = NULL;
+
+    visit_type_str(v, &path, name, &local_err);
+
+    if (!local_err && strcmp(path, "") != 0) {
+        new_container = MEMORY_REGION(object_resolve_link(obj, name, path,
+                                      &local_err));
+        while (new_container->alias) {
+            new_container = new_container->alias;
+        }
+    }
+
+    if (local_err) {
+        error_propagate(errp, local_err);
+        return;
+    }
+
+    object_ref(OBJECT(new_container));
+
+    memory_region_transaction_begin();
+    memory_region_ref(mr);
+    if (old_container) {
+        memory_region_del_subregion(old_container, mr);
+    }
+    mr->container = new_container;
+    if (new_container) {
+        memory_region_update_container_subregions(mr);
+    }
+    memory_region_unref(mr);
+    memory_region_transaction_commit();
+
+    object_unref(OBJECT(old_container));
+}
+

     op = object_property_add(OBJECT(mr), "container",
                              "link<" TYPE_MEMORY_REGION ">",
                              memory_region_get_container,
-                             NULL, /* memory_region_set_container */
+                             memory_region_set_container,
                              NULL, NULL, &error_abort);


The function does the normal link setting - similar to
object_set_link_property (not to be confused with
object_property_set_link!) but is surrounded by class specific side
effects. Specifically in this case, it does
memory_region_transaction_begin/ref/unref/commit etc for the MR.

For this GPIO case, you could create a custom setter that does the
normal set, then calls the DeviceClass installed hook (or you can
install the hook to the object and init it at qdev_init_gpio_out_named
time as suggested in the eariler thread). The callback will happen
after the link is populated.

To reduce verbosity, I suggest making object_set_link_property() a
visible API, then RYO link setters can call it surrounded by custom
behavior e.g:

foo_object_set_bar_property(...)
{
    pre_set_link_side_effects();
    object_set_link_property();
    post_set_link_side_effects();
}

object_set_link_property() would need to be coreified and wrapped to
remove it's awareness of LinkProperty type (as that doesn't exist in
RYO properties) in this case.

Regards,
Peter

> If you have any idea, please help.
>
> Paolo
>
