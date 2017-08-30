From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3 56/59] KVM: arm/arm64: GICv4: Prevent heterogenous
 systems from using GICv4
Date: Wed, 30 Aug 2017 23:00:27 +0200
Message-ID: <20170830210027.GO24522@cbox>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
 <20170731172637.29355-57-marc.zyngier@arm.com>
 <20170828183550.GQ24649@cbox>
 <bcd17108-b035-a95f-67a4-4433e2be20ae@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAB1C49C0C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Aug 2017 16:58:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q5nHqPnlr1PY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Aug 2017 16:58:15 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7723940A86
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Aug 2017 16:58:15 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id a80so17310623wma.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Aug 2017 14:00:28 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <bcd17108-b035-a95f-67a4-4433e2be20ae@arm.com>
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
Cc: Jason Cooper <jason@lakedaemon.net>, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Wed, Aug 30, 2017 at 05:03:51PM +0100, Marc Zyngier wrote:
> On 28/08/17 19:35, Christoffer Dall wrote:
> > On Mon, Jul 31, 2017 at 06:26:34PM +0100, Marc Zyngier wrote:
> >> The GICv4 architecture doesn't prevent CPUs implementing GICv4 to
> >> cohabit with CPUs limited to GICv3 in the same system.
> >>
> >> This is mad (the sheduler would have to be made aware of the v4
> > 
> > *scheduler
> > 
> >> capability), and we're certainly not going to support this any
> >> time soon. So let's check that all online CPUs are GICv4 capable,
> >> and disable the functionnality if not.
> > 
> > *functionality
> > 
> >>
> >> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> >> ---
> >>  include/linux/irqchip/arm-gic-v3.h |  2 ++
> >>  virt/kvm/arm/vgic/vgic-v3.c        | 22 +++++++++++++++++++++-
> >>  2 files changed, 23 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> >> index 1ea576c8126f..dfa4a51643d6 100644
> >> --- a/include/linux/irqchip/arm-gic-v3.h
> >> +++ b/include/linux/irqchip/arm-gic-v3.h
> >> @@ -532,6 +532,8 @@
> >>  #define ICH_VTR_SEIS_MASK		(1 << ICH_VTR_SEIS_SHIFT)
> >>  #define ICH_VTR_A3V_SHIFT		21
> >>  #define ICH_VTR_A3V_MASK		(1 << ICH_VTR_A3V_SHIFT)
> >> +#define ICH_VTR_nV4_SHIFT		20
> >> +#define ICH_VTR_nV4_MASK		(1 << ICH_VTR_nV4_SHIFT)
> >>  
> >>  #define ICC_IAR1_EL1_SPURIOUS		0x3ff
> >>  
> >> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> >> index 405733678c2f..252268e83ade 100644
> >> --- a/virt/kvm/arm/vgic/vgic-v3.c
> >> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> >> @@ -466,6 +466,18 @@ static int __init early_gicv4_enable(char *buf)
> >>  }
> >>  early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
> >>  
> >> +static void vgic_check_v4_cpuif(void *param)
> >> +{
> >> +	u32 ich_vtr_el2 = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
> >> +	bool *v4 = param, this_cpu_is_v4;
> >> +
> >> +	this_cpu_is_v4 = !(ich_vtr_el2 & ICH_VTR_nV4_MASK);
> >> +	if (!this_cpu_is_v4)
> >> +		kvm_info("CPU%d is not GICv4 capable\n", smp_processor_id());
> >> +
> >> +	*v4 &= this_cpu_is_v4;
> > 
> > nit: You could make this function look slightly less scary by declaring
> > this_cpu_is_v4 on a separate line and not use a bitwise operator on a
> > boolean type.  Actually, having a function called 'check' with a side
> > effect is not the nicest thing either, so why not just return what this
> > particular CPU does and do the comparison in the calling loop.
> 
> Fair enough.
> 
> > #bikeshedding
> 
> How about this on top:
> 
> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> index 01eaf4ee2f63..e471750dc0a1 100644
> --- a/virt/kvm/arm/vgic/vgic-v3.c
> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> @@ -469,18 +469,16 @@ early_param("kvm-arm.vgic_v4_enable", early_gicv4_enable);
>  static void vgic_check_v4_cpuif(void *param)
>  {
>  	u32 ich_vtr_el2 = kvm_call_hyp(__vgic_v3_get_ich_vtr_el2);
> -	bool *v4 = param, this_cpu_is_v4;
> +	bool *v4 = param;
>  
> -	this_cpu_is_v4 = !(ich_vtr_el2 & ICH_VTR_nV4_MASK);
> -	if (!this_cpu_is_v4)
> +	*v4 = !(ich_vtr_el2 & ICH_VTR_nV4_MASK);
> +	if (!*v4)
>  		kvm_info("CPU%d is not GICv4 capable\n", smp_processor_id());
> -
> -	*v4 &= this_cpu_is_v4;
>  }
>  
>  /**
>   * vgic_v3_probe - probe for a GICv3 compatible interrupt controller in DT
> - * @node:	pointer to the DT node
> + * @info:	pointer to the firmware-agnostic GIC information
>   *
>   * Returns 0 if a GICv3 has been found, returns an error code otherwise
>   */
> @@ -504,9 +502,14 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
>  	if (info->has_v4) {
>  		int cpu;
>  
> -		for_each_online_cpu(cpu)
> +		for_each_online_cpu(cpu) {
> +			bool enable;
> +
>  			smp_call_function_single(cpu, vgic_check_v4_cpuif,
> -						 &gicv4_enable, 1);
> +						 &enable, 1);
> +			gicv4_enable = gicv4_enable && enable;
> +		}
> +
>  		kvm_vgic_global_state.has_gicv4 = gicv4_enable;
>  		kvm_info("GICv4 support %sabled\n",
>  			 gicv4_enable ? "en" : "dis");
> 

Looks good to me, thanks!
-Christoffer
