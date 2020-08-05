Return-Path: <SRS0=OpMx=BP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6A04C433E0
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 14:37:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 45BF32332F
	for <kvmarm@archiver.kernel.org>; Wed,  5 Aug 2020 14:37:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 45BF32332F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1FF74B89B;
	Wed,  5 Aug 2020 10:37:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wD4qD9i2ClAt; Wed,  5 Aug 2020 10:37:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 515014B83A;
	Wed,  5 Aug 2020 10:37:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 839A44B774
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 10:37:33 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VmihbIfiODFG for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Aug 2020 10:37:32 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 26F864B71E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Aug 2020 10:37:32 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id ABC521424;
 Wed,  5 Aug 2020 07:37:31 -0700 (PDT)
Received: from [192.168.0.57] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 77E603F7D7;
 Wed,  5 Aug 2020 07:37:30 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: arm64: nVHE: Don't consume host SErrors with RAS
To: Andrew Scull <ascull@google.com>, Marc Zyngier <maz@kernel.org>
References: <20200730151823.1414808-1-ascull@google.com>
 <20200730151823.1414808-2-ascull@google.com>
 <20200730223144.GA2022880@google.com>
 <8d469be9de5ce825ffeacdb530731591@kernel.org>
 <20200731102056.GA2547274@google.com>
From: James Morse <james.morse@arm.com>
Message-ID: <ffbfe036-4370-4a89-7818-1f6b8d4ebed8@arm.com>
Date: Wed, 5 Aug 2020 15:37:27 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200731102056.GA2547274@google.com>
Content-Language: en-GB
Cc: will@kernel.org, catalin.marinas@arm.com, kernel-team@android.com,
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

Hi Andrew,

On 31/07/2020 11:20, Andrew Scull wrote:
> On Fri, Jul 31, 2020 at 09:00:03AM +0100, Marc Zyngier wrote:
>> On 2020-07-30 23:31, Andrew Scull wrote:
>>> On Thu, Jul 30, 2020 at 04:18:23PM +0100, Andrew Scull wrote:
>>>> The ESB at the start of the vectors causes any SErrors to be
>>>> consumed to
>>>> DISR_EL1. If the exception came from the host and the ESB caught an
>>>> SError, it would not be noticed until a guest exits and DISR_EL1 is
>>>> checked. Further, the SError would be attributed to the guest and not
>>>> the host.
>>>>
>>>> To avoid these problems, use a different exception vector for the host
>>>> that does not use an ESB but instead leaves any host SError pending. A
>>>> guest will not be entered if an SError is pending so it will always be
>>>> the host that will receive and handle it.
>>>
>>> Thinking further, I'm not sure this actually solves all of the problem.
>>> It does prevent hyp from causing a host SError to be consumed but, IIUC,
>>> there could be an SError already deferred by the host and logged in
>>> DISR_EL1 that hyp would not preserve if a guest is run.
>>>
>>> I think the host's DISR_EL1 would need to be saved and restored in the
>>> vcpu context switch which, from a cursory read of the ARM, is possible
>>> without having to virtualize SErrors for the host.
>>
>> The question is what do you if you have something pending in DISR_EL1
>> at the point where you enter EL2? Context switching it is not going to
>> help. One problem is that you'd need to do an ESB, corrupting DISR_EL1,
>> before any memory access (I'm assuming you can get traps where all
>> registers are live). I can't see how we square this circle.

> I'll expand on what I understand (or think I do) about RAS at the
> moment. It should hopefully highlight anything wrong with my reasoning
> for your questions.
> 
> DISR_EL1.A being set means a pending physical SError has been
> consumed/cleared. The host has already deferred an SError so saving and
> restoring (i.e. preserving) DISR_EL1 for the host would mean the
> deferred SError is as it was on return to the host.

[..]

> If there is a pending physical SError, we'd have to keep it pending so
> the host can consume it.

I agree!


> __guest_enter has the dsb-isb for RAS so
> SErrors will become pending, but it doesn't consume them.


> I can't
> remember now whether this was reliable or not; I assumed it was as it is
> gated on the RAS config.

It should be reliable for 'asynchronous external abort', but not 'SError Interrupt', both
of which are signalled via the SError vector.

The DSB completes previous memory accesses, so that the components they land in can return
an abort if they need to. The ISB ensures the abort is seen as pending in ISR_EL1 before
the CPU reads it.

The ESB-instruction is potentially cheaper, (as cheap as a nop if all errors are going to
be reported as uncontained anyway), but it has the nasty side effect of consuming the
error, which we don't want here.


> The above didn't need an ESB for the host but incorrect assumptions
> might change that.
> 
>> Furthermore, assuming you find a way to do it, what do you do with it?
>>
>> (a) Either there was something pending already and it is still pending,

> If a physical SError is pending, you leave it pending and go back to the
> host so it can consume it.

Great idea!
If the CPU has IESB, you can just check ISR_EL1 on entry from the host.
If not, you'll need some extra barriers.


>> (b) Or there was nothing pending and you now have an error that you
>>     don't know how to report (the host EL1 never issued an ESB)
> 
> If there isn't a physical SError pending, either there is no SError at
> all (easy) or the SError has already been consumed to DISR_EL1 by a host
> ESB and we'd preserve DISR_EL1 for the host to handle however it chooses.

(I think this is a host bug)


>> We could just error out on hypercalls if DISR_EL1 is non-zero, but
>> I don't see how we do that for traps, as it would just confuse the host
>> EL1.
> 
> Traps would need to be left pending. Detected but not consumed with the
> dsb-isb in __guest_enter.

You're trapping stuff from the host?

If you might trap something between the ESB-instruction and the host reading DISR_EL1 then
you can't use the ESB-instruction in your trap handling path, as it would over-write it.
This sucks as presumably you want to make it common with the really-a-guest trap handling
path.

The best thing to do would be to go the whole-hog and route SError to EL2 with
HCR_EL2.AMO. SError taken out of the host can be re-injected with HCR_EL2.VSE and
VSESR_EL2, which will be consumed to VDISR_EL2 if the 'host' executes an ESB-instruction.

DISR_EL1 then belongs to EL2, meaning its free to use the ESB-instruction as it likes.


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
