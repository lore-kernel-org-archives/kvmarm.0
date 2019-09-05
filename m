Return-Path: <SRS0=E5f7=XA=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D46EC3A5A5
	for <kvmarm@archiver.kernel.org>; Thu,  5 Sep 2019 08:25:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C05B20870
	for <kvmarm@archiver.kernel.org>; Thu,  5 Sep 2019 08:25:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2C05B20870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 81F7C4A59B;
	Thu,  5 Sep 2019 04:25:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cOHGPeq8JOmZ; Thu,  5 Sep 2019 04:25:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E3A94A554;
	Thu,  5 Sep 2019 04:25:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DFA554A528
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Sep 2019 04:25:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cN1Jr8aREa5j for <kvmarm@lists.cs.columbia.edu>;
 Thu,  5 Sep 2019 04:25:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 754E44A522
 for <kvmarm@lists.cs.columbia.edu>; Thu,  5 Sep 2019 04:25:05 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0EF7C337;
 Thu,  5 Sep 2019 01:25:05 -0700 (PDT)
Received: from localhost (e113682-lin.copenhagen.arm.com [10.32.144.41])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 94E2A3F67D;
 Thu,  5 Sep 2019 01:25:04 -0700 (PDT)
Date: Thu, 5 Sep 2019 10:25:03 +0200
From: Christoffer Dall <christoffer.dall@arm.com>
To: Peter Maydell <peter.maydell@linaro.org>
Subject: Re: [PATCH 1/1] KVM: inject data abort if instruction cannot be
 decoded
Message-ID: <20190905082503.GB4320@e113682-lin.lund.arm.com>
References: <20190904180736.29009-1-xypron.glpk@gmx.de>
 <86r24vrwyh.wl-maz@kernel.org>
 <CAFEAcA-mc6cLmRGdGNOBR0PC1f_VBjvTdAL6xYtKjApx3NoPgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFEAcA-mc6cLmRGdGNOBR0PC1f_VBjvTdAL6xYtKjApx3NoPgQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Daniel P =?utf-8?B?LiBCZXJyYW5nw6k=?= <berrange@redhat.com>,
 Marc Zyngier <maz@kernel.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Stefan Hajnoczi <stefanha@redhat.com>,
 Heinrich Schuchardt <xypron.glpk@gmx.de>, kvmarm@lists.cs.columbia.edu,
 arm-mail-list <linux-arm-kernel@lists.infradead.org>
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

On Thu, Sep 05, 2019 at 09:16:54AM +0100, Peter Maydell wrote:
> On Thu, 5 Sep 2019 at 09:04, Marc Zyngier <maz@kernel.org> wrote:
> > How can you tell that the access would fault? You have no idea at that
> > stage (the kernel doesn't know about the MMIO ranges that userspace
> > handles). All you know is that you're faced with a memory access that
> > you cannot emulate in the kernel. Injecting a data abort at that stage
> > is not something that the architecture allows.
> 
> To be fair, locking up the whole CPU (which is effectively
> what the kvm_err/ENOSYS is going to do to the VM) isn't
> something the architecture allows either :-)
> 
> > Of course, the best thing would be to actually fix the guest so that
> > it doesn't use non-emulatable MMIO accesses. In general, that the sign
> > of a bug in low-level accessors.
> 
> This is true, but the problem is that barfing out to userspace
> makes it harder to debug the guest because it means that
> the VM is immediately destroyed, whereas AIUI if we
> inject some kind of exception then (assuming you're set up
> to do kernel-debug via gdbstub) you can actually examine
> the offending guest code with a debugger because at least
> your VM is still around to inspect...
> 

Is it really going to be easier to debug a guest that sees behavior
which may not be architecturally correct?  For example, seeing a data
abort on an access to an MMIO region because the guest used a strange
instruction?

I appreaciate that the current way we handle this is confusing and has
led many people down a rabbit hole, so we should do better.

Would a better approach not be to return to userspace saying, "we can't
handle this in the kernel, you decide", without printing the dubious
kernel error message.  Then user space could suspend the VM and print a
lenghty explanation of all the possible problems there could be, or
re-inject something back into the guest, or whatever, for a particular
environment.

Thoughts?


Thanks,

    Christoffer
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
