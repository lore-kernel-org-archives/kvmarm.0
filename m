Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B662736D
	for <kvmarm@lists.linux.dev>; Fri, 14 Jul 2023 01:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1689296548;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RCZyb3R24GuDipQIPDZ95wX4wOQwTE4wykLLz/wfDdA=;
	b=UIdG4MNe07bfTv1OG8hYWIARq0uwzWYCDBzxERFnIp667ozNVxwUyeTPSsue5wE0wXvMfk
	ExFAd0IShA0auZ2c2GlsLfwqlYEGvnRF3iPNLRqlch4H1ipXF3QujtNDaF0Wx4Fn16nFQP
	8J3LuIYB4Fy5HTUXx9BHNu55z2Brzm0=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-610-B-Ui-5biPdyLXTaS0e5Xlw-1; Thu, 13 Jul 2023 21:02:27 -0400
X-MC-Unique: B-Ui-5biPdyLXTaS0e5Xlw-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-265819aa743so943189a91.1
        for <kvmarm@lists.linux.dev>; Thu, 13 Jul 2023 18:02:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689296546; x=1691888546;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RCZyb3R24GuDipQIPDZ95wX4wOQwTE4wykLLz/wfDdA=;
        b=OSjnE2PEdGw0t0tgkIv2C5KIqZ6HNMOwI16EPTp3+Bk9eJ0tBuxzjiOXwEIOKzLgZe
         uw2eruxQZ6+TaYLd/I0ujOYw3UUiTFd//zPjy3bEkXGlxchhVzU5RCUhfhG9xPoeBYxh
         KfKfyK4blzwYcosNty+1GsjxsrOYkUXB1h22L0k6ui3oc7v73mHJprZl7hUebEVUKziY
         ttFcMMwyiPERmoi/sx6aLxPpqk8PeT2Ox4ZZ+jthci+Mh05pNlaZgRyGTe9smOGKt6hQ
         FfuA1mw+8e9+nVSHzGc7O+Ue6BrNcwDIaX3X+lH0+KDznhrnwdhNjyi27+9dMd42McdF
         iyeQ==
X-Gm-Message-State: ABy/qLbmhgxn43+secqAWbTXS/nWR2BmvYhci6oGU9f/XVkV2dYg5Q0I
	LKT4ksnm9Aeg3FuF3WhrWNPghifwkR+WcyJaemueshF2XLojlPNBbOMxTLIjSOIHufiTqy/VvG+
	NFIDYy7T6T0Kyoyhj
X-Received: by 2002:a17:90a:950b:b0:261:1141:b716 with SMTP id t11-20020a17090a950b00b002611141b716mr2709721pjo.33.1689296546060;
        Thu, 13 Jul 2023 18:02:26 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFSSCf8gGL9MdVrTrliVfiTlZBbSVuaYTkwu2FoRn5pnrMxd9r/+WlBrcYEXoTEJAZF8xXaVA==
X-Received: by 2002:a17:90a:950b:b0:261:1141:b716 with SMTP id t11-20020a17090a950b00b002611141b716mr2709710pjo.33.1689296545727;
        Thu, 13 Jul 2023 18:02:25 -0700 (PDT)
Received: from ?IPV6:2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5? ([2001:8003:e5b0:9f00:dbbc:1945:6e65:ec5])
        by smtp.gmail.com with ESMTPSA id 12-20020a17090a1a0c00b00263dfe1f8d8sm140821pjk.23.2023.07.13.18.02.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Jul 2023 18:02:25 -0700 (PDT)
Message-ID: <874fdca6-e029-98fe-8e6f-b21dc1eaa467@redhat.com>
Date: Fri, 14 Jul 2023 11:02:15 +1000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [RESEND PATCH v5 07/11] KVM: arm64: Define
 kvm_tlb_flush_vmid_range()
To: Raghavendra Rao Ananta <rananta@google.com>
Cc: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Paolo Bonzini <pbonzini@redhat.com>,
 Sean Christopherson <seanjc@google.com>, Huacai Chen
 <chenhuacai@kernel.org>, Zenghui Yu <yuzenghui@huawei.com>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atishp@atishpatra.org>,
 Jing Zhang <jingzhangos@google.com>, Colton Lewis <coltonlewis@google.com>,
 David Matlack <dmatlack@google.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.linux.dev, linux-mips@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-kernel@vger.kernel.org, kvm@vger.kernel.org
References: <20230621175002.2832640-1-rananta@google.com>
 <20230621175002.2832640-8-rananta@google.com>
 <1fe280a7-0f10-e124-00aa-b137df722c33@redhat.com>
 <CAJHc60xQtjvVsWRE=w-pAioNJW6uh-qKuZz2wp6bkT=X4oCm5A@mail.gmail.com>
 <60ba5bb4-6fad-0e51-2cd5-845610e6631d@redhat.com>
 <CAJHc60y6AaAUVy=V6GHTpVhHGO3Bjn1vpTnYpdFiFLjS-vR-uA@mail.gmail.com>
From: Gavin Shan <gshan@redhat.com>
In-Reply-To: <CAJHc60y6AaAUVy=V6GHTpVhHGO3Bjn1vpTnYpdFiFLjS-vR-uA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Raghavendra,

On 7/14/23 04:47, Raghavendra Rao Ananta wrote:
> On Wed, Jul 5, 2023 at 5:04 PM Gavin Shan <gshan@redhat.com> wrote:
>>
>> On 7/6/23 04:28, Raghavendra Rao Ananta wrote:
>>> On Tue, Jul 4, 2023 at 5:31 PM Gavin Shan <gshan@redhat.com> wrote:
>>>> On 6/22/23 03:49, Raghavendra Rao Ananta wrote:
>>>>> Implement the helper kvm_tlb_flush_vmid_range() that acts
>>>>> as a wrapper for range-based TLB invalidations. For the
>>>>> given VMID, use the range-based TLBI instructions to do
>>>>> the job or fallback to invalidating all the TLB entries.
>>>>>
>>>>> Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
>>>>> ---
>>>>>     arch/arm64/include/asm/kvm_pgtable.h | 10 ++++++++++
>>>>>     arch/arm64/kvm/hyp/pgtable.c         | 20 ++++++++++++++++++++
>>>>>     2 files changed, 30 insertions(+)
>>>>>
>>>>
>>>> It may be reasonable to fold this to PATCH[08/11] since kvm_tlb_flush_vmid_range() is
>>>> only called by ARM64's kvm_arch_flush_remote_tlbs_range(), which is added by PATCH[08/11].
>>>> In either way, the changes look good to me:
>>>>
>>> Ah, the patches 10 and 11 also call kvm_tlb_flush_vmid_range(), so
>>> probably it's better to keep the definition isolated?
>>>
>>
>> Thanks for your explanation. It's fine to have two separate patches in this
>> case. I still need to spend some time to look at PATCH[11/11] whose subject
>> includes typo (intructions -> instructions)
>>
> I'm planning to send v6 soon, but I'm happy to wait if you have any
> other comments on v5 patch-11.
> Appreciate your help with the reviews.
> 

I didn't get a chance to look at PATCH[11/11] yet. Please post v6 and I will
take a look on PATCH[v6 11/11]. Sorry for the delay.

Thanks,
Gavin

>>>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>>>>
>>>>> diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
>>>>> index 4cd6762bda805..1b12295a83595 100644
>>>>> --- a/arch/arm64/include/asm/kvm_pgtable.h
>>>>> +++ b/arch/arm64/include/asm/kvm_pgtable.h
>>>>> @@ -682,4 +682,14 @@ enum kvm_pgtable_prot kvm_pgtable_stage2_pte_prot(kvm_pte_t pte);
>>>>>      *     kvm_pgtable_prot format.
>>>>>      */
>>>>>     enum kvm_pgtable_prot kvm_pgtable_hyp_pte_prot(kvm_pte_t pte);
>>>>> +
>>>>> +/**
>>>>> + * kvm_tlb_flush_vmid_range() - Invalidate/flush a range of TLB entries
>>>>> + *
>>>>> + * @mmu:     Stage-2 KVM MMU struct
>>>>> + * @addr:    The base Intermediate physical address from which to invalidate
>>>>> + * @size:    Size of the range from the base to invalidate
>>>>> + */
>>>>> +void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
>>>>> +                             phys_addr_t addr, size_t size);
>>>>>     #endif      /* __ARM64_KVM_PGTABLE_H__ */
>>>>> diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
>>>>> index 3d61bd3e591d2..df8ac14d9d3d4 100644
>>>>> --- a/arch/arm64/kvm/hyp/pgtable.c
>>>>> +++ b/arch/arm64/kvm/hyp/pgtable.c
>>>>> @@ -631,6 +631,26 @@ static bool stage2_has_fwb(struct kvm_pgtable *pgt)
>>>>>         return !(pgt->flags & KVM_PGTABLE_S2_NOFWB);
>>>>>     }
>>>>>
>>>>> +void kvm_tlb_flush_vmid_range(struct kvm_s2_mmu *mmu,
>>>>> +                             phys_addr_t addr, size_t size)
>>>>> +{
>>>>> +     unsigned long pages, inval_pages;
>>>>> +
>>>>> +     if (!system_supports_tlb_range()) {
>>>>> +             kvm_call_hyp(__kvm_tlb_flush_vmid, mmu);
>>>>> +             return;
>>>>> +     }
>>>>> +
>>>>> +     pages = size >> PAGE_SHIFT;
>>>>> +     while (pages > 0) {
>>>>> +             inval_pages = min(pages, MAX_TLBI_RANGE_PAGES);
>>>>> +             kvm_call_hyp(__kvm_tlb_flush_vmid_range, mmu, addr, inval_pages);
>>>>> +
>>>>> +             addr += inval_pages << PAGE_SHIFT;
>>>>> +             pages -= inval_pages;
>>>>> +     }
>>>>> +}
>>>>> +
>>>>>     #define KVM_S2_MEMATTR(pgt, attr) PAGE_S2_MEMATTR(attr, stage2_has_fwb(pgt))
>>>>>
>>>>>     static int stage2_set_prot_attr(struct kvm_pgtable *pgt, enum kvm_pgtable_prot prot,
>>
> 

