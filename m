From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v5 02/26] KVM: arm/arm64: register irq bypass consumer on
 ARM/ARM64
Date: Mon, 30 Oct 2017 07:47:36 +0100
Message-ID: <20171030064736.GN2166@lvm>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
 <20171027142855.21584-3-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 57B4F49D28
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Oct 2017 02:46:15 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id E9Nz--c7r58T for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Oct 2017 02:46:14 -0400 (EDT)
Received: from mail-lf0-f66.google.com (mail-lf0-f66.google.com
 [209.85.215.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3D48649D24
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Oct 2017 02:46:14 -0400 (EDT)
Received: by mail-lf0-f66.google.com with SMTP id a69so13656904lfe.5
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 23:47:46 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20171027142855.21584-3-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Andre Przywara <Andre.Przywara@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 27, 2017 at 03:28:31PM +0100, Marc Zyngier wrote:
> From: Eric Auger <eric.auger@redhat.com>
> 
> This patch selects IRQ_BYPASS_MANAGER and HAVE_KVM_IRQ_BYPASS
> configs for ARM/ARM64.
> 
> kvm_arch_has_irq_bypass() now is implemented and returns true.
> As a consequence the irq bypass consumer will be registered for
> ARM/ARM64 with the forwarding callbacks:
> 
> - stop/start: halt/resume guest execution
> - add/del_producer: set/unset forwarding at vgic/irqchip level
> 
> We don't have any actual support yet, so nothing gets actually
> forwarded.
> 

Acked-by: Christoffer Dall <christoffer.dall@linaro.org>

> Signed-off-by: Eric Auger <eric.auger@redhat.com>
> [maz: dropped the DEOI stuff for the time being in order to
>       reduce the dependency chain, amended commit message]
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/kvm/Kconfig   |  3 +++
>  arch/arm64/kvm/Kconfig |  3 +++
>  virt/kvm/arm/arm.c     | 40 ++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 46 insertions(+)
> 
> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
> index 90d0176fb30d..4e2b192a030a 100644
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
> index 52cb7ad9b2fd..7e0d6e63cc71 100644
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
> index b9f68e4add71..7ac4ecba9ebd 100644
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
> @@ -1449,6 +1451,44 @@ struct kvm_vcpu *kvm_mpidr_to_vcpu(struct kvm *kvm, unsigned long mpidr)
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
> +	return 0;
> +}
> +void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
> +				      struct irq_bypass_producer *prod)
> +{
> +	struct kvm_kernel_irqfd *irqfd =
> +		container_of(cons, struct kvm_kernel_irqfd, consumer);
> +
> +	return;
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
> 2.11.0
> 
