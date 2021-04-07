Return-Path: <SRS0=nct1=JE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B10E0C43460
	for <kvmarm@archiver.kernel.org>; Wed,  7 Apr 2021 15:35:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C5FA613CE
	for <kvmarm@archiver.kernel.org>; Wed,  7 Apr 2021 15:35:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C5FA613CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 87D744B918;
	Wed,  7 Apr 2021 11:35:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id amuQr7-mLmZB; Wed,  7 Apr 2021 11:35:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 489754B888;
	Wed,  7 Apr 2021 11:35:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1BD8B4B7ED
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Apr 2021 11:35:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K7cl2UcwuSWr for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Apr 2021 11:35:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F9774B7CD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Apr 2021 11:35:23 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 470861424;
 Wed,  7 Apr 2021 08:35:23 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 402603F792;
 Wed,  7 Apr 2021 08:35:21 -0700 (PDT)
Subject: Re: [RFC PATCH v3 2/2] KVM: arm64: Distinguish cases of memcache
 allocations completely
To: Yanan Wang <wangyanan55@huawei.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210326031654.3716-1-wangyanan55@huawei.com>
 <20210326031654.3716-3-wangyanan55@huawei.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <4348b555-2a38-6f00-8ef0-0d5fd801d753@arm.com>
Date: Wed, 7 Apr 2021 16:35:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210326031654.3716-3-wangyanan55@huawei.com>
Content-Language: en-US
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

Hi Yanan,

On 3/26/21 3:16 AM, Yanan Wang wrote:
> With a guest translation fault, the memcache pages are not needed if KVM
> is only about to install a new leaf entry into the existing page table.
> And with a guest permission fault, the memcache pages are also not needed
> for a write_fault in dirty-logging time if KVM is only about to update
> the existing leaf entry instead of collapsing a block entry into a table.
>
> By comparing fault_granule and vma_pagesize, cases that require allocations
> from memcache and cases that don't can be distinguished completely.
>
> Signed-off-by: Yanan Wang <wangyanan55@huawei.com>
> ---
>  arch/arm64/kvm/mmu.c | 25 ++++++++++++-------------
>  1 file changed, 12 insertions(+), 13 deletions(-)
>
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 1eec9f63bc6f..05af40dc60c1 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -810,19 +810,6 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	gfn = fault_ipa >> PAGE_SHIFT;
>  	mmap_read_unlock(current->mm);
>  
> -	/*
> -	 * Permission faults just need to update the existing leaf entry,
> -	 * and so normally don't require allocations from the memcache. The
> -	 * only exception to this is when dirty logging is enabled at runtime
> -	 * and a write fault needs to collapse a block entry into a table.
> -	 */
> -	if (fault_status != FSC_PERM || (logging_active && write_fault)) {
> -		ret = kvm_mmu_topup_memory_cache(memcache,
> -						 kvm_mmu_cache_min_pages(kvm));
> -		if (ret)
> -			return ret;
> -	}
> -
>  	mmu_seq = vcpu->kvm->mmu_notifier_seq;
>  	/*
>  	 * Ensure the read of mmu_notifier_seq happens before we call
> @@ -880,6 +867,18 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>  	else if (cpus_have_const_cap(ARM64_HAS_CACHE_DIC))
>  		prot |= KVM_PGTABLE_PROT_X;
>  
> +	/*
> +	 * Allocations from the memcache are required only when granule of the
> +	 * lookup level where the guest fault happened exceeds vma_pagesize,
> +	 * which means new page tables will be created in the fault handlers.
> +	 */
> +	if (fault_granule > vma_pagesize) {
> +		ret = kvm_mmu_topup_memory_cache(memcache,
> +						 kvm_mmu_cache_min_pages(kvm));
> +		if (ret)
> +			return ret;
> +	}

As I explained in v1 [1], this looks correct to me. I still think that someone
else should have a look, but if Marc decides to pick up this patch as-is, he can
add my Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>.

[1] https://lore.kernel.org/lkml/2c65bff2-be7f-b20c-9265-939bc73185b6@arm.com/

Thanks,

Alex

> +
>  	/*
>  	 * Under the premise of getting a FSC_PERM fault, we just need to relax
>  	 * permissions only if vma_pagesize equals fault_granule. Otherwise,
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
