From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v4 05/21] KVM: ARM64: Add reset and access handlers for
 PMSELR register
Date: Mon, 30 Nov 2015 17:56:00 +0000
Message-ID: <20151130175600.0ce835cd@arm.com>
References: <1446186123-11548-1-git-send-email-zhaoshenglong@huawei.com>
 <1446186123-11548-6-git-send-email-zhaoshenglong@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2FCC48534
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2015 12:54:51 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id add-wJXivGYm for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Nov 2015 12:54:50 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B8374852F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Nov 2015 12:54:50 -0500 (EST)
In-Reply-To: <1446186123-11548-6-git-send-email-zhaoshenglong@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: kvm@vger.kernel.org, shannon.zhao@linaro.org, will.deacon@arm.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, 30 Oct 2015 14:21:47 +0800
Shannon Zhao <zhaoshenglong@huawei.com> wrote:

> From: Shannon Zhao <shannon.zhao@linaro.org>
> 
> Since the reset value of PMSELR_EL0 is UNKNOWN, use reset_unknown for
> its reset handler. As it doesn't need to deal with the acsessing action
> specially, it uses default case to emulate writing and reading PMSELR
> register.
> 
> Add a helper for CP15 registers reset to UNKNOWN.
> 
> Signed-off-by: Shannon Zhao <shannon.zhao@linaro.org>
> ---
>  arch/arm64/kvm/sys_regs.c | 5 +++--
>  arch/arm64/kvm/sys_regs.h | 8 ++++++++
>  2 files changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 5b591d6..35d232e 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -707,7 +707,7 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	  trap_raz_wi },
>  	/* PMSELR_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b101),
> -	  trap_raz_wi },
> +	  access_pmu_regs, reset_unknown, PMSELR_EL0 },
>  	/* PMCEID0_EL0 */
>  	{ Op0(0b11), Op1(0b011), CRn(0b1001), CRm(0b1100), Op2(0b110),
>  	  trap_raz_wi },
> @@ -998,7 +998,8 @@ static const struct sys_reg_desc cp15_regs[] = {
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 1), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 2), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 3), trap_raz_wi },
> -	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), trap_raz_wi },
> +	{ Op1( 0), CRn( 9), CRm(12), Op2( 5), access_pmu_cp15_regs,
> +	  reset_unknown_cp15, c9_PMSELR },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 6), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(12), Op2( 7), trap_raz_wi },
>  	{ Op1( 0), CRn( 9), CRm(13), Op2( 0), trap_raz_wi },
> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
> index eaa324e..8afeff7 100644
> --- a/arch/arm64/kvm/sys_regs.h
> +++ b/arch/arm64/kvm/sys_regs.h
> @@ -110,6 +110,14 @@ static inline void reset_unknown(struct kvm_vcpu *vcpu,
>  	vcpu_sys_reg(vcpu, r->reg) = 0x1de7ec7edbadc0deULL;
>  }
>  
> +static inline void reset_unknown_cp15(struct kvm_vcpu *vcpu,
> +				      const struct sys_reg_desc *r)
> +{
> +	BUG_ON(!r->reg);
> +	BUG_ON(r->reg >= NR_COPRO_REGS);
> +	vcpu_cp15(vcpu, r->reg) = 0xdecafbad;
> +}
> +
>  static inline void reset_val(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
>  {
>  	BUG_ON(!r->reg);


Same remark here as the one I made earlier. I'm pretty sure we don't
call any CP15 reset because they are all shared with their 64bit
counterparts. The same thing goes for the whole series.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny.
