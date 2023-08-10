Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9097442C
	for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 12:26:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1691670379;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mnvMtwrO+HlpCnGD+Ie1TBrDV8keaKNA7WfaJ+XMfts=;
	b=PThITPCV91zKh135syv7wW8rJbf8dZOP8YA3duXGMz/cGQH8wLsvzIULnY53qbPxfYXAQ4
	VbCReSC32+VDIcQWUIeF+V0aIFbQriTeuTyVDPVt+ABPz+SA91wJ2dQRZahBwukOb1lYe5
	HdWHv+GMM4J9VHpzP/dIjUtP0t90SRU=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-360-35W2KsZyPhKo7cBESax7eA-1; Thu, 10 Aug 2023 08:26:18 -0400
X-MC-Unique: 35W2KsZyPhKo7cBESax7eA-1
Received: by mail-pf1-f199.google.com with SMTP id d2e1a72fcca58-6871900d991so189276b3a.1
        for <kvmarm@lists.linux.dev>; Thu, 10 Aug 2023 05:26:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691670377; x=1692275177;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mnvMtwrO+HlpCnGD+Ie1TBrDV8keaKNA7WfaJ+XMfts=;
        b=eBy7BQuRLbMTc+wMxXmDTEGvk/vUp1WT4XSVufl7J0OKKRhPwbnNwqapc/yM9Rv1Hq
         Cy19++kB/GjN7s+zedNt8BfweLfe2fxODO3GPvxXi8bKR9e079J1J3e7C1xkG9olPiqk
         aIwKKnH4HOf/QEWHdX7yQyfAc2YCWXbCn1+zf+Rg4lrRHd+BNz5r916V14rV+3x4EFbi
         XyXuVPf+8KKoq6XKZGE8J+0eYRQvibQG/BaogqckGNsERIBdZw240YUvSKHzJJmQIOQc
         N2lQyapFqEUiE3gBE1o+JW6F/v7oidsYKCuc9GwhiwlP8baYA7LtF7d55W7d05n2ejTI
         hAmg==
X-Gm-Message-State: AOJu0YzCryPUM2rSUMKM/T9U7cG+t9al1tRv/LXEiRsg5G9UpGHkZhlG
	+JhfNqrHK00JltIlXJQ4ODZWq/+0Rf6NmlsjGBufsvPYEw/U4PLRH+Mtjo502mcevDVc2GHCAYD
	c0N3LpIoctShlHBto
X-Received: by 2002:a05:6a00:d96:b0:687:874c:7ce0 with SMTP id bf22-20020a056a000d9600b00687874c7ce0mr2463248pfb.1.1691670377123;
        Thu, 10 Aug 2023 05:26:17 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFbuLOrMlEpRqBni5bZEXHe0+/YLy2srme8Tcb0EpGLk+ZLZKJl+h1qsrD5Yo9JHMcHNLUrCg==
X-Received: by 2002:a05:6a00:d96:b0:687:874c:7ce0 with SMTP id bf22-20020a056a000d9600b00687874c7ce0mr2463218pfb.1.1691670376757;
        Thu, 10 Aug 2023 05:26:16 -0700 (PDT)
Received: from [10.72.112.92] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s11-20020aa78d4b000000b006878f50d071sm1393686pfe.203.2023.08.10.05.26.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 05:26:16 -0700 (PDT)
Message-ID: <30e45ef3-309a-63de-e085-be1645c1be79@redhat.com>
Date: Thu, 10 Aug 2023 20:26:09 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v8 02/14] KVM: Declare kvm_arch_flush_remote_tlbs()
 globally
To: Raghavendra Rao Ananta <rananta@google.com>, Gavin Shan <gshan@redhat.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Huacai Chen
 <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Jing Zhang <jingzhangos@google.com>, Reiji Watanabe <reijiw@google.com>,
 Colton Lewis <coltonlewis@google.com>, David Matlack <dmatlack@google.com>,
 Fuad Tabba <tabba@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20230808231330.3855936-1-rananta@google.com>
 <20230808231330.3855936-3-rananta@google.com>
 <c33b0518-6e64-7acf-efa8-f404fce1ccac@redhat.com>
 <CAJHc60yCJANBQOizaoSPhEJH9e8a9C6n68x4qdVkOhVZiiWqkw@mail.gmail.com>
From: Shaoqin Huang <shahuang@redhat.com>
In-Reply-To: <CAJHc60yCJANBQOizaoSPhEJH9e8a9C6n68x4qdVkOhVZiiWqkw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 8/10/23 00:38, Raghavendra Rao Ananta wrote:
> Hi Gavin,
> 
> On Tue, Aug 8, 2023 at 9:00 PM Gavin Shan <gshan@redhat.com> wrote:
>>
>>
>> On 8/9/23 09:13, Raghavendra Rao Ananta wrote:
>>> There's no reason for the architectures to declare
>>> kvm_arch_flush_remote_tlbs() in their own headers. Hence to
>>> avoid this duplication, make the declaration global, leaving
>>> the architectures to define only __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
>>> as needed.
>>>
>>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
>>> ---
>>>    arch/mips/include/asm/kvm_host.h | 1 -
>>>    include/linux/kvm_host.h         | 2 ++
>>>    2 files changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/mips/include/asm/kvm_host.h b/arch/mips/include/asm/kvm_host.h
>>> index 9b0ad8f3bf327..54a85f1d4f2c8 100644
>>> --- a/arch/mips/include/asm/kvm_host.h
>>> +++ b/arch/mips/include/asm/kvm_host.h
>>> @@ -897,6 +897,5 @@ static inline void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu) {}
>>>    static inline void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu) {}
>>>
>>>    #define __KVM_HAVE_ARCH_FLUSH_REMOTE_TLBS
>>> -int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
>>>
>>>    #endif /* __MIPS_KVM_HOST_H__ */
>>> diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
>>> index e3f968b38ae97..ade5d4500c2ce 100644
>>> --- a/include/linux/kvm_host.h
>>> +++ b/include/linux/kvm_host.h
>>> @@ -1484,6 +1484,8 @@ static inline int kvm_arch_flush_remote_tlbs(struct kvm *kvm)
>>>    {
>>>        return -ENOTSUPP;
>>>    }
>>> +#else
>>> +int kvm_arch_flush_remote_tlbs(struct kvm *kvm);
>>>    #endif
>>>
>>>    #ifdef __KVM_HAVE_ARCH_NONCOHERENT_DMA
>>
>> Is the declaration inconsistent to that in arch/x86/include/asm/kvm_host.h?
>> In order to keep them consistent, I guess we need move kvm_arch_flush_remote_tlbs()
>> from x86's header file to arch/x86/kvm/mmu/mmu.c and 'inline' needs to be dropped.
>>
> Unsure of the original intentions, I didn't want to disturb any
> existing arrangements. If more people agree to this refactoring, I'm
> happy to move.

This is amazing to me. This change can be compiled without any error 
even if the declaration inconsistent between the kvm_host.h and x86's 
header file.

I'm curious which option make it possible?

Thanks,
Shaoqin

> 
> Thank you.
> Raghavendra
>> Thanks,
>> Gavin
>>
> 

-- 
Shaoqin

