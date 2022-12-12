Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52220C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 12 Dec 2022 22:03:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD04E4B93A;
	Mon, 12 Dec 2022 17:03:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wQ6yKz5OFOPb; Mon, 12 Dec 2022 17:03:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31D1C4B955;
	Mon, 12 Dec 2022 17:03:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 808644B93A
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:03:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZyXDg5UMXe6e for <kvmarm@lists.cs.columbia.edu>;
 Mon, 12 Dec 2022 17:03:32 -0500 (EST)
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com
 [209.85.222.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E10974B939
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 17:03:32 -0500 (EST)
Received: by mail-qk1-f179.google.com with SMTP id pa22so3580211qkn.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 12 Dec 2022 14:03:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:from:to:cc:subject:date:message-id:reply-to;
 bh=H8tNx4JMG+gKP0BZeEF6ikCYeMz41r++QkWX8vYlQZM=;
 b=fxTE10OGf3TVyQxMLoDuqEMEvCKCuX6oKKQscuWuJW8s4G4XvLTdmuezqay8Mg9JYm
 SjIqhlKCJR0Ww+iau0nkyCwnH23sgTOWqnOZvVoQPS4gyvJllvkixGnDaHuYM4MSpPUH
 vlJ5QwL4fXZJkiYDMnhBNhlnIqrbtZ9SwiH8+UXOIFOatiUaZvTURGeq3eeSOKyLuZAK
 He3GLK1W5lEJMqftamCtWkFaxkazZNUe3RGAfK7LbqQH1pwQ3zt3YGHNkoXzME6bNoHB
 S2ESaoEY+DI1mjVH8CgA7w+zhvFCLohTewNQOniHfIQ5HYoZ0uBPJGaY1xD8goR0I/Fi
 l7HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:subject:message-id:date:from:in-reply-to:references
 :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
 :reply-to;
 bh=H8tNx4JMG+gKP0BZeEF6ikCYeMz41r++QkWX8vYlQZM=;
 b=v+KD+WyXV+VMnSpvKDrq+dfOqgFmVeO0A0HNQL6Mgqv7+OQt7VNsqO5bwmPooBXI3t
 3Or3g/rfX65PREbnpwOeiz9yKof/NZrN88pOeGkFTyRtLtoZDm/tlIyc8TnOUNYWaHPF
 sMCiEFoSnsLepIqutWkUG8a9SzLDg5PSKBNbpjmq5ydW1mt/j5tcg0p81+MiLpL0MAcY
 pFUbLwQBTzN4TOzCBye1YW5o7757OmDqpqFBhzSgMnqj+STLfMHKI82vCTaF0eyVDJYy
 wjr+nEF+KYDfPrGnjmawDoLG7830CCdi32gPpqiFJtr7QYV3gj187ocEzP+Ct6FovxFa
 8pPg==
X-Gm-Message-State: ANoB5pmKM7NG/Zol2u/NcSyeLCDRl6N1R1jbaxz2roAM+IysDJ422Civ
 iL3927Qf0QVcZyqly6mtPIHu8pJd6IxT8bIdr6ADWg==
X-Google-Smtp-Source: AA0mqf6Lfo5iFMd62emQsE/GPr8MrnqXMWIYcSRSfcv9BTwdZvHpZDZvH+CRfINtutrDx+tvKeU8pqz46nZZZu5exoY=
X-Received: by 2002:a37:808:0:b0:6fe:d95e:3cae with SMTP id
 8-20020a370808000000b006fed95e3caemr8457916qki.768.1670882612067; Mon, 12 Dec
 2022 14:03:32 -0800 (PST)
MIME-Version: 1.0
References: <20221208193857.4090582-1-dmatlack@google.com>
 <20221208193857.4090582-34-dmatlack@google.com>
In-Reply-To: <20221208193857.4090582-34-dmatlack@google.com>
From: Ben Gardon <bgardon@google.com>
Date: Mon, 12 Dec 2022 14:03:20 -0800
Message-ID: <CANgfPd_069QPNby+mR4GuOWDNJtFk_=9EOffb0=2_V5TH-ZCDA@mail.gmail.com>
Subject: Re: [RFC PATCH 33/37] KVM: Move kvm_arch_flush_remote_tlbs_memslot()
 to common code
To: David Matlack <dmatlack@google.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
 Hugh Dickins <hughd@google.com>, Paul Walmsley <paul.walmsley@sifive.com>,
 Nadav Amit <namit@vmware.com>, Colin Cross <ccross@google.com>,
 linux-riscv@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Yu Zhao <yuzhao@google.com>, Marc Zyngier <maz@kernel.org>,
 Huacai Chen <chenhuacai@kernel.org>,
 "Matthew Wilcox \(Oracle\)" <willy@infradead.org>,
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>,
 Krish Sadhukhan <krish.sadhukhan@oracle.com>,
 Palmer Dabbelt <palmer@dabbelt.com>, Mingwei Zhang <mizhang@google.com>,
 Albert Ou <aou@eecs.berkeley.edu>, xu xin <cgel.zte@gmail.com>,
 Arnd Bergmann <arnd@arndb.de>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 kvm@vger.kernel.org, Atish Patra <atishp@atishpatra.org>,
 kvmarm@lists.linux.dev, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, linux-arm-kernel@lists.infradead.org,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 Paolo Bonzini <pbonzini@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
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

On Thu, Dec 8, 2022 at 11:40 AM David Matlack <dmatlack@google.com> wrote:
>
> Move kvm_arch_flush_remote_tlbs_memslot() to common code and drop
> "arch_" from the name. kvm_arch_flush_remote_tlbs_memslot() is just a
> range-based TLB invalidation where the range is defined by the memslot.
> Now that kvm_flush_remote_tlbs_range() can be called from common code we
> can just use that and drop a bunch of duplicate code from the arch
> directories.
>
> Note this adds a lockdep assertion for slot_lock being held when calling
> kvm_flush_remote_tlbs_memslot(), which was previously only asserted on
> x86.

Besides the one lockdep assertion, is there any benefit to having this
wrapper function? Open-coding "kvm_flush_remote_tlbs_range(kvm,
memslot->base_gfn, memslot->npages);" is only a slightly longer line
and, IMO, just as readable. I'm happy to see this cleanup, but it
might be just as easy to drop the function.

>
> Signed-off-by: David Matlack <dmatlack@google.com>
> ---
>  arch/arm64/kvm/arm.c     |  6 ------
>  arch/mips/kvm/mips.c     | 10 ++--------
>  arch/riscv/kvm/mmu.c     |  6 ------
>  arch/x86/kvm/mmu/mmu.c   | 16 +---------------
>  arch/x86/kvm/x86.c       |  2 +-
>  include/linux/kvm_host.h |  7 +++----
>  virt/kvm/kvm_main.c      | 17 +++++++++++++++--
>  7 files changed, 22 insertions(+), 42 deletions(-)
>
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 0e0d4c4f79a2..4f1549c1d2d2 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1430,12 +1430,6 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>
>  }
>
> -void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -                                       const struct kvm_memory_slot *memslot)
> -{
> -       kvm_flush_remote_tlbs(kvm);
> -}
> -
>  static int kvm_vm_ioctl_set_device_addr(struct kvm *kvm,
>                                         struct kvm_arm_device_addr *dev_addr)
>  {
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index a25e0b73ee70..ecd8a051fd6b 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -209,7 +209,7 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>         /* Flush slot from GPA */
>         kvm_mips_flush_gpa_pt(kvm, slot->base_gfn,
>                               slot->base_gfn + slot->npages - 1);
> -       kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> +       kvm_flush_remote_tlbs_memslot(kvm, slot);
>         spin_unlock(&kvm->mmu_lock);
>  }
>
> @@ -245,7 +245,7 @@ void kvm_arch_commit_memory_region(struct kvm *kvm,
>                 needs_flush = kvm_mips_mkclean_gpa_pt(kvm, new->base_gfn,
>                                         new->base_gfn + new->npages - 1);
>                 if (needs_flush)
> -                       kvm_arch_flush_remote_tlbs_memslot(kvm, new);
> +                       kvm_flush_remote_tlbs_memslot(kvm, new);
>                 spin_unlock(&kvm->mmu_lock);
>         }
>  }
> @@ -997,12 +997,6 @@ int kvm_arch_flush_remote_tlb(struct kvm *kvm)
>         return 1;
>  }
>
> -void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -                                       const struct kvm_memory_slot *memslot)
> -{
> -       kvm_flush_remote_tlbs(kvm);
> -}
> -
>  long kvm_arch_vm_ioctl(struct file *filp, unsigned int ioctl, unsigned long arg)
>  {
>         long r;
> diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
> index a8281a65cb3d..98bf3719a396 100644
> --- a/arch/riscv/kvm/mmu.c
> +++ b/arch/riscv/kvm/mmu.c
> @@ -406,12 +406,6 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>  {
>  }
>
> -void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -                                       const struct kvm_memory_slot *memslot)
> -{
> -       kvm_flush_remote_tlbs(kvm);
> -}
> -
>  void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free)
>  {
>  }
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index 19963ed83484..f2602ee1771f 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -6524,7 +6524,7 @@ static void kvm_rmap_zap_collapsible_sptes(struct kvm *kvm,
>          */
>         if (slot_handle_level(kvm, slot, kvm_mmu_zap_collapsible_spte,
>                               PG_LEVEL_4K, KVM_MAX_HUGEPAGE_LEVEL - 1, true))
> -               kvm_arch_flush_remote_tlbs_memslot(kvm, slot);
> +               kvm_flush_remote_tlbs_memslot(kvm, slot);
>  }
>
>  void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
> @@ -6543,20 +6543,6 @@ void kvm_mmu_zap_collapsible_sptes(struct kvm *kvm,
>         }
>  }
>
> -void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -                                       const struct kvm_memory_slot *memslot)
> -{
> -       /*
> -        * All current use cases for flushing the TLBs for a specific memslot
> -        * related to dirty logging, and many do the TLB flush out of mmu_lock.
> -        * The interaction between the various operations on memslot must be
> -        * serialized by slots_locks to ensure the TLB flush from one operation
> -        * is observed by any other operation on the same memslot.
> -        */
> -       lockdep_assert_held(&kvm->slots_lock);
> -       kvm_flush_remote_tlbs_range(kvm, memslot->base_gfn, memslot->npages);
> -}
> -
>  void kvm_mmu_slot_leaf_clear_dirty(struct kvm *kvm,
>                                    const struct kvm_memory_slot *memslot)
>  {
> diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
> index 517c8ed33542..95ff95da55d5 100644
> --- a/arch/x86/kvm/x86.c
> +++ b/arch/x86/kvm/x86.c
> @@ -12574,7 +12574,7 @@ static void kvm_mmu_slot_apply_flags(struct kvm *kvm,
>                  * See is_writable_pte() for more details (the case involving
>                  * access-tracked SPTEs is particularly relevant).
>                  */
> -               kvm_arch_flush_remote_tlbs_memslot(kvm, new);
> +               kvm_flush_remote_tlbs_memslot(kvm, new);
>         }
>  }
>
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index d9a7f559d2c5..46ed0ef4fb79 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1366,6 +1366,8 @@ void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool usermode_vcpu_not_eligible);
>
>  void kvm_flush_remote_tlbs(struct kvm *kvm);
>  void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
> +void kvm_flush_remote_tlbs_memslot(struct kvm *kvm,
> +                                  const struct kvm_memory_slot *memslot);
>
>  #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
>  int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
> @@ -1394,10 +1396,7 @@ void kvm_arch_mmu_enable_log_dirty_pt_masked(struct kvm *kvm,
>                                         unsigned long mask);
>  void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot);
>
> -#ifdef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
> -void kvm_arch_flush_remote_tlbs_memslot(struct kvm *kvm,
> -                                       const struct kvm_memory_slot *memslot);
> -#else /* !CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT */
> +#ifndef CONFIG_KVM_GENERIC_DIRTYLOG_READ_PROTECT
>  int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log);
>  int kvm_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log,
>                       int *is_dirty, struct kvm_memory_slot **memslot);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 662ca280c0cf..39c2efd15504 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -388,6 +388,19 @@ void __weak kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pa
>         kvm_flush_remote_tlbs(kvm);
>  }
>
> +void kvm_flush_remote_tlbs_memslot(struct kvm *kvm, const struct kvm_memory_slot *memslot)
> +{
> +       /*
> +        * All current use cases for flushing the TLBs for a specific memslot
> +        * related to dirty logging, and many do the TLB flush out of mmu_lock.
> +        * The interaction between the various operations on memslot must be
> +        * serialized by slots_locks to ensure the TLB flush from one operation
> +        * is observed by any other operation on the same memslot.
> +        */
> +       lockdep_assert_held(&kvm->slots_lock);
> +       kvm_flush_remote_tlbs_range(kvm, memslot->base_gfn, memslot->npages);
> +}
> +
>  static void kvm_flush_shadow_all(struct kvm *kvm)
>  {
>         kvm_arch_flush_shadow_all(kvm);
> @@ -2197,7 +2210,7 @@ static int kvm_get_dirty_log_protect(struct kvm *kvm, struct kvm_dirty_log *log)
>         }
>
>         if (flush)
> -               kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
> +               kvm_flush_remote_tlbs_memslot(kvm, memslot);
>
>         if (copy_to_user(log->dirty_bitmap, dirty_bitmap_buffer, n))
>                 return -EFAULT;
> @@ -2314,7 +2327,7 @@ static int kvm_clear_dirty_log_protect(struct kvm *kvm,
>         KVM_MMU_UNLOCK(kvm);
>
>         if (flush)
> -               kvm_arch_flush_remote_tlbs_memslot(kvm, memslot);
> +               kvm_flush_remote_tlbs_memslot(kvm, memslot);
>
>         return 0;
>  }
> --
> 2.39.0.rc1.256.g54fd8350bd-goog
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
