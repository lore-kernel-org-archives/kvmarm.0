Return-Path: <SRS0=W8aC=VM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 785CDC76195
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jul 2019 14:26:51 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0B25A217F4
	for <kvmarm@archiver.kernel.org>; Mon, 15 Jul 2019 14:26:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0B25A217F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AF834A389;
	Mon, 15 Jul 2019 10:26:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id DZDUpgCnhJsM; Mon, 15 Jul 2019 10:26:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E50544A4C1;
	Mon, 15 Jul 2019 10:26:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD16C4A418
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jul 2019 10:26:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T-ZnFtSXTN8T for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Jul 2019 10:26:46 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 266CF4A389
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Jul 2019 10:26:46 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B204E28;
 Mon, 15 Jul 2019 07:26:45 -0700 (PDT)
Received: from [10.1.196.105] (eglon.cambridge.arm.com [10.1.196.105])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E10E3F59C;
 Mon, 15 Jul 2019 07:26:44 -0700 (PDT)
Subject: Re: [RFC] Add virtual SDEI support in qemu
To: Guoheyi <guoheyi@huawei.com>
References: <1b0aa6b2-80b1-a72e-6849-7323c3b9c6bc@huawei.com>
 <20190715134059.GJ2790@e103592.cambridge.arm.com>
 <20190715134848.GI56232@lakrids.cambridge.arm.com>
From: James Morse <james.morse@arm.com>
Message-ID: <4daefb19-6c15-f82c-31e9-1ae035d45bd5@arm.com>
Date: Mon, 15 Jul 2019 15:26:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190715134848.GI56232@lakrids.cambridge.arm.com>
Content-Language: en-GB
Cc: Marc Zyngier <marc.zyngier@arm.com>, qemu-devel@nongnu.org,
 Dave Martin <Dave.Martin@arm.com>, qemu-arm@nongnu.org,
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

Hi guys,

On 15/07/2019 14:48, Mark Rutland wrote:
> On Mon, Jul 15, 2019 at 02:41:00PM +0100, Dave Martin wrote:
>> On Sat, Jul 13, 2019 at 05:53:57PM +0800, Guoheyi wrote:
>>> Do it make sense to implement virtual SDEI in qemu? So that we can have the
>>> standard way for guest to handle NMI watchdog, RAS events and something else
>>> which involves SDEI in a physical ARM64 machine.

I think so!


>>> My basic idea is like below:
>>>
>>> 1. Change a few lines of code in kvm to allow unhandled SMC invocations
>>> (like SDEI) to be sent to qemu, with exit reason of KVM_EXIT_HYPERCALL, so
>>> we don't need to add new API.
>>
>> So long as KVM_EXIT_HYPERCALL reports sufficient information so that
>> userspace can identify the cause as an SMC and retrieve the SMC
>> immediate field, this seems feasible.
>>
>> For its own SMCCC APIs, KVM exclusively uses HVC, so rerouting SMC to
>> userspace shouldn't conflict.
> 
> Be _very_ careful here! In systems without EL3 (and without NV), SMC
> UNDEFs rather than trapping to EL2. Given that, we shouldn't build a
> hypervisor ABI that depends on SMC.
> 
> I am strongly of the opinion that (for !NV) we should always use HVC
> here and have KVM appropriately forward calls to userspace, rather than
> trying to use HVC/SMC to distinguish handled-by-kernel and
> handled-by-userspace events.
> 
> For NV, the first guest hypervisor would use SMC to talk to KVM, all
> else being the same.
> 
>> This bouncing of SMCs to userspace would need to be opt-in, otherwise
>> old userspace would see exits that it doesn't know what to do with.
>>
>>> 2. qemu handles supported SDEI calls just as the spec says for what a
>>> hypervisor should do for a guest OS.

[pulled point 3 out to discuss separately]

>> Something like that.
>>
>> Interactions between SDEI and PSCI would need some thought: for example,
>> after PSCI_CPU_ON, the newly online cpu needs to have SDEs masked.
>>
>> One option (suggested to me by James Morse) would be to allow userspace
>> to disable in the in-kernel PSCI implementation and provide its own
>> PSCI to the guest via SMC -- in which case userspace that wants to
>> implement SDEI would have to implement PSCI as well.
> 
> I think this would be the best approach, since it puts userspace in
> charge of everything.
> 
> However, this interacts poorly with FW-based mitigations that we
> implement in hyp. I suspect we'd probably need a mechanism to delegate
> that responsibility back to the kernel, and figure out if that has any
> interaction with thigns that got punted to userspace...

This has come up before:
https://lore.kernel.org/r/59C139D0.3040507@arm.com

I agree Qemu should opt-in to this, it needs to be a feature that is enabled.

I had an early version of something like this for testing SDEI before there was firmware
available. The review feedback from Christoffer was that it should include HVC and SMC,
their immediates, and shouldn't be tied to SMC-CC ranges.

I think this should be a catch-all as Heyi describes to deliver 'unhandled SMC/HVC' to
user-space as hypercall exits. We should include the immediate in the struct.

We can allow Qemu to disable the in-kernel PSCI implementation, which would let it be done
in user-space via this catch-all mechanism. (PSCI in user-space has come up on another
thread recently). The in-kernel PSCI needs to be default-on for backwards compatibility.

As Mark points out, the piece that's left is the 'arch workaround' stuff. We always need
to handle these in the kernel. I don't think these should be routed-back, they should be
un-obtainable by user-space.
Ideally there would be a way for user-space to discover the immediate/x0 values that the
kernel will not deliver via the catch-all. This could be done via some co-processor
register... thing...



>>> 3. For interrupts bound to hypervisor, qemu should stop injecting the IRQ to
>>> guest through KVM, but jump to the registered event handler directly,
>>> including context saving and restoring. Some interrupts like virtual timer
>>> are handled by kvm directly, so we may refuse to bind such interrupts to
>>> SDEI events.

I don't think we'd ever need a physical interrupt to be delivered via Qemu as an SDEI event.
The use-cases for this stuff mean it can be done 'higher-up'. For example, your timer is
probably used as a watchdog. On a real system this may well be a device with an interrupt,
but Qemu could happily emulate a watchdog using some other linux API. (e.g. SIGALRM).



Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
