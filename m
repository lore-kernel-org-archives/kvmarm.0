From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 4/5] VFIO: platform: populate reset function according
 to compat
Date: Thu, 14 May 2015 10:57:24 +0200
Message-ID: <55546374.7000208@linaro.org>
References: <1431008843-28411-1-git-send-email-eric.auger@linaro.org>	
 <1431008843-28411-5-git-send-email-eric.auger@linaro.org>
 <1431541996.3625.55.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 887775140F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 04:48:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id qfWVoOKvmbkj for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2015 04:48:21 -0400 (EDT)
Received: from mail-wg0-f43.google.com (mail-wg0-f43.google.com [74.125.82.43])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6D1165140A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 04:48:21 -0400 (EDT)
Received: by wguv19 with SMTP id v19so5998023wgu.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 01:57:28 -0700 (PDT)
In-Reply-To: <1431541996.3625.55.camel@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Alex Williamson <alex.williamson@redhat.com>
Cc: kvm@vger.kernel.org, patches@linaro.org, linux-kernel@vger.kernel.org, eric.auger@st.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 05/13/2015 08:33 PM, Alex Williamson wrote:
> On Thu, 2015-05-07 at 16:27 +0200, Eric Auger wrote:
>> Add the reset function lookup according to the device compat
>> string. This lookup is added at different places:
>> - on VFIO_DEVICE_GET_INFO
>> - on VFIO_DEVICE_RESET
>> - on device release
>>
>> A reference to the module implementing the reset function is taken
>> on first reset function lookup and released on vfio platform device
>> release.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> ---
>>  drivers/vfio/platform/vfio_platform_common.c | 50 ++++++++++++++++++++++++++++
>>  1 file changed, 50 insertions(+)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
>> index 0d10018..bd7e44c 100644
>> --- a/drivers/vfio/platform/vfio_platform_common.c
>> +++ b/drivers/vfio/platform/vfio_platform_common.c
>> @@ -28,6 +28,52 @@ LIST_HEAD(reset_list);
>>  
>>  static DEFINE_MUTEX(driver_lock);
>>  
>> +static vfio_platform_reset_fn_t vfio_platform_lookup_reset(const char *compat)
>> +{
>> +	struct vfio_platform_reset_node *iter;
>> +
>> +	list_for_each_entry(iter, &reset_list, link) {
> 
> Racy
ok
> 
>> +		if (!strcmp(iter->compat, compat) &&
>> +			try_module_get(iter->owner))
>> +			return iter->reset;
>> +	}
>> +
>> +	return ERR_PTR(-ENODEV);
> 
> return NULL imo
ok
> 
>> +}
>> +
>> +static vfio_platform_reset_fn_t vfio_platform_get_reset(
>> +					struct vfio_platform_device *vdev)
>> +{
>> +	struct device *dev = vdev->get_device(vdev);
>> +	const char *compat_str_array[2];
>> +	vfio_platform_reset_fn_t reset;
>> +	int ret;
>> +
>> +	if (!IS_ERR_OR_NULL(vdev->reset))
>> +		return vdev->reset;
>> +
>> +	ret = device_property_read_string_array(dev, "compatible",
>> +						compat_str_array, 2);
>> +	if (!ret)
>> +		return ERR_PTR(ret);
>> +
>> +	reset = vfio_platform_lookup_reset(compat_str_array[0]);
>> +	return reset;
> 
> Something got allocated into compat_str_array and gets leaked here.
is there any allocation? device_property_read_string_array does not
return -ENOMEM.

> 
>> +}
>> +
>> +static void vfio_platform_put_reset(struct vfio_platform_device *vdev)
>> +{
>> +	struct vfio_platform_reset_node *iter;
>> +
>> +	list_for_each_entry(iter, &reset_list, link) {
> 
> Racy
ok
> 
>> +		if (iter->reset == vdev->reset) {
>> +			module_put(iter->owner);
>> +			vdev->reset = NULL;
>> +			return;
>> +		}
>> +	}
>> +}
>> +
>>  static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
>>  {
>>  	int cnt = 0, i;
>> @@ -103,10 +149,12 @@ static void vfio_platform_release(void *device_data)
>>  	mutex_lock(&driver_lock);
>>  
>>  	if (!(--vdev->refcnt)) {
>> +		vdev->reset = vfio_platform_get_reset(vdev);
>>  		if (!IS_ERR_OR_NULL(vdev->reset))
>>  			vdev->reset(vdev);
>>  		vfio_platform_regions_cleanup(vdev);
>>  		vfio_platform_irq_cleanup(vdev);
>> +		vfio_platform_put_reset(vdev);
>>  	}
>>  
>>  	mutex_unlock(&driver_lock);
>> @@ -164,6 +212,7 @@ static long vfio_platform_ioctl(void *device_data,
>>  		if (info.argsz < minsz)
>>  			return -EINVAL;
>>  
>> +		vdev->reset = vfio_platform_get_reset(vdev);
>>  		if (!IS_ERR_OR_NULL(vdev->reset))
>>  			vdev->flags |= VFIO_DEVICE_FLAGS_RESET;
>>  		info.flags = vdev->flags;
>> @@ -260,6 +309,7 @@ static long vfio_platform_ioctl(void *device_data,
>>  		return ret;
>>  
>>  	} else if (cmd == VFIO_DEVICE_RESET) {
>> +		vdev->reset = vfio_platform_get_reset(vdev);
>>  		if (!IS_ERR_OR_NULL(vdev->reset))
>>  			return vdev->reset(vdev);
>>  		else
> 
> I count 3 gets and 1 put, isn't the module reference count increase
> showing that?

vfio_platform_get_reset simply returns if the function pointer already
is populated so there is no systematic ref increment.

  This looks like it hasn't been tested.

It did testing with external and in-kernel modules through
  Why would we do a
> get every time we want to do a reset?

My doubt were about the order of probing between the
vfio-platform_driver and the vfio reset module? This question was the
rationale of this implementation choice. But again the actual ref count
increment is devised to be done once on the first entry point (iotcl or
internal release)

  Do one get when the device is
> registered or opened and one put when the device is unregistered or
> closed.  We don't want erratic userspace behavior that the reset
> property of a device can come and go.

> 
