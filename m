From: Christopher Covington <cov@codeaurora.org>
Subject: Re: [PATCH v4 08/21] KVM: ARM64: Add reset and access
 handlers for PMXEVTYPER register
Date: Mon, 02 Nov 2015 15:54:12 -0500
Message-ID: <5637CD74.2010609@codeaurora.org>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com> <1446186123-11548-9-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1446186123-11548-9-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, marc.zyngier@arm.com, christoffer.dall@linaro.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, shannon.zhao@linaro.org, peter.huangpeng@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

Hi Shannon,

On 10/30/2015 02:21 AM, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Since the reset value of PMXEVTYPER is UNKNOWN, use reset_unknown or
> reset_unknown_cp15 for its reset handler. Add access handler which
> emulates writing and reading PMXEVTYPER register. When writing to
> PMXEVTYPER, call kvm_pmu_set_counter_event_type to create a perf_event
> for the selected event type.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 26 ++++++++++++++++++++++++--
>  1 file changed, 24 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index cb82b15..4e606ea 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -491,6 +491,17 @@ static bool access_pmu_regs(struct kvm_vcpu *vcpu,
>  
>  	if (p->is_write) {
>  		switch (r->reg) {
> +		case PMXEVTYPER_EL0: {
> +			val = vcpu_sys_reg(vcpu, PMSELR_EL0);
> +			kvm_pmu_set_counter_event_type(vcpu,
> +						       *vcpu_reg(vcpu, p->Rt),
> +						       val);
> +			vcpu_sys_reg(vcpu, PMXEVTYPER_EL0) =
> +							 *vcpu_reg(vcpu, p->Rt);

Why does PMXEVTYPER get set directly? It seems like it could have an accessor
that redirected to PMEVTYPER<n>.

> +			vcpu_sys_reg(vcpu, PMEVTYPER0_EL0 + val) =
> +							 *vcpu_reg(vcpu, p->Rt);

I tried to look around briefly but couldn't find counter number range checking
in the PMSELR handler or here. Should there be some here and in PMXEVCNTR?

Thanks,
Christopher Covington

-- 
Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
