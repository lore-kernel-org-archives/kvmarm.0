From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [RFC PATCH] KVM: arm/arm64: Enable direct irqfd MSI injection
Date: Sun, 17 Mar 2019 19:05:10 +0100
Message-ID: <f53253f1-aa5e-3731-a1cd-bd14fb0509a8@redhat.com>
References: <1552833373-19828-1-git-send-email-yuzenghui@huawei.com>
 <1552834226.19343.1.camel@amazon.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1552834226.19343.1.camel@amazon.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: "Raslan, KarimAllah" <karahmed@amazon.de>, "marc.zyngier@arm.com" <marc.zyngier@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>, "christoffer.dall@arm.com" <christoffer.dall@arm.com>, "andre.przywara@arm.com" <andre.przywara@arm.com>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "james.morse@arm.com" <james.morse@arm.com>, "mst@redhat.com" <mst@redhat.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "julien.thierry@arm.com" <julien.thierry@arm.com>, "rkrcmar@redhat.com" <rkrcmar@redhat.com>, "wanghaibin.wang@huawei.com" <wanghaibin.wang@huawei.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 3/17/19 3:50 PM, Raslan, KarimAllah wrote:
> On Sun, 2019-03-17 at 14:36 +0000, Zenghui Yu wrote:
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
>>
>> ---
>>  virt/kvm/arm/vgic/trace.h      | 22 ++++++++++++++++++++++
>>  virt/kvm/arm/vgic/vgic-irqfd.c | 21 +++++++++++++++++++++
>>  2 files changed, 43 insertions(+)
>>
>> diff --git a/virt/kvm/arm/vgic/trace.h b/virt/kvm/arm/vgic/trace.h
>> index 55fed77..bc1f4db 100644
>> --- a/virt/kvm/arm/vgic/trace.h
>> +++ b/virt/kvm/arm/vgic/trace.h
>> @@ -27,6 +27,28 @@
>>  		  __entry->vcpu_id, __entry->irq, __entry->level)
>>  );
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
>>  #endif /* _TRACE_VGIC_H */
>>  
>>  #undef TRACE_INCLUDE_PATH
>> diff --git a/virt/kvm/arm/vgic/vgic-irqfd.c b/virt/kvm/arm/vgic/vgic-irqfd.c
>> index 99e026d..4cfc3f4 100644
>> --- a/virt/kvm/arm/vgic/vgic-irqfd.c
>> +++ b/virt/kvm/arm/vgic/vgic-irqfd.c
>> @@ -19,6 +19,7 @@
>>  #include <trace/events/kvm.h>
>>  #include <kvm/arm_vgic.h>
>>  #include "vgic.h"
>> +#include "trace.h"
>>  
>>  /**
>>   * vgic_irqfd_set_irq: inject the IRQ corresponding to the
>> @@ -105,6 +106,26 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>>  	return vgic_its_inject_msi(kvm, &msi);
>>  }
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
> 
> The implementation of kvm_set_msi is not atomic. There is a mutex held in one
> of the execution paths. That is why it can not be used directly in this atomic 
> context.
Yep, vgic_its_trigger_msi call is protected by the its->its_lock.

Thanks

Eric
> 
>> +	return ret;
>> +}
>> +
>>  int kvm_vgic_setup_default_irq_routing(struct kvm *kvm)
>>  {
>>  	struct kvm_irq_routing_entry *entries;
> 
> 
> 
> Amazon Development Center Germany GmbH
> Krausenstr. 38
> 10117 Berlin
> Geschaeftsfuehrer: Christian Schlaeger, Ralf Herbrich
> Ust-ID: DE 289 237 879
> Eingetragen am Amtsgericht Charlottenburg HRB 149173 B
> 
