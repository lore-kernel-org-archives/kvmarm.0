From: Wei Huang <wei@redhat.com>
Subject: Re: [PATCH v3 10/20] KVM: ARM64: Add reset and access handlers for
 PMCCNTR register
Date: Fri, 16 Oct 2015 10:06:35 -0500
Message-ID: <5621127B.8070704@redhat.com>
References: <1443133885-3366-1-git-send-email-shannon.zhao@linaro.org>
 <1443133885-3366-11-git-send-email-shannon.zhao@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F1748412AF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Oct 2015 11:04:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0Ln4qKJP+Csq for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Oct 2015 11:04:21 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 94888411BE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Oct 2015 11:04:21 -0400 (EDT)
In-Reply-To: <1443133885-3366-11-git-send-email-shannon.zhao@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <shannon.zhao@linaro.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, marc.zyngier@arm.com, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 09/24/2015 05:31 PM, Shannon Zhao wrote:
> Since the reset value of PMCCNTR is UNKNOWN, use reset_unknown for its
> reset handler. Add a new case to emulate reading to PMCCNTR register.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index e7f6058..c38c2de 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -518,6 +518,12 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>  		}
>  	} else {
>  		switch (r->reg) {
> +		case PMCCNTR_EL0: {
> +			val = kvm_pmu_get_counter_value(vcpu,
> +							ARMV8_MAX_COUNTERS - 1);
> +			*vcpu_reg(vcpu, p->Rt) = val;
> +			break;
> +		}
>  		case PMXEVCNTR_EL0: {
>  			val = kvm_pmu_get_counter_value(vcpu,
>  						vcpu_sys_reg(vcpu, PMSELR_EL0));
> @@ -748,7 +754,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  access_pmu_regs, reset_pmceid, PMCEID1_EL0 },
>  	/* PMCCNTR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b000),
> -	  trap_raz_wi },
> +	  access_pmu_regs, reset_unknown, PMCCNTR_EL0 },
>  	/* PMXEVTYPER_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1101), Op2(0b001),
>  	  access_pmu_regs, reset_unknown, PMXEVTYPER_EL0 },
> @@ -997,6 +1003,12 @@ static bool access_pmu_cp15_regs(struct kvm_vcpu *vcpu,
>  		}
>  	} else {
>  		switch (r->reg) {
> +		case c9_PMCCNTR: {
> +			val = kvm_pmu_get_counter_value(vcpu,
> +							ARMV8_MAX_COUNTERS - 1);

PMCCNTR is for cycle counter. There is a filter register, PMCCFILTR_EL0,
associated with it. When kvm_pmu_set_counter_event_type() is called, I
didn't see this filter config been used in perf_event_attr when
perf_event is created.

> +			*vcpu_reg(vcpu, p->Rt) = val;
> +			break;
> +		}
>  		case c9_PMXEVCNTR: {
>  			val = kvm_pmu_get_counter_value(vcpu,
>  						    vcpu_cp15(vcpu, c9_PMSELR));
> @@ -1051,7 +1063,8 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	  reset_pmceid, c9_PMCEID0 },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), access_pmu_cp15_regs,
>  	  reset_pmceid, c9_PMCEID1 },
> -	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), trap_raz_wi },
> +	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), access_pmu_cp15_regs,
> +	  reset_unknown_cp15, c9_PMCCNTR },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 1), access_pmu_cp15_regs,
>  	  reset_unknown_cp15, c9_PMXEVTYPER },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 2), access_pmu_cp15_regs,
> 
