Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6C57C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 29 Mar 2022 08:51:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC91349F19;
	Tue, 29 Mar 2022 04:51:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rq7rZmyhNXOM; Tue, 29 Mar 2022 04:51:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB2D749EFF;
	Tue, 29 Mar 2022 04:51:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3970149EEE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 04:51:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CCod+5EMlWAF for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Mar 2022 04:51:15 -0400 (EDT)
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com
 [209.85.160.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E8C5949EEB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 04:51:14 -0400 (EDT)
Received: by mail-oa1-f41.google.com with SMTP id
 586e51a60fabf-d6ca46da48so17968491fac.12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Mar 2022 01:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=J/eRk2ImRzThvCuDLwHzf4xR9PAnPCdQO7PLIDrEyk0=;
 b=nnyN0eihHxUrf+TwB7MLpcpSf2tlQiGtoqCXDg7me/90+B5CbLAw5kc3Bi+PsvIN08
 G/8PYgbLWcDtMgLWGyssOW3y5RdhVrfh4XcLmCEEtCPfd18v+MUQRD5U8f3uChLsoBTU
 0xzbkVUbS8C+VVZk3Ug5I7bK/oK7wYc1FbF0vlj4egoDQdFVPOrIymd7LKW6fye9Rm+r
 ucXN1UdGW7STFAWgSHaE9lZ0OH0Un4+/C+b1NrE/lDou7KCXORuAhRPGPlQEv1hCgMia
 E4YNeclPGTx8FxuxSLv2kOdtOiNPxd/YwlTD6QgLVtPoNvf+1rR2rNKgToxFg624S4Lh
 3Ttg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=J/eRk2ImRzThvCuDLwHzf4xR9PAnPCdQO7PLIDrEyk0=;
 b=AWMoTgIkoi7dWr4CyetbU6L0Xp2TXReBX3WV7znbUS1SH+9UHVJi2RpeA42mXTKWuu
 kDbqpI51rbgzOhOf7tdNY2JNdOVhHYe+h09IWxKdSpX1IZob/QGF23I12Qgm/Kw/vwg3
 Cq1SHkcgDHwzx4P9rlRZsRyheJawS/b1WEuhd2iuuMUA7etnjK9TIrkDrbs9BiDz10ys
 sqljy1bksVsCuW31ks0XmJ23BH/IPPsgDxs8ovmi2nanjZp0hd6K3fwq8aDXtMdQZ6pn
 TrgQ07NNXOgrcwDJ5Iepfw3qpkpU8+E1fRFcPUZopkDbLDx/BwmpZBsHVJnpgCQ0IchN
 ETSQ==
X-Gm-Message-State: AOAM531PSoY2sqetehV+lSaMuZ+dhYkOpAMlnenRT3sV8IOUYDvP4MZu
 K4ef9/cFMfQkriGmxHDC9GSLnyDz6KX3TyNCJA4ptg==
X-Google-Smtp-Source: ABdhPJwBs4l3xPrJ86QqdOmfqcuVD/NvIViycAprqNRRQDkwaU6W1i5RBinZQBRbLLzO2uklz/Epgwa7l41lkeLUKZ4=
X-Received: by 2002:a05:6870:8196:b0:dd:e471:8bb5 with SMTP id
 k22-20020a056870819600b000dde4718bb5mr814608oae.294.1648543874076; Tue, 29
 Mar 2022 01:51:14 -0700 (PDT)
MIME-Version: 1.0
References: <20220314200148.2695206-1-kaleshsingh@google.com>
 <20220314200148.2695206-2-kaleshsingh@google.com>
In-Reply-To: <20220314200148.2695206-2-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 29 Mar 2022 09:50:38 +0100
Message-ID: <CA+EHjTxx7RoLods=9xz4RZF3FSFZdH+7kwcHCurpUqAD+mtgzA@mail.gmail.com>
Subject: Re: [PATCH v6 1/8] KVM: arm64: Introduce hyp_alloc_private_va_range()
To: Kalesh Singh <kaleshsingh@google.com>
Cc: kernel-team@android.com, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, surenb@google.com,
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

Hi Kalesh,


On Mon, Mar 14, 2022 at 8:02 PM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> hyp_alloc_private_va_range() can be used to reserve private VA ranges
> in the nVHE hypervisor. Allocations are aligned based on the order of
> the requested size.
>
> This will be used to implement stack guard pages for KVM nVHE hypervisor
> (nVHE Hyp mode / not pKVM), in a subsequent patch in the series.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>

This looks good to me. I have also tested this entire series, and your
enhancements will make debugging easier.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad



> ---
>
> Changes in v6:
>   - Update kernel-doc for hyp_alloc_private_va_range()
>     and add return description, per Stephen
>   - Update hyp_alloc_private_va_range() to return an int error code,
>     per Stephen
>   - Replace IS_ERR() checks with IS_ERR_VALUE() check, per Stephen
>   - Clean up goto, per Stephen
>
> Changes in v5:
>   - Align private allocations based on the order of their size, per Marc
>
> Changes in v4:
>   - Handle null ptr in hyp_alloc_private_va_range() and replace
>     IS_ERR_OR_NULL checks in callers with IS_ERR checks, per Fuad
>   - Fix kernel-doc comments format, per Fuad
>
> Changes in v3:
>   - Handle null ptr in IS_ERR_OR_NULL checks, per Mark
>
>
>  arch/arm64/include/asm/kvm_mmu.h |  1 +
>  arch/arm64/kvm/mmu.c             | 66 +++++++++++++++++++++-----------
>  2 files changed, 45 insertions(+), 22 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 81839e9a8a24..3cc9aa25f510 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -153,6 +153,7 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
>  int kvm_share_hyp(void *from, void *to);
>  void kvm_unshare_hyp(void *from, void *to);
>  int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
> +int hyp_alloc_private_va_range(size_t size, unsigned long *haddr);
>  int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
>                            void __iomem **kaddr,
>                            void __iomem **haddr);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index bc2aba953299..7326d683c500 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -457,23 +457,22 @@ int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
>         return 0;
>  }
>
> -static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
> -                                       unsigned long *haddr,
> -                                       enum kvm_pgtable_prot prot)
> +
> +/**
> + * hyp_alloc_private_va_range - Allocates a private VA range.
> + * @size:      The size of the VA range to reserve.
> + * @haddr:     The hypervisor virtual start address of the allocation.
> + *
> + * The private virtual address (VA) range is allocated below io_map_base
> + * and aligned based on the order of @size.
> + *
> + * Return: 0 on success or negative error code on failure.
> + */
> +int hyp_alloc_private_va_range(size_t size, unsigned long *haddr)
>  {
>         unsigned long base;
>         int ret = 0;
>
> -       if (!kvm_host_owns_hyp_mappings()) {
> -               base = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
> -                                        phys_addr, size, prot);
> -               if (IS_ERR_OR_NULL((void *)base))
> -                       return PTR_ERR((void *)base);
> -               *haddr = base;
> -
> -               return 0;
> -       }
> -
>         mutex_lock(&kvm_hyp_pgd_mutex);
>
>         /*
> @@ -484,30 +483,53 @@ static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
>          *
>          * The allocated size is always a multiple of PAGE_SIZE.
>          */
> -       size = PAGE_ALIGN(size + offset_in_page(phys_addr));
> -       base = io_map_base - size;
> +       base = io_map_base - PAGE_ALIGN(size);
> +
> +       /* Align the allocation based on the order of its size */
> +       base = ALIGN_DOWN(base, PAGE_SIZE << get_order(size));
>
>         /*
>          * Verify that BIT(VA_BITS - 1) hasn't been flipped by
>          * allocating the new area, as it would indicate we've
>          * overflowed the idmap/IO address range.
>          */
> -       if ((base ^ io_map_base) & BIT(VA_BITS - 1))
> +       if (!base || (base ^ io_map_base) & BIT(VA_BITS - 1))
>                 ret = -ENOMEM;
>         else
> -               io_map_base = base;
> +               *haddr = io_map_base = base;
>
>         mutex_unlock(&kvm_hyp_pgd_mutex);
>
> +       return ret;
> +}
> +
> +static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
> +                                       unsigned long *haddr,
> +                                       enum kvm_pgtable_prot prot)
> +{
> +       unsigned long addr;
> +       int ret = 0;
> +
> +       if (!kvm_host_owns_hyp_mappings()) {
> +               addr = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
> +                                        phys_addr, size, prot);
> +               if (IS_ERR_VALUE(addr))
> +                       return addr;
> +               *haddr = addr;
> +
> +               return 0;
> +       }
> +
> +       size += offset_in_page(phys_addr);
> +       ret = hyp_alloc_private_va_range(size, &addr);
>         if (ret)
> -               goto out;
> +               return ret;
>
> -       ret = __create_hyp_mappings(base, size, phys_addr, prot);
> +       ret = __create_hyp_mappings(addr, size, phys_addr, prot);
>         if (ret)
> -               goto out;
> +               return ret;
>
> -       *haddr = base + offset_in_page(phys_addr);
> -out:
> +       *haddr = addr + offset_in_page(phys_addr);
>         return ret;
>  }
>
> --
> 2.35.1.723.g4982287a31-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
