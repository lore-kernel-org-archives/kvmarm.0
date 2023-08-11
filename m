Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E76A47
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 03:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691723640;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+8Fzopu9BiGSPjrEUNgR9DMg7UpRaexYmg1fQM6xS1Q=;
	b=jBLfwgJ3FigI3FpMokS1XSdmQ0sTJ8OppUgJkAHc3FQyJpRrWAmoITHSQBDamEU22RyvHl
	428fyOdvFya+0gM/T0r3nXnkIEn+e7tPqeoF5jvFP/OWPbgqluZ6aBpggIfpAKSJdaMNGa
	HrKW5by2L5p3SXiQhs5Mn8XLTOp66Wk=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-176-azwQjLrtO-aVFasGnJToBg-1; Thu, 10 Aug 2023 23:13:55 -0400
X-MC-Unique: azwQjLrtO-aVFasGnJToBg-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6871900d991so390958b3a.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 20:13:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691723635; x=1692328435;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+8Fzopu9BiGSPjrEUNgR9DMg7UpRaexYmg1fQM6xS1Q=;
        b=MxSOc84UxrFf96O5qZKbB16qpccyn5Cec1k1+IjiDPDHBXLE7nL6AoqMUBrCtSdyWz
         IMhw5B/kcICHwBEUsQPtm9aADPP6kT92c18B03TgLb6fVVZqG5CKyEio/mL0x3EOrU9v
         h2keRmWNshiwwIHpJtYgxC4rummUYm91f5nya0s8llD2xAt1kx+Y7SCLz/zg6HS7r/VA
         IcgCQUHlOxMRPCabH8AXx7DYrrtWefORO1y55X7O+EgrpszEGnFdVvoECF55jG8oKIxf
         nSJUlEnJIvQqYg5J/CfU1SXrKchDjmQEANVxZtVoV3glQn6mOd0J7eYIIxNthnKgFrPc
         dUKg==
X-Gm-Message-State: AOJu0Yz9r2Cvz1Qukm86GMsZFphRWQE7NclxxHfRylDjlO30O7Cpwo7W
	7W0+CHAbcuLeLMqmt5sxF0qgrFZjzH9JljFxMRPFgUeYH99IiMb79Rghq6vr+hyD8j91QjGzU4d
	Ad85JywDNNkWiaRRS
X-Received: by 2002:a05:6a00:4789:b0:687:874c:7ce0 with SMTP id dh9-20020a056a00478900b00687874c7ce0mr669615pfb.1.1691723634861;
        Thu, 10 Aug 2023 20:13:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE3d1VhIHydgxUNSBHJCWT9khJqug4xGZp+7IM8qZhfIPYmAixEOhR0Nz01guBm87TUHF3WYw==
X-Received: by 2002:a05:6a00:4789:b0:687:874c:7ce0 with SMTP id dh9-20020a056a00478900b00687874c7ce0mr669587pfb.1.1691723634514;
        Thu, 10 Aug 2023 20:13:54 -0700 (PDT)
Received: from [10.72.112.92] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x8-20020aa79188000000b0064d57ecaa1dsm2227869pfa.28.2023.08.10.20.13.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 20:13:54 -0700 (PDT)
Message-ID: <5ca5e4ed-82f0-369b-db61-7fcd1c148f1c@redhat.com>
Date: Fri, 11 Aug 2023 11:13:46 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 14/14] KVM: arm64: Use TLBI range-based intructions for
 unmap
To: Raghavendra Rao Ananta <rananta@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Huacai Chen
 <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>,
 Colton Lewis <coltonlewis@google.com>, David Matlack <dmatlack@google.com>,
 Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20230808231330.3855936-1-rananta@google.com>
 <20230808231330.3855936-15-rananta@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230808231330.3855936-15-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/9/23 07:13, Raghavendra Rao Ananta wrote:
> The current implementation of the stage-2 unmap walker traverses
> the given range and, as a part of break-before-make, performs
> TLB invalidations with a DSB for every PTE. A multitude of this
> combination could cause a performance bottleneck on some systems.
> 
> Hence, if the system supports FEAT_TLBIRANGE, defer the TLB
> invalidations until the entire walk is finished, and then
> use range-based instructions to invalidate the TLBs in one go.
> Condition deferred TLB invalidation on the system supporting FWB,
> as the optimization is entirely pointless when the unmap walker
> needs to perform CMOs.
> 
> Rename stage2_put_pte() to stage2_unmap_put_pte() as the function
> now serves the stage-2 unmap walker specifically, rather than
> acting generic.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/kvm/hyp/pgtable.c | 40 +++++++++++++++++++++++++++++-------
>   1 file changed, 33 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index 5ef098af17362..eaaae76481fa9 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -831,16 +831,36 @@ static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t n
>   	smp_store_release(ctx->ptep, new);
>   }
>   
> -static void stage2_put_pte(const struct kvm_pgtable_visit_ctx *ctx, struct kvm_s2_mmu *mmu,
> -			   struct kvm_pgtable_mm_ops *mm_ops)
> +static bool stage2_unmap_defer_tlb_flush(struct kvm_pgtable *pgt)
>   {
>   	/*
> -	 * Clear the existing PTE, and perform break-before-make with
> -	 * TLB maintenance if it was valid.
> +	 * If FEAT_TLBIRANGE is implemented, defer the individual
> +	 * TLB invalidations until the entire walk is finished, and
> +	 * then use the range-based TLBI instructions to do the
> +	 * invalidations. Condition deferred TLB invalidation on the
> +	 * system supporting FWB as the optimization is entirely
> +	 * pointless when the unmap walker needs to perform CMOs.
> +	 */
> +	return system_supports_tlb_range() && stage2_has_fwb(pgt);
> +}
> +
> +static void stage2_unmap_put_pte(const struct kvm_pgtable_visit_ctx *ctx,
> +				struct kvm_s2_mmu *mmu,
> +				struct kvm_pgtable_mm_ops *mm_ops)
> +{
> +	struct kvm_pgtable *pgt = ctx->arg;
> +
> +	/*
> +	 * Clear the existing PTE, and perform break-before-make if it was
> +	 * valid. Depending on the system support, defer the TLB maintenance
> +	 * for the same until the entire unmap walk is completed.
>   	 */
>   	if (kvm_pte_valid(ctx->old)) {
>   		kvm_clear_pte(ctx->ptep);
> -		kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ctx->addr, ctx->level);
> +
> +		if (!stage2_unmap_defer_tlb_flush(pgt))
> +			kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu,
> +					ctx->addr, ctx->level);
>   	}
>   
>   	mm_ops->put_page(ctx->ptep);
> @@ -1098,7 +1118,7 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>   	 * block entry and rely on the remaining portions being faulted
>   	 * back lazily.
>   	 */
> -	stage2_put_pte(ctx, mmu, mm_ops);
> +	stage2_unmap_put_pte(ctx, mmu, mm_ops);
>   
>   	if (need_flush && mm_ops->dcache_clean_inval_poc)
>   		mm_ops->dcache_clean_inval_poc(kvm_pte_follow(ctx->old, mm_ops),
> @@ -1112,13 +1132,19 @@ static int stage2_unmap_walker(const struct kvm_pgtable_visit_ctx *ctx,
>   
>   int kvm_pgtable_stage2_unmap(struct kvm_pgtable *pgt, u64 addr, u64 size)
>   {
> +	int ret;
>   	struct kvm_pgtable_walker walker = {
>   		.cb	= stage2_unmap_walker,
>   		.arg	= pgt,
>   		.flags	= KVM_PGTABLE_WALK_LEAF | KVM_PGTABLE_WALK_TABLE_POST,
>   	};
>   
> -	return kvm_pgtable_walk(pgt, addr, size, &walker);
> +	ret = kvm_pgtable_walk(pgt, addr, size, &walker);
> +	if (stage2_unmap_defer_tlb_flush(pgt))
> +		/* Perform the deferred TLB invalidations */
> +		kvm_tlb_flush_vmid_range(pgt->mmu, addr, size);
> +
> +	return ret;
>   }
>   
>   struct stage2_attr_data {

-- 
Shaoqin

