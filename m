From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v2 12/25] KVM: arm64: Enable GICv3 Group-1 sysreg
 trapping via command-line
Date: Tue, 6 Jun 2017 14:06:56 +0200
Message-ID: <20170606120656.GN9464@cbox>
References: <20170601102117.17750-1-marc.zyngier@arm.com>
 <20170601102117.17750-13-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170601102117.17750-13-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Jun 01, 2017 at 11:21:04AM +0100, Marc Zyngier wrote:
> Now that we're able to safely handle Group-1 sysreg access, let's
> give the user the opportunity to enable it by passing a specific
> command-line option (vgic_v3.group1_trap).
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/hyp/vgic-v3-sr.c |  6 +++++-
>  virt/kvm/arm/vgic/vgic-v3.c   | 11 +++++++++++
>  2 files changed, 16 insertions(+), 1 deletion(-)
> 
> diff --git a/virt/kvm/arm/hyp/vgic-v3-sr.c b/virt/kvm/arm/hyp/vgic-v3-sr.c
> index 8973bad35748..42ac9ee7650a 100644
> --- a/virt/kvm/arm/hyp/vgic-v3-sr.c
> +++ b/virt/kvm/arm/hyp/vgic-v3-sr.c
> @@ -334,7 +334,11 @@ void __hyp_text __vgic_v3_restore_state(struct kvm_vcpu *vcpu)
>  		for (i = 0; i < used_lrs; i++)
>  			__gic_v3_set_lr(cpu_if->vgic_lr[i], i);
>  	} else {
> -		/* Always write ICH_HCR_EL2 to enable trapping */
> +		/*
> +                 * If we don't have any interrupt to inject, but that
> +		 * trapping is enabled, write the ICH_HCR_EL2 config
> +		 * anyway.
> +		 */

nit: Whitespace and grammar issues, and maybe this hunk was supposed to
be in the last patch?

>  		if (static_branch_unlikely(&vgic_v3_cpuif_trap))
>  			write_gicreg(cpu_if->vgic_hcr, ICH_HCR_EL2);
>  	}
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index fbd678bc046d..a16769276efd 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -416,6 +416,12 @@ int vgic_v3_map_resources(struct kvm *kvm)
>  
>  DEFINE_STATIC_KEY_FALSE(vgic_v3_cpuif_trap);
>  
> +static int __init early_group1_trap_cfg(char *buf)
> +{
> +	return strtobool(buf, &group1_trap);
> +}
> +early_param("vgic_v3.group1_trap", early_group1_trap_cfg);
> +

this shouldn't be named something with KVM (we're not going to trap
anything on the host somehow are we?)?

>  /**
>   * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
>   * @node:	pointer to the DT node
> @@ -467,6 +473,11 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>  	if (kvm_vgic_global_state.vcpu_base == 0)
>  		kvm_info("disabling GICv2 emulation\n");
>  
> +	if (group1_trap) {
> +		kvm_info("GICv3 sysreg trapping enabled (reduced performance)\n");
> +		static_branch_enable(&vgic_v3_cpuif_trap);
> +	}
> +
>  	kvm_vgic_global_state.vctrl_base = NULL;
>  	kvm_vgic_global_state.type = VGIC_V3;
>  	kvm_vgic_global_state.max_gic_vcpus = VGIC_V3_MAX_CPUS;
> -- 
> 2.11.0
> 

Thanks,
-Christoffer
