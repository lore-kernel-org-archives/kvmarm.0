Return-Path: <SRS0=ioR1=HG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60D2BC433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 09:34:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B5D5D64F55
	for <kvmarm@archiver.kernel.org>; Thu,  4 Feb 2021 09:34:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B5D5D64F55
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B05E4B31E;
	Thu,  4 Feb 2021 04:34:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gqp5-xUxToSJ; Thu,  4 Feb 2021 04:34:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1CCA4B29F;
	Thu,  4 Feb 2021 04:34:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1F7B44B29F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 04:34:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XCM7dlrr+2YS for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Feb 2021 04:34:35 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A6CD94B29C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Feb 2021 04:34:35 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD4EF64F51;
 Thu,  4 Feb 2021 09:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1612431274;
 bh=JZn0fWEQP3IOCgy3diGQCOjnTYrAIwK2aSJ/VhcnDHM=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=vFDndyt6NSQFwscvlNNJUIa065sFq6KD/ieVgiNPLfJh5r4i2Na3h7tdfUt6/eyq5
 qLTNDehWSqu7ChjS6c30pzr53GYt1roQYniZzM9GivjclpIqHJqknYU726isCkL+AO
 K0ksJUjjLxA9sF+ccYzunzBUaC352aNqGhwISRRaNZOoB0wcXiXoXz0qgXh55HFVml
 sCHonAfwjt1ZIIdXRn4q6Udl/4tfIdczeofFFY1mnNn3Jum9LihYqkmC5XZdOOm0BI
 i4uHtNAlLTbQih+2EYV5J3GhSSq9XS/yQU64zZXfV5LdIyktWczSSH1O/vED1tPXuv
 JFNnc4v2x3ZoA==
Date: Thu, 4 Feb 2021 09:34:28 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 06/21] arm64: Move VHE-specific SPE setup to
 mutate_to_vhe()
Message-ID: <20210204093427.GB20244@willie-the-truck>
References: <20210201115637.3123740-1-maz@kernel.org>
 <20210201115637.3123740-7-maz@kernel.org>
 <20210203211319.GA19694@willie-the-truck>
 <a660fd06d43451b4693fbb65f2ee1b56@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <a660fd06d43451b4693fbb65f2ee1b56@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Prasad Sodagudi <psodagud@codeaurora.org>,
 Srinivas Ramana <sramana@codeaurora.org>,
 Catalin Marinas <catalin.marinas@arm.com>, linux-kernel@vger.kernel.org,
 Ard Biesheuvel <ardb@kernel.org>, Ajay Patil <pajay@qti.qualcomm.com>,
 kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

On Thu, Feb 04, 2021 at 09:30:08AM +0000, Marc Zyngier wrote:
> Hi Will,
> 
> On 2021-02-03 21:13, Will Deacon wrote:
> > Hi Marc,
> > 
> > On Mon, Feb 01, 2021 at 11:56:22AM +0000, Marc Zyngier wrote:
> > > There isn't much that a VHE kernel needs on top of whatever has
> > > been done for nVHE, so let's move the little we need to the
> > > VHE stub (the SPE setup), and drop the init_el2_state macro.
> > > 
> > > No expected functional change.
> > > 
> > > Signed-off-by: Marc Zyngier <maz@kernel.org>
> > > Acked-by: David Brazdil <dbrazdil@google.com>
> > > Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> > > ---
> > >  arch/arm64/kernel/hyp-stub.S | 28 +++++++++++++++++++++++++---
> > >  1 file changed, 25 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/arch/arm64/kernel/hyp-stub.S
> > > b/arch/arm64/kernel/hyp-stub.S
> > > index 373ed2213e1d..6b5c73cf9d52 100644
> > > --- a/arch/arm64/kernel/hyp-stub.S
> > > +++ b/arch/arm64/kernel/hyp-stub.S
> > > @@ -92,9 +92,6 @@ SYM_CODE_START_LOCAL(mutate_to_vhe)
> > >  	msr	hcr_el2, x0
> > >  	isb
> > > 
> > > -	// Doesn't do much on VHE, but still, worth a shot
> > > -	init_el2_state vhe
> > > -
> > >  	// Use the EL1 allocated stack, per-cpu offset
> > >  	mrs	x0, sp_el1
> > >  	mov	sp, x0
> > > @@ -107,6 +104,31 @@ SYM_CODE_START_LOCAL(mutate_to_vhe)
> > >  	mrs_s	x0, SYS_VBAR_EL12
> > >  	msr	vbar_el1, x0
> > > 
> > > +	// Fixup SPE configuration, if supported...
> > > +	mrs	x1, id_aa64dfr0_el1
> > > +	ubfx	x1, x1, #ID_AA64DFR0_PMSVER_SHIFT, #4
> > > +	mov	x2, xzr
> > > +	cbz	x1, skip_spe
> > > +
> > > +	// ... and not owned by EL3
> > > +	mrs_s	x0, SYS_PMBIDR_EL1
> > > +	and	x0, x0, #(1 << SYS_PMBIDR_EL1_P_SHIFT)
> > > +	cbnz	x0, skip_spe
> > > +
> > > +	// Let the SPE driver in control of the sampling
> > > +	mrs_s	x0, SYS_PMSCR_EL1
> > > +	bic	x0, x0, #(1 << SYS_PMSCR_EL2_PCT_SHIFT)
> > > +	bic	x0, x0, #(1 << SYS_PMSCR_EL2_PA_SHIFT)
> > > +	msr_s	SYS_PMSCR_EL1, x0
> > 
> > Why do we need to touch pmscr_el1 at all? The SPE driver should take
> > care of
> > that, no? If you drop the pmscr_el1 accesses, I think you can drop the
> > pmbidr_el1 check as well.
> 
> That's definitely a brain fart, and is what we need on the nVHE path,
> not here. Doing the same thing twice isn't exactly helpful.
> 
> > And actually, then why even check dfr0? Doing the
> > bic for the mdcr_el1.e2pb bits is harmless.
> > 
> > > +	mov	x2, #MDCR_EL2_TPMS
> > > +
> > > +skip_spe:
> > > +	// For VHE, use EL2 translation and disable access from EL1
> > > +	mrs	x0, mdcr_el2
> > > +	bic	x0, x0, #(MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT)
> > > +	orr	x0, x0, x2
> > > +	msr	mdcr_el2, x0
> > 
> > Doesn't this undo the setting of mdcr_el2.hpmn if SPE is not present or
> > unavailable? (This wouldn't be an issue if we removed the skip_spe paths
> > altogether).
> 
> I don't think it does. We only clear the E2PB bits (harmless, as you point
> out above), and OR something that is either 0 (no SPE) or MDCR_EL2_TPMS.
> In any case, the HPMN bits are preserved (having been set during the nVHE
> setup).

Duh, OR not AND. Yes, sorry.

> I think the following patch addresses the above issue, which I'll squash
> with the original patch. Please shout if I missed anything.
> 
> Thanks,
> 
>         M.
> 
> diff --git a/arch/arm64/kernel/hyp-stub.S b/arch/arm64/kernel/hyp-stub.S
> index aa7e8d592295..3e08dcc924b5 100644
> --- a/arch/arm64/kernel/hyp-stub.S
> +++ b/arch/arm64/kernel/hyp-stub.S
> @@ -115,29 +115,9 @@ SYM_CODE_START_LOCAL(mutate_to_vhe)
>  	mrs_s	x0, SYS_VBAR_EL12
>  	msr	vbar_el1, x0
> 
> -	// Fixup SPE configuration, if supported...
> -	mrs	x1, id_aa64dfr0_el1
> -	ubfx	x1, x1, #ID_AA64DFR0_PMSVER_SHIFT, #4
> -	mov	x2, xzr
> -	cbz	x1, skip_spe
> -
> -	// ... and not owned by EL3
> -	mrs_s	x0, SYS_PMBIDR_EL1
> -	and	x0, x0, #(1 << SYS_PMBIDR_EL1_P_SHIFT)
> -	cbnz	x0, skip_spe
> -
> -	// Let the SPE driver in control of the sampling
> -	mrs_s	x0, SYS_PMSCR_EL1
> -	bic	x0, x0, #(1 << SYS_PMSCR_EL2_PCT_SHIFT)
> -	bic	x0, x0, #(1 << SYS_PMSCR_EL2_PA_SHIFT)
> -	msr_s	SYS_PMSCR_EL1, x0
> -	mov	x2, #MDCR_EL2_TPMS
> -
> -skip_spe:
> -	// For VHE, use EL2 translation and disable access from EL1
> +	// Use EL2 translations for SPE and disable access from EL1
>  	mrs	x0, mdcr_el2
>  	bic	x0, x0, #(MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT)
> -	orr	x0, x0, x2
>  	msr	mdcr_el2, x0

Looks a tonne better, thanks! Be nice if somebody could test it for us.

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
