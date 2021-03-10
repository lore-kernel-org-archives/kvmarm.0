Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B30F7C433DB
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 18:20:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2CB2064FB5
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 18:20:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2CB2064FB5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C12E44B55E;
	Wed, 10 Mar 2021 13:20:33 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DejjYrX9LUhA; Wed, 10 Mar 2021 13:20:31 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C7E4A4B53A;
	Wed, 10 Mar 2021 13:20:31 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25CB34B531
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 13:20:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lKk+tCWXBv-u for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Mar 2021 13:20:30 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 19B504B52D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Mar 2021 13:20:30 -0500 (EST)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6D4DD64FB9;
 Wed, 10 Mar 2021 18:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1615400428;
 bh=o9Fr0+5LSL0K2coftyVU1nfPIgKPCOHLaGmkCg1KFn4=;
 h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
 b=nJLHR742EWNFtwq560ZDPG2Nkp0DcCwld9fp3YmokDtdvNlzP7fNpLQJK0yOTX3qy
 rygT/CdVYiDj+Enu5m90Uu4lHuURsGAcYnroBwF0N63XPrL8oJ0xLJoQ7YjeQboJOD
 ivS5wrSoOqHNAgaJy/V4nEXcY9TAMrlaeODSb9jys/8Pgsd0lJAhmVxP3VJkyTS3Lk
 s7+I5Sl1iVbndjoGCcNjKYCZtDagssBJureMCw0+eXtqix+wvQqwIRFKILzR3ae+9b
 Wze+zudmcdLCi7ae4moELxGRBSpskH+0AVcGY/CiAN48Y894asq1ChfcwJ5fBa7SUJ
 loTu/OsH6hiJA==
Date: Wed, 10 Mar 2021 18:20:22 +0000
From: Will Deacon <will@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH 3/4] KVM: arm64: Rename SCTLR_ELx_FLAGS to SCTLR_EL2_FLAGS
Message-ID: <20210310182022.GA29969@willie-the-truck>
References: <20210310152656.3821253-1-maz@kernel.org>
 <20210310152656.3821253-4-maz@kernel.org>
 <20210310154625.GA29738@willie-the-truck>
 <874khjxade.wl-maz@kernel.org>
 <20210310161546.GC29834@willie-the-truck>
 <87zgzagaqq.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87zgzagaqq.wl-maz@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: kvm@vger.kernel.org, kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
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

On Wed, Mar 10, 2021 at 05:49:17PM +0000, Marc Zyngier wrote:
> On Wed, 10 Mar 2021 16:15:47 +0000,
> Will Deacon <will@kernel.org> wrote:
> > On Wed, Mar 10, 2021 at 04:05:17PM +0000, Marc Zyngier wrote:
> > > On Wed, 10 Mar 2021 15:46:26 +0000,
> > > Will Deacon <will@kernel.org> wrote:
> > > > On Wed, Mar 10, 2021 at 03:26:55PM +0000, Marc Zyngier wrote:
> > > > > diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > > > > index 4eb584ae13d9..7423f4d961a4 100644
> > > > > --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > > > > +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> > > > > @@ -122,7 +122,7 @@ alternative_else_nop_endif
> > > > >  	 * as well as the EE bit on BE. Drop the A flag since the compiler
> > > > >  	 * is allowed to generate unaligned accesses.
> > > > >  	 */
> > > > > -	mov_q	x0, (SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
> > > > > +	mov_q	x0, (SCTLR_EL2_RES1 | (SCTLR_EL2_FLAGS & ~SCTLR_ELx_A))
> > > > 
> > > > Can we just drop SCTLR_ELx_A from SCTLR_EL2_FLAGS instead of clearing it
> > > > here?
> > > 
> > > Absolutely. That'd actually be an improvement.
> > 
> > In fact, maybe just define INIT_SCTLR_EL2_MMU_ON to mirror what we do for
> > EL1 (i.e. including the RES1 bits) and then use that here?
> 
> Like this?
> 
> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> index dfd4edbfe360..593b9bf91bbd 100644
> --- a/arch/arm64/include/asm/sysreg.h
> +++ b/arch/arm64/include/asm/sysreg.h
> @@ -579,9 +579,6 @@
>  #define SCTLR_ELx_A	(BIT(1))
>  #define SCTLR_ELx_M	(BIT(0))
>  
> -#define SCTLR_ELx_FLAGS	(SCTLR_ELx_M  | SCTLR_ELx_A | SCTLR_ELx_C | \
> -			 SCTLR_ELx_SA | SCTLR_ELx_I | SCTLR_ELx_IESB)
> -
>  /* SCTLR_EL2 specific flags. */
>  #define SCTLR_EL2_RES1	((BIT(4))  | (BIT(5))  | (BIT(11)) | (BIT(16)) | \
>  			 (BIT(18)) | (BIT(22)) | (BIT(23)) | (BIT(28)) | \
> @@ -593,6 +590,10 @@
>  #define ENDIAN_SET_EL2		0
>  #endif
>  
> +#define INIT_SCTLR_EL2_MMU_ON						\
> +	(SCTLR_ELx_M  | SCTLR_ELx_C | SCTLR_ELx_SA | SCTLR_ELx_I |	\
> +	 SCTLR_ELx_IESB | ENDIAN_SET_EL2 | SCTLR_EL2_RES1)
> +
>  #define INIT_SCTLR_EL2_MMU_OFF \
>  	(SCTLR_EL2_RES1 | ENDIAN_SET_EL2)
>  
> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> index 4eb584ae13d9..2e16b2098bbd 100644
> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
> @@ -117,13 +117,7 @@ alternative_else_nop_endif
>  	tlbi	alle2
>  	dsb	sy
>  
> -	/*
> -	 * Preserve all the RES1 bits while setting the default flags,
> -	 * as well as the EE bit on BE. Drop the A flag since the compiler
> -	 * is allowed to generate unaligned accesses.
> -	 */
> -	mov_q	x0, (SCTLR_EL2_RES1 | (SCTLR_ELx_FLAGS & ~SCTLR_ELx_A))
> -CPU_BE(	orr	x0, x0, #SCTLR_ELx_EE)
> +	mov_q	x0, INIT_SCTLR_EL2_MMU_ON
>  alternative_if ARM64_HAS_ADDRESS_AUTH
>  	mov_q	x1, (SCTLR_ELx_ENIA | SCTLR_ELx_ENIB | \
>  		     SCTLR_ELx_ENDA | SCTLR_ELx_ENDB)

Beautiful!

With that, you can have my ack on the whole series:

Acked-by: Will Deacon <will@kernel.org>

Will
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
