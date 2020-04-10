Return-Path: <SRS0=QOrb=52=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE499C2BA2B
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 11:19:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 48B7C20753
	for <kvmarm@archiver.kernel.org>; Fri, 10 Apr 2020 11:19:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=xen.org header.i=@xen.org header.b="Lz/PnyNY"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 48B7C20753
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=xen.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8BFFF4B0BA;
	Fri, 10 Apr 2020 07:19:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@xen.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Ol7NQ9RRdb60; Fri, 10 Apr 2020 07:19:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AB4B34B188;
	Fri, 10 Apr 2020 07:19:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 132734B085
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 06:14:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EFgsr65hZ1Su for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Apr 2020 06:14:52 -0400 (EDT)
Received: from mail.xenproject.org (mail.xenproject.org [104.130.215.37])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 22C374A551
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Apr 2020 06:14:52 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=xen.org;
 s=20200302mail; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
 MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=LP9i8n5XWnZnXoSDgVk2SDbe3JT7yVCp8/P3iO2zZ/c=; b=Lz/PnyNYCQe1my1jMCVbQ1l2wI
 OKl2n/UEcRhAFyx6OvklPc2kikUnD6gbjCqtQeZ/Zy+E4RCwJrJ66fqrYeTvBBZ1+2QGJNWBy5V5O
 yCYDOb37ETvjB9ItpFOdYxe98Or0fDGEUY2SWy9KFpR5R72ptduDg1Q6V4YayeB5t0Wo=;
Received: from xenbits.xenproject.org ([104.239.192.120])
 by mail.xenproject.org with esmtp (Exim 4.89)
 (envelope-from <julien@xen.org>)
 id 1jMqgJ-0003HN-1p; Fri, 10 Apr 2020 10:14:39 +0000
Received: from [54.239.6.186] (helo=a483e7b01a66.ant.amazon.com)
 by xenbits.xenproject.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.89)
 (envelope-from <julien@xen.org>)
 id 1jMqgI-0008Ty-QB; Fri, 10 Apr 2020 10:14:38 +0000
Subject: Re: I{S,C}ACTIVER implemention question
To: Marc Zyngier <maz@kernel.org>
References: <c90bdfa0-00cf-170b-4319-e270e8aaef7e@xen.org>
 <2a201532b992fca74b4f193f53fc71f9@kernel.org>
From: Julien Grall <julien@xen.org>
Message-ID: <34b86a31-6ea3-8c58-9892-5caf29ec5053@xen.org>
Date: Fri, 10 Apr 2020 11:14:36 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <2a201532b992fca74b4f193f53fc71f9@kernel.org>
Content-Language: en-GB
X-Mailman-Approved-At: Fri, 10 Apr 2020 07:19:01 -0400
Cc: Stefano Stabellini <sstabellini@kernel.org>, George.Dunlap@eu.citrix.com,
 Bertrand Marquis <Bertrand.Marquis@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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



On 06/04/2020 16:14, Marc Zyngier wrote:
> Hi Julien,

Hi Marc,

> 
> Thanks for the heads up.
> 
> On 2020-04-06 14:16, Julien Grall wrote:
>> Hi,
>>
>> Xen community is currently reviewing a new implementation for reading
>> I{S,C}ACTIVER registers (see [1]).
>>
>> The implementation is based on vgic_mmio_read_active() in KVM, i.e the
>> active state of the interrupts is based on the vGIC state stored in
>> memory.
>>
>> While reviewing the patch on xen-devel, I noticed a potential deadlock
>> at least with Xen implementation. I know that Xen vGIC and KVM vGIC
>> are quite different, so I looked at the implementation to see how this
>> is dealt.
>>
>> With my limited knowledge of KVM, I wasn't able to rule it out. I am
>> curious to know if I missed anything.
>>
>> vCPU A may read the active state of an interrupt routed to vCPU B.
>> When vCPU A is reading the state, it will read the state stored in
>> memory.
>>
>> The only way the memory state can get synced with the HW state is when
>> vCPU B exit guest context.
>>
>> AFAICT, vCPU B will not exit when deactivating HW mapped interrupts
>> and virtual edge interrupts. So vCPU B may run for an abritrary long
>> time before been exiting and syncing the memory state with the HW
>> state.
> 
> So while I agree that this is definitely not ideal, I don't think we end-up
> with a deadlock (or rather a livelock) either. That's because we are 
> guaranteed
> to exit eventually if only because the kernel's own timer interrupt (or any
> other host interrupt routed to the same physical CPU) will fire and get us
> out of there. On its own, this is enough to allow the polling vcpu to make
> forward progress.

That's a good point. I think in Xen we can't rely on this because in 
some of the setup (such as a pCPU dedicated to a vCPU), there will be 
close to zero host interrupts (timer is only used for scheduling).

> 
> Now, it is obvious that we should improve on the current situation. I just
> hacked together a patch that provides the same guarantees as the one we
> already have on the write side (kick all vcpus out of the guest, snapshot
> the state, kick everyone back in). I boot-tested it, so it is obviously 
> perfect
> and won't eat your data at all! ;-)

Thank you for the patch! This is the similar to what I had in mind.

Cheers,

-- 
Julien Grall
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
