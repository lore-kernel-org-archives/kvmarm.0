Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DFAEDC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 24 Feb 2022 12:25:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5D6D44BDFA;
	Thu, 24 Feb 2022 07:25:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zdRraCDBwreh; Thu, 24 Feb 2022 07:25:03 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70A824C0BB;
	Thu, 24 Feb 2022 07:25:03 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 496F44C0BC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 07:25:02 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2XcSyIF5XFUX for <kvmarm@lists.cs.columbia.edu>;
 Thu, 24 Feb 2022 07:25:00 -0500 (EST)
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com
 [209.85.161.53])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9E4874C0BB
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 07:25:00 -0500 (EST)
Received: by mail-oo1-f53.google.com with SMTP id
 d134-20020a4a528c000000b00319244f4b04so3144879oob.8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 24 Feb 2022 04:25:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=Py9a6z5uwcsSI2pT/P/X06lNc5avWgegLU62z/0BWvM=;
 b=RPXgZqyUqoq9ax2om738OHkI2ASrhUdSPHYfH+EMXLO5ilhXwMUDnnnseVBHcePdGO
 xVsdS+s51pd6t+6Djtwa5VuZ8fKI7uZEnOtiYJDDe5Mznm51WHGbNOXrpVNpQoGxmEHs
 7PbctUM/GVCA58MGrblUb9A+taH9KX4PwOAMcE79XJzfJS7wvX/8Yi59diob+HDDLYpw
 kNmttcXGnR2dtXsuWF5BtQqgGq1LeQ0OjPrnfhvjFD5xliGAP+VqPuIN7nNutc0cx3gL
 EQMZntO7nfYkEpDHv1vAkN6vz0JWYNUY7zwiz66ifBnupr8ZHLQSjA1v/nuCE+RgVQng
 Gz0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=Py9a6z5uwcsSI2pT/P/X06lNc5avWgegLU62z/0BWvM=;
 b=d25AlOFh4Sn4J1VyDun1MIdCDvI0yL7aiGTrKa1rE1YXRvoHtQUhpds6P5DfRMk0KR
 0R2Dx5zodVbUWv+935iklD6Q/ajM6CGP9MkBJzuYoLG4/GnAbWs3zVRqNwJ0Yit8VjK2
 B751FdxAeFhV8SL3U24gEDStZLkgwyDpOd360+WRuMm5thT0HCfdzCeKY10X4E+UNILX
 +02XmCaNLS5oKzwilkwThAO0sgVF85Qcdo1YpqOZGM995LOcW9ErkI581MhTo0Sy1pVc
 NRzEKuvnF4nHYv+Tpy8jvBnxofl3eZTOxSe48t1JduOsINCf8aHOzxM1LMHCgR0ZQ9xg
 7gxw==
X-Gm-Message-State: AOAM532F+4qACzwrdLO0vlzKqoN++Jpvpy5kbTg1vrfeAt6Erb0u5nBj
 p5tb5FO/+2b2ADecTe6DGpjfh5OIhRU3jx1mnESdJA==
X-Google-Smtp-Source: ABdhPJypJhJXpiHx6uc07a0UP/bjXtRUesuyw0zU9+tLQj6a3Ly13d/6h6jq9Luwq8oAkzi78zmptBaTxpEqn4nY1A0=
X-Received: by 2002:a05:6870:d991:b0:ce:c0c9:622 with SMTP id
 gn17-20020a056870d99100b000cec0c90622mr6117040oab.116.1645705499586; Thu, 24
 Feb 2022 04:24:59 -0800 (PST)
MIME-Version: 1.0
References: <20220224051439.640768-1-kaleshsingh@google.com>
 <20220224051439.640768-2-kaleshsingh@google.com>
In-Reply-To: <20220224051439.640768-2-kaleshsingh@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Thu, 24 Feb 2022 12:24:23 +0000
Message-ID: <CA+EHjTzkmPuqtpRQRRfRnC2n-ah_jnPiqfa2kg55YESGSjN6OA@mail.gmail.com>
Subject: Re: [PATCH v3 1/8] KVM: arm64: Introduce hyp_alloc_private_va_range()
To: Kalesh Singh <kaleshsingh@google.com>
Cc: kernel-team@android.com, will@kernel.org,
 Peter Collingbourne <pcc@google.com>, maz@kernel.org,
 linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 "Madhavan T. Venkataraman" <madvenka@linux.microsoft.com>,
 Mark Brown <broonie@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 surenb@google.com, linux-arm-kernel@lists.infradead.org
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

On Thu, Feb 24, 2022 at 5:16 AM Kalesh Singh <kaleshsingh@google.com> wrote:
>
> hyp_alloc_private_va_range() can be used to reserve private VA ranges
> in the nVHE hypervisor. Also update  __create_hyp_private_mapping()
> to allow specifying an alignment for the private VA mapping.
>
> These will be used to implement stack guard pages for KVM nVHE hypervisor
> (nVHE Hyp mode / not pKVM), in a subsequent patch in the series.
>
> Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
> ---
>
> Changes in v3:
>   - Handle null ptr in IS_ERR_OR_NULL checks, per Mark
>
>  arch/arm64/include/asm/kvm_mmu.h |  4 +++
>  arch/arm64/kvm/mmu.c             | 62 ++++++++++++++++++++------------
>  2 files changed, 43 insertions(+), 23 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 81839e9a8a24..0b0c71302b92 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -153,6 +153,10 @@ static __always_inline unsigned long __kern_hyp_va(unsigned long v)
>  int kvm_share_hyp(void *from, void *to);
>  void kvm_unshare_hyp(void *from, void *to);
>  int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot);
> +unsigned long hyp_alloc_private_va_range(size_t size, size_t align);
> +int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
> +                               size_t align, unsigned long *haddr,
> +                               enum kvm_pgtable_prot prot);
>  int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
>                            void __iomem **kaddr,
>                            void __iomem **haddr);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index bc2aba953299..fc09536c8197 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -457,22 +457,16 @@ int create_hyp_mappings(void *from, void *to, enum kvm_pgtable_prot prot)
>         return 0;
>  }
>
> -static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
> -                                       unsigned long *haddr,
> -                                       enum kvm_pgtable_prot prot)
> +
> +/*
> + * Allocates a private VA range below io_map_base.
> + *
> + * @size:      The size of the VA range to reserve.
> + * @align:     The required alignment for the allocation.
> + */

Many of the functions in this file use the kernel-doc format, and your
added comments are close, but not quite conforment. If you want to use
the kernel-doc for these you can refer to:
https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html

> +unsigned long hyp_alloc_private_va_range(size_t size, size_t align)
>  {
>         unsigned long base;
> -       int ret = 0;
> -
> -       if (!kvm_host_owns_hyp_mappings()) {
> -               base = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
> -                                        phys_addr, size, prot);
> -               if (IS_ERR_OR_NULL((void *)base))
> -                       return PTR_ERR((void *)base);
> -               *haddr = base;
> -
> -               return 0;
> -       }
>
>         mutex_lock(&kvm_hyp_pgd_mutex);
>
> @@ -484,8 +478,8 @@ static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
>          *
>          * The allocated size is always a multiple of PAGE_SIZE.
>          */
> -       size = PAGE_ALIGN(size + offset_in_page(phys_addr));
> -       base = io_map_base - size;
> +       base = io_map_base - PAGE_ALIGN(size);
> +       base = ALIGN_DOWN(base, align);
>
>         /*
>          * Verify that BIT(VA_BITS - 1) hasn't been flipped by
> @@ -493,20 +487,42 @@ static int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
>          * overflowed the idmap/IO address range.
>          */
>         if ((base ^ io_map_base) & BIT(VA_BITS - 1))
> -               ret = -ENOMEM;
> +               base = (unsigned long)ERR_PTR(-ENOMEM);
>         else
>                 io_map_base = base;
>
>         mutex_unlock(&kvm_hyp_pgd_mutex);
>
> -       if (ret)
> -               goto out;
> +       return base;
> +}
> +
> +int __create_hyp_private_mapping(phys_addr_t phys_addr, size_t size,
> +                               size_t align, unsigned long *haddr,
> +                               enum kvm_pgtable_prot prot)
> +{
> +       unsigned long addr;
> +       int ret = 0;
> +
> +       if (!kvm_host_owns_hyp_mappings()) {
> +               addr = kvm_call_hyp_nvhe(__pkvm_create_private_mapping,
> +                                        phys_addr, size, prot);
> +               if (IS_ERR_OR_NULL((void *)addr))
> +                       return addr ? PTR_ERR((void *)addr) : -ENOMEM;
> +               *haddr = addr;
> +
> +               return 0;
> +       }
> +
> +       size += offset_in_page(phys_addr);

You're not page-aligning the size, which was the behavior before this
patch. However, looking at where it's being used it seems to be fine
because the users of size would align it if necessary.

Thanks,
/fuad



> +       addr = hyp_alloc_private_va_range(size, align);
> +       if (IS_ERR_OR_NULL((void *)addr))
> +               return addr ? PTR_ERR((void *)addr) : -ENOMEM;
>
> -       ret = __create_hyp_mappings(base, size, phys_addr, prot);
> +       ret = __create_hyp_mappings(addr, size, phys_addr, prot);
>         if (ret)
>                 goto out;
>
> -       *haddr = base + offset_in_page(phys_addr);
> +       *haddr = addr + offset_in_page(phys_addr);
>  out:
>         return ret;
>  }
> @@ -537,7 +553,7 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
>                 return 0;
>         }
>
> -       ret = __create_hyp_private_mapping(phys_addr, size,
> +       ret = __create_hyp_private_mapping(phys_addr, size, PAGE_SIZE,
>                                            &addr, PAGE_HYP_DEVICE);
>         if (ret) {
>                 iounmap(*kaddr);
> @@ -564,7 +580,7 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,
>
>         BUG_ON(is_kernel_in_hyp_mode());
>
> -       ret = __create_hyp_private_mapping(phys_addr, size,
> +       ret = __create_hyp_private_mapping(phys_addr, size, PAGE_SIZE,
>                                            &addr, PAGE_HYP_EXEC);
>         if (ret) {
>                 *haddr = NULL;
> --
> 2.35.1.473.g83b2b277ed-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
