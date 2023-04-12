Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 847AD6FD2
	for <kvmarm@lists.linux.dev>; Wed, 12 Apr 2023 17:06:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEA4EC433D2;
	Wed, 12 Apr 2023 17:06:12 +0000 (UTC)
Date: Wed, 12 Apr 2023 18:06:09 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Ryan Roberts <ryan.roberts@arm.com>
Cc: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
Subject: Re: [PATCH v2 06/12] KVM: arm64: Use LPA2 page-tables for hyp stage1
 if HW supports it
Message-ID: <ZDblAddFaCSwl/bf@arm.com>
References: <20230306195438.1557851-1-ryan.roberts@arm.com>
 <20230306195438.1557851-7-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230306195438.1557851-7-ryan.roberts@arm.com>

On Mon, Mar 06, 2023 at 07:54:32PM +0000, Ryan Roberts wrote:
> Implement a simple policy whereby if the HW supports FEAT_LPA2 for the
> page size we are using, always use LPA2-style page-tables for hyp stage
> 1, regardless of the IPA or PA size requirements. When in use we can now
> support up to 52-bit IPA and PA sizes.
> 
> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> ---
>  arch/arm64/kvm/arm.c         | 2 ++
>  arch/arm64/kvm/hyp/pgtable.c | 3 ++-
>  2 files changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> index 3bd732eaf087..bef73c484162 100644
> --- a/arch/arm64/kvm/arm.c
> +++ b/arch/arm64/kvm/arm.c
> @@ -1548,6 +1548,8 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
>  	tcr = (read_sysreg(tcr_el1) & TCR_EL2_MASK) | TCR_EL2_RES1;
>  	tcr &= ~TCR_T0SZ_MASK;
>  	tcr |= TCR_T0SZ(hyp_va_bits);
> +	if (system_supports_lpa2())
> +		tcr |= TCR_EL2_DS;
>  	params->tcr_el2 = tcr;
>  
>  	params->pgd_pa = kvm_mmu_get_httbr();
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 414a5dbf233d..bb481d6c7f2d 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -379,7 +379,8 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
>  	}
>  
>  	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_AP, ap);
> -	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
> +	if (!system_supports_lpa2())
> +		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
>  	attr |= KVM_PTE_LEAF_ATTR_LO_S1_AF;
>  	attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
>  	*ptep = attr;

Isn't LPA2 at stage 1 more involved than just not setting the SH field?
Does kvm_phys_to_pte() need changing as well?

If that's not strictly needed for stage 2, I'd rather keep the two
stages separate and add the stage 1 hyp together with Ard's series for
LPA2 at stage 1.

-- 
Catalin
