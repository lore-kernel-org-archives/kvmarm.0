From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v3] kvm: arm/arm64: Fix locking for kvm_free_stage2_pgd
Date: Tue, 4 Apr 2017 11:35:35 +0100
Message-ID: <28bece63-9917-5f00-ccdf-fe663def500f@arm.com>
References: <1491228763-23450-1-git-send-email-suzuki.poulose@arm.com>
 <20170404101316.GF11752@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0DBC40A6A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 06:33:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fb90HxxRBBah for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Apr 2017 06:33:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FDCD40992
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 06:33:28 -0400 (EDT)
In-Reply-To: <20170404101316.GF11752@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, ard.biesheuvel@linaro.org, marc.zyngier@arm.com, andreyknvl@google.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, kcc@google.com, syzkaller@googlegroups.com, dvyukov@google.com, catalin.marinas@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer,

On 04/04/17 11:13, Christoffer Dall wrote:
> Hi Suzuki,
>
> On Mon, Apr 03, 2017 at 03:12:43PM +0100, Suzuki K Poulose wrote:
>> In kvm_free_stage2_pgd() we don't hold the kvm->mmu_lock while calling
>> unmap_stage2_range() on the entire memory range for the guest. This could
>> cause problems with other callers (e.g, munmap on a memslot) trying to
>> unmap a range. And since we have to unmap the entire Guest memory range
>> holding a spinlock, make sure we yield the lock if necessary, after we
>> unmap each PUD range.
>>
>> Fixes: commit d5d8184d35c9 ("KVM: ARM: Memory virtualization setup")
>> Cc: stable@vger.kernel.org # v3.10+
>> Cc: Paolo Bonzini <pbonzin@redhat.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@linaro.org>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> [ Avoid vCPU starvation and lockup detector warnings ]
>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>>
>
> This unfortunately fails to build on 32-bit ARM, and I also think we
> intended to check against S2_PGDIR_SIZE, not S2_PUD_SIZE.

Sorry about that, I didn't test the patch with arm32. I am fine the
patch below. And I agree that the name change does make things more
readable. See below for a hunk that I posted to the kbuild report.

>
> How about adding this to your patch (which includes a rename of
> S2_PGD_SIZE which is horribly confusing as it indicates the size of the
> first level stage-2 table itself, where S2_PGDIR_SIZE indicates the size
> of address space mapped by a single entry in the same table):
>
> diff --git a/arch/arm/include/asm/stage2_pgtable.h b/arch/arm/include/asm/stage2_pgtable.h
> index 460d616..c997f2d 100644
> --- a/arch/arm/include/asm/stage2_pgtable.h
> +++ b/arch/arm/include/asm/stage2_pgtable.h
> @@ -35,10 +35,13 @@
>
>  #define stage2_pud_huge(pud)			pud_huge(pud)
>
> +#define S2_PGDIR_SIZE				PGDIR_SIZE
> +#define S2_PGDIR_MASK				PGDIR_MASK
> +
>  /* Open coded p*d_addr_end that can deal with 64bit addresses */
>  static inline phys_addr_t stage2_pgd_addr_end(phys_addr_t addr, phys_addr_t end)
>  {
> -	phys_addr_t boundary = (addr + PGDIR_SIZE) & PGDIR_MASK;
> +	phys_addr_t boundary = (addr + S2_PGDIR_SIZE) & S2_PGDIR_MASK;
>
>  	return (boundary - 1 < end - 1) ? boundary : end;
>  }
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index db94f3a..6e79a4c 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -41,7 +41,7 @@ static unsigned long hyp_idmap_start;
>  static unsigned long hyp_idmap_end;
>  static phys_addr_t hyp_idmap_vector;
>
> -#define S2_PGD_SIZE	(PTRS_PER_S2_PGD * sizeof(pgd_t))
> +#define S2_PGD_TABLE_SIZE	(PTRS_PER_S2_PGD * sizeof(pgd_t))
>  #define hyp_pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
>
>  #define KVM_S2PTE_FLAG_IS_IOMAP		(1UL << 0)
> @@ -299,7 +299,7 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
>  		 * If the range is too large, release the kvm->mmu_lock
>  		 * to prevent starvation and lockup detector warnings.
>  		 */
> -		if (size > S2_PUD_SIZE)
> +		if (size > S2_PGDIR_SIZE)
>  			cond_resched_lock(&kvm->mmu_lock);
>  		next = stage2_pgd_addr_end(addr, end);
>  		if (!stage2_pgd_none(*pgd))
> @@ -747,7 +747,7 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
>  	}
>
>  	/* Allocate the HW PGD, making sure that each page gets its own refcount */
> -	pgd = alloc_pages_exact(S2_PGD_SIZE, GFP_KERNEL | __GFP_ZERO);
> +	pgd = alloc_pages_exact(S2_PGD_TABLE_SIZE, GFP_KERNEL | __GFP_ZERO);
>  	if (!pgd)
>  		return -ENOMEM;
>
> @@ -843,7 +843,7 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
>  	spin_unlock(&kvm->mmu_lock);
>
>  	/* Free the HW pgd, one page at a time */
> -	free_pages_exact(kvm->arch.pgd, S2_PGD_SIZE);
> +	free_pages_exact(kvm->arch.pgd, S2_PGD_TABLE_SIZE);
>  	kvm->arch.pgd = NULL;
>  }
>

Btw, I have a different hunk to solve the problem, posted to the kbuild
report. I will post it here for the sake of capturing the discussion in
one place. The following hunk on top of the patch, changes the lock
release after we process one PGDIR entry. As for the first time
we enter the loop we haven't done much with the lock held, hence it may make
sense to do it after the first round and we have more work to do.

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index db94f3a..582a972 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -295,15 +295,15 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
         assert_spin_locked(&kvm->mmu_lock);
         pgd = kvm->arch.pgd + stage2_pgd_index(addr);
         do {
+               next = stage2_pgd_addr_end(addr, end);
+               if (!stage2_pgd_none(*pgd))
+                       unmap_stage2_puds(kvm, pgd, addr, next);
                 /*
                  * If the range is too large, release the kvm->mmu_lock
                  * to prevent starvation and lockup detector warnings.
                  */
-               if (size > S2_PUD_SIZE)
+               if (next != end)
                         cond_resched_lock(&kvm->mmu_lock);
-               next = stage2_pgd_addr_end(addr, end);
-               if (!stage2_pgd_none(*pgd))
-                       unmap_stage2_puds(kvm, pgd, addr, next);
         } while (pgd++, addr = next, addr != end);
  }
