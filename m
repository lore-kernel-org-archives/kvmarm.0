Return-Path: <SRS0=xxyy=BY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 690E4C433DF
	for <kvmarm@archiver.kernel.org>; Fri, 14 Aug 2020 11:49:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1291E20716
	for <kvmarm@archiver.kernel.org>; Fri, 14 Aug 2020 11:49:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1291E20716
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BB8C34BC28;
	Fri, 14 Aug 2020 07:49:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aX57OMwL0XV3; Fri, 14 Aug 2020 07:49:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 98D174BC36;
	Fri, 14 Aug 2020 07:49:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 831084BC28
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Aug 2020 07:49:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TZl5qAlwpKgF for <kvmarm@lists.cs.columbia.edu>;
 Fri, 14 Aug 2020 07:49:44 -0400 (EDT)
Received: from huawei.com (szxga02-in.huawei.com [45.249.212.188])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6924C4BC24
 for <kvmarm@lists.cs.columbia.edu>; Fri, 14 Aug 2020 07:49:44 -0400 (EDT)
Received: from DGGEMM403-HUB.china.huawei.com (unknown [172.30.72.57])
 by Forcepoint Email with ESMTP id B975F88DAB87003DCA55;
 Fri, 14 Aug 2020 19:49:40 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 DGGEMM403-HUB.china.huawei.com (10.3.20.211) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 14 Aug 2020 19:49:40 +0800
Received: from [10.174.185.187] (10.174.185.187) by
 dggema765-chm.china.huawei.com (10.1.198.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 14 Aug 2020 19:49:40 +0800
Subject: Re: [RFC 3/4] kvm: arm64: make ID registers configurable
To: Andrew Jones <drjones@redhat.com>
References: <20200813060517.2360048-1-liangpeng10@huawei.com>
 <20200813060517.2360048-4-liangpeng10@huawei.com>
 <20200813090927.busuifugzatw5sem@kamzik.brq.redhat.com>
From: Peng Liang <liangpeng10@huawei.com>
Message-ID: <d7f5f605-df93-e713-8cbf-f7e76c9f9d37@huawei.com>
Date: Fri, 14 Aug 2020 19:49:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200813090927.busuifugzatw5sem@kamzik.brq.redhat.com>
Content-Language: en-US
X-Originating-IP: [10.174.185.187]
X-ClientProxiedBy: dggeme703-chm.china.huawei.com (10.1.199.99) To
 dggema765-chm.china.huawei.com (10.1.198.207)
X-CFilter-Loop: Reflected
Cc: Zhanghailiang <zhang.zhanghailiang@huawei.com>, kvm@vger.kernel.org,
 maz@kernel.org, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On 8/13/2020 5:09 PM, Andrew Jones wrote:
> On Thu, Aug 13, 2020 at 02:05:16PM +0800, Peng Liang wrote:
>> It's time to make ID registers configurable.  When userspace (but not
>> guest) want to set the values of ID registers, save the value in
>> kvm_arch_vcpu so that guest can read the modified values.
>>
>> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
>> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
>> ---
>>  arch/arm64/kvm/sys_regs.c | 23 ++++++++++++++++-------
>>  1 file changed, 16 insertions(+), 7 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 776c2757a01e..f98635489966 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1111,6 +1111,14 @@ static u64 kvm_get_id_reg(struct kvm_vcpu *vcpu, u64 id)
>>  	return ri->sys_val;
>>  }
>>  
>> +static void kvm_set_id_reg(struct kvm_vcpu *vcpu, u64 id, u64 value)
>> +{
>> +	struct id_reg_info *ri = kvm_id_reg(vcpu, id);
>> +
>> +	BUG_ON(!ri);
>> +	ri->sys_val = value;
>> +}
>> +
>>  /* Read a sanitised cpufeature ID register by sys_reg_desc */
>>  static u64 read_id_reg(struct kvm_vcpu *vcpu,
>>  		struct sys_reg_desc const *r, bool raz)
>> @@ -1252,10 +1260,6 @@ static int set_id_aa64zfr0_el1(struct kvm_vcpu *vcpu,
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
>> @@ -1279,9 +1283,14 @@ static int __set_id_reg(struct kvm_vcpu *vcpu,
>>  	if (err)
>>  		return err;
>>  
>> -	/* This is what we mean by invariant: you can't change it. */
>> -	if (val != read_id_reg(vcpu, rd, raz))
>> -		return -EINVAL;
>> +	if (raz) {
>> +		if (val != read_id_reg(vcpu, rd, raz))
>> +			return -EINVAL;
>> +	} else {
>> +		u32 reg_id = sys_reg((u32)rd->Op0, (u32)rd->Op1, (u32)rd->CRn,
>> +				     (u32)rd->CRm, (u32)rd->Op2);
>> +		kvm_set_id_reg(vcpu, reg_id, val);
> 
> So userspace can set the ID registers to whatever they want? I think each
> register should have its own sanity checks applied before accepting the
> input.
> 
> Thanks,
> drew
> 
>> +	}
>>  
>>  	return 0;
>>  }
>> -- 
>> 2.18.4
>>
> 
> .
> 

Yea, sanity checkers are necessary and I'm working on it.  I think we should make
sure that every ID fields should be checked to match the HW capabilities so that
guest will not be confused because of a careless hypervisor.

Thanks,
Peng
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
