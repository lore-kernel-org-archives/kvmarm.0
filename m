Return-Path: <SRS0=B0kT=CR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D1C0C433E2
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 15:38:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 7C6A224198
	for <kvmarm@archiver.kernel.org>; Tue,  8 Sep 2020 15:38:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C6A224198
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C9DD04B445;
	Tue,  8 Sep 2020 11:38:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WFqR2hSpGo4o; Tue,  8 Sep 2020 11:38:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9E41A4B44A;
	Tue,  8 Sep 2020 11:38:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1CBFB4B443
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 11:38:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v32VIY87wZpo for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Sep 2020 11:38:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDC1E4B2F7
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Sep 2020 11:38:45 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F5001045;
 Tue,  8 Sep 2020 08:38:44 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B74A33F73C;
 Tue,  8 Sep 2020 08:38:42 -0700 (PDT)
Subject: Re: [PATCH v4 11/21] KVM: arm64: Convert page-aging and access faults
 to generic page-table API
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200907152344.12978-1-will@kernel.org>
 <20200907152344.12978-12-will@kernel.org>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <f1046b83-9696-dead-c908-86e71d2b2791@arm.com>
Date: Tue, 8 Sep 2020 16:39:31 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200907152344.12978-12-will@kernel.org>
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
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

Hi Will,

On 9/7/20 4:23 PM, Will Deacon wrote:
> Convert the page-aging functions and access fault handler to use the
> generic page-table code instead of walking the page-table directly.
>
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>  arch/arm64/kvm/mmu.c | 74 ++++++++++----------------------------------
>  1 file changed, 16 insertions(+), 58 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index a7021509231c..a036aac3ed24 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1703,46 +1703,23 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	return ret;
>  }
>  
> -/*
> - * Resolve the access fault by making the page young again.
> - * Note that because the faulting entry is guaranteed not to be
> - * cached in the TLB, we don't need to invalidate anything.
> - * Only the HW Access Flag updates are supported for Stage 2 (no DBM),
> - * so there is no need for atomic (pte|pmd)_mkyoung operations.
> - */
> +/* Resolve the access fault by making the page young again. */
>  static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>  {
> -	pud_t *pud;
> -	pmd_t *pmd;
> -	pte_t *pte;
> -	kvm_pfn_t pfn;
> -	bool pfn_valid = false;
> +	pte_t pte;
> +	kvm_pte_t kpte;
> +	struct kvm_s2_mmu *mmu;
>  
>  	trace_kvm_access_fault(fault_ipa);
>  
>  	spin_lock(&vcpu->kvm->mmu_lock);
> -
> -	if (!stage2_get_leaf_entry(vcpu->arch.hw_mmu, fault_ipa, &pud, &pmd, &pte))
> -		goto out;
> -
> -	if (pud) {		/* HugeTLB */
> -		*pud = kvm_s2pud_mkyoung(*pud);
> -		pfn = kvm_pud_pfn(*pud);
> -		pfn_valid = true;
> -	} else	if (pmd) {	/* THP, HugeTLB */
> -		*pmd = pmd_mkyoung(*pmd);
> -		pfn = pmd_pfn(*pmd);
> -		pfn_valid = true;
> -	} else {
> -		*pte = pte_mkyoung(*pte);	/* Just a page... */
> -		pfn = pte_pfn(*pte);
> -		pfn_valid = true;
> -	}
> -
> -out:
> +	mmu = vcpu->arch.hw_mmu;
> +	kpte = kvm_pgtable_stage2_mkyoung(mmu->pgt, fault_ipa);
>  	spin_unlock(&vcpu->kvm->mmu_lock);
> -	if (pfn_valid)
> -		kvm_set_pfn_accessed(pfn);
> +
> +	pte = __pte(kpte);
> +	if (pte_valid(pte))
> +		kvm_set_pfn_accessed(pte_pfn(pte));
>  }
>  
>  /**
> @@ -1959,38 +1936,19 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
>  
>  static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
>  {
> -	pud_t *pud;
> -	pmd_t *pmd;
> -	pte_t *pte;
> +	pte_t pte;
> +	kvm_pte_t kpte;
>  
>  	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
> -	if (!stage2_get_leaf_entry(&kvm->arch.mmu, gpa, &pud, &pmd, &pte))
> -		return 0;
> -
> -	if (pud)
> -		return stage2_pudp_test_and_clear_young(pud);
> -	else if (pmd)
> -		return stage2_pmdp_test_and_clear_young(pmd);
> -	else
> -		return stage2_ptep_test_and_clear_young(pte);
> +	kpte = kvm_pgtable_stage2_mkold(kvm->arch.mmu.pgt, gpa);
> +	pte = __pte(kpte);
> +	return pte_valid(pte) && pte_young(pte);

I checked that the semantics of the return value are preserved. The old version of
the function returned 1 if stage2_get_leaf_entry() returned true (entry was found
and it was valid) and the entry was young, which is equivalent to pte_valid(pte)
&& pte_young(pte).

>  }
>  
>  static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
>  {
> -	pud_t *pud;
> -	pmd_t *pmd;
> -	pte_t *pte;
> -
>  	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
> -	if (!stage2_get_leaf_entry(&kvm->arch.mmu, gpa, &pud, &pmd, &pte))
> -		return 0;
> -
> -	if (pud)
> -		return kvm_s2pud_young(*pud);
> -	else if (pmd)
> -		return pmd_young(*pmd);
> -	else
> -		return pte_young(*pte);
> +	return kvm_pgtable_stage2_is_young(kvm->arch.mmu.pgt, gpa);
>  }

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Thanks,
Alex
>  
>  int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
