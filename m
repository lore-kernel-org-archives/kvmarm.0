Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563F71FD8
	for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 11:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689678942;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BqFBTcreB9uM7bVA+oKgdwOheFXwxzAShQOYP1vaHLs=;
	b=UoJkDCTCW3UbiMxhNVm7orufGMKqQxto60k8XmQ6T3l3WIMdcoid0v25kanO0d9DeMIlR6
	P/3NaRf6S0R59TyKYGHGnpdMI+o4AABukG080M3tH08A8oh6uiJX7mhaOmMblCSIVwClRB
	Chl+DOesqjiQ8nnB5d6vsPNhmdT89Ss=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-492-SUoTvYg_POuNsBWyzmIJeg-1; Tue, 18 Jul 2023 07:15:40 -0400
X-MC-Unique: SUoTvYg_POuNsBWyzmIJeg-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-66d7911409dso422446b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 18 Jul 2023 04:15:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689678940; x=1690283740;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=BqFBTcreB9uM7bVA+oKgdwOheFXwxzAShQOYP1vaHLs=;
        b=abeNfdzgULRbhgu0c92MAzcP+7wacCegj3xl2JqI4JBsg9RqKRfZQFDyi5Esvg7RxA
         cOQHSmEhPJXgf3JrH6jlqVHrutfMJOwMx73jYkN0BeBWADmfJiq4NHDNatZSDK1JGX4u
         REEx70FSEQBzY9Us97iN/y1PIzmybpglKk3Nks2e2s9a9bZy3XWJDEMsRzDdSfYbGqgR
         yjizeAk0xswPKoND4eI5aHetJQHo3M9Z46PjgtZYQUQj57teZQtekx0ZsjJkGjGsbsyq
         90wFWFWd9sdS8JAOPsUdSH95cdTacOCcj8fs1DrWREHvO3cASegfaqMnndZTDhlMoecx
         9VBQ==
X-Gm-Message-State: ABy/qLZNpCuArzY5szU+OG0vZxSETyTBF9vGbLk4GrI5ezHkck0o/mJH
	nk64tlgYBPuar57OKnQHt/zObumwyfv7vxE736ZeJUbqAvUFIaYXbgSnI0YJWR7In8KpEKhl7ao
	+Z2yTNjokZKyJYHGX
X-Received: by 2002:a05:6a00:2d06:b0:679:a1f1:a5f8 with SMTP id fa6-20020a056a002d0600b00679a1f1a5f8mr11345527pfb.3.1689678939736;
        Tue, 18 Jul 2023 04:15:39 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEpw9FbepMwI4i8WQLrfFCcRWK4bQzZOcI8bUuVzeTHVwddSiiqvjUkmkgPmHYZSjCF3HQUxg==
X-Received: by 2002:a05:6a00:2d06:b0:679:a1f1:a5f8 with SMTP id fa6-20020a056a002d0600b00679a1f1a5f8mr11345498pfb.3.1689678939458;
        Tue, 18 Jul 2023 04:15:39 -0700 (PDT)
Received: from [10.72.112.40] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s1-20020a63af41000000b00528db73ed70sm1476638pgo.3.2023.07.18.04.15.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Jul 2023 04:15:39 -0700 (PDT)
Message-ID: <5b2c03a5-5887-d951-6c3d-f71b49e683fc@redhat.com>
Date: Tue, 18 Jul 2023 19:15:32 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v6 08/11] KVM: arm64: Implement
 kvm_arch_flush_remote_tlbs_range()
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
 <20230715005405.3689586-9-rananta@google.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <20230715005405.3689586-9-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 7/15/23 08:54, Raghavendra Rao Ananta wrote:
> Implement kvm_arch_flush_remote_tlbs_range() for arm64
> to invalidate the given range in the TLB.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Shaoqin Huang <shahuang@redhat.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 3 +++
>   arch/arm64/kvm/mmu.c              | 7 +++++++
>   2 files changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 7281222f24ef..52d3ed918893 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1114,6 +1114,9 @@ struct kvm *kvm_arch_alloc_vm(void);
>   #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
>   int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
>   
> +#define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS_RANGE
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages);
> +
>   static inline bool kvm_vm_is_protected(struct kvm *kvm)
>   {
>   	return false;
> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
> index 0ac721fa27f1..387f2215fde7 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -172,6 +172,13 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>   	return 0;
>   }
>   
> +int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm, gfn_t start_gfn, u64 pages)
> +{
> +	kvm_tlb_flush_vmid_range(&kvm->arch.mmu,
> +				start_gfn << PAGE_SHIFT, pages << PAGE_SHIFT);
> +	return 0;
> +}
> +
>   static bool kvm_is_device_pfn(unsigned long pfn)
>   {
>   	return !pfn_is_map_memory(pfn);

-- 
Shaoqin

