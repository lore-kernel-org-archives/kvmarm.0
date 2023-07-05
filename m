Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB7663C
	for <kvmarm@lists.linux.dev>; Wed,  5 Jul 2023 00:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1688517204;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sznGK6ZukwvfWp0A8i4mc61vcYJsrjsNcN47/Lw0qI8=;
	b=Z6l26/zlFF+k+R+BzUS3g2OzE9rayT6I5HEhlUu5OLOpfSgqJZ6AN2bDhXxaHErBligXCp
	ionPQBcbXwY20czdpXNZVwPuqA1Ci53PjV7nhZ9ue2M30OpkRcflPOcQRt7CHS8gut0hI+
	9jUGncE4MNPAzmijPeSqyDRvvXk2kqM=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-627-MfgKBv9nMCW0IF-CtFC7oA-1; Tue, 04 Jul 2023 20:33:23 -0400
X-MC-Unique: MfgKBv9nMCW0IF-CtFC7oA-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-53b9eb7bda0so5955218a12.0
        for <kvmarm@lists.linux.dev>; Tue, 04 Jul 2023 17:33:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688517202; x=1691109202;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sznGK6ZukwvfWp0A8i4mc61vcYJsrjsNcN47/Lw0qI8=;
        b=fyGFFESTQqKUJMMpQr3d1G3HhL7IS1ffkfG9+OarMmAPYxE0NEoUNsS0zyZvCkrCcI
         uOml9+Fd5iKk1OehRf+IaCKZd784mrTPWxldWOc0zO82lDgrNpnAeBsVCouOVDGDaS7f
         YOFyRI2kiDAALmQVLRxG/Ok8JKT+10xmx0UvVUcFu4mzBucZ1o1RLCpku1i/HdTrRUYL
         qbDFTntYu9ynxOYDIIAYMTI+OnDGKfRjswJYC3opTqcq6lDxjZYLBKlI11Z5EdyMF2Wy
         HMEwa7gXOfX3dP4h5fyvWmR5JTL/Iu7bHMCJtlV6J4KGhvij11J6i+HdmgWtnpwWg3W8
         wYBg==
X-Gm-Message-State: ABy/qLbKcJMq+6PgdQMtek1IY2p8Nr1zM18Bd4VZ3QUxTovJr4XDe7br
	xYA4UF0e3eyvTsQuBol8Lk7PRrge5NIFOGfELtc3YBKugwECYg29xUX1e5wQVOGMQpvFdKoC0Rl
	Fghwz3eSUZc+7pcg1
X-Received: by 2002:a05:6a20:1601:b0:12f:4d11:5f74 with SMTP id l1-20020a056a20160100b0012f4d115f74mr2599854pzj.58.1688517202490;
        Tue, 04 Jul 2023 17:33:22 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFvypcLwb/KPkwH9ar4hG3nsZmNacj2rbML5ruL00tj8y35B6pCwD/DI8RaK0glisLwI/suTQ==
X-Received: by 2002:a05:6a20:1601:b0:12f:4d11:5f74 with SMTP id l1-20020a056a20160100b0012f4d115f74mr2599827pzj.58.1688517202196;
        Tue, 04 Jul 2023 17:33:22 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id q3-20020a17090311c300b001ac897026cesm17766726plh.102.2023.07.04.17.33.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jul 2023 17:33:21 -0700 (PDT)
Message-ID: <6b8dd9cd-784c-b9e1-73de-6c84deba9426@redhat.com>
Date: Wed, 5 Jul 2023 10:33:12 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RESEND PATCH v5 08/11] KVM: arm64: Implement
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
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20230621175002.2832640-1-rananta@google.com>
 <20230621175002.2832640-9-rananta@google.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <20230621175002.2832640-9-rananta@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/22/23 03:49, Raghavendra Rao Ananta wrote:
> Implement kvm_arch_flush_remote_tlbs_range() for arm64
> to invalidate the given range in the TLB.
> 
> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
> ---
>   arch/arm64/include/asm/kvm_host.h | 3 +++
>   arch/arm64/kvm/mmu.c              | 7 +++++++
>   2 files changed, 10 insertions(+)
> 

Reviewed-by: Gavin Shan <gshan@redhat.com>

> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> index 81ab41b84f436..343fb530eea9c 100644
> --- a/arch/arm64/include/asm/kvm_host.h
> +++ b/arch/arm64/include/asm/kvm_host.h
> @@ -1081,6 +1081,9 @@ struct kvm *kvm_arch_alloc_vm(void);
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
> index d0a0d3dca9316..c3ec2141c3284 100644
> --- a/arch/arm64/kvm/mmu.c
> +++ b/arch/arm64/kvm/mmu.c
> @@ -92,6 +92,13 @@ int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
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

