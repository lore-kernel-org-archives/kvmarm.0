From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v1 08/16] kvm: arm/arm64: Clean up stage2 pgd life time
Date: Thu, 8 Feb 2018 12:00:59 +0100
Message-ID: <20180208110059.GK29286@cbox>
References: <20180109190414.4017-1-suzuki.poulose@arm.com>
 <20180109190414.4017-9-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180109190414.4017-9-suzuki.poulose@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, linux-kernel@vger.kernel.org, kristina.martsenko@arm.com, peter.maydell@linaro.org, pbonzini@redhat.com, rkrcmar@redhat.com, will.deacon@arm.com, ard.biesheuvel@linaro.org, mark.rutland@arm.com, catalin.marinas@arm.com, Christoffer Dall <cdall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Jan 09, 2018 at 07:04:03PM +0000, Suzuki K Poulose wrote:
> On arm/arm64 we pre-allocate the entry level page tables when
> a VM is created and is free'd when either all the mm users are
> gone or the KVM is about to get destroyed. i.e, kvm_free_stage2_pgd
> is triggered via kvm_arch_flush_shadow_all() which can be invoked
> from two different paths :
> 
>  1) do_exit()-> .-> mmu_notifier->release()-> ..-> kvm_arch_flush_shadow_all()
>     OR
>  2) kvm_destroy_vm()-> mmu_notifier_unregister-> kvm_arch_flush_shadow_all()
> 
> This has created lot of race conditions in the past as some of
> the VCPUs could be active when we free the stage2 via path (1).

How??  mmu_notifier->release() is called via __mput->exit_mmap(), which
is only called if mm_users == 0, which means there are no more threads
left than the one currently doing exit().

> 
> On a closer look, all we need to do with kvm_arch_flush_shadow_all() is,
> to ensure that the stage2 mappings are cleared. This doesn't mean we
> have to free up the stage2 entry level page tables yet, which could
> be delayed until the kvm is destroyed. This would avoid issues
> of use-after-free,

do we have any of those left?

> This will be later used for delaying
> the allocation of the stage2 entry level page tables until we really
> need to do something with it.

Fine, but you don't actually explain why this change of flow is
necessary for what you're trying to do later?

> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <cdall@linaro.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
>  virt/kvm/arm/arm.c |  1 +
>  virt/kvm/arm/mmu.c | 56 ++++++++++++++++++++++++++++--------------------------
>  2 files changed, 30 insertions(+), 27 deletions(-)
> 
> diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
> index c8d49879307f..19b720ddedce 100644
> --- a/virt/kvm/arm/arm.c
> +++ b/virt/kvm/arm/arm.c
> @@ -189,6 +189,7 @@ void kvm_arch_destroy_vm(struct kvm *kvm)
>  		}
>  	}
>  	atomic_set(&kvm->online_vcpus, 0);
> +	kvm_free_stage2_pgd(kvm);
>  }
>  
>  int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 78253fe00fc4..c94c61ac38b9 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -298,11 +298,10 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
>  	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
>  	do {
>  		/*
> -		 * Make sure the page table is still active, as another thread
> -		 * could have possibly freed the page table, while we released
> -		 * the lock.
> +		 * The page table shouldn't be free'd as we still hold a reference
> +		 * to the KVM.

To avoid confusion about references to the kernel module KVM and a
specific KVM VM instance, please s/KVM/VM/.

>  		 */
> -		if (!READ_ONCE(kvm->arch.pgd))
> +		if (WARN_ON(!READ_ONCE(kvm->arch.pgd)))

This reads a lot like a defensive implementation now, and I think for
this patch to make sense, we shouldn't try to handle a buggy super-racy
implementation gracefully, but rather have VM_BUG_ON() (if we care about
performance of the check) or simply BUG_ON().

The rationale being that if we've gotten this flow incorrect and freed
the pgd at the wrong time, we don't want to leave a ticking bomb to blow
up somewhere else randomly (which it will!), but instead crash and burn.

>  			break;
>  		next = stage2_pgd_addr_end(addr, end);
>  		if (!stage2_pgd_none(*pgd))
> @@ -837,30 +836,33 @@ void stage2_unmap_vm(struct kvm *kvm)
>  	up_read(&current->mm->mmap_sem);
>  	srcu_read_unlock(&kvm->srcu, idx);
>  }
> -
> -/**
> - * kvm_free_stage2_pgd - free all stage-2 tables
> - * @kvm:	The KVM struct pointer for the VM.
> - *
> - * Walks the level-1 page table pointed to by kvm->arch.pgd and frees all
> - * underlying level-2 and level-3 tables before freeing the actual level-1 table
> - * and setting the struct pointer to NULL.
> +/*
> + * kvm_flush_stage2_all: Unmap the entire stage2 mappings including
> + * device and regular RAM backing memory.
>   */
> -void kvm_free_stage2_pgd(struct kvm *kvm)
> +static void kvm_flush_stage2_all(struct kvm *kvm)
>  {
> -	void *pgd = NULL;
> -
>  	spin_lock(&kvm->mmu_lock);
> -	if (kvm->arch.pgd) {
> +	if (kvm->arch.pgd)
>  		unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
> -		pgd = READ_ONCE(kvm->arch.pgd);
> -		kvm->arch.pgd = NULL;
> -	}
>  	spin_unlock(&kvm->mmu_lock);
> +}
>  
> -	/* Free the HW pgd, one page at a time */
> -	if (pgd)
> -		free_pages_exact(pgd, S2_PGD_SIZE);
> +/**
> + * kvm_free_stage2_pgd - Free the entry level page tables in stage-2.

nit: you should put the parameter description here and leave a blank
line before the lengthy discussion.

> + * This is called when all reference to the KVM has gone away and we
> + * really don't need any protection in resetting the PGD. This also

I don't think I understand the last part of this sentence.

This function is pretty self-explanatory really, and I think we can
either drop the documentation all together or simply say that this
function clears all stage 2 page table entries to release the memory of
the lower-level page tables themselves and then frees the pgd in the
end.  The VM is known to go away and no more VCPUs exist at this point.

> + * means that nobody should be touching stage2 at this point, as we
> + * have unmapped the entire stage2 already and all dynamic entities,
> + * (VCPUs and devices) are no longer active.
> + *
> + * @kvm:	The KVM struct pointer for the VM.
> + */
> +void kvm_free_stage2_pgd(struct kvm *kvm)
> +{
> +	kvm_flush_stage2_all(kvm);
> +	free_pages_exact(kvm->arch.pgd, S2_PGD_SIZE);
> +	kvm->arch.pgd = NULL;
>  }
>  
>  static pud_t *stage2_get_pud(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
> @@ -1189,12 +1191,12 @@ static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
>  		 * large. Otherwise, we may see kernel panics with
>  		 * CONFIG_DETECT_HUNG_TASK, CONFIG_LOCKUP_DETECTOR,
>  		 * CONFIG_LOCKDEP. Additionally, holding the lock too long
> -		 * will also starve other vCPUs. We have to also make sure
> -		 * that the page tables are not freed while we released
> -		 * the lock.
> +		 * will also starve other vCPUs.
> +		 * The page tables shouldn't be free'd while we released the

s/shouldn't/can't/

> +		 * lock, since we hold a reference to the KVM.

s/KVM/VM/

>  		 */
>  		cond_resched_lock(&kvm->mmu_lock);
> -		if (!READ_ONCE(kvm->arch.pgd))
> +		if (WARN_ON(!READ_ONCE(kvm->arch.pgd)))
>  			break;
>  		next = stage2_pgd_addr_end(addr, end);
>  		if (stage2_pgd_present(*pgd))
> @@ -1950,7 +1952,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, struct kvm_memslots *slots)
>  
>  void kvm_arch_flush_shadow_all(struct kvm *kvm)
>  {
> -	kvm_free_stage2_pgd(kvm);
> +	kvm_flush_stage2_all(kvm);
>  }
>  
>  void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
> -- 
> 2.13.6
> 

Thanks,
-Christoffer
