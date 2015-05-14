From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 1/5] VFIO: platform: add reset_list and register/unregister
 functions
Date: Thu, 14 May 2015 10:25:24 +0200
Message-ID: <55545BF4.805@linaro.org>
References: <1431008843-28411-1-git-send-email-eric.auger@linaro.org>	
 <1431008843-28411-2-git-send-email-eric.auger@linaro.org>
 <1431541925.3625.52.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0896A513C1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 04:16:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HTSPEQFVh6+J for <kvmarm@lists.cs.columbia.edu>;
 Thu, 14 May 2015 04:16:23 -0400 (EDT)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
 [209.85.212.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D43D1513AA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 04:16:22 -0400 (EDT)
Received: by wicmx19 with SMTP id mx19so6626233wic.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 14 May 2015 01:25:29 -0700 (PDT)
In-Reply-To: <1431541925.3625.52.camel@redhat.com>
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

Hi Alex,
On 05/13/2015 08:32 PM, Alex Williamson wrote:
> On Thu, 2015-05-07 at 16:27 +0200, Eric Auger wrote:
>> vfio_platform_common now stores a lists of available reset functions.
>> Two functions are exposed to register/unregister a reset function. A
>> reset function is paired with a compat string.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> ---
>>  drivers/vfio/platform/vfio_platform_common.c  | 63 +++++++++++++++++++++++++++
>>  drivers/vfio/platform/vfio_platform_private.h | 13 ++++++
>>  2 files changed, 76 insertions(+)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
>> index abcff7a..edbf24c 100644
>> --- a/drivers/vfio/platform/vfio_platform_common.c
>> +++ b/drivers/vfio/platform/vfio_platform_common.c
>> @@ -23,6 +23,9 @@
>>  
>>  #include "vfio_platform_private.h"
>>  
>> +struct list_head reset_list;
>> +LIST_HEAD(reset_list);
>> +
> 
> Redundant?  Static?
static, yes
> 
>>  static DEFINE_MUTEX(driver_lock);
>>  
>>  static int vfio_platform_regions_init(struct vfio_platform_device *vdev)
>> @@ -511,6 +514,13 @@ EXPORT_SYMBOL_GPL(vfio_platform_probe_common);
>>  struct vfio_platform_device *vfio_platform_remove_common(struct device *dev)
>>  {
>>  	struct vfio_platform_device *vdev;
>> +	struct vfio_platform_reset_node *iter, *tmp;
>> +
>> +	list_for_each_entry_safe(iter, tmp, &reset_list, link) {
>> +		list_del(&iter->link);
>> +		kfree(iter->compat);
>> +		kfree(iter);
>> +	}
> 
> 
> This doesn't make sense.  We allow reset functions to be registered and
> unregistered, but we forget them all when any device is released?!
I acknowledge indeed. Can I rely on the reset module exit and associated
unregister_reset or shall I take this action in the vfio driver itself,
core?
> 
>>  
>>  	vdev = vfio_del_group_dev(dev);
>>  	if (vdev)
>> @@ -519,3 +529,56 @@ struct vfio_platform_device *vfio_platform_remove_common(struct device *dev)
>>  	return vdev;
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_platform_remove_common);
>> +
>> +int vfio_platform_register_reset(char *compat, struct module *reset_owner,
>> +				 vfio_platform_reset_fn_t reset)
>> +{
>> +	struct vfio_platform_reset_node *node, *iter;
>> +	bool found = false;
>> +
>> +	list_for_each_entry(iter, &reset_list, link) {
>> +		if (!strcmp(iter->compat, compat)) {
>> +			found = true;
> 
> Just return errno here
ok
> 
>> +			break;
>> +		}
>> +	}
>> +	if (found)
>> +		return -EINVAL;
>> +
>> +	node = kmalloc(sizeof(*node), GFP_KERNEL);
>> +	if (!node)
>> +		return -ENOMEM;
>> +
>> +	node->compat = kstrdup(compat, GFP_KERNEL);
>> +	if (!node->compat)
> 
> Leaking node
ok
> 
>> +		return -ENOMEM;
>> +
>> +	node->owner = reset_owner;
>> +	node->reset = reset;
>> +
>> +	list_add(&node->link, &reset_list);
> 
> Isn't this racy?  Don't we need some locks around the list?
I will add a lock to protect access to the list.
> 
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(vfio_platform_register_reset);
>> +
>> +int vfio_platform_unregister_reset(char *compat)
>> +{
>> +	struct vfio_platform_reset_node *iter;
>> +	bool found = false;
>> +
>> +	list_for_each_entry(iter, &reset_list, link) {
>> +		if (!strcmp(iter->compat, compat)) {
> 
> Return errno here
ok
> 
>> +			found = true;
>> +			break;
>> +		}
>> +	}
>> +	if (!found)
>> +		return -EINVAL;
>> +
>> +	list_del(&iter->link);
> 
> Racy
> 
>> +	kfree(iter->compat);
>> +	kfree(iter);
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(vfio_platform_unregister_reset);
>> +
>> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
>> index 5d31e04..da2d60b 100644
>> --- a/drivers/vfio/platform/vfio_platform_private.h
>> +++ b/drivers/vfio/platform/vfio_platform_private.h
>> @@ -69,6 +69,15 @@ struct vfio_platform_device {
>>  	int	(*get_irq)(struct vfio_platform_device *vdev, int i);
>>  };
>>  
>> +typedef int (*vfio_platform_reset_fn_t)(struct vfio_platform_device *vdev);
> 
> Seems like this ought to be in a non-private header if we're exporting
> the [un]register functions.
I considered the vfio reset modules were internal to the vfio subsystem
but if you prefer I can expose that in vfio.h. I guess
register/unregister should become an external API then?

Thanks

Eric
>> +
>> +struct vfio_platform_reset_node {
>> +	struct list_head link;
>> +	char *compat;
>> +	struct module *owner;
>> +	vfio_platform_reset_fn_t reset;
>> +};
>> +
>>  extern int vfio_platform_probe_common(struct vfio_platform_device *vdev,
>>  				      struct device *dev);
>>  extern struct vfio_platform_device *vfio_platform_remove_common
>> @@ -82,4 +91,8 @@ extern int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
>>  					unsigned start, unsigned count,
>>  					void *data);
>>  
>> +extern int vfio_platform_register_reset(char *compat, struct module *owner,
>> +					vfio_platform_reset_fn_t reset);
>> +extern int vfio_platform_unregister_reset(char *compat);
>> +
>>  #endif /* VFIO_PLATFORM_PRIVATE_H */
> 
> 
> 
