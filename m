From: Zenghui Yu <yuzenghui@huawei.com>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Enable direct irqfd MSI injection
Date: Tue, 19 Mar 2019 09:09:43 +0800
Message-ID: <428b2aac-5a0f-e9da-8d74-8045f99a8c74@huawei.com>
References: <1552833373-19828-1-git-send-email-yuzenghui@huawei.com>
 <86o969z42z.wl-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <86o969z42z.wl-marc.zyngier@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, eric.auger@redhat.com, "Raslan, KarimAllah" <karahmed@amazon.de>
Cc: christoffer.dall@arm.com, andre.przywara@arm.com, james.morse@arm.com, julien.thierry@arm.com, suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu, mst@redhat.com, pbonzini@redhat.com, rkrcmar@redhat.com, kvm@vger.kernel.org, wanghaibin.wang@huawei.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, guoheyi@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi all,

On 2019/3/18 3:35, Marc Zyngier wrote:
> On Sun, 17 Mar 2019 14:36:13 +0000,
> Zenghui Yu <yuzenghui@huawei.com> wrote:
>>
>> Currently, IRQFD on arm still uses the deferred workqueue mechanism
>> to inject interrupts into guest, which will likely lead to a busy
>> context-switching from/to the kworker thread. This overhead is for
>> no purpose (only in my view ...) and will result in an interrupt
>> performance degradation.
>>
>> Implement kvm_arch_set_irq_inatomic() for arm/arm64 to support direct
>> irqfd MSI injection, by which we can get rid of the annoying latency.
>> As a result, irqfd MSI intensive scenarios (e.g., DPDK with high packet
>> processing workloads) will benefit from it.
>>
>> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
>> ---
>>
>> It seems that only MSI will follow the IRQFD path, did I miss something?
>>
>> This patch is still under test and sent out for early feedback. If I have
>> any mis-understanding, please fix me up and let me know. Thanks!
> 
> As mentioned by other folks in the thread, this is clearly wrong. The
> first thing kvm_inject_msi does is to lock the corresponding ITS using
> a mutex. So the "no purpose" bit was a bit too quick.
> 
> When doing this kind of work, I suggest you enable lockdep and all the
> related checkers. Also, for any optimisation, please post actual
> numbers for the relevant benchmarks. Saying "application X will
> benefit from it" is meaningless without any actual data.
> 
>>
>> ---
>>   virt/kvm/arm/vgic/trace.h      | 22 ++++++++++++++++++++++
>>   virt/kvm/arm/vgic/vgic-irqfd.c | 21 +++++++++++++++++++++
>>   2 files changed, 43 insertions(+)
>>
>> diff --git a/virt/kvm/arm/vgic/trace.h b/virt/kvm/arm/vgic/trace.h
>> index 55fed77..bc1f4db 100644
>> --- a/virt/kvm/arm/vgic/trace.h
>> +++ b/virt/kvm/arm/vgic/trace.h
>> @@ -27,6 +27,28 @@
>>   		  __entry->vcpu_id, __entry->irq, __entry->level)
>>   );
>>   
>> +TRACE_EVENT(kvm_arch_set_irq_inatomic,
>> +	TP_PROTO(u32 gsi, u32 type, int level, int irq_source_id),
>> +	TP_ARGS(gsi, type, level, irq_source_id),
>> +
>> +	TP_STRUCT__entry(
>> +		__field(	u32,	gsi		)
>> +		__field(	u32,	type		)
>> +		__field(	int,	level		)
>> +		__field(	int,	irq_source_id	)
>> +	),
>> +
>> +	TP_fast_assign(
>> +		__entry->gsi		= gsi;
>> +		__entry->type		= type;
>> +		__entry->level		= level;
>> +		__entry->irq_source_id	= irq_source_id;
>> +	),
>> +
>> +	TP_printk("gsi %u type %u level %d source %d", __entry->gsi,
>> +		  __entry->type, __entry->level, __entry->irq_source_id)
>> +);
>> +
>>   #endif /* _TRACE_VGIC_H */
>>   
>>   #undef TRACE_INCLUDE_PATH
>> diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
>> index 99e026d..4cfc3f4 100644
>> --- a/virt/kvm/arm/vgic/vgic-irqfd.c
>> +++ b/virt/kvm/arm/vgic/vgic-irqfd.c
>> @@ -19,6 +19,7 @@
>>   #include <trace/events/kvm.h>
>>   #include <kvm/arm_vgic.h>
>>   #include "vgic.h"
>> +#include "trace.h"
>>   
>>   /**
>>    * vgic_irqfd_set_irq: inject the IRQ corresponding to the
>> @@ -105,6 +106,26 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>>   	return vgic_its_inject_msi(kvm, &msi);
>>   }
>>   
>> +/**
>> + * kvm_arch_set_irq_inatomic: fast-path for irqfd injection
>> + *
>> + * Currently only direct MSI injecton is supported.
>> + */
>> +int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
>> +			      struct kvm *kvm, int irq_source_id, int level,
>> +			      bool line_status)
>> +{
>> +	int ret;
>> +
>> +	trace_kvm_arch_set_irq_inatomic(e->gsi, e->type, level, irq_source_id);
>> +
>> +	if (unlikely(e->type != KVM_IRQ_ROUTING_MSI))
>> +		return -EWOULDBLOCK;
>> +
>> +	ret = kvm_set_msi(e, kvm, irq_source_id, level, line_status);
>> +	return ret;
>> +}
>> +
> 
> Although we've established that the approach is wrong, maybe we can
> look at improving this aspect.
> 
> A first approach would be to keep a small cache of the last few
> successful translations for this ITS, cache that could be looked-up by
> holding a spinlock instead. A hit in this cache could directly be
> injected. Any command that invalidates or changes anything (DISCARD,
> INV, INVALL, MAPC with V=0, MAPD with V=0, MOVALL, MOVI) should nuke
> the cache altogether.
> 
> Of course, all of that needs to be quantified.

Thanks for all of your explanations, especially for Marc's suggestions!
It took me long time to figure out my mistakes, since I am not very
familiar with the locking stuff. Now I have to apologize for my noise.

As for the its-translation-cache code (a really good news to us), we
have a rough look at it and start testing now!


thanks,

zenghui

> 
> Thanks,
> 
> 	M.
> 
