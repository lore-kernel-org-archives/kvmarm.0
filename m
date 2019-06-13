Return-Path: <SRS0=T7gh=UM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1EB6C31E45
	for <kvmarm@archiver.kernel.org>; Thu, 13 Jun 2019 16:50:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 773C62082C
	for <kvmarm@archiver.kernel.org>; Thu, 13 Jun 2019 16:50:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 773C62082C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5C6E4A4F9;
	Thu, 13 Jun 2019 12:50:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7Am4Oi7samLC; Thu, 13 Jun 2019 12:50:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A85504A4E1;
	Thu, 13 Jun 2019 12:50:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3A144A4A4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jun 2019 12:50:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NEm8nLAqob01 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 Jun 2019 12:50:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 620184A445
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 Jun 2019 12:50:46 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D703E367;
 Thu, 13 Jun 2019 09:50:45 -0700 (PDT)
Received: from [10.1.196.93] (en101.cambridge.arm.com [10.1.196.93])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EDE0F3F694;
 Thu, 13 Jun 2019 09:50:44 -0700 (PDT)
Subject: Re: [PATCH v9 4/5] KVM: arm/arm64: remove pmc->bitmask
To: andrew.murray@arm.com, julien.thierry@arm.com
References: <20190612190450.7085-1-andrew.murray@arm.com>
 <20190612190450.7085-5-andrew.murray@arm.com>
 <6a8e4fdd-d8cf-f3fb-55cd-2d06805b0eb9@arm.com>
 <20190613093957.GG49779@e119886-lin.cambridge.arm.com>
From: Suzuki K Poulose <suzuki.poulose@arm.com>
Message-ID: <5e18d747-1d82-8eed-ef1c-de86c5b3a7e7@arm.com>
Date: Thu, 13 Jun 2019 17:50:43 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190613093957.GG49779@e119886-lin.cambridge.arm.com>
Content-Language: en-US
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
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



On 13/06/2019 10:39, Andrew Murray wrote:
> On Thu, Jun 13, 2019 at 08:30:51AM +0100, Julien Thierry wrote:
>> Hi Andrew,
>>
>> On 12/06/2019 20:04, Andrew Murray wrote:
>>> We currently use pmc->bitmask to determine the width of the pmc - however
>>> it's superfluous as the pmc index already describes if the pmc is a cycle
>>> counter or event counter. The architecture clearly describes the widths of
>>> these counters.
>>>
>>> Let's remove the bitmask to simplify the code.
>>>
>>> Signed-off-by: Andrew Murray <andrew.murray@arm.com>
>>> ---
>>>   include/kvm/arm_pmu.h |  1 -
>>>   virt/kvm/arm/pmu.c    | 19 +++++++++----------
>>>   2 files changed, 9 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
>>> index b73f31baca52..2f0e28dc5a9e 100644
>>> --- a/include/kvm/arm_pmu.h
>>> +++ b/include/kvm/arm_pmu.h
>>> @@ -28,7 +28,6 @@
>>>   struct kvm_pmc {
>>>   	u8 idx;	/* index into the pmu->pmc array */
>>>   	struct perf_event *perf_event;
>>> -	u64 bitmask;
>>>   };
>>>   
>>>   struct kvm_pmu {
>>> diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
>>> index ae1e886d4a1a..88ce24ae0b45 100644
>>> --- a/virt/kvm/arm/pmu.c
>>> +++ b/virt/kvm/arm/pmu.c
>>> @@ -47,7 +47,10 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
>>>   		counter += perf_event_read_value(pmc->perf_event, &enabled,
>>>   						 &running);
>>>   
>>> -	return counter & pmc->bitmask;
>>> +	if (select_idx != ARMV8_PMU_CYCLE_IDX)
>>> +		counter = lower_32_bits(counter);
>>
>> Shouldn't this depend on PMCR.LC as well? If PMCR.LC is clear we only
>> want the lower 32bits of the cycle counter.
> 
> Yes that's correct. The hunk should look like this:
> 
> -       return counter & pmc->bitmask;
> +       if (!(select_idx == ARMV8_PMU_CYCLE_IDX &&
> +             __vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_LC))
> +               counter = lower_32_bits(counter);
> +
> +       return counter;

May be you could add a macro :

#define vcpu_pmu_counter_is_64bit(vcpu, idx) ?

Cheers
Suzuki
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
