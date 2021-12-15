Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38A56C433F5
	for <kvmarm@archiver.kernel.org>; Wed, 15 Dec 2021 11:57:43 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B16264B099;
	Wed, 15 Dec 2021 06:57:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id VqYQ2H2863tN; Wed, 15 Dec 2021 06:57:41 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 356DD49E57;
	Wed, 15 Dec 2021 06:57:41 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC55D407ED
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 06:57:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w04q7Rp-hih7 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Dec 2021 06:57:37 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B9CE740413
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Dec 2021 06:57:37 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5D186D6E;
 Wed, 15 Dec 2021 03:57:37 -0800 (PST)
Received: from FVFF77S0Q05N (unknown [10.57.67.176])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 41F603F774;
 Wed, 15 Dec 2021 03:57:36 -0800 (PST)
Date: Wed, 15 Dec 2021 11:57:33 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Oliver Upton <oupton@google.com>
Subject: Re: [PATCH v4 2/6] KVM: arm64: Stash OSLSR_EL1 in the cpu context
Message-ID: <YbnYLTR+UCcr6AUh@FVFF77S0Q05N>
References: <20211214172812.2894560-1-oupton@google.com>
 <20211214172812.2894560-3-oupton@google.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20211214172812.2894560-3-oupton@google.com>
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

On Tue, Dec 14, 2021 at 05:28:08PM +0000, Oliver Upton wrote:
> An upcoming change to KVM will context switch the OS Lock status between
> guest/host. Add OSLSR_EL1 to the cpu context and handle guest reads
> using the stored value.

The "context switch" wording is stale here, since later patches emulate the
behaviour of the OS lock (and explain why a context switch isn't appropriate).

That first sentence needs to change to something like:

| An upcoming change to KVM will emulate the OS Lock from the PoV of the guest.

> Wire up a custom handler for writes from userspace and prevent any of
> the invariant bits from changing.
> 
> Reviewed-by: Reiji Watanabe <reijiw@google.com>
> Signed-off-by: Oliver Upton <oupton@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/kvm/sys_regs.c         | 31 ++++++++++++++++++++++++-------
>  2 files changed, 26 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 2a5f7f38006f..53fc8a6eaf1c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -172,8 +172,10 @@ enum vcpu_sysreg {
>  	PAR_EL1,	/* Physical Address Register */
>  	MDSCR_EL1,	/* Monitor Debug System Control Register */
>  	MDCCINT_EL1,	/* Monitor Debug Comms Channel Interrupt Enable Reg */
> +	OSLSR_EL1,	/* OS Lock Status Register */
>  	DISR_EL1,	/* Deferred Interrupt Status Register */
>  
> +

I don't think this whitespace needed to change.

>  	/* Performance Monitors Registers */
>  	PMCR_EL0,	/* Control Register */
>  	PMSELR_EL0,	/* Event Counter Selection Register */
> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
> index 11b4212c2036..7bf350b3d9cd 100644
> --- a/arch/arm64/kvm/sys_regs.c
> +++ b/arch/arm64/kvm/sys_regs.c
> @@ -291,12 +291,28 @@ static bool trap_oslsr_el1(struct kvm_vcpu *vcpu,
>  			   struct sys_reg_params *p,
>  			   const struct sys_reg_desc *r)
>  {
> -	if (p->is_write) {
> +	if (p->is_write)
>  		return write_to_read_only(vcpu, p, r);
> -	} else {
> -		p->regval = (1 << 3);
> -		return true;
> -	}
> +
> +	p->regval = __vcpu_sys_reg(vcpu, r->reg);
> +	return true;
> +}
> +
> +static int set_oslsr_el1(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
> +			 const struct kvm_one_reg *reg, void __user *uaddr)
> +{
> +	u64 id = sys_reg_to_index(rd);
> +	u64 val;
> +	int err;
> +
> +	err = reg_from_user(&val, uaddr, id);
> +	if (err)
> +		return err;
> +
> +	if (val != rd->val)
> +		return -EINVAL;

Bit 1 isn't invariant; why can't the user set that? If there's a rationale,
that needs to be stated in the commit message.

> +
> +	return 0;
>  }
>  
>  static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
> @@ -1448,7 +1464,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
>  
>  	{ SYS_DESC(SYS_MDRAR_EL1), trap_raz_wi },
>  	{ SYS_DESC(SYS_OSLAR_EL1), trap_raz_wi },
> -	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1 },
> +	{ SYS_DESC(SYS_OSLSR_EL1), trap_oslsr_el1, reset_val, OSLSR_EL1, 0x00000008,

Could we add mnemonics for this to <asm/sysreg.h>, e.g.

#define	OSLSR_EL1_OSLM_LOCK_NI			0
#define	OSLSR_EL1_OSLM_LOCK_IMPLEMENTED		BIT(3)

... and use that here for clarity?

Thanks,
Mark.

> +		.set_user = set_oslsr_el1, },
>  	{ SYS_DESC(SYS_OSDLR_EL1), trap_raz_wi },
>  	{ SYS_DESC(SYS_DBGPRCR_EL1), trap_raz_wi },
>  	{ SYS_DESC(SYS_DBGCLAIMSET_EL1), trap_raz_wi },
> @@ -1923,7 +1940,7 @@ static const struct sys_reg_desc cp14_regs[] = {
>  	{ Op1( 0), CRn( 1), CRm( 0), Op2( 4), trap_raz_wi },
>  	DBGBXVR(1),
>  	/* DBGOSLSR */
> -	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1 },
> +	{ Op1( 0), CRn( 1), CRm( 1), Op2( 4), trap_oslsr_el1, NULL, OSLSR_EL1 },
>  	DBGBXVR(2),
>  	DBGBXVR(3),
>  	/* DBGOSDLR */
> -- 
> 2.34.1.173.g76aa8bc2d0-goog
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
