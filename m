Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39641FA9
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 08:39:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689669568;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=48OfsAs+5NoliWawjnL6mrqynpB+mYbsWNJ2N0teO4w=;
	b=ZcNcd7BUBnlW5ef07InP4qh+CXmP3//x42h+6KkHe8zJOK0n9oT9g0y6W/ehB+qHMatmcw
	Kf0/QgsUyWPFa8xrIeo741jLcPHKMcKOuRT/pD7KMZ08fjj2lXPIs25ToXrdu6zX7iyncC
	ZauNHXYSMNIJlWS18hN+GSvlY76wO7Q=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-19-AcB8iRUVMXmICt-sUAyzPQ-1; Tue, 18 Jul 2023 04:39:26 -0400
X-MC-Unique: AcB8iRUVMXmICt-sUAyzPQ-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-553c68126f8so746535a12.0
        for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 01:39:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689669566; x=1692261566;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=48OfsAs+5NoliWawjnL6mrqynpB+mYbsWNJ2N0teO4w=;
        b=LdsUe/c6ZVyvI+Ih7uXzEi7AKW/1m3BhMYMO9iAwvhJFOTP2775pwZCIY93jkx7hM5
         t4rWtZ+p6ze6MOjd9Y4J8uyswweNFCFBXmkf2oyq+ARbyGXFF7iHkbiW0iXZwUNT+VVg
         W9CNv/0odPYNWe9ZVN8zCICu263HzOL0Y4Zgh9T3h1XItSS/ups9/Ii1Xmsz1h9C74K0
         Eu9C6OtgOaL/zGxKaA8RACjtYpW603TLsi5l2dr+meJ2icbcRZDexYkJID8qjGlxpuan
         HBiigSEpV58P0e6IR3gDI5lG9KQnTZNZR2W5p5b8RodPx1lRyomYJEDJZWtG2tTU6LTA
         BANw==
X-Gm-Message-State: ABy/qLZ9PQgvj16oyY0jYC2f6ts6zyrhp8EeQe+mrGPvF3umLuynhO64
	wNtEzFzZmuKlblHh7H0yvvQED2kq4Dsn5P2lyeit7xwRPTQ/8O2XV6XvBCO2hL3y3LB1BAdoSfa
	2nzl0ugkrPR/GiSBR
X-Received: by 2002:a05:6a21:338e:b0:123:149b:a34f with SMTP id yy14-20020a056a21338e00b00123149ba34fmr11522174pzb.1.1689669565982;
        Tue, 18 Jul 2023 01:39:25 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFn6VTd9NoeqQyeoZ4mz9lw2meP9X5GlAOs2CSTs0WWxzf4uI+E1rzir2tOn6PnHRRKr5e2eQ==
X-Received: by 2002:a05:6a21:338e:b0:123:149b:a34f with SMTP id yy14-20020a056a21338e00b00123149ba34fmr11522141pzb.1.1689669565640;
        Tue, 18 Jul 2023 01:39:25 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id p9-20020a639509000000b0055bbc746272sm1140176pgd.17.2023.07.18.01.39.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jul 2023 01:39:25 -0700 (PDT)
Message-ID: <148fecc6-7ad5-1039-4466-7c1e5a9df911@redhat.com>
Date: Tue, 18 Jul 2023 16:39:20 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 07/11] KVM: arm64: Define kvm_tlb_flush_vmid_range()
To: Raghavendra Rao Ananta <rananta@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Huacai Chen
 <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Gavin Shan <gshan@redhat.com>
References: <20230715005405.3689586-1-rananta@google.com>
 <20230715005405.3689586-8-rananta@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230715005405.3689586-8-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/15/23 08:54, Raghavendra Rao Ananta wrote:
> Implement the helper kvm_tlb_flush_vmid_range() that acts
> as a wrapper for range-based TLB invalidations. For the
> given VMID, use the range-based TLBI instructions to do
> the job or fallback to invalidating all the TLB entries.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h | 10 ++++++++++
>   arch/arm64/kvm/hyp/pgtable.c         | 20 ++++++++++++++++++++
>   2 files changed, 30 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 8294a9a7e566..5e8b1ff07854 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -754,4 +754,14 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte);
>    *	   kvm_pgtable_prot format.
>    */
>   enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
> +
> +/**
> + * kvm_tlb_flush_vmid_range() - Invalidate/flush a range of TLB entries
> + *
> + * @mmu:	Stage-2 KVM MMU struct
> + * @addr:	The base Intermediate physical address from which to invalidate
> + * @size:	Size of the range from the base to invalidate
> + */
> +void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> +				phys_addr_t addr, size_t size);
>   #endif	/* __ARM64_KVM_PGTABLE_H__ */
> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
> index aa740a974e02..5d14d5d5819a 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -670,6 +670,26 @@ static bool stage2_has_fwb(struct kvm_pgtable *pgt)
>   	return !(pgt->flags & KVM_PGTABLE_S2_NOFWB);
>   }
>   
> +void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
> +				phys_addr_t addr, size_t size)
> +{
> +	unsigned long pages, inval_pages;
> +
> +	if (!system_supports_tlb_range()) {
> +		kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
> +		return;
> +	}
> +
> +	pages = size >> PAGE_SHIFT;
> +	while (pages > 0) {
> +		inval_pages = min(pages, MAX_TLBI_RANGE_PAGES);
> +		kvm_call_hyp(__kvm_tlb_flush_vmid_range, mmu, addr, inval_pages);
> +
> +		addr += inval_pages << PAGE_SHIFT;
> +		pages -= inval_pages;
> +	}
> +}
> +
>   #define KVM_S2_MEMATTR(pgt, attr) PAGE_S2_MEMATTR(attr, stage2_has_fwb(pgt))
>   
>   static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot prot,

-- 
Shaoqin

