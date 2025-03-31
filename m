Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB80633F3
	for <kvmarm@lists.linux.dev>; Mon, 31 Mar 2025 08:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743408049; cv=none; b=ELH/fWwB/PuEIALXA1odRvGbOkNHM50jNeTRi4RsQyBE033WjIpFVjegkBiwTROJDSuAV+6Z7BhiavYWkWfBrUUQA2CxypJ+Eh0Jk54UBvYKJscX3ddvNiJBkVeY8B25rDGrj2ESbWXSn0i9GBZCML5I6LOm69nS3qJMSyeQv9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743408049; c=relaxed/simple;
	bh=BJe/4xveLVWeK61M76ZIcA8+1pMVcat+dYFs9OhqlTg=;
	h=CC:Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=faMfVQ7CB/TsSuIjGWukCUyAsoFFCW+3tx5VEoIFBBZHjjXOJknKzBkYJWlJn6MXLXvyL3WG29+LdL8t7EFaoeViraNo1t6/OmV9boD/PiAqHgUjgP4M7Q4P2qR300LsKcSCkHe48QEtWcvAy7S7lGBgC8fGy6dWslXIjZLAN8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4ZR3T96Xcfz13LCQ;
	Mon, 31 Mar 2025 16:00:13 +0800 (CST)
Received: from kwepemd200014.china.huawei.com (unknown [7.221.188.8])
	by mail.maildlp.com (Postfix) with ESMTPS id 02ED11400DC;
	Mon, 31 Mar 2025 16:00:43 +0800 (CST)
Received: from [10.67.121.177] (10.67.121.177) by
 kwepemd200014.china.huawei.com (7.221.188.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 31 Mar 2025 16:00:42 +0800
CC: <yangyicong@hisilicon.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<oliver.upton@linux.dev>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>,
	<prime.zeng@hisilicon.com>, <xuwei5@huawei.com>, Linuxarm
	<linuxarm@huawei.com>
Subject: Re: [PATCH 2/3] arm64/cpufeature: Add cpucap for HCR_EL2.E2H RES1
 (!FEAT_E2H0)
To: Marc Zyngier <maz@kernel.org>
References: <20250329034409.21354-1-yangyicong@huawei.com>
 <20250329034409.21354-3-yangyicong@huawei.com> <87semwz24p.wl-maz@kernel.org>
 <75a93cfd-1e1b-3d8a-9ff0-3991b5ef05cc@huawei.com>
 <87r02gyv85.wl-maz@kernel.org>
From: Yicong Yang <yangyicong@huawei.com>
Message-ID: <fab14901-b5d0-28b6-9f72-92dabfb19192@huawei.com>
Date: Mon, 31 Mar 2025 16:00:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <87r02gyv85.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 kwepemd200014.china.huawei.com (7.221.188.8)

On 2025/3/29 18:41, Marc Zyngier wrote:
> On Sat, 29 Mar 2025 08:41:09 +0000,
> Yicong Yang <yangyicong@huawei.com> wrote:
>>
>> On 2025/3/29 16:12, Marc Zyngier wrote:
>>> On Sat, 29 Mar 2025 03:44:08 +0000,
>>> Yicong Yang <yangyicong@huawei.com> wrote:
>>>>
>>>> From: Yicong Yang <yangyicong@hisilicon.com>
>>>>
>>>> Arm introduced a "new" feature FEAT_E2H0 indicates that HCR_EL2.E2H can
>>>> be programmed to the value 0 for legacy hardwares supported VHE. The
>>>> feature is indicated by ID_AA64MMFR4_EL1.E2H0 == 0. It is needed to
>>>> detect this feature for KVM mode initialization. Instead of bothering
>>>> the existed hardwares, introduce a new cpucap HAS_E2H_RES1 to indicate
>>>> FEAT_E2H0 is not supported. Make this a ARM64_CPUCAP_SYSTEM_FEATURE
>>>> just like VHE.
>>>>
>>>> Introduce cpu_has_e2h_res1() for checking the feature's support
>>>> which can be used in the early boot stage where CPU capabilities
>>>> are not initialized.
>>>>
>>>> Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
>>>> ---
>>>>  arch/arm64/include/asm/cpufeature.h | 23 +++++++++++++++++++++++
>>>>  arch/arm64/kernel/cpufeature.c      | 12 ++++++++++++
>>>>  arch/arm64/tools/cpucaps            |  1 +
>>>>  3 files changed, 36 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>>>> index c4326f1cb917..b35d393da28d 100644
>>>> --- a/arch/arm64/include/asm/cpufeature.h
>>>> +++ b/arch/arm64/include/asm/cpufeature.h
>>>> @@ -889,6 +889,29 @@ static inline bool cpu_has_hw_af(void)
>>>>  						ID_AA64MMFR1_EL1_HAFDBS_SHIFT);
>>>>  }
>>>>  
>>>> +/*
>>>> + * Check whether FEAT_E2H0 is not supported, in which case HCR_EL2.E2H
>>>> + * is implemented as RES1.
>>>> + */
>>>> +static __always_inline bool cpu_has_e2h_res1(void)
>>>> +{
>>>> +	u64 mmfr4;
>>>> +	u32 val;
>>>> +
>>>> +	/*
>>>> +	 * It's also used for checking the kvm mode cfg in early_param()
>>>> +	 * where boot capabilities is not initialized. In such case read
>>>> +	 * mmfr4 directly. This works same after boot stage since
>>>> +	 * ARM64_HAS_E2H_RES1 is a system feature, the cached sanitised
>>>> +	 * value keeps same with every single CPU.
>>>> +	 */
>>>> +	mmfr4 = read_sysreg_s(SYS_ID_AA64MMFR4_EL1);
>>>
>>> This will result in traps to EL2 with nested. Are you expecting this
>>> to be used on any form of hot paths?
>>>
>>
>> No. If any use required in the hotpath, check ARM64_HAS_E2H_RES1 by
>> alternative_has_cap* instead. We cannot check the capabilites in
>> the early_param() (in early_kvm_mode_cfg()) since they are not initialized,
>> so we can only rely on the registers directly.
> 
> Then I think an explicit comment would help clarifying what is
> expected to be used. I also don't think the __always_inline is
> mandated here. Specially if the helper needs to account for the broken
> Apple stuff.
> 

sure.

>>
>>>> +	val = cpuid_feature_extract_signed_field(mmfr4,
>>>> +						 ID_AA64MMFR4_EL1_E2H0_SHIFT);
>>>> +
>>>> +	return val != ID_AA64MMFR4_EL1_E2H0_IMP;
>>>
>>> This is going to break badly on Apple HW, which predate the
>>> "!FEAT_E2H0" relaxation and yet have HCR_EL2.E2H RAO/WI and
>>> ID_AA64MMFR4_EL1.E2H0==0.
>>
>> currently maybe only a wrong declaration of HCR_EL2.E2H RES1 and we can have
>> a workaround for the apple? considering the only use case of this is in the
>> early_kvm_mode_cfg() described below.
> 
> Indeed, I think you would need to handle the Apple behaviour here.
> 

okay will add a workaround for apple on this feature.

>>
>>>
>>> The curent code was carefully designed to *avoid* doing this, because
>>> the kernel doesn't really need to know anything about FEAT_E2H0 apart
>>> from the very early boot.
>>>
>>> What do we gain with this?
>>>
>>
>> Only one usecase introduced in patch 3/3, avoid triggering the warning on
>> !E2H0 platforms when booting with "kvm-arm.mode=nvhe". In such case "nvhe"
>> is inavailable but user has no hint on this, booting with "kvm-arm.mode=nvhe"
>> will trigger the warn [1]. Need to give some hint if user try to boot with
>> "nvhe" mode on !FEAT_E2H0 platforms. But we need a ARM64_CPUCAP_SYSTEM_FEATURE
>> capability to make this feature system wide consistent.
>>
>> [1] https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/kvm/arm.c#n2917
> 
> But *why* do we need an extra helper for this only functionnality? If
> we reach the point where early_kvm_mode_cfg() gets called, that we are
> still at EL2, and that the requested mode is "nvhe", then we know, by
> construction, that we couldn't switch to E2H==0.
> 
> That's because idreg-override.c defines this:
> 
>  { "kvm_arm.mode=nvhe",		"arm64_sw.hvhe=0 id_aa64mmfr1.vh=0" },
> 
> and "id_aa64mmfr1.vh=0" gets filtered out by mmfr1_vh_filter().
> 
> Or am I missing something obvious?
> 

nop, but the problem is not about the KVM function itself. The problem is that
trying to use "nvhe" mode on a E2H0 unavailable platform, and doesn't pass the
check of nvhe mode in early_kvm_mode_cfg(), explicitly:

early_kvm_mode_cfg()
[...]
	if (strcmp(arg, "nvhe") == 0 && !WARN_ON(is_kernel_in_hyp_mode())) { // Trigger the WARN_ON here and a call trace in the dmesg.
		kvm_mode = KVM_MODE_DEFAULT;
		return 0;
	}

finally we'll enter with VHE mode so the function of KVM is fine. we want
to eliminate this call trace and notify the user "nvhe" is not supported
due to !FEAT_E2H0.

The helper will be used in 2 places (sorry for the mistake in the last
reply):
1) in the HAS_E2H_RES1 capcap's detection has_e2h_res1()
2) in early_kvm_mode_cfg() for checking HAS_E2H_RES1 support and avoid
   checking for "nvhe".

is it suggested to check the mmfr4 directly in those 2 places without
using a wrapper?

Thanks.
