Return-Path: <SRS0=v2jq=2J=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F42AC2D0C0
	for <kvmarm@archiver.kernel.org>; Thu, 19 Dec 2019 11:59:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1E3392467B
	for <kvmarm@archiver.kernel.org>; Thu, 19 Dec 2019 11:59:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1E3392467B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 739D94A650;
	Thu, 19 Dec 2019 06:59:16 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5PGv3VEiOeTN; Thu, 19 Dec 2019 06:59:15 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C2D34A536;
	Thu, 19 Dec 2019 06:59:15 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A8CD4A4F7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Dec 2019 06:59:14 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oTax5mh0ZLSl for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Dec 2019 06:59:11 -0500 (EST)
Received: from huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A70974A49F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Dec 2019 06:59:11 -0500 (EST)
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.56])
 by Forcepoint Email with ESMTP id 271993F2B861E22293DF;
 Thu, 19 Dec 2019 19:59:08 +0800 (CST)
Received: from dggeme755-chm.china.huawei.com (10.3.19.101) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 19 Dec 2019 19:59:07 +0800
Received: from [127.0.0.1] (10.173.221.248) by dggeme755-chm.china.huawei.com
 (10.3.19.101) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 19
 Dec 2019 19:59:06 +0800
Subject: Re: [PATCH 2/5] KVM: arm64: Implement PV_LOCK_FEATURES call
To: Steven Price <steven.price@arm.com>
References: <20191217135549.3240-1-yezengruan@huawei.com>
 <20191217135549.3240-3-yezengruan@huawei.com>
 <20191217142848.GB38811@arm.com>
From: yezengruan <yezengruan@huawei.com>
Message-ID: <21910175-c89a-7a14-66a9-7b53d72a4543@huawei.com>
Date: Thu, 19 Dec 2019 19:59:04 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <20191217142848.GB38811@arm.com>
Content-Language: en-US
X-Originating-IP: [10.173.221.248]
X-ClientProxiedBy: dggeme712-chm.china.huawei.com (10.1.199.108) To
 dggeme755-chm.china.huawei.com (10.3.19.101)
X-CFilter-Loop: Reflected
Cc: "daniel.lezcano@linaro.org" <daniel.lezcano@linaro.org>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "maz@kernel.org" <maz@kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "virtualization@lists.linux-foundation.org"
 <virtualization@lists.linux-foundation.org>, Catalin
 Marinas <Catalin.Marinas@arm.com>,
 "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
 "will@kernel.org" <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
 "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Steve,

On 2019/12/17 22:28, Steven Price wrote:
> On Tue, Dec 17, 2019 at 01:55:46PM +0000, yezengruan@huawei.com wrote:
>> From: Zengruan Ye <yezengruan@huawei.com>
>>
>> This provides a mechanism for querying which paravirtualized lock
>> features are available in this hypervisor.
>>
>> Also add the header file which defines the ABI for the paravirtualized
>> lock features we're about to add.
>>
>> Signed-off-by: Zengruan Ye <yezengruan@huawei.com>
>> ---
>>  arch/arm64/include/asm/pvlock-abi.h | 16 ++++++++++++++++
>>  include/linux/arm-smccc.h           | 13 +++++++++++++
>>  virt/kvm/arm/hypercalls.c           |  3 +++
>>  3 files changed, 32 insertions(+)
>>  create mode 100644 arch/arm64/include/asm/pvlock-abi.h
>>
>> diff --git a/arch/arm64/include/asm/pvlock-abi.h b/arch/arm64/include/asm/pvlock-abi.h
>> new file mode 100644
>> index 000000000000..06e0c3d7710a
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/pvlock-abi.h
>> @@ -0,0 +1,16 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/*
>> + * Copyright(c) 2019 Huawei Technologies Co., Ltd
>> + * Author: Zengruan Ye <yezengruan@huawei.com>
>> + */
>> +
>> +#ifndef __ASM_PVLOCK_ABI_H
>> +#define __ASM_PVLOCK_ABI_H
>> +
>> +struct pvlock_vcpu_state {
>> +	__le64 preempted;
> 
> Somewhere we need to document when 'preempted' is. It looks like it's a
> 1-bit field from the later patches.

Good point, I'll document this in the pvlock doc.

> 
>> +	/* Structure must be 64 byte aligned, pad to that size */
>> +	u8 padding[56];
>> +} __packed;
>> +
>> +#endif
>> diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
>> index 59494df0f55b..59e65a951959 100644
>> --- a/include/linux/arm-smccc.h
>> +++ b/include/linux/arm-smccc.h
>> @@ -377,5 +377,18 @@ asmlinkage void __arm_smccc_hvc(unsigned long a0, unsigned long a1,
>>  			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
>>  			   0x21)
>>  
>> +/* Paravirtualised lock calls */
>> +#define ARM_SMCCC_HV_PV_LOCK_FEATURES				\
>> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
>> +			   ARM_SMCCC_SMC_64,			\
>> +			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
>> +			   0x40)
>> +
>> +#define ARM_SMCCC_HV_PV_LOCK_PREEMPTED				\
>> +	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
>> +			   ARM_SMCCC_SMC_64,			\
>> +			   ARM_SMCCC_OWNER_STANDARD_HYP,	\
>> +			   0x41)
>> +
>>  #endif /*__ASSEMBLY__*/
>>  #endif /*__LINUX_ARM_SMCCC_H*/
>> diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
>> index 550dfa3e53cd..ff13871fd85a 100644
>> --- a/virt/kvm/arm/hypercalls.c
>> +++ b/virt/kvm/arm/hypercalls.c
>> @@ -52,6 +52,9 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>>  		case ARM_SMCCC_HV_PV_TIME_FEATURES:
>>  			val = SMCCC_RET_SUCCESS;
>>  			break;
>> +		case ARM_SMCCC_HV_PV_LOCK_FEATURES:
>> +			val = SMCCC_RET_SUCCESS;
>> +			break;
> 
> Ideally you wouldn't report that PV_LOCK_FEATURES exists until the
> actual hypercalls are wired up to avoid breaking a bisect.

Thanks for pointing it out to me! I'll update the code.

> 
> Steve
> 
>>  		}
>>  		break;
>>  	case ARM_SMCCC_HV_PV_TIME_FEATURES:
>> -- 
>> 2.19.1
>>
>>
> 
> .
> 

Thanks,

Zengruan


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
