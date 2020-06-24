Return-Path: <SRS0=cLfN=AF=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59606C433E1
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jun 2020 11:52:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E32E520CC7
	for <kvmarm@archiver.kernel.org>; Wed, 24 Jun 2020 11:52:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E32E520CC7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5AA344B1E9;
	Wed, 24 Jun 2020 07:52:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sytnZUEIJjOP; Wed, 24 Jun 2020 07:52:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 163824B1F0;
	Wed, 24 Jun 2020 07:52:08 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9FF384B1D5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2020 07:52:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h9TxK7OtR4SZ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 24 Jun 2020 07:52:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36BBF4B1D1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 24 Jun 2020 07:52:05 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D881E1F1;
 Wed, 24 Jun 2020 04:52:04 -0700 (PDT)
Received: from gaia (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8FA4E3F6CF;
 Wed, 24 Jun 2020 04:52:03 -0700 (PDT)
Date: Wed, 24 Jun 2020 12:52:01 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [RFC PATCH 0/2] MTE support for KVM guest
Message-ID: <20200624115200.GA31575@gaia>
References: <20200617123844.29960-1-steven.price@arm.com>
 <CAFEAcA8Myn_QEjfk4Ka604PDAUAWXs6dLUY5bEQ98C__oMsmhA@mail.gmail.com>
 <20200624093846.GA11863@gaia> <20200624103412.GD25945@arm.com>
 <faa68f22-4d8e-0290-b52a-63ae7425b988@arm.com>
 <20200624110904.GB11863@gaia>
 <904edac0-3de7-35a6-a9bc-b983ccd3490c@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <904edac0-3de7-35a6-a9bc-b983ccd3490c@arm.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Cc: Marc Zyngier <maz@kernel.org>,
 lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
 Dave P Martin <Dave.Martin@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>,
 "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
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

On Wed, Jun 24, 2020 at 12:18:46PM +0100, Steven Price wrote:
> On 24/06/2020 12:09, Catalin Marinas wrote:
> > On Wed, Jun 24, 2020 at 12:03:35PM +0100, Steven Price wrote:
> > > On 24/06/2020 11:34, Dave Martin wrote:
> > > > On Wed, Jun 24, 2020 at 10:38:48AM +0100, Catalin Marinas wrote:
> > > > > On Tue, Jun 23, 2020 at 07:05:07PM +0100, Peter Maydell wrote:
> > > > > > On Wed, 17 Jun 2020 at 13:39, Steven Price <steven.price@arm.com> wrote:
> > > > > > > These patches add support to KVM to enable MTE within a guest. It is
> > > > > > > based on Catalin's v4 MTE user space series[1].
> > > > > > > 
> > > > > > > [1] http://lkml.kernel.org/r/20200515171612.1020-1-catalin.marinas%40arm.com
> > > > > > > 
> > > > > > > Posting as an RFC as I'd like feedback on the approach taken.
> > > > > > 
> > > > > > What's your plan for handling tags across VM migration?
> > > > > > Will the kernel expose the tag ram to userspace so we
> > > > > > can copy it from the source machine to the destination
> > > > > > at the same time as we copy the actual ram contents ?
> > > > > 
> > > > > Qemu can map the guest memory with PROT_MTE and access the tags directly
> > > > > with LDG/STG instructions. Steven was actually asking in the cover
> > > > > letter whether we should require that the VMM maps the guest memory with
> > > > > PROT_MTE as a guarantee that it can access the guest tags.
> > > > > 
> > > > > There is no architecturally visible tag ram (tag storage), that's a
> > > > > microarchitecture detail.
> > > > 
> > > > If userspace maps the guest memory with PROT_MTE for dump purposes,
> > > > isn't it going to get tag check faults when accessing the memory
> > > > (i.e., when dumping the regular memory content, not the tags
> > > > specifically).
> > > > 
> > > > Does it need to map two aliases, one with PROT_MTE and one without,
> > > > and is that architecturally valid?
> > > 
> > > Userspace would either need to have two mappings (I don't believe there are
> > > any architectural issues with that - but this could be awkward to arrange in
> > > some situations) or be careful to avoid faults. Basically your choices with
> > > one mapping are:
> > > 
> > >   1. Disable tag checking (using prctl) when touching the memory. This works
> > > but means you lose tag checking for the VMM's own accesses during this code
> > > sequence.
> > > 
> > >   2. Read the tag values and ensure you use the correct tag. This suffers
> > > from race conditions if the VM is still running.
> > > 
> > >   3. Use one of the exceptions in the architecture that generates a Tag
> > > Unchecked access. Sadly the only remotely useful thing I can see in the v8
> > > ARM is "A base register plus immediate offset addressing form, with the SP
> > > as the base register." - but making sure SP is in range of where you want to
> > > access would be a pain.
> > 
> > Or:
> > 
> > 4. Set PSTATE.TCO when accessing tagged memory in an unsafe way.
> 
> Ah yes, similar to (1) but much lower overhead ;) That's probably the best
> option - it can be hidden in a memcpy_ignoring_tags() function. However it
> still means that the VMM can't directly touch the guest's memory which might
> cause issues for the VMM.

You are right, I don't think it's safe for the VMM to access the guest
memory via a PROT_MTE mapping. If the guest is using memory tagging for
for a buffer and then it is passed to qemu for virtio, the tag
information may have been lost already (does qemu only get the IPA in
this case?)

So we may end up with two mappings after all, one for the normal
execution and a new on if migration is needed.

-- 
Catalin
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
