From: Anshuman Khandual <anshuman.khandual@arm.com>
Subject: Re: [PATCH v9 2/8] KVM: arm/arm64: Re-factor setting the Stage 2
 entry to exec on fault
Date: Mon, 3 Dec 2018 19:02:23 +0530
Message-ID: <12212830-ffc6-a0e0-5de6-3e6a15ed7141@arm.com>
References: <20181031175745.18650-1-punit.agrawal@arm.com>
 <20181031175745.18650-3-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181031175745.18650-3-punit.agrawal@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Punit Agrawal <punit.agrawal@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: suzuki.poulose@arm.com, marc.zyngier@arm.com, will.deacon@arm.com, linux-kernel@vger.kernel.org, Christoffer Dall <christoffer.dall@arm.com>, punitagrawal@gmail.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 10/31/2018 11:27 PM, Punit Agrawal wrote:
> Stage 2 fault handler marks a page as executable if it is handling an
> execution fault or if it was a permission fault in which case the
> executable bit needs to be preserved.
> 
> The logic to decide if the page should be marked executable is
> duplicated for PMD and PTE entries. To avoid creating another copy
> when support for PUD hugepages is introduced refactor the code to
> share the checks needed to mark a page table entry as executable.
> 
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  virt/kvm/arm/mmu.c | 28 +++++++++++++++-------------
>  1 file changed, 15 insertions(+), 13 deletions(-)
> 
> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index 59595207c5e1..6912529946fb 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c
> @@ -1475,7 +1475,8 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  			  unsigned long fault_status)
>  {
>  	int ret;
> -	bool write_fault, exec_fault, writable, force_pte = false;
> +	bool write_fault, writable, force_pte = false;
> +	bool exec_fault, needs_exec;

New line not required, still within 80 characters.

>  	unsigned long mmu_seq;
>  	gfn_t gfn = fault_ipa >> PAGE_SHIFT;
>  	struct kvm *kvm = vcpu->kvm;
> @@ -1598,19 +1599,25 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	if (exec_fault)
>  		invalidate_icache_guest_page(pfn, vma_pagesize);
>  
> +	/*
> +	 * If we took an execution fault we have made the
> +	 * icache/dcache coherent above and should now let the s2

Coherent or invalidated with invalidate_icache_guest_page ?

> +	 * mapping be executable.
> +	 *
> +	 * Write faults (!exec_fault && FSC_PERM) are orthogonal to
> +	 * execute permissions, and we preserve whatever we have.
> +	 */

Otherwise looks good.
