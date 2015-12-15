From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v7 09/19] KVM: ARM64: Add access handler for event counter
 register
Date: Tue, 15 Dec 2015 13:44:41 +0000
Message-ID: <56701949.6080004@arm.com>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com> <1450169379-12336-10-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450169379-12336-10-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 15/12/15 08:49, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> These kind of registers include PMEVCNTRn, PMCCNTR and PMXEVCNTR which
> is mapped to PMEVCNTRn.
> 
> The access handler translates all aarch32 register offsets to aarch64
> ones and uses vcpu_sys_reg() to access their values to avoid taking care
> of big endian.
> 
> When reading these registers, return the sum of register value and the
> value perf event counts.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 136 ++++++++++++++++++++++++++++++++++++++++++++--
>  1 file changed, 132 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c52ff15..dc6bb26 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -566,6 +566,55 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	return true;
>  }
>  
> +static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
> +			      struct sys_reg_params *p,
> +			      const struct sys_reg_desc *r)
> +{
> +	u64 idx, reg, val;
> +
> +	if (!p->is_aarch32) {
> +		if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 2)
> +			/* PMXEVCNTR_EL0 */
> +			reg = 0;
> +		else
> +			/* PMEVCNTRn_EL0 or PMCCNTR_EL0 */
> +			reg = r->reg;
> +	} else {
> +		if (r->CRn == 9 && r->CRm == 13) {
> +			reg = (r->Op2 & 2) ? 0 : PMCCNTR_EL0;
> +		} else {
> +			reg = ((r->CRm & 3) << 3) & (r->Op2 & 7);

Same bug as the previous patch.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
