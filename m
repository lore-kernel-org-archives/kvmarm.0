Return-Path: <SRS0=mzwA=FH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D828C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 16:59:10 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8C94E207A3
	for <kvmarm@archiver.kernel.org>; Thu,  3 Dec 2020 16:59:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8C94E207A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6C004B16C;
	Thu,  3 Dec 2020 11:59:07 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LECvZB5B5fZU; Thu,  3 Dec 2020 11:59:06 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C60094B17A;
	Thu,  3 Dec 2020 11:59:06 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 07C094B16C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 11:59:05 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cjvwXxmbDO25 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Dec 2020 11:59:03 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 82B904B11F
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Dec 2020 11:59:03 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 24ADA11D4;
 Thu,  3 Dec 2020 08:59:03 -0800 (PST)
Received: from C02TD0UTHF1T.local (unknown [10.57.0.87])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 495BC3F575;
 Thu,  3 Dec 2020 08:59:00 -0800 (PST)
Date: Thu, 3 Dec 2020 16:58:56 +0000
From: Mark Rutland <mark.rutland@arm.com>
To: Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v6 0/2] MTE support for KVM guest
Message-ID: <20201203165856.GH96754@C02TD0UTHF1T.local>
References: <20201127152113.13099-1-steven.price@arm.com>
 <20201203160943.GG96754@C02TD0UTHF1T.local>
 <77e65f06-563b-3b30-ab36-9670e8cc03a4@arm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <77e65f06-563b-3b30-ab36-9670e8cc03a4@arm.com>
Cc: "Dr. David Alan Gilbert" <dgilbert@redhat.com>, qemu-devel@nongnu.org,
 Catalin Marinas <catalin.marinas@arm.com>, Juan Quintela <quintela@redhat.com>,
 Richard Henderson <richard.henderson@linaro.org>, linux-kernel@vger.kernel.org,
 Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu
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

On Thu, Dec 03, 2020 at 04:49:49PM +0000, Steven Price wrote:
> On 03/12/2020 16:09, Mark Rutland wrote:
> > On Fri, Nov 27, 2020 at 03:21:11PM +0000, Steven Price wrote:
> > > It's been a week, and I think the comments on v5 made it clear that
> > > enforcing PROT_MTE requirements on the VMM was probably the wrong
> > > approach. So since I've got swap working correctly without that I
> > > thought I'd post a v6 which hopefully addresses all the comments so far.
> > > 
> > > This series adds support for Arm's Memory Tagging Extension (MTE) to
> > > KVM, allowing KVM guests to make use of it. This builds on the existing
> > > user space support already in v5.10-rc4, see [1] for an overview.
> > 
> > >   arch/arm64/include/asm/kvm_emulate.h       |  3 +++
> > >   arch/arm64/include/asm/kvm_host.h          |  8 ++++++++
> > >   arch/arm64/include/asm/pgtable.h           |  2 +-
> > >   arch/arm64/include/asm/sysreg.h            |  3 ++-
> > >   arch/arm64/kernel/mte.c                    | 18 +++++++++++++-----
> > >   arch/arm64/kvm/arm.c                       |  9 +++++++++
> > >   arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 14 ++++++++++++++
> > >   arch/arm64/kvm/mmu.c                       | 16 ++++++++++++++++
> > >   arch/arm64/kvm/sys_regs.c                  | 20 +++++++++++++++-----
> > >   include/uapi/linux/kvm.h                   |  1 +
> > >   10 files changed, 82 insertions(+), 12 deletions(-)
> > 
> > I note that doesn't fixup arch/arm64/kvm/inject_fault.c, where in
> > enter_exception64() we have:
> > 
> > | // TODO: TCO (if/when ARMv8.5-MemTag is exposed to guests)
> > 
> > ... and IIUC when MTE is present, TCO should be set when delivering an
> > exception, so I believe that needs to be updated to set TCO.
> 
> Well spotted! As you say TCO should be set when delivering an exception, so
> we need the following:
> 
> -       // TODO: TCO (if/when ARMv8.5-MemTag is exposed to guests)
> +       if (kvm_has_mte(vcpu->kvm))
> +               new |= PSR_TCO_BIT;

Something of that sort, yes.

It'd be worth a look for any mention of TCO or MTE in case there are
other bits that need a fixup.

> > Given that MTE-capable HW does that unconditionally, this is going to be
> > a mess for big.LITTLE. :/
> 
> I'm not sure I follow. Either all CPUs support MTE in which this isn't a
> problem, or the MTE feature just isn't exposed. We don't support a mix of
> MTE and non-MTE CPUs. There are several aspects of MTE which effective mean
> it's an all-or-nothing feature for the system.

So long as the host requires uniform MTE support, I agree that's not a
problem.

The fun is that the CPUs themselves will set TCO upon a real exception
regardless of whether the host is aware, and on a mismatched system some
CPUs will do that while others will not. In such a case the host and
guest will end up seeing the SPSR TCO bit set sometimes upon exceptions
from EL1 or EL2, and I hope that MTE-unaware CPUs ignore the bit upon
ERET, or we're going to have significant problems.

Thanks,
Mark.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
