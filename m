Return-Path: <SRS0=9OIH=S4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 931A4C43219
	for <kvmarm@archiver.kernel.org>; Fri, 26 Apr 2019 15:03:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 17E9E2084F
	for <kvmarm@archiver.kernel.org>; Fri, 26 Apr 2019 15:03:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 17E9E2084F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A6754A485;
	Fri, 26 Apr 2019 11:03:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id QLfRUDzeDN3e; Fri, 26 Apr 2019 11:03:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07B7F4A48C;
	Fri, 26 Apr 2019 11:03:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A1F94A470
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Apr 2019 11:03:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9YQAT3DukrhX for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Apr 2019 11:03:06 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 94B094A331
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Apr 2019 11:03:06 -0400 (EDT)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com
 [10.5.11.12])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mx1.redhat.com (Postfix) with ESMTPS id 859CB31649AE;
 Fri, 26 Apr 2019 15:03:04 +0000 (UTC)
Received: from [10.36.116.17] (ovpn-116-17.ams2.redhat.com [10.36.116.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 2ED3B60FD6;
 Fri, 26 Apr 2019 15:03:00 +0000 (UTC)
Subject: Re: [PATCH v4 2/2] KVM: doc: add API documentation on the
 KVM_REG_ARM_WORKAROUNDS register
To: Andre Przywara <andre.przywara@arm.com>
References: <20190228234334.20456-1-andre.przywara@arm.com>
 <20190228234334.20456-3-andre.przywara@arm.com>
 <60c2e180-03aa-1b9e-f19c-90d890b99d15@redhat.com>
 <20190415133353.04304c45@donnerap.cambridge.arm.com>
From: Auger Eric <eric.auger@redhat.com>
Message-ID: <c818b9e0-d8de-40f0-7ebc-f2871dfcbeee@redhat.com>
Date: Fri, 26 Apr 2019 17:02:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190415133353.04304c45@donnerap.cambridge.arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16
 (mx1.redhat.com [10.5.110.41]); Fri, 26 Apr 2019 15:03:04 +0000 (UTC)
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
 Dave Martin <dave.martin@arm.com>, Steven Price <steven.price@arm.com>,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190426150258.bDWN23bWuypw_UnjmXUuGQRYRYTuS_9L-ALOBR-skRE@z>

Hi Andre,

On 4/15/19 2:34 PM, Andre Przywara wrote:
> On Thu, 21 Mar 2019 13:33:18 +0100
> Auger Eric <eric.auger@redhat.com> wrote:
> 
> Hi Eric,
> 
> many thanks for the feedback, turns out that this description here is
> somewhat tricky. We only really care about the guest's view, but the
> various host states (support configured out, disabled on the command line,
> not supported by firmware, not needed on this CPU) play into this as well.
> So in my understanding the information presented here does not necessarily
> copy the information returned by the firmware interface, it just presents
> what the guest can expect from the firmware interface.
> 
> I tried to reword the description in v5 to address any ambiguities,
> meanwhile trying to answer your specific questions below.
> Please have a look at v5 and tell me if that is clearer now.
> 
>> On 3/1/19 12:43 AM, Andre Przywara wrote:
>>> Add documentation for the newly defined firmware registers to save and
>>> restore any vulnerability migitation status.  
>> s/migitation/mitigation
>>>
>>> Signed-off-by: Andre Przywara <andre.przywara@arm.com>
>>> ---
>>>  Documentation/virtual/kvm/arm/psci.txt | 25 +++++++++++++++++++++++++
>>>  1 file changed, 25 insertions(+)
>>>
>>> diff --git a/Documentation/virtual/kvm/arm/psci.txt b/Documentation/virtual/kvm/arm/psci.txt
>>> index aafdab887b04..1ed0f0515cd8 100644
>>> --- a/Documentation/virtual/kvm/arm/psci.txt
>>> +++ b/Documentation/virtual/kvm/arm/psci.txt
>>> @@ -28,3 +28,28 @@ The following register is defined:
>>>    - Allows any PSCI version implemented by KVM and compatible with
>>>      v0.2 to be set with SET_ONE_REG
>>>    - Affects the whole VM (even if the register view is per-vcpu)
>>> +
>>> +* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
>>> +  Holds the state of the firmware controlled workaround to mitigate
>>> +  CVE-2017-5715, as described under SMCCC_ARCH_WORKAROUND_1 in [1].> +  Accepted values are:
>>> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL: Workaround not available.
>>> +      The mitigation status for the guest is unknown.
>>> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL: The workaround HVC call is
>>> +      available to the guest and required for the mitigation.  
>> It is unclear to me why we don't report the actual enable status too as
>> for WA2. Assuming the mitigation is not applied on the source (ie. AVAIL
>> but SMCCC_ARCH_WORKAROUND_1 not called), do we need it on the destination?
> 
> In contrast to WORKAROUND_2 this one here is stateless. KVM potentially
> offers the HVC call and says whether it's needed or not: What the guest
> makes out of it, is up to the guest's discretion. The guest has to call
> this HVC every time it wants to mitigate the issue. KVM needs to maintain
> continuity on migration regarding offering this HVC call and its effect.
OK that's clear now. Thank you for the explanations.
> 
>>> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_UNAFFECTED: The workaround HVC call
>>> +      is available to the guest, but it is not needed on this VCPU.
>>> +
>>> +* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
>>> +  Holds the state of the firmware controlled workaround to mitigate
>>> +  CVE-2018-3639, as described under SMCCC_ARCH_WORKAROUND_2 in [1].  
>> This does not really match the terminology used in [1]. At least it is
>> not straightforward to me.
> 
> Not really sure what you mean by this, exactly?

Well I meant the SMCCC spec uses the
NOT_SUPPORTED, NOT_REQUIRED. The difficulty somewhat is each layer has a
different terminology, SMCC spec, kernel, user and the translation was
not straightforward to me.
> 
>>> +  Accepted values are:
>>> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL: Workaround not available.
>>> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN: Workaround state unknown.  
>> both included in NOT_SUPPORTED. By the way why did we need to be more
>> precise here? Seems WA1 also has the UNKNOWN state as part of
>> UNSUPPORTED. Why isn't it homogeneous?
> 
> Most differences originate in the statelessness of WORKAROUND_1. Also we
> have this information here in the host kernel: NOT_AVAIL is returned when
> the workaround has been explicitly disabled on the command line, UNKNOWN
> is used when the workaround has been configured out.
> We use this to avoid migration to a "worse place": UNKNOWN is never worse
> than "not available".
> 
>>> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL: Workaround available, and can
>>> +      be disabled by a vCPU. If KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED is
>>> +      set, it is active for this vCPU.
>>> +    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED: Workaround always active  
>> NOT_REQUIRED or 1?
> 
> I think we don't care. KVM always offers this HVC call. I think the trick
> here is that is not the firmware interface, but a description of it. It
> just tells what the guest is able to call, we don't copy the results of
> the firmware call in here.
Yes the confusion came that only the FW spec gets quoted. To understand
the uapi definition knowledge about the overall mitigation scheme is
requested.

Thanks

Eric
> 
> Cheers,
> Andre.
> 
> 
>>> +      or not needed.
>>> +
>>> +[1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
>>>   
>> Thanks
>>
>> Eric
> 
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
