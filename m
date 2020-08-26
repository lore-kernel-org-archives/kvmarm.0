Return-Path: <SRS0=T+3t=CE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62B8EC433E1
	for <kvmarm@archiver.kernel.org>; Wed, 26 Aug 2020 17:41:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CC3E3207BC
	for <kvmarm@archiver.kernel.org>; Wed, 26 Aug 2020 17:41:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC3E3207BC
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07FC14BCCE;
	Wed, 26 Aug 2020 13:41:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7t6EBTHTHzLk; Wed, 26 Aug 2020 13:41:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9D34E4BCD5;
	Wed, 26 Aug 2020 13:41:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D98144BCCF
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Aug 2020 13:41:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wjzJGtl+L23Q for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Aug 2020 13:41:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43DB94BCC1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Aug 2020 13:41:05 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BA2AE101E;
 Wed, 26 Aug 2020 10:41:04 -0700 (PDT)
Received: from [172.16.1.113] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E53593F68F;
 Wed, 26 Aug 2020 10:41:02 -0700 (PDT)
Subject: Re: [PATCH 2/2] KVM: arm64: nVHE: Don't consume host SErrors with RAS
To: Andrew Scull <ascull@google.com>
References: <20200730151823.1414808-1-ascull@google.com>
 <20200730151823.1414808-2-ascull@google.com>
 <20200730223144.GA2022880@google.com>
 <8d469be9de5ce825ffeacdb530731591@kernel.org>
 <20200731102056.GA2547274@google.com>
 <ffbfe036-4370-4a89-7818-1f6b8d4ebed8@arm.com>
 <20200811151230.GC2917393@google.com>
From: James Morse <james.morse@arm.com>
Message-ID: <394b84de-6989-e980-c068-5ef9c48cd078@arm.com>
Date: Wed, 26 Aug 2020 18:41:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200811151230.GC2917393@google.com>
Content-Language: en-GB
Cc: kernel-team@android.com, catalin.marinas@arm.com,
 Marc Zyngier <maz@kernel.org>, will@kernel.org, kvmarm@lists.cs.columbia.edu
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

On 11/08/2020 16:12, Andrew Scull wrote:
> On Wed, Aug 05, 2020 at 03:37:27PM +0100, James Morse wrote:
>> On 31/07/2020 11:20, Andrew Scull wrote:
>>> If there is a pending physical SError, we'd have to keep it pending so
>>> the host can consume it.

>>> __guest_enter has the dsb-isb for RAS so
>>> SErrors will become pending, but it doesn't consume them.

>>> I can't
>>> remember now whether this was reliable or not; I assumed it was as it is
>>> gated on the RAS config.
>>
>> It should be reliable for 'asynchronous external abort', but not 'SError Interrupt', both
>> of which are signalled via the SError vector.
> 
> Uh oh, more terms with differences that I don't understand yet.

> I assume that there aren't SError Interrupts that we would be concerned
> about being deliered to the guest that should have been delivered to the
> host after checing for asynchronous external aborts? At least, that seem
> to be the current behaviour if I'm reading things right.

Currently KVM assume everything is an asynchronous-external-abort as that was the pre-RAS
behaviour. SError interrupt means something along the lines of 'part of the SoC fell out',
and I expect we're not going to get very far before we trip over the problem again.
If we don't, its probably something related to the guest.

With v8.2 we can tell these things apart, so we could try harder, but I don't think
anything uses SError-Interrupt. Its much more likely that catastrophic errors are taken to
EL3 firmware, or handled by a dedicated microcontroller.


>> The DSB completes previous memory accesses, so that the components they land in can return
>> an abort if they need to. The ISB ensures the abort is seen as pending in ISR_EL1 before
>> the CPU reads it.
>>
>> The ESB-instruction is potentially cheaper, (as cheap as a nop if all errors are going to
>> be reported as uncontained anyway), but it has the nasty side effect of consuming the
>> error, which we don't want here.
>>
>>
>>> The above didn't need an ESB for the host but incorrect assumptions
>>> might change that.
>>>
>>>> Furthermore, assuming you find a way to do it, what do you do with it?
>>>>
>>>> (a) Either there was something pending already and it is still pending,
>>
>>> If a physical SError is pending, you leave it pending and go back to the
>>> host so it can consume it.
>>
>> Great idea!
>> If the CPU has IESB, you can just check ISR_EL1 on entry from the host.
>> If not, you'll need some extra barriers.

> I'm not sure it would be easy to check ISR_EL1 and bail to the host in
> the general case as it would require a meaningful return code for each
> context, something like EAGAIN that doesn't exist in the hyp interfaces.

I guess whether its a problem depends on how much work we're going to do. It doesn't feel
right to carry on once we know something is burning.

If its a bug to make an HVC from SError-masked code, this would only happen if IESB
synchronised the error.

For __kvm_vcpu_run_*(), we could return immediately as if we'd taken an IRQ out of the
guest, this is pretty much the trick __guest_enter pulls. We should probably do this today.

For others, we could rewind ELR_EL2 and forcibly emulate the exception back into the host.
If it returns, it runs the HVC again. Its probably not worth the effort, unless we do the
same for the guest.... which won't promise not to do this from masked


> I was instead thinking that EL2 would continue as usual except it won't
> consume any SErrors with the ESB.
What we don't know can't hurt us! I think this is fine provided we don't end up making the
blackout window huge. A whole set of extra vectors is I guess the cost of this.


Will KVM ever want to handle its own errors? (it doesn't today).

If its okay to merge KVM's asynchronous external abort and the hosts, then I agree this
works, we'd need to be careful not to unmask SError or run ESB.

If KVM wants to know if its an asynchronous external abort that it caused, you'd need to
virtualise the errors for the host.


>>>> (b) Or there was nothing pending and you now have an error that you
>>>>     don't know how to report (the host EL1 never issued an ESB)
>>>
>>> If there isn't a physical SError pending, either there is no SError at
>>> all (easy) or the SError has already been consumed to DISR_EL1 by a host
>>> ESB and we'd preserve DISR_EL1 for the host to handle however it chooses.
>>
>> (I think this is a host bug)
>>
>>
>>>> We could just error out on hypercalls if DISR_EL1 is non-zero, but
>>>> I don't see how we do that for traps, as it would just confuse the host
>>>> EL1.
>>>
>>> Traps would need to be left pending. Detected but not consumed with the
>>> dsb-isb in __guest_enter.
>>
>> You're trapping stuff from the host?
> 
> Not yet, but it might happen e.g. to context switch FPSIMD under
> protected KVM.

Sounds fun.


>> If you might trap something between the ESB-instruction and the host reading DISR_EL1 then
>> you can't use the ESB-instruction in your trap handling path, as it would over-write it.
>> This sucks as presumably you want to make it common with the really-a-guest trap handling
>> path.
>>
>> The best thing to do would be to go the whole-hog and route SError to EL2 with
>> HCR_EL2.AMO. SError taken out of the host can be re-injected with HCR_EL2.VSE and
>> VSESR_EL2, which will be consumed to VDISR_EL2 if the 'host' executes an ESB-instruction.
>>
>> DISR_EL1 then belongs to EL2, meaning its free to use the ESB-instruction as it likes.
> 
> Does a save and restore of DISR_EL1 (see other thread on this series)
> address the concerns here or would you still think it better to start
> virtualizing for the host?

Other than trapping things from the host, I'm confused as to the circumstances that
DISR_EL1 would get clobbered. (is there an example?)

Isn't that unnecessary in the "EL2 would continue as usual except it won't
consume any SErrors with the ESB." world?


DISR_EL1 belongs to the thing that is consuming SError for the platform. The hardware
takes care of ensuring the guest can never corrupt this. KVMs EL2 code is part of the
host, so it magically knows its not overwriting anything when uses the ESB-instruction.
I can see how trapping stuff from the host would change that.

Save restoring it looks really weird, having two things consuming errors leads to problems
around who consumes what. Not handling the DISR_EL1 value as quickly as possible looks
problematic.

(I don't think I'm answering the question here).


For trapping, or KVM detecting its own asynchronous-external-abort, I think you need to
turn the virtualisation on. Otherwise its avoiding ESB-instructions and unmasking SError,
which comes with the cost of special copies of things like the vectors.


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
