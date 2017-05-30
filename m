From: Auger Eric <eric.auger@redhat.com>
Subject: Re: [PATCH 30/31] KVM: arm64: Enable GICv3 common sysreg trapping via
 command-line
Date: Tue, 30 May 2017 11:56:19 +0200
Message-ID: <1e6b1e3c-ec86-24ad-8704-59521dc0b159@redhat.com>
References: <20170503104606.19342-1-marc.zyngier@arm.com>
 <20170503104606.19342-31-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170503104606.19342-31-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Robert Richter <rrichter@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 03/05/2017 12:46, Marc Zyngier wrote:
> Now that we're able to safely handle common sysreg access, let's
> give the user the opportunity to enable it by passing a specific
> command-line option (vgic_v3.common_trap).
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

What is the rationale behind trapping those common sysreg accesses. This
is not enabled by default for some erratas. Is it to complete the
trapping modality. May be worth to explain.

Besides

Reviewed-by: Eric Auger <eric.auger@redhat.com>

Eric
> ---
>  include/linux/irqchip/arm-gic-v3.h |  1 +
>  virt/kvm/arm/vgic/vgic-v3.c        | 11 ++++++++++-
>  2 files changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 7fef09bcf7b1..2692217ac667 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -403,6 +403,7 @@
>  
>  #define ICH_HCR_EN			(1 << 0)
>  #define ICH_HCR_UIE			(1 << 1)
> +#define ICH_HCR_TC			(1 << 10)
>  #define ICH_HCR_TALL0			(1 << 11)
>  #define ICH_HCR_TALL1			(1 << 12)
>  #define ICH_HCR_EOIcount_SHIFT		27
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 445e86c8b00c..717219ab58a2 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -23,6 +23,7 @@
>  
>  static bool group0_trap;
>  static bool group1_trap;
> +static bool common_trap;
>  
>  void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
>  {
> @@ -246,6 +247,8 @@ void vgic_v3_enable(struct kvm_vcpu *vcpu)
>  		vgic_v3->vgic_hcr |= ICH_HCR_TALL0;
>  	if (group1_trap)
>  		vgic_v3->vgic_hcr |= ICH_HCR_TALL1;
> +	if (common_trap)
> +		vgic_v3->vgic_hcr |= ICH_HCR_TC;
>  }
>  
>  /* check for overlapping regions and for regions crossing the end of memory */
> @@ -339,6 +342,12 @@ static int __init early_group1_trap_cfg(char *buf)
>  }
>  early_param("vgic_v3.group1_trap", early_group1_trap_cfg);
>  
> +static int __init early_common_trap_cfg(char *buf)
> +{
> +	return strtobool(buf, &common_trap);
> +}
> +early_param("vgic_v3.common_trap", early_common_trap_cfg);
> +
>  /**
>   * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
>   * @node:	pointer to the DT node
> @@ -397,7 +406,7 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>  	}
>  #endif
>  
> -	if (group0_trap || group1_trap) {
> +	if (group0_trap || group1_trap || common_trap) {
>  		kvm_info("GICv3 sysreg trapping enabled (reduced performance)\n");
>  		static_branch_enable(&vgic_v3_cpuif_trap);
>  	}
> 
