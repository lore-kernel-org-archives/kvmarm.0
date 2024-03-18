Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1C9A364A4;
	Mon, 18 Mar 2024 11:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710760966; cv=none; b=I7UaZ5QhvLQvzuulGwwlwPTVJcmhmwo2mOLbxXFT5laFi9LR4Ni2T90SAylIonVjRyZPcYbIhRAXUNxIirqUqP39DzmlXn35CdbcURnqdGrYmmp3rHSDOu+i0WHaekZMlR+Cy0WZZSg1lKRjaZtlzDmLmIsYcLntm3Oo2NJp2hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710760966; c=relaxed/simple;
	bh=/XlGRfj+bypUxiL/nVJQfK2Y04gmJmgRzWZLHLYUIPM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n4Razs/J/d4ZHPN03+cXz7kNICTlvS0t8CKdlHcBABNqqNBQYUGB5zmNZjA0ouZrBnZBUArmfq1BnozlDlOp+pqiAahWt8eMg7OdvrEMa2ae9BL9kVCit3yJxYLAPjI4Oicdq5FGsmkb4UctqHrfLmDan8oPmSkRTsB2ValOwbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3E50C106F;
	Mon, 18 Mar 2024 04:23:19 -0700 (PDT)
Received: from [10.57.12.69] (unknown [10.57.12.69])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DD3383F7CE;
	Mon, 18 Mar 2024 04:22:40 -0700 (PDT)
Message-ID: <9bd6668c-17c9-4fdf-ad06-3fd41814ba28@arm.com>
Date: Mon, 18 Mar 2024 11:22:41 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 04/28] arm64: RME: Check for RME support at KVM init
Content-Language: en-GB
To: Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112932.38045-1-steven.price@arm.com>
 <20230127112932.38045-5-steven.price@arm.com>
 <d5a1adac-d0d1-4eac-b5ad-b2b8f4d9d971@os.amperecomputing.com>
From: Steven Price <steven.price@arm.com>
In-Reply-To: <d5a1adac-d0d1-4eac-b5ad-b2b8f4d9d971@os.amperecomputing.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 18/03/2024 07:17, Ganapatrao Kulkarni wrote:
> 
> 
> On 27-01-2023 04:59 pm, Steven Price wrote:
>> Query the RMI version number and check if it is a compatible version. A
>> static key is also provided to signal that a supported RMM is available.
>>
>> Functions are provided to query if a VM or VCPU is a realm (or rec)
>> which currently will always return false.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_emulate.h | 17 ++++++++++
>>   arch/arm64/include/asm/kvm_host.h    |  4 +++
>>   arch/arm64/include/asm/kvm_rme.h     | 22 +++++++++++++
>>   arch/arm64/include/asm/virt.h        |  1 +
>>   arch/arm64/kvm/Makefile              |  3 +-
>>   arch/arm64/kvm/arm.c                 |  8 +++++
>>   arch/arm64/kvm/rme.c                 | 49 ++++++++++++++++++++++++++++
>>   7 files changed, 103 insertions(+), 1 deletion(-)
>>   create mode 100644 arch/arm64/include/asm/kvm_rme.h
>>   create mode 100644 arch/arm64/kvm/rme.c
>>

[...]

>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> new file mode 100644
>> index 000000000000..f6b587bc116e
>> --- /dev/null
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -0,0 +1,49 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2023 ARM Ltd.
>> + */
>> +
>> +#include <linux/kvm_host.h>
>> +
>> +#include <asm/rmi_cmds.h>
>> +#include <asm/virt.h>
>> +
>> +static int rmi_check_version(void)
>> +{
>> +    struct arm_smccc_res res;
>> +    int version_major, version_minor;
>> +
>> +    arm_smccc_1_1_invoke(SMC_RMI_VERSION, &res);
>> +
>> +    if (res.a0 == SMCCC_RET_NOT_SUPPORTED)
>> +        return -ENXIO;
>> +
>> +    version_major = RMI_ABI_VERSION_GET_MAJOR(res.a0);
>> +    version_minor = RMI_ABI_VERSION_GET_MINOR(res.a0);
>> +
>> +    if (version_major != RMI_ABI_MAJOR_VERSION) {
>> +        kvm_err("Unsupported RMI ABI (version %d.%d) we support %d\n",
> 
> Can we please replace "we support" to host supports.
> Also in the patch present in the repo, you are using variable
> our_version, can this be changed to host_version?

Sure, I do have a bad habit using "we" - thanks for point it out.

Steve

>> +            version_major, version_minor,
>> +            RMI_ABI_MAJOR_VERSION);
>> +        return -ENXIO;
>> +    }
>> +
>> +    kvm_info("RMI ABI version %d.%d\n", version_major, version_minor);
>> +
>> +    return 0;
>> +}
>> +
>> +int kvm_init_rme(void)
>> +{
>> +    if (PAGE_SIZE != SZ_4K)
>> +        /* Only 4k page size on the host is supported */
>> +        return 0;
>> +
>> +    if (rmi_check_version())
>> +        /* Continue without realm support */
>> +        return 0;
>> +
>> +    /* Future patch will enable static branch kvm_rme_is_available */
>> +
>> +    return 0;
>> +}
> 
> Thanks,
> Ganapat

