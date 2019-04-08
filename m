Return-Path: <SRS0=T7i1=SK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72E08C282CE
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 08:51:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 152CC20880
	for <kvmarm@archiver.kernel.org>; Mon,  8 Apr 2019 08:51:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 152CC20880
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 919E14A47D;
	Mon,  8 Apr 2019 04:51:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 3lCyHTlZ5NfR; Mon,  8 Apr 2019 04:51:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4934E4A422;
	Mon,  8 Apr 2019 04:51:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A3B864A41C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 04:51:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Zb0WO207-agT for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Apr 2019 04:51:49 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 274F64A319
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Apr 2019 04:51:49 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7787215AD;
 Mon,  8 Apr 2019 01:51:48 -0700 (PDT)
Received: from [10.162.0.144] (a075553-lin.blr.arm.com [10.162.0.144])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 375663F718;
 Mon,  8 Apr 2019 01:51:44 -0700 (PDT)
Subject: Re: [PATCH v8 8/9] KVM: arm64: Add capability to advertise ptrauth
 for guest
To: Dave Martin <Dave.Martin@arm.com>
References: <1554172037-4516-1-git-send-email-amit.kachhap@arm.com>
 <1554172037-4516-9-git-send-email-amit.kachhap@arm.com>
 <20190405110339.GU3567@e103592.cambridge.arm.com>
From: Amit Daniel Kachhap <amit.kachhap@arm.com>
Message-ID: <d50f78e4-6608-fb8a-6b8a-b4c246387d72@arm.com>
Date: Mon, 8 Apr 2019 14:21:42 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190405110339.GU3567@e103592.cambridge.arm.com>
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
Message-ID: <20190408085142.SrV1qrGoQ4Ad9ILyp6EXv0RnQr9fPfCaB_BkPN5f1z8@z>

Hi,

On 4/5/19 4:33 PM, Dave Martin wrote:
> On Tue, Apr 02, 2019 at 07:57:16AM +0530, Amit Daniel Kachhap wrote:
>> This patch advertises the capability of two cpu feature called address
>> pointer authentication and generic pointer authentication. These
>> capabilities depend upon system support for pointer authentication and
>> VHE mode.
>>
>> The current arm64 KVM partially implements pointer authentication and
>> support of address/generic authentication are tied together. However,
>> separate ABI requirements for both of them is added so that the future
>> isolated implementation will not require any ABI changes.
>>
>> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Marc Zyngier <marc.zyngier@arm.com>
>> Cc: Christoffer Dall <christoffer.dall@arm.com>
>> Cc: kvmarm@lists.cs.columbia.edu
>> ---
>>
>> Changes since v7:
>> * Created 2 capabilities KVM_CAP_ARM_PTRAUTH_ADDRESS and KVM_CAP_ARM_PTRAUTH_GENERIC
>>    instead of one KVM_CAP_ARM_PTRAUTH [Kristina Martsenko].
>> * Added documentation here itself instead of in a new patch.
>>
>>   Documentation/virtual/kvm/api.txt | 3 +++
>>   arch/arm64/kvm/reset.c            | 6 ++++++
>>   include/uapi/linux/kvm.h          | 2 ++
>>   3 files changed, 11 insertions(+)
>>
>> diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
>> index aaa048d..9b56892 100644
>> --- a/Documentation/virtual/kvm/api.txt
>> +++ b/Documentation/virtual/kvm/api.txt
>> @@ -2661,8 +2661,11 @@ Possible features:
>>   	  Depends on KVM_CAP_ARM_PMU_V3.
>>   	- KVM_ARM_VCPU_PTRAUTH_ADDRESS: Enables Address Pointer authentication
>>   	  for the CPU and supported only on arm64 architecture.
>> +	  Depends on KVM_CAP_ARM_PTRAUTH_ADDRESS.
>>   	- KVM_ARM_VCPU_PTRAUTH_GENERIC: Enables Generic Pointer authentication
>>   	  for the CPU and supported only on arm64 architecture.
>> +	  Depends on KVM_CAP_ARM_PTRAUTH_GENERIC.
>>   
>>   
>>   4.83 KVM_ARM_PREFERRED_TARGET
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index 717afed..8aa8982 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -92,6 +92,12 @@ int kvm_arch_vm_ioctl_check_extension(struct kvm *kvm, long ext)
>>   	case KVM_CAP_ARM_VM_IPA_SIZE:
>>   		r = kvm_ipa_limit;
>>   		break;
>> +	case KVM_CAP_ARM_PTRAUTH_ADDRESS:
>> +		r = has_vhe() && system_supports_address_auth();
>> +		break;
>> +	case KVM_CAP_ARM_PTRAUTH_GENERIC:
>> +		r = has_vhe() && system_supports_generic_auth();
>> +		break;
> 
> If some hardware supports just one auth type, we would report just one
> of these caps.  Although we have the rule that userspace is not allowed
> to request these independently in KVM_ARM_VCPU_INIT anyway, I think it
> would be easier for userspace if we suppress both caps if either auth
> type isn't available on the host.  e.g.:
> 
> 	case KVM_ARM_ARM_PTRAUTH_ADDRESS:
> 	case KVM_ARM_ARM_PTRAUTH_GENERIC:
> 		r = has_vhe() && system_supports_address_auth() &&
> 			system_supports_generic_auth();
> 
> We could revert back to the above code later on, and apply the ABI
> relaxations described in my response to the vcpu features patch, if
> someday we add support to KVM for coping with host hardware that
> supports just one auth type.
These 2 different capabilities are introduced in this iteration so I was 
not clear whether to expose the suppression in capability ioctl level or 
KVM_ARM_VCPU_INIT ioctl level. But agree that this way will be more 
clearer to userspace.
> 
> 
> I'd like Mark to comment on this, since he's more aware of the
> architectural situation than I am.
ok.

Thanks,
Amit D.
> 
> Cheers
> ---Dave
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
