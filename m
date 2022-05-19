Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BAC27C433F5
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 15:34:05 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 13C814B3A3;
	Thu, 19 May 2022 11:34:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@brainfault-org.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DO15X8awFFBp; Thu, 19 May 2022 11:34:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD3354B39A;
	Thu, 19 May 2022 11:34:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EF2004B39A
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 11:34:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3HfTvd49Q+We for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 11:34:00 -0400 (EDT)
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com
 [209.85.221.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7FB104B33B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 11:34:00 -0400 (EDT)
Received: by mail-wr1-f45.google.com with SMTP id w4so7665946wrg.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 08:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=brainfault-org.20210112.gappssmtp.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=qbyCxuZ29f6WskkxByuyI9MB64JeWT48ILjv69TkKQc=;
 b=omfH1aJuBDj4dpa8TTkzFwBnfq6unv6UUX17QanNhLrvYGjNmO/hv/5FjXtEorWIr6
 uH1Ge9fFukT7RD6lVtsJg6YSxpqjXWpcDnpJB5gSw/9Bny1amRFF4N/lCDNHWvZQkL2F
 eCJY+9lOSgVltfUuQTCLkzUh1dJDPJoIWl1t50k7xLHsnGWYdTyeRrhlCSAAz/IyIaok
 h7jRLrZVynZZVX6Z8E5YHDcXjJ54oZeJsB9yVEL/YliIBpHChf07whofhq5CcxmmCn03
 OMukqaF6AQUk2K0d16sKJBd7iiw4ertFY78w1MS49wAldiVOt5003mmzSF01Xvd6ceQU
 nitw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=qbyCxuZ29f6WskkxByuyI9MB64JeWT48ILjv69TkKQc=;
 b=hClNSuxL36Iin1Yidcy1Ir19dJhrbXHoMJnlb3PAmlySy5Qd4d6EudKcvMcNGVBHLn
 uBTCgd1gevfbb8NXH5qJYZ5okODL4uRhbVo2+2xjtKtm/k17V6xalPHklKTVmNSQR0ec
 Jig1yYxOp24WVgfIbu0/3foMDKPixLB1PVgfTLPzQaGaX1FBVopEp7IrPIRGbLuLSpC7
 bOKxwJp/shMTYl5JGKpGyifqhxDEqPPZQaNN1PHUi8P/swLXOHPsHgqCiLZ6mGT/cJEH
 UnEz5JbinPFBqpH2CpfWrDNNeTW9Z8pPy6geNkPmoaUNre18hhOM5Ayzrzx3mRWE27xd
 ofsw==
X-Gm-Message-State: AOAM5333IA8KibLHGBLhm0YD5/sfBhCY4X3MStz2e285oC1jmi0YkjfT
 Xr9TXrXAOcRGK8juUFhR8bXTwHZJM+/5hKNBN6KOcw==
X-Google-Smtp-Source: ABdhPJz9n7/WYKowTqaLjO6PZwmJ95x8Wu3I84HeVusJegUVevaq08lkBs9a/fBQkYDljVPvVNA0buz+sktyter8ByA=
X-Received: by 2002:a5d:6c6b:0:b0:1ea:77ea:dde8 with SMTP id
 r11-20020a5d6c6b000000b001ea77eadde8mr4582799wrz.690.1652974439187; Thu, 19
 May 2022 08:33:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220516232138.1783324-1-dmatlack@google.com>
 <20220516232138.1783324-22-dmatlack@google.com>
In-Reply-To: <20220516232138.1783324-22-dmatlack@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Thu, 19 May 2022 21:03:48 +0530
Message-ID: <CAAhSdy3yHbGBYT6eYEjN7E9-pyiJB_mc+kL6wgREm2qzsHAenQ@mail.gmail.com>
Subject: Re: [PATCH v6 21/22] KVM: Allow for different capacities in
 kvm_mmu_memory_cache structs
To: David Matlack <dmatlack@google.com>
Cc: Albert Ou <aou@eecs.berkeley.edu>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR MIPS \(KVM/mips\)"
 <linux-mips@vger.kernel.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 "open list:KERNEL VIRTUAL MACHINE FOR RISC-V \(KVM/riscv\)"
 <kvm-riscv@lists.infradead.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 Ben Gardon <bgardon@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 "Maciej S. Szmigiero" <maciej.szmigiero@oracle.com>,
 "moderated list:KERNEL VIRTUAL MACHINE FOR ARM64 \(KVM/arm64\)"
 <kvmarm@lists.cs.columbia.edu>, Peter Feiner <pfeiner@google.com>
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

On Tue, May 17, 2022 at 4:52 AM David Matlack <dmatlack@google.com> wrote:
>
> Allow the capacity of the kvm_mmu_memory_cache struct to be chosen at
> declaration time rather than being fixed for all declarations. This will
> be used in a follow-up commit to declare an cache in x86 with a capacity
> of 512+ objects without having to increase the capacity of all caches in
> KVM.
>
> This change requires each cache now specify its capacity at runtime,
> since the cache struct itself no longer has a fixed capacity known at
> compile time. To protect against someone accidentally defining a
> kvm_mmu_memory_cache struct directly (without the extra storage), this
> commit includes a WARN_ON() in kvm_mmu_topup_memory_cache().
>
> In order to support different capacities, this commit changes the
> objects pointer array to be dynamically allocated the first time the
> cache is topped-up.
>
> While here, opportunistically clean up the stack-allocated
> kvm_mmu_memory_cache structs in riscv and arm64 to use designated
> initializers.
>
> No functional change intended.
>
> Reviewed-by: Marc Zyngier <maz@kernel.org>
> Signed-off-by: David Matlack <dmatlack@google.com>

Looks good to me for KVM RISC-V.

Reviewed-by: Anup Patel <anup@brainfault.org>

A small heads-up that function stage2_ioremap() is going to be
renamed for Linux-5.19 so you might have to rebase one more time.

Thanks,
Anup

> ---
>  arch/arm64/kvm/mmu.c      |  2 +-
>  arch/riscv/kvm/mmu.c      |  5 +----
>  include/linux/kvm_types.h |  6 +++++-
>  virt/kvm/kvm_main.c       | 33 ++++++++++++++++++++++++++++++---
>  4 files changed, 37 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 53ae2c0640bc..f443ed845f85 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -764,7 +764,7 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  {
>         phys_addr_t addr;
>         int ret = 0;
> -       struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
> +       struct kvm_mmu_memory_cache cache = { .gfp_zero = __GFP_ZERO };
>         struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
>                                      KVM_PGTABLE_PROT_R |
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index f80a34fbf102..4d95ebe4114f 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -347,10 +347,7 @@ static int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
>         int ret = 0;
>         unsigned long pfn;
>         phys_addr_t addr, end;
> -       struct kvm_mmu_memory_cache pcache;
> -
> -       memset(&pcache, 0, sizeof(pcache));
> -       pcache.gfp_zero = __GFP_ZERO;
> +       struct kvm_mmu_memory_cache pcache = { .gfp_zero = __GFP_ZERO };
>
>         end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
>         pfn = __phys_to_pfn(hpa);
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index ac1ebb37a0ff..68529884eaf8 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -83,12 +83,16 @@ struct gfn_to_pfn_cache {
>   * MMU flows is problematic, as is triggering reclaim, I/O, etc... while
>   * holding MMU locks.  Note, these caches act more like prefetch buffers than
>   * classical caches, i.e. objects are not returned to the cache on being freed.
> + *
> + * The @capacity field and @objects array are lazily initialized when the cache
> + * is topped up (__kvm_mmu_topup_memory_cache()).
>   */
>  struct kvm_mmu_memory_cache {
>         int nobjs;
>         gfp_t gfp_zero;
>         struct kmem_cache *kmem_cache;
> -       void *objects[KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE];
> +       int capacity;
> +       void **objects;
>  };
>  #endif
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e089db822c12..5e2e75014256 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -369,14 +369,31 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
>                 return (void *)__get_free_page(gfp_flags);
>  }
>
> -int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> +static int __kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int capacity, int min)
>  {
> +       gfp_t gfp = GFP_KERNEL_ACCOUNT;
>         void *obj;
>
>         if (mc->nobjs >= min)
>                 return 0;
> -       while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> -               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> +
> +       if (unlikely(!mc->objects)) {
> +               if (WARN_ON_ONCE(!capacity))
> +                       return -EIO;
> +
> +               mc->objects = kvmalloc_array(sizeof(void *), capacity, gfp);
> +               if (!mc->objects)
> +                       return -ENOMEM;
> +
> +               mc->capacity = capacity;
> +       }
> +
> +       /* It is illegal to request a different capacity across topups. */
> +       if (WARN_ON_ONCE(mc->capacity != capacity))
> +               return -EIO;
> +
> +       while (mc->nobjs < mc->capacity) {
> +               obj = mmu_memory_cache_alloc_obj(mc, gfp);
>                 if (!obj)
>                         return mc->nobjs >= min ? 0 : -ENOMEM;
>                 mc->objects[mc->nobjs++] = obj;
> @@ -384,6 +401,11 @@ int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
>         return 0;
>  }
>
> +int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
> +{
> +       return __kvm_mmu_topup_memory_cache(mc, KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE, min);
> +}
> +
>  int kvm_mmu_memory_cache_nr_free_objects(struct kvm_mmu_memory_cache *mc)
>  {
>         return mc->nobjs;
> @@ -397,6 +419,11 @@ void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
>                 else
>                         free_page((unsigned long)mc->objects[--mc->nobjs]);
>         }
> +
> +       kvfree(mc->objects);
> +
> +       mc->objects = NULL;
> +       mc->capacity = 0;
>  }
>
>  void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
> --
> 2.36.0.550.gb090851708-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
