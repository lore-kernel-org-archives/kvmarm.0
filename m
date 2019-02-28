From: Sudeep Holla <sudeep.holla@arm.com>
Subject: [PATCH 00/13] arm64: KVM: add SPE profiling support for guest
Date: Thu, 28 Feb 2019 16:07:22 +0000
Message-ID: <20190228160737.3323-1-sudeep.holla@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F16C94A3A5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:03 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EI1HyHQxMlYe for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Feb 2019 11:08:01 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A4EE34A36D
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Feb 2019 11:08:01 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Sudeep Holla <sudeep.holla@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

This series implements support for allowing KVM guests to use the Arm
Statistical Profiling Extension (SPE).

The patches are also available on a branch[1]. The last two extra
patches are for the kvmtool if someone wants to play with it.

Regards,
Sudeep

[1] git://git.kernel.org/pub/scm/linux/kernel/git/sudeep.holla/linux.git kvm_spe

Sudeep Holla (13):
  KVM: arm64: add {read,write}_sysreg_elx_s versions for new registers
  dt-bindings: ARM SPE: highlight the need for PPI partitions on
    heterogeneous systems
  arm64: KVM: reset E2PB correctly in MDCR_EL2 when exiting the
    guest(VHE)
  arm64: KVM: define SPE data structure for each vcpu
  arm64: KVM: add access handler for SPE system registers
  arm64: KVM/VHE: enable the use PMSCR_EL12 on VHE systems
  arm64: KVM: split debug save restore across vm/traps activation
  arm64: KVM/debug: drop pmscr_el1 and use sys_regs[PMSCR_EL1] in
    kvm_cpu_context
  arm64: KVM: add support to save/restore SPE profiling buffer controls
  arm64: KVM: enable conditional save/restore full SPE profiling buffer
    controls
  arm64: KVM/debug: trap all accesses to SPE controls at EL1
  KVM: arm64: add a new vcpu device control group for SPEv1
  KVM: arm64: enable SPE support

 .../devicetree/bindings/arm/spe-pmu.txt       |   5 +-
 Documentation/virtual/kvm/devices/vcpu.txt    |  28 +++
 arch/arm64/include/asm/kvm_host.h             |  19 +-
 arch/arm64/include/asm/kvm_hyp.h              |  26 ++-
 arch/arm64/include/uapi/asm/kvm.h             |   4 +
 arch/arm64/kvm/Kconfig                        |   7 +
 arch/arm64/kvm/Makefile                       |   1 +
 arch/arm64/kvm/guest.c                        |   9 +
 arch/arm64/kvm/hyp/debug-sr.c                 |  98 +++++++----
 arch/arm64/kvm/hyp/switch.c                   |  18 +-
 arch/arm64/kvm/reset.c                        |   3 +
 arch/arm64/kvm/sys_regs.c                     |  35 ++++
 include/kvm/arm_spe.h                         |  70 ++++++++
 include/uapi/linux/kvm.h                      |   1 +
 virt/kvm/arm/arm.c                            |   4 +
 virt/kvm/arm/spe.c                            | 163 ++++++++++++++++++
 16 files changed, 446 insertions(+), 45 deletions(-)
 create mode 100644 include/kvm/arm_spe.h
 create mode 100644 virt/kvm/arm/spe.c

-- 
2.17.1
