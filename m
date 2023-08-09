Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27BD33C3F
	for <kvmarm@lists.linux.dev>; Wed,  9 Aug 2023 06:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691561368;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gjOdGDWIQkT0phMReVz2eflzO/ETttLoRuiht6Bh+vs=;
	b=Ed9vRJ8uLWLmm4uWaIW/w4+TgxMNGICHw9C3jAXwK2rZLZ3UwlRIBmIypRA8N7hpLUoJFQ
	lEHi24Swr2+tCzU56GdtzOeaRR/bxfZOQvtmyC4mgEOwCCXfiMe33MKWCoqjao3Eb6qprh
	XFKlIxL+sWncEuA7baLosqdATP0IbUQ=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-296-f0j7gwYmOmGHhPkAhodadw-1; Wed, 09 Aug 2023 02:09:27 -0400
X-MC-Unique: f0j7gwYmOmGHhPkAhodadw-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-3a5aa4a8fd6so12013021b6e.1
        for <kvmarm@lists.linux.dev>; Tue, 08 Aug 2023 23:09:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691561366; x=1692166166;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gjOdGDWIQkT0phMReVz2eflzO/ETttLoRuiht6Bh+vs=;
        b=ItPeJlZYtYspVZkdsp6p5u6vSOVl+JhK5If1tMBMJCVi3FFrKhnx6fbhQRkdGWDZdE
         QENAjZdQjkPmKM+LkgVLs5YH+/EEab2Zrc4BP79F4gUlL5JDKECk7RfbDkJEVGO6/vrC
         yI/lYTspspZ3SIa31HBqi1l1Sw80DVbpLYSB4PwG96nHfw6ZtEq0gbzXMRSW1iNvBaQL
         3/vQsHXFxt/HETRaYLYZ870EwRaK+C9eGaQ+tm/tvzxue2ASi6f3ufI1xc6g9bah5rjX
         HHYhpDe6VJuatkxedVo3kjBcKM1a3HdGuV03lhIdWOXszZzAkMOKp/Bj2kcOy5kAEzN4
         zp+w==
X-Gm-Message-State: AOJu0Yyz15AAj5C/HcrIvR3EdjbqqU7VZ4yK/kYS9SSu3LMRmiTuUtv/
	EBrauh6vLCQ3BpueYH0irMLXQ4t4XMJTATUL0LD2ZDgLEKRfTX87WObenbhiR3+iNLPOYPwAE1x
	WPkPg1mNdsfwvfc3w
X-Received: by 2002:a05:6808:193:b0:3a6:f7d7:4cfe with SMTP id w19-20020a056808019300b003a6f7d74cfemr1751349oic.50.1691561366665;
        Tue, 08 Aug 2023 23:09:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IESJGy9tTZJCmzlL28vXdcHkH4ZB7FxhBPbIFweRaehSBbS0wZP4I9BPTRIjsuacKEsONJhQQ==
X-Received: by 2002:a05:6808:193:b0:3a6:f7d7:4cfe with SMTP id w19-20020a056808019300b003a6f7d74cfemr1751333oic.50.1691561366353;
        Tue, 08 Aug 2023 23:09:26 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id 30-20020a17090a001e00b002630bfd35b0sm621062pja.7.2023.08.08.23.09.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Aug 2023 23:09:25 -0700 (PDT)
Message-ID: <15975205-6161-d54b-fe40-805a16b0cb27@redhat.com>
Date: Wed, 9 Aug 2023 16:09:15 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v8 05/14] KVM: Allow range-based TLB invalidation from
 common code
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
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
 Shaoqin Huang <shahuang@redhat.com>
References: <20230808231330.3855936-1-rananta@google.com>
 <20230808231330.3855936-6-rananta@google.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230808231330.3855936-6-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/9/23 09:13, Raghavendra Rao Ananta wrote:
> From: David Matlack <dmatlack@google.com>
> 
> Make kvm_flush_remote_tlbs_range() visible in common code and create a
> default implementation that just invalidates the whole TLB.
> 
> This paves the way for several future features/cleanups:
> 
>   - Introduction of range-based TLBI on ARM.
>   - Eliminating kvm_arch_flush_remote_tlbs_memslot()
>   - Moving the KVM/x86 TDP MMU to common code.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> Reviewed-by: Anup Patel <anup@brainfault.org>
> ---
>   arch/x86/include/asm/kvm_host.h |  2 ++
>   arch/x86/kvm/mmu/mmu.c          |  8 ++++----
>   arch/x86/kvm/mmu/mmu_internal.h |  3 ---
>   include/linux/kvm_host.h        | 12 ++++++++++++
>   virt/kvm/kvm_main.c             | 13 +++++++++++++
>   5 files changed, 31 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index a2d3cfc2eb75c..b547d17c58f63 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1804,6 +1804,8 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>   		return -ENOTSUPP;
>   }
>   
> +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> +
>   #define kvm_arch_pmi_in_guest(vcpu) \
>   	((vcpu) && (vcpu)->arch.handling_intr_from_guest)
>   
> diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
> index ec169f5c7dce2..6adbe6c870982 100644
> --- a/arch/x86/kvm/mmu/mmu.c
> +++ b/arch/x86/kvm/mmu/mmu.c
> @@ -278,16 +278,16 @@ static inline bool kvm_available_flush_remote_tlbs_range(void)
>   	return kvm_x86_ops.flush_remote_tlbs_range;
>   }
>   
> -void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
> -				 gfn_t nr_pages)
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
> +				      u64 nr_pages)
>   {
>   	int ret = -EOPNOTSUPP;
>   
>   	if (kvm_x86_ops.flush_remote_tlbs_range)
>   		ret = static_call(kvm_x86_flush_remote_tlbs_range)(kvm, start_gfn,
>   								   nr_pages);
> -	if (ret)
> -		kvm_flush_remote_tlbs(kvm);
> +
> +	return ret;
>   }
>   

I guess @start_gfn can be renamed to @gfn, to be consistent with its declaration
in include/linux/kvm_host.h and struct kvm_x86_ops::flush_remote_tlbs_range()

>   static gfn_t kvm_mmu_page_get_gfn(struct kvm_mmu_page *sp, int index);
> diff --git a/arch/x86/kvm/mmu/mmu_internal.h b/arch/x86/kvm/mmu/mmu_internal.h
> index d39af5639ce97..86cb83bb34804 100644
> --- a/arch/x86/kvm/mmu/mmu_internal.h
> +++ b/arch/x86/kvm/mmu/mmu_internal.h
> @@ -170,9 +170,6 @@ bool kvm_mmu_slot_gfn_write_protect(struct kvm *kvm,
>   				    struct kvm_memory_slot *slot, u64 gfn,
>   				    int min_level);
>   
> -void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn,
> -				 gfn_t nr_pages);
> -
>   /* Flush the given page (huge or not) of guest memory. */
>   static inline void kvm_flush_remote_tlbs_gfn(struct kvm *kvm, gfn_t gfn, int level)
>   {
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index ade5d4500c2ce..f0be5d9c37dd1 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1359,6 +1359,7 @@ int kvm_vcpu_yield_to(struct kvm_vcpu *target);
>   void kvm_vcpu_on_spin(struct kvm_vcpu *vcpu, bool yield_to_kernel_mode);
>   
>   void kvm_flush_remote_tlbs(struct kvm *kvm);
> +void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages);
>   
>   #ifdef KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE
>   int kvm_mmu_topup_memory_cache(struct kvm_mmu_memory_cache *mc, int min);
> @@ -1488,6 +1489,17 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>   int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
>   #endif
>   
> +#ifndef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> +static inline int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
> +						    gfn_t gfn, u64 nr_pages)
> +{
> +	return -EOPNOTSUPP;
> +}
> +#else
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
> +				      gfn_t gfn, u64 nr_pages);
> +#endif
> +
>   #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA
>   void kvm_arch_register_noncoherent_dma(struct kvm *kvm);
>   void kvm_arch_unregister_noncoherent_dma(struct kvm *kvm);
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index d6b0507861550..26e91000f579d 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -366,6 +366,19 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
>   }
>   EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
>   
> +void kvm_flush_remote_tlbs_range(struct kvm *kvm, gfn_t gfn, u64 nr_pages)
> +{
> +	if (!kvm_arch_flush_remote_tlbs_range(kvm, gfn, nr_pages))
> +		return;
> +
> +	/*
> +	 * Fall back to a flushing entire TLBs if the architecture range-based
> +	 * TLB invalidation is unsupported or can't be performed for whatever
> +	 * reason.
> +	 */
> +	kvm_flush_remote_tlbs(kvm);
> +}
> +
>   static void kvm_flush_shadow_all(struct kvm *kvm)
>   {
>   	kvm_arch_flush_shadow_all(kvm);

Thanks,
Gavin

