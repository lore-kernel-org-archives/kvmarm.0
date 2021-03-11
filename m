Return-Path: <SRS0=mhFy=IJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D19C433DB
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 11:35:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 318D564FCD
	for <kvmarm@archiver.kernel.org>; Thu, 11 Mar 2021 11:35:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 318D564FCD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 912E44B5C0;
	Thu, 11 Mar 2021 06:35:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9qpO60x0J5xp; Thu, 11 Mar 2021 06:35:38 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5835F4B5DB;
	Thu, 11 Mar 2021 06:35:38 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 30C384B5C0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 06:35:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2k1WHo+4vT-U for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Mar 2021 06:35:35 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AA5FF4B5B7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Mar 2021 06:35:35 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 32AC431B;
 Thu, 11 Mar 2021 03:35:35 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.54.221])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B82053F793;
 Thu, 11 Mar 2021 03:35:32 -0800 (PST)
Date: Thu, 11 Mar 2021 11:35:29 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Will Deacon <will@kernel.org>
Subject: Re: [PATCH 3/4] KVM: arm64: Rename SCTLR_ELx_FLAGS to SCTLR_EL2_FLAGS
Message-ID: <20210311113529.GD37303@C02TD0UTHF1T.local>
References: <20210310152656.3821253-1-maz@kernel.org>
 <20210310152656.3821253-4-maz@kernel.org>
 <20210310154625.GA29738@willie-the-truck>
 <874khjxade.wl-maz@kernel.org>
 <20210310161546.GC29834@willie-the-truck>
 <87zgzagaqq.wl-maz@kernel.org>
 <20210310182022.GA29969@willie-the-truck>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20210310182022.GA29969@willie-the-truck>
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

On Wed, Mar 10, 2021 at 06:20:22PM +0000, Will Deacon wrote:
> On Wed, Mar 10, 2021 at 05:49:17PM +0000, Marc Zyngier wrote:
> > On Wed, 10 Mar 2021 16:15:47 +0000,
> > Will Deacon <will@kernel.org> wrote:
> > > On Wed, Mar 10, 2021 at 04:05:17PM +0000, Marc Zyngier wrote:
> > > > On Wed, 10 Mar 2021 15:46:26 +0000,
> > > > Will Deacon <will@kernel.org> wrote:
> > > > > On Wed, Mar 10, 2021 at 03:26:55PM +0000, Marc Zyngier wrote:
> > > > > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > > > > > index 4eb584ae13d9..7423f4d961a4 100644
> > > > > > --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > > > > > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > > > > > @@ -122,7 +122,7 @@ alternative_else_nop_endif
> > > > > >  	 * as well as the EE bit on BE. Drop the A flag since the compiler
> > > > > >  	 * is allowed to generate unaligned accesses.
> > > > > >  	 */
> > > > > > -	mov_q	x0, (SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
> > > > > > +	mov_q	x0, (SCTLR_EL2_RES1 | (SCTLR_EL2_FLAGS & ~SCTLR_ELx_A))
> > > > > 
> > > > > Can we just drop SCTLR_ELx_A from SCTLR_EL2_FLAGS instead of clearing it
> > > > > here?
> > > > 
> > > > Absolutely. That'd actually be an improvement.
> > > 
> > > In fact, maybe just define INIT_SCTLR_EL2_MMU_ON to mirror what we do for
> > > EL1 (i.e. including the RES1 bits) and then use that here?
> > 
> > Like this?
> > 
> > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > index dfd4edbfe360..593b9bf91bbd 100644
> > --- a/arch/arm64/include/asm/sysreg.h
> > +++ b/arch/arm64/include/asm/sysreg.h
> > @@ -579,9 +579,6 @@
> >  #define SCTLR_ELx_A	(BIT(1))
> >  #define SCTLR_ELx_M	(BIT(0))
> >  
> > -#define SCTLR_ELx_FLAGS	(SCTLR_ELx_M  | SCTLR_ELx_A | SCTLR_ELx_C | \
> > -			 SCTLR_ELx_SA | SCTLR_ELx_I | SCTLR_ELx_IESB)
> > -
> >  /* SCTLR_EL2 specific flags. */
> >  #define SCTLR_EL2_RES1	((BIT(4))  | (BIT(5))  | (BIT(11)) | (BIT(16)) | \
> >  			 (BIT(18)) | (BIT(22)) | (BIT(23)) | (BIT(28)) | \
> > @@ -593,6 +590,10 @@
> >  #define ENDIAN_SET_EL2		0
> >  #endif
> >  
> > +#define INIT_SCTLR_EL2_MMU_ON						\
> > +	(SCTLR_ELx_M  | SCTLR_ELx_C | SCTLR_ELx_SA | SCTLR_ELx_I |	\
> > +	 SCTLR_ELx_IESB | ENDIAN_SET_EL2 | SCTLR_EL2_RES1)
> > +
> >  #define INIT_SCTLR_EL2_MMU_OFF \
> >  	(SCTLR_EL2_RES1 | ENDIAN_SET_EL2)
> >  
> > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > index 4eb584ae13d9..2e16b2098bbd 100644
> > --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > @@ -117,13 +117,7 @@ alternative_else_nop_endif
> >  	tlbi	alle2
> >  	dsb	sy
> >  
> > -	/*
> > -	 * Preserve all the RES1 bits while setting the default flags,
> > -	 * as well as the EE bit on BE. Drop the A flag since the compiler
> > -	 * is allowed to generate unaligned accesses.
> > -	 */
> > -	mov_q	x0, (SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
> > -CPU_BE(	orr	x0, x0, #SCTLR_ELx_EE)
> > +	mov_q	x0, INIT_SCTLR_EL2_MMU_ON
> >  alternative_if ARM64_HAS_ADDRESS_AUTH
> >  	mov_q	x1, (SCTLR_ELx_ENIA | SCTLR_ELx_ENIB | \
> >  		     SCTLR_ELx_ENDA | SCTLR_ELx_ENDB)
> 
> Beautiful!
> 
> With that, you can have my ack on the whole series:
> 
> Acked-by: Will Deacon <will@kernel.org>

FWIW, likewise:

Acked-by: Mark Rutland <nark.rutland@arm.com>

This is really nice!

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
