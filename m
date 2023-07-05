Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8AD36D
	for <kvmarm@lists.linux.dev>; Wed,  5 Jul 2023 00:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688517111;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2tbEzCQLL4wAVGNQCcCaWeGf9IDqYi1dQ3iAXttaRxQ=;
	b=J0mmyVAkzVPft89PlCCgACxlvhle9JC5rwZOuZhd9uzNUvX/itPZ4xygzBFwFTSsGKwDLu
	5pEs86aYXPgKIOFmQLK31m32g6BImBmjoj/Kv/AnPlRdo3C3juMhOku/pOSCQ+yQo5YeIr
	gvuYESIdUMN6jXwIMuskXDWVk2ilFiY=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-382-lejHXfhjPf61VFsw_8ioSw-1; Tue, 04 Jul 2023 20:31:49 -0400
X-MC-Unique: lejHXfhjPf61VFsw_8ioSw-1
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-66a4c89bbb1so8137021b3a.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Jul 2023 17:31:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688517109; x=1691109109;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2tbEzCQLL4wAVGNQCcCaWeGf9IDqYi1dQ3iAXttaRxQ=;
        b=ZMPPf3+1chNWH0T1bV3BytvD2DOf/nIl9gmKni7SGvsx4YxyMYOU9pc5AJVXTEy8G0
         YaR9kUOH620wHRtpq/PZp8sT+/BW8EHzP2NxVjHbotUfjAVEcxsLFD1oFeLCSXnupOui
         2OqcQO9Uc3p1Jj8w3UF2IlsV0kqaBPdgNf3VHWxsp8fycpWyehSDwzIJ7Qe3DpEHsc3V
         YfNZYQT/y7gUBFhC8SiHLgUTqzrBwyL9bTyx7YzduafYB6I52R02gxAz+EQTfrMYxFk+
         jRh6E6ai3RyJMgE7klbU46Mu5jfWMczgppex/vpezg+TAOKu4+pdPgMpwDjg9VM7XCBe
         E6Zg==
X-Gm-Message-State: ABy/qLZYvAUTqZT+D7sja/f9eFbeSfW15wGFWDDmvIxfw50SvafL7HvE
	FEt2+yBVHS3L+dB6SyARrl3ENz07XiaD2GAMdf0H7QU3OKcnzAb1wO/LoXrr/5ouF5+zVkaGauw
	/mJw8UIPRK1fTI1XN
X-Received: by 2002:a05:6a00:190d:b0:66c:9faa:bb12 with SMTP id y13-20020a056a00190d00b0066c9faabb12mr16704405pfi.9.1688517108919;
        Tue, 04 Jul 2023 17:31:48 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEmfNfMPx/IrkAMqhqCvq3CBwACnFQn2OpL7OQ5Txr79ZB/+akox9sOla+QB1fZL69N2wqqhQ==
X-Received: by 2002:a05:6a00:190d:b0:66c:9faa:bb12 with SMTP id y13-20020a056a00190d00b0066c9faabb12mr16704398pfi.9.1688517108632;
        Tue, 04 Jul 2023 17:31:48 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id c184-20020a624ec1000000b00658670ebe7dsm6105353pfb.119.2023.07.04.17.31.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 17:31:47 -0700 (PDT)
Message-ID: <1fe280a7-0f10-e124-00aa-b137df722c33@redhat.com>
Date: Wed, 5 Jul 2023 10:31:37 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RESEND PATCH v5 07/11] KVM: arm64: Define
 kvm_tlb_flush_vmid_range()
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
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20230621175002.2832640-1-rananta@google.com>
 <20230621175002.2832640-8-rananta@google.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230621175002.2832640-8-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 6/22/23 03:49, Raghavendra Rao Ananta wrote:
> Implement the helper kvm_tlb_flush_vmid_range() that acts
> as a wrapper for range-based TLB invalidations. For the
> given VMID, use the range-based TLBI instructions to do
> the job or fallback to invalidating all the TLB entries.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>   arch/arm64/include/asm/kvm_pgtable.h | 10 ++++++++++
>   arch/arm64/kvm/hyp/pgtable.c         | 20 ++++++++++++++++++++
>   2 files changed, 30 insertions(+)
> 

It may be reasonable to fold this to PATCH[08/11] since kvm_tlb_flush_vmid_range() is
only called by ARM64's kvm_arch_flush_remote_tlbs_range(), which is added by PATCH[08/11].
In either way, the changes look good to me:

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
> index 4cd6762bda805..1b12295a83595 100644
> --- a/arch/arm64/include/asm/kvm_pgtable.h
> +++ b/arch/arm64/include/asm/kvm_pgtable.h
> @@ -682,4 +682,14 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte);
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
> index 3d61bd3e591d2..df8ac14d9d3d4 100644
> --- a/arch/arm64/kvm/hyp/pgtable.c
> +++ b/arch/arm64/kvm/hyp/pgtable.c
> @@ -631,6 +631,26 @@ static bool stage2_has_fwb(struct kvm_pgtable *pgt)
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

Thanks,
Gavin

