From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 1/5] VFIO: platform: add reset_list and
 register/unregister functions
Date: Thu, 14 May 2015 09:42:16 -0600
Message-ID: <1431618136.3625.129.camel@redhat.com>
References: <1431008843-28411-1-git-send-email-eric.auger@linaro.org>
		 <1431008843-28411-2-git-send-email-eric.auger@linaro.org>
	 <1431541925.3625.52.camel@redhat.com> <55545BF4.805@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55545BF4.805@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, b.reynal@virtualopensystems.com, linux-kernel@vger.kernel.org, patches@linaro.org, agraf@suse.de, Bharat.Bhushan@freescale.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 2015-05-14 at 10:25 +0200, Eric Auger wrote:
> Hi Alex,
> On 05/13/2015 08:32 PM, Alex Williamson wrote:
> > On Thu, 2015-05-07 at 16:27 +0200, Eric Auger wrote:
> >> vfio_platform_common now stores a lists of available reset functions.
> >> Two functions are exposed to register/unregister a reset function. A
> >> reset function is paired with a compat string.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> >> ---
> >>  drivers/vfio/platform/vfio_platform_common.c  | 63 +++++++++++++++++++++++++++
> >>  drivers/vfio/platform/vfio_platform_private.h | 13 ++++++
> >>  2 files changed, 76 insertions(+)
> >>
> >> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> >> index abcff7a..edbf24c 100644
> >> --- a/drivers/vfio/platform/vfio_platform_common.c
> >> +++ b/drivers/vfio/platform/vfio_platform_common.c
> >> @@ -23,6 +23,9 @@
> >>  
> >>  #include "vfio_platform_private.h"
> >>  
> >> +struct list_head reset_list;
> >> +LIST_HEAD(reset_list);
> >> +
> > 
> > Redundant?  Static?
> static, yes
> > 
> >>  static DEFINE_MUTEX(driver_lock);
> >>  
> >>  static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
> >> @@ -511,6 +514,13 @@ EXPORT_SYMBOL_GPL(vfio_platform_probe_common);
> >>  struct vfio_platform_device *vfio_platform_remove_common(struct device *dev)
> >>  {
> >>  	struct vfio_platform_device *vdev;
> >> +	struct vfio_platform_reset_node *iter, *tmp;
> >> +
> >> +	list_for_each_entry_safe(iter, tmp, &reset_list, link) {
> >> +		list_del(&iter->link);
> >> +		kfree(iter->compat);
> >> +		kfree(iter);
> >> +	}
> > 
> > 
> > This doesn't make sense.  We allow reset functions to be registered and
> > unregistered, but we forget them all when any device is released?!
> I acknowledge indeed. Can I rely on the reset module exit and associated
> unregister_reset or shall I take this action in the vfio driver itself,
> core?

If we were to load the reset modules via request_module() from
vfio-platform, I think they would stay loaded as long as vfio-platform
is loaded and automatically unload if vfio-platform is unloaded.  Our
reference via try_module_get() for an in-use reset function should
prevent the module from being unloaded while we're dependent on it.  I
think that covers everything we need.  A user is free to rmmod the reset
module, but if it's in use it shouldn't work, and we can request it
again for the next device.  

> >>  
> >>  	vdev = vfio_del_group_dev(dev);
> >>  	if (vdev)
> >> @@ -519,3 +529,56 @@ struct vfio_platform_device *vfio_platform_remove_common(struct device *dev)
> >>  	return vdev;
> >>  }
> >>  EXPORT_SYMBOL_GPL(vfio_platform_remove_common);
> >> +
> >> +int vfio_platform_register_reset(char *compat, struct module *reset_owner,
> >> +				 vfio_platform_reset_fn_t reset)
> >> +{
> >> +	struct vfio_platform_reset_node *node, *iter;
> >> +	bool found = false;
> >> +
> >> +	list_for_each_entry(iter, &reset_list, link) {
> >> +		if (!strcmp(iter->compat, compat)) {
> >> +			found = true;
> > 
> > Just return errno here
> ok
> > 
> >> +			break;
> >> +		}
> >> +	}
> >> +	if (found)
> >> +		return -EINVAL;
> >> +
> >> +	node = kmalloc(sizeof(*node), GFP_KERNEL);
> >> +	if (!node)
> >> +		return -ENOMEM;
> >> +
> >> +	node->compat = kstrdup(compat, GFP_KERNEL);
> >> +	if (!node->compat)
> > 
> > Leaking node
> ok
> > 
> >> +		return -ENOMEM;
> >> +
> >> +	node->owner = reset_owner;
> >> +	node->reset = reset;
> >> +
> >> +	list_add(&node->link, &reset_list);
> > 
> > Isn't this racy?  Don't we need some locks around the list?
> I will add a lock to protect access to the list.
> > 
> >> +	return 0;
> >> +}
> >> +EXPORT_SYMBOL_GPL(vfio_platform_register_reset);
> >> +
> >> +int vfio_platform_unregister_reset(char *compat)
> >> +{
> >> +	struct vfio_platform_reset_node *iter;
> >> +	bool found = false;
> >> +
> >> +	list_for_each_entry(iter, &reset_list, link) {
> >> +		if (!strcmp(iter->compat, compat)) {
> > 
> > Return errno here
> ok
> > 
> >> +			found = true;
> >> +			break;
> >> +		}
> >> +	}
> >> +	if (!found)
> >> +		return -EINVAL;
> >> +
> >> +	list_del(&iter->link);
> > 
> > Racy
> > 
> >> +	kfree(iter->compat);
> >> +	kfree(iter);
> >> +	return 0;
> >> +}
> >> +EXPORT_SYMBOL_GPL(vfio_platform_unregister_reset);
> >> +
> >> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
> >> index 5d31e04..da2d60b 100644
> >> --- a/drivers/vfio/platform/vfio_platform_private.h
> >> +++ b/drivers/vfio/platform/vfio_platform_private.h
> >> @@ -69,6 +69,15 @@ struct vfio_platform_device {
> >>  	int	(*get_irq)(struct vfio_platform_device *vdev, int i);
> >>  };
> >>  
> >> +typedef int (*vfio_platform_reset_fn_t)(struct vfio_platform_device *vdev);
> > 
> > Seems like this ought to be in a non-private header if we're exporting
> > the [un]register functions.
> I considered the vfio reset modules were internal to the vfio subsystem
> but if you prefer I can expose that in vfio.h. I guess
> register/unregister should become an external API then?

The patch descriptions implied that it was intended for external reset
modules, which I took to mean a potentially broader code base.  It's
fine and probably better if we want to only make it an "internal"
interface, though we really have no ability to enforce that once the
functions are exported.

> >> +
> >> +struct vfio_platform_reset_node {
> >> +	struct list_head link;
> >> +	char *compat;
> >> +	struct module *owner;
> >> +	vfio_platform_reset_fn_t reset;
> >> +};
> >> +
> >>  extern int vfio_platform_probe_common(struct vfio_platform_device *vdev,
> >>  				      struct device *dev);
> >>  extern struct vfio_platform_device *vfio_platform_remove_common
> >> @@ -82,4 +91,8 @@ extern int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
> >>  					unsigned start, unsigned count,
> >>  					void *data);
> >>  
> >> +extern int vfio_platform_register_reset(char *compat, struct module *owner,
> >> +					vfio_platform_reset_fn_t reset);
> >> +extern int vfio_platform_unregister_reset(char *compat);
> >> +
> >>  #endif /* VFIO_PLATFORM_PRIVATE_H */
> > 
> > 
> > 
> 
