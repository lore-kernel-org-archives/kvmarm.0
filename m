Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB955C433EF
	for <kvmarm@archiver.kernel.org>; Fri,  4 Feb 2022 11:47:23 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AAA849E22;
	Fri,  4 Feb 2022 06:47:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id w4dPpHmUk9Qw; Fri,  4 Feb 2022 06:47:21 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D415949E29;
	Fri,  4 Feb 2022 06:47:21 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E73449E22
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Feb 2022 06:47:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 80ALQ4OBoHGM for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Feb 2022 06:47:19 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 06C9849B26
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Feb 2022 06:47:18 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5687F1480;
 Fri,  4 Feb 2022 03:47:18 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 838873F40C;
 Fri,  4 Feb 2022 03:47:15 -0800 (PST)
Date: Fri, 4 Feb 2022 11:47:25 +0000
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: [PATCH v6 09/64] KVM: arm64: nv: Support virtual EL2 exceptions
Message-ID: <Yf0STQXSEtPPApTL@monolith.localdoman>
References: <20220128121912.509006-1-maz@kernel.org>
 <20220128121912.509006-10-maz@kernel.org>
 <Yfqh6BocbZA1jexU@monolith.localdoman>
 <87h79f3kxj.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87h79f3kxj.wl-maz@kernel.org>
Cc: kernel-team@android.com, kvm@vger.kernel.org,
 Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Chase Conklin <chase.conklin@arm.com>, kvmarm@lists.cs.columbia.edu,
 mihai.carabas@oracle.com,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 "Russell King \(Oracle\)" <linux@armlinux.org.uk>,
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

Hi Marc,

On Thu, Feb 03, 2022 at 05:43:36PM +0000, Marc Zyngier wrote:
> On Wed, 02 Feb 2022 15:23:20 +0000,
> Alexandru Elisei <alexandru.elisei@arm.com> wrote:
> > 
> > Hi,
> > 
> > On Fri, Jan 28, 2022 at 12:18:17PM +0000, Marc Zyngier wrote:
> > > diff --git a/arch/arm64/kvm/emulate-nested.c b/arch/arm64/kvm/emulate-nested.c
> > > new file mode 100644
> > > index 000000000000..f52cd4458947
> > > --- /dev/null
> > > +++ b/arch/arm64/kvm/emulate-nested.c
> > > @@ -0,0 +1,197 @@
> > 
> > Looks like this line:
> > 
> > // SPDX-License-Identifier: GPL-2.0-only
> > 
> > is missing.
> 
> Indeed. I should check all the new files, as they are a bit... off.
> 
> > 
> > > +/*
> > > + * Copyright (C) 2016 - Linaro and Columbia University
> > > + * Author: Jintack Lim <jintack.lim@linaro.org>
> > > + */
> > > +
> > > +#include <linux/kvm.h>
> > > +#include <linux/kvm_host.h>
> > > +
> > > +#include <asm/kvm_emulate.h>
> > > +#include <asm/kvm_nested.h>
> > > +
> > > +#include "hyp/include/hyp/adjust_pc.h"
> > > +
> > > +#include "trace.h"
> > > +
> > > +static u64 kvm_check_illegal_exception_return(struct kvm_vcpu *vcpu, u64 spsr)
> > > +{
> > > +	u64 mode = spsr & PSR_MODE_MASK;
> > > +
> > > +	/*
> > > +	 * Possible causes for an Illegal Exception Return from EL2:
> > > +	 * - trying to return to EL3
> > > +	 * - trying to return to a 32bit EL
> > > +	 * - trying to return to EL1 with HCR_EL2.TGE set
> > > +	 */
> > > +	if (mode == PSR_MODE_EL3t || mode == PSR_MODE_EL3h ||
> > > +	    spsr & PSR_MODE32_BIT ||
> > 
> > I take it KVM will not allow a L1 hypervisor to run EL1 or EL0 in 32
> > bit mode?
> 
> No, that'd really be a distraction at this stage. I don't expect any
> HW supporting NV NV to support AArch32 at EL1, and if someone really
> needs EL0 support (the HW support actually exists), they'll have to
> revisit this.
> 
> >
> > > +	    (vcpu_el2_tge_is_set(vcpu) && (mode == PSR_MODE_EL1t ||
> > > +					   mode == PSR_MODE_EL1h))) {
> > 
> > I think these checks should also be added:
> > 
> > "A return where the value of the saved process state M[4] bit is 0,
> > indicating a return to AArch64 state, and one of the following is
> > true:
> > 
> > - The M[1] bit is 1.
> > - The M[3:0] bits are 0b0001.
> 
> Definitely should add these two, probably in the form of a switch
> enumerating all the possible exception levels rather than checking for
> discrete bits that are hard to reason about.
> 
> > - The Exception level being returned to is using AArch32 state, as
> >   programmed by the SCR_EL3.RW or HCR_EL2.RW bits, or as configured
> >   from reset."
> 
> That's already caught with the SPSR check above.

Hmm... I don't think so. The illegal condition, according to the snippet, should
be:

!(mode & PSR_MODE32_BIT) && !(__vcpu_sys_reg(vcpu, HCR_EL2) & HCR_RW)

Or, perhaps better, KVM could add an HCR_EL2 accessor that treated the
HCR_EL2.RW bit as RA0/WI as per the architecture when the EL1 is not capable of
AArch32.  That would make the above situation impossible.

Thanks,
Alex

> 
> Thanks,
> 
> 	M.
> 
> -- 
> Without deviation from the norm, progress is not possible.
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
