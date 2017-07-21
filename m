From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 8/8] KVM: arm/arm64: register DEOI irq bypass consumer
 on ARM/ARM64
Date: Fri, 21 Jul 2017 15:25:06 +0200
Message-ID: <20170721132506.GI16350@cbox>
References: <1497531160-29162-1-git-send-email-eric.auger@redhat.com>
 <1497531160-29162-9-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F13240FAE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jul 2017 09:24:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id c4X18FOnTYUt for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Jul 2017 09:24:14 -0400 (EDT)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 13FE840D1A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jul 2017 09:24:13 -0400 (EDT)
Received: by mail-wm0-f49.google.com with SMTP id v139so3678960wmv.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jul 2017 06:25:08 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1497531160-29162-9-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, alex.williamson@redhat.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu, eric.auger.pro@gmail.com
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 15, 2017 at 02:52:40PM +0200, Eric Auger wrote:
> This patch selects IRQ_BYPASS_MANAGER and HAVE_KVM_IRQ_BYPASS
> configs for ARM/ARM64.
> 
> kvm_arch_has_irq_bypass() now is implemented and returns true.
> As a consequence the irq bypass consumer will be registered for
> ARM/ARM64 with Direct EOI/IRQ forwarding callbacks:
> 
> - stop/start: halt/resume guest execution
> - add/del_producer: set/unset forwarding/DEOI at vgic/irqchip level
> 
> The consumer currently only works with a VFIO_PLATFORM producer.
> In other cases, start/stop do nothing and return without error
> to avoid outputting a spurious warning.
> 
> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> 
> ---
> 
> v1 -> v2:
> - check the type of the producer to avoid attachement with VFIO-PCI
>   dummy MSI producer
> ---
>  arch/arm/kvm/Kconfig   |  3 +++
>  arch/arm64/kvm/Kconfig |  3 +++
>  virt/kvm/arm/arm.c     | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 54 insertions(+)
> 
> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
> index 90d0176..4e2b192 100644
> --- a/arch/arm/kvm/Kconfig
> +++ b/arch/arm/kvm/Kconfig
> @@ -3,6 +3,7 @@
>  #
>  
>  source "virt/kvm/Kconfig"
> +source "virt/lib/Kconfig"
>  
>  menuconfig VIRTUALIZATION
>  	bool "Virtualization"
> @@ -35,6 +36,8 @@ config KVM
>  	select HAVE_KVM_IRQCHIP
>  	select HAVE_KVM_IRQ_ROUTING
>  	select HAVE_KVM_MSI
> +	select IRQ_BYPASS_MANAGER
> +	select HAVE_KVM_IRQ_BYPASS
>  	depends on ARM_VIRT_EXT && ARM_LPAE && ARM_ARCH_TIMER
>  	---help---
>  	  Support hosting virtualized guest machines.
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index 52cb7ad..7e0d6e6 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -3,6 +3,7 @@
>  #
>  
>  source "virt/kvm/Kconfig"
> +source "virt/lib/Kconfig"
>  
>  menuconfig VIRTUALIZATION
>  	bool "Virtualization"
> @@ -35,6 +36,8 @@ config KVM
>  	select HAVE_KVM_MSI
>  	select HAVE_KVM_IRQCHIP
>  	select HAVE_KVM_IRQ_ROUTING
> +	select IRQ_BYPASS_MANAGER
> +	select HAVE_KVM_IRQ_BYPASS
>  	---help---
>  	  Support hosting virtualized guest machines.
>  	  We don't support KVM with 16K page tables yet, due to the multiple
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index 3417e18..58871f8 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -27,6 +27,8 @@
>  #include <linux/mman.h>
>  #include <linux/sched.h>
>  #include <linux/kvm.h>
> +#include <linux/kvm_irqfd.h>
> +#include <linux/irqbypass.h>
>  #include <trace/events/kvm.h>
>  #include <kvm/arm_pmu.h>
>  
> @@ -1420,6 +1422,52 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
>  	return NULL;
>  }
>  
> +bool kvm_arch_has_irq_bypass(void)
> +{
> +	return true;
> +}
> +
> +int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
> +				      struct irq_bypass_producer *prod)
> +{
> +	struct kvm_kernel_irqfd *irqfd =
> +		container_of(cons, struct kvm_kernel_irqfd, consumer);
> +
> +	if (prod->type != IRQ_BYPASS_VFIO_PLATFORM)
> +		return 0;
> +
> +	return kvm_vgic_set_forwarding(irqfd->kvm, prod->irq,
> +				       irqfd->gsi + VGIC_NR_PRIVATE_IRQS);
> +}
> +void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
> +				      struct irq_bypass_producer *prod)
> +{
> +	struct kvm_kernel_irqfd *irqfd =
> +		container_of(cons, struct kvm_kernel_irqfd, consumer);
> +
> +	if (prod->type != IRQ_BYPASS_VFIO_PLATFORM)
> +		return;
> +
> +	kvm_vgic_unset_forwarding(irqfd->kvm, prod->irq,
> +				  irqfd->gsi + VGIC_NR_PRIVATE_IRQS);
> +}
> +
> +void kvm_arch_irq_bypass_stop(struct irq_bypass_consumer *cons)
> +{
> +	struct kvm_kernel_irqfd *irqfd =
> +		container_of(cons, struct kvm_kernel_irqfd, consumer);
> +
> +	kvm_arm_halt_guest(irqfd->kvm);
> +}
> +
> +void kvm_arch_irq_bypass_start(struct irq_bypass_consumer *cons)
> +{
> +	struct kvm_kernel_irqfd *irqfd =
> +		container_of(cons, struct kvm_kernel_irqfd, consumer);
> +
> +	kvm_arm_resume_guest(irqfd->kvm);
> +}
> +
>  /**
>   * Initialize Hyp-mode and memory mappings on all CPUs.
>   */
> -- 
> 2.5.5

Nit: I'm wondering if this should go in a different file, like
virt/kvm/arm/irqbypass.c, or virt/kvm/arm/vgic/vgic-irqbypass.c ?

Thanks,
-Christoffer
