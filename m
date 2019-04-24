Return-Path: <SRS0=bv25=S2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7B95C282CE
	for <kvmarm@archiver.kernel.org>; Wed, 24 Apr 2019 05:58:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 73F942148D
	for <kvmarm@archiver.kernel.org>; Wed, 24 Apr 2019 05:58:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 73F942148D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D24824A4AA;
	Wed, 24 Apr 2019 01:58:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9y5Cbt36hwCh; Wed, 24 Apr 2019 01:57:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A40934A480;
	Wed, 24 Apr 2019 01:57:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 81EFF4A477
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 01:57:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Jod4KhWK1xYT for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Apr 2019 01:57:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 27F2C4A46F
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Apr 2019 01:57:56 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 44111A78;
 Tue, 23 Apr 2019 22:57:55 -0700 (PDT)
Received: from [10.162.0.144] (a075553-lin.blr.arm.com [10.162.0.144])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B27573F5AF;
 Tue, 23 Apr 2019 22:57:52 -0700 (PDT)
Subject: Re: [PATCH v10 1/5] KVM: arm64: Add a vcpu flag to control ptrauth
 for guest
To: Dave Martin <Dave.Martin@arm.com>
References: <1555994558-26349-1-git-send-email-amit.kachhap@arm.com>
 <1555994558-26349-2-git-send-email-amit.kachhap@arm.com>
 <20190423154419.GL3567@e103592.cambridge.arm.com>
From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Message-ID: <f9ebe12e-b6df-690b-1279-b7e2709c9e25@arm.com>
Date: Wed, 24 Apr 2019 11:27:50 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190423154419.GL3567@e103592.cambridge.arm.com>
Content-Language: en-US
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 linux-kernel@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>,
 Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="UTF-8"; format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190424055750.PBFKHBjcC42MMGjFxXk2F4hXHUHtfQoXP3-wBAuSixg@z>

Hi,

On 4/23/19 9:14 PM, Dave Martin wrote:
> On Tue, Apr 23, 2019 at 10:12:34AM +0530, Amit Daniel Kachhap wrote:
>> A per vcpu flag is added to check if pointer authentication is
>> enabled for the vcpu or not. This flag may be enabled according to
>> the necessary user policies and host capabilities.
>>
>> This patch also adds a helper to check the flag.
>>
>> Reviewed-by: Dave Martin <Dave.Martin@arm.com>
>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: kvmarm@lists.cs.columbia.edu
>> ---
>> Changes since v9:
>>
>> * Added ptrauth cpufeature static check in vcpu_has_ptrauth [Marc Zyngier].
>>
>>   arch/arm64/include/asm/kvm_host.h | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 7a096fd..7ccac42 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -355,10 +355,15 @@ struct kvm_vcpu_arch {
>>   #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
>>   #define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
>>   #define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
>> +#define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
>>   
>>   #define vcpu_has_sve(vcpu) (system_supports_sve() && \
>>   			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
>>   
>> +#define vcpu_has_ptrauth(vcpu)	((system_supports_address_auth() || \
>> +				  system_supports_generic_auth()) && \
> 
> Come to think of it, should this be
> system_supports_address_auth() _&&_ system_supports_generic_auth()?
I thought about it and kept it this way so that the implementation 
limitation is not introduced in this patch but only in a single place in 
the 3rd patch where all the documentation and reasoning is present on 
doing this way.
> 
> It won't make a functional difference today though, since today
> kvm_vcpu_enable_ptrauth() won't set KVM_ARM64_GUEST_HAS_PTRAUTH without
> system_supports_address_auth() and system_supports_generic_auth() both
> true.
> 
> With || here, we won't have to change this if supporting the two auth
> types independently in the future though.
Yes right.
> 
> Either way, my Reviewed-by stands.
Thanks,
Amit D
> 
> Cheers
> ---Dave
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
