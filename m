Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED03A1FB3
	for <kvmarm@lists.linux.dev>; Fri,  3 Mar 2023 09:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1677834896;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Wnl4G7Xh5CvB+FtHVG1C7RoK/+CAnEZD+17PHCsomsk=;
	b=IBal91mUAkBecgzFePuPfdPTjmB6xIEUl90ypArl/vFSJTj4NMVMsDAhJYM2pqzfxMVCCw
	lwOBUTirI0AXLkd871h/H05nErJNmAcVRIuMmt00gy+wNwwtpmfMCFqlse9PxmV046pX9A
	4ZZDR0gqTy3LFl6KV3iA4M8JA1z+++U=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-453-3oEEWwoWMKu6NLLy0Lv-0A-1; Fri, 03 Mar 2023 04:14:56 -0500
X-MC-Unique: 3oEEWwoWMKu6NLLy0Lv-0A-1
Received: by mail-qt1-f198.google.com with SMTP id z1-20020ac87ca1000000b003ba2a2c50f9so1110707qtv.23
        for <kvmarm@lists.linux.dev>; Fri, 03 Mar 2023 01:14:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677834895;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wnl4G7Xh5CvB+FtHVG1C7RoK/+CAnEZD+17PHCsomsk=;
        b=mAnmQpGHziBqzIGtvq02uQneLSf8WgMr/UigsHKO4RFooa48mGrHpoE/xExKxWaTOU
         xvwh2BdP61RrC3i3b3M4TyAqhylqgWVeVaD/q/Le5H20FG+7iuWcwRrONF6sTly3AQ/z
         pfiYRmuOohNkKMF4jjYzdiRC0/F0BIqVSQgsax/JP2UYB1F34mijM1ifOG/sxMVYyJMC
         rlP84rvkLUKI5x2a/cibIRKwm33GHftsFE+SqCvyZdQ1nuhoRDtp2qz8IwFlYDc2Of0A
         C/PklriuAHUGiD8L0KI1sF2k+Sr7tbrwF9K/m6Fhe1hoc+gLssHISEniEJCDfyq32RZM
         IQ8g==
X-Gm-Message-State: AO0yUKUa2fAuBnMQS1hrz5MEXSTuC07P2DyMQaFJUiO+/WRylCQvOR+R
	VzmPz6CenE2kXNf2zjExdDjgNDSOeui0rJEa0E/n6xShFJFd9fwJuqtA3BYsaIBh+jSXh3sa/Es
	5lFAKFSUASglTWBuF
X-Received: by 2002:a0c:f252:0:b0:56e:89b9:9a92 with SMTP id z18-20020a0cf252000000b0056e89b99a92mr1677884qvl.0.1677834895603;
        Fri, 03 Mar 2023 01:14:55 -0800 (PST)
X-Google-Smtp-Source: AK7set8Oon3JEryPmpvkzn4BXeyH+owWGVq0cEzAlMUQ2IC/xiSsTl75uAXSBNWx0LttYq51PFDSXQ==
X-Received: by 2002:a0c:f252:0:b0:56e:89b9:9a92 with SMTP id z18-20020a0cf252000000b0056e89b99a92mr1677844qvl.0.1677834895127;
        Fri, 03 Mar 2023 01:14:55 -0800 (PST)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d11-20020a05620a158b00b0073b8745fd39sm1323195qkk.110.2023.03.03.01.14.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Mar 2023 01:14:54 -0800 (PST)
Message-ID: <78db9523-880c-2899-2cee-a07dc9b8f282@redhat.com>
Date: Fri, 3 Mar 2023 17:14:47 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v5 06/12] KVM: arm64: Add kvm_uninit_stage2_mmu()
To: Ricardo Koller <ricarkol@google.com>, pbonzini@redhat.com,
 maz@kernel.org, oupton@google.com, yuzenghui@huawei.com, dmatlack@google.com
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, qperret@google.com,
 catalin.marinas@arm.com, andrew.jones@linux.dev, seanjc@google.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, eric.auger@redhat.com,
 gshan@redhat.com, reijiw@google.com, rananta@google.com, bgardon@google.com,
 ricarkol@gmail.com
References: <20230301210928.565562-1-ricarkol@google.com>
 <20230301210928.565562-7-ricarkol@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230301210928.565562-7-ricarkol@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/2/23 05:09, Ricardo Koller wrote:
> Add kvm_uninit_stage2_mmu() and move kvm_free_stage2_pgd() into it. A
> future commit will add some more things to do inside of
> kvm_uninit_stage2_mmu().
> 
> No functional change intended.
> 
> Signed-off-by: Ricardo Koller <ricarkol@google.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_mmu.h | 1 +
>   arch/arm64/kvm/mmu.c             | 7 ++++++-
>   2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
> index e4a7e6369499..058f3ae5bc26 100644
> --- a/arch/arm64/include/asm/kvm_mmu.h
> +++ b/arch/arm64/include/asm/kvm_mmu.h
> @@ -167,6 +167,7 @@ void free_hyp_pgds(void);
>   
>   void stage2_unmap_vm(struct kvm *kvm);
>   int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long type);
> +void kvm_uninit_stage2_mmu(struct kvm *kvm);
>   void kvm_free_stage2_pgd(struct kvm_s2_mmu *mmu);
>   int kvm_phys_addr_ioremap(struct kvm *kvm, phys_addr_t guest_ipa,
>   			  phys_addr_t pa, unsigned long size, bool writable);
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index d2c5e6992459..812633a75e74 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -766,6 +766,11 @@ int kvm_init_stage2_mmu(struct kvm *kvm, struct kvm_s2_mmu *mmu, unsigned long t
>   	return err;
>   }
>   
> +void kvm_uninit_stage2_mmu(struct kvm *kvm)
> +{
> +	kvm_free_stage2_pgd(&kvm->arch.mmu);
> +}
> +
>   static void stage2_unmap_memslot(struct kvm *kvm,
>   				 struct kvm_memory_slot *memslot)
>   {
> @@ -1855,7 +1860,7 @@ void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
>   
>   void kvm_arch_flush_shadow_all(struct kvm *kvm)
>   {
> -	kvm_free_stage2_pgd(&kvm->arch.mmu);
> +	kvm_uninit_stage2_mmu(kvm);
>   }
>   
>   void kvm_arch_flush_shadow_memslot(struct kvm *kvm,

-- 
Shaoqin

