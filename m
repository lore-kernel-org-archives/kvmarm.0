Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1868C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 16 May 2022 03:32:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6509D49F4A;
	Sun, 15 May 2022 23:32:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered)
	header.i=@brainfault-org.20210112.gappssmtp.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B3qx5w6i6l+D; Sun, 15 May 2022 23:32:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4DF04B1B4;
	Sun, 15 May 2022 23:32:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 290C94B104
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2022 23:32:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LHTb+ACHge9E for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 May 2022 23:32:34 -0400 (EDT)
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com
 [209.85.128.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 96A014B349
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2022 23:32:34 -0400 (EDT)
Received: by mail-wm1-f44.google.com with SMTP id
 l38-20020a05600c1d2600b00395b809dfbaso7602949wms.2
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 May 2022 20:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=brainfault-org.20210112.gappssmtp.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=oqynqjXur5gzVoTN8CwQIeM0rvdnBIkekRkxe/Ghbeg=;
 b=rdF9dfFQrQNiKEIV/nhYQRNHKsvYwycjBiBcphswaNIbgiTBabEbKgI2uFKjy+2ob/
 S3CIFGdwJozVT8JUkNVkMU5532CmFs6ZOGCSP7uUObYFlfo11UsuIDM9cT9VFDE1L7y5
 NxlDZ8NlKEhog+iR9zrLz75oz5DBa/humKLzOO32R3UXP0i7Zrew/T+wHkhReCidbNC3
 i2T65Cyr5BQRDzZ3SYN+OtE8z5E0dmli8OpC49akmRJZvopxYqQ4O9ZDYnLZpfe0+b9J
 Ts4StF31PTy2dROi7cL2/yFZ+TReC8FdL+f1J0jzuz6huxgn09ZbwyuuSsYhzvH9y2kA
 2XWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=oqynqjXur5gzVoTN8CwQIeM0rvdnBIkekRkxe/Ghbeg=;
 b=C78VNm7ymz/efZygSPffqSJOcvepFOvn5BQUcJFKznxnEGblztaOJooWIyz6dCL9As
 IpFJu2WZ0k+5QeAcXTIJpWs8VsKAz69HUce1MT3BMrJAEQlrU11iD+xa5JsVybD5OdWD
 0faTxWWIrnwaF7ffK+1GxdvnLBMZlI6u97DGNcI9MX3R1O2TU/hkavMxMJCNprnOEtqf
 0lA6a76r3C3HjMx2BEOaj2rXM6FIL7rpk7K5tIolZyJLcRHlQEeBHzTiU1qd2NAg2Sji
 wmN/B+yrUPdQoIMeg2a1V74GKlsADrmaIcZSuVbgk0ormHgJbLzKWRN5RBVp4nJKqrFc
 oDzg==
X-Gm-Message-State: AOAM533OdXRdUU9cdLJfvg3qsbJVsWNtrt01nskoinzLeLVn4VoL9i0v
 uHYsgO8gEbnmDMJ/mAuQTPm1uM2vVq2NeHFNhA02Ig==
X-Google-Smtp-Source: ABdhPJxGy6aNwJtRkou3ysJqO72GQR0pYZXDbNIl8eNcu+4dFzxGD1EDGOm8BvvpkUob6py8XuVJuFbD7oicuRU4b8Q=
X-Received: by 2002:a05:600c:5113:b0:394:800c:4c36 with SMTP id
 o19-20020a05600c511300b00394800c4c36mr15065787wms.93.1652671953328; Sun, 15
 May 2022 20:32:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220513202819.829591-1-dmatlack@google.com>
 <20220513202819.829591-21-dmatlack@google.com>
In-Reply-To: <20220513202819.829591-21-dmatlack@google.com>
From: Anup Patel <anup@brainfault.org>
Date: Mon, 16 May 2022 09:01:27 +0530
Message-ID: <CAAhSdy1yP-QUuGn10W-zZaET8_WHo0fdkWwGoP4-WySOXfaHGg@mail.gmail.com>
Subject: Re: [PATCH v5 20/21] KVM: Allow for different capacities in
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

On Sat, May 14, 2022 at 1:59 AM David Matlack <dmatlack@google.com> wrote:
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
> An alternative would be to lay out the objects array after the
> kvm_mmu_memory_cache struct, which can be done at compile time. But that
> change, unfortunately, adds some grottiness to arm64 and riscv, which
> uses a function-local (i.e.  stack-allocated) kvm_mmu_memory_cache
> struct. Since C does not allow anonymous structs in functions, the new
> wrapper struct that contains kvm_mmu_memory_cache and the objects
> pointer array, must be named, which means dealing with an outer and
> inner struct. The outer struct can't be dropped since then there would
> be no guarantee the kvm_mmu_memory_cache struct and objects array would
> be laid out consecutively on the stack.
>
> No functional change intended.
>
> Signed-off-by: David Matlack <dmatlack@google.com>

Overall, this looks good to me. I wanted to try this patch with KVM RISC-V
but there are conflicts in include/linux/kvm_types.h and virt/kvm/kvm_main.c

Please take a look.

Regards,
Anup

> ---
>  arch/arm64/kvm/arm.c      |  1 +
>  arch/arm64/kvm/mmu.c      |  5 ++++-
>  arch/mips/kvm/mips.c      |  2 ++
>  arch/riscv/kvm/mmu.c      |  8 ++++----
>  arch/riscv/kvm/vcpu.c     |  1 +
>  arch/x86/kvm/mmu/mmu.c    |  9 +++++++++
>  include/linux/kvm_types.h |  9 +++++++--
>  virt/kvm/kvm_main.c       | 20 ++++++++++++++++++--
>  8 files changed, 46 insertions(+), 9 deletions(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 7fceb855fa71..aa1e0c1659d4 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -320,6 +320,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         vcpu->arch.target = -1;
>         bitmap_zero(vcpu->arch.features, KVM_VCPU_MAX_FEATURES);
>
> +       vcpu->arch.mmu_page_cache.capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
>         vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
>
>         /* Set up the timer */
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 53ae2c0640bc..2f2ef6b60ff4 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -764,7 +764,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>  {
>         phys_addr_t addr;
>         int ret = 0;
> -       struct kvm_mmu_memory_cache cache = { 0, __GFP_ZERO, NULL, };
> +       struct kvm_mmu_memory_cache cache = {
> +               .capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE,
> +               .gfp_zero = __GFP_ZERO,
> +       };
>         struct kvm_pgtable *pgt = kvm->arch.mmu.pgt;
>         enum kvm_pgtable_prot prot = KVM_PGTABLE_PROT_DEVICE |
>                                      KVM_PGTABLE_PROT_R |
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index a25e0b73ee70..45c7179144dc 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -387,6 +387,8 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>         if (err)
>                 goto out_free_gebase;
>
> +       vcpu->arch.mmu_page_cache.capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
> +
>         return 0;
>
>  out_free_gebase:
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index f80a34fbf102..8c2338ecc246 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -347,10 +347,10 @@ static int stage2_ioremap(struct kvm *kvm, gpa_t gpa, phys_addr_t hpa,
>         int ret = 0;
>         unsigned long pfn;
>         phys_addr_t addr, end;
> -       struct kvm_mmu_memory_cache pcache;
> -
> -       memset(&pcache, 0, sizeof(pcache));
> -       pcache.gfp_zero = __GFP_ZERO;
> +       struct kvm_mmu_memory_cache pcache = {
> +               .capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE,
> +               .gfp_zero = __GFP_ZERO,
> +       };
>
>         end = (gpa + size + PAGE_SIZE - 1) & PAGE_MASK;
>         pfn = __phys_to_pfn(hpa);
> diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
> index 6785aef4cbd4..bbcb9d4a04fb 100644
> --- a/arch/riscv/kvm/vcpu.c
> +++ b/arch/riscv/kvm/vcpu.c
> @@ -94,6 +94,7 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>
>         /* Mark this VCPU never ran */
>         vcpu->arch.ran_atleast_once = false;
> +       vcpu->arch.mmu_page_cache.capacity = KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
>         vcpu->arch.mmu_page_cache.gfp_zero = __GFP_ZERO;
>
>         /* Setup ISA features available to VCPU */
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 4b40fa2e27eb..dad7e19ef8ed 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -5803,12 +5803,21 @@ int kvm_mmu_create(struct kvm_vcpu *vcpu)
>  {
>         int ret;
>
> +       vcpu->arch.mmu_pte_list_desc_cache.capacity =
> +               KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
>         vcpu->arch.mmu_pte_list_desc_cache.kmem_cache = pte_list_desc_cache;
>         vcpu->arch.mmu_pte_list_desc_cache.gfp_zero = __GFP_ZERO;
>
> +       vcpu->arch.mmu_page_header_cache.capacity =
> +               KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
>         vcpu->arch.mmu_page_header_cache.kmem_cache = mmu_page_header_cache;
>         vcpu->arch.mmu_page_header_cache.gfp_zero = __GFP_ZERO;
>
> +       vcpu->arch.mmu_shadowed_info_cache.capacity =
> +               KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
> +
> +       vcpu->arch.mmu_shadow_page_cache.capacity =
> +               KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE;
>         vcpu->arch.mmu_shadow_page_cache.gfp_zero = __GFP_ZERO;
>
>         vcpu->arch.mmu = &vcpu->arch.root_mmu;
> diff --git a/include/linux/kvm_types.h b/include/linux/kvm_types.h
> index ac1ebb37a0ff..549103a4f7bc 100644
> --- a/include/linux/kvm_types.h
> +++ b/include/linux/kvm_types.h
> @@ -83,14 +83,19 @@ struct gfn_to_pfn_cache {
>   * MMU flows is problematic, as is triggering reclaim, I/O, etc... while
>   * holding MMU locks.  Note, these caches act more like prefetch buffers than
>   * classical caches, i.e. objects are not returned to the cache on being freed.
> + *
> + * The storage for the cache object pointers is allocated dynamically when the
> + * cache is topped-up. The capacity field defines the number of object pointers
> + * available after the struct.
>   */
>  struct kvm_mmu_memory_cache {
>         int nobjs;
> +       int capacity;
>         gfp_t gfp_zero;
>         struct kmem_cache *kmem_cache;
> -       void *objects[KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE];
> +       void **objects;
>  };
> -#endif
> +#endif /* KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE */
>
>  #define HALT_POLL_HIST_COUNT                   32
>
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index e089db822c12..264e4107e06f 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -371,12 +371,23 @@ static inline void *mmu_memory_cache_alloc_obj(struct kvm_mmu_memory_cache *mc,
>
>  int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min)
>  {
> +       gfp_t gfp = GFP_KERNEL_ACCOUNT;
>         void *obj;
>
>         if (mc->nobjs >= min)
>                 return 0;
> -       while (mc->nobjs < ARRAY_SIZE(mc->objects)) {
> -               obj = mmu_memory_cache_alloc_obj(mc, GFP_KERNEL_ACCOUNT);
> +
> +       if (WARN_ON(mc->capacity == 0))
> +               return -EINVAL;
> +
> +       if (!mc->objects) {
> +               mc->objects = kvmalloc_array(sizeof(void *), mc->capacity, gfp);
> +               if (!mc->objects)
> +                       return -ENOMEM;
> +       }
> +
> +       while (mc->nobjs < mc->capacity) {
> +               obj = mmu_memory_cache_alloc_obj(mc, gfp);
>                 if (!obj)
>                         return mc->nobjs >= min ? 0 : -ENOMEM;
>                 mc->objects[mc->nobjs++] = obj;
> @@ -397,6 +408,11 @@ void kvm_mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
>                 else
>                         free_page((unsigned long)mc->objects[--mc->nobjs]);
>         }
> +
> +       kvfree(mc->objects);
> +
> +       /* Note, must set to NULL to avoid use-after-free in the next top-up. */
> +       mc->objects = NULL;
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
