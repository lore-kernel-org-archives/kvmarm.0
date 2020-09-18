Return-Path: <SRS0=n0cH=C3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC6A8C43464
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 09:25:20 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E8DCE20DD4
	for <kvmarm@archiver.kernel.org>; Fri, 18 Sep 2020 09:25:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8DCE20DD4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76F4F4B337;
	Fri, 18 Sep 2020 05:25:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NBacnphEE3Td; Fri, 18 Sep 2020 05:25:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A6C04B351;
	Fri, 18 Sep 2020 05:25:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3D0D64B20D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 05:25:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v+E31gsX6BRV for <kvmarm@lists.cs.columbia.edu>;
 Fri, 18 Sep 2020 05:25:15 -0400 (EDT)
Received: from huawei.com (szxga08-in.huawei.com [45.249.212.255])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AB1834B2C9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 18 Sep 2020 05:25:14 -0400 (EDT)
Received: from DGGEMM401-HUB.china.huawei.com (unknown [172.30.72.55])
 by Forcepoint Email with ESMTP id 09048F025AF68B3D2055;
 Fri, 18 Sep 2020 17:25:12 +0800 (CST)
Received: from dggema765-chm.china.huawei.com (10.1.198.207) by
 DGGEMM401-HUB.china.huawei.com (10.3.20.209) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Fri, 18 Sep 2020 17:25:11 +0800
Received: from [10.174.185.187] (10.174.185.187) by
 dggema765-chm.china.huawei.com (10.1.198.207) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Fri, 18 Sep 2020 17:25:11 +0800
Subject: Re: [RFC v2 2/7] arm64: introduce check_features
To: Andrew Jones <drjones@redhat.com>
References: <20200917120101.3438389-1-liangpeng10@huawei.com>
 <20200917120101.3438389-3-liangpeng10@huawei.com>
 <20200918073059.izmscvrtbnsbgnlj@kamzik.brq.redhat.com>
From: Peng Liang <liangpeng10@huawei.com>
Message-ID: <bc37052f-3719-ac71-ed86-0427e7fdecf2@huawei.com>
Date: Fri, 18 Sep 2020 17:25:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <20200918073059.izmscvrtbnsbgnlj@kamzik.brq.redhat.com>
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

On 9/18/2020 3:30 PM, Andrew Jones wrote:
> On Thu, Sep 17, 2020 at 08:00:56PM +0800, Peng Liang wrote:
>> To emulate ID registers, we need to validate the value of the register
>> defined by user space.  For most ID registers, we need to check whether
>> each field defined by user space is no more than that of host (whether
>> host support the corresponding features) and whether the fields are
>> supposed to be exposed to guest.  Introduce check_features to do those
>> jobs.
>>
>> Signed-off-by: zhanghailiang <zhang.zhanghailiang@huawei.com>
>> Signed-off-by: Peng Liang <liangpeng10@huawei.com>
>> ---
>>  arch/arm64/include/asm/cpufeature.h |  2 ++
>>  arch/arm64/kernel/cpufeature.c      | 23 +++++++++++++++++++++++
>>  2 files changed, 25 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>> index 2ba7c4f11d8a..954adc5ca72f 100644
>> --- a/arch/arm64/include/asm/cpufeature.h
>> +++ b/arch/arm64/include/asm/cpufeature.h
>> @@ -579,6 +579,8 @@ void check_local_cpu_capabilities(void);
>>  
>>  u64 read_sanitised_ftr_reg(u32 id);
>>  
>> +int check_features(u32 sys_reg, u64 val);
>> +
>>  static inline bool cpu_supports_mixed_endian_el0(void)
>>  {
>>  	return id_aa64mmfr0_mixed_endian_el0(read_cpuid(ID_AA64MMFR0_EL1));
>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index 698b32705544..e58926992a70 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -2850,3 +2850,26 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr,
>>  
>>  	return sprintf(buf, "Vulnerable\n");
>>  }
>> +
>> +int check_features(u32 sys_reg, u64 val)
>> +{
>> +	struct arm64_ftr_reg *reg = get_arm64_ftr_reg(sys_reg);
>> +	const struct arm64_ftr_bits *ftrp;
>> +	u64 exposed_mask = 0;
>> +
>> +	if (!reg)
>> +		return -ENOENT;
>> +
>> +	for (ftrp = reg->ftr_bits; ftrp->width; ftrp++) {
>> +		if (arm64_ftr_value(ftrp, reg->sys_val) <
>> +		    arm64_ftr_value(ftrp, val)) {
>> +			return -EINVAL;
> 
> This assumes that 0b1111 is invalid if the host has e.g. 0b0001,
> but, IIRC, there are some ID registers where 0b1111 means the
> feature is disabled.

I think arm64_ftr_value will handle it correctly.  If the value of
the field is 0b1111 and the field is signed, arm64_ftr_value will
return -1.

> 
>> +		}
>> +		exposed_mask |= arm64_ftr_mask(ftrp);
>> +	}
>> +
>> +	if (val & ~exposed_mask)
>> +		return -EINVAL;
>> +
>> +	return 0;
>> +}
>> -- 
>> 2.26.2
>>
> 
> I don't think we should be trying to do the verification at the ftr_bits
> level, at least not generally. Trying to handle all ID registers the
> same way is bound to fail, for the 0b1111 vs. 0b0000 reason pointed
> out above, and probably other reasons. As I stated before, we should be
> validating each feature of each ID register on a case by case basis,
> and we should be using higher level CPU feature checking APIs to get
> that right.
> 
> Also, what about validating that all VCPUs have consistent features
> exposed? Each VCPU could select a valid feature mask by this check,
> but different ones, which will obviously create a completely broken
> guest.
> 
> Thanks,
> drew
> 
> .
> 
Thank you for pointing this.  I haven't thought about it yet...

Thanks,
Peng
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
