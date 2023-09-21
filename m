Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B3A1FAF
	for <kvmarm@lists.linux.dev>; Thu, 21 Sep 2023 03:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695266896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0v2JG/s7PIc0vGKodtM+Q59Y9VnGkq0n4Wh8qBqHuOY=;
	b=Kc26MZ1wPbp8WDtR2ze0PWWJ/5KGrhGs/HkVO+VkgG0s5EyfTVlzG5QmUhkRRf+2LI9apy
	UuMA+hMA+W9t0XyZJDrRkCFtV/mY0eIHXZtjN+2FOrgirHzdbkUpmTRaBUYeTGc6DgWW8V
	7YNezBc0lvDXsdzApaXTZw4+HiLnYLk=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-85-IHqYkDwjNkCBTqzZ_O3_1g-1; Wed, 20 Sep 2023 23:28:13 -0400
X-MC-Unique: IHqYkDwjNkCBTqzZ_O3_1g-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-27472e97c0bso312339a91.3
        for <kvmarm@lists.linux.dev>; Wed, 20 Sep 2023 20:28:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695266892; x=1695871692;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0v2JG/s7PIc0vGKodtM+Q59Y9VnGkq0n4Wh8qBqHuOY=;
        b=OEq5ZgTi7XgYwp+bwe5YxVyQDR0owWoXGZRqzu9nMTm5YPK5wztk95ChMfYCHcCM0P
         oXCKVG7e18/lAyTlzYskBStN2XhPXZCrDJLPUkKW+9LIc4U5iv1TH64FKxaFOuHZVed/
         fMFFJ5je+MrhIOYsjjCpPKCk8EfKDcdZ3q0opFJKkuJ7dsMlmSI5yglNNQOJCWnpszYj
         4TUZVwOI2c2tb7ptLdEBoESCr+BXPrnd1m6D5qq4c2WfWToHiyWr3FI+hBTeZHaK5rOs
         XAMnpfGCG26E+1x5O+t704kk0di6/cg/zidoLq+DoySa/OkJ2Q9oDdtrI/SqR9L/WOiV
         R6gA==
X-Gm-Message-State: AOJu0Yxl/Fqu4HxSO1weHfhf/ipQJvG3cf5fMSkCu+alEJA/237ERckw
	lp0ujatcf6k3OYe5Rr+ve0WAXDEOKTqZ7FQFNktp7mZvG/DMgArlHPNY70r12WDyX+j1Z9jBKcN
	/gYp9WlusVfvbzywXzw8YH2Gr
X-Received: by 2002:a17:90b:60f:b0:271:9237:a07f with SMTP id gb15-20020a17090b060f00b002719237a07fmr4640842pjb.32.1695266892198;
        Wed, 20 Sep 2023 20:28:12 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGdTGDV/U1WxJZGqkf4/kI8P6PMbKZALx0spzejxrzMvccw2t9wWS0So2gleLrmzMbpuDGdXw==
X-Received: by 2002:a17:90b:60f:b0:271:9237:a07f with SMTP id gb15-20020a17090b060f00b002719237a07fmr4640832pjb.32.1695266891888;
        Wed, 20 Sep 2023 20:28:11 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id j8-20020a17090a31c800b0027360359b70sm287885pjf.48.2023.09.20.20.28.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 20:28:11 -0700 (PDT)
Message-ID: <b652ad1e-6d38-3591-7728-487afeb1c9a6@redhat.com>
Date: Thu, 21 Sep 2023 13:28:06 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 2/2] KVM: arm64: Avoid soft lockups due to I-cache
 maintenance
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 linux-arm-kernel@lists.infradead.org
References: <20230920080133.944717-1-oliver.upton@linux.dev>
 <20230920080133.944717-3-oliver.upton@linux.dev>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230920080133.944717-3-oliver.upton@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/23 18:01, Oliver Upton wrote:
> Gavin reports of soft lockups on his Ampere Altra Max machine when
> backing KVM guests with hugetlb pages. Upon further investigation, it
> was found that the system is unable to keep up with parallel I-cache
> invalidations done by KVM's stage-2 fault handler.
> 
> This is ultimately an implementation problem. I-cache maintenance
> instructions are available at EL0, so nothing stops a malicious
> userspace from hammering a system with CMOs and cause it to fall over.
> "Fixing" this problem in KVM is nothing more than slapping a bandage
> over a much deeper problem.
> 
> Anyway, the kernel already has a heuristic for limiting TLB
> invalidations to avoid soft lockups. Reuse that logic to limit I-cache
> CMOs done by KVM to map executable pages on systems without FEAT_DIC.
> While at it, restructure __invalidate_icache_guest_page() to improve
> readability and squeeze our new condition into the existing branching
> structure.
> 
> Link: https://lore.kernel.org/kvmarm/20230904072826.1468907-1-gshan@redhat.com/
> Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
> ---
>   arch/arm64/include/asm/kvm_mmu.h | 37 ++++++++++++++++++++++++++------
>   1 file changed, 31 insertions(+), 6 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>
Tested-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index 96a80e8f6226..a425ecdd7be0 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -224,16 +224,41 @@ static inline void __clean_dcache_guest_page(void *va, size_t size)
>   	kvm_flush_dcache_to_poc(va, size);
>   }
>   
> +static inline size_t __invalidate_icache_max_range(void)
> +{
> +	u8 iminline;
> +	u64 ctr;
> +
> +	asm volatile(ALTERNATIVE_CB("movz %0, #0\n"
> +				    "movk %0, #0, lsl #16\n"
> +				    "movk %0, #0, lsl #32\n"
> +				    "movk %0, #0, lsl #48\n",
> +				    ARM64_ALWAYS_SYSTEM,
> +				    kvm_compute_final_ctr_el0)
> +		     : "=r" (ctr));
> +
> +	iminline = SYS_FIELD_GET(CTR_EL0, IminLine, ctr) + 2;
> +	return MAX_DVM_OPS << iminline;
> +}
> +
>   static inline void __invalidate_icache_guest_page(void *va, size_t size)
>   {
> -	if (icache_is_aliasing()) {
> -		/* any kind of VIPT cache */
> +	/*
> +	 * VPIPT I-cache maintenance must be done from EL2. See comment in the
> +	 * nVHE flavor of __kvm_tlb_flush_vmid_ipa().
> +	 */
> +	if (icache_is_vpipt() && read_sysreg(CurrentEL) != CurrentEL_EL2)
> +		return;
> +
> +	/*
> +	 * Blow the whole I-cache if it is aliasing (i.e. VIPT) or the
> +	 * invalidation range exceeds our arbitrary limit on invadations by
> +	 * cache line.
> +	 */
> +	if (icache_is_aliasing() || size > __invalidate_icache_max_range())
>   		icache_inval_all_pou();
> -	} else if (read_sysreg(CurrentEL) != CurrentEL_EL1 ||
> -		   !icache_is_vpipt()) {
> -		/* PIPT or VPIPT at EL2 (see comment in __kvm_tlb_flush_vmid_ipa) */
> +	else
>   		icache_inval_pou((unsigned long)va, (unsigned long)va + size);
> -	}
>   }
>   
>   void kvm_set_way_flush(struct kvm_vcpu *vcpu);

