From: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Subject: Re: [PATCH v3 09/20] kvm: arm64: Make stage2 page table layout
 dynamic
Date: Mon, 2 Jul 2018 11:57:34 +0100
Message-ID: <8a6b81ef-ff78-41b5-b004-c60ba7e5a9a7@arm.com>
References: <1530270944-11351-1-git-send-email-suzuki.poulose@arm.com>
 <1530270944-11351-10-git-send-email-suzuki.poulose@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1530270944-11351-10-git-send-email-suzuki.poulose@arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, james.morse@arm.com, marc.zyngier@arm.com, cdall@kernel.org, eric.auger@redhat.com, julien.grall@arm.com, will.deacon@arm.com, catalin.marinas@arm.com, punit.agrawal@arm.com, qemu-devel@nongnu.org
List-Id: kvmarm@lists.cs.columbia.edu

On 29/06/18 12:15, Suzuki K Poulose wrote:
> So far we had a static stage2 page table handling code, based on a
> fixed IPA of 40bits. As we prepare for a configurable IPA size per
> VM, make our stage2 page table code dynamic, to do the right thing
> for a given VM. We ensure the existing condition is always true even
> when we lift the limit on the IPA. i.e,
> 
> 	page table levels in stage1 >= page table levels in stage2
> 
> Support for the IPA size configuration needs other changes in the way
> we configure the EL2 registers (VTTBR and VTCR). So, the IPA is still
> fixed to 40bits. The patch also moves the kvm_page_empty() in asm/kvm_mmu.h
> to the top, before including the asm/stage2_pgtable.h to avoid a forward
> declaration.
> 
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Christoffer Dall <cdall@kernel.org>
> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> ---
> Changes since V2
>   - Restrict the stage2 page table to allow reusing the host page table
>     helpers for now, until we get stage1 independent page table helpers.

...

> -#define stage2_pgd_none(kvm, pgd)		pgd_none(pgd)
> -#define stage2_pgd_clear(kvm, pgd)		pgd_clear(pgd)
> -#define stage2_pgd_present(kvm, pgd)		pgd_present(pgd)
> -#define stage2_pgd_populate(kvm, pgd, pud)	pgd_populate(NULL, pgd, pud)
> -#define stage2_pud_offset(kvm, pgd, address)	pud_offset(pgd, address)
> -#define stage2_pud_free(kvm, pud)		pud_free(NULL, pud)
> +#define __s2_pud_index(addr) \
> +	(((addr) >> __S2_PUD_SHIFT) & (PTRS_PER_PTE - 1))
> +#define __s2_pmd_index(addr) \
> +	(((addr) >> __S2_PMD_SHIFT) & (PTRS_PER_PTE - 1))
>   
> -#define stage2_pud_table_empty(kvm, pudp)	kvm_page_empty(pudp)
> +#define __kvm_has_stage2_levels(kvm, min_levels)	\
> +  ((CONFIG_PGTABLE_LEVELS >= min_levels) && (kvm_stage2_levels(kvm) >= min_levels))

On another look, I have renamed the helpers as follows :

kvm_stage2_has_pud(kvm) => kvm_stage2_has_pmd(kvm)
kvm_stage2_has_pgd(kvm) => kvm_stage2_has_pud(kvm)

below and everywhere.

> +
> +#define kvm_stage2_has_pgd(kvm)	__kvm_has_stage2_levels(kvm, 4)
> +#define kvm_stage2_has_pud(kvm) __kvm_has_stage2_levels(kvm, 3)


Suzuki
