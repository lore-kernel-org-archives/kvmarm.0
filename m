From: Alex Williamson <alex.williamson@redhat.com>
Subject: Re: [PATCH 4/5] VFIO: platform: populate reset function according
 to compat
Date: Thu, 14 May 2015 09:30:18 -0600
Message-ID: <1431617418.3625.121.camel@redhat.com>
References: <1431008843-28411-1-git-send-email-eric.auger@linaro.org>
		 <1431008843-28411-5-git-send-email-eric.auger@linaro.org>
	 <1431541996.3625.55.camel@redhat.com> <55546374.7000208@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <55546374.7000208@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, christoffer.dall@linaro.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, b.reynal@virtualopensystems.com, linux-kernel@vger.kernel.org, patches@linaro.org, agraf@suse.de, Bharat.Bhushan@freescale.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, 2015-05-14 at 10:57 +0200, Eric Auger wrote:
> On 05/13/2015 08:33 PM, Alex Williamson wrote:
> > On Thu, 2015-05-07 at 16:27 +0200, Eric Auger wrote:
> >> Add the reset function lookup according to the device compat
> >> string. This lookup is added at different places:
> >> - on VFIO_DEVICE_GET_INFO
> >> - on VFIO_DEVICE_RESET
> >> - on device release
> >>
> >> A reference to the module implementing the reset function is taken
> >> on first reset function lookup and released on vfio platform device
> >> release.
> >>
> >> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> >> ---
> >>  drivers/vfio/platform/vfio_platform_common.c | 50 ++++++++++++++++++++++++++++
> >>  1 file changed, 50 insertions(+)
> >>
> >> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
> >> index 0d10018..bd7e44c 100644
> >> --- a/drivers/vfio/platform/vfio_platform_common.c
> >> +++ b/drivers/vfio/platform/vfio_platform_common.c
> >> @@ -28,6 +28,52 @@ LIST_HEAD(reset_list);
> >>  
> >>  static DEFINE_MUTEX(driver_lock);
> >>  
> >> +static vfio_platform_reset_fn_t vfio_platform_lookup_reset(const char *compat)
> >> +{
> >> +	struct vfio_platform_reset_node *iter;
> >> +
> >> +	list_for_each_entry(iter, &reset_list, link) {
> > 
> > Racy
> ok
> > 
> >> +		if (!strcmp(iter->compat, compat) &&
> >> +			try_module_get(iter->owner))
> >> +			return iter->reset;
> >> +	}
> >> +
> >> +	return ERR_PTR(-ENODEV);
> > 
> > return NULL imo
> ok
> > 
> >> +}
> >> +
> >> +static vfio_platform_reset_fn_t vfio_platform_get_reset(
> >> +					struct vfio_platform_device *vdev)
> >> +{
> >> +	struct device *dev = vdev->get_device(vdev);
> >> +	const char *compat_str_array[2];
> >> +	vfio_platform_reset_fn_t reset;
> >> +	int ret;
> >> +
> >> +	if (!IS_ERR_OR_NULL(vdev->reset))
> >> +		return vdev->reset;
> >> +
> >> +	ret = device_property_read_string_array(dev, "compatible",
> >> +						compat_str_array, 2);
> >> +	if (!ret)
> >> +		return ERR_PTR(ret);
> >> +
> >> +	reset = vfio_platform_lookup_reset(compat_str_array[0]);
> >> +	return reset;
> > 
> > Something got allocated into compat_str_array and gets leaked here.
> is there any allocation? device_property_read_string_array does not
> return -ENOMEM.

Yeah, since they're const I guess maybe it's just setting a pointer.  It
troubles me a little bit that nobody else seems to be using this
device_property_read_string_array() interface.
 
> >> +}
> >> +
> >> +static void vfio_platform_put_reset(struct vfio_platform_device *vdev)
> >> +{
> >> +	struct vfio_platform_reset_node *iter;
> >> +
> >> +	list_for_each_entry(iter, &reset_list, link) {
> > 
> > Racy
> ok
> > 
> >> +		if (iter->reset == vdev->reset) {
> >> +			module_put(iter->owner);
> >> +			vdev->reset = NULL;
> >> +			return;
> >> +		}
> >> +	}
> >> +}
> >> +
> >>  static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
> >>  {
> >>  	int cnt = 0, i;
> >> @@ -103,10 +149,12 @@ static void vfio_platform_release(void *device_data)
> >>  	mutex_lock(&driver_lock);
> >>  
> >>  	if (!(--vdev->refcnt)) {
> >> +		vdev->reset = vfio_platform_get_reset(vdev);
> >>  		if (!IS_ERR_OR_NULL(vdev->reset))
> >>  			vdev->reset(vdev);
> >>  		vfio_platform_regions_cleanup(vdev);
> >>  		vfio_platform_irq_cleanup(vdev);
> >> +		vfio_platform_put_reset(vdev);
> >>  	}
> >>  
> >>  	mutex_unlock(&driver_lock);
> >> @@ -164,6 +212,7 @@ static long vfio_platform_ioctl(void *device_data,
> >>  		if (info.argsz < minsz)
> >>  			return -EINVAL;
> >>  
> >> +		vdev->reset = vfio_platform_get_reset(vdev);
> >>  		if (!IS_ERR_OR_NULL(vdev->reset))
> >>  			vdev->flags |= VFIO_DEVICE_FLAGS_RESET;
> >>  		info.flags = vdev->flags;
> >> @@ -260,6 +309,7 @@ static long vfio_platform_ioctl(void *device_data,
> >>  		return ret;
> >>  
> >>  	} else if (cmd == VFIO_DEVICE_RESET) {
> >> +		vdev->reset = vfio_platform_get_reset(vdev);
> >>  		if (!IS_ERR_OR_NULL(vdev->reset))
> >>  			return vdev->reset(vdev);
> >>  		else
> > 
> > I count 3 gets and 1 put, isn't the module reference count increase
> > showing that?
> 
> vfio_platform_get_reset simply returns if the function pointer already
> is populated so there is no systematic ref increment.

Ah, so it does.

> 
>   This looks like it hasn't been tested.
> 
> It did testing with external and in-kernel modules through
>   Why would we do a
> > get every time we want to do a reset?
> 
> My doubt were about the order of probing between the
> vfio-platform_driver and the vfio reset module? This question was the
> rationale of this implementation choice. But again the actual ref count
> increment is devised to be done once on the first entry point (iotcl or
> internal release)

I think we need to enforce the ordering; the reset function should be
set on device open via request_module() and try_module_get() to make
sure it is present and can't go away (or make it all a static part of
vfio-platform).  A user doesn't expect the reset capability advertised
in the vfio device info struct to change over time.  Thanks,

Alex
