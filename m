Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A692C43463
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 09:26:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8C55521973
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 09:26:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C55521973
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A288E4B3C3;
	Fri, 18 Sep 2020 05:25:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EKZNzZbs5f0a; Fri, 18 Sep 2020 05:25:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C8D84B392;
	Fri, 18 Sep 2020 05:25:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EFD24B392
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 05:25:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ESCus-ENAMGM for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 05:25:56 -0400 (EDT)
Received: from huawei.com (szxga03-in.huawei.com [45.249.212.189])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 15CB04B33E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 05:25:56 -0400 (EDT)
Received: from DGGEMM405-HUB.china.huawei.com (unknown [172.30.72.56])
 by Forcepoint Email with ESMTP id 31595E1EE9293CD5A916;
 Fri, 18 Sep 2020 17:25:53 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 DGGEMM405-HUB.china.huawei.com (10.3.20.213) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 18 Sep 2020 17:25:52 +0800
Received: from [10.174.185.187] (10.174.185.187) by
 dggema765-chm.china.huawei.com (10.1.198.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 18 Sep 2020 17:25:52 +0800
Subject: Re: [RFC v2 4/7] kvm: arm64: introduce check_user
To: Andrew Jones <drjones@redhat.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-5-liangpeng10@huawei.com>
 <20200918074135.67ahnd6rlh7db3is@kamzik.brq.redhat.com>
From: Peng Liang <liangpeng10@huawei.com>
Message-ID: <20569744-7467-456f-3027-64d71d7c0b0c@huawei.com>
Date: Fri, 18 Sep 2020 17:25:51 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918074135.67ahnd6rlh7db3is@kamzik.brq.redhat.com>
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

On 9/18/2020 3:41 PM, Andrew Jones wrote:
> On Thu, Sep 17, 2020 at 08:00:58PM +0800, Peng Liang wrote:
>> Currently, if we need to check the value of the register defined by user
>> space, we should check it in set_user.  However, some system registers
>> may use the same set_user (for example, almost all ID registers), which
>> make it difficult to validate the value defined by user space.
> 
> If sharing set_user no longer makes sense for ID registers, then we need
> to rework the code so it's no longer shared. As I keep saying, we need
> to address this problem one ID register at a time. So, IMO, the approach
> should be to change one ID register at a time from using ID_SANITISED()
> to having its own table entry with its own set/get_user code. There may
> still be opportunity to share code among the ID registers, in which case
> refactoring can be done as needed too.
> 
> Thanks,
> drew
> 

Thank you for your advise.  Currently, the implementation is a little dirty.
Removing the shared set_user of ID registers should make it clean.  I will
refactor the code to make it in next version.

Thanks,
Peng

>>
>> Introduce check_user to solve the problem.  And apply check_user before
>> set_user to make sure that the value of register is valid.
>>
>> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
>> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 7 +++++++
>>  arch/arm64/kvm/sys_regs.h | 6 ++++++
>>  2 files changed, 13 insertions(+)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 2b0fa8d5ac62..86ebb8093c3c 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -2684,6 +2684,7 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>>  {
>>  	const struct sys_reg_desc *r;
>>  	void __user *uaddr = (void __user *)(unsigned long)reg->addr;
>> +	int err;
>>  
>>  	if ((reg->id & KVM_REG_ARM_COPROC_MASK) == KVM_REG_ARM_DEMUX)
>>  		return demux_c15_set(reg->id, uaddr);
>> @@ -2699,6 +2700,12 @@ int kvm_arm_sys_reg_set_reg(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg
>>  	if (sysreg_hidden_from_user(vcpu, r))
>>  		return -ENOENT;
>>  
>> +	if (r->check_user) {
>> +		err = (r->check_user)(vcpu, r, reg, uaddr);
>> +		if (err)
>> +			return err;
>> +	}
>> +
>>  	if (r->set_user)
>>  		return (r->set_user)(vcpu, r, reg, uaddr);
>>  
>> diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
>> index 5a6fc30f5989..9bce5e9a3490 100644
>> --- a/arch/arm64/kvm/sys_regs.h
>> +++ b/arch/arm64/kvm/sys_regs.h
>> @@ -53,6 +53,12 @@ struct sys_reg_desc {
>>  			const struct kvm_one_reg *reg, void __user *uaddr);
>>  	int (*set_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>>  			const struct kvm_one_reg *reg, void __user *uaddr);
>> +	/*
>> +	 * Check the value userspace passed.  It should return 0 on success and
>> +	 * otherwise on failure.
>> +	 */
>> +	int (*check_user)(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
>> +			  const struct kvm_one_reg *reg, void __user *uaddr);
>>  
>>  	/* Return mask of REG_* runtime visibility overrides */
>>  	unsigned int (*visibility)(const struct kvm_vcpu *vcpu,
>> -- 
>> 2.26.2
>>
> 
> .
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
