Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5809A3CE4B9
	for <kvmarm@lists.linux.dev>; Fri,  5 Jun 2026 08:29:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.223
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780648197; cv=none; b=ZnkC4MpCIKC5jE3/9KAYFu505jQuMLii4qaSW8GWyN+eBuwRopPItsPyPP0Z9TpAJ8HUj42vlM6093vUfQV99llfVwvILOq+U/3O7PiaqG639fEn2Q9RlFFhV6EucnQH+oGUE7AL4gZZBMr48yBxsT1iSTcncqxvX2T4z54Ash8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780648197; c=relaxed/simple;
	bh=nXd0A+r89FuIKQpP6LrasSo0O8BaqgMBBgLC1Hv+46c=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jpJDRWCiIHObgBFdlsTOV9Fkp636f6Ck2VJRdTBS0VuJjwM5jWLXrCLY1XJogj9jzX+QEMGvgtUDd7GCDc1SvbUESQPfpTY2E9AiMDv1vTqywe4YcGAoz1lFt5M+Yr0dj9R3xXgdYTdXtwVBxy9TAbyaapMOnNSuZb2YEen5i6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=HH0ktyBM; arc=none smtp.client-ip=113.46.200.223
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="HH0ktyBM"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=eJ3rd6muldb5Ys/jUa4C6DrQYqz6Oo7suf7mdItTnFQ=;
	b=HH0ktyBMxXWRTw/q/P8xozXjuNm27h8Fvyyfntd5ZSceMqPqC0q4E4xGLazt1dCP72cDoP+ce
	EEIHUiS04j8T2FGa6sIvRJYuMTAsgJrOvZSoxWM7IdxbUpoUUZfAWjJ/WqKW2Z343vKak3V0mDP
	fevTQXcqKN9aiQ/bJwyoZGQ=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4gWvYL5dm4zmV8m;
	Fri,  5 Jun 2026 16:21:58 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 2980440562;
	Fri,  5 Jun 2026 16:29:51 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 5 Jun 2026 16:29:50 +0800
Message-ID: <22abfaf8-8636-4ed3-9a5c-fb4fdef1bc19@huawei.com>
Date: Fri, 5 Jun 2026 16:29:49 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/5] KVM: arm64: Add support for FEAT_HDBSS
To: Inochi Amaoto <inochiama@gmail.com>, Marc Zyngier <maz@kernel.org>
CC: <oupton@kernel.org>, <catalin.marinas@arm.com>, <corbet@lwn.net>,
	<pbonzini@redhat.com>, <will@kernel.org>, <yuzenghui@huawei.com>,
	<wangzhou1@hisilicon.com>, <liuyonglong@huawei.com>,
	<Jonathan.Cameron@huawei.com>, <yezhenyu2@huawei.com>, <linuxarm@huawei.com>,
	<joey.gouly@arm.com>, <kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <skhan@linuxfoundation.org>,
	<suzuki.poulose@arm.com>, <leo.bras@arm.com>
References: <20260225040421.2683931-1-zhengtian10@huawei.com>
 <20260225040421.2683931-4-zhengtian10@huawei.com>
 <ahzUUDAMoHtDFJD3@inochi.infowork> <864ijmvdpy.wl-maz@kernel.org>
 <ah1KLrpYBXSMM91H@inochi.infowork>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <ah1KLrpYBXSMM91H@inochi.infowork>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)


On 6/1/2026 5:05 PM, Inochi Amaoto wrote:
> On Mon, Jun 01, 2026 at 09:58:49AM +0100, Marc Zyngier wrote:
>> On Mon, 01 Jun 2026 01:50:22 +0100,
>> Inochi Amaoto <inochiama@gmail.com> wrote:
>>> On Wed, Feb 25, 2026 at 12:04:19PM +0800, Tian Zheng wrote:
>>>> From: eillon <yezhenyu2@huawei.com>
>>>>
>>>> Armv9.5 introduces the Hardware Dirty Bit State Structure (HDBSS) feature,
>>>> indicated by ID_AA64MMFR1_EL1.HAFDBS == 0b0100. A CPU capability is added
>>>> to notify the user of the feature.
>>>>
>>>> Add KVM_CAP_ARM_HW_DIRTY_STATE_TRACK ioctl and basic framework for
>>>> ARM64 HDBSS support. Since the HDBSS buffer size is configurable and
>>>> cannot be determined at KVM initialization, an IOCTL interface is
>>>> required.
>>>>
>>>> Actually exposing the new capability to user space happens in a later
>>>> patch.
>>>>
>>>> Signed-off-by: eillon <yezhenyu2@huawei.com>
>>>> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
>>>> ---
>>>>   arch/arm64/include/asm/cpufeature.h |  5 +++++
>>>>   arch/arm64/kernel/cpufeature.c      | 12 ++++++++++++
>>>>   arch/arm64/tools/cpucaps            |  1 +
>>>>   include/uapi/linux/kvm.h            |  1 +
>>>>   tools/include/uapi/linux/kvm.h      |  1 +
>>>>   5 files changed, 20 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>>>> index 4de51f8d92cb..dcc2e2cad5ad 100644
>>>> --- a/arch/arm64/include/asm/cpufeature.h
>>>> +++ b/arch/arm64/include/asm/cpufeature.h
>>>> @@ -856,6 +856,11 @@ static inline bool system_supports_haft(void)
>>>>   	return cpus_have_final_cap(ARM64_HAFT);
>>>>   }
>>>>
>>>> +static inline bool system_supports_hdbss(void)
>>>> +{
>>>> +	return cpus_have_final_cap(ARM64_HAS_HDBSS);
>>>> +}
>>>> +
>>>>   static __always_inline bool system_supports_mpam(void)
>>>>   {
>>>>   	return alternative_has_cap_unlikely(ARM64_MPAM);
>>>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>>>> index c31f8e17732a..348b0afffc3e 100644
>>>> --- a/arch/arm64/kernel/cpufeature.c
>>>> +++ b/arch/arm64/kernel/cpufeature.c
>>>> @@ -2124,6 +2124,11 @@ static bool hvhe_possible(const struct arm64_cpu_capabilities *entry,
>>>>   	return arm64_test_sw_feature_override(ARM64_SW_FEATURE_OVERRIDE_HVHE);
>>>>   }
>>>>
>>>> +static bool has_vhe_hdbss(const struct arm64_cpu_capabilities *entry, int cope)
>>>> +{
>>>> +	return is_kernel_in_hyp_mode() && has_cpuid_feature(entry, cope);
>>>> +}
>>>> +
>>>>   bool cpu_supports_bbml2_noabort(void)
>>>>   {
>>>>   	/*
>>>> @@ -2759,6 +2764,13 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
>>>>   		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, HAFDBS, HAFT)
>>>>   	},
>>>>   #endif
>>>> +	{
>>>> +		.desc = "Hardware Dirty state tracking structure (HDBSS)",
>>>> +		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
>>>> +		.capability = ARM64_HAS_HDBSS,
>>>> +		.matches = has_vhe_hdbss,
>>>> +		ARM64_CPUID_FIELDS(ID_AA64MMFR1_EL1, HAFDBS, HDBSS)
>>>> +	},
>>>>   	{
>>>>   		.desc = "CRC32 instructions",
>>>>   		.capability = ARM64_HAS_CRC32,
>>>> diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
>>>> index 7261553b644b..f6ece5b85532 100644
>>>> --- a/arch/arm64/tools/cpucaps
>>>> +++ b/arch/arm64/tools/cpucaps
>>>> @@ -68,6 +68,7 @@ HAS_VA52
>>>>   HAS_VIRT_HOST_EXTN
>>>>   HAS_WFXT
>>>>   HAS_XNX
>>>> +HAS_HDBSS
>>>>   HAFT
>>>>   HW_DBM
>>>>   KVM_HVHE
>>>
>>>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>>>> index 65500f5db379..15ee42cdbd51 100644
>>>> --- a/include/uapi/linux/kvm.h
>>>> +++ b/include/uapi/linux/kvm.h
>>>> @@ -985,6 +985,7 @@ struct kvm_enable_cap {
>>>>   #define KVM_CAP_ARM_SEA_TO_USER 245
>>>>   #define KVM_CAP_S390_USER_OPEREXEC 246
>>>>   #define KVM_CAP_S390_KEYOP 247
>>>> +#define KVM_CAP_ARM_HW_DIRTY_STATE_TRACK 248
>>>>
>>>>   struct kvm_irq_routing_irqchip {
>>>>   	__u32 irqchip;
>>>> diff --git a/tools/include/uapi/linux/kvm.h b/tools/include/uapi/linux/kvm.h
>>>> index dddb781b0507..93e0a1e14dc7 100644
>>>> --- a/tools/include/uapi/linux/kvm.h
>>>> +++ b/tools/include/uapi/linux/kvm.h
>>>> @@ -974,6 +974,7 @@ struct kvm_enable_cap {
>>>>   #define KVM_CAP_GUEST_MEMFD_FLAGS 244
>>>>   #define KVM_CAP_ARM_SEA_TO_USER 245
>>>>   #define KVM_CAP_S390_USER_OPEREXEC 246
>>>> +#define KVM_CAP_ARM_HW_DIRTY_STATE_TRACK 248
>>>>
>>>>   struct kvm_irq_routing_irqchip {
>>>>   	__u32 irqchip;
>>>> --
>>>> 2.33.0
>>>>
>>> Instead of having these architecture specific capability, I wonder if
>>> we can add a generic capability like "KVM_CAP_HW_DIRTY_STATE", so
>>> other architecture supports similar things can reuse this capability,
>> What of the existing stuff doing the same thing? x86's PML, to start
>> with?
>>
> In fact I think the HDBSS is the first one with non-fixed size.
> Although there is a in process RISC-V extension for it, there will
> be a long story to make it ratified.
>
>>> For this generic thing I suggest, the getter returns the max support
>>> entry count (or the buffer size) it supports like the dirty ring
>>> capability. And the setter just let the architecture set the parameters
>>> based on the user request.
>> This looks wrong on a number of levels.
>>
>> - If you want something generic, there is the existing dirty
>>    log/bitmap. How this stuff is populated is none of the user's
>>    business (trapping write accesses, dirty bit collection from the
>>    PTs, or HW-generated log), and we don't need an extra feature for
>>    it. Performance will obviously suck, but that's what you pay for
>>    something abstracted and cross-architecture.
>>
>> - If you want something architecture specific, then it can't be
>>    generic, by definition. You get the raw speed and compatibility with
>>    other arch-specific extensions.
>>
> OK, I agree, it is better to keep this thing arch-specific. Doing a
> generic thing does not benefit too much, I have made a mistake on
> it. Thanks for your kindly explanation.


Awesome. Thanks for the review.

I agree with Marc—keeping this ARM-specific is the right approach.
Also, in v4 we're removing the ioctl interface entirely. HDBSS will be
auto-enabled during migration setup and auto-disabled when migration
completes, so the capability naming issue becomes moot.

I plan to post v4 with the updated approach soon.


>>> This should do no harm to this implement, as everything still depends
>>> on the architecture behavior, and leave room for other architecture
>>> to reuse this.
>> Again, the generic framework exists, you just have to implement the
>> backend you want.
>>
>> 	M.
>>
>> -- 
>> Without deviation from the norm, progress is not possible.
> Regards,
> Inochi
