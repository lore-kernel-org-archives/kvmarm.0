From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v4 25/26] KVM: arm/arm64: GICv4: Prevent heterogenous
 systems from using GICv4
Date: Thu, 26 Oct 2017 17:31:28 +0200
Message-ID: <20171026153128.GE2166@lvm>
References: <20171006153401.5481-1-marc.zyngier@arm.com>
 <20171006153401.5481-26-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171006153401.5481-26-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Oct 06, 2017 at 04:34:00PM +0100, Marc Zyngier wrote:
> The GICv4 architecture doesn't prevent CPUs implementing GICv4 to
> cohabit with CPUs limited to GICv3 in the same system.
> 
> This is mad (the scheduler would have to be made aware of the v4
> capability), and we're certainly not going to support this any
> time soon. So let's check that all online CPUs are GICv4 capable,
> and disable the functionnality if not.
> 

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  include/linux/irqchip/arm-gic-v3.h |  2 ++
>  virt/kvm/arm/vgic/vgic-v3.c        | 27 +++++++++++++++++++++++++--
>  2 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> index 1ea576c8126f..dfa4a51643d6 100644
> --- a/include/linux/irqchip/arm-gic-v3.h
> +++ b/include/linux/irqchip/arm-gic-v3.h
> @@ -532,6 +532,8 @@
>  #define ICH_VTR_SEIS_MASK		(1 << ICH_VTR_SEIS_SHIFT)
>  #define ICH_VTR_A3V_SHIFT		21
>  #define ICH_VTR_A3V_MASK		(1 << ICH_VTR_A3V_SHIFT)
> +#define ICH_VTR_nV4_SHIFT		20
> +#define ICH_VTR_nV4_MASK		(1 << ICH_VTR_nV4_SHIFT)
>  
>  #define ICC_IAR1_EL1_SPURIOUS		0x3ff
>  
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 405733678c2f..da99df50a818 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -466,9 +466,19 @@ static int __init early_gicv4_enable(char *buf)
>  }
>  early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
>  
> +static void vgic_check_v4_cpuif(void *param)
> +{
> +	u32 ich_vtr_el2 = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
> +	bool *v4 = param;
> +
> +	*v4 = !(ich_vtr_el2 & ICH_VTR_nV4_MASK);
> +	if (!*v4)
> +		kvm_info("CPU%d is not GICv4 capable\n", smp_processor_id());
> +}
> +
>  /**
>   * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
> - * @node:	pointer to the DT node
> + * @info:	pointer to the firmware-agnostic GIC information
>   *
>   * Returns 0 if a GICv3 has been found, returns an error code otherwise
>   */
> @@ -485,8 +495,21 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>  	kvm_vgic_global_state.can_emulate_gicv2 = false;
>  	kvm_vgic_global_state.ich_vtr_el2 = ich_vtr_el2;
>  
> -	/* GICv4 support? */
> +	/*
> +	 * GICv4 support? We need to check on all CPUs in case of some
> +	 * extremely creative form of big-little brain damage...
> +	 */
>  	if (info->has_v4) {
> +		int cpu;
> +
> +		for_each_online_cpu(cpu) {
> +			bool enable;
> +
> +			smp_call_function_single(cpu, vgic_check_v4_cpuif,
> +						 &enable, 1);
> +			gicv4_enable = gicv4_enable && enable;
> +		}
> +
>  		kvm_vgic_global_state.has_gicv4 = gicv4_enable;
>  		kvm_info("GICv4 support %sabled\n",
>  			 gicv4_enable ? "en" : "dis");
> -- 
> 2.14.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
