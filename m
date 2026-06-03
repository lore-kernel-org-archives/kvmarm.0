Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 172E243D4E3;
	Wed,  3 Jun 2026 10:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780484248; cv=none; b=k+83VJJAMW/KxmA22I8rE9BKErwWw+nQbXTZkCDVhCCNWKHNClFIEB0W1jaQ2YhSincBV9tdoRJVatm0Da4ZHXFdb+mlt+G6fYak8wPz4L2WFf33K9Hs15iBrQqoFIT0tyZIMoV1DZwwYwU39UXhvyc8ilgROQvKVehY4yi9U3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780484248; c=relaxed/simple;
	bh=Cbom3lLA/oZS7Gf7ajwverW1Ai4B/b3z2gFyR3cP6kg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bAOUxVMYfYynVoMTqcqbFsiLFPRdqkzXGuf3TXe8/b2ndPf1xhx78U9G3jgZboDB4GjnES94S2iDR6kUhtfQ8fujZMUcf4gi1viAICHlFTrwVGeSDEdV4wouyzKaA/rJm2ad6TTpqEuIYz/UwsU5wnz0Nh40woXSKNgniyPIgL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=eNBypVqi; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="eNBypVqi"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8346249E3;
	Wed,  3 Jun 2026 03:57:20 -0700 (PDT)
Received: from [10.57.26.22] (unknown [10.57.26.22])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5D3013F632;
	Wed,  3 Jun 2026 03:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780484245; bh=Cbom3lLA/oZS7Gf7ajwverW1Ai4B/b3z2gFyR3cP6kg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eNBypVqikAVvslU2dozRzAi/42KRf1QN3GyF+PjiX1Fwkyr5+wSTOg4FSY5wO0t72
	 pZ3567HwrF3FO2JZjd0DpdkFQF+q9NSYA/WiQBBKtpkStJity9ezznwGOBMIfTZnyv
	 pivG5AchAXnj1UwH6V3pS50qAnqFDiXn+0L+3McM=
Message-ID: <1085ff2d-1e23-4df9-baad-cfafeb1f6449@arm.com>
Date: Wed, 3 Jun 2026 11:57:12 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 06/44] arm64: RMI: Check for RMI support at init
To: Marc Zyngier <maz@kernel.org>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 James Morse <james.morse@arm.com>, Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>, WeiLin.Chang@arm.com,
 Lorenzo.Pieralisi2@arm.com
References: <20260513131757.116630-1-steven.price@arm.com>
 <20260513131757.116630-7-steven.price@arm.com> <86bje8x6dj.wl-maz@kernel.org>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <86bje8x6dj.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/05/2026 14:02, Marc Zyngier wrote:
> On Wed, 13 May 2026 14:17:14 +0100,
> Steven Price <steven.price@arm.com> wrote:
>>
>> Query the RMI version number and check if it is a compatible version.
>> The first two feature registers are read and exposed for future code to
>> use.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>> v14:
>>  * This moves the basic RMI setup into the 'kernel' directory. This is
>>    because RMI will be used for some features outside of KVM so should
>>    be available even if KVM isn't compiled in.
>> ---
>>  arch/arm64/include/asm/rmi_cmds.h |  3 ++
>>  arch/arm64/kernel/Makefile        |  2 +-
>>  arch/arm64/kernel/cpufeature.c    |  1 +
>>  arch/arm64/kernel/rmi.c           | 65 +++++++++++++++++++++++++++++++
>>  4 files changed, 70 insertions(+), 1 deletion(-)
>>  create mode 100644 arch/arm64/kernel/rmi.c
>>
>> diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
>> index 04f7066894e9..9179934925c5 100644
>> --- a/arch/arm64/include/asm/rmi_cmds.h
>> +++ b/arch/arm64/include/asm/rmi_cmds.h
>> @@ -10,6 +10,9 @@
>>  
>>  #include <asm/rmi_smc.h>
>>  
>> +extern unsigned long rmm_feat_reg0;
>> +extern unsigned long rmm_feat_reg1;
>> +
>>  struct rtt_entry {
>>  	unsigned long walk_level;
>>  	unsigned long desc;
>> diff --git a/arch/arm64/kernel/Makefile b/arch/arm64/kernel/Makefile
>> index 74b76bb70452..d68f351aae75 100644
>> --- a/arch/arm64/kernel/Makefile
>> +++ b/arch/arm64/kernel/Makefile
>> @@ -34,7 +34,7 @@ obj-y			:= debug-monitors.o entry.o irq.o fpsimd.o		\
>>  			   cpufeature.o alternative.o cacheinfo.o		\
>>  			   smp.o smp_spin_table.o topology.o smccc-call.o	\
>>  			   syscall.o proton-pack.o idle.o patching.o pi/	\
>> -			   rsi.o jump_label.o
>> +			   rsi.o jump_label.o rmi.o
>>  
>>  obj-$(CONFIG_COMPAT)			+= sys32.o signal32.o			\
>>  					   sys_compat.o
>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index 6d53bb15cf7b..8bdd95a8c2de 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -292,6 +292,7 @@ static const struct arm64_ftr_bits ftr_id_aa64isar3[] = {
>>  static const struct arm64_ftr_bits ftr_id_aa64pfr0[] = {
>>  	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_CSV3_SHIFT, 4, 0),
>>  	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_CSV2_SHIFT, 4, 0),
>> +	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_RME_SHIFT, 4, 0),
>>  	ARM64_FTR_BITS(FTR_VISIBLE, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_DIT_SHIFT, 4, 0),
>>  	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_AMU_SHIFT, 4, 0),
>>  	ARM64_FTR_BITS(FTR_HIDDEN, FTR_STRICT, FTR_LOWER_SAFE, ID_AA64PFR0_EL1_MPAM_SHIFT, 4, 0),
>> diff --git a/arch/arm64/kernel/rmi.c b/arch/arm64/kernel/rmi.c
>> new file mode 100644
>> index 000000000000..99c1ccc35c11
>> --- /dev/null
>> +++ b/arch/arm64/kernel/rmi.c
>> @@ -0,0 +1,65 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2023-2025 ARM Ltd.
>> + */
>> +
>> +#include <linux/memblock.h>
>> +
>> +#include <asm/rmi_cmds.h>
>> +
>> +unsigned long rmm_feat_reg0;
>> +unsigned long rmm_feat_reg1;
> 
> What is the requirement for making those globally accessible? Can't
> they be made static and use an accessor that returns them? Can the
> variables be made __ro_after_init?

Good point - there's no requirement. Also the name isn't quite right - 
these should be named rmi_ as there is a different set for RSI.

>> +
>> +static int rmi_check_version(void)
>> +{
>> +	struct arm_smccc_res res;
>> +	unsigned short version_major, version_minor;
>> +	unsigned long host_version = RMI_ABI_VERSION(RMI_ABI_MAJOR_VERSION,
>> +						     RMI_ABI_MINOR_VERSION);
>> +	unsigned long aa64pfr0 = read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
>> +
>> +	/* If RME isn't supported, then RMI can't be */
>> +	if (cpuid_feature_extract_unsigned_field(aa64pfr0, ID_AA64PFR0_EL1_RME_SHIFT) == 0)
>> +		return -ENXIO;
>> +
>> +	arm_smccc_1_1_invoke(SMC_RMI_VERSION, host_version, &res);
>> +
>> +	if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
>> +		return -ENXIO;
>> +
>> +	version_major = RMI_ABI_VERSION_GET_MAJOR(res.a1);
>> +	version_minor = RMI_ABI_VERSION_GET_MINOR(res.a1);
>> +
>> +	if (res.a0 != RMI_SUCCESS) {
>> +		unsigned short high_version_major, high_version_minor;
>> +
>> +		high_version_major = RMI_ABI_VERSION_GET_MAJOR(res.a2);
>> +		high_version_minor = RMI_ABI_VERSION_GET_MINOR(res.a2);
>> +
>> +		pr_err("Unsupported RMI ABI (v%d.%d - v%d.%d) we want v%d.%d\n",
>> +		       version_major, version_minor,
>> +		       high_version_major, high_version_minor,
>> +		       RMI_ABI_MAJOR_VERSION,
>> +		       RMI_ABI_MINOR_VERSION);
>> +		return -ENXIO;
>> +	}
>> +
>> +	pr_info("RMI ABI version %d.%d\n", version_major, version_minor);
>> +
>> +	return 0;
>> +}
>> +
>> +static int __init arm64_init_rmi(void)
>> +{
>> +	/* Continue without realm support if we can't agree on a version */
>> +	if (rmi_check_version())
>> +		return 0;
>> +
>> +	if (WARN_ON(rmi_features(0, &rmm_feat_reg0)))
>> +		return 0;
>> +	if (WARN_ON(rmi_features(1, &rmm_feat_reg1)))
>> +		return 0;
>> +
>> +	return 0;
>> +}
>> +subsys_initcall(arm64_init_rmi);
> 
> Is there any reliance on this being executed before or after KVM's own
> initialisation? If so, this should be captured.

Yes I'm expecting this to be called before KVM's initialisation. 
kvm_init_rmi() alls rmi_is_available() to check if CCA is supported and 
only enables the KVM side of things if that check passes. So if the 
initialisation was the other way round then Realm guests would be 
unsupported. I'll add a comment

/*
 * Note arm64_init_rmi() must be called before kvm_init_rmi() otherwise KVM
 * will not support realm guests. subsys_initcall() is called before
 * module_init() (used for KVM) so this is OK.
 */

Thanks,
Steve
