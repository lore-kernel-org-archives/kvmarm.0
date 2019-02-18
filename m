From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH v10 5/5] arm64: KVM: Enable support for :G/:H perf event
 modifiers
Date: Mon, 18 Feb 2019 23:00:19 +0100
Message-ID: <20190218220019.GB28113@e113682-lin.lund.arm.com>
References: <1547482308-29839-1-git-send-email-andrew.murray@arm.com>
 <1547482308-29839-6-git-send-email-andrew.murray@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 985594A2E4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 17:00:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5TLow4lSOJDB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Feb 2019 17:00:23 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DA9940A52
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Feb 2019 17:00:23 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <1547482308-29839-6-git-send-email-andrew.murray@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Murray <andrew.murray@arm.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 14, 2019 at 04:11:48PM +0000, Andrew Murray wrote:
> Enable/disable event counters as appropriate when entering and exiting
> the guest to enable support for guest or host only event counting.
> 
> For both VHE and non-VHE we switch the counters between host/guest at
> EL2. EL2 is filtered out by the PMU when we are using the :G modifier.

I don't think the last part is strictly true as per the former patch on
a non-vhe system if you have the :h modifier, so maybe just leave that
out of the commit message.

> 
> The PMU may be on when we change which counters are enabled however
> we avoid adding an isb as we instead rely on existing context
> synchronisation events: the isb in kvm_arm_vhe_guest_exit for VHE and
> the eret from the hvc in kvm_call_hyp.
> 
> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  arch/arm64/kvm/hyp/switch.c | 60 +++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 60 insertions(+)
> 
> diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
> index b0b1478..9018fb3 100644
> --- a/arch/arm64/kvm/hyp/switch.c
> +++ b/arch/arm64/kvm/hyp/switch.c
> @@ -357,6 +357,54 @@ static bool __hyp_text __hyp_switch_fpsimd(struct kvm_vcpu *vcpu)
>  	return true;
>  }
>  
> +static bool __hyp_text __pmu_switch_to_guest(struct kvm_cpu_context *host_ctxt)
> +{
> +	struct kvm_host_data *host;
> +	struct kvm_pmu_events *pmu;
> +	u32 clr, set;
> +
> +	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
> +	pmu = &host->pmu_events;
> +
> +	/* We can potentially avoid a sysreg write by only changing bits that
> +	 * differ between the guest/host. E.g. where events are enabled in
> +	 * both guest and host
> +	 */

super nit: kernel coding style requires 'wings' on both side of a
multi-line comment.  Only if you respin anyhow.

> +	clr = pmu->events_host & ~pmu->events_guest;
> +	set = pmu->events_guest & ~pmu->events_host;
> +
> +	if (clr)
> +		write_sysreg(clr, pmcntenclr_el0);
> +
> +	if (set)
> +		write_sysreg(set, pmcntenset_el0);
> +
> +	return (clr || set);
> +}
> +
> +static void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
> +{
> +	struct kvm_host_data *host;
> +	struct kvm_pmu_events *pmu;
> +	u32 clr, set;
> +
> +	host = container_of(host_ctxt, struct kvm_host_data, host_ctxt);
> +	pmu = &host->pmu_events;
> +
> +	/* We can potentially avoid a sysreg write by only changing bits that
> +	 * differ between the guest/host. E.g. where events are enabled in
> +	 * both guest and host
> +	 */

ditto

> +	clr = pmu->events_guest & ~pmu->events_host;
> +	set = pmu->events_host & ~pmu->events_guest;
> +
> +	if (clr)
> +		write_sysreg(clr, pmcntenclr_el0);
> +
> +	if (set)
> +		write_sysreg(set, pmcntenset_el0);
> +}
> +
>  /*
>   * Return true when we were able to fixup the guest exit and should return to
>   * the guest, false when we should restore the host state and return to the
> @@ -464,12 +512,15 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpu_context *host_ctxt;
>  	struct kvm_cpu_context *guest_ctxt;
> +	bool pmu_switch_needed;
>  	u64 exit_code;
>  
>  	host_ctxt = vcpu->arch.host_cpu_context;
>  	host_ctxt->__hyp_running_vcpu = vcpu;
>  	guest_ctxt = &vcpu->arch.ctxt;
>  
> +	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
> +
>  	sysreg_save_host_state_vhe(host_ctxt);
>  
>  	/*
> @@ -511,6 +562,9 @@ int kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
>  
>  	__debug_switch_to_host(vcpu);
>  
> +	if (pmu_switch_needed)
> +		__pmu_switch_to_host(host_ctxt);
> +
>  	return exit_code;
>  }
>  
> @@ -519,6 +573,7 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
>  {
>  	struct kvm_cpu_context *host_ctxt;
>  	struct kvm_cpu_context *guest_ctxt;
> +	bool pmu_switch_needed;
>  	u64 exit_code;
>  
>  	vcpu = kern_hyp_va(vcpu);
> @@ -527,6 +582,8 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
>  	host_ctxt->__hyp_running_vcpu = vcpu;
>  	guest_ctxt = &vcpu->arch.ctxt;
>  
> +	pmu_switch_needed = __pmu_switch_to_guest(host_ctxt);
> +
>  	__sysreg_save_state_nvhe(host_ctxt);
>  
>  	__activate_vm(kern_hyp_va(vcpu->kvm));
> @@ -573,6 +630,9 @@ int __hyp_text __kvm_vcpu_run_nvhe(struct kvm_vcpu *vcpu)
>  	 */
>  	__debug_switch_to_host(vcpu);
>  
> +	if (pmu_switch_needed)
> +		__pmu_switch_to_host(host_ctxt);
> +
>  	return exit_code;
>  }
>  
> -- 
> 2.7.4
> 

Thanks,

    Christoffer
