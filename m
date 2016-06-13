From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 4/5] arm/arm64: KVM: Map the HYP text as read-only
Date: Mon, 13 Jun 2016 16:02:51 +0100
Message-ID: <20160613150251.GB29783@leverpostej>
References: <1465826449-14349-1-git-send-email-marc.zyngier@arm.com>
 <1465826449-14349-5-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465826449-14349-5-git-send-email-marc.zyngier@arm.com>
Sender: kvm-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Christoffer Dall <christoffer.dall@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jun 13, 2016 at 03:00:48PM +0100, Marc Zyngier wrote:
> There should be no reason for mapping the HYP text read/write.
> 
> As such, let's have a new set of flags (PAGE_HYP_EXEC) that allows
> execution, but makes the page as read-only, and update the two call
> sites that deal with mapping code.
> 
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/include/asm/pgtable.h        | 1 +
>  arch/arm/kvm/arm.c                    | 2 +-
>  arch/arm/kvm/mmu.c                    | 2 +-
>  arch/arm64/include/asm/pgtable-prot.h | 1 +
>  4 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/pgtable.h b/arch/arm/include/asm/pgtable.h
> index f332087..7487bf9 100644
> --- a/arch/arm/include/asm/pgtable.h
> +++ b/arch/arm/include/asm/pgtable.h
> @@ -98,6 +98,7 @@ extern pgprot_t		pgprot_s2_device;
>  #define PAGE_KERNEL		_MOD_PROT(pgprot_kernel, L_PTE_XN)
>  #define PAGE_KERNEL_EXEC	pgprot_kernel
>  #define PAGE_HYP		_MOD_PROT(pgprot_kernel, L_PTE_HYP)
> +#define PAGE_HYP_EXEC		_MOD_PROT(pgprot_kernel, L_PTE_HYP | L_PTE_RDONLY)
>  #define PAGE_HYP_RO		_MOD_PROT(pgprot_kernel, L_PTE_HYP | L_PTE_RDONLY | L_PTE_XN)
>  #define PAGE_HYP_DEVICE		_MOD_PROT(pgprot_hyp_device, L_PTE_HYP)
>  #define PAGE_S2			_MOD_PROT(pgprot_s2, L_PTE_S2_RDONLY)
> diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
> index 0b5099f..d7bf2dd 100644
> --- a/arch/arm/kvm/arm.c
> +++ b/arch/arm/kvm/arm.c
> @@ -1285,7 +1285,7 @@ static int init_hyp_mode(void)
>  	 * Map the Hyp-code called directly from the host
>  	 */
>  	err = create_hyp_mappings(kvm_ksym_ref(__hyp_text_start),
> -				  kvm_ksym_ref(__hyp_text_end), PAGE_HYP);
> +				  kvm_ksym_ref(__hyp_text_end), PAGE_HYP_EXEC);

As far as I can tell, __hyp_text_{start,end} aren't guaranteed to be
page-aligned. Are we certain that we'll never share a page with
something that we'll subsequently want to map non-executable?

Otherwise this looks good!

Thanks,
Mark.

>  	if (err) {
>  		kvm_err("Cannot map world-switch code\n");
>  		goto out_err;
> diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
> index 6023abd..8a0aa37 100644
> --- a/arch/arm/kvm/mmu.c
> +++ b/arch/arm/kvm/mmu.c
> @@ -1687,7 +1687,7 @@ static int kvm_map_idmap_text(pgd_t *pgd)
>  	err = 	__create_hyp_mappings(pgd,
>  				      hyp_idmap_start, hyp_idmap_end,
>  				      __phys_to_pfn(hyp_idmap_start),
> -				      PAGE_HYP);
> +				      PAGE_HYP_EXEC);
>  	if (err)
>  		kvm_err("Failed to idmap %lx-%lx\n",
>  			hyp_idmap_start, hyp_idmap_end);
> diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
> index 88db58c..3802048 100644
> --- a/arch/arm64/include/asm/pgtable-prot.h
> +++ b/arch/arm64/include/asm/pgtable-prot.h
> @@ -56,6 +56,7 @@
>  #define PAGE_KERNEL_EXEC_CONT	__pgprot(_PAGE_DEFAULT | PTE_UXN | PTE_DIRTY | PTE_WRITE | PTE_CONT)
>  
>  #define PAGE_HYP		__pgprot(_PAGE_DEFAULT | PTE_HYP)
> +#define PAGE_HYP_EXEC		__pgprot(_PAGE_DEFAULT | PTE_HYP | PTE_RDONLY)
>  #define PAGE_HYP_RO		__pgprot(_PAGE_DEFAULT | PTE_HYP | PTE_RDONLY | PTE_HYP_XN)
>  #define PAGE_HYP_DEVICE		__pgprot(PROT_DEVICE_nGnRE | PTE_HYP)
>  
> -- 
> 2.1.4
> 
