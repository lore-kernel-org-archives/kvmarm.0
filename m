From: Christoffer Dall <cdall@linaro.org>
Subject: Re: [PATCH v3] kvm: arm/arm64: Fix locking for kvm_free_stage2_pgd
Date: Tue, 4 Apr 2017 12:13:16 +0200
Message-ID: <20170404101316.GF11752@cbox>
References: <1491228763-23450-1-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D9DF40B58
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 06:11:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tJQPS9gQsJIs for <kvmarm@lists.cs.columbia.edu>;
 Tue,  4 Apr 2017 06:11:04 -0400 (EDT)
Received: from mail-wr0-f172.google.com (mail-wr0-f172.google.com
 [209.85.128.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E79FC40A86
 for <kvmarm@lists.cs.columbia.edu>; Tue,  4 Apr 2017 06:11:03 -0400 (EDT)
Received: by mail-wr0-f172.google.com with SMTP id w11so206007077wrc.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 04 Apr 2017 03:13:15 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1491228763-23450-1-git-send-email-suzuki.poulose@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, ard.biesheuvel@linaro.org, marc.zyngier@arm.com, andreyknvl@google.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, kcc@google.com, syzkaller@googlegroups.com, dvyukov@google.com, catalin.marinas@arm.com, pbonzini@redhat.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Suzuki,

On Mon, Apr 03, 2017 at 03:12:43PM +0100, Suzuki K Poulose wrote:
> In kvm_free_stage2_pgd() we don't hold the kvm->mmu_lock while calling
> unmap_stage2_range() on the entire memory range for the guest. This could
> cause problems with other callers (e.g, munmap on a memslot) trying to
> unmap a range. And since we have to unmap the entire Guest memory range
> holding a spinlock, make sure we yield the lock if necessary, after we
> unmap each PUD range.
> 
> Fixes: commit d5d8184d35c9 ("KVM: ARM: Memory virtualization setup")
> Cc: stable@vger.kernel.org # v3.10+
> Cc: Paolo Bonzini <pbonzin@redhat.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <christoffer.dall@linaro.org>
> Cc: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> [ Avoid vCPU starvation and lockup detector warnings ]
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 

This unfortunately fails to build on 32-bit ARM, and I also think we
intended to check against S2_PGDIR_SIZE, not S2_PUD_SIZE.

How about adding this to your patch (which includes a rename of
S2_PGD_SIZE which is horribly confusing as it indicates the size of the
first level stage-2 table itself, where S2_PGDIR_SIZE indicates the size
of address space mapped by a single entry in the same table):

diff --git a/arch/arm/include/asm/stage2_pgtable.h b/arch/arm/include/asm/stage2_pgtable.h
index 460d616..c997f2d 100644
--- a/arch/arm/include/asm/stage2_pgtable.h
+++ b/arch/arm/include/asm/stage2_pgtable.h
@@ -35,10 +35,13 @@
 
 #define stage2_pud_huge(pud)			pud_huge(pud)
 
+#define S2_PGDIR_SIZE				PGDIR_SIZE
+#define S2_PGDIR_MASK				PGDIR_MASK
+
 /* Open coded p*d_addr_end that can deal with 64bit addresses */
 static inline phys_addr_t stage2_pgd_addr_end(phys_addr_t addr, phys_addr_t end)
 {
-	phys_addr_t boundary = (addr + PGDIR_SIZE) & PGDIR_MASK;
+	phys_addr_t boundary = (addr + S2_PGDIR_SIZE) & S2_PGDIR_MASK;
 
 	return (boundary - 1 < end - 1) ? boundary : end;
 }
diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index db94f3a..6e79a4c 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -41,7 +41,7 @@ static unsigned long hyp_idmap_start;
 static unsigned long hyp_idmap_end;
 static phys_addr_t hyp_idmap_vector;
 
-#define S2_PGD_SIZE	(PTRS_PER_S2_PGD * sizeof(pgd_t))
+#define S2_PGD_TABLE_SIZE	(PTRS_PER_S2_PGD * sizeof(pgd_t))
 #define hyp_pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
 
 #define KVM_S2PTE_FLAG_IS_IOMAP		(1UL << 0)
@@ -299,7 +299,7 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
 		 * If the range is too large, release the kvm->mmu_lock
 		 * to prevent starvation and lockup detector warnings.
 		 */
-		if (size > S2_PUD_SIZE)
+		if (size > S2_PGDIR_SIZE)
 			cond_resched_lock(&kvm->mmu_lock);
 		next = stage2_pgd_addr_end(addr, end);
 		if (!stage2_pgd_none(*pgd))
@@ -747,7 +747,7 @@ int kvm_alloc_stage2_pgd(struct kvm *kvm)
 	}
 
 	/* Allocate the HW PGD, making sure that each page gets its own refcount */
-	pgd = alloc_pages_exact(S2_PGD_SIZE, GFP_KERNEL | __GFP_ZERO);
+	pgd = alloc_pages_exact(S2_PGD_TABLE_SIZE, GFP_KERNEL | __GFP_ZERO);
 	if (!pgd)
 		return -ENOMEM;
 
@@ -843,7 +843,7 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
 	spin_unlock(&kvm->mmu_lock);
 
 	/* Free the HW pgd, one page at a time */
-	free_pages_exact(kvm->arch.pgd, S2_PGD_SIZE);
+	free_pages_exact(kvm->arch.pgd, S2_PGD_TABLE_SIZE);
 	kvm->arch.pgd = NULL;
 }
 

Thanks,
-Christoffer

> ---
> Changes since V2:
>  - Restrict kvm->mmu_lock relaxation to bigger ranges in unmap_stage2_range(),
>    to avoid possible issues like [0]
> 
>  [0] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-March/498210.html
> 
> Changes since V1:
>  - Yield the kvm->mmu_lock if necessary in unmap_stage2_range to prevent
>    vCPU starvation and lockup detector warnings.
> ---
>  arch/arm/kvm/mmu.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index 13b9c1f..db94f3a 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -292,8 +292,15 @@ static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
>  	phys_addr_t addr = start, end = start + size;
>  	phys_addr_t next;
>  
> +	assert_spin_locked(&kvm->mmu_lock);
>  	pgd = kvm->arch.pgd + stage2_pgd_index(addr);
>  	do {
> +		/*
> +		 * If the range is too large, release the kvm->mmu_lock
> +		 * to prevent starvation and lockup detector warnings.
> +		 */
> +		if (size > S2_PUD_SIZE)
> +			cond_resched_lock(&kvm->mmu_lock);
>  		next = stage2_pgd_addr_end(addr, end);
>  		if (!stage2_pgd_none(*pgd))
>  			unmap_stage2_puds(kvm, pgd, addr, next);
> @@ -831,7 +838,10 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
>  	if (kvm->arch.pgd == NULL)
>  		return;
>  
> +	spin_lock(&kvm->mmu_lock);
>  	unmap_stage2_range(kvm, 0, KVM_PHYS_SIZE);
> +	spin_unlock(&kvm->mmu_lock);
> +
>  	/* Free the HW pgd, one page at a time */
>  	free_pages_exact(kvm->arch.pgd, S2_PGD_SIZE);
>  	kvm->arch.pgd = NULL;
> -- 
> 2.7.4
> 
