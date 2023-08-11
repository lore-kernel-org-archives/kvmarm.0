Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070E0A3D
	for <kvmarm@lists.linux.dev>; Fri, 11 Aug 2023 03:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691723039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1DMrZ/cVVx9oJnb2z2JJ4WKVaGEEQv2IXABVTFJ5wRQ=;
	b=eViK7cmuXm7qapoTxs6HXXdJUQhVUf3IG+2xlSwJoNIYd1q9QtxUE8VjCkxlsVaWY5w+Z4
	nwgEE4MIyp4EVuwoUI+LiXKj7A03U3Eo5AhQXPIdK7En3GUGRUEx7AJl/v9w6N8vsFs3Bm
	G9OiwS79Kov8mJFII5i6icfZn10Ni2Y=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-88-JQGcFZUoMPmOGkc-NskaPA-1; Thu, 10 Aug 2023 23:03:58 -0400
X-MC-Unique: JQGcFZUoMPmOGkc-NskaPA-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-56561aaaeeeso234319a12.0
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 20:03:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691723037; x=1692327837;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1DMrZ/cVVx9oJnb2z2JJ4WKVaGEEQv2IXABVTFJ5wRQ=;
        b=O+kdxMJc1IgsA+yh3/FtBpRUmDVX7Wrs1YIcHbADO9c/S1dNYP3FsJ58d/xYgUStn9
         6kE9zgGcY2tfRxxT3HOknxCz9S3VziYRM2Sd3y7U3ZOF8cn+Gmg79PqSqfhl/BbHeLYU
         MqbQSMzyLl1zhAegwuF9ooTnh9NZQGoadw2aZbKBQaNnXIgzHo5NNVJAUb8CMu2cjqzL
         GIVqAIF49geDUI4CeSTlAt0F5mHaXE8wpxEhiu/n1sHCjtForeKBUi86kB5MODE5Hg7h
         X+PiwHP1G0czFPeB4B5bBT6ExthyfXrzd936hyuDc23yCdZCji2GVjYY0KWQP+BhpupM
         uw6w==
X-Gm-Message-State: AOJu0YyFDEFfEcz+fSwZwZ1pbtK9pbbO6padjt9STSn6sB0eu+07/lF1
	IfOEPPLkynjPJHkB9JJ/H1bx0xOKK/i5nW8i+P+QFLsSAelzB9nULmNfvCTjgVsHKKdj3KQVUUg
	9QBNDDvdLjhKAmzVz
X-Received: by 2002:a05:6a21:6d88:b0:13a:3649:dc1a with SMTP id wl8-20020a056a216d8800b0013a3649dc1amr1316463pzb.0.1691723036990;
        Thu, 10 Aug 2023 20:03:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENpkl1RL6Mkjeuk83qmopiO791ccRF4dSFjJzHpK+/MQLjdG2TJSO7XFsP6XAreIKgXCzHJg==
X-Received: by 2002:a05:6a21:6d88:b0:13a:3649:dc1a with SMTP id wl8-20020a056a216d8800b0013a3649dc1amr1316435pzb.0.1691723036603;
        Thu, 10 Aug 2023 20:03:56 -0700 (PDT)
Received: from [10.72.112.92] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id y15-20020a637d0f000000b00553d42a7cb5sm2239376pgc.68.2023.08.10.20.03.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 20:03:56 -0700 (PDT)
Message-ID: <d03b0f1f-2bd6-fc23-2d7a-ddb36eba93cf@redhat.com>
Date: Fri, 11 Aug 2023 11:03:45 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 11/14] KVM: arm64: Implement
 kvm_arch_flush_remote_tlbs_range()
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
 Gavin Shan <gshan@redhat.com>
References: <20230808231330.3855936-1-rananta@google.com>
 <20230808231330.3855936-12-rananta@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230808231330.3855936-12-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 8/9/23 07:13, Raghavendra Rao Ananta wrote:
> Implement kvm_arch_flush_remote_tlbs_range() for arm64
> to invalidate the given range in the TLB.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 2 ++
>   arch/arm64/kvm/mmu.c              | 8 ++++++++
>   2 files changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 20f2ba149c70c..8f2d99eaab036 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1113,6 +1113,8 @@ struct kvm *kvm_arch_alloc_vm(void);
>   
>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
>   
> +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> +
>   static inline bool kvm_vm_is_protected(struct kvm *kvm)
>   {
>   	return false;
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 0ac721fa27f18..294078ce16349 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -172,6 +172,14 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>   	return 0;
>   }
>   
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
> +				      gfn_t gfn, u64 nr_pages)
Hi Raghavendra,

As the kernel test robot points out, the parameter `gfn` should change 
to `start_gfn`.

Thanks,
Shaoqin
> +{
> +	kvm_tlb_flush_vmid_range(&kvm->arch.mmu,
> +				start_gfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT);
> +	return 0;
> +}
> +
>   static bool kvm_is_device_pfn(unsigned long pfn)
>   {
>   	return !pfn_is_map_memory(pfn);

-- 
Shaoqin

