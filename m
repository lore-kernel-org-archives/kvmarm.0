Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38260C43463
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 09:26:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B1E4F23119
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 09:26:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1E4F23119
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 419F14B349;
	Fri, 18 Sep 2020 05:26:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id FtbaPTCE+Jts; Fri, 18 Sep 2020 05:26:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DBA14B3D0;
	Fri, 18 Sep 2020 05:26:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 485EE4B378
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 05:26:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fswh7afX5J5R for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 05:26:46 -0400 (EDT)
Received: from huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3592B4B392
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 05:26:46 -0400 (EDT)
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.56])
 by Forcepoint Email with ESMTP id 96306FBB3AA04035DFB0;
 Fri, 18 Sep 2020 17:26:43 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 18 Sep 2020 17:26:43 +0800
Received: from [10.174.185.187] (10.174.185.187) by
 dggema765-chm.china.huawei.com (10.1.198.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 18 Sep 2020 17:26:43 +0800
Subject: Re: [RFC v2 7/7] kvm: arm64: add KVM_CAP_ARM_CPU_FEATURE extension
To: Andrew Jones <drjones@redhat.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-8-liangpeng10@huawei.com>
 <20200918075518.cbpjb3iswyj3lcym@kamzik.brq.redhat.com>
From: Peng Liang <liangpeng10@huawei.com>
Message-ID: <27a8bd74-c85a-81e8-0c9c-1385c246e07a@huawei.com>
Date: Fri, 18 Sep 2020 17:26:42 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918075518.cbpjb3iswyj3lcym@kamzik.brq.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.187]
X-ClientProxiedBy: dggeme713-chm.china.huawei.com (10.1.199.109) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected
Cc: zhang.zhanghailiang@huawei.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On 9/18/2020 3:55 PM, Andrew Jones wrote:
> On Thu, Sep 17, 2020 at 08:01:01PM +0800, Peng Liang wrote:
>> Add KVM_CAP_ARM_CPU_FEATURE extension for userpace to check whether KVM
>> supports to set CPU features in AArch64.
>>
>> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
>> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
>> ---
>>  Documentation/virt/kvm/api.rst | 8 ++++++++
>>  arch/arm64/kvm/arm.c           | 1 +
>>  include/uapi/linux/kvm.h       | 1 +
>>  3 files changed, 10 insertions(+)
>>
>> diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
>> index d2b733dc7892..50214ed8f50e 100644
>> --- a/Documentation/virt/kvm/api.rst
>> +++ b/Documentation/virt/kvm/api.rst
>> @@ -6173,3 +6173,11 @@ specific interfaces must be consistent, i.e. if one says the feature
>>  is supported, than the other should as well and vice versa.  For arm64
>>  see Documentation/virt/kvm/devices/vcpu.rst "KVM_ARM_VCPU_PVTIME_CTRL".
>>  For x86 see Documentation/virt/kvm/msr.rst "MSR_KVM_STEAL_TIME".
>> +
>> +8.25 KVM_CAP_ARM_CPU_FEATURE
>> +-----------------------------------
> 
> Too many '----'
> 
>> +
>> +:Architecture: arm64
>> +
>> +This capability indicates that userspace can modify the ID registers via
>> +KVM_SET_ONE_REG ioctl.
> 
> You should say something like "See KVM_SET_ONE_REG:ARM64 ID Registers"
> here and also extend the "KVM_SET_ONE_REG" section with a "ARM64 ID
> Register" section that describes the limits and return values.
> 
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 6d961e192268..918a7a56b224 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -178,6 +178,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>  	case KVM_CAP_ARM_IRQ_LINE_LAYOUT_2:
>>  	case KVM_CAP_ARM_NISV_TO_USER:
>>  	case KVM_CAP_ARM_INJECT_EXT_DABT:
>> +	case KVM_CAP_ARM_CPU_FEATURE:
>>  		r = 1;
>>  		break;
>>  	case KVM_CAP_ARM_SET_DEVICE_ADDR:
>> diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
>> index 7d8eced6f459..12356beadd5a 100644
>> --- a/include/uapi/linux/kvm.h
>> +++ b/include/uapi/linux/kvm.h
>> @@ -1037,6 +1037,7 @@ struct kvm_ppc_resize_hpt {
>>  #define KVM_CAP_SMALLER_MAXPHYADDR 185
>>  #define KVM_CAP_S390_DIAG318 186
>>  #define KVM_CAP_STEAL_TIME 187
>> +#define KVM_CAP_ARM_CPU_FEATURE 188
>>  
>>  #ifdef KVM_CAP_IRQ_ROUTING
>>  
>> -- 
>> 2.26.2
>>
> 
> Thanks,
> drew
> 
> .
> 

Thank you for your advise.  I'll change them in next version.

Thanks,
Peng
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
