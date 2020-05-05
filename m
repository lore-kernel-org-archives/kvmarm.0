Return-Path: <SRS0=MGAT=6T=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C32C47247
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 16:03:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C5D54206A4
	for <kvmarm@archiver.kernel.org>; Tue,  5 May 2020 16:03:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C5D54206A4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31F1C4B2DF;
	Tue,  5 May 2020 12:03:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XXMbOn8P6WOm; Tue,  5 May 2020 12:03:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C10CF4B2CC;
	Tue,  5 May 2020 12:03:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9BAD84B27F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 12:03:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z+IGmvjA9SwL for <kvmarm@lists.cs.columbia.edu>;
 Tue,  5 May 2020 12:03:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF85B4B263
 for <kvmarm@lists.cs.columbia.edu>; Tue,  5 May 2020 12:03:25 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 720841FB;
 Tue,  5 May 2020 09:03:25 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8076D3F71F;
 Tue,  5 May 2020 09:03:23 -0700 (PDT)
From: James Morse <james.morse@arm.com>
Subject: Re: [PATCH 03/26] KVM: arm64: Factor out stage 2 page table data from
 struct kvm
To: Marc Zyngier <maz@kernel.org>
References: <20200422120050.3693593-1-maz@kernel.org>
 <20200422120050.3693593-4-maz@kernel.org>
Message-ID: <660a6638-5ee0-54c5-4a9d-d0d9235553ad@arm.com>
Date: Tue, 5 May 2020 17:03:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20200422120050.3693593-4-maz@kernel.org>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, Will Deacon <will@kernel.org>,
 George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>,
 linux-arm-kernel@lists.infradead.org
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

Hi Marc,

On 22/04/2020 13:00, Marc Zyngier wrote:
> From: Christoffer Dall <christoffer.dall@arm.com>
> 
> As we are about to reuse our stage 2 page table manipulation code for
> shadow stage 2 page tables in the context of nested virtualization, we
> are going to manage multiple stage 2 page tables for a single VM.
> 
> This requires some pretty invasive changes to our data structures,
> which moves the vmid and pgd pointers into a separate structure and
> change pretty much all of our mmu code to operate on this structure
> instead.
> 
> The new structure is called struct kvm_s2_mmu.
> 
> There is no intended functional change by this patch alone.

It's not obvious to me that VTCR_EL2.T0SZ is a per-vm thing, today the size of the IPA
space comes from the VMM, its not a hardware/compile-time property. Where does the vEL2's
T0SZ go? ... but using this for nested guests would 'only' cause a translation fault, it
would still need handling in the emulation code. So making it per-vm should be simpler.

But accessing VTCR is why the stage2_dissolve_p?d() stuff still needs the kvm pointer,
hence the backreference... it might be neater to push the vtcr properties into kvm_s2_mmu
that way you could drop the kvm backref, and only things that take vm-wide locks would
need the kvm pointer. But I don't think it matters.


I think I get it. I can't see anything that should be the other vm/vcpu pointer.

Reviewed-by: James Morse <james.morse@arm.com>


Some boring fiddly stuff:

[...]

> @@ -125,24 +123,24 @@ static void __hyp_text __tlb_switch_to_host_nvhe(struct kvm *kvm,
>  	}
>  }
>  
> -static void __hyp_text __tlb_switch_to_host(struct kvm *kvm,
> +static void __hyp_text __tlb_switch_to_host(struct kvm_s2_mmu *mmu,
>  					    struct tlb_inv_context *cxt)
>  {
>  	if (has_vhe())
> -		__tlb_switch_to_host_vhe(kvm, cxt);
> +		__tlb_switch_to_host_vhe(cxt);
>  	else
> -		__tlb_switch_to_host_nvhe(kvm, cxt);
> +		__tlb_switch_to_host_nvhe(cxt);
>  }

What does __tlb_switch_to_host() need the kvm_s2_mmu for?

[...]


>  void __hyp_text __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu)
>  {
> -	struct kvm *kvm = kern_hyp_va(kern_hyp_va(vcpu)->kvm);
> +	struct kvm_s2_mmu *mmu = kern_hyp_va(kern_hyp_va(vcpu)->arch.hw_mmu);
>  	struct tlb_inv_context cxt;
>
>  	/* Switch to requested VMID */
> -	__tlb_switch_to_guest(kvm, &cxt);
> +	__tlb_switch_to_guest(mmu, &cxt);
>
>  	__tlbi(vmalle1);
>  	dsb(nsh);
>  	isb();
>
> -	__tlb_switch_to_host(kvm, &cxt);
> +	__tlb_switch_to_host(mmu, &cxt);
>  }

Does this need the vcpu in the future?
Its the odd one out, the other tlb functions here take the s2_mmu, or nothing.
We only use the s2_mmu here.

[...]


> diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
> index e3b9ee268823b..2f99749048285 100644
> --- a/virt/kvm/arm/mmu.c
> +++ b/virt/kvm/arm/mmu.c

> @@ -96,31 +96,33 @@ static bool kvm_is_device_pfn(unsigned long pfn)
>   *
>   * Function clears a PMD entry, flushes addr 1st and 2nd stage TLBs.
>   */
> -static void stage2_dissolve_pmd(struct kvm *kvm, phys_addr_t addr, pmd_t *pmd)
> +static void stage2_dissolve_pmd(struct kvm_s2_mmu *mmu, phys_addr_t addr, pmd_t *pmd)

The comment above this function still has '@kvm:	pointer to kvm structure.'

[...]


> @@ -331,8 +339,9 @@ static void unmap_stage2_puds(struct kvm *kvm, pgd_t *pgd,
>   * destroying the VM), otherwise another faulting VCPU may come in and mess
>   * with things behind our backs.
>   */
> -static void unmap_stage2_range(struct kvm *kvm, phys_addr_t start, u64 size)
> +static void unmap_stage2_range(struct kvm_s2_mmu *mmu, phys_addr_t start, u64 size)

The comment above this function still has '@kvm:   The VM pointer'

[...]

> -static void stage2_flush_memslot(struct kvm *kvm,
> +static void stage2_flush_memslot(struct kvm_s2_mmu *mmu,
>  				 struct kvm_memory_slot *memslot)
>  {

Wouldn't something manipulating a memslot have to mess with a set of kvm_s2_mmu once this
is all assembled?
stage2_unmap_memslot() takes struct kvm, it seems odd to pass one kvm_s2_mmu here.

[...]

> @@ -886,21 +898,23 @@ int create_hyp_exec_mappings(phys_addr_t phys_addr, size_t size,

> -int kvm_alloc_stage2_pgd(struct kvm *kvm)
> +int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu)
>  {
>  	phys_addr_t pgd_phys;
>  	pgd_t *pgd;
> +	int cpu;
>  
> -	if (kvm->arch.pgd != NULL) {
> +	if (mmu->pgd != NULL) {
>  		kvm_err("kvm_arch already initialized?\n");

Does this error message still make sense?


>  		return -EINVAL;
>  	}

[...]

> @@ -1439,9 +1467,10 @@ static void stage2_wp_ptes(pmd_t *pmd, phys_addr_t addr, phys_addr_t end)
>   * @addr:	range start address
>   * @end:	range end address
>   */
> -static void stage2_wp_pmds(struct kvm *kvm, pud_t *pud,
> +static void stage2_wp_pmds(struct kvm_s2_mmu *mmu, pud_t *pud,
>  			   phys_addr_t addr, phys_addr_t end)

The comment above this function still has 'kvm:		kvm instance for the VM'.


>  {
> +	struct kvm *kvm = mmu->kvm;
>  	pmd_t *pmd;
>  	phys_addr_t next;
>  
> @@ -1461,14 +1490,15 @@ static void stage2_wp_pmds(struct kvm *kvm, pud_t *pud,
>  }
>  
>  /**
> - * stage2_wp_puds - write protect PGD range
> - * @pgd:	pointer to pgd entry
> - * @addr:	range start address
> - * @end:	range end address
> - */
> -static void  stage2_wp_puds(struct kvm *kvm, pgd_t *pgd,
> +  * stage2_wp_puds - write protect PGD range
> +  * @pgd:	pointer to pgd entry
> +  * @addr:	range start address
> +  * @end:	range end address
> +  */
> +static void  stage2_wp_puds(struct kvm_s2_mmu *mmu, pgd_t *pgd,
>  			    phys_addr_t addr, phys_addr_t end)

Comment was missing @kvm, now its missing @mmu....


>  {
> +	struct kvm *kvm __maybe_unused = mmu->kvm;
>  	pud_t *pud;
>  	phys_addr_t next;
>  

> @@ -1492,12 +1522,13 @@ static void  stage2_wp_puds(struct kvm *kvm, pgd_t *pgd,
>   * @addr:	Start address of range
>   * @end:	End address of range
>   */
> -static void stage2_wp_range(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
> +static void stage2_wp_range(struct kvm_s2_mmu *mmu, phys_addr_t addr, phys_addr_t end)

The comment above this function still ... you get the picture.

[...]


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
