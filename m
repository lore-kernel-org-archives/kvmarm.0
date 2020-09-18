Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D563C43465
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 11:58:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B2B8921582
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 11:58:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B2B8921582
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A0F84B21E;
	Fri, 18 Sep 2020 07:58:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id B5izWXCzKCNo; Fri, 18 Sep 2020 07:58:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07CC64B232;
	Fri, 18 Sep 2020 07:58:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E54254B21E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 07:58:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GveUuj17DJVy for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 07:58:50 -0400 (EDT)
Received: from huawei.com (szxga01-in.huawei.com [45.249.212.187])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B4C174B21D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 07:58:49 -0400 (EDT)
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.56])
 by Forcepoint Email with ESMTP id D749BC943E32EEFBD62F;
 Fri, 18 Sep 2020 19:58:44 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 18 Sep 2020 19:58:44 +0800
Received: from [10.174.185.187] (10.174.185.187) by
 dggema765-chm.china.huawei.com (10.1.198.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 18 Sep 2020 19:58:44 +0800
Subject: Re: [RFC v2 1/7] arm64: add a helper function to traverse
 arm64_ftr_regs
To: Andrew Jones <drjones@redhat.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-2-liangpeng10@huawei.com>
 <20200918071820.e6hghta4yclio7ca@kamzik.brq.redhat.com>
 <00293b67-e9bb-3ad1-d6db-adb35bcacba6@huawei.com>
 <20200918102808.gwpk6ggy36prq7iv@kamzik.brq.redhat.com>
From: Peng Liang <liangpeng10@huawei.com>
Message-ID: <a0960559-ff81-cb30-ffa1-4ed1cdae65e7@huawei.com>
Date: Fri, 18 Sep 2020 19:58:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918102808.gwpk6ggy36prq7iv@kamzik.brq.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.187]
X-ClientProxiedBy: dggeme714-chm.china.huawei.com (10.1.199.110) To
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

On 9/18/2020 6:28 PM, Andrew Jones wrote:
> On Fri, Sep 18, 2020 at 05:24:27PM +0800, Peng Liang wrote:
>> On 9/18/2020 3:18 PM, Andrew Jones wrote:
>>> On Thu, Sep 17, 2020 at 08:00:55PM +0800, Peng Liang wrote:
>>>> If we want to emulate ID registers, we need to initialize ID registers
>>>> firstly.  This commit is to add a helper function to traverse
>>>> arm64_ftr_regs so that we can initialize ID registers from
>>>> arm64_ftr_regs.
>>>>
>>>> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
>>>> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
>>>> ---
>>>>  arch/arm64/include/asm/cpufeature.h |  2 ++
>>>>  arch/arm64/kernel/cpufeature.c      | 13 +++++++++++++
>>>>  2 files changed, 15 insertions(+)
>>>>
>>>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>>>> index 89b4f0142c28..2ba7c4f11d8a 100644
>>>> --- a/arch/arm64/include/asm/cpufeature.h
>>>> +++ b/arch/arm64/include/asm/cpufeature.h
>>>> @@ -79,6 +79,8 @@ struct arm64_ftr_reg {
>>>>  
>>>>  extern struct arm64_ftr_reg arm64_ftr_reg_ctrel0;
>>>>  
>>>> +int arm64_cpu_ftr_regs_traverse(int (*op)(u32, u64, void *), void *argp);
>>>> +
>>>>  /*
>>>>   * CPU capabilities:
>>>>   *
>>>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>>>> index 6424584be01e..698b32705544 100644
>>>> --- a/arch/arm64/kernel/cpufeature.c
>>>> +++ b/arch/arm64/kernel/cpufeature.c
>>>> @@ -1112,6 +1112,19 @@ u64 read_sanitised_ftr_reg(u32 id)
>>>>  	return regp->sys_val;
>>>>  }
>>>>  
>>>> +int arm64_cpu_ftr_regs_traverse(int (*op)(u32, u64, void *), void *argp)
>>>> +{
>>>> +	int i, ret;
>>>> +
>>>> +	for (i = 0; i <  ARRAY_SIZE(arm64_ftr_regs); i++) {
>>>> +		ret = (*op)(arm64_ftr_regs[i].sys_id,
>>>> +			    arm64_ftr_regs[i].reg->sys_val, argp);
>>>> +		if (ret < 0)
>>>> +			return ret;
>>>> +	}
>>>> +	return 0;
>>>> +}
>>>> +
>>>>  #define read_sysreg_case(r)	\
>>>>  	case r:		return read_sysreg_s(r)
>>>>  
>>>> -- 
>>>> 2.26.2
>>>>
>>>
>>> Skimming the rest of the patches to see how this is used I only saw a
>>> single callsite. Why wouldn't we just put this simple for-loop right
>>> there at that callsite? Or, IOW, I think this traverse function should
>>> be dropped.
>>>
>>> Thanks,
>>> drew
>>>
>>> .
>>>
>>
>> arm64_ftr_regs is defined as a static array in arch/arm64/kernel/cpufeature.c,
>> which is not a virtualization-related file.  Putting this simple for-loop
>> right there will make cpufeature.c depend on kvm_host.h.  Is this a good idea?
> 
> Well, the fact that arm64_ftr_regs is static to cpufeature.c is a clue
> that your implementation is likely playing with internal arm64_ftr
> state that it shouldn't be. If there's not an accessor function that
> works for you, then you can try adding one. Providing general functions
> like this, that are effectively just an odd way of removing 'static'
> from arm64_ftr_regs, breaks the encapsulation.
> 
> Thanks,
> drew
> 
> .
> 

I found get_arm64_ftr_reg_nowarn and get_arm64_ftr_reg in cpufeature.c which will
search and return the arm64_ftr_reg* according to the sys_id.  But they are all
static.  Hence, I think cpufeature.c don't want other modules to access the
arm64_ftr_reg*.  So I add arm64_cpu_ftr_regs_traverse to traverse the
arm64_ftr_regs and pass the id and value to op instead of the arm64_ftr_reg*.

Thanks,
Peng
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
