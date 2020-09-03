Return-Path: <SRS0=ROvZ=CM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0220C433E2
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 04:37:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 17CD220716
	for <kvmarm@archiver.kernel.org>; Thu,  3 Sep 2020 04:37:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cuOfVMfY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17CD220716
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7345A4B35D;
	Thu,  3 Sep 2020 00:37:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dgW38W7cikqR; Thu,  3 Sep 2020 00:37:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5337A4B31D;
	Thu,  3 Sep 2020 00:37:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B57814B30C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 00:37:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id HKjC882singY for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Sep 2020 00:37:25 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [207.211.31.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF4564B31D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Sep 2020 00:37:25 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1599107845;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=S68/9hVCwulCuaMk9J3W2zX+S4GaU7CGv+1Yli5RMGo=;
 b=cuOfVMfYw2PM7HeL3NC7yWaBfjJtFRdas4d5NQhsnDEFHqz5bNHs99g0/1OtoKwc6DmWA1
 EPJk+PkmLZYqDxacQIAf0M5IVDX4Vj5GlepNlUG3ITUZdX96QDVg50g1GX3y24T0bojozv
 o9tUqqZwi42B25sglftgj5Xd23Qsoo8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-527-jX7D0PapO6G9-R_sUSd8TQ-1; Thu, 03 Sep 2020 00:37:24 -0400
X-MC-Unique: jX7D0PapO6G9-R_sUSd8TQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3FFA418B9ECA;
 Thu,  3 Sep 2020 04:37:22 +0000 (UTC)
Received: from [10.64.54.159] (vpn2-54-159.bne.redhat.com [10.64.54.159])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 1718860C0F;
 Thu,  3 Sep 2020 04:37:19 +0000 (UTC)
Subject: Re: [PATCH v3 11/21] KVM: arm64: Convert page-aging and access faults
 to generic page-table API
To: Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
References: <20200825093953.26493-1-will@kernel.org>
 <20200825093953.26493-12-will@kernel.org>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <10da8311-1b80-dd1b-1a30-6e3aebc0f196@redhat.com>
Date: Thu, 3 Sep 2020 14:37:17 +1000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <20200825093953.26493-12-will@kernel.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Authentication-Results: relay.mimecast.com;
 auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=gshan@redhat.com
X-Mimecast-Spam-Score: 0.002
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Cc: Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kernel-team@android.com, linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Will,

On 8/25/20 7:39 PM, Will Deacon wrote:
> Convert the page-aging functions and access fault handler to use the
> generic page-table code instead of walking the page-table directly.
> 
> Cc: Marc Zyngier <maz@kernel.org>
> Cc: Quentin Perret <qperret@google.com>
> Signed-off-by: Will Deacon <will@kernel.org>
> ---
>   arch/arm64/kvm/mmu.c | 74 ++++++++++----------------------------------
>   1 file changed, 16 insertions(+), 58 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 751ce2462765..d3db8e00ce0a 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -1698,46 +1698,23 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>   	return ret;
>   }
>   
> -/*
> - * Resolve the access fault by making the page young again.
> - * Note that because the faulting entry is guaranteed not to be
> - * cached in the TLB, we don't need to invalidate anything.
> - * Only the HW Access Flag updates are supported for Stage 2 (no DBM),
> - * so there is no need for atomic (pte|pmd)_mkyoung operations.
> - */
> +/* Resolve the access fault by making the page young again. */
>   static void handle_access_fault(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa)
>   {
> -	pud_t *pud;
> -	pmd_t *pmd;
> -	pte_t *pte;
> -	kvm_pfn_t pfn;
> -	bool pfn_valid = false;
> +	pte_t pte;
> +	kvm_pte_t kpte;
> +	struct kvm_s2_mmu *mmu;
>   
>   	trace_kvm_access_fault(fault_ipa);
>   
>   	spin_lock(&vcpu->kvm->mmu_lock);
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
>   	spin_unlock(&vcpu->kvm->mmu_lock);
> -	if (pfn_valid)
> -		kvm_set_pfn_accessed(pfn);
> +
> +	pte = __pte(kpte);
> +	if (pte_valid(pte))
> +		kvm_set_pfn_accessed(pte_pfn(pte));
>   }
>   
>   /**
> @@ -1954,38 +1931,19 @@ int kvm_set_spte_hva(struct kvm *kvm, unsigned long hva, pte_t pte)
>   
>   static int kvm_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
>   {
> -	pud_t *pud;
> -	pmd_t *pmd;
> -	pte_t *pte;
> +	pte_t pte;
> +	kvm_pte_t kpte;
>   
>   	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
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
>   }
>   
>   static int kvm_test_age_hva_handler(struct kvm *kvm, gpa_t gpa, u64 size, void *data)
>   {
> -	pud_t *pud;
> -	pmd_t *pmd;
> -	pte_t *pte;
> -
>   	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
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
>   }
>   
>   int kvm_age_hva(struct kvm *kvm, unsigned long start, unsigned long end)
> 

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
