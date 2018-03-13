From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v5 08/23] KVM: arm/arm64: Move ioremap calls to
 create_hyp_io_mappings
Date: Tue, 13 Mar 2018 09:03:28 +0000
Message-ID: <06891249-199a-7f85-1d5b-cb1594f2a4ac@arm.com>
References: <20180301155538.26860-1-marc.zyngier@arm.com>
 <20180301155538.26860-9-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A7CA840672
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Mar 2018 04:56:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id klRxEpKiXqVO for <kvmarm@lists.cs.columbia.edu>;
 Tue, 13 Mar 2018 04:56:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B248401CD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Mar 2018 04:56:01 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 84CCD1596
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Mar 2018 02:03:30 -0700 (PDT)
Received: from [10.1.206.28] (e107814-lin.cambridge.arm.com [10.1.206.28])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 322EE3F487
 for <kvmarm@lists.cs.columbia.edu>; Tue, 13 Mar 2018 02:03:30 -0700 (PDT)
In-Reply-To: <20180301155538.26860-9-marc.zyngier@arm.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On 01/03/18 15:55, Marc Zyngier wrote:
> Both HYP io mappings call ioremap, followed by create_hyp_io_mappings.
> Let's move the ioremap call into create_hyp_io_mappings itself, which
> simplifies the code a bit and allows for further refactoring.
> 
> Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>   arch/arm/include/asm/kvm_mmu.h   |  3 ++-
>   arch/arm64/include/asm/kvm_mmu.h |  3 ++-
>   virt/kvm/arm/mmu.c               | 24 ++++++++++++++----------
>   virt/kvm/arm/vgic/vgic-v2.c      | 31 ++++++++-----------------------
>   4 files changed, 26 insertions(+), 35 deletions(-)
> 
> diff --git a/arch/arm/include/asm/kvm_mmu.h b/arch/arm/include/asm/kvm_mmu.h
> index a6808d2869f5..477c5ed426ef 100644
> --- a/arch/arm/include/asm/kvm_mmu.h
> +++ b/arch/arm/include/asm/kvm_mmu.h
> @@ -50,7 +50,8 @@
>   #include <asm/stage2_pgtable.h>
>   
>   int create_hyp_mappings(void *from, void *to, pgprot_t prot);
> -int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
> +int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
> +			   void __iomem **kaddr);
>   void free_hyp_pgds(void);
>   
>   void stage2_unmap_vm(struct kvm *kvm);
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 7120bf3f22c7..5885564f9863 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -140,7 +140,8 @@ static inline unsigned long __kern_hyp_va(unsigned long v)
>   #include <asm/stage2_pgtable.h>
>   
>   int create_hyp_mappings(void *from, void *to, pgprot_t prot);
> -int create_hyp_io_mappings(void *from, void *to, phys_addr_t);
> +int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
> +			   void __iomem **kaddr);
>   void free_hyp_pgds(void);
>   
>   void stage2_unmap_vm(struct kvm *kvm);
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 711473cd1097..d58388d8550e 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -709,26 +709,30 @@ int create_hyp_mappings(void *from, void *to, pgprot_t prot)
>   }
>   
>   /**
> - * create_hyp_io_mappings - duplicate a kernel IO mapping into Hyp mode
> - * @from:	The kernel start VA of the range
> - * @to:		The kernel end VA of the range (exclusive)
> + * create_hyp_io_mappings - Map IO into both kernel and HYP
>    * @phys_addr:	The physical start address which gets mapped
> + * @size:	Size of the region being mapped
> + * @kaddr:	Kernel VA for this mapping
>    *
>    * The resulting HYP VA is the same as the kernel VA, modulo
>    * HYP_PAGE_OFFSET.
>    */
> -int create_hyp_io_mappings(void *from, void *to, phys_addr_t phys_addr)
> +int create_hyp_io_mappings(phys_addr_t phys_addr, size_t size,
> +			   void __iomem **kaddr)
>   {
> -	unsigned long start = kern_hyp_va((unsigned long)from);
> -	unsigned long end = kern_hyp_va((unsigned long)to);
> +	unsigned long start, end;
>   
> -	if (is_kernel_in_hyp_mode())
> +	*kaddr = ioremap(phys_addr, size);
> +	if (!*kaddr)
> +		return -ENOMEM;
> +
> +	if (is_kernel_in_hyp_mode()) {
>   		return 0;
> +	}
>   
> -	/* Check for a valid kernel IO mapping */
> -	if (!is_vmalloc_addr(from) || !is_vmalloc_addr(to - 1))
> -		return -EINVAL;
>   
> +	start = kern_hyp_va((unsigned long)*kaddr);
> +	end = kern_hyp_va((unsigned long)*kaddr + size);
>   	return __create_hyp_mappings(hyp_pgd, PTRS_PER_PGD, start, end,
>   				     __phys_to_pfn(phys_addr), PAGE_HYP_DEVICE);

nit: So, we now ioremap() in create_hyp_io_mappings() and expect the caller to
iounmap() in case we ended up failing to create the hyp mappings. Do we need a
comment here ?

Cheers
Suzuki
