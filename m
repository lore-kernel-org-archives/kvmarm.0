From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH v2 00/14] ARM Spectre variant 2 fixes
Date: Fri, 25 May 2018 11:00:20 +0100
Message-ID: <20180525100020.GB17671@n2100.armlinux.org.uk>
References: <20180521114238.GN17671@n2100.armlinux.org.uk>
 <6845807d-4838-53e4-91ad-a7c6ef081f58@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D3CE849F7F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 05:50:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EzgA37Y0Qm14 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 May 2018 05:49:55 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9911349F7E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 May 2018 05:49:55 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <6845807d-4838-53e4-91ad-a7c6ef081f58@gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, tony@atomide.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, May 24, 2018 at 04:18:30PM -0700, Florian Fainelli wrote:
> On 05/21/2018 04:42 AM, Russell King - ARM Linux wrote:
> > This is the second posting - the original cover note is below.  Comments
> > from previous series addresesd:
> > - Drop R7 and R8 changes.
> > - Remove "PSCI" from the hypervisor version of the workaround.
> > 
> >  arch/arm/include/asm/bugs.h        |   6 +-
> >  arch/arm/include/asm/cp15.h        |   3 +
> >  arch/arm/include/asm/cputype.h     |   5 ++
> >  arch/arm/include/asm/kvm_asm.h     |   2 -
> >  arch/arm/include/asm/kvm_host.h    |  14 +++-
> >  arch/arm/include/asm/kvm_mmu.h     |  23 +++++-
> >  arch/arm/include/asm/proc-fns.h    |   4 +
> >  arch/arm/include/asm/system_misc.h |   8 ++
> >  arch/arm/kernel/Makefile           |   1 +
> >  arch/arm/kernel/bugs.c             |  18 +++++
> >  arch/arm/kernel/smp.c              |   4 +
> >  arch/arm/kernel/suspend.c          |   2 +
> >  arch/arm/kvm/hyp/hyp-entry.S       | 108 +++++++++++++++++++++++++-
> >  arch/arm/mm/Kconfig                |  23 ++++++
> >  arch/arm/mm/Makefile               |   2 +-
> >  arch/arm/mm/fault.c                |   3 +
> >  arch/arm/mm/proc-macros.S          |   3 +-
> >  arch/arm/mm/proc-v7-2level.S       |   6 --
> >  arch/arm/mm/proc-v7-bugs.c         | 130 +++++++++++++++++++++++++++++++
> >  arch/arm/mm/proc-v7.S              | 154 +++++++++++++++++++++++++++++--------
> >  20 files changed, 469 insertions(+), 50 deletions(-)
> >  create mode 100644 arch/arm/kernel/bugs.c
> >  create mode 100644 arch/arm/mm/proc-v7-bugs.c
> 
> Since there appears to be more work needed in the PSCI/KVM changes
> (patches 9 through 14), how about we go with the "bare-metal" parts:
> patches 1-8 first and try to get those included ASAP?
> 
> The rationale being that a lot of affected people have Linux running on
> ARMv7-A Cortex-A, typically A9, A15, Brahma-B15, and are in need of
> those patches but do not necessarily require KVM fixes right now, and
> even less so PSCI infrastructure to mitigate ARMv8-A running in AArch32.
> 
> In terms of backporting to -stable, and because the spectre variant 1
> patches have not been submitted yet, it is not like we can lump
> everything in one go anyway, so we are not making the lives of the
> -stable maintainers any worse than it currently is?

Patch 6 is implicated in the rework - it will cause big.Little systems
to either have the workaround applied when it isn't required or not
applied when it is required.  It depends which CPU is the boot CPU.

For example, a big.Little A7/A15 cluster - if the boot CPU is an A15,
then we will use the ICIALLI switch_mm method for both the A15 and A7.
If the boot CPU is an A7, then we will use the standard switch_mm
method that does not contain the workaround even for the A15, and the
A15 will then be vulnerable.

I don't think we have a way to identify if we boot on a big.Little
system, so the kernel messages could claim to have the workarounds,
but they won't be effective.

This is the hardest one to solve, because it means more invasive
changes to deal with the MM switching paths, which need to become
per-cpu.  The problem is, there are times that we call into that
path but the per-cpu variables are not accessible (because the CPU
isn't initialised sufficiently for them to work.)

It's trivial to solve the issues in the later patches by comparison.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
