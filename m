Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB538C43464
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 09:26:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 67C3721D43
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 09:26:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67C3721D43
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 03A384B351;
	Fri, 18 Sep 2020 05:26:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aBALuoks31AK; Fri, 18 Sep 2020 05:26:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EC3994B3A7;
	Fri, 18 Sep 2020 05:26:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D6764B3D0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 05:26:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BfyXEAck1m2K for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 05:26:42 -0400 (EDT)
Received: from huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 745904B392
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 05:26:42 -0400 (EDT)
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.54])
 by Forcepoint Email with ESMTP id 7F36C44C79EC4DF2539F;
 Fri, 18 Sep 2020 17:26:40 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 18 Sep 2020 17:26:38 +0800
Received: from [10.174.185.187] (10.174.185.187) by
 dggema765-chm.china.huawei.com (10.1.198.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 18 Sep 2020 17:26:38 +0800
Subject: Re: [RFC v2 6/7] kvm: arm64: make ID registers configurable
To: Andrew Jones <drjones@redhat.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-7-liangpeng10@huawei.com>
 <20200918075039.36eezfwbsiearq3h@kamzik.brq.redhat.com>
From: Peng Liang <liangpeng10@huawei.com>
Message-ID: <96d2155f-6ba8-6eee-8eff-354c026232f3@huawei.com>
Date: Fri, 18 Sep 2020 17:26:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918075039.36eezfwbsiearq3h@kamzik.brq.redhat.com>
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

On 9/18/2020 3:50 PM, Andrew Jones wrote:
> On Thu, Sep 17, 2020 at 08:01:00PM +0800, Peng Liang wrote:
>> It's time to make ID registers configurable.  When userspace (but not
>> guest) want to set the values of ID registers, save the value in
>> sysreg file so that guest can read the modified values.
>>
>> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
>> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 16 +++++++++-------
>>  1 file changed, 9 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index a642ecfebe0a..881b66494524 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1263,10 +1263,6 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
>>  
>>  /*
>>   * cpufeature ID register user accessors
>> - *
>> - * For now, these registers are immutable for userspace, so no values
>> - * are stored, and for set_id_reg() we don't allow the effective value
>> - * to be changed.
>>   */
>>  static int __get_id_reg(struct kvm_vcpu *vcpu,
>>  			const struct sys_reg_desc *rd, void __user *uaddr,
>> @@ -1290,9 +1286,15 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
>>  	if (err)
>>  		return err;
>>  
>> -	/* This is what we mean by invariant: you can't change it. */
>> -	if (val != read_id_reg(vcpu, rd, raz))
>> -		return -EINVAL;
>> +	if (raz) {
>> +		if (val != read_id_reg(vcpu, rd, raz))
> 
> val != 0 ?

Thanks for you advise.  It will make it much clearer.  I'll change it in next
version.

Thanks,
Peng

> 
>> +			return -EINVAL;
>> +	} else {
>> +		u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
>> +				     (u32)rd->CRm, (u32)rd->Op2);
>> +		/* val should be checked in check_user */
> 
> It really doesn't make sense to share this trivial set_user function and
> have different check functions. Just don't share the set_user function.
> 
>> +		__vcpu_sys_reg(vcpu, ID_REG_INDEX(reg_id)) = val;
>> +	}
>>  
>>  	return 0;
>>  }
>> -- 
>> 2.26.2
>>
> 
> Thanks,
> drew
> 
> .
>
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
