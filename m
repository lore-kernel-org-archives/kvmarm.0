Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75C5A5D477
	for <kvmarm@lists.linux.dev>; Sat, 29 Mar 2025 08:41:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743237678; cv=none; b=PxJW+IHtf5N5BWTnxQ4YhvmUAo48BfIF4QjZLxaV9yTm2OExa7pNJtHCaEm0amodGGPwgV0z9Dg3BgfLq5Xw7eSYOe637XwMyySzTqajR62C5qSYJKh3eHebgn0/P2kxud234GNHB4pQH0Dsk4BBWzL5iXQzDA+VqMFNmgVLr8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743237678; c=relaxed/simple;
	bh=8b6GKypgIkncu5Gd65V+Btjw9CImKpiHc4FFSTuqn9Y=;
	h=CC:Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=uVjg3sSDtPTEXo5Ip9yAG3VOINFgHaGihP1Do/L1Z3AxuQx79bk1U1ve4M2jrYuPjVtuQN2p91thdGd3VfnIXM+m/0L0u3qmDAFPolaY6dcASknz03HSfv8hbG0Uhd/96M3b1LINsBVUyhz0dpEZudUvGCasMw7hasGExbLO4M0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4ZPrRG2zpbz1R7Ng;
	Sat, 29 Mar 2025 16:39:22 +0800 (CST)
Received: from kwepemd200014.china.huawei.com (unknown [7.221.188.8])
	by mail.maildlp.com (Postfix) with ESMTPS id 0DDB51800B2;
	Sat, 29 Mar 2025 16:41:11 +0800 (CST)
Received: from [10.67.121.177] (10.67.121.177) by
 kwepemd200014.china.huawei.com (7.221.188.8) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Sat, 29 Mar 2025 16:41:10 +0800
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <oliver.upton@linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<shameerali.kolothum.thodi@huawei.com>, <jonathan.cameron@huawei.com>,
	<prime.zeng@hisilicon.com>, <xuwei5@huawei.com>, <yangyicong@hisilicon.com>,
	Yicong Yang <yangyicong@huawei.com>, Linuxarm <linuxarm@huawei.com>
Subject: Re: [PATCH 2/3] arm64/cpufeature: Add cpucap for HCR_EL2.E2H RES1
 (!FEAT_E2H0)
To: Marc Zyngier <maz@kernel.org>
References: <20250329034409.21354-1-yangyicong@huawei.com>
 <20250329034409.21354-3-yangyicong@huawei.com> <87semwz24p.wl-maz@kernel.org>
From: Yicong Yang <yangyicong@huawei.com>
Message-ID: <75a93cfd-1e1b-3d8a-9ff0-3991b5ef05cc@huawei.com>
Date: Sat, 29 Mar 2025 16:41:09 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <87semwz24p.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 kwepemd200014.china.huawei.com (7.221.188.8)

On 2025/3/29 16:12, Marc Zyngier wrote:
> On Sat, 29 Mar 2025 03:44:08 +0000,
> Yicong Yang <yangyicong@huawei.com> wrote:
>>
>> From: Yicong Yang <yangyicong@hisilicon.com>
>>
>> Arm introduced a "new" feature FEAT_E2H0 indicates that HCR_EL2.E2H can
>> be programmed to the value 0 for legacy hardwares supported VHE. The
>> feature is indicated by ID_AA64MMFR4_EL1.E2H0 == 0. It is needed to
>> detect this feature for KVM mode initialization. Instead of bothering
>> the existed hardwares, introduce a new cpucap HAS_E2H_RES1 to indicate
>> FEAT_E2H0 is not supported. Make this a ARM64_CPUCAP_SYSTEM_FEATURE
>> just like VHE.
>>
>> Introduce cpu_has_e2h_res1() for checking the feature's support
>> which can be used in the early boot stage where CPU capabilities
>> are not initialized.
>>
>> Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
>> ---
>>  arch/arm64/include/asm/cpufeature.h | 23 +++++++++++++++++++++++
>>  arch/arm64/kernel/cpufeature.c      | 12 ++++++++++++
>>  arch/arm64/tools/cpucaps            |  1 +
>>  3 files changed, 36 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>> index c4326f1cb917..b35d393da28d 100644
>> --- a/arch/arm64/include/asm/cpufeature.h
>> +++ b/arch/arm64/include/asm/cpufeature.h
>> @@ -889,6 +889,29 @@ static inline bool cpu_has_hw_af(void)
>>  						ID_AA64MMFR1_EL1_HAFDBS_SHIFT);
>>  }
>>  
>> +/*
>> + * Check whether FEAT_E2H0 is not supported, in which case HCR_EL2.E2H
>> + * is implemented as RES1.
>> + */
>> +static __always_inline bool cpu_has_e2h_res1(void)
>> +{
>> +	u64 mmfr4;
>> +	u32 val;
>> +
>> +	/*
>> +	 * It's also used for checking the kvm mode cfg in early_param()
>> +	 * where boot capabilities is not initialized. In such case read
>> +	 * mmfr4 directly. This works same after boot stage since
>> +	 * ARM64_HAS_E2H_RES1 is a system feature, the cached sanitised
>> +	 * value keeps same with every single CPU.
>> +	 */
>> +	mmfr4 = read_sysreg_s(SYS_ID_AA64MMFR4_EL1);
> 
> This will result in traps to EL2 with nested. Are you expecting this
> to be used on any form of hot paths?
> 

No. If any use required in the hotpath, check ARM64_HAS_E2H_RES1 by
alternative_has_cap* instead. We cannot check the capabilites in
the early_param() (in early_kvm_mode_cfg()) since they are not initialized,
so we can only rely on the registers directly.

>> +	val = cpuid_feature_extract_signed_field(mmfr4,
>> +						 ID_AA64MMFR4_EL1_E2H0_SHIFT);
>> +
>> +	return val != ID_AA64MMFR4_EL1_E2H0_IMP;
> 
> This is going to break badly on Apple HW, which predate the
> "!FEAT_E2H0" relaxation and yet have HCR_EL2.E2H RAO/WI and
> ID_AA64MMFR4_EL1.E2H0==0.

currently maybe only a wrong declaration of HCR_EL2.E2H RES1 and we can have
a workaround for the apple? considering the only use case of this is in the
early_kvm_mode_cfg() described below.

> 
> The curent code was carefully designed to *avoid* doing this, because
> the kernel doesn't really need to know anything about FEAT_E2H0 apart
> from the very early boot.
> 
> What do we gain with this?
> 

Only one usecase introduced in patch 3/3, avoid triggering the warning on
!E2H0 platforms when booting with "kvm-arm.mode=nvhe". In such case "nvhe"
is inavailable but user has no hint on this, booting with "kvm-arm.mode=nvhe"
will trigger the warn [1]. Need to give some hint if user try to boot with
"nvhe" mode on !FEAT_E2H0 platforms. But we need a ARM64_CPUCAP_SYSTEM_FEATURE
capability to make this feature system wide consistent.

[1] https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/kvm/arm.c#n2917

Thanks.


