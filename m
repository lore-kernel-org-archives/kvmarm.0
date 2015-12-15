From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v7 06/19] KVM: ARM64: Add access handler for PMCEID0 and
 PMCEID1 register
Date: Tue, 15 Dec 2015 14:20:14 +0000
Message-ID: <5670219E.1050207@arm.com>
References: <1450169379-12336-1-git-send-email-zhaoshenglong@huawei.com> <1450169379-12336-7-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1450169379-12336-7-git-send-email-zhaoshenglong@huawei.com>
Sender: kvm-owner@vger.kernel.org
To: Shannon Zhao <zhaoshenglong@huawei.com>, kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, will.deacon@arm.com, alex.bennee@linaro.org, wei@redhat.com, cov@codeaurora.org, shannon.zhao@linaro.org, peter.huangpeng@huawei.com, hangaohuai@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 15/12/15 08:49, Shannon Zhao wrote:
> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Add access handler which gets host value of PMCEID0 or PMCEID1 when
> guest access these registers. Writing action to PMCEID0 or PMCEID1 is
> ignored.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 26 ++++++++++++++++++++++----
>  1 file changed, 22 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index c21f91b..e043224 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -486,6 +486,24 @@ static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
>  	return true;
>  }
>  
> +static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
> +			  const struct sys_reg_desc *r)
> +{
> +	u64 pmceid;
> +
> +	if (p->is_write)
> +		return write_to_read_only(vcpu, p);

This register in UNDEFINED in that case. You should call
kvm_inject_undefined() for that vcpu and return.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
