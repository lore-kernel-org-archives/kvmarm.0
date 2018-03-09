From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v5 10/23] KVM: arm/arm64: Move HYP IO VAs to the "idmap"
 range
Date: Fri, 09 Mar 2018 18:59:08 +0000
Message-ID: <5AA2D97C.70503@arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
 <20180301155538.26860-11-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E5A9040683
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Mar 2018 13:54:48 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BhocCZBeUW3Y for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Mar 2018 13:54:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C2F240357
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Mar 2018 13:54:27 -0500 (EST)
In-Reply-To: <20180301155538.26860-11-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 01/03/18 15:55, Marc Zyngier wrote:
> We so far mapped our HYP IO (which is essencially the GICv2 control

(Nit: essentially)


> registers) using the same method as for memory. It recently appeared
> that is a bit unsafe:
> 
> We compute the HYP VA using the kern_hyp_va helper, but that helper
> is only designed to deal with kernel VAs coming from the linear map,
> and not from the vmalloc region... This could in turn cause some bad
> aliasing between the two, amplified by the upcoming VA randomisation.
> 
> A solution is to come up with our very own basic VA allocator for
> MMIO. Since half of the HYP address space only contains a single
> page (the idmap), we have plenty to borrow from. Let's use the idmap
> as a base, and allocate downwards from it. GICv2 now lives on the
> other side of the great VA barrier.

> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 0e5cfffb4c21..3074544940dc 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -502,27 +505,31 @@ static void unmap_hyp_range(pgd_t *pgdp, phys_addr_t start, u64 size)
>   *
>   * Assumes hyp_pgd is a page table used strictly in Hyp-mode and
>   * therefore contains either mappings in the kernel memory area (above
> - * PAGE_OFFSET), or device mappings in the vmalloc range (from
> - * VMALLOC_START to VMALLOC_END).
> + * PAGE_OFFSET), or device mappings in the idmap range.
>   *
> - * boot_hyp_pgd should only map two pages for the init code.
> + * boot_hyp_pgd should only map the idmap range, and is only used in
> + * the extended idmap case.
>   */
>  void free_hyp_pgds(void)
>  {
> +	pgd_t *id_pgd;
> +
>  	mutex_lock(&kvm_hyp_pgd_mutex);
>  
> +	id_pgd = boot_hyp_pgd ? boot_hyp_pgd : hyp_pgd;

> +
> +	if (id_pgd)
> +		unmap_hyp_range(id_pgd, io_map_base,
> +				hyp_idmap_start + PAGE_SIZE - io_map_base);

Even if kvm_mmu_init() fails before it sets io_map_base, this will still unmap
the idmap. It just starts from 0, so it may take out the flipped PAGE_OFFSET
range too...

(using io_map_base without taking io_map_lock makes me nervous ... in practice,
its fine)


> +
>  	if (boot_hyp_pgd) {
> -		unmap_hyp_range(boot_hyp_pgd, hyp_idmap_start, PAGE_SIZE);
>  		free_pages((unsigned long)boot_hyp_pgd, hyp_pgd_order);
>  		boot_hyp_pgd = NULL;
>  	}
>  
>  	if (hyp_pgd) {
> -		unmap_hyp_range(hyp_pgd, hyp_idmap_start, PAGE_SIZE);
>  		unmap_hyp_range(hyp_pgd, kern_hyp_va(PAGE_OFFSET),
>  				(uintptr_t)high_memory - PAGE_OFFSET);
> -		unmap_hyp_range(hyp_pgd, kern_hyp_va(VMALLOC_START),
> -				VMALLOC_END - VMALLOC_START);
>  
>  		free_pages((unsigned long)hyp_pgd, hyp_pgd_order);
>  		hyp_pgd = NULL;
> @@ -719,7 +726,8 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
>  			   void __iomem **kaddr,
>  			   void __iomem **haddr)
>  {
> -	unsigned long start, end;
> +	pgd_t *pgd = hyp_pgd;
> +	unsigned long base;
>  	int ret;
>  
>  	*kaddr = ioremap(phys_addr, size);
> @@ -731,11 +739,42 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
>  		return 0;
>  	}
>  
> +	mutex_lock(&io_map_lock);
> +
> +	/*
> +	 * This assumes that we we have enough space below the idmap
> +	 * page to allocate our VAs. If not, the check below will
> +	 * kick. A potential alternative would be to detect that
> +	 * overflow and switch to an allocation above the idmap.
> +	 */
> +	size = max(PAGE_SIZE, roundup_pow_of_two(size));
> +	base = io_map_base - size;
> +	base &= ~(size - 1);
>  
> -	start = kern_hyp_va((unsigned long)*kaddr);
> -	end = kern_hyp_va((unsigned long)*kaddr + size);
> -	ret = __create_hyp_mappings(hyp_pgd, PTRS_PER_PGD, start, end,
> -				     __phys_to_pfn(phys_addr), PAGE_HYP_DEVICE);
> +	/*
> +	 * Verify that BIT(VA_BITS - 1) hasn't been flipped by
> +	 * allocating the new area, as it would indicate we've
> +	 * overflowed the idmap/IO address range.
> +	 */
> +	if ((base ^ io_map_base) & BIT(VA_BITS - 1)) {
> +		ret = -ENOMEM;
> +		goto out;
> +	}
> +
> +	if (__kvm_cpu_uses_extended_idmap())
> +		pgd = boot_hyp_pgd;
> +
> +	ret = __create_hyp_mappings(pgd, __kvm_idmap_ptrs_per_pgd(),
> +				    base, base + size,
> +				    __phys_to_pfn(phys_addr), PAGE_HYP_DEVICE);

(/me winces, that's subtle....)
This __kvm_idmap_ptrs_per_pgd() change is because the hyp_pgd
extended-idmap top-level page may be a pgd bigger than the 64-entries that linux
believes it has for 64K/48bit VA?

Doesn't unmap_hyp_range() need to know about this too? Otherwise its
pgd_index(hyp_idmap_start) is going to mask out too much of the address, and
pgd_addr_end() will never reach the end address we provided...

...

Trying to boot a 64K config, and forcing it into teardown_hyp_mode() leads to
some fireworks: It looks like an unaligned end address is getting into
unmap_hyp_ptes() and its escaping the loop to kvm_set_pte() other kernel data...

My local changes are below [0], the config is defconfig + 64K pages, this is on
Juno. 4K pages is quite happy with this 'force teardown_hyp_mode()' debug hack.

Bisects to patch 4: "arm64: KVM: Dynamically patch the kernel/hyp VA mask"

I'll keep digging on Monday,


Thanks,

James


[0] Local changes to this series on v4.16-rc4
diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 433d13d0c271..5a132180119d 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -418,7 +418,7 @@ static inline void *kvm_get_hyp_vector(void)
 /*  This is only called on a !VHE system */
 static inline int kvm_map_vectors(void)
 {
-       phys_addr_t vect_pa = virt_to_phys(__bp_harden_hyp_vecs_start);
+       phys_addr_t vect_pa = __pa_symbol(__bp_harden_hyp_vecs_start);
        unsigned long size = __bp_harden_hyp_vecs_end - __bp_harden_hyp_vecs_start;

        if (cpus_have_const_cap(ARM64_HARDEN_BRANCH_PREDICTOR)) {
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 86941f6181bb..8f4ec0cc269f 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1494,7 +1494,7 @@ static int init_hyp_mode(void)
                }
        }

-       return 0;
+       err = -EINVAL;

 out_err:
        teardown_hyp_mode();
