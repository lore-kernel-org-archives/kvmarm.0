Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0438314B8E
	for <kvmarm@lists.linux.dev>; Tue, 11 Nov 2025 03:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762832463; cv=none; b=dM0UgEJrL501PrDC3bBwSZ9fdOWJURsdl9TVM8hWOLDXbKTzQB7Kd/KIQaeaogfwcacJpdvlUDsNDNqyJiXI2TLWNtkoYyW2OtP7prGSOXg2RSy+lQO/tYGBmQ6wgLPR3EfY4ahQGCph9X4P0EXhg+qi8kPquL+L/VHU9hzcOUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762832463; c=relaxed/simple;
	bh=1B0R3QzgEZmkuz8BBzFNYgzAW3ZbhmWFOOj1JPlo9is=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=uoc6kE0m6K2robVxFolV9Wrr78H6lXdRXQT5sb1vQFLq+NQpUeC7hHGqtmH7CrTzKnmWQomgG3wJkRwrr6jC4qQGQPI/rDdmhp3UVZcKWrtOsswgFy4iXXhQ35iCiKXn8673c5f8cLVXj2c4lGdMqJtlaoqohZHjy4R/tSRS81Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4d5C2b6Nz6z1T4K7;
	Tue, 11 Nov 2025 11:39:35 +0800 (CST)
Received: from dggemv705-chm.china.huawei.com (unknown [10.3.19.32])
	by mail.maildlp.com (Postfix) with ESMTPS id 73299180B49;
	Tue, 11 Nov 2025 11:40:57 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv705-chm.china.huawei.com (10.3.19.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 11 Nov 2025 11:40:57 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 11 Nov 2025 11:40:56 +0800
Message-ID: <7fae4511-6841-7df6-de43-4b9a7b5c9bdc@hisilicon.com>
Date: Tue, 11 Nov 2025 11:40:56 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v7 5/7] arm64: Add support for FEAT_{LS64, LS64_V}
Content-Language: en-US
To: Suzuki K Poulose <suzuki.poulose@arm.com>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <maz@kernel.org>, <oliver.upton@linux.dev>,
	<joey.gouly@arm.com>, <yuzenghui@huawei.com>, <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<yangyccccc@gmail.com>, <prime.zeng@hisilicon.com>, <xuwei5@huawei.com>
References: <20251107072127.448953-1-wangzhou1@hisilicon.com>
 <20251107072127.448953-6-wangzhou1@hisilicon.com>
 <cb087e63-3dae-4d7d-ac8a-a8982e560be6@arm.com>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <cb087e63-3dae-4d7d-ac8a-a8982e560be6@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2025/11/7 20:05, Suzuki K Poulose wrote:
> On 07/11/2025 07:21, Zhou Wang wrote:
>> From: Yicong Yang <yangyicong@hisilicon.com>
>>
>> Armv8.7 introduces single-copy atomic 64-byte loads and stores
>> instructions and its variants named under FEAT_{LS64, LS64_V}.
>> These features are identified by ID_AA64ISAR1_EL1.LS64 and the
>> use of such instructions in userspace (EL0) can be trapped. In
>> order to support the use of corresponding instructions in userspace:
>> - Make ID_AA64ISAR1_EL1.LS64 visbile to userspace
>> - Add identifying and enabling in the cpufeature list
>> - Expose these support of these features to userspace through HWCAP3
>>    and cpuinfo
>>
>> ld64b/st64b (FEAT_LS64) and st64bv (FEAT_LS64_V) is intended for
>> special memory (device memory) so requires support by the CPU, system
>> and target memory location (device that support these instructions).
>> The HWCAP3_{LS64, LS64_V} implies the support of CPU and system (since
>> no identification method from system, so SoC vendors should advertise
>> support in the CPU if system also support them).
>>
>> Otherwise for ld64b/st64b the atomicity may not be guaranteed or a
>> DABT will be generated, so users (probably userspace driver developer)
>> should make sure the target memory (device) also have the support.
>> For st64bv 0xffffffffffffffff will be returned as status result for
>> unsupported memory so user should check it.
>>
>> Document the restrictions along with HWCAP3_{LS64, LS64_V}.
>>
>> Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
>> Signed-off-by: Zhou Wang <wangzhou1@hisilicon.com>
>> ---
>>   Documentation/arch/arm64/booting.rst    | 12 ++++++
>>   Documentation/arch/arm64/elf_hwcaps.rst | 14 +++++++
>>   arch/arm64/include/asm/hwcap.h          |  2 +
>>   arch/arm64/include/uapi/asm/hwcap.h     |  2 +
>>   arch/arm64/kernel/cpufeature.c          | 51 +++++++++++++++++++++++++
>>   arch/arm64/kernel/cpuinfo.c             |  2 +
>>   arch/arm64/tools/cpucaps                |  2 +
>>   7 files changed, 85 insertions(+)
>>
>> diff --git a/Documentation/arch/arm64/booting.rst b/Documentation/arch/arm64/booting.rst
>> index e4f953839f71..2c56d76ecafb 100644
>> --- a/Documentation/arch/arm64/booting.rst
>> +++ b/Documentation/arch/arm64/booting.rst
>> @@ -556,6 +556,18 @@ Before jumping into the kernel, the following conditions must be met:
>>        - MDCR_EL3.TPM (bit 6) must be initialized to 0b0
>>   +  For CPUs with support for 64-byte loads and stores without status (FEAT_LS64):
>> +
>> +  - If the kernel is entered at EL1 and EL2 is present:
>> +
>> +    - HCRX_EL2.EnALS (bit 1) must be initialised to 0b1.
>> +
>> +  For CPUs with support for 64-byte stores with status (FEAT_LS64_V):
>> +
>> +  - If the kernel is entered at EL1 and EL2 is present:
>> +
>> +    - HCRX_EL2.EnASR (bit 2) must be initialised to 0b1.
>> +
>>   The requirements described above for CPU mode, caches, MMUs, architected
>>   timers, coherency and system registers apply to all CPUs.  All CPUs must
>>   enter the kernel in the same exception level.  Where the values documented
>> diff --git a/Documentation/arch/arm64/elf_hwcaps.rst b/Documentation/arch/arm64/elf_hwcaps.rst
>> index a15df4956849..b86059bc288b 100644
>> --- a/Documentation/arch/arm64/elf_hwcaps.rst
>> +++ b/Documentation/arch/arm64/elf_hwcaps.rst
>> @@ -444,6 +444,20 @@ HWCAP3_MTE_STORE_ONLY
>>   HWCAP3_LSFE
>>       Functionality implied by ID_AA64ISAR3_EL1.LSFE == 0b0001
>>   +HWCAP3_LS64
>> +    Functionality implied by ID_AA64ISAR1_EL1.LS64 == 0b0001. Note that
>> +    the function of instruction ld64b/st64b requires support by CPU, system
>> +    and target (device) memory location and HWCAP3_LS64 implies the support
>> +    of CPU. User should only use ld64b/st64b on supported target (device)
>> +    memory location, otherwise fallback to the non-atomic alternatives.
>> +
>> +HWCAP3_LS64_V
>> +    Functionality implied by ID_AA64ISAR1_EL1.LS64 == 0b0010. Same to
>> +    HWCAP3_LS64 that HWCAP3_LS64_V implies CPU's support of instruction
>> +    st64bv but also requires the support from the system and target (device)
>> +    memory location. st64bv supports return status result and 0xFFFFFFFFFFFFFFFF
>> +    will be returned for unsupported memory location.
>> +
>>     4. Unused AT_HWCAP bits
>>   -----------------------
>> diff --git a/arch/arm64/include/asm/hwcap.h b/arch/arm64/include/asm/hwcap.h
>> index 6d567265467c..3c0804fb3435 100644
>> --- a/arch/arm64/include/asm/hwcap.h
>> +++ b/arch/arm64/include/asm/hwcap.h
>> @@ -179,6 +179,8 @@
>>   #define KERNEL_HWCAP_MTE_FAR        __khwcap3_feature(MTE_FAR)
>>   #define KERNEL_HWCAP_MTE_STORE_ONLY    __khwcap3_feature(MTE_STORE_ONLY)
>>   #define KERNEL_HWCAP_LSFE        __khwcap3_feature(LSFE)
>> +#define KERNEL_HWCAP_LS64        __khwcap3_feature(LS64)
>> +#define KERNEL_HWCAP_LS64_V        __khwcap3_feature(LS64_V)
>>     /*
>>    * This yields a mask that user programs can use to figure out what
>> diff --git a/arch/arm64/include/uapi/asm/hwcap.h b/arch/arm64/include/uapi/asm/hwcap.h
>> index 575564ecdb0b..79bc77425b82 100644
>> --- a/arch/arm64/include/uapi/asm/hwcap.h
>> +++ b/arch/arm64/include/uapi/asm/hwcap.h
>> @@ -146,5 +146,7 @@
>>   #define HWCAP3_MTE_FAR        (1UL << 0)
>>   #define HWCAP3_MTE_STORE_ONLY        (1UL << 1)
>>   #define HWCAP3_LSFE        (1UL << 2)
>> +#define HWCAP3_LS64        (1UL << 3)
>> +#define HWCAP3_LS64_V        (1UL << 4)
>>     #endif /* _UAPI__ASM_HWCAP_H */
>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index 5ed401ff79e3..dcc5ba620a7e 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -239,6 +239,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar0[] = {
>>   };
>>     static const struct arm64_ftr_bits ftr_id_aa64isar1[] = {
>> +    ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_LS64_SHIFT, 4, 0),
>>       ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_XS_SHIFT, 4, 0),
>>       ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_I8MM_SHIFT, 4, 0),
>>       ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64ISAR1_EL1_DGH_SHIFT, 4, 0),
>> @@ -2259,6 +2260,38 @@ static void cpu_enable_e0pd(struct arm64_cpu_capabilities const *cap)
>>   }
>>   #endif /* CONFIG_ARM64_E0PD */
>>   +static bool has_ls64(const struct arm64_cpu_capabilities *entry, int __unused)
>> +{
>> +    u64 ls64;
>> +
>> +    ls64 = cpuid_feature_extract_field(__read_sysreg_by_encoding(entry->sys_reg),
>> +                       entry->field_pos, entry->sign);
> 
> Why are we always reading from the "local" CPU ? Shouldn't this be based on the SCOPE ?
> 
> i.e., read from the sanitised feature state for SCOPE_SYSTEM (given that is the SCOPE for the capability)
> 
> and read from the local CPU for SCOPE_LOCAL (for checks in late CPUs).>

I am not sure if there is more consideration here, but seems that directly using has_cpuid_feature
is enough here, just as you mentioned below.

> 
>> +
>> +    if (ls64 == ID_AA64ISAR1_EL1_LS64_NI ||
>> +        ls64 > ID_AA64ISAR1_EL1_LS64_LS64_ACCDATA)
> 
> Given this is FTR_LOWER_SAFE, why do we skip anything that is HIGHER than a particular value ? You must be able to fall back to the has_cpuid_feature() check for both these CAPs.
> 
> 
>> +        return false;
>> +
> 
> 
> 
> ---8>---
> 
>> +    if (entry->capability == ARM64_HAS_LS64 &&
>> +        ls64 >= ID_AA64ISAR1_EL1_LS64_LS64)
>> +        return true;
>> +
>> +    if (entry->capability == ARM64_HAS_LS64_V &&
>> +        ls64 >= ID_AA64ISAR1_EL1_LS64_LS64_V)
>> +        return true;
>> +
>> +    return false;
> 
> --<8---
> 
> 
> minor nit: You could simplify this to:
> 
>     return (ls64 >= entry->min_field_value)

Same as above.

Best,
Zhou

> 
> 
> Suzuki
> 
> .
