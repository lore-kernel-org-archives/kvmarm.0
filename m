From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 11/25] KVM: arm64: vgic-v3: Enable trapping of Group-1
 system registers
Date: Tue, 6 Jun 2017 15:22:41 +0200
Message-ID: <20170606132241.GV9464@cbox>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-12-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170601102117.17750-12-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 01, 2017 at 11:21:03AM +0100, Marc Zyngier wrote:
> In order to be able to trap Group-1 GICv3 system registers, we need to
> set ICH_HCR_EL2.TALL1 before entering the guest. This is conditionally
> done after having restored the guest's state, and cleared on exit.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <cdall@linaro.org>

> ---
>  include/linux/irqchip/arm-gic-v3.h | 1 +
>  virt/kvm/arm/hyp/vgic-v3-sr.c      | 7 +++++++
>  virt/kvm/arm/vgic/vgic-v3.c        | 4 ++++
>  3 files changed, 12 insertions(+)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index e50ce5d416a3..03b5a28bb2d0 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -417,6 +417,7 @@
>  
>  #define ICH_HCR_EN			(1 << 0)
>  #define ICH_HCR_UIE			(1 << 1)
> +#define ICH_HCR_TALL1			(1 << 12)
>  #define ICH_HCR_EOIcount_SHIFT		27
>  #define ICH_HCR_EOIcount_MASK		(0x1f << ICH_HCR_EOIcount_SHIFT)
>  
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index f0bc711db258..8973bad35748 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -258,6 +258,9 @@ void __hyp_text __vgic_v3_save_state(struct kvm_vcpu *vcpu)
>  			cpu_if->vgic_ap1r[0] = __vgic_v3_read_ap1rn(0);
>  		}
>  	} else {
> +		if (static_branch_unlikely(&vgic_v3_cpuif_trap))
> +			write_gicreg(0, ICH_HCR_EL2);
> +
>  		cpu_if->vgic_elrsr = 0xffff;
>  		cpu_if->vgic_ap0r[0] = 0;
>  		cpu_if->vgic_ap0r[1] = 0;
> @@ -330,6 +333,10 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
>  
>  		for (i = 0; i < used_lrs; i++)
>  			__gic_v3_set_lr(cpu_if->vgic_lr[i], i);
> +	} else {
> +		/* Always write ICH_HCR_EL2 to enable trapping */
> +		if (static_branch_unlikely(&vgic_v3_cpuif_trap))
> +			write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
>  	}
>  
>  	/*
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 88d9bd9bf468..fbd678bc046d 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -21,6 +21,8 @@
>  
>  #include "vgic.h"
>  
> +static bool group1_trap;
> +
>  void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
>  {
>  	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
> @@ -239,6 +241,8 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
>  
>  	/* Get the show on the road... */
>  	vgic_v3->vgic_hcr = ICH_HCR_EN;
> +	if (group1_trap)
> +		vgic_v3->vgic_hcr |= ICH_HCR_TALL1;
>  }
>  
>  int vgic_v3_lpi_sync_pending_status(struct kvm *kvm, struct vgic_irq *irq)
> -- 
> 2.11.0
> 
