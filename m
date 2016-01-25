From: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 00/21] arm64: Virtualization Host Extension support
Date: Mon, 25 Jan 2016 16:44:36 +0000
Message-ID: <20160125164435.GG22927@arm.com>
References: <1453737235-16522-1-git-send-email-marc.zyngier@arm.com>
 <20160125162613.GD22927@arm.com>
 <56A64F53.4000201@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56A64F53.4000201@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Jan 25, 2016 at 04:37:39PM +0000, Marc Zyngier wrote:
> On 25/01/16 16:26, Will Deacon wrote:
> > On Mon, Jan 25, 2016 at 03:53:34PM +0000, Marc Zyngier wrote:
> >> ARMv8.1 comes with the "Virtualization Host Extension" (VHE for
> >> short), which enables simpler support of Type-2 hypervisors.
> >>
> >> This extension allows the kernel to directly run at EL2, and
> >> significantly reduces the number of system registers shared between
> >> host and guest, reducing the overhead of virtualization.
> >>
> >> In order to have the same kernel binary running on all versions of the
> >> architecture, this series makes heavy use of runtime code patching.
> >>
> >> The first 20 patches massage the KVM code to deal with VHE and enable
> >> Linux to run at EL2. The last patch catches an ugly case when VHE
> >> capable CPUs are paired with some of their less capable siblings. This
> >> should never happen, but hey...
> >>
> >> I have deliberately left out some of the more "advanced"
> >> optimizations, as they are likely to distract the reviewer from the
> >> core infrastructure, which is what I care about at the moment.
> >>
> >> A few things to note:
> >>
> >> - Given that the code has been almost entierely rewritten, I've
> >>   dropped all Acks from the new patches
> >>
> >> - GDB is currently busted on VHE systems, as it checks for version 6
> >>   on the debug architecture, while VHE is version 7. The binutils
> >>   people are on the case.
> > 
> > [...]
> > 
> >>  arch/arm/include/asm/virt.h          |   5 ++
> >>  arch/arm/kvm/arm.c                   | 151 +++++++++++++++++++------------
> >>  arch/arm/kvm/mmu.c                   |   7 ++
> >>  arch/arm64/Kconfig                   |  13 +++
> >>  arch/arm64/include/asm/cpufeature.h  |   3 +-
> >>  arch/arm64/include/asm/kvm_arm.h     |   1 +
> >>  arch/arm64/include/asm/kvm_emulate.h |   3 +
> >>  arch/arm64/include/asm/kvm_mmu.h     |  34 ++++++-
> >>  arch/arm64/include/asm/virt.h        |  27 ++++++
> >>  arch/arm64/kernel/asm-offsets.c      |   3 -
> >>  arch/arm64/kernel/cpufeature.c       |  15 +++-
> >>  arch/arm64/kernel/head.S             |  51 ++++++++++-
> >>  arch/arm64/kernel/smp.c              |   3 +
> >>  arch/arm64/kvm/hyp-init.S            |  18 +---
> >>  arch/arm64/kvm/hyp.S                 |   7 ++
> >>  arch/arm64/kvm/hyp/entry.S           |   6 ++
> >>  arch/arm64/kvm/hyp/hyp-entry.S       | 107 +++++++---------------
> >>  arch/arm64/kvm/hyp/hyp.h             | 119 ++++++++++++++++++++++--
> >>  arch/arm64/kvm/hyp/switch.c          | 170 +++++++++++++++++++++++++++++++----
> >>  arch/arm64/kvm/hyp/sysreg-sr.c       | 147 ++++++++++++++++++++----------
> >>  arch/arm64/kvm/hyp/timer-sr.c        |  10 +--
> >>  drivers/clocksource/arm_arch_timer.c |  96 ++++++++++++--------
> >>  22 files changed, 724 insertions(+), 272 deletions(-)
> > 
> > Have you tried hw_breakpoint/perf/ptrace with these changes? I was under
> > the impression that the debug architecture was aware of E2H and did need
> > some changes made. I know you say that GDB is broken anyway, but we should
> > check that the kernel does the right thing if userspace pokes it the
> > right way.
> 
> I did use HW breakpoints on the model by hacking the host kernel to
> return Debug Version 6 instead of 7, and things seem to work as
> expected. strace also works out of the box.
> 
> As for perf, did you have something precise in mind?

It would be worth trying things like the filter options on perf events
(perf stat -e cycles:k to count cycles in kernel space) and also
breakpoints (perf stat -e mem:<addr>:rwx on kernel addresses).

Will
