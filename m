From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH 1/4] vfio: platform: add capability to register a reset
 function
Date: Tue, 20 Oct 2015 19:48:44 +0200
Message-ID: <56267E7C.2060804@linaro.org>
References: <1445184015-24414-1-git-send-email-eric.auger@linaro.org>
 <1445184015-24414-2-git-send-email-eric.auger@linaro.org>
 <1445283934.4059.810.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445283934.4059.810.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alex Williamson <alex.williamson@redhat.com>
Cc: eric.auger@st.com, b.reynal@virtualopensystems.com, arnd@arndb.de, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, christoffer.dall@linaro.org, linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Alex,
On 10/19/2015 09:45 PM, Alex Williamson wrote:
> On Sun, 2015-10-18 at 18:00 +0200, Eric Auger wrote:
>> In preparation for subsequent changes in reset function lookup,
>> lets introduce a dynamic list of reset combos (compat string,
>> reset module, reset function). The list can be populated/voided with
>> two new functions, vfio_platform_register/unregister_reset. Those are
>> not yet used in this patch.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> ---
>>  drivers/vfio/platform/vfio_platform_common.c  | 55 +++++++++++++++++++++++++++
>>  drivers/vfio/platform/vfio_platform_private.h | 14 +++++++
>>  2 files changed, 69 insertions(+)
>>
>> diff --git a/drivers/vfio/platform/vfio_platform_common.c b/drivers/vfio/platform/vfio_platform_common.c
>> index e43efb5..d36afc9 100644
>> --- a/drivers/vfio/platform/vfio_platform_common.c
>> +++ b/drivers/vfio/platform/vfio_platform_common.c
>> @@ -23,6 +23,8 @@
>>  
>>  #include "vfio_platform_private.h"
>>  
>> +struct list_head reset_list;
> 
> What's the purpose of this one above?
useless indeed
> 
>> +LIST_HEAD(reset_list);
> 
> static
> 
> I think you also need a mutex protecting this list, otherwise nothing
> prevents concurrent list changes and walks.  A rw lock probably fits the
> usage model best, but I don't expect much contention if you just want to
> use a mutex.
yes you're right. I am going to use a standard mutex I think.
> 
>>  static DEFINE_MUTEX(driver_lock);
>>  
>>  static const struct vfio_platform_reset_combo reset_lookup_table[] = {
>> @@ -573,3 +575,56 @@ struct vfio_platform_device *vfio_platform_remove_common(struct device *dev)
>>  	return vdev;
>>  }
>>  EXPORT_SYMBOL_GPL(vfio_platform_remove_common);
>> +
>> +int vfio_platform_register_reset(struct module *reset_owner, char *compat,
> 
> const char *
ok
> 
>> +				 vfio_platform_reset_fn_t reset)
>> +{
>> +	struct vfio_platform_reset_node *node, *iter;
>> +	bool found = false;
>> +
>> +	list_for_each_entry(iter, &reset_list, link) {
>> +		if (!strcmp(iter->compat, compat)) {
>> +			found = true;
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
>> +		return -ENOMEM;
> 
> Leaks node
thanks
> 
>> +
>> +	node->owner = reset_owner;
>> +	node->reset = reset;
>> +
>> +	list_add(&node->link, &reset_list);
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(vfio_platform_register_reset);
>> +
>> +int vfio_platform_unregister_reset(char *compat)
> 
> const char *
ok

Thanks for your quick review!

Best Regards

Eric
> 
>> +{
>> +	struct vfio_platform_reset_node *iter;
>> +	bool found = false;
>> +
>> +	list_for_each_entry(iter, &reset_list, link) {
>> +		if (!strcmp(iter->compat, compat)) {
>> +			found = true;
>> +			break;
>> +		}
>> +	}
>> +	if (!found)
>> +		return -EINVAL;
>> +
>> +	list_del(&iter->link);
>> +	kfree(iter->compat);
>> +	kfree(iter);
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL_GPL(vfio_platform_unregister_reset);
>> +
>> diff --git a/drivers/vfio/platform/vfio_platform_private.h b/drivers/vfio/platform/vfio_platform_private.h
>> index 1c9b3d5..17323f0 100644
>> --- a/drivers/vfio/platform/vfio_platform_private.h
>> +++ b/drivers/vfio/platform/vfio_platform_private.h
>> @@ -76,6 +76,15 @@ struct vfio_platform_reset_combo {
>>  	const char *module_name;
>>  };
>>  
>> +typedef int (*vfio_platform_reset_fn_t)(struct vfio_platform_device *vdev);
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
>> @@ -89,4 +98,9 @@ extern int vfio_platform_set_irqs_ioctl(struct vfio_platform_device *vdev,
>>  					unsigned start, unsigned count,
>>  					void *data);
>>  
>> +extern int vfio_platform_register_reset(struct module *owner,
>> +					char *compat,
>> +					vfio_platform_reset_fn_t reset);
>> +extern int vfio_platform_unregister_reset(char *compat);
>> +
>>  #endif /* VFIO_PLATFORM_PRIVATE_H */
> 
> 
> 
