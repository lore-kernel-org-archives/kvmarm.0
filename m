Return-Path: <SRS0=AIE7=4F=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7103CC34021
	for <kvmarm@archiver.kernel.org>; Mon, 17 Feb 2020 15:17:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 27EC322464
	for <kvmarm@archiver.kernel.org>; Mon, 17 Feb 2020 15:17:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 27EC322464
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A3034AF42;
	Mon, 17 Feb 2020 10:17:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XrXN0dQXsONv; Mon, 17 Feb 2020 10:17:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 382E04AF37;
	Mon, 17 Feb 2020 10:17:12 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D12AD4AF19
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Feb 2020 10:17:10 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZF9XUeeOxTKL for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Feb 2020 10:17:09 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 61BC64AF42
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Feb 2020 10:17:09 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5FAB328;
 Mon, 17 Feb 2020 07:17:08 -0800 (PST)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com
 [10.121.207.14])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0C3A23F703;
 Mon, 17 Feb 2020 07:17:07 -0800 (PST)
Date: Mon, 17 Feb 2020 15:17:05 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v2 32/94] KVM: arm64: nv: Filter out unsupported features
 from ID regs
Message-ID: <20200217151705.GG47755@lakrids.cambridge.arm.com>
References: <20200211174938.27809-1-maz@kernel.org>
 <20200211174938.27809-33-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20200211174938.27809-33-maz@kernel.org>
User-Agent: Mutt/1.11.1+11 (2f07cb52) (2018-12-01)
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On Tue, Feb 11, 2020 at 05:48:36PM +0000, Marc Zyngier wrote:
> As there is a number of features that we either can't support,
> or don't want to support right away with NV, let's add some
> basic filtering so that we don't advertize silly things to the
> EL2 guest.
> 
> Signed-off-by: Marc Zyngier <maz@kernel.org>
> ---
>  arch/arm64/include/asm/kvm_nested.h |   6 ++
>  arch/arm64/include/asm/sysreg.h     |  11 +++
>  arch/arm64/kvm/nested.c             | 115 ++++++++++++++++++++++++++++
>  arch/arm64/kvm/sys_regs.c           |   5 +-
>  4 files changed, 136 insertions(+), 1 deletion(-)

> +/*
> + * Our emulated CPU doesn't support all the possible features. For the
> + * sake of simplicity (and probably mental sanity), wipe out a number
> + * of feature bits we don't intend to support for the time being.
> + * This list should get updated as new features get added to the NV
> + * support, and new extension to the architecture.
> + *
> + * Revisit: Implement as a whitelist rather than a blacklist?

I certainly think we want this to be a whitelist; blacklists are awful
for both forwards-compatibility and backporting.

I realise that's pain up-front, but I think it saves us much much more
in the long run.

Thanks,
Mark.

> + */
> +void access_nested_id_reg(struct kvm_vcpu *v, struct sys_reg_params *p,
> +			  const struct sys_reg_desc *r)
> +{
> +	u32 id = sys_reg((u32)r->Op0, (u32)r->Op1,
> +			 (u32)r->CRn, (u32)r->CRm, (u32)r->Op2);
> +	u64 val, tmp;
> +
> +	if (!nested_virt_in_use(v))
> +		return;
> +
> +	val = p->regval;
> +
> +	switch (id) {
> +	case SYS_ID_AA64DFR0_EL1:
> +		/* No SPE */
> +		val &= ~FEATURE(ID_AA64DFR0_PMSVER);
> +		/* Cap PMU to ARMv8.1 */
> +		tmp = FIELD_GET(FEATURE(ID_AA64DFR0_PMUVER), val);
> +		if (tmp > 0b0100) {
> +			val &= FEATURE(ID_AA64DFR0_PMUVER);
> +			val |= FIELD_PREP(FEATURE(ID_AA64DFR0_PMUVER), 0b0100);
> +		}
> +		/* No trace */
> +		val &= FEATURE(ID_AA64DFR0_TRACEVER);
> +		/* Cap Debug to ARMv8.1 */
> +		tmp = FIELD_GET(FEATURE(ID_AA64DFR0_DEBUGVER), val);
> +		if (tmp > 0b0111) {
> +			val &= FEATURE(ID_AA64DFR0_DEBUGVER);
> +			val |= FIELD_PREP(FEATURE(ID_AA64DFR0_DEBUGVER), 0b0111);
> +		}
> +		break;
> +
> +	case SYS_ID_AA64ISAR1_EL1:
> +		/* No PtrAuth */
> +		val &= ~(FEATURE(ID_AA64ISAR1_APA) |
> +			 FEATURE(ID_AA64ISAR1_API) |
> +			 FEATURE(ID_AA64ISAR1_GPA) |
> +			 FEATURE(ID_AA64ISAR1_GPI));
> +		break;
> +
> +	case SYS_ID_AA64MMFR0_EL1:
> +		/* Cap PARange to 40bits */
> +		tmp = FIELD_GET(FEATURE(ID_AA64MMFR0_PARANGE), val);
> +		if (tmp > 0b0010) {
> +			val &= ~FEATURE(ID_AA64MMFR0_PARANGE);
> +			val |= FIELD_PREP(FEATURE(ID_AA64MMFR0_PARANGE), 0b0010);
> +		}
> +		break;
> +
> +	case SYS_ID_AA64MMFR1_EL1:
> +		/* No XNX */
> +		val &= ~FEATURE(ID_AA64MMFR1_XNX);
> +		/* No RAS */
> +		val &= ~FEATURE(ID_AA64MMFR1_SpecSEI);
> +		/* No Hierarchical Permission Disable */
> +		val &= ~FEATURE(ID_AA64MMFR1_HPD);
> +		/* No Hardward Access flags and Dirty Bit State update */
> +		val &= ~FEATURE(ID_AA64MMFR1_HADBS);
> +		break;
> +
> +	case SYS_ID_AA64MMFR2_EL1:
> +		/* No ARMv8.2-EVT */
> +		val &= ~FEATURE(ID_AA64MMFR2_EVT);
> +		/* No ARMv8.4-TTRem */
> +		val &= ~FEATURE(ID_AA64MMFR2_BBM);
> +		/* No ARMv8.4-TTST */
> +		val &= ~FEATURE(ID_AA64MMFR2_ST);
> +		/* No ARMv8.3-CCIDX */
> +		val &= ~FEATURE(ID_AA64MMFR2_CCIDX);
> +		/* No ARMv8.2-LVA */
> +		val &= ~FEATURE(ID_AA64MMFR2_LVA);
> +		break;
> +
> +	case SYS_ID_AA64PFR0_EL1:
> +		/* No AMU */
> +		val &= ~FEATURE(ID_AA64PFR0_AMU);
> +		/* No MPAM */
> +		val &= ~FEATURE(ID_AA64PFR0_MPAM);
> +		/* No Secure EL2 */
> +		val &= ~FEATURE(ID_AA64PFR0_SEL2);
> +		/* No RAS */
> +		val &= ~FEATURE(ID_AA64PFR0_RAS);
> +		/* No SVE */
> +		val &= ~FEATURE(ID_AA64PFR0_SVE);
> +		/* EL2 is AArch64 only */
> +		val &= ~FEATURE(ID_AA64PFR0_EL2);
> +		val |= FIELD_PREP(FEATURE(ID_AA64PFR0_EL2), 0b0001);
> +		break;
> +
> +	case SYS_ID_AA64PFR1_EL1:
> +		/* No MTE */
> +		val &= ~FEATURE(ID_AA64PFR1_MTE);
> +		/* No BT */
> +		val &= ~FEATURE(ID_AA64PFR1_BT);
> +		break;
> +	}
> +
> +	p->regval = val;
> +}
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 435340a49634..966eb31a84e6 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -1414,7 +1414,10 @@ static bool access_id_reg(struct kvm_vcpu *vcpu,
>  			  struct sys_reg_params *p,
>  			  const struct sys_reg_desc *r)
>  {
> -	return __access_id_reg(vcpu, p, r, false);
> +	bool ret = __access_id_reg(vcpu, p, r, false);
> +
> +	access_nested_id_reg(vcpu, p, r);
> +	return ret;
>  }
>  
>  static bool access_raz_id_reg(struct kvm_vcpu *vcpu,
> -- 
> 2.20.1
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
