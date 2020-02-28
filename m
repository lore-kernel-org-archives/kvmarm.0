Return-Path: <SRS0=iQbv=4Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B824C3F2D2
	for <kvmarm@archiver.kernel.org>; Fri, 28 Feb 2020 13:37:27 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8B02E24699
	for <kvmarm@archiver.kernel.org>; Fri, 28 Feb 2020 13:37:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8B02E24699
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9B524AF4E;
	Fri, 28 Feb 2020 08:37:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GH44OsesuuCT; Fri, 28 Feb 2020 08:37:24 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A21164AF53;
	Fri, 28 Feb 2020 08:37:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A6A934AF4E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Feb 2020 08:37:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hcgiCQkICSYu for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Feb 2020 08:37:22 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F1CD4AF4A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Feb 2020 08:37:22 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD0A431B;
 Fri, 28 Feb 2020 05:37:21 -0800 (PST)
Received: from arrakis.emea.arm.com (arrakis.cambridge.arm.com [10.1.196.71])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id
 5767B3F7B4; Fri, 28 Feb 2020 05:37:20 -0800 (PST)
Date: Fri, 28 Feb 2020 13:37:18 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: Re: [PATCH 12/18] arm64: kernel: Convert to modern annotations for
 assembly functions
Message-ID: <20200228133718.GB4019108@arrakis.emea.arm.com>
References: <20200218195842.34156-1-broonie@kernel.org>
 <20200218195842.34156-13-broonie@kernel.org>
 <CAKv+Gu9Bt93hCaOUrgtfYWp+BU4gheVf2Y==PXVyMZcCssRLQg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9Bt93hCaOUrgtfYWp+BU4gheVf2Y==PXVyMZcCssRLQg@mail.gmail.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>, Marc Zyngier <maz@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>, Mark Brown <broonie@kernel.org>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Will Deacon <will@kernel.org>, "David S. Miller" <davem@davemloft.net>,
 "open list:HARDWARE RANDOM NUMBER GENERATOR CORE"
 <linux-crypto@vger.kernel.org>
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

On Fri, Feb 28, 2020 at 01:41:21PM +0100, Ard Biesheuvel wrote:
> On Tue, 18 Feb 2020 at 21:02, Mark Brown <broonie@kernel.org> wrote:
> > In an effort to clarify and simplify the annotation of assembly functions
> > in the kernel new macros have been introduced. These replace ENTRY and
> > ENDPROC and also add a new annotation for static functions which previously
> > had no ENTRY equivalent. Update the annotations in the core kernel code to
> > the new macros.
> >
> > Signed-off-by: Mark Brown <broonie@kernel.org>
> > ---
> >  arch/arm64/kernel/cpu-reset.S                 |  4 +-
> >  arch/arm64/kernel/efi-entry.S                 |  4 +-
> >  arch/arm64/kernel/efi-rt-wrapper.S            |  4 +-
> >  arch/arm64/kernel/entry-fpsimd.S              | 20 ++++-----
> >  arch/arm64/kernel/hibernate-asm.S             | 16 +++----
> >  arch/arm64/kernel/hyp-stub.S                  | 20 ++++-----
> >  arch/arm64/kernel/probes/kprobes_trampoline.S |  4 +-
> >  arch/arm64/kernel/reloc_test_syms.S           | 44 +++++++++----------
> >  arch/arm64/kernel/relocate_kernel.S           |  4 +-
> >  arch/arm64/kernel/sleep.S                     | 12 ++---
> >  arch/arm64/kernel/smccc-call.S                |  8 ++--
> >  11 files changed, 70 insertions(+), 70 deletions(-)
> >
> ...
> > diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
> > index 304d5b02ca67..de6ced92950e 100644
> > --- a/arch/arm64/kernel/efi-entry.S
> > +++ b/arch/arm64/kernel/efi-entry.S
> > @@ -25,7 +25,7 @@
> >          * we want to be. The kernel image wants to be placed at TEXT_OFFSET
> >          * from start of RAM.
> >          */
> > -ENTRY(entry)
> > +SYM_CODE_START(entry)
> >         /*
> >          * Create a stack frame to save FP/LR with extra space
> >          * for image_addr variable passed to efi_entry().
> > @@ -117,4 +117,4 @@ efi_load_fail:
> >         ret
> >
> >  entry_end:
> > -ENDPROC(entry)
> > +SYM_CODE_END(entry)
> 
> This hunk is going to conflict badly with the EFI tree. I will
> incorporate this change for v5.7, so could you please just drop it
> from this patch?

I wonder whether it would be easier to merge all these patches at
5.7-rc1, once most of the major changes went in.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
