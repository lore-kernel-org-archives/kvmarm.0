From: Eric Auger <eric.auger@linaro.org>
Subject: Re: [PATCH v9 5/5] KVM: arm/arm64: add irqfd support
Date: Thu, 05 Mar 2015 15:04:09 +0100
Message-ID: <54F86259.20704@linaro.org>
References: <1425464076-20558-1-git-send-email-eric.auger@linaro.org> <1425464076-20558-6-git-send-email-eric.auger@linaro.org> <54F8359A.4020405@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <54F8359A.4020405@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, "eric.auger@st.com" <eric.auger@st.com>, "christoffer.dall@linaro.org" <christoffer.dall@linaro.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Cc: Andre Przywara <Andre.Przywara@arm.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>, "gleb@kernel.org" <gleb@kernel.org>, "pbonzini@redhat.com" <pbonzini@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,
On 03/05/2015 11:53 AM, Marc Zyngier wrote:
> On 04/03/15 10:14, Eric Auger wrote:
>> This patch enables irqfd on arm/arm64.
>>
>> Both irqfd and resamplefd are supported. Injection is implemented
>> in vgic.c without routing.
>>
>> This patch enables CONFIG_HAVE_KVM_EVENTFD and CONFIG_HAVE_KVM_IRQFD.
>>
>> KVM_CAP_IRQFD is now advertised. KVM_CAP_IRQFD_RESAMPLE capability
>> automatically is advertised as soon as CONFIG_HAVE_KVM_IRQFD is set.
>>
>> Irqfd injection is restricted to SPI. The rationale behind not
>> supporting PPI irqfd injection is that any device using a PPI would
>> be a private-to-the-CPU device (timer for instance), so its state
>> would have to be context-switched along with the VCPU and would
>> require in-kernel wiring anyhow. It is not a relevant use case for
>> irqfds.
>>
>> Signed-off-by: Eric Auger <eric.auger@linaro.org>
>> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
>>
>> ---
>> v8 -> v9:
>> - replace kvm_debug by trace_kvm_set_irq and add
>>   BUG_ON(!vgic_initialized(kvm));
>>
>> v7 -> v8:
>> - remove kvm_irq_has_notifier call
>> - part of dist locking changes now are part of previous patch file
>> - remove gic_initialized() check in kvm_set_irq
>> - remove Christoffer's Reviewed-by after this change
>>
>> v5 -> v6:
>> - KVM_CAP_IRQFD support depends on vgic_present
>> - add Christoffer's Reviewed-by
>>
>> v4 -> v5:
>> - squash [PATCH v4 3/3] KVM: arm64: add irqfd support into this patch
>> - some rewording in Documentation/virtual/kvm/api.txt and in vgic
>>   vgic_process_maintenance unlock comment.
>> - move explanation of why not supporting PPI into commit message
>> - in case of injection before gic readiness, -ENODEV is returned. It is
>>   up to the user space to avoid this situation.
>>
>> v3 -> v4:
>> - reword commit message
>> - explain why we unlock the distributor before calling kvm_notify_acked_irq
>> - rename is_assigned_irq into has_notifier
>> - change EOI and injection kvm_debug format string
>> - remove error local variable in kvm_set_irq
>> - Move HAVE_KVM_IRQCHIP unset in a separate patch
>> - handle case were the irqfd injection is attempted before the vgic is ready.
>>   in such a case the notifier, if any, is called immediatly
>> - use nr_irqs to test spi is within correct range
>>
>> v2 -> v3:
>> - removal of irq.h from eventfd.c put in a separate patch to increase
>>   visibility
>> - properly expose KVM_CAP_IRQFD capability in arm.c
>> - remove CONFIG_HAVE_KVM_IRQCHIP meaningfull only if irq_comm.c is used
>>
>> v1 -> v2:
>> - rebase on 3.17rc1
>> - move of the dist unlock in process_maintenance
>> - remove of dist lock in __kvm_vgic_sync_hwstate
>> - rewording of the commit message (add resamplefd reference)
>> - remove irq.h
>>
>> Conflicts:
>> 	arch/arm64/kvm/Kconfig
>> ---
>>  Documentation/virtual/kvm/api.txt |  6 ++++-
>>  arch/arm/include/uapi/asm/kvm.h   |  3 +++
>>  arch/arm/kvm/Kconfig              |  2 ++
>>  arch/arm/kvm/Makefile             |  2 +-
>>  arch/arm/kvm/arm.c                |  5 ++++
>>  arch/arm64/include/uapi/asm/kvm.h |  3 +++
>>  arch/arm64/kvm/Kconfig            |  2 ++
>>  arch/arm64/kvm/Makefile           |  2 +-
>>  virt/kvm/arm/vgic.c               | 48 +++++++++++++++++++++++++++++++++++++++
>>  9 files changed, 70 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index b112efc..b265d8e 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -2234,7 +2234,7 @@ into the hash PTE second double word).
>>  4.75 KVM_IRQFD
>>  
>>  Capability: KVM_CAP_IRQFD
>> -Architectures: x86 s390
>> +Architectures: x86 s390 arm arm64
>>  Type: vm ioctl
>>  Parameters: struct kvm_irqfd (in)
>>  Returns: 0 on success, -1 on error
>> @@ -2260,6 +2260,10 @@ Note that closing the resamplefd is not sufficient to disable the
>>  irqfd.  The KVM_IRQFD_FLAG_RESAMPLE is only necessary on assignment
>>  and need not be specified with KVM_IRQFD_FLAG_DEASSIGN.
>>  
>> +On ARM/ARM64, the gsi field in the kvm_irqfd struct specifies the Shared
>> +Peripheral Interrupt (SPI) index, such that the GIC interrupt ID is
>> +given by gsi + 32.
>> +
>>  4.76 KVM_PPC_ALLOCATE_HTAB
>>  
>>  Capability: KVM_CAP_PPC_ALLOC_HTAB
>> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
>> index 0db25bc..2499867 100644
>> --- a/arch/arm/include/uapi/asm/kvm.h
>> +++ b/arch/arm/include/uapi/asm/kvm.h
>> @@ -198,6 +198,9 @@ struct kvm_arch_memory_slot {
>>  /* Highest supported SPI, from VGIC_NR_IRQS */
>>  #define KVM_ARM_IRQ_GIC_MAX		127
>>  
>> +/* One single KVM irqchip, ie. the VGIC */
>> +#define KVM_NR_IRQCHIPS          1
>> +
>>  /* PSCI interface */
>>  #define KVM_PSCI_FN_BASE		0x95c1ba5e
>>  #define KVM_PSCI_FN(n)			(KVM_PSCI_FN_BASE + (n))
>> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
>> index aae5242..d735a3e 100644
>> --- a/arch/arm/kvm/Kconfig
>> +++ b/arch/arm/kvm/Kconfig
>> @@ -27,6 +27,7 @@ config KVM
>>  	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>>  	select SRCU
>>  	depends on ARM_VIRT_EXT && ARM_LPAE
>> +	select HAVE_KVM_EVENTFD
>>  	---help---
>>  	  Support hosting virtualized guest machines. You will also
>>  	  need to select one or more of the processor modules below.
>> @@ -58,6 +59,7 @@ config KVM_ARM_MAX_VCPUS
>>  config KVM_ARM_VGIC
>>  	bool "KVM support for Virtual GIC"
>>  	depends on KVM_ARM_HOST && OF
>> +	select HAVE_KVM_IRQFD
>>  	default y
>>  	---help---
>>  	  Adds support for a hardware assisted, in-kernel GIC emulation.
>> diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
>> index 443b8be..539c1a5 100644
>> --- a/arch/arm/kvm/Makefile
>> +++ b/arch/arm/kvm/Makefile
>> @@ -15,7 +15,7 @@ AFLAGS_init.o := -Wa,-march=armv7-a$(plus_virt)
>>  AFLAGS_interrupts.o := -Wa,-march=armv7-a$(plus_virt)
>>  
>>  KVM := ../../../virt/kvm
>> -kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
>> +kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o
>>  
>>  obj-y += kvm-arm.o init.o interrupts.o
>>  obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
>> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
>> index 5300d5a..4313776 100644
>> --- a/arch/arm/kvm/arm.c
>> +++ b/arch/arm/kvm/arm.c
>> @@ -175,6 +175,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>  	case KVM_CAP_IRQCHIP:
>>  		r = vgic_present;
>>  		break;
>> +#ifdef CONFIG_HAVE_KVM_IRQFD
>> +	case KVM_CAP_IRQFD:
>> +		r = vgic_present;
>> +		break;
>> +#endif
> 
> Nitpick: we have "select HAVE_KVM_IRQFD", so we can lose the #ifdef-ery.
right. Also I think the vgic_present can be removed since
CONFIG_HAVE_KVM_IRQFD always is set when CONFIG_KVM_ARM_VGIC is set.
So overall this indeed can simply be replaced by Paolo's patch.
> 
>>  	case KVM_CAP_DEVICE_CTRL:
>>  	case KVM_CAP_USER_MEMORY:
>>  	case KVM_CAP_SYNC_MMU:
>> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
>> index 3ef77a4..c154c0b 100644
>> --- a/arch/arm64/include/uapi/asm/kvm.h
>> +++ b/arch/arm64/include/uapi/asm/kvm.h
>> @@ -191,6 +191,9 @@ struct kvm_arch_memory_slot {
>>  /* Highest supported SPI, from VGIC_NR_IRQS */
>>  #define KVM_ARM_IRQ_GIC_MAX		127
>>  
>> +/* One single KVM irqchip, ie. the VGIC */
>> +#define KVM_NR_IRQCHIPS          1
>> +
>>  /* PSCI interface */
>>  #define KVM_PSCI_FN_BASE		0x95c1ba5e
>>  #define KVM_PSCI_FN(n)			(KVM_PSCI_FN_BASE + (n))
>> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
>> index 039d8cf..143c9fd 100644
>> --- a/arch/arm64/kvm/Kconfig
>> +++ b/arch/arm64/kvm/Kconfig
>> @@ -29,6 +29,7 @@ config KVM
>>  	select KVM_ARM_TIMER
>>  	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>>  	select SRCU
>> +	select HAVE_KVM_EVENTFD
>>  	---help---
>>  	  Support hosting virtualized guest machines.
>>  
>> @@ -53,6 +54,7 @@ config KVM_ARM_MAX_VCPUS
>>  config KVM_ARM_VGIC
>>  	bool
>>  	depends on KVM_ARM_HOST && OF
>> +	select HAVE_KVM_IRQFD
> 
> Hmmm. There is way too many selects here. Can't we just select it with
> CONFIG_KVM_ARM_VGIC, and be done with it?

I did that way since CONFIG_KVM_ARM_VGIC is not selected in the config
KVM section on 32b. Currently the IRQFD select location is same for arm
and arm64.

do you prefer I select HAVE_KVM_IRQFD in the config KVM section, ie. at
the same place we select CONFIG_KVM_ARM_VGIC?


> 
>>  	---help---
>>  	  Adds support for a hardware assisted, in-kernel GIC emulation.
>>  
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index 4e6e09e..0dffb5f 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -11,7 +11,7 @@ ARM=../../../arch/arm/kvm
>>  
>>  obj-$(CONFIG_KVM_ARM_HOST) += kvm.o
>>  
>> -kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
>> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/arm.o $(ARM)/mmu.o $(ARM)/mmio.o
>>  kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/psci.o $(ARM)/perf.o
>>  
>> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
>> index 4e9b6d3..2dfb299 100644
>> --- a/virt/kvm/arm/vgic.c
>> +++ b/virt/kvm/arm/vgic.c
>> @@ -31,6 +31,7 @@
>>  #include <asm/kvm_emulate.h>
>>  #include <asm/kvm_arm.h>
>>  #include <asm/kvm_mmu.h>
>> +#include <trace/events/kvm.h>
>>  
>>  /*
>>   * How the whole thing works (courtesy of Christoffer Dall):
>> @@ -1083,6 +1084,7 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>>  	u32 status = vgic_get_interrupt_status(vcpu);
>>  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>>  	bool level_pending = false;
>> +	struct kvm *kvm = vcpu->kvm;
>>  
>>  	kvm_debug("STATUS = %08x\n", status);
>>  
>> @@ -1118,6 +1120,17 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>>  			 */
>>  			vgic_dist_irq_clear_soft_pend(vcpu, vlr.irq);
>>  
>> +			/*
>> +			 * kvm_notify_acked_irq calls kvm_set_irq()
>> +			 * to reset the IRQ level. Need to release the
>> +			 * lock for kvm_set_irq to grab it.
>> +			 */
>> +			spin_unlock(&dist->lock);
>> +
>> +			kvm_notify_acked_irq(kvm, 0,
>> +					     vlr.irq - VGIC_NR_PRIVATE_IRQS);
>> +			spin_lock(&dist->lock);
>> +
> 
> I tried hard to break that one, and failed. It must be correct! ;-)
Knock on wood!

Do I need to post a v10 based on Paolo's patch?

Thanks

Eric
> 
>>  			/* Any additional pending interrupt? */
>>  			if (vgic_dist_irq_get_level(vcpu, vlr.irq)) {
>>  				vgic_cpu_irq_set(vcpu, vlr.irq);
>> @@ -1911,3 +1924,38 @@ out_free_irq:
>>  	free_percpu_irq(vgic->maint_irq, kvm_get_running_vcpus());
>>  	return ret;
>>  }
>> +
>> +int kvm_irq_map_gsi(struct kvm *kvm,
>> +		    struct kvm_kernel_irq_routing_entry *entries,
>> +		    int gsi)
>> +{
>> +	return gsi;
>> +}
>> +
>> +int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
>> +{
>> +	return pin;
>> +}
>> +
>> +int kvm_set_irq(struct kvm *kvm, int irq_source_id,
>> +		u32 irq, int level, bool line_status)
>> +{
>> +	unsigned int spi = irq + VGIC_NR_PRIVATE_IRQS;
>> +
>> +	trace_kvm_set_irq(irq, level, irq_source_id);
>> +
>> +	BUG_ON(!vgic_initialized(kvm));
>> +
>> +	if (spi > kvm->arch.vgic.nr_irqs)
>> +		return -EINVAL;
>> +	return kvm_vgic_inject_irq(kvm, 0, spi, level);
>> +
>> +}
>> +
>> +/* MSI not implemented yet */
>> +int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
>> +		struct kvm *kvm, int irq_source_id,
>> +		int level, bool line_status)
>> +{
>> +	return 0;
>> +}
>>
> 
> Despite from the nits mentionned before, this looks good, and I think we
> should merge it in 4.1 (or whatever this is called).
> 
> So for the whole series:
> 
> Acked-by: Marc Zyngier <marc.zyngier@arm.com>
> 
> 	M.
> 

