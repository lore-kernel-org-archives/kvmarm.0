Return-Path: <SRS0=1Hfd=EL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B9DC00A89
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 10:02:13 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C592D2074B
	for <kvmarm@archiver.kernel.org>; Thu,  5 Nov 2020 10:02:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rUiRwZ/O"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C592D2074B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linaro.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4180A4B62C;
	Thu,  5 Nov 2020 05:02:12 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linaro.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id s+cBMD4izW+v; Thu,  5 Nov 2020 05:02:07 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 427AC4B727;
	Thu,  5 Nov 2020 05:02:07 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92A894B721
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 05:02:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iIG2ek-n3qNy for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Nov 2020 05:02:04 -0500 (EST)
Received: from mail-io1-f67.google.com (mail-io1-f67.google.com
 [209.85.166.67])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4FD634B6B2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Nov 2020 05:02:04 -0500 (EST)
Received: by mail-io1-f67.google.com with SMTP id m9so1168861iox.10
 for <kvmarm@lists.cs.columbia.edu>; Thu, 05 Nov 2020 02:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=yhvUTRr/wMHYPJde/XaA3QlQoGwF3Vc7mcC1zaM9b3M=;
 b=rUiRwZ/OlT2zC2iPhKW4lBPsRJL4Ki+LTtlumGRaWURTOVdUuAcFuY8VUqa5BoJGC2
 l/q6x1GWGsXvLLnpZTR5iWNAuXA35Wb9b819MBFUrdgrpZAhz47huHzXNZN/6Gxthjn2
 gIcaCLJ5EMNLOMKfj5r+qL10Z/UEoUuF76TRARC+0wliWJOi5riEGYKgsc1BNroJE1e+
 h6GQTJkt93am/QYEn23okluX+9sjPrjiuX9GNhq5y+cDY8aMMmMy0IxkVmVaQo0J/axl
 TK3wK600YTxfWAwtzjoUtNDl0qxW0EMYgaKvSAvREDyNOdQUQPb+eP7cR+ZsZz364SjD
 0Qfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=yhvUTRr/wMHYPJde/XaA3QlQoGwF3Vc7mcC1zaM9b3M=;
 b=CLlxykeIEvzVYREH9/dlgl3MMUjYh5RGhgEkYf33XrkBGlsVNJ82m5eZ6N8OdYzbyD
 u9oiyKETUBVkeFJ6b4Vk4/Upwh5WcaqmBfuEzewKZPUSn6/HxRweyjWkHUlbpXzBZsR2
 Oi4THBrYlBg7CPTzqba8JnMLwkhDeF0IB3RWdYD0HJ73qLI4OORxaOHMrwI44OCoTlzR
 vyp7AzO6hc3H2yRX9m4D+9945uRPqQp810kJbK0wap6KCwar2xC42A4d2h/oNwm3Yvmn
 eAiyJhQ/Zdb9Vxuvar1nnT8n+3tAloJgB362PVbhby9hEs3npJ1zPykF5fwRDbe6h61q
 sVLQ==
X-Gm-Message-State: AOAM530pCSwJQ0zN09UfN2xH7qJnSJ39EK/iFaoLJ9u4FrHNOfFGH8bO
 Ebc6mhzxU+LSO8ddnX5PbbVBUtJUOqekgZZ285IO
X-Google-Smtp-Source: ABdhPJzh3zjjDSs4fl3RHXvgPXyXH8wRE85cKqJdYHOXaBMEdJzkqsb20MNwRwS9vIb/ggRZuI5/V8gUtuD7Uu0f5ME=
X-Received: by 2002:a02:cd15:: with SMTP id g21mr1351875jaq.25.1604570523600; 
 Thu, 05 Nov 2020 02:02:03 -0800 (PST)
MIME-Version: 1.0
References: <20201027172705.15181-1-alexandru.elisei@arm.com>
 <20201027172705.15181-10-alexandru.elisei@arm.com>
In-Reply-To: <20201027172705.15181-10-alexandru.elisei@arm.com>
From: Haibo Xu <haibo.xu@linaro.org>
Date: Thu, 5 Nov 2020 18:01:52 +0800
Message-ID: <CAJc+Z1F1aEU=-qiCdDD8GhS3bhFvuhgPqtqTbBHF3RZgwznHgA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 09/16] KVM: arm64: Use separate function for the
 mapping size in user_mem_abort()
To: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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

On Wed, 28 Oct 2020 at 01:26, Alexandru Elisei <alexandru.elisei@arm.com> wrote:
>
> user_mem_abort() is already a long and complex function, let's make it
> slightly easier to understand by abstracting the algorithm for choosing the
> stage 2 IPA entry size into its own function.
>
> This also makes it possible to reuse the code when guest SPE support will
> be added.
>

Better to mention that there is "No functional change"!

> Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
> ---
>  arch/arm64/kvm/mmu.c | 55 ++++++++++++++++++++++++++------------------
>  1 file changed, 33 insertions(+), 22 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 19aacc7d64de..c3c43555490d 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -738,12 +738,43 @@ transparent_hugepage_adjust(struct kvm_memory_slot *memslot,
>         return PAGE_SIZE;
>  }
>
> +static short stage2_max_pageshift(struct kvm_memory_slot *memslot,
> +                                 struct vm_area_struct *vma, hva_t hva,
> +                                 bool *force_pte)
> +{
> +       short pageshift;
> +
> +       *force_pte = false;
> +
> +       if (is_vm_hugetlb_page(vma))
> +               pageshift = huge_page_shift(hstate_vma(vma));
> +       else
> +               pageshift = PAGE_SHIFT;
> +
> +       if (memslot_is_logging(memslot) || (vma->vm_flags & VM_PFNMAP)) {
> +               *force_pte = true;
> +               pageshift = PAGE_SHIFT;
> +       }
> +
> +       if (pageshift == PUD_SHIFT &&
> +           !fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
> +               pageshift = PMD_SHIFT;
> +
> +       if (pageshift == PMD_SHIFT &&
> +           !fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
> +               *force_pte = true;
> +               pageshift = PAGE_SHIFT;
> +       }
> +
> +       return pageshift;
> +}
> +
>  static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                           struct kvm_memory_slot *memslot, unsigned long hva,
>                           unsigned long fault_status)
>  {
>         int ret = 0;
> -       bool write_fault, writable, force_pte = false;
> +       bool write_fault, writable, force_pte;
>         bool exec_fault;
>         bool device = false;
>         unsigned long mmu_seq;
> @@ -776,27 +807,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>                 return -EFAULT;
>         }
>
> -       if (is_vm_hugetlb_page(vma))
> -               vma_shift = huge_page_shift(hstate_vma(vma));
> -       else
> -               vma_shift = PAGE_SHIFT;
> -
> -       if (logging_active ||
> -           (vma->vm_flags & VM_PFNMAP)) {
> -               force_pte = true;
> -               vma_shift = PAGE_SHIFT;
> -       }
> -
> -       if (vma_shift == PUD_SHIFT &&
> -           !fault_supports_stage2_huge_mapping(memslot, hva, PUD_SIZE))
> -              vma_shift = PMD_SHIFT;
> -
> -       if (vma_shift == PMD_SHIFT &&
> -           !fault_supports_stage2_huge_mapping(memslot, hva, PMD_SIZE)) {
> -               force_pte = true;
> -               vma_shift = PAGE_SHIFT;
> -       }
> -
> +       vma_shift = stage2_max_pageshift(memslot, vma, hva, &force_pte);
>         vma_pagesize = 1UL << vma_shift;
>         if (vma_pagesize == PMD_SIZE || vma_pagesize == PUD_SIZE)
>                 fault_ipa &= ~(vma_pagesize - 1);
> --
> 2.29.1
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
