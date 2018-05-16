From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: [PATCH 0/14] ARM Spectre variant 2 fixes
Date: Wed, 16 May 2018 11:59:49 +0100
Message-ID: <20180516105949.GJ16141@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AD1EA49EA2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 06:50:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id t5IiI6XXLybU for <kvmarm@lists.cs.columbia.edu>;
 Wed, 16 May 2018 06:49:41 -0400 (EDT)
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [78.32.30.218])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 38A5942121
 for <kvmarm@lists.cs.columbia.edu>; Wed, 16 May 2018 06:49:41 -0400 (EDT)
Content-Disposition: inline
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Florian Fainelli <f.fainelli@gmail.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

This series addresses the Spectre variant 2 issues on ARM Cortex and
Broadcom Brahma B15 CPUs.  Due to the complexity of the bug, it is not
possible to verify that this series fixes any of the bugs, since it
has not been able to reproduce these exact scenarios using test
programs.

I believe that this covers the entire extent of the Spectre variant 2
issues, with the exception of Cortex A53 and Cortex A72 processors as
these require a substantially more complex solution (except where the
workaround is implemented in PSCI firmware.)

Spectre variant 1 is not covered by this series.

The patch series is based partly on Marc Zyngier's work from February -
two of the KVM patches are from Marc's work.

The main differences are:
- Inclusion of more processors as per current ARM Ltd security update
  documentation.
- Extension of "bugs" infrastructure to detect Cortex A8 and Cortex A15
  CPUs missing out on the IBE bit being set on (re-)entry to the kernel
  through all paths.
- Handle all suspect userspace-touching-kernelspace aborts irrespective
  of mapping type.

The first patch will trivially conflict with the Broadcom Brahma
updates already in arm-soc - it has been necessary to independently
add the ID definitions for the B15 CPU.

Having worked through this series, I'm of the opinion that the
define_processor_functions macro in proc-v7 are probably  more hassle
than they're worth - here, we don't need the global equivalent symbols,
because we never refer to them from the kernel code for any V7
processor (MULTI_CPU is always defined.)

This series is currently in my "spectre" branch (along with some
Spectre variant 1 patches.)

Please carefully review.

 arch/arm/include/asm/bugs.h        |   6 +-
 arch/arm/include/asm/cp15.h        |   3 +
 arch/arm/include/asm/cputype.h     |   5 ++
 arch/arm/include/asm/kvm_asm.h     |   2 -
 arch/arm/include/asm/kvm_host.h    |  14 +++-
 arch/arm/include/asm/kvm_mmu.h     |  23 +++++-
 arch/arm/include/asm/proc-fns.h    |   4 +
 arch/arm/include/asm/system_misc.h |   8 ++
 arch/arm/kernel/Makefile           |   1 +
 arch/arm/kernel/bugs.c             |  18 +++++
 arch/arm/kernel/smp.c              |   4 +
 arch/arm/kernel/suspend.c          |   2 +
 arch/arm/kvm/hyp/hyp-entry.S       | 108 ++++++++++++++++++++++++-
 arch/arm/mm/Kconfig                |  23 ++++++
 arch/arm/mm/Makefile               |   2 +-
 arch/arm/mm/fault.c                |   3 +
 arch/arm/mm/proc-macros.S          |   3 +-
 arch/arm/mm/proc-v7-2level.S       |   6 --
 arch/arm/mm/proc-v7-bugs.c         | 130 ++++++++++++++++++++++++++++++
 arch/arm/mm/proc-v7.S              | 158 +++++++++++++++++++++++++++++--------
 20 files changed, 471 insertions(+), 52 deletions(-)

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
