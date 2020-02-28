Return-Path: <SRS0=iQbv=4Q=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A421C3F2D3
	for <kvmarm@archiver.kernel.org>; Fri, 28 Feb 2020 12:41:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C39FC246A3
	for <kvmarm@archiver.kernel.org>; Fri, 28 Feb 2020 12:41:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H32BlYxS"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C39FC246A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 399114AFE8;
	Fri, 28 Feb 2020 07:41:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ug7pZ14Pbt47; Fri, 28 Feb 2020 07:41:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1547B4AF07;
	Fri, 28 Feb 2020 07:41:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09E0C4AFC5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Feb 2020 07:41:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LpLwhpiJswrC for <kvmarm@lists.cs.columbia.edu>;
 Fri, 28 Feb 2020 07:41:33 -0500 (EST)
Received: from mail-wr1-f66.google.com (mail-wr1-f66.google.com
 [209.85.221.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E940F4AF86
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Feb 2020 07:41:32 -0500 (EST)
Received: by mail-wr1-f66.google.com with SMTP id r7so2820564wro.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 28 Feb 2020 04:41:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=XBS4xJeronFByco7hvqXXCJEpIN3x2l+h2xMS+Qu5VY=;
 b=H32BlYxSp7yeOYKrV+18Kq0+YS+hSAOrzWo3T6WyqnHTkd0LkP8qZjWhS1n5//SwFO
 7yqusqGjdG8VA3A/7qaHEYn0+6hAzJjGiZP0lNj1456ePdSkYU7BMpxhz6GoBcLHXIwK
 gOzyaCW0Xns5tOdyob4OhuPjbYcfHcOq8e2QURnGhwq0UeBw+sOpJ/73uaprMNuuTXF2
 iLn1W4nYHLZRS1rRnPYzYVj4gQhwMs+x+nlNaP6uYErNFT5JWSv4K6IuZx8CbGFP59Z9
 7CKW+egRaz8fyaTmNtvzCa3R7Hm0PSt6mS5JhRgXArF0qCOJnOgLCizqVEszVt+wk5Y1
 gojA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=XBS4xJeronFByco7hvqXXCJEpIN3x2l+h2xMS+Qu5VY=;
 b=M3g5bpPAYJ91KQcKXWEyTksGnsthwdigQoYIH+AYSKszEqVwS+j6GSG/Tn9hEMWtyk
 9J6M6Wljb+6w5WoIRKMaJxnef1Y+/iLlPUwt7pQl752d0hHZj0Y6QrvYDrsJjO+grN4J
 XHFocfZmj4+u8lUOPv6NECmJ+Tt0S8udSjg9HCQONl8NWk0HmmK2MSj98+jvq9/dIQPU
 nBOBQbctoj5Ra0b8FEkMQAMRw913M+SeMUIaXYPVeuslk19IGYFzTf5tvgRSjNClu8TR
 ilSGwI/hvmNeGSxlyCsGu6gSOVOzRE3sHC0HmvgKo4vRRKOQbLh9PRayVsvQJ9nwDgyH
 pQKQ==
X-Gm-Message-State: APjAAAVdEcOryu89jIXR21BMvQGqq6Ve6sLD+ioAdzZffCJRTKmNxt00
 d9Utl62QPbfIks3mEg7JUIXJCMFoOTAHVpjRJfa6HA==
X-Google-Smtp-Source: APXvYqycHr5BpR7YsHapDHRDF5PvvknfNJGfaHFydphDQrJgW+V3mYRdB8mumbWLaqIy7fTmjqZ4VZ0ui5GjrBMPKsg=
X-Received: by 2002:adf:f84a:: with SMTP id d10mr4811332wrq.208.1582893691834; 
 Fri, 28 Feb 2020 04:41:31 -0800 (PST)
MIME-Version: 1.0
References: <20200218195842.34156-1-broonie@kernel.org>
 <20200218195842.34156-13-broonie@kernel.org>
In-Reply-To: <20200218195842.34156-13-broonie@kernel.org>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 28 Feb 2020 13:41:21 +0100
Message-ID: <CAKv+Gu9Bt93hCaOUrgtfYWp+BU4gheVf2Y==PXVyMZcCssRLQg@mail.gmail.com>
Subject: Re: [PATCH 12/18] arm64: kernel: Convert to modern annotations for
 assembly functions
To: Mark Brown <broonie@kernel.org>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
 Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm <kvmarm@lists.cs.columbia.edu>,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 "David S. Miller" <davem@davemloft.net>,
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

Hi Mark,

On Tue, 18 Feb 2020 at 21:02, Mark Brown <broonie@kernel.org> wrote:
>
> In an effort to clarify and simplify the annotation of assembly functions
> in the kernel new macros have been introduced. These replace ENTRY and
> ENDPROC and also add a new annotation for static functions which previously
> had no ENTRY equivalent. Update the annotations in the core kernel code to
> the new macros.
>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  arch/arm64/kernel/cpu-reset.S                 |  4 +-
>  arch/arm64/kernel/efi-entry.S                 |  4 +-
>  arch/arm64/kernel/efi-rt-wrapper.S            |  4 +-
>  arch/arm64/kernel/entry-fpsimd.S              | 20 ++++-----
>  arch/arm64/kernel/hibernate-asm.S             | 16 +++----
>  arch/arm64/kernel/hyp-stub.S                  | 20 ++++-----
>  arch/arm64/kernel/probes/kprobes_trampoline.S |  4 +-
>  arch/arm64/kernel/reloc_test_syms.S           | 44 +++++++++----------
>  arch/arm64/kernel/relocate_kernel.S           |  4 +-
>  arch/arm64/kernel/sleep.S                     | 12 ++---
>  arch/arm64/kernel/smccc-call.S                |  8 ++--
>  11 files changed, 70 insertions(+), 70 deletions(-)
>
...
> diff --git a/arch/arm64/kernel/efi-entry.S b/arch/arm64/kernel/efi-entry.S
> index 304d5b02ca67..de6ced92950e 100644
> --- a/arch/arm64/kernel/efi-entry.S
> +++ b/arch/arm64/kernel/efi-entry.S
> @@ -25,7 +25,7 @@
>          * we want to be. The kernel image wants to be placed at TEXT_OFFSET
>          * from start of RAM.
>          */
> -ENTRY(entry)
> +SYM_CODE_START(entry)
>         /*
>          * Create a stack frame to save FP/LR with extra space
>          * for image_addr variable passed to efi_entry().
> @@ -117,4 +117,4 @@ efi_load_fail:
>         ret
>
>  entry_end:
> -ENDPROC(entry)
> +SYM_CODE_END(entry)

This hunk is going to conflict badly with the EFI tree. I will
incorporate this change for v5.7, so could you please just drop it
from this patch?
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
