Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B783A52
	for <kvmarm@lists.linux.dev>; Wed,  9 Aug 2023 04:10:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691554227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tiZt5qkV373iiZscCJbcFROPFCou/fOb43yGS5e3+0c=;
	b=HDllo3iOgXbZQaKB65XgmtuKQrZk5PCnQT9LyKSGjMp9A1lS2WP+PB5TiZGkCuwCnLJMg3
	4ytHLn2djqM5rdlr0zkzR9t4FMPQPe06npve5/DujH3AoJ0ca2i7xiC0V6YJ2+5Cmc1NDc
	Bu7FMLpbWXzESnrc4Dq6+NFcsNRdrKc=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-609-6b1R_yzSMgOJY0VR-Wzlog-1; Wed, 09 Aug 2023 00:10:26 -0400
X-MC-Unique: 6b1R_yzSMgOJY0VR-Wzlog-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-686baf1a407so467213b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 08 Aug 2023 21:10:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691554223; x=1692159023;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tiZt5qkV373iiZscCJbcFROPFCou/fOb43yGS5e3+0c=;
        b=CAa1u/SWAqjgyQ4wc3u9YC39v96alOe6/xlftKftX+Q4iVUs0bQu0I7iqPGKh6STSI
         YtAhsFox7cooayIzphCuNCdCxQGC6KpBp+/dTEVn713CTWBjZUvg3BuiNgdUVXyuJkhu
         F19FEuXtBzye41y/HtcDVfNERi8cMqgM4xdwcYPZkSPkyDtKI/ve7ttd7kQUe2ukXduW
         NNQH4BXxORdhK7WTjq3bAF12AsySXHzRjOZHvXcHjcSN4oPGN9uywJBRfLmIn6tqQMrw
         Uv4DvmoAb6k3AP5jlaLurfOixol1knkvzus1FMYJnVH3DN16Nt9hWEXKdwd6SEw+Swb8
         unSQ==
X-Gm-Message-State: AOJu0Yxnf4FNI9R3SaO9VJCDQsYE3Q2tMc9xJw7vpDZXesvE2IlXKP8+
	QgVDwfR3Tw3ZbuIxAVH3g6VNpKOga4ys75kiWhQitsSXKjGv9qrVmSOh7mdiqSjKuC4YzCbs3a2
	Zxbo6xmWBkHMBLq3p
X-Received: by 2002:a05:6a00:1487:b0:666:eaaf:a2af with SMTP id v7-20020a056a00148700b00666eaafa2afmr2263679pfu.14.1691554222963;
        Tue, 08 Aug 2023 21:10:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE4mKNqTgX+EsfCEP/MYW99W9JIOB5kHuLZbEs18DPRnq1dfDRhMLd6YmPemv3TlybaLWWmcQ==
X-Received: by 2002:a05:6a00:1487:b0:666:eaaf:a2af with SMTP id v7-20020a056a00148700b00666eaafa2afmr2263648pfu.14.1691554222702;
        Tue, 08 Aug 2023 21:10:22 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id p26-20020a62ab1a000000b006871fdde2c7sm8840727pff.110.2023.08.08.21.10.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Aug 2023 21:10:22 -0700 (PDT)
Message-ID: <b91d1869-3a1d-d9eb-27b0-0aac94cca8e0@redhat.com>
Date: Wed, 9 Aug 2023 14:10:12 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v8 03/14] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
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
 <20230808231330.3855936-4-rananta@google.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230808231330.3855936-4-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 8/9/23 09:13, Raghavendra Rao Ananta wrote:
> Stop depending on CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL and opt to
> standardize on kvm_arch_flush_remote_tlbs() since it avoids
> duplicating the generic TLB stats across architectures that implement
> their own remote TLB flush.
> 
> This adds an extra function call to the ARM64 kvm_flush_remote_tlbs()
> path, but that is a small cost in comparison to flushing remote TLBs.
> 
> In addition, instead of just incrementing remote_tlb_flush_requests
> stat, the generic interface would also increment the
> remote_tlb_flush stat.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 2 ++
>   arch/arm64/kvm/Kconfig            | 1 -
>   arch/arm64/kvm/mmu.c              | 6 +++---
>   3 files changed, 5 insertions(+), 4 deletions(-)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 8b6096753740c..20f2ba149c70c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1111,6 +1111,8 @@ int __init kvm_set_ipa_limit(void);
>   #define __KVM_HAVE_ARCH_VM_ALLOC
>   struct kvm *kvm_arch_alloc_vm(void);
>   
> +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> +
>   static inline bool kvm_vm_is_protected(struct kvm *kvm)
>   {
>   	return false;
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index f531da6b362e9..6b730fcfee379 100644
> --- a/arch/arm64/kvm/Kconfig
> +++ b/arch/arm64/kvm/Kconfig
> @@ -25,7 +25,6 @@ menuconfig KVM
>   	select MMU_NOTIFIER
>   	select PREEMPT_NOTIFIERS
>   	select HAVE_KVM_CPU_RELAX_INTERCEPT
> -	select HAVE_KVM_ARCH_TLB_FLUSH_ALL
>   	select KVM_MMIO
>   	select KVM_GENERIC_DIRTYLOG_READ_PROTECT
>   	select KVM_XFER_TO_GUEST_WORK
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 6db9ef288ec38..0ac721fa27f18 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -161,15 +161,15 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
>   }
>   
>   /**
> - * kvm_flush_remote_tlbs() - flush all VM TLB entries for v7/8
> + * kvm_arch_flush_remote_tlbs() - flush all VM TLB entries for v7/8
>    * @kvm:	pointer to kvm structure.
>    *
>    * Interface to HYP function to flush all VM TLB entries
>    */
> -void kvm_flush_remote_tlbs(struct kvm *kvm)
> +int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>   {
> -	++kvm->stat.generic.remote_tlb_flush_requests;
>   	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
> +	return 0;
>   }
>   
>   static bool kvm_is_device_pfn(unsigned long pfn)

