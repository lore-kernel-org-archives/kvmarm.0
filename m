Return-Path: <SRS0=vcVD=7Y=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 318E0C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 08:01:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A71D3207C3
	for <kvmarm@archiver.kernel.org>; Thu, 11 Jun 2020 08:01:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="BFNWtrgH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A71D3207C3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E0004B153;
	Thu, 11 Jun 2020 04:01:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7sL-igAU1-DP; Thu, 11 Jun 2020 04:01:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 84F374B147;
	Thu, 11 Jun 2020 04:01:50 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D78AA4B147
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2020 04:01:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oIBNDv7QrO56 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 11 Jun 2020 04:01:47 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ACFF44B108
 for <kvmarm@lists.cs.columbia.edu>; Thu, 11 Jun 2020 04:01:47 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 65AB1204EA;
 Thu, 11 Jun 2020 08:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1591862506;
 bh=WrdLLQIOoxEMsuU9Lk5Dy1SToKye9eSD7H3ebXQ4auQ=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=BFNWtrgHmTyg+AGGrVuwbubxxA7aMIB6dBhEn5erW2tJ90Re7LmkgQh1PRU8S1tBy
 1Vf5aq5qLm3ViH955oFX5SqDRf+22SYRhv8o6a+CLJPlv/tGf0NcfQ1zvZ772LwNWR
 fmY3NiXUQ/U6YmjVuKyNJoqR2RwkIVDLBKcX1YPI=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jjI9g-0021ZL-Tz; Thu, 11 Jun 2020 09:01:45 +0100
MIME-Version: 1.0
Date: Thu, 11 Jun 2020 09:01:44 +0100
From: Marc Zyngier <maz@kernel.org>
To: Sean Christopherson <sean.j.christopherson@intel.com>
Subject: Re: [PATCH 18/21] KVM: arm64: Use common KVM implementation of MMU
 memory caches
In-Reply-To: <20200605213853.14959-19-sean.j.christopherson@intel.com>
References: <20200605213853.14959-1-sean.j.christopherson@intel.com>
 <20200605213853.14959-19-sean.j.christopherson@intel.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <3555daf3b38c890e1e74f05d6f49f9be@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: sean.j.christopherson@intel.com, paulus@ozlabs.org,
 borntraeger@de.ibm.com, frankja@linux.ibm.com, pbonzini@redhat.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 david@redhat.com, cohuck@redhat.com, imbrenda@linux.ibm.com,
 vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com,
 joro@8bytes.org, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, linux-mips@vger.kernel.org, kvm@vger.kernel.org,
 kvm-ppc@vger.kernel.org, linux-kernel@vger.kernel.org, pfeiner@google.com,
 pshier@google.com, junaids@google.com, bgardon@google.com,
 christoffer.dall@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org,
 Paul Mackerras <paulus@ozlabs.org>, Ben Gardon <bgardon@google.com>,
 Claudio Imbrenda <imbrenda@linux.ibm.com>, kvmarm@lists.cs.columbia.edu,
 Janosch Frank <frankja@linux.ibm.com>, Joerg Roedel <joro@8bytes.org>,
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Junaid Shahid <junaids@google.com>, kvm-ppc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>,
 Cornelia Huck <cohuck@redhat.com>, Peter Shier <pshier@google.com>,
 linux-mips@vger.kernel.org, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Peter Feiner <pfeiner@google.com>
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

On 2020-06-05 22:38, Sean Christopherson wrote:
> Move to the common MMU memory cache implementation now that the common
> code and arm64's existing code are semantically compatible.
> 
> No functional change intended.
> 
> Suggested-by: Christoffer Dall <christoffer.dall@arm.com>
> Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
> ---
>  arch/arm64/include/asm/kvm_host.h  | 12 -------
>  arch/arm64/include/asm/kvm_types.h |  2 ++
>  arch/arm64/kvm/mmu.c               | 51 ++++++------------------------
>  3 files changed, 12 insertions(+), 53 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h
> b/arch/arm64/include/asm/kvm_host.h
> index 2385dede96e0..d221b6b129fd 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -97,18 +97,6 @@ struct kvm_arch {
>  	bool return_nisv_io_abort_to_user;
>  };
> 
> -#define KVM_NR_MEM_OBJS     40
> -
> -/*
> - * We don't want allocation failures within the mmu code, so we 
> preallocate
> - * enough memory for a single page fault in a cache.
> - */
> -struct kvm_mmu_memory_cache {
> -	int nobjs;
> -	gfp_t gfp_zero;
> -	void *objects[KVM_NR_MEM_OBJS];
> -};
> -
>  struct kvm_vcpu_fault_info {
>  	u32 esr_el2;		/* Hyp Syndrom Register */
>  	u64 far_el2;		/* Hyp Fault Address Register */
> diff --git a/arch/arm64/include/asm/kvm_types.h
> b/arch/arm64/include/asm/kvm_types.h
> index d0987007d581..9a126b9e2d7c 100644
> --- a/arch/arm64/include/asm/kvm_types.h
> +++ b/arch/arm64/include/asm/kvm_types.h
> @@ -2,5 +2,7 @@
>  #ifndef _ASM_ARM64_KVM_TYPES_H
>  #define _ASM_ARM64_KVM_TYPES_H
> 
> +#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
> +
>  #endif /* _ASM_ARM64_KVM_TYPES_H */
> 
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 688213ef34f0..976405e2fbb2 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -124,37 +124,6 @@ static void stage2_dissolve_pud(struct kvm *kvm,
> phys_addr_t addr, pud_t *pudp)
>  	put_page(virt_to_page(pudp));
>  }
> 
> -static int mmu_topup_memory_cache(struct kvm_mmu_memory_cache *cache, 
> int min)
> -{
> -	void *page;
> -
> -	if (cache->nobjs >= min)
> -		return 0;
> -	while (cache->nobjs < ARRAY_SIZE(cache->objects)) {
> -		page = (void *)__get_free_page(GFP_KERNEL_ACCOUNT |
> -					       cache->gfp_zero);
> -		if (!page)
> -			return -ENOMEM;
> -		cache->objects[cache->nobjs++] = page;
> -	}
> -	return 0;
> -}
> -
> -static void mmu_free_memory_cache(struct kvm_mmu_memory_cache *mc)
> -{
> -	while (mc->nobjs)
> -		free_page((unsigned long)mc->objects[--mc->nobjs]);
> -}
> -
> -static void *mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc)
> -{
> -	void *p;
> -
> -	BUG_ON(!mc || !mc->nobjs);
> -	p = mc->objects[--mc->nobjs];
> -	return p;
> -}
> -
>  static void clear_stage2_pgd_entry(struct kvm *kvm, pgd_t *pgd,
> phys_addr_t addr)
>  {
>  	pud_t *pud_table __maybe_unused = stage2_pud_offset(kvm, pgd, 0UL);
> @@ -1024,7 +993,7 @@ static pud_t *stage2_get_pud(struct kvm *kvm,
> struct kvm_mmu_memory_cache *cache
>  	if (stage2_pgd_none(kvm, *pgd)) {
>  		if (!cache)
>  			return NULL;
> -		pud = mmu_memory_cache_alloc(cache);
> +		pud = kvm_mmu_memory_cache_alloc(cache);
>  		stage2_pgd_populate(kvm, pgd, pud);
>  		get_page(virt_to_page(pgd));
>  	}

Quick note: this patch (as it is) breaks on arm64 due to Mike Rapoport's
P4D rework. I've fixed it locally in order to test the series.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
