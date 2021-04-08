Return-Path: <SRS0=McpZ=JF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A5B1C433ED
	for <kvmarm@archiver.kernel.org>; Thu,  8 Apr 2021 18:16:34 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 87840610CA
	for <kvmarm@archiver.kernel.org>; Thu,  8 Apr 2021 18:16:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 87840610CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5A214B8F2;
	Thu,  8 Apr 2021 14:16:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nRccgS3IxlSd; Thu,  8 Apr 2021 14:16:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B3FFB4BB25;
	Thu,  8 Apr 2021 14:16:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F0F6C4B8F3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Apr 2021 14:16:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BERenBsVNho2 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Apr 2021 14:16:30 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [63.128.21.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03DB64B8F2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Apr 2021 14:16:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617905789;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=a+ZAM3G9QEbZhESupLgtt9XPr4Jta/bTYgM9EuA2Thw=;
 b=F0c5YJiKvEgKZZoboH/bZx9WwMN/8NUIaGx3Lhxnq1D9qK+FdiHHLz2DPhzUThgiqrfjCq
 63CchNhZZH/OpPhXK1tiGkOFfOiz5+gDaQY7XUUUoO7CwO+8lFoXib+ZS7WfE0lD7EH4z0
 BtKlG/senbKLpz5cBOZS8tnyRB4d2qg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-568-v5LP_p_OOEqJQ2MwT-ujmw-1; Thu, 08 Apr 2021 14:16:27 -0400
X-MC-Unique: v5LP_p_OOEqJQ2MwT-ujmw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com
 [10.5.11.16])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DA6E384B9A0;
 Thu,  8 Apr 2021 18:16:25 +0000 (UTC)
Received: from [10.36.113.26] (ovpn-113-26.ams2.redhat.com [10.36.113.26])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 542815C1C4;
 Thu,  8 Apr 2021 18:16:18 +0000 (UTC)
Subject: Re: [PATCH v10 2/6] arm64: kvm: Introduce MTE VM feature
To: Catalin Marinas <catalin.marinas@arm.com>,
 Steven Price <steven.price@arm.com>
References: <e0b88560-34e1-dcc4-aaa7-9a7a5b771824@arm.com>
 <20210330103013.GD18075@arm.com>
 <8977120b-841d-4882-2472-6e403bc9c797@redhat.com>
 <20210331092109.GA21921@arm.com>
 <d545a051-a02a-4c3a-0afe-66612839ba32@redhat.com>
 <86a968c8-7a0e-44a4-28c3-bac62c2b7d65@arm.com>
 <20210331184311.GA10737@arm.com>
 <e2612bd8-b356-a9cd-cfdf-26f4aa813578@arm.com>
 <20210407151458.GC21451@arm.com>
 <5e5bf772-1e4d-ca59-a9d8-058a72dfad4f@arm.com>
 <20210408141853.GA7676@arm.com>
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <bfcd1c41-92fb-d4ee-34b1-7beb6b6c9fd8@redhat.com>
Date: Thu, 8 Apr 2021 20:16:17 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210408141853.GA7676@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Cc: Marc Zyngier <maz@kernel.org>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>,
 "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 Thomas Gleixner <tglx@linutronix.de>, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 08.04.21 16:18, Catalin Marinas wrote:
> On Wed, Apr 07, 2021 at 04:52:54PM +0100, Steven Price wrote:
>> On 07/04/2021 16:14, Catalin Marinas wrote:
>>> On Wed, Apr 07, 2021 at 11:20:18AM +0100, Steven Price wrote:
>>>> On 31/03/2021 19:43, Catalin Marinas wrote:
>>>>> When a slot is added by the VMM, if it asked for MTE in guest (I guess
>>>>> that's an opt-in by the VMM, haven't checked the other patches), can we
>>>>> reject it if it's is going to be mapped as Normal Cacheable but it is a
>>>>> ZONE_DEVICE (i.e. !kvm_is_device_pfn() + one of David's suggestions to
>>>>> check for ZONE_DEVICE)? This way we don't need to do more expensive
>>>>> checks in set_pte_at().
>>>>
>>>> The problem is that KVM allows the VMM to change the memory backing a slot
>>>> while the guest is running. This is obviously useful for the likes of
>>>> migration, but ultimately means that even if you were to do checks at the
>>>> time of slot creation, you would need to repeat the checks at set_pte_at()
>>>> time to ensure a mischievous VMM didn't swap the page for a problematic one.
>>>
>>> Does changing the slot require some KVM API call? Can we intercept it
>>> and do the checks there?
>>
>> As David has already replied - KVM uses MMU notifiers, so there's not really
>> a good place to intercept this before the fault.
>>
>>> Maybe a better alternative for the time being is to add a new
>>> kvm_is_zone_device_pfn() and force KVM_PGTABLE_PROT_DEVICE if it returns
>>> true _and_ the VMM asked for MTE in guest. We can then only set
>>> PG_mte_tagged if !device.
>>
>> KVM already has a kvm_is_device_pfn(), and yes I agree restricting the MTE
>> checks to only !kvm_is_device_pfn() makes sense (I have the fix in my branch
>> locally).
> 
> Indeed, you can skip it if kvm_is_device_pfn(). In addition, with MTE,
> I'd also mark a pfn as 'device' in user_mem_abort() if
> pfn_to_online_page() is NULL as we don't want to map it as Cacheable in
> Stage 2. It's unlikely that we'll trip over this path but just in case.
> 
> (can we have a ZONE_DEVICE _online_ pfn or by definition they are
> considered offline?)

By definition (and implementation) offline. When you get a page = 
pfn_to_online_page() with page != NULL, that one should never be 
ZONE_DEVICE (otherwise it would be a BUG).

As I said, things are different when exposing dax memory via dax/kmem to 
the buddy. But then, we are no longer talking about ZONE_DEVICE.

-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
