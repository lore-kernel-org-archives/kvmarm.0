Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFA046BD
	for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 09:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690189996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=//aPJH4zrPdTDxzMzJs7UJ4GFjBaI2aqgPX71P6a5dg=;
	b=X1KjHS83ouiUHOnmHS7PPccqlD7fV/v1VvUmUGumpnmpp7jJLt9QFhFYjXV1Xm2wy+DUYe
	2V7monuQBI9+Z+6kuErNYx09sYMB1SyIIS8HH8ayptnOXl7Dgk3hnVssT/hiu+FhVsx32z
	jBOwZOCL9L39AcvZcOj6XRgoDHBv/x8=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-471-fdHREZaCO2aQzR-ogaqPaQ-1; Mon, 24 Jul 2023 05:13:15 -0400
X-MC-Unique: fdHREZaCO2aQzR-ogaqPaQ-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-26801e9bcdaso439050a91.1
        for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 02:13:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690189992; x=1690794792;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=//aPJH4zrPdTDxzMzJs7UJ4GFjBaI2aqgPX71P6a5dg=;
        b=HG1bW7yttC2A5x5VDr3GzayuWbLN6+q9m/RPzoITaWoeP3ZT8q92FExlwPYHatZHjs
         Rcqn97IRMm9Mq2NP05wk/zss6MbW7YeLltiQVVA3YGbI5gFCNu9dHQYRVks8BeEXFzR4
         EgRjE2+H6ZRqKvjjM8eNWOwsmQwKd55RNnmlA94XxU0s8H4HBJf3BSJxhkHIFZ5aXON+
         MXWsLyMXIPd86qhcjkIenZhzINZo8IS9I+yn0VMbHiucZUWRKIvU5XBBQgZFAeK4396Z
         h05Il6fd8tD+3s1NFse9cMGG48R6xOIRvorqsH3tqEbTD7QZt1Qr1pjCib5QjpsDgmxC
         j1Uw==
X-Gm-Message-State: ABy/qLaHIeEUcdaVmRMLty9cOyAINOKBQEHAlci2NvPxpsAQfjKf5PgI
	WYCeXDvKKTxOO1JD8dIFr+iTF15UaOWPqks//ZeTiK5zCjhILcP5v34FI4LhsxYE3j2adWgaE10
	yPd/LzSXBnhQ1QaTJ
X-Received: by 2002:a17:902:ce92:b0:1b8:1591:9f81 with SMTP id f18-20020a170902ce9200b001b815919f81mr12102520plg.4.1690189992429;
        Mon, 24 Jul 2023 02:13:12 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFYYex+PeZplrxlN0jNWs984ysaSZQSKu+vtitozLwa1hyTQD6SfImYNcNMAys3P7/0AANuTw==
X-Received: by 2002:a17:902:ce92:b0:1b8:1591:9f81 with SMTP id f18-20020a170902ce9200b001b815919f81mr12102507plg.4.1690189992175;
        Mon, 24 Jul 2023 02:13:12 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w7-20020a170902e88700b001b06c106844sm8389140plg.151.2023.07.24.02.13.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 02:13:11 -0700 (PDT)
Message-ID: <bab509a1-5096-4ca0-e043-898d941e200a@redhat.com>
Date: Mon, 24 Jul 2023 17:13:06 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 02/12] KVM: arm64: Use kvm_arch_flush_remote_tlbs()
To: Raghavendra Rao Ananta <rananta@google.com>,
 Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Huacai Chen
 <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>,
 Colton Lewis <coltonlewis@google.com>, David Matlack <dmatlack@google.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
 linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
 kvm@vger.kernel.org
References: <20230722022251.3446223-1-rananta@google.com>
 <20230722022251.3446223-3-rananta@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230722022251.3446223-3-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/22/23 10:22, Raghavendra Rao Ananta wrote:
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
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 3 +++
>   arch/arm64/kvm/Kconfig            | 1 -
>   arch/arm64/kvm/mmu.c              | 6 +++---
>   3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 8b6096753740..7281222f24ef 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1111,6 +1111,9 @@ int __init kvm_set_ipa_limit(void);
>   #define __KVM_HAVE_ARCH_VM_ALLOC
>   struct kvm *kvm_arch_alloc_vm(void);
>   
> +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> +int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
> +
>   static inline bool kvm_vm_is_protected(struct kvm *kvm)
>   {
>   	return false;
> diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
> index f531da6b362e..6b730fcfee37 100644
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
> index 6db9ef288ec3..0ac721fa27f1 100644
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

-- 
Shaoqin

