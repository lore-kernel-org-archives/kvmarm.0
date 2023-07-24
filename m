Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311956FA4
	for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 09:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690190036;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2oPDYvwpZtu0Ko50jtkdQDGuMOTIWCRCGf2FetUqVmk=;
	b=YZ6DV5DpqleGOPM8Am+zXQhbfuFPIy8KyrWaeh0uAKadqptjEAokxk2k0RVIRCVJyApolg
	+ldec7BszUhWcU8to0CYPAmFrgYUvHafhsogymOaPT/mnrJeophLLk/w8tft1GP/ZIHOID
	RTGdUlh3UltFkftsxW/QQzV8508f5xU=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-479-H-uX7iDiPa-F5FmjYFTZPw-1; Mon, 24 Jul 2023 05:13:52 -0400
X-MC-Unique: H-uX7iDiPa-F5FmjYFTZPw-1
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-6b9ccd6d236so879079a34.0
        for <kvmarm@lists.linux.dev>; Mon, 24 Jul 2023 02:13:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690190032; x=1690794832;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2oPDYvwpZtu0Ko50jtkdQDGuMOTIWCRCGf2FetUqVmk=;
        b=jRUn1u1tmS2wHiYulWm7T7CBQQqNAlpLxmu/a/5nsc/t9wzJx5aNmTN8tab+pWwXBz
         +17FSaOCboY48uAzslG1svQ3Boz5l/YU/UzZ3o2n7Ft4a88soC++evM3V5HkSvJKOiZv
         6WdQTE5NGBLd5yxY5yZxPDeKh/y9SHgyAuGg42qOAwBlkV3neKECpNKJIs71fwYWIkSk
         L6aFo+2xeWv1i7E4iyAzc4blmBkBWx2Kh1bHtJ9Ze+mrBV3VAL2N+Ju2uMa9hWYMtIAt
         pgGo3xeq6vai1uqgLJlc6LC2Am2x5uuW4N3jc8UOMu2rochfmeBnR3AUh51VnnzxtMIe
         g7Yg==
X-Gm-Message-State: ABy/qLY+LVymZD+yVupPyR4FLvqYAgDdTmy5gs/PR9NgkvFWdGi7UAiV
	iMUHcYPOw5M88wcHMMWM3hQ7EY5KVG8pmXRTCbDIhtEuXWijOM9VBxFsx875pskZe1cRptpEJqe
	xZXjMCT/g6Jqz1+Ez
X-Received: by 2002:a05:6870:568e:b0:1b7:613c:2e30 with SMTP id p14-20020a056870568e00b001b7613c2e30mr7564453oao.2.1690190032052;
        Mon, 24 Jul 2023 02:13:52 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGz31tvB+wfj4JC9JljpAdnVVugjKH/UFomLvpFW9yVXyN8NXs0fQCdMnGqdTxGWM2Ywaca6g==
X-Received: by 2002:a05:6870:568e:b0:1b7:613c:2e30 with SMTP id p14-20020a056870568e00b001b7613c2e30mr7564429oao.2.1690190031838;
        Mon, 24 Jul 2023 02:13:51 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w6-20020a63af06000000b0050f85ef50d1sm7977675pge.26.2023.07.24.02.13.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jul 2023 02:13:51 -0700 (PDT)
Message-ID: <c28915ad-d10c-a5f4-9b95-4ab644139780@redhat.com>
Date: Mon, 24 Jul 2023 17:13:45 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v7 03/12] KVM: Remove CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
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
 <20230722022251.3446223-4-rananta@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230722022251.3446223-4-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/22/23 10:22, Raghavendra Rao Ananta wrote:
> kvm_arch_flush_remote_tlbs() or CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
> are two mechanisms to solve the same problem, allowing
> architecture-specific code to provide a non-IPI implementation of
> remote TLB flushing.
> 
> Dropping CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL allows KVM to standardize
> all architectures on kvm_arch_flush_remote_tlbs() instead of
> maintaining two mechanisms.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   virt/kvm/Kconfig    | 3 ---
>   virt/kvm/kvm_main.c | 2 --
>   2 files changed, 5 deletions(-)
> 
> diff --git a/virt/kvm/Kconfig b/virt/kvm/Kconfig
> index b74916de5183..484d0873061c 100644
> --- a/virt/kvm/Kconfig
> +++ b/virt/kvm/Kconfig
> @@ -62,9 +62,6 @@ config HAVE_KVM_CPU_RELAX_INTERCEPT
>   config KVM_VFIO
>          bool
>   
> -config HAVE_KVM_ARCH_TLB_FLUSH_ALL
> -       bool
> -
>   config HAVE_KVM_INVALID_WAKEUPS
>          bool
>   
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index 70e5479797ac..d6b050786155 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -345,7 +345,6 @@ bool kvm_make_all_cpus_request(struct kvm *kvm, unsigned int req)
>   }
>   EXPORT_SYMBOL_GPL(kvm_make_all_cpus_request);
>   
> -#ifndef CONFIG_HAVE_KVM_ARCH_TLB_FLUSH_ALL
>   void kvm_flush_remote_tlbs(struct kvm *kvm)
>   {
>   	++kvm->stat.generic.remote_tlb_flush_requests;
> @@ -366,7 +365,6 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
>   		++kvm->stat.generic.remote_tlb_flush;
>   }
>   EXPORT_SYMBOL_GPL(kvm_flush_remote_tlbs);
> -#endif
>   
>   static void kvm_flush_shadow_all(struct kvm *kvm)
>   {

-- 
Shaoqin

