Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2AEC433F5
	for <kvmarm@archiver.kernel.org>; Tue, 25 Jan 2022 13:22:45 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 203844083E;
	Tue, 25 Jan 2022 08:22:45 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6ZvYi5Q6L4iy; Tue, 25 Jan 2022 08:22:43 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C5A3441003;
	Tue, 25 Jan 2022 08:22:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC07C41003
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 08:22:41 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id r-zMhL2heORG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Jan 2022 08:22:40 -0500 (EST)
Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com
 [209.85.167.173])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4CD274083E
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 08:22:40 -0500 (EST)
Received: by mail-oi1-f173.google.com with SMTP id s9so30871667oib.11
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Jan 2022 05:22:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=mime-version:references:in-reply-to:from:date:message-id:subject:to
 :cc; bh=aZqUIlm4PvtJlcx9bRdDGrSDogo725VWLZaRdcVhoa0=;
 b=iDkwH6BdBn7ZudT5jGT+bAtp8x9UEMX9taW9pwmkBeWl3VLuWFtgadqeNOdkOiFply
 5jNbQMDzH3uqgodmXACE6eoYtQ0lXndqYh8j+LxtV8hxOos8uykInR2qSpEF2xWj7RL6
 Q1cXZp6+Uu0DUJZ+h2Cs+78Bxgf9sTURDTlGibrZF2+XGtOr4SRdjKIMErWXBaUg6bRo
 fde3XT7aTdIbD5GlCGc38OcWmJE+WiZ7NHSW1CA9g9rcqmI4mE6XXioZUw7iQjcezgNj
 d38NtfGoyMlu7U9oU/SliZL0eYjsW3kDw7gp1RKcqOcFSWk2C1xxZhQL1qbPZ7xCOad7
 VdNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:mime-version:references:in-reply-to:from:date
 :message-id:subject:to:cc;
 bh=aZqUIlm4PvtJlcx9bRdDGrSDogo725VWLZaRdcVhoa0=;
 b=i1m/dyxCgKvpb/rGEo0JogAyx5UcP1dfW+eFAiGFcn9RfGmgCogWyLpR2rC646nwnM
 r+M83Qe/vV7dzpcIonkGvEWgqm6AV7vX1V2gL7RWBzCzTT608xKOgvp1IySRG4SVgzl/
 LrjUVZnuQ4XO8imeAgpKX9CWXXIrQRqemw8bhFTUp999/uH4bdUdKLwtGlZl0r8+B44k
 nbiOc1uUlVubDC2tq/LpWJGr0pjAzV0lfImGrsl2d247JUrIvZATvNLJd1uIIPS3gigh
 halbSJs6S2600dGWP+Qddh9+EV4D0tGa4F1AoKAcmIHNpYANX6uJRtWdSUu7K/5/kvVd
 N8iA==
X-Gm-Message-State: AOAM532b40rKAZek3oHvHd3MYoPY00Orv0kBrQ9B8KY2+BTWOxYbqvAq
 lv5sO1bakV9Woq2UpwhfuhQSq2vsFJUnO46LKvYbsQ==
X-Google-Smtp-Source: ABdhPJzMLwLIYDJONpUkGz4SJ/EhA3LdVHMhbBMl+Al394fvAYZIoKOdmC+i2H9D+sqiDiSCUOIaVac7X2yO2iSVYYI=
X-Received: by 2002:a05:6808:1785:: with SMTP id
 bg5mr578166oib.171.1643116959083; 
 Tue, 25 Jan 2022 05:22:39 -0800 (PST)
MIME-Version: 1.0
References: <20220118015703.3630552-1-jingzhangos@google.com>
 <20220118015703.3630552-2-jingzhangos@google.com>
In-Reply-To: <20220118015703.3630552-2-jingzhangos@google.com>
From: Fuad Tabba <tabba@google.com>
Date: Tue, 25 Jan 2022 13:22:03 +0000
Message-ID: <CA+EHjTw0NHow89cnPV4h0YZAZ32be6+_CQCqVov34xEUuuaa0w@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] KVM: arm64: Use read/write spin lock for MMU
 protection
To: Jing Zhang <jingzhangos@google.com>
Cc: KVM <kvm@vger.kernel.org>, Marc Zyngier <maz@kernel.org>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>
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

Hi Jing,

On Tue, Jan 18, 2022 at 1:57 AM Jing Zhang <jingzhangos@google.com> wrote:
>
> Replace MMU spinlock with rwlock and update all instances of the lock
> being acquired with a write lock acquisition.
> Future commit will add a fast path for permission relaxation during
> dirty logging under a read lock.

Looking at the code, building it and running it, it seems that all
instances of the lock are covered.

Tested-by: Fuad Tabba <tabba@google.com>
Reviewed-by: Fuad Tabba <tabba@google.com>

Thanks,
/fuad




> Signed-off-by: Jing Zhang <jingzhangos@google.com>
> ---
>  arch/arm64/include/asm/kvm_host.h |  2 ++
>  arch/arm64/kvm/mmu.c              | 36 +++++++++++++++----------------
>  2 files changed, 20 insertions(+), 18 deletions(-)
>
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 3b44ea17af88..6c99c0335bae 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -50,6 +50,8 @@
>  #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
>                                      KVM_DIRTY_LOG_INITIALLY_SET)
>
> +#define KVM_HAVE_MMU_RWLOCK
> +
>  /*
>   * Mode of operation configurable with kvm-arm.mode early param.
>   * See Documentation/admin-guide/kernel-parameters.txt for more information.
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index bc2aba953299..cafd5813c949 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -58,7 +58,7 @@ static int stage2_apply_range(struct kvm *kvm, phys_addr_t addr,
>                         break;
>
>                 if (resched && next != end)
> -                       cond_resched_lock(&kvm->mmu_lock);
> +                       cond_resched_rwlock_write(&kvm->mmu_lock);
>         } while (addr = next, addr != end);
>
>         return ret;
> @@ -179,7 +179,7 @@ static void __unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64
>         struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>         phys_addr_t end = start + size;
>
> -       assert_spin_locked(&kvm->mmu_lock);
> +       lockdep_assert_held_write(&kvm->mmu_lock);
>         WARN_ON(size & ~PAGE_MASK);
>         WARN_ON(stage2_apply_range(kvm, start, end, kvm_pgtable_stage2_unmap,
>                                    may_block));
> @@ -213,13 +213,13 @@ static void stage2_flush_vm(struct kvm *kvm)
>         int idx, bkt;
>
>         idx = srcu_read_lock(&kvm->srcu);
> -       spin_lock(&kvm->mmu_lock);
> +       write_lock(&kvm->mmu_lock);
>
>         slots = kvm_memslots(kvm);
>         kvm_for_each_memslot(memslot, bkt, slots)
>                 stage2_flush_memslot(kvm, memslot);
>
> -       spin_unlock(&kvm->mmu_lock);
> +       write_unlock(&kvm->mmu_lock);
>         srcu_read_unlock(&kvm->srcu, idx);
>  }
>
> @@ -720,13 +720,13 @@ void stage2_unmap_vm(struct kvm *kvm)
>
>         idx = srcu_read_lock(&kvm->srcu);
>         mmap_read_lock(current->mm);
> -       spin_lock(&kvm->mmu_lock);
> +       write_lock(&kvm->mmu_lock);
>
>         slots = kvm_memslots(kvm);
>         kvm_for_each_memslot(memslot, bkt, slots)
>                 stage2_unmap_memslot(kvm, memslot);
>
> -       spin_unlock(&kvm->mmu_lock);
> +       write_unlock(&kvm->mmu_lock);
>         mmap_read_unlock(current->mm);
>         srcu_read_unlock(&kvm->srcu, idx);
>  }
> @@ -736,14 +736,14 @@ void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu)
>         struct kvm *kvm = kvm_s2_mmu_to_kvm(mmu);
>         struct kvm_pgtable *pgt = NULL;
>
> -       spin_lock(&kvm->mmu_lock);
> +       write_lock(&kvm->mmu_lock);
>         pgt = mmu->pgt;
>         if (pgt) {
>                 mmu->pgd_phys = 0;
>                 mmu->pgt = NULL;
>                 free_percpu(mmu->last_vcpu_ran);
>         }
> -       spin_unlock(&kvm->mmu_lock);
> +       write_unlock(&kvm->mmu_lock);
>
>         if (pgt) {
>                 kvm_pgtable_stage2_destroy(pgt);
> @@ -783,10 +783,10 @@ int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>                 if (ret)
>                         break;
>
> -               spin_lock(&kvm->mmu_lock);
> +               write_lock(&kvm->mmu_lock);
>                 ret = kvm_pgtable_stage2_map(pgt, addr, PAGE_SIZE, pa, prot,
>                                              &cache);
> -               spin_unlock(&kvm->mmu_lock);
> +               write_unlock(&kvm->mmu_lock);
>                 if (ret)
>                         break;
>
> @@ -834,9 +834,9 @@ static void kvm_mmu_wp_memory_region(struct kvm *kvm, int slot)
>         start = memslot->base_gfn << PAGE_SHIFT;
>         end = (memslot->base_gfn + memslot->npages) << PAGE_SHIFT;
>
> -       spin_lock(&kvm->mmu_lock);
> +       write_lock(&kvm->mmu_lock);
>         stage2_wp_range(&kvm->arch.mmu, start, end);
> -       spin_unlock(&kvm->mmu_lock);
> +       write_unlock(&kvm->mmu_lock);
>         kvm_flush_remote_tlbs(kvm);
>  }
>
> @@ -1212,7 +1212,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         if (exec_fault && device)
>                 return -ENOEXEC;
>
> -       spin_lock(&kvm->mmu_lock);
> +       write_lock(&kvm->mmu_lock);
>         pgt = vcpu->arch.hw_mmu->pgt;
>         if (mmu_notifier_retry(kvm, mmu_seq))
>                 goto out_unlock;
> @@ -1271,7 +1271,7 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>         }
>
>  out_unlock:
> -       spin_unlock(&kvm->mmu_lock);
> +       write_unlock(&kvm->mmu_lock);
>         kvm_set_pfn_accessed(pfn);
>         kvm_release_pfn_clean(pfn);
>         return ret != -EAGAIN ? ret : 0;
> @@ -1286,10 +1286,10 @@ static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>
>         trace_kvm_access_fault(fault_ipa);
>
> -       spin_lock(&vcpu->kvm->mmu_lock);
> +       write_lock(&vcpu->kvm->mmu_lock);
>         mmu = vcpu->arch.hw_mmu;
>         kpte = kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
> -       spin_unlock(&vcpu->kvm->mmu_lock);
> +       write_unlock(&vcpu->kvm->mmu_lock);
>
>         pte = __pte(kpte);
>         if (pte_valid(pte))
> @@ -1692,9 +1692,9 @@ void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
>         gpa_t gpa = slot->base_gfn << PAGE_SHIFT;
>         phys_addr_t size = slot->npages << PAGE_SHIFT;
>
> -       spin_lock(&kvm->mmu_lock);
> +       write_lock(&kvm->mmu_lock);
>         unmap_stage2_range(&kvm->arch.mmu, gpa, size);
> -       spin_unlock(&kvm->mmu_lock);
> +       write_unlock(&kvm->mmu_lock);
>  }
>
>  /*
> --
> 2.34.1.703.g22d0c6ccf7-goog
>
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
