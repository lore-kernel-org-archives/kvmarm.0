Return-Path: <SRS0=JvcX=7V=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62C43C433E1
	for <kvmarm@archiver.kernel.org>; Mon,  8 Jun 2020 09:36:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1B93F206D5
	for <kvmarm@archiver.kernel.org>; Mon,  8 Jun 2020 09:36:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Y9+UtojW"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1B93F206D5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AC6B14B1E5;
	Mon,  8 Jun 2020 05:36:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@gmail.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xGPZq8pDvwAB; Mon,  8 Jun 2020 05:36:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5801A4B15B;
	Mon,  8 Jun 2020 05:36:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C41174B1C1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jun 2020 04:57:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gkZSvAzgLL65 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Jun 2020 04:57:31 -0400 (EDT)
Received: from mail-il1-f194.google.com (mail-il1-f194.google.com
 [209.85.166.194])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AF3444B1BF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Jun 2020 04:57:31 -0400 (EDT)
Received: by mail-il1-f194.google.com with SMTP id l6so16008041ilo.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Jun 2020 01:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20161025;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=ZhUJIihNsOJBPcBzEUBiE7/iTHmbpkI3L5KiEBlzlAw=;
 b=Y9+UtojWa2WvofBKlqksrH2UxqOeor9ywSsTiV/vDSFGtDp5oN9ImT7jixVrCmdrv7
 KqNvYCOlvk6+QKy0dRkO4iGrNI1kmjIN/u1NVSqW1i1b/KF63PcNOO/bFR5fou29C499
 imfbf9MzdZyRbHyCiRH8irRF8ehZh/IUDpq6TclCsORYbkamGlPncs3p/d40LqM/8v0O
 +fDZsW+XFyhc934YqXtULIaXiGVuUIDbErtxW3Jcylu0nj4HGVsGOYIqFaPoNNpjmbZy
 2J56AZj9w8fwtGQ2NO7AePx8m8uSEytRjzYL5oCw63lDRsB4J+xLIy9/+aw4NX/Oh//i
 Tqkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=ZhUJIihNsOJBPcBzEUBiE7/iTHmbpkI3L5KiEBlzlAw=;
 b=DKiK4jZOBWLIIkHDnsQTvG93zQPUFe7I+wOwpVdZbEuLE5EidHjGu/zyBX00cs6QZ8
 /c+cfkIJV1/uTP7UHSufSeOlaxTU64RwPfVNUjNXMokFiURu/ZaL/V5YcetoxbKJ0cVN
 XjgpUAgOzntry2HFMeZk9QMRBXtQbhHJKlpTbZNxodGKdT7P4Cg0uumAgXueIsR5jtbN
 UeET0LTIcGVKK0QoqvcGHsh0NNGRD5UEPudD8dNEdvrzxVKHUUl1g14BjrUSarnfRAxa
 Ech8s/MjeQaKwGOv7GnqazSa9qvaAn+eazrZBIyYwvaUuZfxNIJsE1IH71EY1rNpT4aN
 Z2fw==
X-Gm-Message-State: AOAM533n7ba6yqagILg3xS5jGBo7qohEEvEN4ttfLNa+heFO9V2nT/Bb
 PrWz4qW3nWxfcgMFkf4XSOvwgB7phZEPsRj9KSQ=
X-Google-Smtp-Source: ABdhPJwyPmJaXLtSbRr/u7WSBpcrHXUO5Dpivercq2zRD4AQJbzLRnckACLEYWNLFcrCuA7qfpn1FslH2bosTiVE5PA=
X-Received: by 2002:a92:9f12:: with SMTP id u18mr20674915ili.287.1591606651183; 
 Mon, 08 Jun 2020 01:57:31 -0700 (PDT)
MIME-Version: 1.0
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-22-sean.j.christopherson@intel.com>
In-Reply-To: <20200605213853.14959-22-sean.j.christopherson@intel.com>
From: Huacai Chen <chenhuacai@gmail.com>
Date: Mon, 8 Jun 2020 16:57:20 +0800
Message-ID: <CAAhV-H4XrXx9ktum-E706ggukSU77hdN-iofJ-DDGtLeGt+KPA@mail.gmail.com>
Subject: Re: [PATCH 21/21] KVM: MIPS: Use common KVM implementation of MMU
 memory caches
To: Sean Christopherson <sean.j.christopherson@intel.com>
X-Mailman-Approved-At: Mon, 08 Jun 2020 05:36:10 -0400
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm <kvm@vger.kernel.org>,
 David Hildenbrand <david@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
 Paul Mackerras <paulus@ozlabs.org>, Ben Gardon <bgardon@google.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, Christian Borntraeger <borntraeger@de.ibm.com>,
 Junaid Shahid <junaids@google.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
 Jim Mattson <jmattson@google.com>, Cornelia Huck <cohuck@redhat.com>,
 Peter Shier <pshier@google.com>, "open list:MIPS" <linux-mips@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Peter Feiner <pfeiner@google.com>
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

Reviewed-by: Huacai Chen <chenhc@lemote.com>

On Sat, Jun 6, 2020 at 5:41 AM Sean Christopherson
<sean.j.christopherson@intel.com> wrote:
>
> Move to the common MMU memory cache implementation now that the common
> code and MIPS's existing code are semantically compatible.
>
> No functional change intended.
>
> Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/mips/include/asm/kvm_host.h  | 11 ---------
>  arch/mips/include/asm/kvm_types.h |  2 ++
>  arch/mips/kvm/mmu.c               | 40 ++++---------------------------
>  3 files changed, 7 insertions(+), 46 deletions(-)
>
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 363e7a89d173..f49617175f60 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -335,17 +335,6 @@ struct kvm_mips_tlb {
>         long tlb_lo[2];
>  };
>
> -#define KVM_NR_MEM_OBJS     4
> -
> -/*
> - * We don't want allocation failures within the mmu code, so we preallocate
> - * enough memory for a single page fault in a cache.
> - */
> -struct kvm_mmu_memory_cache {
> -       int nobjs;
> -       void *objects[KVM_NR_MEM_OBJS];
> -};
> -
>  #define KVM_MIPS_AUX_FPU       0x1
>  #define KVM_MIPS_AUX_MSA       0x2
>
> diff --git a/arch/mips/include/asm/kvm_types.h b/arch/mips/include/asm/kvm_types.h
> index 5efeb32a5926..213754d9ef6b 100644
> --- a/arch/mips/include/asm/kvm_types.h
> +++ b/arch/mips/include/asm/kvm_types.h
> @@ -2,4 +2,6 @@
>  #ifndef _ASM_MIPS_KVM_TYPES_H
>  #define _ASM_MIPS_KVM_TYPES_H
>
> +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE     4
> +
>  #endif /* _ASM_MIPS_KVM_TYPES_H */
> diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
> index 41a4a063a730..d6acd88c0c46 100644
> --- a/arch/mips/kvm/mmu.c
> +++ b/arch/mips/kvm/mmu.c
> @@ -25,39 +25,9 @@
>  #define KVM_MMU_CACHE_MIN_PAGES 2
>  #endif
>
> -static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache, int min)
> -{
> -       void *page;
> -
> -       if (cache->nobjs >= min)
> -               return 0;
> -       while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> -               page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT);
> -               if (!page)
> -                       return -ENOMEM;
> -               cache->objects[cache->nobjs++] = page;
> -       }
> -       return 0;
> -}
> -
> -static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
> -{
> -       while (mc->nobjs)
> -               free_page((unsigned long)mc->objects[--mc->nobjs]);
> -}
> -
> -static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
> -{
> -       void *p;
> -
> -       BUG_ON(!mc || !mc->nobjs);
> -       p = mc->objects[--mc->nobjs];
> -       return p;
> -}
> -
>  void kvm_mmu_free_memory_caches(struct kvm_vcpu *vcpu)
>  {
> -       mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
> +       kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_cache);
>  }
>
>  /**
> @@ -151,7 +121,7 @@ static pte_t *kvm_mips_walk_pgd(pgd_t *pgd, struct kvm_mmu_memory_cache *cache,
>
>                 if (!cache)
>                         return NULL;
> -               new_pmd = mmu_memory_cache_alloc(cache);
> +               new_pmd = kvm_mmu_memory_cache_alloc(cache);
>                 pmd_init((unsigned long)new_pmd,
>                          (unsigned long)invalid_pte_table);
>                 pud_populate(NULL, pud, new_pmd);
> @@ -162,7 +132,7 @@ static pte_t *kvm_mips_walk_pgd(pgd_t *pgd, struct kvm_mmu_memory_cache *cache,
>
>                 if (!cache)
>                         return NULL;
> -               new_pte = mmu_memory_cache_alloc(cache);
> +               new_pte = kvm_mmu_memory_cache_alloc(cache);
>                 clear_page(new_pte);
>                 pmd_populate_kernel(NULL, pmd, new_pte);
>         }
> @@ -709,7 +679,7 @@ static int kvm_mips_map_page(struct kvm_vcpu *vcpu, unsigned long gpa,
>                 goto out;
>
>         /* We need a minimum of cached pages ready for page table creation */
> -       err = mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES);
> +       err = kvm_mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES);
>         if (err)
>                 goto out;
>
> @@ -793,7 +763,7 @@ static pte_t *kvm_trap_emul_pte_for_gva(struct kvm_vcpu *vcpu,
>         int ret;
>
>         /* We need a minimum of cached pages ready for page table creation */
> -       ret = mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES);
> +       ret = kvm_mmu_topup_memory_cache(memcache, KVM_MMU_CACHE_MIN_PAGES);
>         if (ret)
>                 return NULL;
>
> --
> 2.26.0
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
