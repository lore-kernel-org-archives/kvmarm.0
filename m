From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH 45/45] KVM: arm/arm64: vgic-new: enable build
Date: Thu, 31 Mar 2016 20:18:50 +0200
Message-ID: <20160331181850.GI4126@cbox>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <1458871508-17279-46-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458871508-17279-46-git-send-email-andre.przywara@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Andre Przywara <andre.przywara@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Mar 25, 2016 at 02:05:08AM +0000, Andre Przywara wrote:
> Now that the new VGIC implementation has reached feature parity with
> the old one, add the new files to the build system and add a Kconfig
> option to switch between the two versions.
> We set the default to the new version to get maximum test coverage,
> in case people experience problems they can switch back to the old
> behaviour if needed.
> 
> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
> ---
>  arch/arm/kvm/Kconfig    |  7 +++++++
>  arch/arm/kvm/Makefile   | 10 ++++++++++
>  arch/arm64/kvm/Kconfig  |  7 +++++++
>  arch/arm64/kvm/Makefile | 10 ++++++++++
>  4 files changed, 34 insertions(+)
> 
> diff --git a/arch/arm/kvm/Kconfig b/arch/arm/kvm/Kconfig
> index 95a0005..02abfff 100644
> --- a/arch/arm/kvm/Kconfig
> +++ b/arch/arm/kvm/Kconfig
> @@ -46,6 +46,13 @@ config KVM_ARM_HOST
>  	---help---
>  	  Provides host support for ARM processors.
>  
> +config KVM_NEW_VGIC
> +	bool "New VGIC implementation"
> +	depends on KVM
> +	default y
> +	---help---
> +	  uses the new VGIC implementation
> +

I had imagined we'd name it in the reverse, so the option would have
been CONFIG_KVM_VGIC_LEGACY, but I guess the net effect should be the
same, assuming most people just go with the default anyway.

Thanks,
-Christoffer

>  source drivers/vhost/Kconfig
>  
>  endif # VIRTUALIZATION
> diff --git a/arch/arm/kvm/Makefile b/arch/arm/kvm/Makefile
> index eb1bf43..aa7d724 100644
> --- a/arch/arm/kvm/Makefile
> +++ b/arch/arm/kvm/Makefile
> @@ -21,7 +21,17 @@ obj-$(CONFIG_KVM_ARM_HOST) += hyp/
>  obj-y += kvm-arm.o init.o interrupts.o
>  obj-y += arm.o handle_exit.o guest.o mmu.o emulate.o reset.o
>  obj-y += coproc.o coproc_a15.o coproc_a7.o mmio.o psci.o perf.o
> +
> +ifeq ($(CONFIG_KVM_NEW_VGIC),y)
> +obj-y += $(KVM)/arm/vgic/vgic.o
> +obj-y += $(KVM)/arm/vgic/vgic_init.o
> +obj-y += $(KVM)/arm/vgic/vgic_irqfd.o
> +obj-y += $(KVM)/arm/vgic/vgic-v2.o
> +obj-y += $(KVM)/arm/vgic/vgic_mmio.o
> +obj-y += $(KVM)/arm/vgic/vgic_kvm_device.o
> +else
>  obj-y += $(KVM)/arm/vgic.o
>  obj-y += $(KVM)/arm/vgic-v2.o
>  obj-y += $(KVM)/arm/vgic-v2-emul.o
> +endif
>  obj-y += $(KVM)/arm/arch_timer.o
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index de7450d..3f0e1ce 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -55,6 +55,13 @@ config KVM_ARM_PMU
>  	  Adds support for a virtual Performance Monitoring Unit (PMU) in
>  	  virtual machines.
>  
> +config KVM_NEW_VGIC
> +	bool "New VGIC implementation"
> +	depends on KVM
> +	default y
> +        ---help---
> +          uses the new VGIC implementation
> +
>  source drivers/vhost/Kconfig
>  
>  endif # VIRTUALIZATION
> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> index 122cff4..2f5d431 100644
> --- a/arch/arm64/kvm/Makefile
> +++ b/arch/arm64/kvm/Makefile
> @@ -20,10 +20,20 @@ kvm-$(CONFIG_KVM_ARM_HOST) += emulate.o inject_fault.o regmap.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += hyp.o hyp-init.o handle_exit.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += guest.o debug.o reset.o sys_regs.o sys_regs_generic_v8.o
>  
> +ifeq ($(CONFIG_KVM_NEW_VGIC),y)
> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic_init.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic_irqfd.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v2.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic-v3.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic_mmio.o
> +kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic/vgic_kvm_device.o
> +else
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v2.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v2-emul.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3.o
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/vgic-v3-emul.o
> +endif
>  kvm-$(CONFIG_KVM_ARM_HOST) += $(KVM)/arm/arch_timer.o
>  kvm-$(CONFIG_KVM_ARM_PMU) += $(KVM)/arm/pmu.o
> -- 
> 2.7.3
> 
> --
> To unsubscribe from this list: send the line "unsubscribe kvm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
