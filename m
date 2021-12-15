Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEC64C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 15 Dec 2021 12:15:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DB684B0F5;
	Wed, 15 Dec 2021 07:15:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uhk0JGcM54+X; Wed, 15 Dec 2021 07:15:16 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C2B594B103;
	Wed, 15 Dec 2021 07:15:16 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A13F84B0F5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 07:15:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tuFa-NTlVyWY for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Dec 2021 07:15:14 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 106674B0C3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 07:15:14 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A40B9D6E;
 Wed, 15 Dec 2021 04:15:13 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.67.176])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 950413F774;
 Wed, 15 Dec 2021 04:15:12 -0800 (PST)
Date: Wed, 15 Dec 2021 12:15:09 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v4 3/6] KVM: arm64: Allow guest to set the OSLK bit
Message-ID: <YbncTRH4TnVvRVxB@FVFF77S0Q05N>
References: <20211214172812.2894560-1-oupton@google.com>
 <20211214172812.2894560-4-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211214172812.2894560-4-oupton@google.com>
Cc: linux-arm-kernel@lists.infradead.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>, kvmarm@lists.cs.columbia.edu,
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

On Tue, Dec 14, 2021 at 05:28:09PM +0000, Oliver Upton wrote:
> Allow writes to OSLAR and forward the OSLK bit to OSLSR. Do nothing with
> the value for now.
> 
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/sysreg.h |  9 ++++++++
>  arch/arm64/kvm/sys_regs.c       | 39 ++++++++++++++++++++++++++-------
>  2 files changed, 40 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index 16b3f1a1d468..46f800bda045 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -129,7 +129,16 @@
>  #define SYS_DBGWCRn_EL1(n)		sys_reg(2, 0, 0, n, 7)
>  #define SYS_MDRAR_EL1			sys_reg(2, 0, 1, 0, 0)
>  #define SYS_OSLAR_EL1			sys_reg(2, 0, 1, 0, 4)
> +
> +#define SYS_OSLAR_OSLK			BIT(0)
> +
>  #define SYS_OSLSR_EL1			sys_reg(2, 0, 1, 1, 4)
> +
> +#define SYS_OSLSR_OSLK			BIT(1)
> +
> +#define SYS_OSLSR_OSLM_MASK		(BIT(3) | BIT(0))
> +#define SYS_OSLSR_OSLM			BIT(3)

Since `OSLM` is the field as a whole, I think this should have another level of
hierarchy, e.g.

#define SYS_OSLSR_OSLM_MASK			(BIT(3) | BIT(0))
#define SYS_OSLSR_OSLM_NI			0
#define SYS_OSLSR_OSLM_OSLK			BIT(3)

[...]

> +static bool trap_oslar_el1(struct kvm_vcpu *vcpu,
> +			   struct sys_reg_params *p,
> +			   const struct sys_reg_desc *r)
> +{
> +	u64 oslsr;
> +
> +	if (!p->is_write)
> +		return read_from_write_only(vcpu, p, r);
> +
> +	/* Forward the OSLK bit to OSLSR */
> +	oslsr = __vcpu_sys_reg(vcpu, OSLSR_EL1) & ~SYS_OSLSR_OSLK;
> +	if (p->regval & SYS_OSLAR_OSLK)
> +		oslsr |= SYS_OSLSR_OSLK;
> +
> +	__vcpu_sys_reg(vcpu, OSLSR_EL1) = oslsr;
> +	return true;
> +}

Does changing this affect existing userspace? Previosuly it could read
OSLAR_EL1 as 0, whereas now that should be rejected.

That might be fine, and if so, it would be good to call that out in the commit
message.

[...]

> @@ -309,9 +331,14 @@ static int set_oslsr_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>  	if (err)
>  		return err;
>  
> -	if (val != rd->val)
> +	/*
> +	 * The only modifiable bit is the OSLK bit. Refuse the write if
> +	 * userspace attempts to change any other bit in the register.
> +	 */
> +	if ((val & ~SYS_OSLSR_OSLK) != SYS_OSLSR_OSLM)
>  		return -EINVAL;

How about:

	if ((val ^ rd->val) & ~SYS_OSLSR_OSLK)
		return -EINVAL;

... so that we don't need to hard-code the expected value here, and can more
easily change it in future?

[...]

> @@ -1463,8 +1486,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  	DBG_BCR_BVR_WCR_WVR_EL1(15),
>  
>  	{ SYS_DESC(SYS_MDRAR_EL1), trap_raz_wi },
> -	{ SYS_DESC(SYS_OSLAR_EL1), trap_raz_wi },
> -	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x00000008,
> +	{ SYS_DESC(SYS_OSLAR_EL1), trap_oslar_el1 },
> +	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, SYS_OSLSR_OSLM,
>  		.set_user = set_oslsr_el1, },
>  	{ SYS_DESC(SYS_OSDLR_EL1), trap_raz_wi },
>  	{ SYS_DESC(SYS_DBGPRCR_EL1), trap_raz_wi },
> @@ -1937,7 +1960,7 @@ static const struct sys_reg_desc cp14_regs[] = {
>  
>  	DBGBXVR(0),
>  	/* DBGOSLAR */
> -	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_raz_wi },
> +	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_oslar_el1 },

As above, I have a slight concern that this could adversely affect existing
userspace, but I can also believe that's fine.

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
