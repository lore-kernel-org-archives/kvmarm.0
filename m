From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v2 10/15] KVM: arm64: add data structures to model ITS
 interrupt translation
Date: Thu, 27 Aug 2015 16:16:37 +0200
Message-ID: <55DF1BC5.3020100@linaro.org>
References: <1436538111-4294-1-git-send-email-andre.przywara@arm.com> <1436538111-4294-11-git-send-email-andre.przywara@arm.com> <55CCBBBF.1080407@linaro.org> <55DC4E3F.506@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <55DC4E3F.506@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, Pavel Fedin <p.fedin@samsung.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Andre,
On 08/25/2015 01:15 PM, Andre Przywara wrote:
> Hi Eric,
> 
> On 13/08/15 16:46, Eric Auger wrote:
>>
>> On 07/10/2015 04:21 PM, Andre Przywara wrote:
>>> The GICv3 Interrupt Translation Service (ITS) uses tables in memory
>>> to allow a sophisticated interrupt routing. It features device tables,
>>> an interrupt table per device and a table connecting "collections" to
>>> actual CPUs (aka. redistributors in the GICv3 lingo).
>>> Since the interrupt numbers for the LPIs are allocated quite sparsely
>>> and the range can be quite huge (8192 LPIs being the minimum), using
>>> bitmaps or arrays for storing information is a waste of memory.
>>> We use linked lists instead, which we iterate linearily. This works
>>> very well with the actual number of LPIs/MSIs in the guest being
>>> quite low. Should the number of LPIs exceed the number where iterating
>>> through lists seems acceptable, we can later revisit this and use more
>>> efficient data structures.
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> ---
>>>  include/kvm/arm_vgic.h  |  3 +++
>>>  virt/kvm/arm/its-emul.c | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>>>  2 files changed, 51 insertions(+)
>>>
>>> diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
>>> index b432055..1648668 100644
>>> --- a/include/kvm/arm_vgic.h
>>> +++ b/include/kvm/arm_vgic.h
>>> @@ -25,6 +25,7 @@
>>>  #include <linux/spinlock.h>
>>>  #include <linux/types.h>
>>>  #include <kvm/iodev.h>
>>> +#include <linux/list.h>
>>>  
>>>  #define VGIC_NR_IRQS_LEGACY	256
>>>  #define VGIC_NR_SGIS		16
>>> @@ -162,6 +163,8 @@ struct vgic_its {
>>>  	u64			cbaser;
>>>  	int			creadr;
>>>  	int			cwriter;
>>> +	struct list_head	device_list;
>>> +	struct list_head	collection_list;
>>>  };
>>>  
>>>  struct vgic_dist {
>>> diff --git a/virt/kvm/arm/its-emul.c b/virt/kvm/arm/its-emul.c
>>> index b498f06..7f217fa 100644
>>> --- a/virt/kvm/arm/its-emul.c
>>> +++ b/virt/kvm/arm/its-emul.c
>>> @@ -21,6 +21,7 @@
>>>  #include <linux/kvm.h>
>>>  #include <linux/kvm_host.h>
>>>  #include <linux/interrupt.h>
>>> +#include <linux/list.h>
>>>  
>>>  #include <linux/irqchip/arm-gic-v3.h>
>>>  #include <kvm/arm_vgic.h>
>>> @@ -32,6 +33,25 @@
>>>  #include "vgic.h"
>>>  #include "its-emul.h"
>>>  
>>> +struct its_device {
>>> +	struct list_head dev_list;
>>> +	struct list_head itt;
>>> +	u32 device_id;
>>> +};
>>> +
>>> +struct its_collection {
>>> +	struct list_head coll_list;
>>> +	u32 collection_id;
>>> +	u32 target_addr;
>>> +};
>>> +
>>> +struct its_itte {
>>> +	struct list_head itte_list;
>>> +	struct its_collection *collection;
>>> +	u32 lpi;
>>> +	u32 event_id;
>>> +};
>>> +
>>>  #define BASER_BASE_ADDRESS(x) ((x) & 0xfffffffff000ULL)
>>>  
>>>  /* The distributor lock is held by the VGIC MMIO handler. */
>>> @@ -311,6 +331,9 @@ int vits_init(struct kvm *kvm)
>>>  
>>>  	spin_lock_init(&its->lock);
>>>  
>>> +	INIT_LIST_HEAD(&its->device_list);
>>> +	INIT_LIST_HEAD(&its->collection_list);
>>> +
>>>  	its->enabled = false;
>>>  
>>>  	return -ENXIO;
>>> @@ -320,11 +343,36 @@ void vits_destroy(struct kvm *kvm)
>>>  {
>>>  	struct vgic_dist *dist = &kvm->arch.vgic;
>>>  	struct vgic_its *its = &dist->its;
>>> +	struct its_device *dev;
>>> +	struct its_itte *itte;
>>> +	struct list_head *dev_cur, *dev_temp;
>>> +	struct list_head *cur, *temp;
>>>  
>>>  	if (!vgic_has_its(kvm))
>>>  		return;
>>>  
>>> +	if (!its->device_list.next)
>> Why not using list_empty? But I think I would simply remove this since
>> the empty case if handle below...
> 
> list_empty() requires the list to be initialized before. This check here
> is to detect that map_resources was never called (this is only done on
> the first VCPU run) and thus device_list is basically still all zeroes.
> If we abort the guest without ever running a VCPU (for instance because
> some initialization failed), we call vits_destroy() anyway (because this
> is called when tearing down the VGIC device).
> So the check is here to detect early that vits_destroy() has been called
> without the ITS ever been fully initialized. This fixed a real bug when
> the guest start was aborted before the ITS was ever used.
> I will add a comment to make this clear.

OK. My next question is why don't we call vits_init in vgic_init after
dist->nr_cpus? I had in mind map_resources was linked to the setting of
vgic_dist_base & vgic_cpu_base. Here you do not depend on those
addresses? Do I miss smthg?
> 
>>> +		return;
>>> +
>>> +	spin_lock(&its->lock);
>>> +	list_for_each_safe(dev_cur, dev_temp, &its->device_list) {
>>> +		dev = container_of(dev_cur, struct its_device, dev_list);
>> isn't the usage of list_for_each_entry_safe more synthetic here?
Sorry my point was about the _ENTRY_ variant that should avoid to use
container_of, isn't it?

Eric
> 
> If I got this correctly, we need the _safe variant if we want to remove
> the list item within the loop. Or am I missing something here?
> 
> Cheers,
> Andre.
> 
> 
>>> +		list_for_each_safe(cur, temp, &dev->itt) {
>>> +			itte = (container_of(cur, struct its_itte, itte_list));
>> same
>>
>> Eric
>>> +			list_del(cur);
>>> +			kfree(itte);
>>> +		}
>>> +		list_del(dev_cur);
>>> +		kfree(dev);
>>> +	}
>>> +
>>> +	list_for_each_safe(cur, temp, &its->collection_list) {
>>> +		list_del(cur);
>>> +		kfree(container_of(cur, struct its_collection, coll_list));
>>> +	}
>>> +
>>>  	kfree(dist->pendbaser);
>>>  
>>>  	its->enabled = false;
>>> +	spin_unlock(&its->lock);
>>>  }
>>>
>>

