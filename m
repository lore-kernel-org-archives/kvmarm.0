Return-Path: <SRS0=nct1=JE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFFDCC433ED
	for <kvmarm@archiver.kernel.org>; Wed,  7 Apr 2021 15:52:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 432576138B
	for <kvmarm@archiver.kernel.org>; Wed,  7 Apr 2021 15:52:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 432576138B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C3FA24B919;
	Wed,  7 Apr 2021 11:52:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vGnFDC29Fuax; Wed,  7 Apr 2021 11:52:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6FC004B8E4;
	Wed,  7 Apr 2021 11:52:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD4714B8BF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Apr 2021 11:52:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7ownYbcCtTF0 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Apr 2021 11:52:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 507E14B637
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Apr 2021 11:52:47 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D779C1063;
 Wed,  7 Apr 2021 08:52:46 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F3F543F694;
 Wed,  7 Apr 2021 08:52:43 -0700 (PDT)
Subject: Re: [PATCH v10 2/6] arm64: kvm: Introduce MTE VM feature
To: Catalin Marinas <catalin.marinas@arm.com>
References: <20210327152324.GA28167@arm.com> <20210328122131.GB17535@arm.com>
 <e0b88560-34e1-dcc4-aaa7-9a7a5b771824@arm.com>
 <20210330103013.GD18075@arm.com>
 <8977120b-841d-4882-2472-6e403bc9c797@redhat.com>
 <20210331092109.GA21921@arm.com>
 <d545a051-a02a-4c3a-0afe-66612839ba32@redhat.com>
 <86a968c8-7a0e-44a4-28c3-bac62c2b7d65@arm.com>
 <20210331184311.GA10737@arm.com>
 <e2612bd8-b356-a9cd-cfdf-26f4aa813578@arm.com>
 <20210407151458.GC21451@arm.com>
From: Steven Price <steven.price@arm.com>
Message-ID: <5e5bf772-1e4d-ca59-a9d8-058a72dfad4f@arm.com>
Date: Wed, 7 Apr 2021 16:52:54 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210407151458.GC21451@arm.com>
Content-Language: en-GB
Cc: David Hildenbrand <david@redhat.com>, Marc Zyngier <maz@kernel.org>,
 Richard Henderson <richard.henderson@linaro.org>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Juan Quintela <quintela@redhat.com>, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, Dave Martin <Dave.Martin@arm.com>,
 linux-kernel@vger.kernel.org
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

On 07/04/2021 16:14, Catalin Marinas wrote:
> On Wed, Apr 07, 2021 at 11:20:18AM +0100, Steven Price wrote:
>> On 31/03/2021 19:43, Catalin Marinas wrote:
>>> When a slot is added by the VMM, if it asked for MTE in guest (I guess
>>> that's an opt-in by the VMM, haven't checked the other patches), can we
>>> reject it if it's is going to be mapped as Normal Cacheable but it is a
>>> ZONE_DEVICE (i.e. !kvm_is_device_pfn() + one of David's suggestions to
>>> check for ZONE_DEVICE)? This way we don't need to do more expensive
>>> checks in set_pte_at().
>>
>> The problem is that KVM allows the VMM to change the memory backing a slot
>> while the guest is running. This is obviously useful for the likes of
>> migration, but ultimately means that even if you were to do checks at the
>> time of slot creation, you would need to repeat the checks at set_pte_at()
>> time to ensure a mischievous VMM didn't swap the page for a problematic one.
> 
> Does changing the slot require some KVM API call? Can we intercept it
> and do the checks there?

As David has already replied - KVM uses MMU notifiers, so there's not 
really a good place to intercept this before the fault.

> Maybe a better alternative for the time being is to add a new
> kvm_is_zone_device_pfn() and force KVM_PGTABLE_PROT_DEVICE if it returns
> true _and_ the VMM asked for MTE in guest. We can then only set
> PG_mte_tagged if !device.

KVM already has a kvm_is_device_pfn(), and yes I agree restricting the 
MTE checks to only !kvm_is_device_pfn() makes sense (I have the fix in 
my branch locally).

> We can later relax this further to Normal Non-cacheable for ZONE_DEVICE
> memory (via a new KVM_PGTABLE_PROT_NORMAL_NC) or even Normal Cacheable
> if we manage to change the behaviour of the architecture.

Indeed, it'll be interesting to see whether people want to build MTE 
capable systems with significant quantities of non-MTE capable memory. 
But for a first stage let's stick with either all guest memory (except 
devices) is MTE or you disable MTE for the guest.

>>> We could add another PROT_TAGGED or something which means PG_mte_tagged
>>> set but still mapped as Normal Untagged. It's just that we are short of
>>> pte bits for another flag.
>>
>> That could help here - although it's slightly odd as you're asking the
>> kernel to track the tags, but not allowing user space (direct) access to
>> them. Like you say using us the precious bits for this seems like it might
>> be short-sighted.
> 
> Yeah, let's scrap this idea. We set PG_mte_tagged in user_mem_abort(),
> so we already know it's a page potentially containing tags. On
> restoring from swap, we need to check for MTE metadata irrespective of
> whether the user pte is tagged or not, as you already did in patch 1.
> I'll get back to that and look at the potential races.
> 
> BTW, after a page is restored from swap, how long do we keep the
> metadata around? I think we can delete it as soon as it was restored and
> PG_mte_tagged was set. Currently it looks like we only do this when the
> actual page was freed or swapoff. I haven't convinced myself that it's
> safe to do this for swapoff unless it guarantees that all the ptes
> sharing a page have been restored.
> 

My initial thought was to free the metadata immediately. However it 
turns out that the following sequence can happen:

  1. Swap out a page
  2. Swap the page in *read only*
  3. Discard the page
  4. Swap the page in again

So there's no writing of the swap data again before (3). This works 
nicely with a swap device because after writing a page it stays there 
forever, so if you know it hasn't been modified it's pointless rewriting 
it. Sadly it's not quite so ideal with the MTE tags which are currently 
kept in RAM. Arguably it would make sense to modify the on-disk swap 
format to include the tags - but that would open a whole new can of worms!

swapoff needs to ensure that all the PTEs have been restored because 
after the swapoff has completed the PTEs will be pointing at a swap 
entry which is no longer valid (and could even have been reallocated to 
point to a new swap device). When you issue you a swapoff, Linux will 
scan the mmlist and the page tables of every process to search for swap 
entry PTEs relating to the swap which is being removed (see try_to_unuse()).

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
