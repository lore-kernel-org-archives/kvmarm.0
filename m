Return-Path: <SRS0=y90B=AM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F83AC433DF
	for <kvmarm@archiver.kernel.org>; Wed,  1 Jul 2020 11:28:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D96F620722
	for <kvmarm@archiver.kernel.org>; Wed,  1 Jul 2020 11:28:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D96F620722
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C7B64B32B;
	Wed,  1 Jul 2020 07:28:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id tQ3GBQY8qc2a; Wed,  1 Jul 2020 07:28:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3BE94B31F;
	Wed,  1 Jul 2020 07:28:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A80B4B2F4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jul 2020 07:28:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GwSQuCGZEpTN for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Jul 2020 07:28:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EC2A4B2C3
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Jul 2020 07:28:44 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D39FD30E;
 Wed,  1 Jul 2020 04:28:43 -0700 (PDT)
Received: from [192.168.1.84] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0D8313F73C;
 Wed,  1 Jul 2020 04:28:40 -0700 (PDT)
Subject: Re: [PATCH 03/12] KVM: arm64: Report hardware dirty status of stage2
 PTE if coverred
To: Keqian Zhu <zhukeqian1@huawei.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
References: <20200616093553.27512-1-zhukeqian1@huawei.com>
 <20200616093553.27512-4-zhukeqian1@huawei.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <a73952ac-5e81-6c05-9b21-734e25250845@arm.com>
Date: Wed, 1 Jul 2020 12:28:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200616093553.27512-4-zhukeqian1@huawei.com>
Content-Language: en-GB
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Sean Christopherson <sean.j.christopherson@intel.com>, liangpeng10@huawei.com,
 Alexios Zavras <alexios.zavras@intel.com>, Mark Brown <broonie@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi,

On 16/06/2020 10:35, Keqian Zhu wrote:
> kvm_set_pte is called to replace a target PTE with a desired one.
> We always do this without changing the desired one, but if dirty
> status set by hardware is coverred, let caller know it.
> 
> Signed-off-by: Keqian Zhu <zhukeqian1@huawei.com>
> ---
>   arch/arm64/kvm/mmu.c | 36 +++++++++++++++++++++++++++++++++++-
>   1 file changed, 35 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 5ad87bce23c0..27407153121b 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -194,11 +194,45 @@ static void clear_stage2_pmd_entry(struct kvm *kvm, pmd_t *pmd, phys_addr_t addr
>   	put_page(virt_to_page(pmd));
>   }
>   
> -static inline void kvm_set_pte(pte_t *ptep, pte_t new_pte)
> +#ifdef CONFIG_ARM64_HW_AFDBM
> +/**
> + * @ret: true if dirty status set by hardware is coverred.

NIT: s/coverred/covered/, this is in several places.

> + */
> +static bool kvm_set_pte(pte_t *ptep, pte_t new_pte)
> +{
> +	pteval_t old_pteval, new_pteval, pteval;
> +	bool old_logging, new_no_write;
> +
> +	old_logging = kvm_hw_dbm_enabled() && !pte_none(*ptep) &&
> +		      kvm_s2pte_dbm(ptep);
> +	new_no_write = pte_none(new_pte) || kvm_s2pte_readonly(&new_pte);
> +
> +	if (!old_logging || !new_no_write) {
> +		WRITE_ONCE(*ptep, new_pte);
> +		dsb(ishst);
> +		return false;
> +	}
> +
> +	new_pteval = pte_val(new_pte);
> +	pteval = READ_ONCE(pte_val(*ptep));

This usage of *ptep looks wrong - it's read twice using READ_ONCE (once 
in kvm_s2pte_dbm()) and once without any decoration (in the pte_none() 
call). Which looks a bit dodgy and at the very least needs some 
justification. AFAICT you would be better taking a local copy and using 
that rather than reading from memory repeatedly.

> +	do {
> +		old_pteval = pteval;
> +		pteval = cmpxchg_relaxed(&pte_val(*ptep), old_pteval, new_pteval);
> +	} while (pteval != old_pteval);
This look appears to be reinventing xchg_relaxed(). Any reason we can't 
just use xchg_relaxed()? Also we had a dsb() after the WRITE_ONCE but 
you are using the _relaxed variant here. What is the justification for 
not having a barrier?

> +
> +	return !kvm_s2pte_readonly(&__pte(pteval));
> +}
> +#else
> +/**
> + * @ret: true if dirty status set by hardware is coverred.
> + */
> +static inline bool kvm_set_pte(pte_t *ptep, pte_t new_pte)
>   {
>   	WRITE_ONCE(*ptep, new_pte);
>   	dsb(ishst);
> +	return false;
>   }
> +#endif /* CONFIG_ARM64_HW_AFDBM */

You might be able to avoid this #ifdef by redefining old_logging as:

   old_logging = IS_ENABLED(CONFIG_ARM64_HW_AFDBM) && ...

I *think* the compiler should be able to kill the dead code and leave 
you with just the above when the config symbol is off.

Steve

>   
>   static inline void kvm_set_pmd(pmd_t *pmdp, pmd_t new_pmd)
>   {
> 

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
