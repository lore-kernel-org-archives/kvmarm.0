Return-Path: <SRS0=KDMR=AR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFAABC433E1
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 07:54:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 757942073E
	for <kvmarm@archiver.kernel.org>; Mon,  6 Jul 2020 07:54:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="nnFYAtyE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 757942073E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 011924B419;
	Mon,  6 Jul 2020 03:54:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TUEnf8YYRaAV; Mon,  6 Jul 2020 03:54:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D032D4B3D1;
	Mon,  6 Jul 2020 03:54:09 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC5F94B3C5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2020 03:54:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZBfG-s4jZ-6O for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Jul 2020 03:54:07 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CFBD4B36B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Jul 2020 03:54:07 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 721292070C;
 Mon,  6 Jul 2020 07:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1594022046;
 bh=LTkW7ZOgh52aEUoTRJGndtpVXZlqePOvqTFOIhj/xj4=;
 h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
 b=nnFYAtyEJsFj8lTYSIqofkAV9WqcL4o8QsXpZwp6R9QVfMplMI6/a9o4QawTX8OYD
 47EfKkJsZ4wWHTSrZ0C5iY0ZxJCQXxCR5ySTiUzPF0R0CFjqgiey6ADBmHaR1aYL2l
 rKyZWUtU8/sQCMFG6mfbeOY667wmu+ZzvYFskaVw=
Received: from disco-boy.misterjones.org ([51.254.78.96] helo=www.loen.fr)
 by disco-boy.misterjones.org with esmtpsa
 (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jsLwz-009OR0-2C; Mon, 06 Jul 2020 08:54:05 +0100
MIME-Version: 1.0
Date: Mon, 06 Jul 2020 08:54:04 +0100
From: Marc Zyngier <maz@kernel.org>
To: zhukeqian <zhukeqian1@huawei.com>
Subject: Re: [PATCH v2 0/8] KVM: arm64: Support HW dirty log based on DBM
In-Reply-To: <e120ec04-24d5-f1cb-3aa2-8baf3d6da1db@huawei.com>
References: <20200702135556.36896-1-zhukeqian1@huawei.com>
 <e120ec04-24d5-f1cb-3aa2-8baf3d6da1db@huawei.com>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <015847afd67e8bd4f8a158b604854838@kernel.org>
X-Sender: maz@kernel.org
X-SA-Exim-Connect-IP: 51.254.78.96
X-SA-Exim-Rcpt-To: zhukeqian1@huawei.com, catalin.marinas@arm.com,
 kvmarm@lists.cs.columbia.edu, wanghaibin.wang@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu
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

Hi Keqian,

On 2020-07-06 02:28, zhukeqian wrote:
> Hi Catalin and Marc,
> 
> On 2020/7/2 21:55, Keqian Zhu wrote:
>> This patch series add support for dirty log based on HW DBM.
>> 
>> It works well under some migration test cases, including VM with 4K
>> pages or 2M THP. I checked the SHA256 hash digest of all memory and
>> they keep same for source VM and destination VM, which means no dirty
>> pages is missed under hardware DBM.
>> 
>> Some key points:
>> 
>> 1. Only support hardware updates of dirty status for PTEs. PMDs and 
>> PUDs
>>    are not involved for now.
>> 
>> 2. About *performance*: In RFC patch, I have mentioned that for every 
>> 64GB
>>    memory, KVM consumes about 40ms to scan all PTEs to collect dirty 
>> log.
>>    This patch solves this problem through two ways: HW/SW dynamic 
>> switch
>>    and Multi-core offload.
>> 
>>    HW/SW dynamic switch: Give userspace right to enable/disable hw 
>> dirty
>>    log. This adds a new KVM cap named KVM_CAP_ARM_HW_DIRTY_LOG. We can
>>    achieve this by change the kvm->arch.vtcr value and kick vCPUs out 
>> to
>>    reload this value to VCTR_EL2. Then userspace can enable hw dirty 
>> log
>>    at the begining and disable it when dirty pages is little and about 
>> to
>>    stop VM, so VM downtime is not affected.
>> 
>>    Multi-core offload: Offload the PT scanning workload to multi-core 
>> can
>>    greatly reduce scanning time. To promise we can complete in time, I 
>> use
>>    smp_call_fuction to realize this policy, which utilize IPI to 
>> dispatch
>>    workload to other CPUs. Under 128U Kunpeng 920 platform, it just 
>> takes
>>    about 5ms to scan PTs of 256 RAM (use mempress and almost all PTs 
>> have
>>    been established). And We dispatch workload iterately (every CPU 
>> just
>>    scan PTs of 512M RAM for each iteration), so it won't affect 
>> physical
>>    CPUs seriously.
> 
> What do you think of these two methods to solve high-cost PTs scaning? 
> Maybe
> you are waiting for PML like feature on ARM :-) , but for my test, DBM 
> is usable
> after these two methods applied.

Useable, maybe. But leaving to userspace the decision to switch from one
mode to another isn't an acceptable outcome. Userspace doesn't need nor
want to know about this.

Another thing is that sending IPIs all over to trigger scanning may
work well on a system that runs a limited number of guests (or some
other userspace, actually), but I seriously doubt that it is impact
free once you start doing this on an otherwise loaded system.

You may have better results by having an alternative mapping of your
S2 page tables so that they are accessible linearly, which would
sidestep the PT parsing altogether, probably saving some cycles. But
this is still a marginal gain compared to the overall overhead of
scanning 4kB of memory per 2MB of guest RAM, as opposed to 64 *bytes*
per 2MB (assuming strict 4kB mappings at S2, no block mappings).

Finally, this doesn't work with pages dirtied from DMA, which is the
biggest problem. If you cannot track pages that are dirtied behind your
back, what is the purpose of scanning the dirty bits?

As for a PML-like feature, this would only be useful if the SMMU
architecture took part in it and provided consistent logging of
the dirtied pages in the IPA space. Only having it at the CPU level
would be making the exact same mistake.

So, given the above, I remain unconvinced by this approach.

Thanks,

         M.
-- 
Jazz is not dead. It just smells funny...
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
