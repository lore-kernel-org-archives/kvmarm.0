Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 697B9486431;
	Mon, 21 Sep 2026 09:27:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789982879; cv=none; b=Gw8QlcKp0tF2DnL0JbnY1MlUxbqs93wE7atl8tLQwhOLTCUGXsWADla0UU21XqQdUmmlE5g4M2middO5/ON1+AEpkX9Ns7qlEDZbACcqqBVOU7yPZfIY1R6D2q5QQR0GolxF2CSdGTcN0DguZGMpgEIr7xhR7vq9mzqjtsw4t/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789982879; c=relaxed/simple;
	bh=ZTBtfMgrW8AVZtlxHjrB7je5cwXndDnFsVDtzCf5SAk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XTgg/QNgEeVZvtTZh6IifWAUQzGpiZMy0OJv5Gewq2Z8xoLTwCmDi9CsC1OoUBWu+N6RzY0+Cb7Axb/X9ORxwLJEwF5nKHX/zjarJ/L5BPlE6/b6p5ETrF1Gy0YWMqplLIJZB7lhbK3MUUN7POqzvsFL0ry859VTjF8TE+29VcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=TkC2tykb; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="TkC2tykb"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 98B4F1476;
	Mon, 21 Sep 2026 02:27:47 -0700 (PDT)
Received: from [10.0.128.141] (unknown [10.0.128.141])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D74603F86F;
	Mon, 21 Sep 2026 02:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789982871; bh=ZTBtfMgrW8AVZtlxHjrB7je5cwXndDnFsVDtzCf5SAk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TkC2tykbS6fuXOOVNsxlJt/ZCdRJVqaSv+ZbV/fy/dp/i/FCK5r7pviztK8PJrsmN
	 K5OUDt8Ib1Lkz4NnQEx7A4QnQ+0SH/pH/XRwppfJvtueM/pGYpy8q3aUtfoiwsuBNO
	 kc2IYVS2cwBgcv0sa8gPseAz1rwmBbj4wCSB5zwk=
Message-ID: <d7ccaf22-5bde-4344-8bf0-a5a17dcac0f3@arm.com>
Date: Mon, 21 Sep 2026 10:27:46 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 1/7] firmware: arm_rmm: Add SMC definitions for
 calling the RMM
Content-Language: en-GB
To: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.linux.dev, maz@kernel.org,
 will@kernel.org, catalin.marinas@arm.com, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, steven.price@arm.com,
 aneesh.kumar@kernel.org, oupton@kernel.org, gshan@redhat.com,
 joey.gouly@arm.com, tabba@google.com, yuzenghui@huawei.com,
 linux-coco@lists.linux.dev, gankulkarni@os.amperecomputing.com,
 sdonthineni@nvidia.com, alpergun@google.com, fj0570is@fujitsu.com,
 WeiLin.Chang@arm.com, lpieralisi@kernel.org, enju.kohei@fujitsu.com
References: <20260912083611.2513845-1-suzuki.poulose@arm.com>
 <20260912083611.2513845-2-suzuki.poulose@arm.com>
 <178978126540.2352296.16845657485139032765.b4-review@b4>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <178978126540.2352296.16845657485139032765.b4-review@b4>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 19/09/2026 02:27, Jonathan Cameron wrote:
>> The RMM (Realm Management Monitor) provides functionality that can be
>> accessed by SMC calls from the host.
>>
>> The SMC definitions are based on DEN0137[1] version 2.0-bet3
>>
>> [1] https://developer.arm.com/documentation/den0137/2-0bet3/
>>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
> 
> With Gavin's nitpicks and the GENMASK_ULL() from sashiko, just a few
> comments inline.  Mostly on subtle inconsistencies that really don't
> matter that much.
> 
>>   include/linux/arm-smccc-rmi.h | 497 ++++++++++++++++++++++++++++++++++
>>   1 file changed, 497 insertions(+)
>>   create mode 100644 include/linux/arm-smccc-rmi.h
>>
>> diff --git a/include/linux/arm-smccc-rmi.h b/include/linux/arm-smccc-rmi.h
>> new file mode 100644
>> index 000000000000..214d6228dfc2
>> --- /dev/null
>> +++ b/include/linux/arm-smccc-rmi.h
>> @@ -0,0 +1,497 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright (C) 2023-2026 ARM Ltd.
>> + *
>> + * The values and structures in this file are from the Realm Management Monitor
>> + * specification (DEN0137) version 2.0-bet3:
>> + * https://developer.arm.com/documentation/den0137/2-0bet3/
>> + */
>> +
>> +#ifndef __LINUX_ARM_SMCCC_RMI_H_
>> +#define __LINUX_ARM_SMCCC_RMI_H_
>> +
>> +#include <linux/arm-smccc.h>
>> +#include <linux/bitfield.h>
>> +#include <linux/bits.h>
>> +#include <linux/build_bug.h>
>> +#include <linux/sizes.h>
>> +
>> +#include <asm/page.h>
>> +
>> +#define SMC_RMI_CALL(func)				\
>> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,		\
>> +			   ARM_SMCCC_SMC_64,		\
>> +			   ARM_SMCCC_OWNER_STANDARD,	\
>> +			   (func))
> 
> Obviously it is v18 so probably a future thing but nothing about this
> is RMI specific.  Could be used for ARM_SMCCC_TRNG_RND64 for instance.
> I'm not entirely sure what we'd call such a macro
> 
> ARM_SMCCC_CALL_VAL64_STD() maybe?

ARM_SMCCC_STD_CALL64_VAL() ?

But, I would leave it as a wider cleanup in the tree as a separate
series.

> 
> I'm not just not keen on macros whose names to me hint at something
> special. FWIW this also matches SMC_RSI_FID() and FFA_SMC64().
> Isn't it nice when we have a predictable naming scheme :)
> 
> FID (for Function IDentifier) is in the spec, so maybe?
> 
> Anyhow, I don't really care that much.
> 
>> +
>> +#define SMC_RMI_VERSION				SMC_RMI_CALL(0x0150)
>> +
> 
> 
>> +#define RMI_ABI_MAJOR_VERSION	2
>> +#define RMI_ABI_MINOR_VERSION	0
>> +
>> +#define RMI_ABI_VERSION_GET_MAJOR(version) ((version) >> 16)
> 
> I'd mask it.  Mostly because that would shout that it is only 15 bits.
> 

Ack

>> +#define RMI_ABI_VERSION_GET_MINOR(version) ((version) & 0xFFFF)
>> +#define RMI_ABI_VERSION(major, minor)      (((major) << 16) | (minor))
> 
> I'd go all in on FIELD_PREP() / FIELD_GET() + GENMASK just for the
> sake of consistency + not having to be careful that everything is
> checked for fit to keep the LLM bots happy.
> 
>> +
>> +#define RMI_RETURN_STATUS_MASK		GENMASK(7, 0)
>> +#define RMI_RETURN_INDEX_MASK		GENMASK(15, 8)
>> +#define RMI_RETURN_MEMREQ_MASK		GENMASK(9, 8)
>> +#define RMI_RETURN_CAN_CANCEL_MASK	BIT(10)
>> +
>> +#define RMI_RETURN_STATUS(ret)		FIELD_GET(RMI_RETURN_STATUS_MASK, ret)
>> +#define RMI_RETURN_INDEX(ret)		FIELD_GET(RMI_RETURN_INDEX_MASK, ret)
> 
> What's this one?  I can't find anything in the spec that matches it
> and as far as I can tell you don't use it in this series.

This is coming from RmiResultDataLevel. See RmiResult type.
This was renamed after we introduce the RmiResultDataIncomplete.
It is used in the KVM code to find the "level" where a command
failed/walked.

I could rename it to RMI_RESULT_DATA_LEVEL() ?
Similarly RMI_RESULT_STATUS instead of RMI_RETURN_*

> 
>> +#define RMI_RETURN_MEMREQ(ret)		FIELD_GET(RMI_RETURN_MEMREQ_MASK, ret)
>> +#define RMI_RETURN_CAN_CANCEL(ret)	FIELD_GET(RMI_RETURN_CAN_CANCEL_MASK, ret)

> These are obscure enough to find in the spec I'd give a comment just
> to save the sanity of anyone looking for them.

As above, they are really RMI_RESULT_DATA_INCOMPLETE_*

> 
>> +/*
>> + * Note many of these fields are smaller than u64 but all fields have u64
>> + * alignment, so use u64 to ensure correct alignment.
> 
> Obviously this is only going to run on arm64 so it's not critical, but
> more generally u64s aren't always 64 bit aligned.  So if you 'really'
> care aligned_u64 is there to ensure it.  Meh, arm64 so fine.

Agreed, I am worried about the churn in the consumer code. Also, like
you said, this is only for ARM64. So, I would pass it.

> 
>> + */
>> +struct rmm_config {
>> +	union { /* 0x0 */
>> +		struct {
>> +			u64 tracking_region_size;
>> +			u64 rmi_granule_size;
>> +		};
>> +		u8 sizer[SZ_4K];
>> +	};
>> +};
>> +
>> +static_assert(sizeof(struct rmm_config) == SZ_4K);
>> +
>> +#define RMI_REALM_PARAM_FLAG_SVE		BIT(1)
>> +#define RMI_REALM_PARAM_FLAG_PMU		BIT(2)
>> +#define RMI_REALM_PARAM_FLAG_DA			BIT(3)
>> +#define RMI_REALM_PARAM_FLAG_LFA_POLICY		GENMASK(6, 5)
>> +#define RMI_REALM_PARAM_FLAG_MEC_POLICY		GENMASK(8, 7)
> 
> Tiny bit inconsistent. When do you decide _MASK is needed and when
> not?  Seems a little too random for multibit fields.

I will try to clean this up.

>> +
>> +struct rec_params {
>> +	union { /* 0x0 */
>> +		u64 flags;
>> +		u8 padding0[0x100];
>> +	};
>> +	union { /* 0x100 */
>> +		u64 mpidr;
>> +		u8 padding1[0x100];
>> +	};
>> +	union { /* 0x200 */
>> +		u64 pc;
>> +		u8 padding2[0x100];
>> +	};
>> +	union { /* 0x300 */
>> +		u64 gprs[REC_CREATE_NR_GPRS];
>> +		u8 padding3[0xd00];
>> +	};
>> +};
>> +
>> +static_assert(sizeof(struct rec_params) == SZ_4K);
> Whilst the assert works and is need to prevent oversized the
> dos never seem to provide any indication of the final trailing
> padding other than indirectly and I don't like maths on Fridays ;).

Agree it is a bit obscure, but ...

> Maybe union the inner union set with a u8 [SZ_4K]?
> 

That doesn't help if the other one runs past SZ_4K ?

>> +
>> +struct rec_exit {
>> +	union { /* 0x000 */
>> +		u8 exit_reason;
>> +		u8 padding0[0x100];
>> +	};
>> +	union { /* 0x100 */
>> +		struct {
>> +			u64 esr;
>> +			u64 far;
>> +			u64 hpfar;
>> +			u64 rtt_tree;
>> +		};
>> +		u8 padding1[0x100];
>> +	};
>> +	union { /* 0x200 */
>> +		u64 gprs[REC_RUN_GPRS];
>> +		u8 padding2[0x100];
>> +	};
>> +	union { /* 0x300 */
>> +		u8 padding3[0x100];
> 
> Why does this one exist rather than padding above
> by 0x200?  Other structures don't seem to keep
> to a specific stride so I'm not sure what this gives
> you here.


That looks like a field was removed over the RMM spec iterations.
I will fold this into the padding above.

> 
>> +	};
>> +	union { /* 0x400 */
>> +		struct {
>> +			u64 cntp_ctl;
>> +			u64 cntp_cval;
>> +			u64 cntv_ctl;
>> +			u64 cntv_cval;
>> +		};
>> +		u8 padding4[0x100];
>> +	};
>> +	union { /* 0x500 */
>> +		struct {
>> +			u64 ripas_base;
>> +			u64 ripas_top;
>> +			u8 ripas_value;
>> +			u8 padding5[0xf];
> 
> In various other places you just use a u64 for a u8
> + padding. Why is this one special? And for that matter
> various other fields later in this particular structure?

Please feel free to point out, if you spot any. I am happy
to fix them.

> 
>> +			u64 s2ap_base;
>> +			u64 s2ap_top;
>> +			u64 vdev_id_1;
>> +			u64 vdev_id_2;
>> +			u64 dev_mem_base;
>> +			u64 dev_mem_top;
>> +			u64 dev_mem_pa;
>> +		};
>> +		u8 padding6[0x100];
>> +	};
>> +	union { /* 0x600 */
>> +		struct {
>> +			u16 imm;
>> +			u8 padding7[0x6];
>> +			u64 plane;
>> +		};
>> +		u8 padding8[0x100];
>> +	};
>> +	union { /* 0x700 */
>> +		struct {
>> +			u8 pmu_ovf_status;
>> +			u8 padding9[0xf];
>> +			u64 vsmmu;
>> +		};
>> +		u8 padding10[0x100];
>> +	};
>> +};
>> +
>> +static_assert(sizeof(struct rec_exit) == SZ_2K);
> 
>> +
>> +/* RMI_RTT_UNPROT_MAP_FLAGS definitions */
> 
> How this counts as a 'flags' field is slightly beyond me, but
> indeed matches the spec naming even though it's a grab bag
> of small fields...
> 
>> +#define RMI_RTT_UNPROT_MAP_FLAGS_OADDR_TYPE	GENMASK(1, 0)
>> +#define RMI_RTT_UNPROT_MAP_FLAGS_LIST_COUNT	GENMASK(15, 2)
>> +#define RMI_RTT_UNPROT_MAP_FLAGS_MEMATTR	GENMASK(18, 16)
>> +#define RMI_RTT_UNPROT_MAP_FLAGS_S2AP		GENMASK(22, 19)
> 
> Nothing signficant enough in here to absolutely require changes so
> Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>

Thanks

Suzuki


> 

