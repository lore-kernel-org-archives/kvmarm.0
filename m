Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C5FB84A2614;
	Tue,  8 Sep 2026 09:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860981; cv=none; b=Bhm1rXxHIttpBQsGyL3XdwMUKwmf4baeuKhnuLGS2cPUg1xOfa6RUsDi0CEe9MsovWY9414HeyTJnElBgFyATr10eN8GMuyWH+atSuKVyVNkK9Oh7zMQHkr3c+u1E64xmsVE9hlha5QiQE1VCYvbwVJpSQlEjn7LJrZD4DHGCBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860981; c=relaxed/simple;
	bh=kJteEwoT3OdITFopCoesbDyojoKuGSBp7kslVKQdQY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pP6NtgRRq9TtGSCt9K+I7w86GwHeY007YOQeKCK1VXy48n70HIi8HQAgg3ikMZAVu1IWT6MvCqWc2unnjZ8EZZTHKQCBHzH/9+HC5FUKDtr86B2H5pFprWdezf9eCDdi1RaafQVUn0QulPuhvoxFYIS2XPdJhu4XYzyqxrYDzJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bnEijS8U; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bnEijS8U"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5AE741476;
	Tue,  8 Sep 2026 02:49:33 -0700 (PDT)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 685AE3F7B4;
	Tue,  8 Sep 2026 02:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1788860977; bh=kJteEwoT3OdITFopCoesbDyojoKuGSBp7kslVKQdQY0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=bnEijS8UoORGgws4/gA0W4HiONlIvwJMlSXD8OSU/r3dg/eT6i8+aRl9HfVheUaUS
	 jvbmdRo2tL2vQpBZlOOwEVT3bN917GE2o282Fo2hN0lkk+zG8H03BMgZ26A3d4piwM
	 cNK8rOVVEt5zZV461cpirSw+FvdQcp6Aynp4+T4M=
Message-ID: <7c8b3430-e233-486e-b4fd-3c1f5d05d97d@arm.com>
Date: Tue, 8 Sep 2026 10:49:32 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v17 2/7] firmware: arm_rmm: Check for RMI support at init
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: maz@kernel.org, will@kernel.org, catalin.marinas@arm.com,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 steven.price@arm.com, aneesh.kumar@kernel.org, oupton@kernel.org,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260907095942.1140734-1-suzuki.poulose@arm.com>
 <20260907095942.1140734-3-suzuki.poulose@arm.com>
 <25894d08-0fec-4dcd-9d5e-e8270ff9d26c@redhat.com>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <25894d08-0fec-4dcd-9d5e-e8270ff9d26c@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 08/09/2026 07:46, Gavin Shan wrote:
> Hi Suzuki,
> 
> On 9/7/26 7:59 PM, Suzuki K Poulose wrote:
>> From: Steven Price <steven.price@arm.com>
>>
>> Query the RMI version number and check if it is a compatible version.
>> The first two feature registers are read and exposed for future code to
>> use.
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>

...

>> diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/ 
>> arm_rmm/rmi.c
>> new file mode 100644
>> index 0000000000000..008a783407b4e
>> --- /dev/null
>> +++ b/drivers/firmware/arm_rmm/rmi.c
>> @@ -0,0 +1,101 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) 2023-2026 ARM Ltd.
>> + */
>> +
>> +#include <linux/cpufeature.h>
>> +#include <linux/memblock.h>
>> +#include <linux/arm-rmi-cmds.h>
>> +#include <linux/slab.h>
>> +
>> +#include <asm/memory.h>
>> +#include <asm/pgtable-hwdef.h>
>> +
>> +/* Currently only the first 2 registers are used by Linux */
>> +#define RMI_FEAT_REG_COUNT    2
>> +static __ro_after_init unsigned long 
>> rmi_feat_reg_cache[RMI_FEAT_REG_COUNT];
>> +
> 
> I would drop RMI_FEAT_REG_COUNT and use ARRAY_SIZE(rmi_feat_reg_cache) 
> in the code.
> Besides, __ro_after_init is usually put at the last the declaration.
> 
> static unsigned long rmi_feat_reg_cache[RMI_FEAT_REG_COUNT] 
> __ro_after_init;
> 
>> +unsigned long rmi_feat_reg(unsigned long id)
>> +{
>> +    if (WARN_ON(id >= RMI_FEAT_REG_COUNT))
>> +        return 0;
>> +
>> +    return rmi_feat_reg_cache[id];
>> +}
>> +EXPORT_SYMBOL_GPL(rmi_feat_reg);
>> +
> 
> I would suggest to rename 'id' to 'index' since it represents the feature
> register index instead of feature register ID.
> 
> unsigned long rmi_feat_reg(unsigned long index)
> {
>     :
> }
> EXPORT_SYMBOL_GPL(rmi_feat_reg);
> 


>> +/*
>> + * Note arm64_init_rmi() must be called before kvm_init_rmi() 
>> otherwise KVM
>> + * will not support realm guests. subsys_initcall() is called before
>> + * module_init() (used for KVM) so this is OK.
>> + */
>> +subsys_initcall(arm64_init_rmi);
>> diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
>> new file mode 100644
>> index 0000000000000..2fb1f7f86d71e

>> +static inline int rmi_features(unsigned long index, unsigned long *out)
>> +{
>> +    struct arm_smccc_res res;
>> +
>> +    arm_smccc_1_1_invoke(SMC_RMI_FEATURES, index, &res);
>> +
>> +    if (res.a0 == RMI_SUCCESS && out)
>> +        *out = res.a1;
>> +
>> +    return res.a0;
>> +}
>> +
> 
> We needn't expose rmi_features() through include/linux/arm-rmi-cmds.h 
> since it's
> used for once in rmi.c::rmi_read_features(). I would suggest to drop it 
> by combining
> the code with that function.

Thanks for the review, I will address them in the next version.

Cheers
Suzuki


