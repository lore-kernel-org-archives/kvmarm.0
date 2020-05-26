Return-Path: <SRS0=x9SY=7I=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1813C433E0
	for <kvmarm@archiver.kernel.org>; Tue, 26 May 2020 11:02:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2E31220899
	for <kvmarm@archiver.kernel.org>; Tue, 26 May 2020 11:02:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E31220899
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 987464B2B5;
	Tue, 26 May 2020 07:02:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id MbPzrS3OUl0V; Tue, 26 May 2020 07:02:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 359734B27E;
	Tue, 26 May 2020 07:02:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9F1814B278
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 07:02:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LdmOO1WHSN11 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 26 May 2020 07:02:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 422B14B255
 for <kvmarm@lists.cs.columbia.edu>; Tue, 26 May 2020 07:02:06 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C65A931B;
 Tue, 26 May 2020 04:02:05 -0700 (PDT)
Received: from [192.168.1.84] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 18D213F6C4;
 Tue, 26 May 2020 04:02:02 -0700 (PDT)
Subject: Re: [RFC PATCH v12 07/11] psci: Add hypercall service for kvm ptp.
To: Jianyong Wu <Jianyong.Wu@arm.com>,
 "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
 "yangbo.lu@nxp.com" <yangbo.lu@nxp.com>,
 "john.stultz@linaro.org" <john.stultz@linaro.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>,
 "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
 "maz@kernel.org" <maz@kernel.org>,
 "richardcochran@gmail.com" <richardcochran@gmail.com>,
 Mark Rutland <Mark.Rutland@arm.com>, "will@kernel.org" <will@kernel.org>,
 Suzuki Poulose <Suzuki.Poulose@arm.com>
References: <20200522083724.38182-1-jianyong.wu@arm.com>
 <20200522083724.38182-8-jianyong.wu@arm.com>
 <87fce07b-d0f5-47b0-05ce-dd664ce53eec@arm.com>
 <HE1PR0802MB2555A66F063927D5B855E1C6F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <d7ec2534-95e4-ae79-fc53-4d48a4ea628c@arm.com>
Date: Tue, 26 May 2020 12:02:01 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <HE1PR0802MB2555A66F063927D5B855E1C6F4B30@HE1PR0802MB2555.eurprd08.prod.outlook.com>
Content-Language: en-GB
Cc: Justin He <Justin.He@arm.com>, Wei Chen <Wei.Chen@arm.com>,
 "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, nd <nd@arm.com>,
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
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 25/05/2020 03:11, Jianyong Wu wrote:
> Hi Steven,

Hi Jianyong,

[...]>>> diff --git a/virt/kvm/arm/hypercalls.c b/virt/kvm/arm/hypercalls.c
>>> index db6dce3d0e23..c964122f8dae 100644
>>> --- a/virt/kvm/arm/hypercalls.c
>>> +++ b/virt/kvm/arm/hypercalls.c
>>> @@ -3,6 +3,7 @@
>>>
>>>    #include <linux/arm-smccc.h>
>>>    #include <linux/kvm_host.h>
>>> +#include <linux/clocksource_ids.h>
>>>
>>>    #include <asm/kvm_emulate.h>
>>>
>>> @@ -11,6 +12,10 @@
>>>
>>>    int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>>>    {
>>> +#ifdef CONFIG_ARM64_KVM_PTP_HOST
>>> +	struct system_time_snapshot systime_snapshot;
>>> +	u64 cycles;
>>> +#endif
>>>    	u32 func_id = smccc_get_function(vcpu);
>>>    	u32 val[4] = {SMCCC_RET_NOT_SUPPORTED};
>>>    	u32 feature;
>>> @@ -70,7 +75,49 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
>>>    		break;
>>>    	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
>>>    		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
>>> +
>>> +#ifdef CONFIG_ARM64_KVM_PTP_HOST
>>> +		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP); #endif
>>>    		break;
>>> +
>>> +#ifdef CONFIG_ARM64_KVM_PTP_HOST
>>> +	/*
>>> +	 * This serves virtual kvm_ptp.
>>> +	 * Four values will be passed back.
>>> +	 * reg0 stores high 32-bit host ktime;
>>> +	 * reg1 stores low 32-bit host ktime;
>>> +	 * reg2 stores high 32-bit difference of host cycles and cntvoff;
>>> +	 * reg3 stores low 32-bit difference of host cycles and cntvoff.
>>> +	 */
>>> +	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
>>> +		/*
>>> +		 * system time and counter value must captured in the same
>>> +		 * time to keep consistency and precision.
>>> +		 */
>>> +		ktime_get_snapshot(&systime_snapshot);
>>> +		if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
>>> +			break;
>>> +		val[0] = upper_32_bits(systime_snapshot.real);
>>> +		val[1] = lower_32_bits(systime_snapshot.real);
>>> +		/*
>>> +		 * which of virtual counter or physical counter being
>>> +		 * asked for is decided by the first argument.
>>> +		 */
>>> +		feature = smccc_get_arg1(vcpu);
>>> +		switch (feature) {
>>> +		case ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_FUNC_ID:
>>> +			cycles = systime_snapshot.cycles;
>>> +			break;
>>> +		default:
>>
>> There's something a bit odd here.
>>
>> ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID and
>> ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_FUNC_ID look like they should
>> be names of separate (top-level) functions, but actually the _PHY_ one is a
>> parameter for the first. If the intention is to have a parameter then it would
>> be better to pick a better name for the _PHY_ define and not define it using
>> ARM_SMCCC_CALL_VAL.
>>
> Yeah, _PHY_ is not the same meaning with _PTP_FUNC_ID,  so I think it should be a different name.
> What about ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_COUNTER?

Personally I'd go with something much shorter, e.g. ARM_PTP_PHY_COUNTER. 
This is just an argument to an SMCCC call so there's no need for most of 
the prefix, indeed if (for whatever reason) there was a non-SMCCC 
mechanism added to do the same thing it would be reasonable to reuse the 
same values.

>> Second the use of "default:" means that there's no possibility to later extend
>> this interface for more clocks if needed in the future.
>>
> I think we can add more clocks by adding more cases, this "default" means we can use no first arg to determine the default clock.

The problem with the 'default' is it means it's not possible to probe 
whether the kernel supports any more clocks. If we used a different 
value (that the kernel doesn't support) then we end up in the default 
case and have no idea whether the clock value is the one we requested or 
not.

It's generally better when defining an ABI to explicitly return an error 
for unknown parameters, that way a future user of the ABI can discover 
whether the call did what was expected or not.

>> Alternatively you could indeed implement as two top-level functions and
>> change this to a...
>>
>> 	switch (func_id)
>>
>> ... along with multiple case labels as the functions would obviously be mostly
>> the same.
>>
>> Also a minor style issue - you might want to consider splitting this into it's
>> own function.
>>
> I think "switch (feature)" maybe better as this _PHY_ is not like a function id. Just like:
> "
> case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
>                  feature = smccc_get_arg1(vcpu);
>                  switch (feature) {
>                  case ARM_SMCCC_ARCH_WORKAROUND_1:
> ...
> "

I'm happy either way - it's purely that the definition/naming of 
ARM_SMCCC_VENDOR_HYP_KVM_PTP_PHY_FUNC_ID made it look like that was the 
intention. My preference would be to stick with the 'feature' approach 
as above because there's no need to "use up" the top-level SMCCC calls 
(but equally there's a large space so we'd have to work very hard to run 
out... ;) )

>> Finally I do think it would be useful to add some documentation of the new
>> SMC calls. It would be easier to review the interface based on that
>> documentation rather than trying to reverse-engineer the interface from the
>> code.
>>
> Yeah, more doc needed here.

Thanks, I think it's a good idea to get the ABI nailed down before 
worrying too much about the code, and it's easier to discuss based on 
documentation rather than code.

Thanks,

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
