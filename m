From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 00/27] arm64: KVM: Mediate access to GICv3 sysregs at EL2
Date: Fri,  9 Jun 2017 12:49:29 +0100
Message-ID: <20170609114956.25963-1-marc.zyngier@arm.com>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, Robert Richter <rrichter@cavium.com>, Eric Auger <eric.auger@redhat.com>, Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Some systems have less than perfect GICv3 implementations, leading to
all kind of ugly issues (guest hanging, host dying). In order to allow
some level of diagnostic, and in some cases implement workarounds,
this series enables the trapping of both Group-0, Group-1 and Common
sysregs. Mediating the access at EL2 allows some form of sanity
checking that the HW is sometimes sorely lacking.

Instead of fully emulating a GICv3 CPU interface, we still use the
existing HW (list registers, AP registers, VMCR...), which allows the
code to be independent from the rest of the KVM code, and to cope with
partial trapping.

Of course, trapping has a cost, which is why this must be either
enabled on the command line, or selected by another cpu capability
(see Cavium erratum 30115). A quick test on an A57-based platform
shows a 25% hit when repeatedly banging on the trapped registers,
while normal workloads do not seem to suffer noticeably from such
trapping (hackbench variance is in the usual noise, despite being very
IPI happy).

This has been tested on a dual socket Thundex-X and a Freescale
LS-2085a, as well as separately by David Daney and Alex Graf.

I've taken the liberty to rebase David Daney's initial Cavium erratum
30115 workaround on top of this series, and included it here as a
typical use case.

- From v2:
  * Added patches that check for illeggal accesses, just in case...
  * Fixed a number of bugs in handling BPR1, IAR0
  * Tried to clarify the use of the preemption bits
  * Renamed the command-line options to refer to kvm-arm
  * Added documentation for these options
  * Added TBs, ABs, RBs
  * Rebased on 4.12-rc4 + d68356cc51e3 (from kvmarm/master)

- From v1:
  * Fix bug in DIR handling which would have performed a deactivation even
    when EOImode==0
  * Some minor cleanups and clarifications.
  * All the initial fixes have already been merged.
  * Rebased on 4.12-rc3.

David Daney (2):
  arm64: Add MIDR values for Cavium cn83XX SoCs
  arm64: Add workaround for Cavium Thunder erratum 30115

Marc Zyngier (25):
  arm64: Add a facility to turn an ESR syndrome into a sysreg encoding
  KVM: arm/arm64: vgic-v3: Add accessors for the ICH_APxRn_EL2 registers
  KVM: arm64: Make kvm_condition_valid32() accessible from EL2
  KVM: arm64: vgic-v3: Add hook to handle guest GICv3 sysreg accesses at
    EL2
  KVM: arm64: vgic-v3: Add ICV_BPR1_EL1 handler
  KVM: arm64: vgic-v3: Add ICV_IGRPEN1_EL1 handler
  KVM: arm64: vgic-v3: Add ICV_IAR1_EL1 handler
  KVM: arm64: vgic-v3: Add ICV_EOIR1_EL1 handler
  KVM: arm64: vgic-v3: Add ICV_AP1Rn_EL1 handler
  KVM: arm64: vgic-v3: Add ICV_HPPIR1_EL1 handler
  KVM: arm64: vgic-v3: Enable trapping of Group-1 system registers
  KVM: arm64: Enable GICv3 Group-1 sysreg trapping via command-line
  KVM: arm64: vgic-v3: Add ICV_BPR0_EL1 handler
  KVM: arm64: vgic-v3: Add ICV_IGNREN0_EL1 handler
  KVM: arm64: vgic-v3: Add misc Group-0 handlers
  KVM: arm64: vgic-v3: Enable trapping of Group-0 system registers
  KVM: arm64: Enable GICv3 Group-0 sysreg trapping via command-line
  KVM: arm64: vgic-v3: Add ICV_DIR_EL1 handler
  KVM: arm64: vgic-v3: Add ICV_RPR_EL1 handler
  KVM: arm64: vgic-v3: Add ICV_CTLR_EL1 handler
  KVM: arm64: vgic-v3: Add ICV_PMR_EL1 handler
  KVM: arm64: Enable GICv3 common sysreg trapping via command-line
  KVM: arm64: vgic-v3: Log which GICv3 system registers are trapped
  KVM: arm64: Log an error if trapping a read-from-write-only GICv3
    access
  KVM: arm64: Log an error if trapping a write-to-read-only GICv3 access

 Documentation/admin-guide/kernel-parameters.txt |  12 +
 Documentation/arm64/silicon-errata.txt          |   1 +
 arch/arm64/Kconfig                              |  11 +
 arch/arm64/include/asm/cpucaps.h                |   3 +-
 arch/arm64/include/asm/cputype.h                |   2 +
 arch/arm64/include/asm/esr.h                    |  24 +
 arch/arm64/include/asm/kvm_hyp.h                |   1 +
 arch/arm64/include/asm/sysreg.h                 |   9 +
 arch/arm64/kernel/cpu_errata.c                  |  21 +
 arch/arm64/kvm/hyp/switch.c                     |  14 +
 arch/arm64/kvm/sys_regs.c                       |  27 +-
 include/kvm/arm_vgic.h                          |   1 +
 include/linux/irqchip/arm-gic-v3.h              |   6 +
 virt/kvm/arm/aarch32.c                          |   2 +-
 virt/kvm/arm/hyp/vgic-v3-sr.c                   | 823 +++++++++++++++++++++++-
 virt/kvm/arm/vgic/vgic-v3.c                     |  45 ++
 16 files changed, 980 insertions(+), 22 deletions(-)

-- 
2.11.0
