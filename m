From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: [PATCH v4 00/15] ARM Spectre variant 2 fixes
Date: Tue, 29 May 2018 10:07:57 +0100
Message-ID: <20180529090756.GG17671@n2100.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Florian Fainelli <f.fainelli@gmail.com>, kvmarm@lists.cs.columbia.edu, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Fourth version:
- Only warn once per CPU about incorrect IBE bit
  (this avoids spamming the kernel log on cpuidle implementations that
   use cpu_suspend() - spotted by Mark Brown.)

 arch/arm/include/asm/bugs.h        |   6 +-
 arch/arm/include/asm/cp15.h        |   3 +
 arch/arm/include/asm/cputype.h     |   8 ++
 arch/arm/include/asm/kvm_asm.h     |   2 -
 arch/arm/include/asm/kvm_host.h    |  14 ++-
 arch/arm/include/asm/kvm_mmu.h     |  23 ++++-
 arch/arm/include/asm/proc-fns.h    |   4 +
 arch/arm/include/asm/system_misc.h |  15 ++++
 arch/arm/kernel/Makefile           |   1 +
 arch/arm/kernel/bugs.c             |  18 ++++
 arch/arm/kernel/smp.c              |   4 +
 arch/arm/kernel/suspend.c          |   2 +
 arch/arm/kvm/hyp/hyp-entry.S       | 112 +++++++++++++++++++++++-
 arch/arm/mm/Kconfig                |  23 +++++
 arch/arm/mm/Makefile               |   2 +-
 arch/arm/mm/fault.c                |   3 +
 arch/arm/mm/proc-macros.S          |   3 +-
 arch/arm/mm/proc-v7-2level.S       |   6 --
 arch/arm/mm/proc-v7-bugs.c         | 173 +++++++++++++++++++++++++++++++++++++
 arch/arm/mm/proc-v7.S              | 154 ++++++++++++++++++++++++++-------
 20 files changed, 526 insertions(+), 50 deletions(-)
 create mode 100644 arch/arm/kernel/bugs.c
 create mode 100644 arch/arm/mm/proc-v7-bugs.c

On Fri, May 25, 2018 at 02:59:39PM +0100, Russell King - ARM Linux wrote:
> Third version:
> - Remove "PSCI" from the SMC version of the workaround as well.
> - Avoid reporting active workaround if the IBE bit is not set.
> - Only probe for workaround_1 on Cortex A57 and A72, or non-ARM CPUs.
> - Require features probe for workaround_1 to return zero.
> - Validation that all CPUs in the system have the same workaround status.
> - Avoid corrupting r12 in workaround_1 KVM hypervisor implementation.
> 
>  arch/arm/include/asm/bugs.h        |   6 +-
>  arch/arm/include/asm/cp15.h        |   3 +
>  arch/arm/include/asm/cputype.h     |   8 ++
>  arch/arm/include/asm/kvm_asm.h     |   2 -
>  arch/arm/include/asm/kvm_host.h    |  14 ++-
>  arch/arm/include/asm/kvm_mmu.h     |  23 ++++-
>  arch/arm/include/asm/proc-fns.h    |   4 +
>  arch/arm/include/asm/system_misc.h |  15 ++++
>  arch/arm/kernel/Makefile           |   1 +
>  arch/arm/kernel/bugs.c             |  18 ++++
>  arch/arm/kernel/smp.c              |   4 +
>  arch/arm/kernel/suspend.c          |   2 +
>  arch/arm/kvm/hyp/hyp-entry.S       | 112 +++++++++++++++++++++++-
>  arch/arm/mm/Kconfig                |  23 +++++
>  arch/arm/mm/Makefile               |   2 +-
>  arch/arm/mm/fault.c                |   3 +
>  arch/arm/mm/proc-macros.S          |   3 +-
>  arch/arm/mm/proc-v7-2level.S       |   6 --
>  arch/arm/mm/proc-v7-bugs.c         | 170 +++++++++++++++++++++++++++++++++++++
>  arch/arm/mm/proc-v7.S              | 154 ++++++++++++++++++++++++++-------
>  20 files changed, 523 insertions(+), 50 deletions(-)
>  create mode 100644 arch/arm/kernel/bugs.c
>  create mode 100644 arch/arm/mm/proc-v7-bugs.c
> 
> On Mon, May 21, 2018 at 12:42:38PM +0100, Russell King - ARM Linux wrote:
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
> > 
> > On Wed, May 16, 2018 at 11:59:49AM +0100, Russell King - ARM Linux wrote:
> > > This series addresses the Spectre variant 2 issues on ARM Cortex and
> > > Broadcom Brahma B15 CPUs.  Due to the complexity of the bug, it is not
> > > possible to verify that this series fixes any of the bugs, since it
> > > has not been able to reproduce these exact scenarios using test
> > > programs.
> > > 
> > > I believe that this covers the entire extent of the Spectre variant 2
> > > issues, with the exception of Cortex A53 and Cortex A72 processors as
> > > these require a substantially more complex solution (except where the
> > > workaround is implemented in PSCI firmware.)
> > > 
> > > Spectre variant 1 is not covered by this series.
> > > 
> > > The patch series is based partly on Marc Zyngier's work from February -
> > > two of the KVM patches are from Marc's work.
> > > 
> > > The main differences are:
> > > - Inclusion of more processors as per current ARM Ltd security update
> > >   documentation.
> > > - Extension of "bugs" infrastructure to detect Cortex A8 and Cortex A15
> > >   CPUs missing out on the IBE bit being set on (re-)entry to the kernel
> > >   through all paths.
> > > - Handle all suspect userspace-touching-kernelspace aborts irrespective
> > >   of mapping type.
> > > 
> > > The first patch will trivially conflict with the Broadcom Brahma
> > > updates already in arm-soc - it has been necessary to independently
> > > add the ID definitions for the B15 CPU.
> > > 
> > > Having worked through this series, I'm of the opinion that the
> > > define_processor_functions macro in proc-v7 are probably  more hassle
> > > than they're worth - here, we don't need the global equivalent symbols,
> > > because we never refer to them from the kernel code for any V7
> > > processor (MULTI_CPU is always defined.)
> > > 
> > > This series is currently in my "spectre" branch (along with some
> > > Spectre variant 1 patches.)
> > > 
> > > Please carefully review.
> > > 
> > >  arch/arm/include/asm/bugs.h        |   6 +-
> > >  arch/arm/include/asm/cp15.h        |   3 +
> > >  arch/arm/include/asm/cputype.h     |   5 ++
> > >  arch/arm/include/asm/kvm_asm.h     |   2 -
> > >  arch/arm/include/asm/kvm_host.h    |  14 +++-
> > >  arch/arm/include/asm/kvm_mmu.h     |  23 +++++-
> > >  arch/arm/include/asm/proc-fns.h    |   4 +
> > >  arch/arm/include/asm/system_misc.h |   8 ++
> > >  arch/arm/kernel/Makefile           |   1 +
> > >  arch/arm/kernel/bugs.c             |  18 +++++
> > >  arch/arm/kernel/smp.c              |   4 +
> > >  arch/arm/kernel/suspend.c          |   2 +
> > >  arch/arm/kvm/hyp/hyp-entry.S       | 108 ++++++++++++++++++++++++-
> > >  arch/arm/mm/Kconfig                |  23 ++++++
> > >  arch/arm/mm/Makefile               |   2 +-
> > >  arch/arm/mm/fault.c                |   3 +
> > >  arch/arm/mm/proc-macros.S          |   3 +-
> > >  arch/arm/mm/proc-v7-2level.S       |   6 --
> > >  arch/arm/mm/proc-v7-bugs.c         | 130 ++++++++++++++++++++++++++++++
> > >  arch/arm/mm/proc-v7.S              | 158 +++++++++++++++++++++++++++++--------
> > >  20 files changed, 471 insertions(+), 52 deletions(-)
> > > 
> > > -- 
> > > RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
> > > FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
> > > According to speedtest.net: 8.21Mbps down 510kbps up
> > > 
> > > _______________________________________________
> > > linux-arm-kernel mailing list
> > > linux-arm-kernel@lists.infradead.org
> > > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> > 
> > -- 
> > RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
> > FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
> > According to speedtest.net: 8.21Mbps down 510kbps up
> > 
> > _______________________________________________
> > linux-arm-kernel mailing list
> > linux-arm-kernel@lists.infradead.org
> > http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 
> -- 
> RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
> FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
> According to speedtest.net: 8.21Mbps down 510kbps up
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 8.8Mbps down 630kbps up
According to speedtest.net: 8.21Mbps down 510kbps up
