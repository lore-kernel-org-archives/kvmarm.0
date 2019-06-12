Return-Path: <SRS0=uW/I=UL=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A722CC31E47
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jun 2019 13:59:41 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 4E4BA20896
	for <kvmarm@archiver.kernel.org>; Wed, 12 Jun 2019 13:59:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4E4BA20896
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=huawei.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C62A4A4E8;
	Wed, 12 Jun 2019 09:59:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id GR-gP01NBivM; Wed, 12 Jun 2019 09:59:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 492754A503;
	Wed, 12 Jun 2019 09:59:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 716F34A518
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jun 2019 09:59:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MQJm6Man0Wfo for <kvmarm@lists.cs.columbia.edu>;
 Wed, 12 Jun 2019 09:59:36 -0400 (EDT)
Received: from huawei.com (szxga06-in.huawei.com [45.249.212.32])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 714C14A4E6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 12 Jun 2019 09:59:36 -0400 (EDT)
Received: from DGGEMS410-HUB.china.huawei.com (unknown [172.30.72.60])
 by Forcepoint Email with ESMTP id F36B1AAB7E15BB89D9AB;
 Wed, 12 Jun 2019 21:47:25 +0800 (CST)
Received: from [127.0.0.1] (10.177.29.32) by DGGEMS410-HUB.china.huawei.com
 (10.3.19.210) with Microsoft SMTP Server id 14.3.439.0; Wed, 12 Jun 2019
 21:47:19 +0800
From: Xiang Zheng <zhengxiang9@huawei.com>
Subject: Re: [PATCH] KVM: ARM64: Update perf event when setting PMU count value
To: Andrew Murray <andrew.murray@arm.com>
References: <20190519100559.7188-1-zhengxiang9@huawei.com>
 <20190521164445.GW8268@e119886-lin.cambridge.arm.com>
Message-ID: <482838e5-64a4-ef99-2e51-4b58e18ba4b4@huawei.com>
Date: Wed, 12 Jun 2019 21:47:05 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:64.0) Gecko/20100101
 Thunderbird/64.0
MIME-Version: 1.0
In-Reply-To: <20190521164445.GW8268@e119886-lin.cambridge.arm.com>
Content-Language: en-US
X-Originating-IP: [10.177.29.32]
X-CFilter-Loop: Reflected
Cc: marc.zyngier@arm.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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


On 2019/5/22 0:44, Andrew Murray wrote:
> On Sun, May 19, 2019 at 06:05:59PM +0800, Xiang Zheng wrote:
>> Guest will adjust the sample period and set PMU counter value when
>> it takes a long time to handle the PMU interrupts.
>>
>> However, we don't have a corresponding change on the virtual PMU
>> which is emulated via a perf event. It could cause a large number
>> of PMU interrupts injected to guest. Then guest will get hang for
>> handling these interrupts.
> 
> Yes this is indeed an issue. I believe I've addressed this in my 'chained
> pmu' series - the relevant patch is here...
> 
> https://lists.cs.columbia.edu/pipermail/kvmarm/2019-May/035933.html
> 
> Some other comments below.
> 

Sorry for that I didn't notice your patches...
I will test your patch series.

>>
>> So update the sample_period of perf event if the counter value is
>> changed to avoid this case.
>>
>> Signed-off-by: Xiang Zheng <zhengxiang9@huawei.com>
>> ---
>>  virt/kvm/arm/pmu.c | 54 +++++++++++++++++++++++++++++++++++++++++++++---------
>>  1 file changed, 45 insertions(+), 9 deletions(-)
>>
>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
>> index 1c5b76c..cbad3ec 100644
>> --- a/virt/kvm/arm/pmu.c
>> +++ b/virt/kvm/arm/pmu.c
>> @@ -24,6 +24,11 @@
>>  #include <kvm/arm_pmu.h>
>>  #include <kvm/arm_vgic.h>
>>  
>> +static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
>> +static struct perf_event *kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu,
>> +						    struct kvm_pmc *pmc,
>> +						    struct perf_event_attr *attr);
>> +
>>  /**
>>   * kvm_pmu_get_counter_value - get PMU counter value
>>   * @vcpu: The vcpu pointer
>> @@ -57,11 +62,29 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>>   */
>>  void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
>>  {
>> -	u64 reg;
>> +	u64 reg, counter, old_sample_period;
>> +	struct kvm_pmu *pmu = &vcpu->arch.pmu;
>> +	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
>> +	struct perf_event *event;
>> +	struct perf_event_attr attr;
>>  
>>  	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
>>  	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
>>  	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
>> +
>> +	if (pmc->perf_event) {
>> +		attr = pmc->perf_event->attr;
>> +		old_sample_period = attr.sample_period;
>> +		counter = kvm_pmu_get_counter_value(vcpu, select_idx);
>> +		attr.sample_period = (-counter) & pmc->bitmask;
>> +		if (attr.sample_period == old_sample_period)
>> +			return;
> 
> I'd be interested to know how often this would evaluate to true.
> 

I have counted it while running my test script, the result shows that there are 1552288
times evaluated to true and 8294235 times not.

I think different testcases may produce different results.

>> +
>> +		kvm_pmu_stop_counter(vcpu, pmc);
>> +		event = kvm_pmu_create_perf_event(vcpu, pmc, &attr);
> 
> I'm not sure it's necessary to change the prototype of kvm_pmu_create_perf_event
> as this function will recalculate the sample period based on the updated counter
> value anyway.
> 

In this patch, kvm_pmu_create_perf_event() will not recalculate the sample period. Maybe
you confuse it with your patch.:)

> Thanks,
> 
> Andrew Murray
> 
>> +		if (event)
>> +			pmc->perf_event = event;
>> +	}
>>  }
>>  
>>  /**
>> @@ -303,6 +326,24 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
>>  	}
>>  }
>>  
>> +static struct perf_event *kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu,
>> +						    struct kvm_pmc *pmc,
>> +						    struct perf_event_attr *attr)
>> +{
>> +	struct perf_event *event;
>> +
>> +	event = perf_event_create_kernel_counter(attr, -1, current,
>> +						 kvm_pmu_perf_overflow, pmc);
>> +
>> +	if (IS_ERR(event)) {
>> +		pr_err_once("kvm: pmu event creation failed %ld\n",
>> +			    PTR_ERR(event));
>> +		return NULL;
>> +	}
>> +
>> +	return event;
>> +}
>> +
>>  /**
>>   * kvm_pmu_software_increment - do software increment
>>   * @vcpu: The vcpu pointer
>> @@ -416,15 +457,10 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
>>  	/* The initial sample period (overflow count) of an event. */
>>  	attr.sample_period = (-counter) & pmc->bitmask;
>>  
>> -	event = perf_event_create_kernel_counter(&attr, -1, current,
>> -						 kvm_pmu_perf_overflow, pmc);
>> -	if (IS_ERR(event)) {
>> -		pr_err_once("kvm: pmu event creation failed %ld\n",
>> -			    PTR_ERR(event));
>> -		return;
>> -	}
>> +	event = kvm_pmu_create_perf_event(vcpu, pmc, &attr);
>>  
>> -	pmc->perf_event = event;
>> +	if (event)
>> +		pmc->perf_event = event;
>>  }
>>  
>>  bool kvm_arm_support_pmu_v3(void)
>> -- 
>> 1.8.3.1
>>
>>
>> _______________________________________________
>> kvmarm mailing list
>> kvmarm@lists.cs.columbia.edu
>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
> .
> 
-- 

Thanks,
Xiang


_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
