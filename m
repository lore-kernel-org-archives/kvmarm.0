Return-Path: <SRS0=nct1=JE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 689CAC433ED
	for <kvmarm@archiver.kernel.org>; Wed,  7 Apr 2021 15:30:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D571F61262
	for <kvmarm@archiver.kernel.org>; Wed,  7 Apr 2021 15:30:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D571F61262
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 34B554B94D;
	Wed,  7 Apr 2021 11:30:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K+U1-kuoPyyT; Wed,  7 Apr 2021 11:30:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EAC94B93C;
	Wed,  7 Apr 2021 11:30:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD6884B93C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Apr 2021 11:30:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id lb-9hqh+ZIKX for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Apr 2021 11:30:16 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C89A64B902
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Apr 2021 11:30:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1617809416;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=rHuby28rSVBEts9hw5b8nEC5zGAh17eoAFfYGcwxu7Q=;
 b=awPx9a2vwTN4p952M82G/jwtY58/A8s3b1z/Rzq0iPWs9JdDHx9ReGBuG2gwV/Civb5YCt
 0lGD3e8wMmWpyusy/8DpKxc3M49gQ5acuaA6TJBGHgrR8//zQlR3HTyyc0f2aI3/8mZZ1P
 WVGfosDMASoqudRJwFRuOwldUPvdhNw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-180-H2GLtm1WMquhgnK143jYrw-1; Wed, 07 Apr 2021 11:30:14 -0400
X-MC-Unique: H2GLtm1WMquhgnK143jYrw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com
 [10.5.11.23])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 08789107ACF2;
 Wed,  7 Apr 2021 15:30:12 +0000 (UTC)
Received: from [10.36.114.68] (ovpn-114-68.ams2.redhat.com [10.36.114.68])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 1B45419C78;
 Wed,  7 Apr 2021 15:30:06 +0000 (UTC)
To: Catalin Marinas <catalin.marinas@arm.com>,
 Steven Price <steven.price@arm.com>
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
From: David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Subject: Re: [PATCH v10 2/6] arm64: kvm: Introduce MTE VM feature
Message-ID: <396423df-5c30-67f6-fcba-c041c08eef7e@redhat.com>
Date: Wed, 7 Apr 2021 17:30:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210407151458.GC21451@arm.com>
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
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

On 07.04.21 17:14, Catalin Marinas wrote:
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

User space can simply mmap(MAP_FIXED) the user space area registered in 
a KVM memory slot. You cannot really intercept that. You can only check 
in the KVM MMU code at fault time that the VMA which you hold in your 
hands is still in a proper state. The KVM MMU is synchronous, which 
means that updates to the VMA layout are reflected in the KVM MMU page 
tables -- e.g., via mmu notifier calls.

E.g., in s390x code we cannot handle VMAs with gigantic pages. We check 
that when faulting (creating the links in the page table) via __gmap_link().

You could either check the page itself (ZONE_DEVICE) or might even be 
able to check via the VMA/file.

-- 
Thanks,

David / dhildenb

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
