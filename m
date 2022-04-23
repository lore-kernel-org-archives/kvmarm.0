Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52756C433F5
	for <kvmarm@archiver.kernel.org>; Sat, 23 Apr 2022 12:48:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BF0FF4B120;
	Sat, 23 Apr 2022 08:48:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id NiSb4YxDKwyW; Sat, 23 Apr 2022 08:48:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 542AC4B08F;
	Sat, 23 Apr 2022 08:48:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C018D4B093
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Apr 2022 08:48:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id quJNYFu7f7RY for <kvmarm@lists.cs.columbia.edu>;
 Sat, 23 Apr 2022 08:48:20 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D2CC4B08F
 for <kvmarm@lists.cs.columbia.edu>; Sat, 23 Apr 2022 08:48:20 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1650718100;
 h=from:from:reply-to:reply-to:subject:subject:date:date:
 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
 content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=pRhbv36CFIo8Yp1QE2JYd5jVp+PVRgKRLXPKJ8jb5rI=;
 b=HcY7/dhkxmGenR8tWpaLaO7fCBvDc8HA9TIDXixvax9rlEXzG5kNNjyrW1ax7htSWDq23g
 9mIdlIaU69/pAt9eByXY241u7BbJWhuXmp+zCq9BInIJCMOtHSB7mMcHaBs5ps0veOMyNy
 IDlnbV+AkE+DlPtar7ks1KYdEItLfN8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-wKYpcH_IP8K7sDJQ2Qz6VA-1; Sat, 23 Apr 2022 08:48:16 -0400
X-MC-Unique: wKYpcH_IP8K7sDJQ2Qz6VA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id ED4F1101AA45;
 Sat, 23 Apr 2022 12:48:15 +0000 (UTC)
Received: from [10.72.13.230] (ovpn-13-230.pek2.redhat.com [10.72.13.230])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 67BB940F4940;
 Sat, 23 Apr 2022 12:48:09 +0000 (UTC)
Subject: Re: [PATCH v6 02/18] KVM: arm64: Route hypercalls based on their owner
To: Oliver Upton <oupton@google.com>
References: <20220403153911.12332-1-gshan@redhat.com>
 <20220403153911.12332-3-gshan@redhat.com> <YmETmWvPPQvHpQwP@google.com>
 <2519e2fa-4d6a-a5f8-1057-6b1820853036@redhat.com>
 <YmLs6t8iUn+BH6mo@google.com>
From: Gavin Shan <gshan@redhat.com>
Message-ID: <6d66823e-a6b0-f52a-efe3-0fbf1538597a@redhat.com>
Date: Sat, 23 Apr 2022 20:48:06 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.0
MIME-Version: 1.0
In-Reply-To: <YmLs6t8iUn+BH6mo@google.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.2
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
Reply-To: Gavin Shan <gshan@redhat.com>
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

Hi Oliver,

On 4/23/22 1:59 AM, Oliver Upton wrote:
> On Fri, Apr 22, 2022 at 08:20:50PM +0800, Gavin Shan wrote:
>> On 4/21/22 4:19 PM, Oliver Upton wrote:
>>> On Sun, Apr 03, 2022 at 11:38:55PM +0800, Gavin Shan wrote:
>>>> kvm_hvc_call_handler() directly handles the incoming hypercall, or
>>>> and routes it based on its (function) ID. kvm_psci_call() becomes
>>>> the gate keeper to handle the hypercall that can't be handled by
>>>> any one else. It makes kvm_hvc_call_handler() a bit messy.
>>>>
>>>> This reorgnizes the code to route the hypercall to the corresponding
>>>> handler based on its owner.
>>>
>>> nit: write changelogs in the imperative:
>>>
>>> Reorganize the code to ...
>>>
>>
>> Thanks again for your review. It will be corrected in next respin.
>> By the way, could you help to review the rest when you have free
>> cycles? :)
> 
> Yup, I've been thinking on the rest of the series just to make sure the
> feedback I give is sane.
> 

Sure.

>>>> The hypercall may be handled directly
>>>> in the handler or routed further to the corresponding functionality.
>>>> The (function) ID is always verified before it's routed to the
>>>> corresponding functionality. By the way, @func_id is repalced by
>>>> @func, to be consistent with by smccc_get_function().
>>>>
>>>> PSCI is the only exception, those hypercalls defined by 0.2 or
>>>> beyond are routed to the handler for Standard Secure Service, but
>>>> those defined in 0.1 are routed to the handler for Standard
>>>> Hypervisor Service.
>>>>
>>>> Suggested-by: Oliver Upton <oupton@google.com>
>>>> Signed-off-by: Gavin Shan <gshan@redhat.com>
>>>> ---
>>>>    arch/arm64/kvm/hypercalls.c | 199 +++++++++++++++++++++++-------------
>>>>    1 file changed, 127 insertions(+), 72 deletions(-)
>>>>
>>>> diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
>>>> index 8438fd79e3f0..b659387d8919 100644
>>>> --- a/arch/arm64/kvm/hypercalls.c
>>>> +++ b/arch/arm64/kvm/hypercalls.c
>>>
>>> [...]
>>>
>>>> +static int kvm_hvc_standard(struct kvm_vcpu *vcpu, u32 func)
>>>> +{
>>>> +	u64 val = SMCCC_RET_NOT_SUPPORTED;
>>>> +
>>>> +	switch (func) {
>>>> +	case ARM_SMCCC_TRNG_VERSION ... ARM_SMCCC_TRNG_RND32:
>>>> +	case ARM_SMCCC_TRNG_RND64:
>>>> +		return kvm_trng_call(vcpu);
>>>> +	case PSCI_0_2_FN_PSCI_VERSION ... PSCI_0_2_FN_SYSTEM_RESET:
>>>> +	case PSCI_0_2_FN64_CPU_SUSPEND ... PSCI_0_2_FN64_MIGRATE_INFO_UP_CPU:
>>>> +	case PSCI_1_0_FN_PSCI_FEATURES ... PSCI_1_0_FN_SET_SUSPEND_MODE:
>>>> +	case PSCI_1_0_FN64_SYSTEM_SUSPEND:
>>>> +	case PSCI_1_1_FN_SYSTEM_RESET2:
>>>> +	case PSCI_1_1_FN64_SYSTEM_RESET2:
>>>
>>> Isn't it known from the SMCCC what range of hypercall numbers PSCI and
>>> TRNG fall under, respectively?
>>>
>>> https://developer.arm.com/documentation/den0028/e/
>>>
>>> See sections 6.3 and 6.4.
>>>
>>
>> Bit#30 of the function ID is the call convention indication, which is
>> either 32 or 64-bits. For TRNG's function IDs, its 32-bits and 64-bits
>> variants are discrete. Besides, the spec reserves more functions IDs
>> than what range we're using. It means we don't have symbols to match
>> the reserved ranges. So it looks good to me for TRNG cases.
>>
>> For PSCI, it can be simplified as below, according to the defination
>> in include/uapi/linux/psci.h:
>>
>>      case PSCI_0_2_FN_PSCI_VERSION ...
>>           PSCI_1_1_FN_SYSTEM_RESET2:     /* 32-bits */
>>      case PSCI_0_2_FN64_CPU_SUSPEND ...
>>           PSCI_1_1_FN64_SYSTEM_RESET2:   /* 64-bits */
> 
> Right, but this still requires that we go back and update this switch
> statement every time we add a new PSCI call, which is exactly what I was
> hoping we could avoid. Doing this based exactly on the spec reduces the
> burden for future changes, and keeps all relevant context in a single
> spot.
> 
>    #define SMCCC_STD_PSCI_RANGE_START	0x0000
>    #define SMCCC_STD_PSCI_RANGE_END	0x001f
>    #define SMCCC_STD_TRNG_RANGE_START	0x0050
>    #define SMCCC_STD_TRNG_RANGE_END	0x005f
> 
>    switch (ARM_SMCCC_FUNC_NUM(function_id)) {
>            case SMCCC_STD_PSCI_RANGE_START ... SMCCC_STD_PSCI_RANGE_END:
> 	          return kvm_psci_call(vcpu);
>            case SMCCC_STD_TRNG_RANGE_START ... SMCCC_STD_TRNG_RANGE_END:
> 	  	  return kvm_trng_call(vcpu);
> 
> 	 ...
>    }
> 

Yep, we should avoid to visit and modify this function when a new PSCI call
is added. I intended not to introduce new macros, especially in the header
file (include/linux/arm-smccc.h), which is out of kvm/arm64 scope to some
degree. However, these newly added macros will have life much easier. I will
include the changes in next respin.

>>>> +	case KVM_PSCI_FN_CPU_SUSPEND ... KVM_PSCI_FN_MIGRATE:
>>>> +		return kvm_psci_call(vcpu);
>>>
>>> You might want to handle these from the main call handler with a giant
>>> disclaimer that these values predate SMCCC and therefore collide with
>>> the standard hypervisor service range.
>>>
>>> [...]
>>>
>>
>> I probably just keep it as it is to follow the rule: to route
>> based on the owner strictly. Besides, there are 3 levels to
>> handle SMCCCs after this patch is applied, which corresponds
>> to 3 handlers as main/owner/function. It sounds more natural
>> for reader to follow the implementation in this way.
> 
> I think this makes it much more confusing for the reader, as you'd be
> hard pressed to find these function IDs in the SMCCC spec. Since their
> values are outside of the specification, it is confusing to only address
> them after these switch statements have decided that they belong to a
> particular service owner as they do not.
> 

Ok. Lets filter these SMCCC PSCI numbers in kvm_hvc_call_handler():

     /* Filter these calls that aren't documented in the specification */
     if (func >= KVM_PSCI_FN_CPU_SUSPEND && func <= KVM_PSCI_FN_MIGRATE)
         return kvm_psci_call(vcpu);

     switch (ARM_SMCCC_OWNER_NUM(func)) {
         :
     }

Thanks,
Gavin

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
