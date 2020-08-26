Return-Path: <SRS0=T+3t=CE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7DF4C433DF
	for <kvmarm@archiver.kernel.org>; Wed, 26 Aug 2020 17:41:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 91041207DF
	for <kvmarm@archiver.kernel.org>; Wed, 26 Aug 2020 17:41:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91041207DF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AA954BCD8;
	Wed, 26 Aug 2020 13:41:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gf9ZJhmJCyhj; Wed, 26 Aug 2020 13:41:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BBC464BCF7;
	Wed, 26 Aug 2020 13:41:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F122F4BCC1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Aug 2020 13:41:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9DCOMeg1jF-E for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Aug 2020 13:41:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C0A694BCCB
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Aug 2020 13:41:05 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 717C91045;
 Wed, 26 Aug 2020 10:41:05 -0700 (PDT)
Received: from [172.16.1.113] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 009513F8C6;
 Wed, 26 Aug 2020 10:41:03 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: arm64: nVHE: Don't consume host SErrors with RAS
To: Andrew Scull <ascull@google.com>
References: <20200730151823.1414808-1-ascull@google.com>
 <20200730151823.1414808-2-ascull@google.com>
 <20200730223144.GA2022880@google.com>
 <6ecc47f3-4733-4f49-660f-f21229176efb@arm.com>
 <20200811145338.GB2917393@google.com>
From: James Morse <james.morse@arm.com>
Message-ID: <456017df-e0fe-12cc-beea-374825ab25f6@arm.com>
Date: Wed, 26 Aug 2020 18:41:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200811145338.GB2917393@google.com>
Content-Language: en-GB
Cc: kernel-team@android.com, catalin.marinas@arm.com, maz@kernel.org,
 will@kernel.org, kvmarm@lists.cs.columbia.edu
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

Hi Andrew,

On 11/08/2020 15:53, Andrew Scull wrote:
> On Wed, Aug 05, 2020 at 03:34:11PM +0100, James Morse wrote:
>> On 30/07/2020 23:31, Andrew Scull wrote:
>>> On Thu, Jul 30, 2020 at 04:18:23PM +0100, Andrew Scull wrote:
>>>> The ESB at the start of the vectors causes any SErrors to be consumed to
>>>> DISR_EL1. If the exception came from the host and the ESB caught an

>>> I think the host's DISR_EL1 would need to be saved and restored in the
>>> vcpu context switch which, from a cursory read of the ARM, is possible
>>> without having to virtualize SErrors for the host.
>>
>> ... I thought this was a redirected register. Reads from EL1 when HCR_EL2.AMO is set get
>> the value from VDISR_EL2, meaning the guest can't read DISR_EL1 at all.
>> (see 'Accessing DISR_EL1' in the register description, "D13.7.1
>> DISR_EL1, Deferred Interrupt Status Register" of DDI0487F.a

> The host doesn't run with HCR_EL2.AMO set so it uses DISR_EL1 directly,
> but hyp also uses DISR_EL1 directly during __guest_exit. That is the
> clobbering I was concerned about. It may not be a problem most of the
> time given what you said above, but I think something like the diff
> below should be enough to be sure it is preserved:

On guest-exit, can't we just clobber the register, and make it the hosts problem to ensure
it always cleared it after use? (as it does today).

Save restore here is extra work to do all the time, to preserve a value the the host
should never need anyway.

I think this is just another weird case where the host really isn't like a vcpu.


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
