Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF06F4CC600;
	Tue, 13 Oct 2026 09:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791885517; cv=none; b=ItC1zbe0G9HD0oF5sw9gS242O7VCVUfUAX+dJSMr3izrSIYwXDHGBkWVEe3ungCWBES5WIPSjsp2LuRae8K8kmqkqT+vQFM1/qvJj4ZbVUbN4oPxq+DE6wbjb68E4mWDAGlBwrBXYrDq0MXznaH94cAZa0t1nd9tVnfvovIkl98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791885517; c=relaxed/simple;
	bh=YXnRSTWAU7IyxFtbn+qxY3qd2/8gPBY2gi/t/qkHSRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ii88/49rBzQrl54Wk4OPQr/kEf+grMPwwvdLGwyPTFVkgTq4B5uEGv1yL5eRwWhcSvfVMkWPyQvcRvkdF3JbjSAjpSB/XHiYfoP+dyaWkdKs18hzQbVK6nhrwJQE3T4hdvhRPM1X4rEONkvkz/JhIE6Spnrrkn/l8ria2Y99/Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=gyrI4p+h; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="gyrI4p+h"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E5801169C;
	Tue, 13 Oct 2026 02:58:30 -0700 (PDT)
Received: from [10.0.128.125] (Suzukis-MBP.cambridge.arm.com [10.0.128.125])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 587BB3F7B4;
	Tue, 13 Oct 2026 02:58:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791885514; bh=YXnRSTWAU7IyxFtbn+qxY3qd2/8gPBY2gi/t/qkHSRE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gyrI4p+h+rg7F7KzN+FY9x9PiD8fijVdOLYuXXJRTseA4OxfHLYYokao4JrlWWDYc
	 b7TYUZxc1LcIIzSY473gSneYG1BQKVdJSIpkJWp2/mAll6ueBdVaaSiIzgjq0dfLc6
	 n/vn/bnmlNaqC9t2P2EbLNHqMRTHnuTppuDBHw80=
Message-ID: <8be050e3-8af1-4f04-902f-9bc01b209dd0@arm.com>
Date: Tue, 13 Oct 2026 10:58:29 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v22 02/10] firmware: arm_rmm: Check for RMI support at
 init
Content-Language: en-GB
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com,
 sudeep.holla@arm.com, jonathan.cameron@oss.qualcomm.com
References: <20261002061507.1600269-1-suzuki.poulose@arm.com>
 <20261002061507.1600269-3-suzuki.poulose@arm.com>
 <2586e689-c27d-4e4c-8c69-03e24259cb96@redhat.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <2586e689-c27d-4e4c-8c69-03e24259cb96@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 13/10/2026 04:53, Gavin Shan wrote:
> Hi Suzuki,
> 
> On 10/2/26 4:14 PM, Suzuki K Poulose wrote:
>> From: Steven Price <steven.price@arm.com>
>>
>> Query the RMI version number and check if it is a compatible version.
>> All RMM feature registers are read and exposed for future code to
>> use. Also restrict the support to SMC conduit.
>>
>> We only support this for Little Endian kernels, the Big Endian kernel
>> support is anyway marked BROKEN and is being removed.
>>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Oliver Upton <oupton@kernel.org>
>> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
>> Tested-by: Gavin Shan <gshan@redhat.com>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> ---
> 
> [...]
> 
>> ---
>>   MAINTAINERS                       |   2 +
>>   arch/arm64/Kconfig                |   1 +
>>   arch/arm64/kernel/cpufeature.c    |   1 +
>>   arch/arm64/kvm/sys_regs.c         |   2 +
>>   drivers/firmware/Kconfig          |   1 +
>>   drivers/firmware/Makefile         |   1 +
>>   drivers/firmware/arm_rmm/Kconfig  |  25 +++++++
>>   drivers/firmware/arm_rmm/Makefile |   1 +
>>   drivers/firmware/arm_rmm/rmi.c    | 112 ++++++++++++++++++++++++++++++
>>   include/linux/arm-rmi-cmds.h      |  48 +++++++++++++
>>   10 files changed, 194 insertions(+)
>>   create mode 100644 drivers/firmware/arm_rmm/Kconfig
>>   create mode 100644 drivers/firmware/arm_rmm/Makefile
>>   create mode 100644 drivers/firmware/arm_rmm/rmi.c
>>   create mode 100644 include/linux/arm-rmi-cmds.h
>>
> 
> [...]
> 
>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/ 
>> arm_rmm/rmi.c
>> new file mode 100644
>> index 0000000000000..06f5392c982d2
>> --- /dev/null
>> +++ b/drivers/firmware/arm_rmm/rmi.c
>> @@ -0,0 +1,112 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2023-2026 ARM Ltd.
>> + */
>> +
>> +#include <linux/arm-rmi-cmds.h>
>> +#include <linux/cpufeature.h>
>> +#include <linux/memblock.h>
>> +#include <linux/slab.h>
>> +
>> +#include <asm/memory.h>
>> +#include <asm/pgtable-hwdef.h>
>> +
>> +/* RMM v2.0 defines RmiFeatureRegister0 to RmiFeatureRegister4. */
>> +static unsigned long rmi_feat_reg_cache[5] __ro_after_init;
>> +
>> +static int rmi_check_version(void)
>> +{
>> +    unsigned short version_major, version_minor;
>> +    unsigned long host_version = RMI_ABI_VERSION(RMI_ABI_MAJOR_VERSION,
>> +                             RMI_ABI_MINOR_VERSION);
>> +    unsigned long aa64pfr0 = 
>> read_sanitised_ftr_reg(SYS_ID_AA64PFR0_EL1);
>> +    struct arm_smccc_1_2_regs res = {
>> +        SMC_RMI_VERSION, host_version,
>> +    };
>> +
>> +    /* If RME isn't supported, then RMI can't be */
>> +    if (cpuid_feature_extract_unsigned_field(aa64pfr0, 
>> ID_AA64PFR0_EL1_RME_SHIFT) == 0)
>> +        return -ENXIO;
>> +
>> +    if (arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_SMC)
>> +        return -ENXIO;
> 
> I think we need to ensure SMCCC version is v1.2 or a newer one here? 
> arm_smccc_1_2_smc()
> is immediately called by rmi_smccc_invoke() after this check.
> 
>      if (arm_smccc_1_1_get_conduit() != SMCCC_CONDUIT_SMC ||
>              arm_smccc_get_version() < ARM_SMCCC_VERSION_1_2)

We could. But I am wondering if that adds any value ? If the RMM
exists and responds to the RMI_ABI_VERSION, it must be so on a
platform with v1.2 or greater ? The extra check doesn't hurt.

Suzuki

>          return -ENXIO;
> 
> Thanks,
> Gavin
> 
>> +
>> +    rmi_smccc_invoke(&res);
>> +    if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
>> +        return -ENXIO;
>> +
>> +    version_major = RMI_ABI_VERSION_GET_MAJOR(res.a1);
>> +    version_minor = RMI_ABI_VERSION_GET_MINOR(res.a1);
>> +
>> +    if (res.a0 != RMI_SUCCESS) {
>> +        unsigned short high_version_major, high_version_minor;
>> +
>> +        high_version_major = RMI_ABI_VERSION_GET_MAJOR(res.a2);
>> +        high_version_minor = RMI_ABI_VERSION_GET_MINOR(res.a2);
>> +
>> +        pr_err("Unsupported RMI ABI (v%d.%d - v%d.%d) we want v%d.%d\n",
>> +               version_major, version_minor,
>> +               high_version_major, high_version_minor,
>> +               RMI_ABI_MAJOR_VERSION,
>> +               RMI_ABI_MINOR_VERSION);
>> +        return -ENXIO;
>> +    }
>> +
>> +    pr_info("RMI ABI version %d.%d\n", version_major, version_minor);
>> +
>> +    return 0;
>> +}
>> +
> 
> [...]
> 
> 
> 

