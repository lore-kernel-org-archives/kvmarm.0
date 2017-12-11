From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH] KVM: arm/arm64: Fix HYP unmapping going off limits
Date: Mon, 11 Dec 2017 10:05:20 +0100
Message-ID: <20171211090520.GC910@cbox>
References: <20171207114545.23845-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20171207114545.23845-1-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Dec 07, 2017 at 11:45:45AM +0000, Marc Zyngier wrote:
> When we unmap the HYP memory, we try to be clever and unmap one
> PGD at a time. If we start with a non-PGD aligned address and try
> to unmap a whole PGD, things go horribly wrong in unmap_hyp_range
> (addr and end can never match, and it all goes really badly as we
> keep incrementing pgd and parse random memory as page tables...).
> 
> The obvious fix is to let unmap_hyp_range do what it does best,
> which is to iterate over a range.

Would you mind terribly if I add the following to the commit message?

  The size of the linear mapping, which begins at PAGE_OFFSET, can be
  easily calculated by subtracting PAGE_OFFSET form high_memory, because
  high_memory is defined as the linear map address of the last byte of
  DRAM, plus one.
  
  The size of the vmalloc region is given trivially by VMALLOC_END -
  VMALLOC_START.



Otherwise:

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>

> 
> Cc: stable@vger.kernel.org
> Reported-by: Andre Przywara <andre.przywara@arm.com>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/mmu.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index b36945d49986..b4b69c2d1012 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -509,8 +509,6 @@ static void unmap_hyp_range(pgd_t *pgdp, phys_addr_t start, u64 size)
>   */
>  void free_hyp_pgds(void)
>  {
> -	unsigned long addr;
> -
>  	mutex_lock(&kvm_hyp_pgd_mutex);
>  
>  	if (boot_hyp_pgd) {
> @@ -521,10 +519,10 @@ void free_hyp_pgds(void)
>  
>  	if (hyp_pgd) {
>  		unmap_hyp_range(hyp_pgd, hyp_idmap_start, PAGE_SIZE);
> -		for (addr = PAGE_OFFSET; virt_addr_valid(addr); addr += PGDIR_SIZE)
> -			unmap_hyp_range(hyp_pgd, kern_hyp_va(addr), PGDIR_SIZE);
> -		for (addr = VMALLOC_START; is_vmalloc_addr((void*)addr); addr += PGDIR_SIZE)
> -			unmap_hyp_range(hyp_pgd, kern_hyp_va(addr), PGDIR_SIZE);
> +		unmap_hyp_range(hyp_pgd, kern_hyp_va(PAGE_OFFSET),
> +				(uintptr_t)high_memory - PAGE_OFFSET);
> +		unmap_hyp_range(hyp_pgd, kern_hyp_va(VMALLOC_START),
> +				VMALLOC_END - VMALLOC_START);
>  
>  		free_pages((unsigned long)hyp_pgd, hyp_pgd_order);
>  		hyp_pgd = NULL;
> -- 
> 2.14.2
> 
