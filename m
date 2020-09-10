Return-Path: <SRS0=WCH4=CT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A41FC43461
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 10:25:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E8E832078E
	for <kvmarm@archiver.kernel.org>; Thu, 10 Sep 2020 10:25:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E8E832078E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 31B3F4B3B8;
	Thu, 10 Sep 2020 06:25:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id IbA-fwPv21Vc; Thu, 10 Sep 2020 06:25:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2335E4B3EA;
	Thu, 10 Sep 2020 06:25:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 612CE4B3D5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 06:25:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4ENHAsM-mgwg for <kvmarm@lists.cs.columbia.edu>;
 Thu, 10 Sep 2020 06:24:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AC924B3B8
 for <kvmarm@lists.cs.columbia.edu>; Thu, 10 Sep 2020 06:24:59 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A14DC1063;
 Thu, 10 Sep 2020 03:24:58 -0700 (PDT)
Received: from [192.168.1.179] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6FED23F68F;
 Thu, 10 Sep 2020 03:24:56 -0700 (PDT)
Subject: Re: [PATCH v2 0/2] MTE support for KVM guest
To: Richard Henderson <richard.henderson@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>
References: <20200904160018.29481-1-steven.price@arm.com>
 <8e661984-70bc-790c-8636-39dcd8b00131@linaro.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <842807ac-562a-36ce-8061-aa323341b605@arm.com>
Date: Thu, 10 Sep 2020 11:24:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <8e661984-70bc-790c-8636-39dcd8b00131@linaro.org>
Content-Language: en-GB
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>,
 Peter Maydell <Peter.Maydell@arm.com>, qemu-devel@nongnu.org,
 Juan Quintela <quintela@redhat.com>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
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
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 10/09/2020 01:33, Richard Henderson wrote:
> On 9/4/20 9:00 AM, Steven Price wrote:
>>   3. Doesn't provide any new methods for the VMM to access the tags on
>>      memory.
> ...
>> (3) may be problematic and I'd welcome input from those familiar with
>> VMMs. User space cannot access tags unless the memory is mapped with the
>> PROT_MTE flag. However enabling PROT_MTE will also enable tag checking
>> for the user space process (assuming the VMM enables tag checking for
>> the process)...
> 
> The latest version of the kernel patches for user mte support has separate
> controls for how tag check fail is reported.  Including
> 
>> +- ``PR_MTE_TCF_NONE``  - *Ignore* tag check faults
> 
> That may be less than optimal once userland starts uses tags itself, e.g.
> running qemu itself with an mte-aware malloc.
> 
> Independent of that, there's also the TCO bit, which can be toggled by any
> piece of code that wants to disable checking locally.

Yes, I would expect the TCO bit is the best option for wrapping accesses 
to make them unchecked.

> However, none of that is required for accessing tags.  User space can always
> load/store tags via LDG/STG.  That's going to be slow, though.

Yes as things stand LDG/STG is the way for user space to access tags. 
Since I don't have any real hardware I can't really comment on speed.

> It's a shame that LDGM/STGM are privileged instructions.  I don't understand
> why that was done, since there's absolutely nothing that those insns can do
> that you can't do with (up to) 16x LDG/STG.

It is a shame, however I suspect this is because to use those 
instructions you need to know the block size held in GMID_EL1. And at 
least in theory that could vary between CPUs.

> I think it might be worth adding some sort of kernel entry point that can bulk
> copy tags, e.g. page aligned quantities.  But that's just a speed of migration
> thing and could come later.

When we have some real hardware it would be worth profiling this. At the 
moment I've no idea whether the kernel entry overhead would make such an 
interface useful from a performance perspective or not.

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
