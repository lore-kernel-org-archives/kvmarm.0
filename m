From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [GIT PULL] KVM/ARM updates for 4.13
Date: Fri, 30 Jun 2017 09:44:16 +0100
Message-ID: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, Alexander Graf <agraf@suse.de>, Andrew Jones <drjones@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <cdall@linaro.org>, David Daney <david.daney@cavium.com>, Eric Auger <eric.auger@redhat.com>, Hu Huajun <huhuajun@huawei.com>, James Morse <james.morse@arm.com>, Mark Rutland <mark.rutland@arm.com>, Stefan Traby <stefan@hello-penguin.com>
List-Id: kvmarm@lists.cs.columbia.edu

Paolo, Radim,

This is the pull request for the 4.13 edition of KVM/ARM. Among the
changes this time around, a rework of the vcpu request infrastructure
and its adoption on ARM, a was for userspace to define which
interrupts get assigned to timer and PMU, a workaround for a nasty
erratum on Cavium HW, and a bit more. Some of the patches touch core
arm64 code, and are acked by the maintainers.

There will be a small clash with the s390 tree, as mentionned by
Stephen Rothwell, as well as with the arm64 tree. Both conflicts are
trivial to resolve, and linux-next got it right (as usual).

Please pull.

       M.

The following changes since commit 33b5c38852b29736f3b472dd095c9a18ec22746f:

  arm: KVM: Allow unaligned accesses at HYP (2017-06-06 22:20:02 +0200)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/kvmarm/kvmarm.git tags/kvmarm-for-4.13

for you to fetch changes up to d38338e396ee0571b3502962fd2fbaec4d2d9a8f:

  arm64: Remove a redundancy in sysreg.h (2017-06-22 17:38:42 +0100)

----------------------------------------------------------------
KVM/ARM updates for 4.13

- vcpu request overhaul
- allow timer and PMU to have their interrupt number
  selected from userspace
- workaround for Cavium erratum 30115
- handling of memory poisonning
- the usual crop of fixes and cleanups

----------------------------------------------------------------
Andrew Jones (10):
      KVM: improve arch vcpu request defining
      KVM: Add documentation for VCPU requests
      KVM: arm/arm64: properly use vcpu requests
      KVM: arm/arm64: replace pause checks with vcpu request checks
      KVM: arm/arm64: use vcpu requests for power_off
      KVM: arm/arm64: optimize VCPU RUN
      KVM: arm/arm64: change exit request to sleep request
      KVM: arm/arm64: use vcpu requests for irq injection
      KVM: arm/arm64: PMU: remove request-less vcpu kick
      KVM: arm/arm64: timer: remove request-less vcpu kick

Christoffer Dall (13):
      KVM: arm/arm64: Allow GICv2 to supply a uaccess register function
      KVM: arm/arm64: Separate guest and uaccess writes to dist {sc}active
      KVM: arm/arm64: Simplify active_change_prepare and plug race
      KVM: arm/arm64: Use uaccess functions for GICv3 {sc}active
      KVM: arm64: Allow creating the PMU without the in-kernel GIC
      KVM: arm: Handle VCPU device attributes in guest.c
      KVM: arm/arm64: Move irq_is_ppi() to header file
      KVM: arm/arm64: Move timer IRQ default init to arch_timer.c
      KVM: arm/arm64: Allow setting the timer IRQ numbers from userspace
      KVM: arm/arm64: Introduce an allocator for in-kernel irq lines
      KVM: arm/arm64: Check if irq lines to the GIC are already used
      KVM: arm/arm64: Disallow userspace control of in-kernel IRQ lines
      KVM: arm/arm64: Don't assume initialized vgic when setting PMU IRQ

David Daney (2):
      arm64: Add MIDR values for Cavium cn83XX SoCs
      arm64: Add workaround for Cavium Thunder erratum 30115

Hu Huajun (1):
      KVM: ARM64: fix phy counter access failure in guest.

James Morse (3):
      KVM: arm: Restore banked registers and physical timer access on hyp_panic()
      KVM: arm64: Restore host physical timer access on hyp_panic()
      KVM: arm/arm64: Signal SIGBUS when stage2 discovers hwpoison memory

Marc Zyngier (26):
      Merge branch 'kvmarm-master/master' into HEAD
      arm64: Add a facility to turn an ESR syndrome into a sysreg encoding
      KVM: arm/arm64: vgic-v3: Add accessors for the ICH_APxRn_EL2 registers
      KVM: arm64: Make kvm_condition_valid32() accessible from EL2
      KVM: arm64: vgic-v3: Add hook to handle guest GICv3 sysreg accesses at EL2
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
      KVM: arm64: Log an error if trapping a read-from-write-only GICv3 access
      KVM: arm64: Log an error if trapping a write-to-read-only GICv3 access

Mark Rutland (2):
      arm64/kvm: sysreg: fix typo'd SYS_ICC_IGRPEN*_EL1
      arm64/kvm: vgic: use SYS_DESC()

Radim Krčmář (1):
      KVM: add kvm_request_pending

Stefan Traby (1):
      arm64: Remove a redundancy in sysreg.h

 Documentation/admin-guide/kernel-parameters.txt |  12 +
 Documentation/arm64/silicon-errata.txt          |   1 +
 Documentation/virtual/kvm/devices/vcpu.txt      |  41 +-
 Documentation/virtual/kvm/vcpu-requests.rst     | 307 +++++++++
 arch/arm/include/asm/kvm_host.h                 |  28 +-
 arch/arm/include/uapi/asm/kvm.h                 |   8 +
 arch/arm/kvm/guest.c                            |  51 ++
 arch/arm/kvm/handle_exit.c                      |   1 +
 arch/arm/kvm/hyp/switch.c                       |   2 +
 arch/arm/kvm/reset.c                            |  16 +-
 arch/arm64/Kconfig                              |  11 +
 arch/arm64/include/asm/arch_gicv3.h             |   2 +-
 arch/arm64/include/asm/cpucaps.h                |   3 +-
 arch/arm64/include/asm/cputype.h                |   2 +
 arch/arm64/include/asm/esr.h                    |  24 +
 arch/arm64/include/asm/kvm_host.h               |   6 +-
 arch/arm64/include/asm/kvm_hyp.h                |   1 +
 arch/arm64/include/asm/sysreg.h                 |  23 +-
 arch/arm64/include/uapi/asm/kvm.h               |   3 +
 arch/arm64/kernel/cpu_errata.c                  |  21 +
 arch/arm64/kvm/guest.c                          |   9 +
 arch/arm64/kvm/handle_exit.c                    |   1 +
 arch/arm64/kvm/hyp/switch.c                     |  15 +
 arch/arm64/kvm/reset.c                          |  16 +-
 arch/arm64/kvm/sys_regs.c                       |  27 +-
 arch/arm64/kvm/vgic-sys-reg-v3.c                |  45 +-
 arch/mips/kvm/trap_emul.c                       |   2 +-
 arch/mips/kvm/vz.c                              |   2 +-
 arch/powerpc/include/asm/kvm_host.h             |   4 +-
 arch/powerpc/kvm/booke.c                        |   2 +-
 arch/powerpc/kvm/powerpc.c                      |   5 +-
 arch/s390/include/asm/kvm_host.h                |   6 +-
 arch/s390/kvm/kvm-s390.c                        |   2 +-
 arch/x86/include/asm/kvm_host.h                 |  47 +-
 arch/x86/kvm/x86.c                              |   4 +-
 include/kvm/arm_arch_timer.h                    |   8 +-
 include/kvm/arm_pmu.h                           |   6 +
 include/kvm/arm_vgic.h                          |  14 +-
 include/linux/irqchip/arm-gic-v3.h              |   6 +
 include/linux/kvm_host.h                        |  12 +
 virt/kvm/arm/aarch32.c                          |   2 +-
 virt/kvm/arm/arch_timer.c                       | 139 +++-
 virt/kvm/arm/arm.c                              |  82 ++-
 virt/kvm/arm/hyp/vgic-v3-sr.c                   | 823 +++++++++++++++++++++++-
 virt/kvm/arm/mmu.c                              |  23 +
 virt/kvm/arm/pmu.c                              | 117 ++--
 virt/kvm/arm/psci.c                             |   8 +-
 virt/kvm/arm/vgic/vgic-irqfd.c                  |   2 +-
 virt/kvm/arm/vgic/vgic-mmio-v2.c                |  24 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c                |  22 +-
 virt/kvm/arm/vgic/vgic-mmio.c                   |  68 +-
 virt/kvm/arm/vgic/vgic-mmio.h                   |  12 +-
 virt/kvm/arm/vgic/vgic-v3.c                     |  45 ++
 virt/kvm/arm/vgic/vgic.c                        |  68 +-
 54 files changed, 1945 insertions(+), 286 deletions(-)
 create mode 100644 Documentation/virtual/kvm/vcpu-requests.rst
