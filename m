Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E568879C8
	for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 11:06:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689591987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VGOOqLavhEXg7lyDpvUW6ICkPL0LfcVFnu070bLPGDE=;
	b=ii5CKAXv00BKMVqd4j9IefrnwfGzba4CF0TNt6gS2XU+LL+mwKVZzGH3dFRqwL5S0PxYyh
	PJpd+cTWqt80PIdv9NGkePDmjAVF0XYdDYwHkXx0iglcI+/K38q4az/1xnMOBHDVslFQlj
	ApKpqMMQpAG0av1swU8hvoV7mC7G6ko=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-47-88Aq3WEuP3eVs06THPNANg-1; Mon, 17 Jul 2023 07:06:26 -0400
X-MC-Unique: 88Aq3WEuP3eVs06THPNANg-1
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7672918d8a4so104593785a.0
        for <kvmarm@lists.linux.dev>; Mon, 17 Jul 2023 04:06:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689591986; x=1692183986;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VGOOqLavhEXg7lyDpvUW6ICkPL0LfcVFnu070bLPGDE=;
        b=dP60tsB3swEP7O0iK5tyGwURx8yuuLgzm/Ou2hA022CBTGlcXd0m4u1G+gKX+t2IdZ
         j4USiwtFwcNFsyIVzMnenWO4nj3/PvJ8cIWuiH1SiI0mYB/DkFjCfh7covNXPW0HTm7G
         85pVUgplHbXgzIYrpaKJd7XabWrZDKq0nkQSerIBC8f009gVM/POP/YnRus8E/Uf8/U4
         im3bp4LKxLEeBnjcZ8g7CSEv+qCawu8RKe2DOwIRiq2SRj/Up5RljTMbnJyI4E32E63S
         fRaisR58zM6SWZFtsSCM/k96VAD4tlerslO9031daPbGKSRVc5pDSbt8FRKd9PBdBJ07
         fD6g==
X-Gm-Message-State: ABy/qLavXicB5oCZdqy8fNzqBaegLGG+xc660QTllDcpRwZFK0o+EiMG
	HbD6lU7MfQ9J1Z0KfHX4VJrVG7YtqZe6juWXGYXdEHqG2lqkbyMAnj+dOskfuwXokH37P50ECo4
	6BVp+BCgmqGDVtbfZ
X-Received: by 2002:ad4:4eea:0:b0:634:cdae:9941 with SMTP id dv10-20020ad44eea000000b00634cdae9941mr6281511qvb.0.1689591985901;
        Mon, 17 Jul 2023 04:06:25 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHPP9caNhe5hJZM2GlWhiygfmGOQVyjdcW0NBVwh6GDivJx65xNuv4iB/a90XMh51kWdiueww==
X-Received: by 2002:ad4:4eea:0:b0:634:cdae:9941 with SMTP id dv10-20020ad44eea000000b00634cdae9941mr6281491qvb.0.1689591985670;
        Mon, 17 Jul 2023 04:06:25 -0700 (PDT)
Received: from [10.66.61.39] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id x26-20020a0ca89a000000b00621268e14efsm6363454qva.55.2023.07.17.04.06.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Jul 2023 04:06:25 -0700 (PDT)
Message-ID: <4f465d66-baa3-88bc-86f5-d88cc0a73441@redhat.com>
Date: Mon, 17 Jul 2023 19:06:09 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 01/11] KVM: Rename kvm_arch_flush_remote_tlb() to
 kvm_arch_flush_remote_tlbs()
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
 <20230715005405.3689586-2-rananta@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230715005405.3689586-2-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/15/23 08:53, Raghavendra Rao Ananta wrote:
> From: David Matlack <dmatlack@google.com>
> 
> Rename kvm_arch_flush_remote_tlb() and the associated macro
> __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB to kvm_arch_flush_remote_tlbs() and
> __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS respectively.
> 
> Making the name plural matches kvm_flush_remote_tlbs() and makes it more
> clear that this function can affect more than one remote TLB.
> 
> No functional change intended.
> 
> Signed-off-by: David Matlack <dmatlack@google.com>
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/mips/include/asm/kvm_host.h | 4 ++--
>   arch/mips/kvm/mips.c             | 2 +-
>   arch/x86/include/asm/kvm_host.h  | 4 ++--
>   include/linux/kvm_host.h         | 4 ++--
>   virt/kvm/kvm_main.c              | 2 +-
>   5 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
> index 04cedf9f8811..9b0ad8f3bf32 100644
> --- a/arch/mips/include/asm/kvm_host.h
> +++ b/arch/mips/include/asm/kvm_host.h
> @@ -896,7 +896,7 @@ static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
>   static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>   static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>   
> -#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
> -int kvm_arch_flush_remote_tlb(struct kvm *kvm);
> +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> +int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
>   
>   #endif /* __MIPS_KVM_HOST_H__ */
> diff --git a/arch/mips/kvm/mips.c b/arch/mips/kvm/mips.c
> index aa5583a7b05b..4b7bc39a4173 100644
> --- a/arch/mips/kvm/mips.c
> +++ b/arch/mips/kvm/mips.c
> @@ -981,7 +981,7 @@ void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
>   
>   }
>   
> -int kvm_arch_flush_remote_tlb(struct kvm *kvm)
> +int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>   {
>   	kvm_mips_callbacks->prepare_flush_shadow(kvm);
>   	return 1;
> diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
> index 28bd38303d70..a2d3cfc2eb75 100644
> --- a/arch/x86/include/asm/kvm_host.h
> +++ b/arch/x86/include/asm/kvm_host.h
> @@ -1794,8 +1794,8 @@ static inline struct kvm *kvm_arch_alloc_vm(void)
>   #define __KVM_HAVE_ARCH_VM_FREE
>   void kvm_arch_free_vm(struct kvm *kvm);
>   
> -#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
> -static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
> +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> +static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>   {
>   	if (kvm_x86_ops.flush_remote_tlbs &&
>   	    !static_call(kvm_x86_flush_remote_tlbs)(kvm))
> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
> index 9d3ac7720da9..e3f968b38ae9 100644
> --- a/include/linux/kvm_host.h
> +++ b/include/linux/kvm_host.h
> @@ -1479,8 +1479,8 @@ static inline void kvm_arch_free_vm(struct kvm *kvm)
>   }
>   #endif
>   
> -#ifndef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLB
> -static inline int kvm_arch_flush_remote_tlb(struct kvm *kvm)
> +#ifndef __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
> +static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>   {
>   	return -ENOTSUPP;
>   }
> diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
> index dfbaafbe3a00..70e5479797ac 100644
> --- a/virt/kvm/kvm_main.c
> +++ b/virt/kvm/kvm_main.c
> @@ -361,7 +361,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
>   	 * kvm_make_all_cpus_request() reads vcpu->mode. We reuse that
>   	 * barrier here.
>   	 */
> -	if (!kvm_arch_flush_remote_tlb(kvm)
> +	if (!kvm_arch_flush_remote_tlbs(kvm)
>   	    || kvm_make_all_cpus_request(kvm, KVM_REQ_TLB_FLUSH))
>   		++kvm->stat.generic.remote_tlb_flush;
>   }

-- 
Shaoqin

