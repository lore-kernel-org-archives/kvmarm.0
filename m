Return-Path: <SRS0=KxuI=OA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11434C433FE
	for <kvmarm@archiver.kernel.org>; Fri, 10 Sep 2021 08:27:31 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 71AF6611C6
	for <kvmarm@archiver.kernel.org>; Fri, 10 Sep 2021 08:27:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 71AF6611C6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F3AB84B16F;
	Fri, 10 Sep 2021 04:27:29 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1MUsFr9IgcQ7; Fri, 10 Sep 2021 04:27:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BC0534B186;
	Fri, 10 Sep 2021 04:27:28 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5DF204B16F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Sep 2021 04:27:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 52jPH7FZWtLP for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Sep 2021 04:27:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2A1F4B11E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Sep 2021 04:27:25 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 541A331B;
 Fri, 10 Sep 2021 01:27:25 -0700 (PDT)
Received: from [192.168.0.110] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 08FA13F59C;
 Fri, 10 Sep 2021 01:27:22 -0700 (PDT)
Subject: Re: [PATCH 1/2] KVM: arm64: vgic: check redist region is not above
 the VM IPA size
To: Ricardo Koller <ricarkol@google.com>
References: <20210908210320.1182303-1-ricarkol@google.com>
 <20210908210320.1182303-2-ricarkol@google.com>
 <b368e9cf-ec28-1768-edf9-dfdc7fa108f8@arm.com> <YTo6kX7jGeR3XvPg@google.com>
From: Alexandru Elisei <alexandru.elisei@arm.com>
Message-ID: <5eb41efd-2ff2-d25b-5801-f4a56457a09f@arm.com>
Date: Fri, 10 Sep 2021 09:28:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <YTo6kX7jGeR3XvPg@google.com>
Content-Language: en-US
Cc: kvm@vger.kernel.org, maz@kernel.org, pshier@google.com,
 Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Ricardo,

On 9/9/21 5:47 PM, Ricardo Koller wrote:
> On Thu, Sep 09, 2021 at 11:20:15AM +0100, Alexandru Elisei wrote:
>> Hi Ricardo,
>>
>> On 9/8/21 10:03 PM, Ricardo Koller wrote:
>>> Extend vgic_v3_check_base() to verify that the redistributor regions
>>> don't go above the VM-specified IPA size (phys_size). This can happen
>>> when using the legacy KVM_VGIC_V3_ADDR_TYPE_REDIST attribute with:
>>>
>>>   base + size > phys_size AND base < phys_size
>>>
>>> vgic_v3_check_base() is used to check the redist regions bases when
>>> setting them (with the vcpus added so far) and when attempting the first
>>> vcpu-run.
>>>
>>> Signed-off-by: Ricardo Koller <ricarkol@google.com>
>>> ---
>>>  arch/arm64/kvm/vgic/vgic-v3.c | 4 ++++
>>>  1 file changed, 4 insertions(+)
>>>
>>> diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
>>> index 66004f61cd83..5afd9f6f68f6 100644
>>> --- a/arch/arm64/kvm/vgic/vgic-v3.c
>>> +++ b/arch/arm64/kvm/vgic/vgic-v3.c
>>> @@ -512,6 +512,10 @@ bool vgic_v3_check_base(struct kvm *kvm)
>>>  		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
>>>  			rdreg->base)
>>>  			return false;
>>> +
>>> +		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) >
>>> +			kvm_phys_size(kvm))
>>> +			return false;
>> Looks to me like this same check (and the overflow one before it) is done when
>> adding a new Redistributor region in kvm_vgic_addr() -> vgic_v3_set_redist_base()
>> -> vgic_v3_alloc_redist_region() -> vgic_check_ioaddr(). As far as I can tell,
>> kvm_vgic_addr() handles both ways of setting the Redistributor address.
>>
>> Without this patch, did you manage to set a base address such that base + size >
>> kvm_phys_size()?
>>
> Yes, with the KVM_VGIC_V3_ADDR_TYPE_REDIST legacy API. The easiest way
> to get to this situation is with the selftest in patch 2.  I then tried
> an extra experiment: map the first redistributor, run the first vcpu,
> and access the redist from inside the guest. KVM didn't complain in any
> of these steps.

Yes, Eric pointed out that I was mistaken and there is no check being done for
base + size > kvm_phys_size().

What I was trying to say is that this check is better done when the user creates a
Redistributor region, not when a VCPU is first run. We have everything we need to
make the check when a region is created, why wait until the VCPU is run?

For example, vgic_v3_insert_redist_region() is called each time the adds a new
Redistributor region (via either of the two APIs), and already has a check for the
upper limit overflowing (identical to the check in vgic_v3_check_base()). I would
add the check against the maximum IPA size there.

Also, because vgic_v3_insert_redist_region() already checks for overflow, I
believe the overflow check in vgic_v3_check_base() is redundant.

As far as I can tell, vgic_v3_check_base() is there to make sure that the
Distributor doesn't overlap with any of the Redistributors, and because the
Redistributors and the Distributor can be created in any order, we defer the check
until the first VCPU is run. I might be wrong about this, someone please correct
me if I'm wrong.

Also, did you verify that KVM is also doing this check for GICv2? KVM does
something similar and calls vgic_v2_check_base() when mapping the GIC resources,
and I don't see a check for the maximum IPA size in that function either.

Thanks,

Alex

>
> Thanks,
> Ricardo
>
>> Thanks,
>>
>> Alex
>>
>>>  	}
>>>  
>>>  	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
