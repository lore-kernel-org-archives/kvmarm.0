From: Punit Agrawal <punit.agrawal@arm.com>
Subject: Re: [PATCH v7.1 9/9] KVM: arm64: Add support for creating PUD hugepages at stage 2
Date: Mon, 01 Oct 2018 15:00:38 +0100
Message-ID: <87bm8dn4vt.fsf@e105922-lin.cambridge.arm.com>
References: <20180924174552.8387-10-punit.agrawal@arm.com>
        <20180925143731.27475-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180925143731.27475-1-punit.agrawal@arm.com> (Punit Agrawal's
        message of "Tue, 25 Sep 2018 15:37:31 +0100")
Sender: linux-kernel-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, Catalin Marinas <catalin.marinas@arm.com>, will.deacon@arm.com, linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Punit Agrawal <punit.agrawal@arm.com> writes:

> KVM only supports PMD hugepages at stage 2. Now that the various page
> handling routines are updated, extend the stage 2 fault handling to
> map in PUD hugepages.
>
> Addition of PUD hugepage support enables additional page sizes (e.g.,
> 1G with 4K granule) which can be useful on cores that support mapping
> larger block sizes in the TLB entries.
>
> Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
> Cc: Christoffer Dall <christoffer.dall@arm.com>
> Cc: Marc Zyngier <marc.zyngier@arm.com>
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>
> v7 -> v7.1
>
> * Added arm helper kvm_stage2_has_pud()
> * Added check for PUD level present at stage 2
> * Dropped redundant comment
> * Fixed up kvm_pud_mkhuge() to complain on arm
>
>  arch/arm/include/asm/kvm_mmu.h         |  20 +++++
>  arch/arm/include/asm/stage2_pgtable.h  |   5 ++
>  arch/arm64/include/asm/kvm_mmu.h       |  16 ++++
>  arch/arm64/include/asm/pgtable-hwdef.h |   2 +
>  arch/arm64/include/asm/pgtable.h       |   2 +
>  virt/kvm/arm/mmu.c                     | 106 +++++++++++++++++++++++--
>  6 files changed, 145 insertions(+), 6 deletions(-)
>

[...]

> diff --git a/arch/arm/include/asm/stage2_pgtable.h b/arch/arm/include/asm/stage2_pgtable.h
> index f6a7ea805232..ec1567d9eb4b 100644
> --- a/arch/arm/include/asm/stage2_pgtable.h
> +++ b/arch/arm/include/asm/stage2_pgtable.h
> @@ -68,4 +68,9 @@ stage2_pmd_addr_end(struct kvm *kvm, phys_addr_t addr, phys_addr_t end)
>  #define stage2_pmd_table_empty(kvm, pmdp)	kvm_page_empty(pmdp)
>  #define stage2_pud_table_empty(kvm, pudp)	false
>  
> +static inline bool kvm_stage2_has_pud(struct kvm *kvm)
> +{
> +	return KVM_VTCR_SL0 == VTCR_SL_L1;
> +}
> +

Turns out this isn't quite the right check. On arm32, the maximum number
of supported levels is 3 with LPAE - effectively the helper should
always return false.

I've updated the check locally to key off of CONFIG_PGTABLE_LEVELS. I'll
post these patches later today.

Thanks,
Punit
