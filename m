From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v8 5/5] KVM: arm/arm64: add irqfd support
Date: Mon, 23 Feb 2015 22:45:55 +0100
Message-ID: <20150223214555.GF5609@cbox>
References: <1421685793-3547-1-git-send-email-eric.auger@linaro.org>
 <1421685793-3547-6-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C7E1466F8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Feb 2015 16:39:56 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Vxacu1VdCcms for <kvmarm@lists.cs.columbia.edu>;
 Mon, 23 Feb 2015 16:39:50 -0500 (EST)
Received: from mail-la0-f53.google.com (mail-la0-f53.google.com
 [209.85.215.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4B9F46671
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Feb 2015 16:39:49 -0500 (EST)
Received: by lams18 with SMTP id s18so21735943lam.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 23 Feb 2015 13:45:28 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1421685793-3547-6-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@linaro.org>
Cc: eric.auger@st.com, kvm@vger.kernel.org, patches@linaro.org, marc.zyngier@arm.com, andre.przywara@arm.com, linux-kernel@vger.kernel.org, gleb@kernel.org, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 19, 2015 at 05:43:13PM +0100, Eric Auger wrote:
> This patch enables irqfd on arm/arm64.
> 
> Both irqfd and resamplefd are supported. Injection is implemented
> in vgic.c without routing.
> 
> This patch enables CONFIG_HAVE_KVM_EVENTFD and CONFIG_HAVE_KVM_IRQFD.
> 
> KVM_CAP_IRQFD is now advertised. KVM_CAP_IRQFD_RESAMPLE capability
> automatically is advertised as soon as CONFIG_HAVE_KVM_IRQFD is set.
> 
> Irqfd injection is restricted to SPI. The rationale behind not
> supporting PPI irqfd injection is that any device using a PPI would
> be a private-to-the-CPU device (timer for instance), so its state
> would have to be context-switched along with the VCPU and would
> require in-kernel wiring anyhow. It is not a relevant use case for
> irqfds.
> 
> Signed-off-by: Eric Auger <eric.auger@linaro.org>
> 
> ---
> v7 -> v8:
> - remove kvm_irq_has_notifier call
> - part of dist locking changes now are part of previous patch file
> - remove gic_initialized() check in kvm_set_irq
> - remove Christoffer's Reviewed-by after this change
> 
> v5 -> v6:
> - KVM_CAP_IRQFD support depends on vgic_present
> - add Christoffer's Reviewed-by
> 
> v4 -> v5:
> - squash [PATCH v4 3/3] KVM: arm64: add irqfd support into this patch
> - some rewording in Documentation/virtual/kvm/api.txt and in vgic
>   vgic_process_maintenance unlock comment.
> - move explanation of why not supporting PPI into commit message
> - in case of injection before gic readiness, -ENODEV is returned. It is
>   up to the user space to avoid this situation.
> 
> v3 -> v4:
> - reword commit message
> - explain why we unlock the distributor before calling kvm_notify_acked_irq
> - rename is_assigned_irq into has_notifier
> - change EOI and injection kvm_debug format string
> - remove error local variable in kvm_set_irq
> - Move HAVE_KVM_IRQCHIP unset in a separate patch
> - handle case were the irqfd injection is attempted before the vgic is ready.
>   in such a case the notifier, if any, is called immediatly
> - use nr_irqs to test spi is within correct range
> 
> v2 -> v3:
> - removal of irq.h from eventfd.c put in a separate patch to increase
>   visibility
> - properly expose KVM_CAP_IRQFD capability in arm.c
> - remove CONFIG_HAVE_KVM_IRQCHIP meaningfull only if irq_comm.c is used
> 
> v1 -> v2:
> - rebase on 3.17rc1
> - move of the dist unlock in process_maintenance
> - remove of dist lock in __kvm_vgic_sync_hwstate
> - rewording of the commit message (add resamplefd reference)
> - remove irq.h
> ---
>  Documentation/virtual/kvm/api.txt |  6 +++++-
>  arch/arm/include/uapi/asm/kvm.h   |  3 +++
>  arch/arm/kvm/Kconfig              |  2 ++
>  arch/arm/kvm/Makefile             |  2 +-
>  arch/arm/kvm/arm.c                |  5 +++++
>  arch/arm64/include/uapi/asm/kvm.h |  3 +++
>  arch/arm64/kvm/Kconfig            |  2 ++
>  arch/arm64/kvm/Makefile           |  2 +-
>  virt/kvm/arm/vgic.c               | 45 +++++++++++++++++++++++++++++++++++++++
>  9 files changed, 67 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
> index 0007fef..5ed8088 100644
> --- a/Documentation/virtual/kvm/api.txt
> +++ b/Documentation/virtual/kvm/api.txt
> @@ -2231,7 +2231,7 @@ into the hash PTE second double word).
>  4.75 KVM_IRQFD
>  
>  Capability: KVM_CAP_IRQFD
> -Architectures: x86 s390
> +Architectures: x86 s390 arm arm64
>  Type: vm ioctl
>  Parameters: struct kvm_irqfd (in)
>  Returns: 0 on success, -1 on error
> @@ -2257,6 +2257,10 @@ Note that closing the resamplefd is not sufficient to disable the
>  irqfd.  The KVM_IRQFD_FLAG_RESAMPLE is only necessary on assignment
>  and need not be specified with KVM_IRQFD_FLAG_DEASSIGN.
>  
> +On ARM/ARM64, the gsi field in the kvm_irqfd struct specifies the Shared
> +Peripheral Interrupt (SPI) index, such that the GIC interrupt ID is
> +given by gsi + 32.
> +
>  4.76 KVM_PPC_ALLOCATE_HTAB
>  
>  Capability: KVM_CAP_PPC_ALLOC_HTAB
> diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> index 0db25bc..2499867 100644
> --- a/arch/arm/include/uapi/asm/kvm.h
> +++ b/arch/arm/include/uapi/asm/kvm.h
> @@ -198,6 +198,9 @@ struct kvm_arch_memory_slot {
>  /* Highest supported SPI, from VGIC_NR_IRQS */
>  #define KVM_ARM_IRQ_GIC_MAX		127
>  
> +/* One single KVM irqchip, ie. the VGIC */
> +#define KVM_NR_IRQCHIPS          1
> +
>  /* PSCI interface */
>  #define KVM_PSCI_FN_BASE		0x95c1ba5e
>  #define KVM_PSCI_FN(n)			(KVM_PSCI_FN_BASE + (n))
> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
> index 9f581b1..e519a40 100644
> --- a/arch/arm/kvm/Kconfig
> +++ b/arch/arm/kvm/Kconfig
> @@ -24,6 +24,7 @@ config KVM
>  	select KVM_MMIO
>  	select KVM_ARM_HOST
>  	depends on ARM_VIRT_EXT && ARM_LPAE
> +	select HAVE_KVM_EVENTFD
>  	---help---
>  	  Support hosting virtualized guest machines. You will also
>  	  need to select one or more of the processor modules below.
> @@ -55,6 +56,7 @@ config KVM_ARM_MAX_VCPUS
>  config KVM_ARM_VGIC
>  	bool "KVM support for Virtual GIC"
>  	depends on KVM_ARM_HOST && OF
> +	select HAVE_KVM_IRQFD
>  	default y
>  	---help---
>  	  Adds support for a hardware assisted, in-kernel GIC emulation.
> diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
> index f7057ed..859db09 100644
> --- a/arch/arm/kvm/Makefile
> +++ b/arch/arm/kvm/Makefile
> @@ -15,7 +15,7 @@ AFLAGS_init.o := -Wa,-march=armv7-a$(plus_virt)
>  AFLAGS_interrupts.o := -Wa,-march=armv7-a$(plus_virt)
>  
>  KVM := ../../../virt/kvm
> -kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
> +kvm-arm-y = $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o
>  
>  obj-y += kvm-arm.o init.o interrupts.o
>  obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 9c905b4..8f8c1da 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -172,6 +172,11 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>  	case KVM_CAP_IRQCHIP:
>  		r = vgic_present;
>  		break;
> +#ifdef CONFIG_HAVE_KVM_IRQFD
> +	case KVM_CAP_IRQFD:
> +		r = vgic_present;
> +		break;
> +#endif
>  	case KVM_CAP_DEVICE_CTRL:
>  	case KVM_CAP_USER_MEMORY:
>  	case KVM_CAP_SYNC_MMU:
> diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> index 480af34..b35c95a 100644
> --- a/arch/arm64/include/uapi/asm/kvm.h
> +++ b/arch/arm64/include/uapi/asm/kvm.h
> @@ -184,6 +184,9 @@ struct kvm_arch_memory_slot {
>  /* Highest supported SPI, from VGIC_NR_IRQS */
>  #define KVM_ARM_IRQ_GIC_MAX		127
>  
> +/* One single KVM irqchip, ie. the VGIC */
> +#define KVM_NR_IRQCHIPS          1
> +
>  /* PSCI interface */
>  #define KVM_PSCI_FN_BASE		0x95c1ba5e
>  #define KVM_PSCI_FN(n)			(KVM_PSCI_FN_BASE + (n))
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 279e1a0..09c25c2 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -26,6 +26,7 @@ config KVM
>  	select KVM_ARM_HOST
>  	select KVM_ARM_VGIC
>  	select KVM_ARM_TIMER
> +	select HAVE_KVM_EVENTFD
>  	---help---
>  	  Support hosting virtualized guest machines.
>  
> @@ -50,6 +51,7 @@ config KVM_ARM_MAX_VCPUS
>  config KVM_ARM_VGIC
>  	bool
>  	depends on KVM_ARM_HOST && OF
> +	select HAVE_KVM_IRQFD
>  	---help---
>  	  Adds support for a hardware assisted, in-kernel GIC emulation.
>  
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 32a0961..2e6b827 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -11,7 +11,7 @@ ARM=../../../arch/arm/kvm
>  
>  obj-$(CONFIG_KVM_ARM_HOST) += kvm.o
>  
> -kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/eventfd.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/arm.o $(ARM)/mmu.o $(ARM)/mmio.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(ARM)/psci.o $(ARM)/perf.o
>  
> diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
> index 18060ea..2c269dd 100644
> --- a/virt/kvm/arm/vgic.c
> +++ b/virt/kvm/arm/vgic.c
> @@ -1449,6 +1449,7 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>  	u32 status = vgic_get_interrupt_status(vcpu);
>  	struct vgic_dist *dist = &vcpu->kvm->arch.vgic;
>  	bool level_pending = false;
> +	struct kvm *kvm = vcpu->kvm;
>  
>  	kvm_debug("STATUS = %08x\n", status);
>  
> @@ -1484,6 +1485,17 @@ static bool vgic_process_maintenance(struct kvm_vcpu *vcpu)
>  			 */
>  			vgic_dist_irq_clear_soft_pend(vcpu, vlr.irq);
>  
> +			/*
> +			 * kvm_notify_acked_irq calls kvm_set_irq()
> +			 * to reset the IRQ level. Need to release the
> +			 * lock for kvm_set_irq to grab it.
> +			 */
> +			spin_unlock(&dist->lock);
> +
> +			kvm_notify_acked_irq(kvm, 0,
> +					     vlr.irq - VGIC_NR_PRIVATE_IRQS);
> +			spin_lock(&dist->lock);
> +
>  			/* Any additional pending interrupt? */
>  			if (vgic_dist_irq_get_level(vcpu, vlr.irq)) {
>  				vgic_cpu_irq_set(vcpu, vlr.irq);
> @@ -2490,3 +2502,36 @@ out_free_irq:
>  	free_percpu_irq(vgic->maint_irq, kvm_get_running_vcpus());
>  	return ret;
>  }
> +
> +int kvm_irq_map_gsi(struct kvm *kvm,
> +		    struct kvm_kernel_irq_routing_entry *entries,
> +		    int gsi)
> +{
> +	return gsi;
> +}
> +
> +int kvm_irq_map_chip_pin(struct kvm *kvm, unsigned irqchip, unsigned pin)
> +{
> +	return pin;
> +}
> +
> +int kvm_set_irq(struct kvm *kvm, int irq_source_id,
> +		u32 irq, int level, bool line_status)
> +{
> +	unsigned int spi = irq + VGIC_NR_PRIVATE_IRQS;
> +
> +	kvm_debug("irqfd sets vIRQ %d to %d\n", irq, level);

I think it would be good to add a BUG_ON(!vgic_initialized(kvm)) here
and convert the kvm_debug into a tracepoint.

> +
> +	if (spi > kvm->arch.vgic.nr_irqs)
> +		return -EINVAL;
> +	return kvm_vgic_inject_irq(kvm, 0, spi, level);
> +
> +}
> +
> +/* MSI not implemented yet */
> +int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
> +		struct kvm *kvm, int irq_source_id,
> +		int level, bool line_status)
> +{
> +	return 0;
> +}
> -- 
> 1.9.1
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

I can adress the two issues above when applying this if you don't have
to do a re-spin.

-Christoffer
