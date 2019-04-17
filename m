Return-Path: <SRS0=XNJw=ST=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97E35C282DC
	for <kvmarm@archiver.kernel.org>; Wed, 17 Apr 2019 13:08:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 395A22173C
	for <kvmarm@archiver.kernel.org>; Wed, 17 Apr 2019 13:08:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 395A22173C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B1BCE4A52D;
	Wed, 17 Apr 2019 09:08:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hQ7F3uCUMrUn; Wed, 17 Apr 2019 09:08:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 60A954A515;
	Wed, 17 Apr 2019 09:08:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 304644A4FF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Apr 2019 09:08:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fXF0urwzXuhq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Apr 2019 09:08:20 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D039F4A4CA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Apr 2019 09:08:20 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 256AB374;
 Wed, 17 Apr 2019 06:08:20 -0700 (PDT)
Received: from [10.162.0.144] (a075553-lin.blr.arm.com [10.162.0.144])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6279E3F59C;
 Wed, 17 Apr 2019 06:08:16 -0700 (PDT)
Subject: Re: [PATCH v9 1/5] KVM: arm64: Add a vcpu flag to control ptrauth for
 guest
To: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org
References: <1555039236-10608-1-git-send-email-amit.kachhap@arm.com>
 <1555039236-10608-2-git-send-email-amit.kachhap@arm.com>
 <eeeebc4d-f061-42a5-954d-40161bbed23a@arm.com>
From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Message-ID: <ef1eb326-cd3a-4033-813d-ceae262b4e23@arm.com>
Date: Wed, 17 Apr 2019 18:38:13 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <eeeebc4d-f061-42a5-954d-40161bbed23a@arm.com>
Content-Language: en-US
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>,
 Kristina Martsenko <kristina.martsenko@arm.com>, kvmarm@lists.cs.columbia.edu,
 Ramana Radhakrishnan <ramana.radhakrishnan@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, linux-kernel@vger.kernel.org
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
Message-ID: <20190417130813.ukMbDxDRBRw5Dq62i4m3yGIp_-VEXLU5489YH2w2LWE@z>

Hi,

On 4/17/19 2:05 PM, Marc Zyngier wrote:
> On 12/04/2019 04:20, Amit Daniel Kachhap wrote:
>> A per vcpu flag is added to check if pointer authentication is
>> enabled for the vcpu or not. This flag may be enabled according to
>> the necessary user policies and host capabilities.
>>
>> This patch also adds a helper to check the flag.
>>
>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: kvmarm@lists.cs.columbia.edu
>> ---
>>
>> Changes since v8:
>> * Added a new per vcpu flag which will store Pointer Authentication enable
>>    status instead of checking them again. [Dave Martin]
>>
>>   arch/arm64/include/asm/kvm_host.h | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index 9d57cf8..31dbc7c 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -355,10 +355,14 @@ struct kvm_vcpu_arch {
>>   #define KVM_ARM64_HOST_SVE_ENABLED	(1 << 4) /* SVE enabled for EL0 */
>>   #define KVM_ARM64_GUEST_HAS_SVE		(1 << 5) /* SVE exposed to guest */
>>   #define KVM_ARM64_VCPU_SVE_FINALIZED	(1 << 6) /* SVE config completed */
>> +#define KVM_ARM64_GUEST_HAS_PTRAUTH	(1 << 7) /* PTRAUTH exposed to guest */
>>   
>>   #define vcpu_has_sve(vcpu) (system_supports_sve() && \
>>   			    ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_SVE))
>>   
>> +#define vcpu_has_ptrauth(vcpu)	\
>> +			((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH)
>> +
> 
> Just as for SVE, please first check that the system has PTRAUTH.
> Something like:
> 
> 		(cpus_have_const_cap(ARM64_HAS_GENERIC_AUTH_ARCH) && \
> 		 ((vcpu)->arch.flags & KVM_ARM64_GUEST_HAS_PTRAUTH))

In the subsequent patches, vcpu->arch.flags is only set to 
KVM_ARM64_GUEST_HAS_PTRAUTH when all host capability check conditions 
matches such as system_supports_address_auth(), 
system_supports_generic_auth() so doing them again is repetitive in my view.

Thanks,
Amit D

> 
> This will save an extra load on unsuspecting CPUs thanks to the static
> key embedded in the capability structure.
> 
> Thanks,
> 
> 	M.
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
