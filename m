Return-Path: <SRS0=ECKt=E6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E9C1C2D0E4
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 14:02:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BD56B206FB
	for <kvmarm@archiver.kernel.org>; Tue, 24 Nov 2020 14:02:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="vC8sTOzZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BD56B206FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 134844BB75;
	Tue, 24 Nov 2020 09:02:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 62B2VJVuLCAM; Tue, 24 Nov 2020 09:02:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 04EA54B9D6;
	Tue, 24 Nov 2020 09:02:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 009F64B975
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 09:02:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fO8qa8iBIGVd for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Nov 2020 09:02:39 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF5964B976
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 09:02:39 -0500 (EST)
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com
 [209.85.210.52])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 5EF0020866
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 14:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1606226558;
 bh=ueZAeL04uckNDd28QddIVeKofdi8RG1oj0UX85IE2CE=;
 h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
 b=vC8sTOzZZNhg0Eut1OB3+3j1fYyVtJB/BwkJLsmoZE8soWwi8EV/YlziB2z6SQt1r
 GRglbic3RmwEJsk8SNqziyObNRJhQz4wjwM7ap7M1iYtqXH3L+7E8J39UySaZUYoOw
 jDRC9hUL4e+pr0/QoqMVAgvvOSr7q4VutMoHwAxk=
Received: by mail-ot1-f52.google.com with SMTP id 79so19379914otc.7
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Nov 2020 06:02:38 -0800 (PST)
X-Gm-Message-State: AOAM532cnIZ+ra7B47mVemR6nefZ9yxAW7xvyS/20QSupgfKgL7JYzeE
 HCo29YFsGzBS9kImHhw8x+XJFeji6epFkiVqwPA=
X-Google-Smtp-Source: ABdhPJyXuqCDGEixCef5QdG9nSVSccAFKPg6VhyzlBBNguekpVHckOJu4TqCBPaYkjdEvbEzzJJkV+TNyWRI0r6VOjQ=
X-Received: by 2002:a9d:62c1:: with SMTP id z1mr3359853otk.108.1606226557554; 
 Tue, 24 Nov 2020 06:02:37 -0800 (PST)
MIME-Version: 1.0
References: <20201119162543.78001-1-dbrazdil@google.com>
 <20201119162543.78001-4-dbrazdil@google.com>
In-Reply-To: <20201119162543.78001-4-dbrazdil@google.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Tue, 24 Nov 2020 15:02:26 +0100
X-Gmail-Original-Message-ID: <CAMj1kXH84+aOa2jGOjQ62x6H_yB=0LtrVpHihtV31v=V5nR2Rg@mail.gmail.com>
Message-ID: <CAMj1kXH84+aOa2jGOjQ62x6H_yB=0LtrVpHihtV31v=V5nR2Rg@mail.gmail.com>
Subject: Re: [RFC PATCH 3/6] kvm: arm64: Fix up RELR relocation in hyp
 code/data
To: David Brazdil <dbrazdil@google.com>
Cc: Android Kernel Team <kernel-team@android.com>,
 Marc Zyngier <maz@kernel.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>
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

On Thu, 19 Nov 2020 at 17:25, David Brazdil <dbrazdil@google.com> wrote:
>
> The arm64 kernel also supports packing of relocation data using the RELR
> format. Implement a parser of RELR data and fixup the relocations using
> the same infra as RELA relocs.
>
> Signed-off-by: David Brazdil <dbrazdil@google.com>
> ---
>  arch/arm64/kvm/va_layout.c | 41 ++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>
> diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
> index b80fab974896..7f45a98eacfd 100644
> --- a/arch/arm64/kvm/va_layout.c
> +++ b/arch/arm64/kvm/va_layout.c
> @@ -145,6 +145,43 @@ static void __fixup_hyp_rela(void)
>                 __fixup_hyp_rel(rel[i].r_offset);
>  }
>
> +#ifdef CONFIG_RELR

Please prefer IS_ENABLED() [below] if the code in question can compile
(but perhaps not link) correctly when the symbol is not set.

> +static void __fixup_hyp_relr(void)

__init ?

> +{
> +       u64 *rel, *end;
> +
> +       rel = (u64*)(kimage_vaddr + __load_elf_u64(__relr_offset));
> +       end = rel + (__load_elf_u64(__relr_size) / sizeof(*rel));
> +

The reason for this little dance with the offset and size exists
because the initial relocation routine runs from the ID mapping, but
the relocation fixups are performed via the kernel's VA mapping, as
the ID mapping does not cover the entire image. So simple adrp/add
pairs aren't suitable there.

In this case (as well as in the previous patch, btw), that problem
does not exist, and so I think we should be able to simply define
start and end markers inside the .rela sections, and reference them
here as symbols with external linkage (which ensures that they are
referenced relatively, although you could add in a
__attribute__((visibility("hidden"))) for good measure)



> +       while (rel < end) {
> +               unsigned n;
> +               u64 addr = *(rel++);

Parens are redundant here (and below)

> +
> +               /* Address must not have the LSB set. */
> +               BUG_ON(addr & BIT(0));
> +
> +               /* Fix up the first address of the chain. */
> +               __fixup_hyp_rel(addr);
> +
> +               /*
> +                * Loop over bitmaps, i.e. as long as words' LSB is 1.
> +                * Each bit (ordered from LSB to MSB) represents one word from
> +                * the last full address (exclusive). If the corresponding bit
> +                * is 1, there is a relative relocation on that word.
> +                */
> +               for (n = 0; rel < end && (*rel & BIT(0)); n++) {
> +                       unsigned i;
> +                       u64 bitmap = *(rel++);
> +
> +                       for (i = 1; i < 64; ++i) {
> +                               if ((bitmap & BIT(i)))
> +                                       __fixup_hyp_rel(addr + 8 * (63 * n + i));
> +                       }
> +               }
> +       }
> +}
> +#endif
> +
>  /*
>   * The kernel relocated pointers to kernel VA. Iterate over relocations in
>   * the hypervisor ELF sections and convert them to hyp VA. This avoids the
> @@ -156,6 +193,10 @@ __init void kvm_fixup_hyp_relocations(void)
>                 return;
>
>         __fixup_hyp_rela();
> +
> +#ifdef CONFIG_RELR
> +       __fixup_hyp_relr();
> +#endif
>  }
>
>  static u32 compute_instruction(int n, u32 rd, u32 rn)
> --
> 2.29.2.299.gdc1121823c-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
