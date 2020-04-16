Return-Path: <SRS0=0qdQ=6A=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44325C2BB55
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 13:03:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C8BB8206B9
	for <kvmarm@archiver.kernel.org>; Thu, 16 Apr 2020 13:03:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C8BB8206B9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 141CC4B26F;
	Thu, 16 Apr 2020 09:03:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bxsPldMbjNyp; Thu, 16 Apr 2020 09:03:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C924C4B12E;
	Thu, 16 Apr 2020 09:03:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 052734B12E
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 09:03:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eV07SYPlxu0x for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Apr 2020 09:03:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CD7B4B11C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Apr 2020 09:03:01 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 055791FB;
 Thu, 16 Apr 2020 06:03:01 -0700 (PDT)
Received: from [192.168.0.14] (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6536E3F68F;
 Thu, 16 Apr 2020 06:02:59 -0700 (PDT)
Subject: Re: [PATCH] KVM: handle the right RAS SEA(Synchronous External Abort)
 type
To: gengdongjiu <gengdongjiu@huawei.com>
References: <20200411121740.37615-1-gengdongjiu@huawei.com>
 <0fa259ab-0e2f-a8b3-783d-24a725b4cc5d@arm.com>
 <65414dc5-1cd7-003d-7c6a-5da62c6a4a1d@huawei.com>
From: James Morse <james.morse@arm.com>
Message-ID: <29b99cab-cdcc-fc7c-378f-9796af0242c5@arm.com>
Date: Thu, 16 Apr 2020 14:02:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <65414dc5-1cd7-003d-7c6a-5da62c6a4a1d@huawei.com>
Content-Language: en-GB
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, linuxarm@huawei.com,
 catalin.marinas@arm.com, will@kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi Geng,

On 16/04/2020 13:07, gengdongjiu wrote:
> On 2020/4/14 20:18, James Morse wrote:
>> On 11/04/2020 13:17, Dongjiu Geng wrote:
>>> When the RAS Extension is implemented, b0b011000, 0b011100,
>>> 0b011101, 0b011110, and 0b011111, are not used and reserved
>>> to the DFSC[5:0] of ESR_ELx, but the code still checks these
>>> unused bits, so remove them.
>>
>> They aren't unused: CPUs without the RAS extensions may still generate these.
>>
>> kvm_handle_guest_abort() wants to know if this is an external abort.
>> KVM doesn't really care if the CPU has the RAS extensions or not, its the arch code's job
>> to sort all that out.
> 
> No, handle_guest_sea() ---> ghes_notify_sea  ---> apei driver

You missed the arch code's apei_claim_sea(). This is where kvm washes its hands of the
exception, its up to the arch code to deal with, in the same way it deals with errors for
user-space.


> If it is an  external abort, it will call apei driver to handle it, but it should be only SEA will call the apei driver.
> other type of external abort should not call apei driver.
> I am not see arch code sort all that out.

The other kind is _asynchronous_ external abort, which doesn't get handled in here.

Do you mean 'Synchronous external abort on translation table walk, nth level'?
KVM shouldn't care, this is still up to the arch code to deal with.

Do you mean 'Synchronous parity or ECC error on memory access, not on translation table
walk'? (and all its translation table walk friends...)

These really are still external abort!
See shared/functions/aborts/IsExternalAbort() in the psuedo code. (J12-7735 of DDI0487F.a)

This means they are trapped by SCR_EL3.EA. On a firmware-first system if we see one of
these, its because firmware re-injected it. The arch code needs to get APEI to check for
CPER records when it sees one. (KVM ... doesn't care)

(I agree not having 'external' in the name is counter-intuitive. I think this is because
the component that triggers them is 'in' the CPU, (e.g. the L1 cache). This is how you can
know it was a parity or ECC error, instead of 'something outside' (i.e. external). An OS
that is deeply tied to the CPU micro-architecture could use the difference to read imp-def
sysregs for one, and poke around in imp-def mmio for the external case. Linux isn't tied
to the micro-architecture, so ignores this 'internal/external' hint.)


>>> If the handling of guest ras data error fails, it should
>>> inject data instead of SError to let the guest recover as
>>> much as possible.
> 
> In some hardware platform, it supports RAS, but the RAS error address will be not recorded,

In what circumstances does this happen?

Wouldn't these errors all be uncontained? (in which case the host should panic()).
e.g. A write went to the wrong address, we don't know where it went...

...

Is this because your platform describes memory-errors that happen inside the CPU as
processor errors, instead of memory-errors?

Linux's APEI code ignores them, because it doesn't know what they are. This means you are
missing the whole memory_failure(), page-unmapping, user-space signalling ... and guest
error injection ... part of the RAS handling.


> so it is better to inject a data abort instead of SError for thtat platform.

Not at all. The SError here is KVM's response to having nothing else it can do.

Having the host handle the error is the best way of solving the problem.

> because guest will try to do recovery for the Synchronous data abort, such as kill the error
> application. But for SError, guest will be panic.

I'd rather we fix this by having the host handle the error.

Botching in a synchronous exception here would mean Qemu can't properly emulate a machine
that has SCR_EL3.EA set ... which you need to provide firmware-first for the guest.

[...]

> Yes, some platform supports RAS but will not record the error address, so the host has failed
> to handle the error.

I don't think its reasonable to expect KVM to do anything useful in this case.
We should fix the host error handling.

In what circumstances does this happen?


Thanks,

James
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
