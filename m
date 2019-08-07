Return-Path: <SRS0=czFP=WD=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82892C41514
	for <kvmarm@archiver.kernel.org>; Wed,  7 Aug 2019 13:21:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0773B21E70
	for <kvmarm@archiver.kernel.org>; Wed,  7 Aug 2019 13:21:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0773B21E70
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 54A154A577;
	Wed,  7 Aug 2019 09:21:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zQsxV9LnXuHL; Wed,  7 Aug 2019 09:21:46 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F00934A567;
	Wed,  7 Aug 2019 09:21:46 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12A484A567
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Aug 2019 09:21:46 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id odkuryQKXqJQ for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Aug 2019 09:21:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 766134A541
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Aug 2019 09:21:44 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8AC0128;
 Wed,  7 Aug 2019 06:21:43 -0700 (PDT)
Received: from [10.1.196.133] (e112269-lin.cambridge.arm.com [10.1.196.133])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B93843F706;
 Wed,  7 Aug 2019 06:21:41 -0700 (PDT)
Subject: Re: [PATCH 1/9] KVM: arm64: Document PV-time interface
To: Christophe de Dinechin <christophe.de.dinechin@gmail.com>
References: <20190802145017.42543-1-steven.price@arm.com>
 <20190802145017.42543-2-steven.price@arm.com> <m1mugnmv0x.fsf@dinechin.org>
From: Steven Price <steven.price@arm.com>
Message-ID: <ff2d038d-d866-65fa-655d-b9865bf14016@arm.com>
Date: Wed, 7 Aug 2019 14:21:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <m1mugnmv0x.fsf@dinechin.org>
Content-Language: en-GB
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 linux-doc@vger.kernel.org, Russell King <linux@armlinux.org.uk>,
 linux-kernel@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, Will Deacon <will@kernel.org>,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

On 05/08/2019 17:40, Christophe de Dinechin wrote:
> 
> Steven Price writes:
> 
>> Introduce a paravirtualization interface for KVM/arm64 based on the
>> "Arm Paravirtualized Time for Arm-Base Systems" specification DEN 0057A.
>>
>> This only adds the details about "Stolen Time" as the details of "Live
>> Physical Time" have not been fully agreed.
>>
> [...]
> 
>> +
>> +Stolen Time
>> +-----------
>> +
>> +The structure pointed to by the PV_TIME_ST hypercall is as follows:
>> +
>> +  Field       | Byte Length | Byte Offset | Description
>> +  ----------- | ----------- | ----------- | --------------------------
>> +  Revision    |      4      |      0      | Must be 0 for version 0.1
>> +  Attributes  |      4      |      4      | Must be 0
>> +  Stolen time |      8      |      8      | Stolen time in unsigned
>> +              |             |             | nanoseconds indicating how
>> +              |             |             | much time this VCPU thread
>> +              |             |             | was involuntarily not
>> +              |             |             | running on a physical CPU.
> 
> I know very little about the topic, but I don't understand how the spec
> as proposed allows an accurate reading of the relation between physical
> time and stolen time simultaneously. In other words, could you draw
> Figure 1 of the spec from within the guest? Or is it a non-objective?

Figure 1 is mostly attempting to explain Live Physical Time (LPT), which
is not part of this patch series. But it does touch on stolen time by
the difference between "live physical time" and "virtual time".

I'm not sure what you mean by "from within the guest". From the
perspective of the guest the parts of the diagram where the guest isn't
running don't exist (therefore there are discontinuities in the
"physical time" and "live physical time" lines).

This patch series doesn't attempt to provide the guest with a view of
"physical time" (or LPT) - but it might be able to observe that by
consulting something external (e.g. an NTP server, or an emulated RTC
which reports wall-clock time).

What it does provide is a mechanism for obtaining the difference (as
reported by the host) between "live physical time" and "virtual time" -
this is reported in nanoseconds in the above structure.

> For example, if you read the stolen time before you read CNTVCT_EL0,
> isn't it possible for a lengthy event like a migration to occur between
> the two reads, causing the stolen time to be obsolete and off by seconds?

"Lengthy events" like migration are represented by the "paused" state in
the diagram - i.e. it's the difference between "physical time" and "live
physical time". So stolen time doesn't attempt to represent that.

And yes, there is a race between reading CNTVCT_EL0 and reading stolen
time - but in practice this doesn't really matter. The usual pseudo-code
way of using stolen time is:

  * scheduler captures stolen time from structure and CNTVCT_EL0:
      before_timer = CNTVCT_EL0
      before_stolen = stolen
  * schedule in process
  * process is pre-empted (or blocked in some way)
  * scheduler captures stolen time from structure and CNTVCT_EL0:
      after_timer = CNTVCT_EL0
      after_stolen = stolen
      time = to_nsecs(after_timer - before_timer) -
             (after_stolen - before_stolen)

The scheduler can then charge the process for "time" nanoseconds of
time. This ensures that a process isn't unfairly penalised if the host
doesn't schedule the VCPU while it is supposed to be running.

The race is very small in comparison to the time the process is running,
and in the worst case just means the process is charged slightly more
(or less) than it should be.

I guess if you're really worried about it, you could do a dance like:

	do {
		before = stolen
		timer = CNTVCT_EL0
		after = stolen
	} while (before != after);

But I don't see the need to have such an accurate view of elapsed time
that the VCPU was scheduled. And of course at the moment (without this
series) the guest has no idea about time stolen by the host.

Steve
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
