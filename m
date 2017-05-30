From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 22/31] KVM: arm64: vgic-v3: Enable trapping of Group-0
 system registers
Date: Tue, 30 May 2017 11:48:15 +0200
Message-ID: <58415158-a732-16a4-4e4a-a5341529e2e5@redhat.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-23-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170503104606.19342-23-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 03/05/2017 12:45, Marc Zyngier wrote:
> In order to be able to trap Group-0 GICv3 system registers, we need to
> set ICH_HCR_EL2.TALL0 begore entering the guest. This is conditionnaly
> done after having restored the guest's state, and cleared on exit.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

> ---
>  include/linux/irqchip/arm-gic-v3.h | 1 +
>  virt/kvm/arm/vgic/vgic-v3.c        | 5 ++++-
>  2 files changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index a1739843343e..7fef09bcf7b1 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -403,6 +403,7 @@
>  
>  #define ICH_HCR_EN			(1 << 0)
>  #define ICH_HCR_UIE			(1 << 1)
> +#define ICH_HCR_TALL0			(1 << 11)
>  #define ICH_HCR_TALL1			(1 << 12)
>  #define ICH_HCR_EOIcount_SHIFT		27
>  #define ICH_HCR_EOIcount_MASK		(0x1f << ICH_HCR_EOIcount_SHIFT)
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 71ecf448ca49..812f179a6931 100644
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
Hum ok, now I get why you use the bool, sorry ;-)

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
>  	if (group1_trap)
>  		vgic_v3->vgic_hcr |= ICH_HCR_TALL1;
>  }
> @@ -381,7 +384,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>  	if (kvm_vgic_global_state.vcpu_base == 0)
>  		kvm_info("disabling GICv2 emulation\n");
>  
> -	if (group1_trap) {
> +	if (group0_trap || group1_trap) {
>  		kvm_info("GICv3 sysreg trapping enabled (reduced performance)\n");
>  		static_branch_enable(&vgic_v3_cpuif_trap);
>  	}
> 
