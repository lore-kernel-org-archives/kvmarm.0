Return-Path: <SRS0=9SrU=UE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18F7EC28CC5
	for <kvmarm@archiver.kernel.org>; Wed,  5 Jun 2019 11:04:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 946FE206DF
	for <kvmarm@archiver.kernel.org>; Wed,  5 Jun 2019 11:04:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 946FE206DF
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EFA134A4E8;
	Wed,  5 Jun 2019 07:04:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bFQxYb51XPAG; Wed,  5 Jun 2019 07:04:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A8C84A4A3;
	Wed,  5 Jun 2019 07:04:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BFE964A49F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jun 2019 07:04:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MtnBt0iGLbm5 for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jun 2019 07:03:59 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 13FE64A409
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jun 2019 07:03:59 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6AC3915AB;
 Wed,  5 Jun 2019 04:03:58 -0700 (PDT)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 350463F690;
 Wed,  5 Jun 2019 04:03:57 -0700 (PDT)
Subject: Re: [PATCH v1 2/6] KVM: arm64: Consume pending SError as early as
 possible
To: Julien Thierry <julien.thierry@arm.com>
References: <20190604144551.188107-1-james.morse@arm.com>
 <20190604144551.188107-3-james.morse@arm.com>
 <e8a742cd-9b37-c4b3-f34a-4663081a8529@arm.com>
From: James Morse <james.morse@arm.com>
Message-ID: <b5419a11-d378-2e21-98ce-b084874d0903@arm.com>
Date: Wed, 5 Jun 2019 12:03:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <e8a742cd-9b37-c4b3-f34a-4663081a8529@arm.com>
Content-Language: en-GB
Cc: Marc Zyngier <marc.zyngier@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
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

Hi Julien,

On 05/06/2019 10:00, Julien Thierry wrote:
> On 04/06/2019 15:45, James Morse wrote:
>> On systems with v8.2 we switch the 'vaxorcism' of guest SError with an
>> alternative sequence that uses the ESB-instruction, then reads DISR_EL1.
>> This saves the unmasking and re-masking of asynchronous exceptions.
>>
>> We do this after we've saved the guest registers and restored the
>> host's. Any SError that becomes pending due to this will be accounted
>> to the guest, when it actually occurred during host-execution.
>>
>> Move the ESB-instruction as early as possible. Any guest SError
>> will become pending due to this ESB-instruction and then consumed to
>> DISR_EL1 before the host touches anything.

> Since you're moving the ESB from a HAS_RAS alternative location to a
> normal location, it might be worth noting in the commit message that the
> ESB is a NOP when RAS is not implemented, to clarify that we are not
> uselessly adding a barrier (or potentially undefined instruction).

Sure.


>> This lets us account for host/guest SError precisely on the guest
>> exit exception boundary.

>> diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
>> index 914036e6b6d7..b8d37a987b34 100644
>> --- a/arch/arm64/kvm/hyp/hyp-entry.S
>> +++ b/arch/arm64/kvm/hyp/hyp-entry.S
>> @@ -230,6 +230,7 @@ ENDPROC(\label)
>>  .macro valid_vect target
>>  	.align 7
>>  661:
>> +	esb
> 
> Having said the above, if the kernel is built without RAS support (you
> have to disable some of options enabled by default to get to that) but
> runs on a CPU that does have the RAS extention, should we execute a nop
> instead of an esb (so have an alternative here)?

That's an interesting corner! The esb-instruction would have consumed any guest-SError,
but we'd never read DISR_EL1 because that undefs, so it lives behind the RAS extension
support. The effect is guest-SError going missing.


> Also, when we have the smccc workaround installed we do two esb, is that
> intentional/necessary?

> Could we have only one esb at the start of hyp_ventry (and "only" 26
> nops after it) for KVM_INDIRECT_VECTORS? Or does this not affect
> performance that much to be of interest?

Ugh, because kvm_patch_vector_branch() that does the preamble work, and jumps over the
'real' vectors preamble depends on CONFIG_HARDEN_EL2_VECTORS, not
CONFIG_HARDEN_BRANCH_PREDICTOR. (I thought the vector tail was always generated...)

Is it harmless? aarch64/functions/ras/AArch64.ESBOperation says DISR_EL1 is overwritten if
a physical SError is pending. For this to be a problem, we'd need two, and the second one
would have to be caused by the smccc workaround (possibly by the firmware portion). This
would be accounted to the guest, which could be a problem. But either the stack has
uncorrected errors (so we aren't going to make it out of KVM alive), or firmware causes
SError. (I'm struggling to care...)

...

Would getting the unpatched kvm_patch_vector_branch() region to do the pre-amble work and
jump over it work?

We'd end up with ESB-instruction at the top of the unpatched-vector, which may be
overwritten with the smccc-workaround, which also contains an ESB-instruction.
kvm_patch_vector_branch() generates the other half of the preamble but the
unpatched-vector needs to do the same so support all the combinations.

I think this makes the addition to this Gordian-knot of code easier to reason about, which
is a good enough reason to do it!


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
