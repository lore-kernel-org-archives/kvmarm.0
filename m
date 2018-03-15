From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH v6 12/26] KVM: arm/arm64: Move HYP IO VAs to the "idmap"
 range
Date: Thu, 15 Mar 2018 19:09:44 +0000
Message-ID: <5AAAC4F8.9050608@arm.com>
References: <20180314165049.30105-1-marc.zyngier@arm.com>
 <20180314165049.30105-13-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180314165049.30105-13-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, Andrew Jones <drjones@redhat.com>, Christoffer Dall <cdall@kernel.org>, kvm@vger.kernel.org, Steve Capper <steve.capper@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 14/03/18 16:50, Marc Zyngier wrote:
> We so far mapped our HYP IO (which is essentially the GICv2 control
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
> index 9946f8a38b26..a9577ecc3e6a 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -43,6 +43,9 @@ static unsigned long hyp_idmap_start;
>  static unsigned long hyp_idmap_end;
>  static phys_addr_t hyp_idmap_vector;
>  
> +static DEFINE_MUTEX(io_map_lock);
> +static unsigned long io_map_base;
> +
>  #define S2_PGD_SIZE	(PTRS_PER_S2_PGD * sizeof(pgd_t))
>  #define hyp_pgd_order get_order(PTRS_PER_PGD * sizeof(pgd_t))
>  
> @@ -518,27 +521,37 @@ static void unmap_hyp_idmap_range(pgd_t *pgdp, phys_addr_t start, u64 size)
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
> +	if (id_pgd) {
> +		mutex_lock(&io_map_lock);

This takes kvm_hyp_pgd_mutex then io_map_lock ...


> +		/* In case we never called hyp_mmu_init() */
> +		if (!io_map_base)
> +			io_map_base = hyp_idmap_start;
> +		unmap_hyp_idmap_range(id_pgd, io_map_base,
> +				      hyp_idmap_start + PAGE_SIZE - io_map_base);
> +		mutex_unlock(&io_map_lock);
> +	}
> +
>  	if (boot_hyp_pgd) {
> -		unmap_hyp_idmap_range(boot_hyp_pgd, hyp_idmap_start, PAGE_SIZE);
>  		free_pages((unsigned long)boot_hyp_pgd, hyp_pgd_order);
>  		boot_hyp_pgd = NULL;
>  	}
>  
>  	if (hyp_pgd) {
> -		unmap_hyp_idmap_range(hyp_pgd, hyp_idmap_start, PAGE_SIZE);
>  		unmap_hyp_range(hyp_pgd, kern_hyp_va(PAGE_OFFSET),
>  				(uintptr_t)high_memory - PAGE_OFFSET);
> -		unmap_hyp_range(hyp_pgd, kern_hyp_va(VMALLOC_START),
> -				VMALLOC_END - VMALLOC_START);
>  
>  		free_pages((unsigned long)hyp_pgd, hyp_pgd_order);
>  		hyp_pgd = NULL;

> @@ -747,11 +761,43 @@ int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
>  		return 0;
>  	}

> +	mutex_lock(&io_map_lock);

> -	start = kern_hyp_va((unsigned long)*kaddr);
> -	end = kern_hyp_va((unsigned long)*kaddr + size);
> -	ret = __create_hyp_mappings(hyp_pgd, PTRS_PER_PGD, start, end,
> -				     __phys_to_pfn(phys_addr), PAGE_HYP_DEVICE);
> +	/*
> +	 * This assumes that we we have enough space below the idmap
> +	 * page to allocate our VAs. If not, the check below will
> +	 * kick. A potential alternative would be to detect that
> +	 * overflow and switch to an allocation above the idmap.
> +	 *
> +	 * The allocated size is always a multiple of PAGE_SIZE.
> +	 */
> +	size = PAGE_ALIGN(size + offset_in_page(phys_addr));
> +	base = io_map_base - size;
> +
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

And here we have io_map_lock, but __create_hyp_mappings takes kvm_hyp_pgd_mutex.

There is another example of this in create_hyp_exec_mappings, I think making
this the required order makes sense: if you are mapping to the KVM-IO region,
you take the io_map_lock before taking the pgd lock to write in your allocated
location. (free_hyp_pgds() is always going to need to take both).

Never going to happen, but it generates a lockdep splat[1].
Fixup diff[0] below fixes it for me.


> +	if (ret)
> +		goto out;
> +
> +	*haddr = (void __iomem *)base + offset_in_page(phys_addr);
> +	io_map_base = base;
> +
> +out:
> +	mutex_unlock(&io_map_lock);
>  
>  	if (ret) {
>  		iounmap(*kaddr);



Thanks,

James


[0]
--------------------------%<--------------------------
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index 554ad5493e7d..f7642c96fc56 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -43,6 +43,7 @@ static unsigned long hyp_idmap_start;
 static unsigned long hyp_idmap_end;
 static phys_addr_t hyp_idmap_vector;

+/* Take io_map_lock before kvm_hyp_pgd_mutex */
 static DEFINE_MUTEX(io_map_lock);
 static unsigned long io_map_base;

@@ -530,18 +531,17 @@ void free_hyp_pgds(void)
 {
        pgd_t *id_pgd;

+       mutex_lock(&io_map_lock);
        mutex_lock(&kvm_hyp_pgd_mutex);

        id_pgd = boot_hyp_pgd ? boot_hyp_pgd : hyp_pgd;

        if (id_pgd) {
-               mutex_lock(&io_map_lock);
                /* In case we never called hyp_mmu_init() */
                if (!io_map_base)
                        io_map_base = hyp_idmap_start;
                unmap_hyp_idmap_range(id_pgd, io_map_base,
                                      hyp_idmap_start + PAGE_SIZE - io_map_base);
-               mutex_unlock(&io_map_lock);
        }

        if (boot_hyp_pgd) {
@@ -563,6 +563,7 @@ void free_hyp_pgds(void)
        }

        mutex_unlock(&kvm_hyp_pgd_mutex);
+       mutex_unlock(&io_map_lock);
 }

 static void create_hyp_pte_mappings(pmd_t *pmd, unsigned long start,
--------------------------%<--------------------------
[1]
[    2.795711] kvm [1]: 8-bit VMID
[    2.800456]
[    2.801944] ======================================================
[    2.808086] WARNING: possible circular locking dependency detected
[    2.814230] 4.16.0-rc5-00027-gca4a12e92d2d-dirty #9471 Not tainted
[    2.820371] ------------------------------------------------------
[    2.826513] swapper/0/1 is trying to acquire lock:
[    2.831274]  (io_map_lock){+.+.}, at: [<00000000cf644f15>] free_hyp_pgds+0x44
/0x148
[    2.838914]
[    2.838914] but task is already holding lock:
[    2.844713]  (kvm_hyp_pgd_mutex){+.+.}, at: [<00000000e786face>] free_hyp_pgd
s+0x20/0x148
[    2.852863]
[    2.852863] which lock already depends on the new lock.
[    2.852863]
[    2.860995]
[    2.860995] the existing dependency chain (in reverse order) is:
[    2.868433]
[    2.868433] -> #1 (kvm_hyp_pgd_mutex){+.+.}:
[    2.874174]        __mutex_lock+0x70/0x8d0
[    2.878249]        mutex_lock_nested+0x1c/0x28
[    2.882671]        __create_hyp_mappings+0x48/0x3e0
[    2.887523]        __create_hyp_private_mapping+0xa4/0xf8
[    2.892893]        create_hyp_exec_mappings+0x28/0x58
[    2.897918]        kvm_arch_init+0x524/0x6e8
[    2.902167]        kvm_init+0x20/0x2d8
[    2.905897]        arm_init+0x1c/0x28
[    2.909542]        do_one_initcall+0x38/0x128
[    2.913884]        kernel_init_freeable+0x1e0/0x284
[    2.918737]        kernel_init+0x10/0x100
[    2.922726]        ret_from_fork+0x10/0x18
[    2.926797]
[    2.926797] -> #0 (io_map_lock){+.+.}:
[    2.932020]        lock_acquire+0x6c/0xb0
[    2.936008]        __mutex_lock+0x70/0x8d0
[    2.940082]        mutex_lock_nested+0x1c/0x28
[    2.944502]        free_hyp_pgds+0x44/0x148
[    2.948663]        teardown_hyp_mode+0x34/0x90
[    2.953084]        kvm_arch_init+0x3b8/0x6e8
[    2.957332]        kvm_init+0x20/0x2d8
[    2.961061]        arm_init+0x1c/0x28
[    2.964704]        do_one_initcall+0x38/0x128
[    2.969039]        kernel_init_freeable+0x1e0/0x284
[    2.973891]        kernel_init+0x10/0x100
[    2.977880]        ret_from_fork+0x10/0x18
[    2.981950]
[    2.981950] other info that might help us debug this:
[    2.981950]
[    2.989910]  Possible unsafe locking scenario:
[    2.989910]
[    2.995796]        CPU0                    CPU1
[    3.000297]        ----                    ----
[    3.004798]   lock(kvm_hyp_pgd_mutex);
[    3.008533]                                lock(io_map_lock);
[    3.014252]                                lock(kvm_hyp_pgd_mutex);
[    3.020488]   lock(io_map_lock);
[    3.023705]
[    3.023705]  *** DEADLOCK ***
[    3.023705]
[    3.029597] 1 lock held by swapper/0/1:
[    3.033409]  #0:  (kvm_hyp_pgd_mutex){+.+.}, at: [<00000000e786face>] free_hy
p_pgds+0x20/0x148
[    3.041993]
[    3.041993] stack backtrace:
[    3.046331] CPU: 4 PID: 1 Comm: swapper/0 Not tainted 4.16.0-rc5-00027-gca4a1
2e92d2d-dirty #9471
[    3.055062] Hardware name: ARM Juno development board (r1) (DT)
[    3.060945] Call trace:
[    3.063383]  dump_backtrace+0x0/0x190
[    3.067027]  show_stack+0x14/0x20
[    3.070326]  dump_stack+0xac/0xe8
[    3.073626]  print_circular_bug.isra.19+0x1d4/0x2e0
[    3.078476]  __lock_acquire+0x19f4/0x1a50
[    3.082464]  lock_acquire+0x6c/0xb0
[    3.085934]  __mutex_lock+0x70/0x8d0
[    3.089491]  mutex_lock_nested+0x1c/0x28
[    3.093394]  free_hyp_pgds+0x44/0x148
[    3.097037]  teardown_hyp_mode+0x34/0x90
[    3.100940]  kvm_arch_init+0x3b8/0x6e8
[    3.104670]  kvm_init+0x20/0x2d8
[    3.107882]  arm_init+0x1c/0x28
[    3.111007]  do_one_initcall+0x38/0x128
[    3.114823]  kernel_init_freeable+0x1e0/0x284
[    3.119158]  kernel_init+0x10/0x100
[    3.122628]  ret_from_fork+0x10/0x18
