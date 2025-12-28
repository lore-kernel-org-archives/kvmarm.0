Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3507725DD1E
	for <kvmarm@lists.linux.dev>; Sun, 28 Dec 2025 13:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766928098; cv=none; b=RGCzmPAPdMviEU7fNH7S6GVuR9ot116HcYzNP+mCAdeMpdxKsQDPJw+ULe9o8XSkfqovuO3eRv1wGS23BanwkPxdi/bifPEBwasApaL51XZrJisp0dijUuHGMisHsnHiiJCBC57a6/HJIHvK3kn7jdg2MtnsPqLdjhr8RDp5tVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766928098; c=relaxed/simple;
	bh=ALXasUN+LrCY1Kw1mJi1uRGYS1BLunwnlJBnwmwD3MQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kP6jfDi53vNnQS0NuXR+QPfq4i63ODGmmQVhaIJML9mbS39yfxIOilTual92DAY2YnFvsvg/M9s+CYMC0ycychDV+101RRLry20tAYWHN4vZqatmIhL4R7YaAh1VqOYpqxL5wJZT3xL55dSBh4vaLZoM0eHZf/SiixBv4wYkhp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QMDUcGwD; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QMDUcGwD"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7b8e49d8b35so10240289b3a.3
        for <kvmarm@lists.linux.dev>; Sun, 28 Dec 2025 05:21:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766928096; x=1767532896; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NsMbiiRw5pwuhYdj9qM0uJazKIcwvpy1o66u9nBUaH4=;
        b=QMDUcGwDaaOtr/V56Bv/NMPb2Nw0YxNIVj6ICNpK7pcilyWshNouFPZVxk7X8ZUCRk
         +TtjjeIy8rT7yV9KrcPuOjkQAyqlw9aVjBF1MqUy4Ix+PxuuLF0O+/n6A+Mz1Qwgm8vs
         1BRuclr4GxYfFS2ewvIZW6FJ/0Vhj8mv6q5wzck+8kKfPCYp/7YnsFlGA5jljK1D1AKJ
         AVISHKD7vR1ZkmTrMmna63GfyAcNBPxXjmYP86VeAoinJ0zVfopFu1LqyzyVdp9JOPCV
         TVdMtjlKvFTK0f7hGRaLZGZXx8ztsupe1EpaJLMRiyFqNHW2nCdvQ9HqT3bvx6zQo1hD
         ksNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766928096; x=1767532896;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NsMbiiRw5pwuhYdj9qM0uJazKIcwvpy1o66u9nBUaH4=;
        b=SjPP89OLNQPu//tFsQVkt9973bFyGjtLFZAfX6TRegAnwDFv41etTGIB3ky+/bjbf1
         99dzuQ2w4ZHu8mhHd6qIEXAlQbvRoPje26UsZs0W3ay3xE4rd3TO/t8MuRKJuAVY++Hn
         HF0xdAvFtHMQRFgH36j+4DgXghAKMFkbHXo8893zWBGIbO3q4wbZFNPzQc8Hf39IA2j/
         tOziQW4B1xl/JObOcKz0mQj0nMSSn4fXUJ7bbBUhcWg6BATEy2TNHCy6Gr8Or1Bzny8x
         mstWKPo9Eyw38Eo1Ma5xZ9LorX71SzLphoAfUAbuRV4P6y/AwglfA4O0ESF8/de03EnG
         /HqQ==
X-Forwarded-Encrypted: i=1; AJvYcCXRS4ful0zGwPq2mpOcs/N0d6nciGwTNnNUgTYnFj1UTPkcBsfhEVUUdXzJpcU0+XG/KeNpuOY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxKal/9VXUTqNeHTYZMAmFab6DWAHnHPt60Eop8l8YRVFX/5lro
	JB9GsgDElZy2i/WNqIIcLvzCV6DsxwejcUWHVSlfMDP4Y9nXQiv6hknY
X-Gm-Gg: AY/fxX59okM8ZsX8/HHwIw0/fX0j4c2IkbM3TZUJ4MMQmNObTAVzky+LVmcMcWmpp7l
	B3OIRcxOfrVz8fBb6v0Gy6AEkT+WnvZSMGsj6chNCVcO79FcxmWum23SLST2HwbajwqscG/J4yc
	E9G1H1tQ2N+G2oMUJXyQNQWQnB5ws85Pxgaq5aBce/+C8hbZ7+Jzv8/xDDWOEVUKBetW2HIgYTR
	Tq75ZDCP8sO46cm5LhMNUrKhZKGGcYtsWnEn1IbdWDiZ3EYmow8EfgksvdoImmOV7u8wWBLzMEv
	HlZ705/GFWrnBptJSgj0OAbaw9XCx/OPjXzPLejAN5aOQ1hoorsNzdPwxm3gFCvCNuxcmOfQn7t
	3N4QWmFkfaBBXtnA20bt/WDmgnST0MXqct2R8SFxI01v1rf2CRyxiNCCv94WgJNqkPmziSCiBen
	iMyMmdScE198OLnoki/WWdDVxpMwmIbcFsgdo3oXYMFxIizhmQ0Zy70zda/8yO2ki1AZIWVzQmW
	8BcmICkbtk3ILBlGl/CaROac8mgS9JyIW+8/Q==
X-Google-Smtp-Source: AGHT+IHeg/aDmTAdO7reMjcuq8FZ1iHZdOJNA4rNPYOoWbba+9Xx9UUwrhaHrn5Pm5j+3g0csgItJg==
X-Received: by 2002:a05:6a20:e290:b0:364:13c3:3dd0 with SMTP id adf61e73a8af0-376a8eb6c35mr29010710637.36.1766928096301;
        Sun, 28 Dec 2025 05:21:36 -0800 (PST)
Received: from [172.27.236.57] (ec2-13-250-3-147.ap-southeast-1.compute.amazonaws.com. [13.250.3.147])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c1e7bd602desm24490702a12.21.2025.12.28.05.21.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Dec 2025 05:21:34 -0800 (PST)
Message-ID: <77111894-1b9f-4970-b41f-48e3a4c4b754@gmail.com>
Date: Sun, 28 Dec 2025 21:21:25 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] KVM: arm64: Enable HDBSS support and handle HDBSSF
 events
To: Tian Zheng <zhengtian10@huawei.com>, maz@kernel.org,
 oliver.upton@linux.dev, catalin.marinas@arm.com, corbet@lwn.net,
 pbonzini@redhat.com, will@kernel.org
Cc: linux-kernel@vger.kernel.org, yuzenghui@huawei.com,
 wangzhou1@hisilicon.com, yezhenyu2@huawei.com, xiexiangyou@huawei.com,
 zhengchuan@huawei.com, joey.gouly@arm.com, kvmarm@lists.linux.dev,
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-doc@vger.kernel.org, suzuki.poulose@arm.com
References: <20251121092342.3393318-1-zhengtian10@huawei.com>
 <20251121092342.3393318-5-zhengtian10@huawei.com>
 <87df4cba-b191-49cf-9486-fc379470a6eb@gmail.com>
 <f8e59e80-33b2-47cd-a042-11f28cc61645@huawei.com>
Content-Language: en-US
From: Robert Hoo <robert.hoo.linux@gmail.com>
In-Reply-To: <f8e59e80-33b2-47cd-a042-11f28cc61645@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/24/2025 2:15 PM, Tian Zheng wrote:
> 
> 
> On 12/17/2025 9:39 PM, Robert Hoo wrote:
>> On 11/21/2025 5:23 PM, Tian Zheng wrote:
>>> From: eillon <yezhenyu2@huawei.com>
>>>
>>> Implement the HDBSS enable/disable functionality using the
>>> KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl.
>>>
>>> Userspace (e.g., QEMU) can enable HDBSS by invoking the ioctl
>>> at the start of live migration, configuring the buffer size.
>>> The feature is disabled by invoking the ioctl again with size
>>> set to 0 once migration completes.
>>>
>>> Add support for updating the dirty bitmap based on the HDBSS
>>> buffer. Similar to the x86 PML implementation, KVM flushes the
>>> buffer on all VM-Exits, so running vCPUs only need to be kicked
>>> to force a VM-Exit.
>>>
>>> Signed-off-by: eillon <yezhenyu2@huawei.com>
>>> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
>>> ---
>>>   arch/arm64/include/asm/kvm_host.h |  10 +++
>>>   arch/arm64/include/asm/kvm_mmu.h  |  17 +++++
>>>   arch/arm64/kvm/arm.c              | 107 ++++++++++++++++++++++++++++++
>>>   arch/arm64/kvm/handle_exit.c      |  45 +++++++++++++
>>>   arch/arm64/kvm/hyp/vhe/switch.c   |   1 +
>>>   arch/arm64/kvm/mmu.c              |  10 +++
>>>   arch/arm64/kvm/reset.c            |   3 +
>>>   include/linux/kvm_host.h          |   1 +
>>>   8 files changed, 194 insertions(+)
>>>
>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/ 
>>> asm/kvm_host.h
>>> index d962932f0e5f..408e4c2b3d1a 100644
>>> --- a/arch/arm64/include/asm/kvm_host.h
>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>> @@ -87,6 +87,7 @@ int __init kvm_arm_init_sve(void);
>>>   u32 __attribute_const__ kvm_target_cpu(void);
>>>   void kvm_reset_vcpu(struct kvm_vcpu *vcpu);
>>>   void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu);
>>> +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
>>>
>>>   struct kvm_hyp_memcache {
>>>       phys_addr_t head;
>>> @@ -793,6 +794,12 @@ struct vcpu_reset_state {
>>>       bool        reset;
>>>   };
>>>
>>> +struct vcpu_hdbss_state {
>>> +    phys_addr_t base_phys;
>>> +    u32 size;
>>> +    u32 next_index;
>>> +};
>>> +
>>>   struct vncr_tlb;
>>>
>>>   struct kvm_vcpu_arch {
>>> @@ -897,6 +904,9 @@ struct kvm_vcpu_arch {
>>>
>>>       /* Per-vcpu TLB for VNCR_EL2 -- NULL when !NV */
>>>       struct vncr_tlb    *vncr_tlb;
>>> +
>>> +    /* HDBSS registers info */
>>> +    struct vcpu_hdbss_state hdbss;
>>>   };
>>>
>>>   /*
>>> diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/ 
>>> asm/kvm_mmu.h
>>> index e4069f2ce642..6ace1080aed5 100644
>>> --- a/arch/arm64/include/asm/kvm_mmu.h
>>> +++ b/arch/arm64/include/asm/kvm_mmu.h
>>> @@ -331,6 +331,23 @@ static __always_inline void __load_stage2(struct 
>>> kvm_s2_mmu *mmu,
>>>       asm(ALTERNATIVE("nop", "isb", ARM64_WORKAROUND_SPECULATIVE_AT));
>>>   }
>>>
>>> +static __always_inline void __load_hdbss(struct kvm_vcpu *vcpu)
>>> +{
>>> +    struct kvm *kvm = vcpu->kvm;
>>> +    u64 br_el2, prod_el2;
>>> +
>>> +    if (!kvm->enable_hdbss)
>>> +        return;
>>> +
>>> +    br_el2 = HDBSSBR_EL2(vcpu->arch.hdbss.base_phys, vcpu- >arch.hdbss.size);
>>> +    prod_el2 = vcpu->arch.hdbss.next_index;
>>> +
>>> +    write_sysreg_s(br_el2, SYS_HDBSSBR_EL2);
>>> +    write_sysreg_s(prod_el2, SYS_HDBSSPROD_EL2);
>>> +
>>> +    isb();
>>> +}
>>> +
>>>   static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
>>>   {
>>>       return container_of(mmu->arch, struct kvm, arch);
>>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>>> index 870953b4a8a7..64f65e3c2a89 100644
>>> --- a/arch/arm64/kvm/arm.c
>>> +++ b/arch/arm64/kvm/arm.c
>>> @@ -79,6 +79,92 @@ int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
>>>       return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
>>>   }
>>>
>>> +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
>>> +{
>>> +    struct page *hdbss_pg = NULL;
>>> +
>>> +    hdbss_pg = phys_to_page(vcpu->arch.hdbss.base_phys);
>>> +    if (hdbss_pg)
>>> +        __free_pages(hdbss_pg, vcpu->arch.hdbss.size);
>>> +
>>> +    vcpu->arch.hdbss = (struct vcpu_hdbss_state) {
>>> +        .base_phys = 0,
>>> +        .size = 0,
>>> +        .next_index = 0,
>>> +    };
>>> +}
>>> +
>>> +static int kvm_cap_arm_enable_hdbss(struct kvm *kvm,
>>> +                    struct kvm_enable_cap *cap)
>>> +{
>>> +    unsigned long i;
>>> +    struct kvm_vcpu *vcpu;
>>> +    struct page *hdbss_pg = NULL;
>>> +    int size = cap->args[0];
>>> +    int ret = 0;
>>> +
>>> +    if (!system_supports_hdbss()) {
>>> +        kvm_err("This system does not support HDBSS!\n");
>>> +        return -EINVAL;
>>> +    }
>>> +
>>> +    if (size < 0 || size > HDBSS_MAX_SIZE) {
>>> +        kvm_err("Invalid HDBSS buffer size: %d!\n", size);
>>> +        return -EINVAL;
>>> +    }
>>> +
>>
>> I think you should check if it's already enabled here. What if user space 
>> calls this twice?
> 
> Ok, I review the implement of qemu, when disable the hdbss feature in
> ram_save_cleanup, size=0 will be set, so here can add a check, if (size
> && kvm->arch.enable_hdbss), we will do nothing.
> 

I mean you should check if ' kvm->enable_hdbss' is already set, if so, return 
rather than alloc_pages() in below (you have allocated in previous call with 
valid 'size').

qemu is just one of the user space applications that would possibly call this 
API, you cannot rely on your qemu patch's flow/sequence as assumption to design 
a KVM API's implementation.

>>
>>> +    /* Enable the HDBSS feature if size > 0, otherwise disable it. */
>>> +    if (size) {
>>> +        kvm_for_each_vcpu(i, vcpu, kvm) {
>>> +            hdbss_pg = alloc_pages(GFP_KERNEL_ACCOUNT, size);
>>> +            if (!hdbss_pg) {
>>> +                kvm_err("Alloc HDBSS buffer failed!\n");
>>> +                ret = -ENOMEM;
>>> +                goto error_alloc;
>>> +            }
>>> +
>>> +            vcpu->arch.hdbss = (struct vcpu_hdbss_state) {
>>> +                .base_phys = page_to_phys(hdbss_pg),
>>> +                .size = size,
>>> +                .next_index = 0,
>>> +            };
>>> +        }
>>> +
>>> +        kvm->enable_hdbss = true;
>>> +        kvm->arch.mmu.vtcr |= VTCR_EL2_HD | VTCR_EL2_HDBSS;
>>


