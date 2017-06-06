From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 16/25] KVM: arm64: vgic-v3: Enable trapping of Group-0
 system registers
Date: Tue, 6 Jun 2017 15:22:56 +0200
Message-ID: <20170606132256.GY9464@cbox>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-17-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170601102117.17750-17-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 01, 2017 at 11:21:08AM +0100, Marc Zyngier wrote:
> In order to be able to trap Group-0 GICv3 system registers, we need to
> set ICH_HCR_EL2.TALL0 begore entering the guest. This is conditionnaly
> done after having restored the guest's state, and cleared on exit.
> 
> Reviewed-by: Eric Auger <eric.auger@redhat.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Acked-by: Christoffer Dall <cdall@linaro.org>

> ---
>  include/linux/irqchip/arm-gic-v3.h | 1 +
>  virt/kvm/arm/vgic/vgic-v3.c        | 5 ++++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 03b5a28bb2d0..46a1e0943cf8 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -417,6 +417,7 @@
>  
>  #define ICH_HCR_EN			(1 << 0)
>  #define ICH_HCR_UIE			(1 << 1)
> +#define ICH_HCR_TALL0			(1 << 11)
>  #define ICH_HCR_TALL1			(1 << 12)
>  #define ICH_HCR_EOIcount_SHIFT		27
>  #define ICH_HCR_EOIcount_MASK		(0x1f << ICH_HCR_EOIcount_SHIFT)
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index a16769276efd..7525216ef988 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -21,6 +21,7 @@
>  
>  #include "vgic.h"
>  
> +static bool group0_trap;
>  static bool group1_trap;
>  
>  void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
> @@ -241,6 +242,8 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
>  
>  	/* Get the show on the road... */
>  	vgic_v3->vgic_hcr = ICH_HCR_EN;
> +	if (group0_trap)
> +		vgic_v3->vgic_hcr |= ICH_HCR_TALL0;
>  	if (group1_trap)
>  		vgic_v3->vgic_hcr |= ICH_HCR_TALL1;
>  }
> @@ -473,7 +476,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>  	if (kvm_vgic_global_state.vcpu_base == 0)
>  		kvm_info("disabling GICv2 emulation\n");
>  
> -	if (group1_trap) {
> +	if (group0_trap || group1_trap) {
>  		kvm_info("GICv3 sysreg trapping enabled (reduced performance)\n");
>  		static_branch_enable(&vgic_v3_cpuif_trap);
>  	}
> -- 
> 2.11.0
> 
