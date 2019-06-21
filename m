Return-Path: <SRS0=LUtr=UU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3698BC48BE3
	for <kvmarm@archiver.kernel.org>; Fri, 21 Jun 2019 09:39:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BB18E20673
	for <kvmarm@archiver.kernel.org>; Fri, 21 Jun 2019 09:39:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BB18E20673
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF65C4A369;
	Fri, 21 Jun 2019 05:39:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EwG-uHUttSeY; Fri, 21 Jun 2019 05:39:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B9944A389;
	Fri, 21 Jun 2019 05:39:16 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CE6574A379
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jun 2019 05:39:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pBD8p-Xs15AU for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Jun 2019 05:39:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EEBC4A319
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jun 2019 05:39:13 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7EC4A1478;
 Fri, 21 Jun 2019 02:39:12 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2AA7E3F246;
 Fri, 21 Jun 2019 02:39:11 -0700 (PDT)
From: Marc Zyngier <marc.zyngier@arm.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 00/59] KVM: arm64: ARMv8.3 Nested Virtualization support
Date: Fri, 21 Jun 2019 10:37:44 +0100
Message-Id: <20190621093843.220980-1-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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

I've taken over the maintenance of this series originally written by
Jintack and Christoffer. Since then, the series has been substantially
reworked, new features (and most probably bugs) have been added, and
the whole thing rebased multiple times. If anything breaks, please
blame me, and nobody else.

As you can tell, this is quite big. It is also remarkably incomplete
(we're missing many critical bits for fully emulate EL2), but the idea
is to start merging things early in order to reduce the maintenance
headache. What we want to achieve is that with NV disabled, there is
no performance overhead and no regression. The only thing I intend to
merge ASAP is the first patch in the series, because it should have
zero effect and is a reasonable cleanup.

The series is roughly divided in 4 parts: exception handling, memory
virtualization, interrupts and timers. There are of course some
dependencies, but you'll hopefully get the gist of it.

For the most courageous of you, I've put out a branch[1] containing this
and a bit more. Of course, you'll need some userspace. Andre maintains
a hacked version of kvmtool[1] that takes a --nested option, allowing
the guest to be started at EL2. You can run the whole stack in the
Foundation model. Don't be in a hurry ;-).

[1] git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/nv-wip-5.2-rc5
[2] git://linux-arm.org/kvmtool.git nv/nv-wip-5.2-rc5

Andre Przywara (4):
  KVM: arm64: nv: Handle virtual EL2 registers in
    vcpu_read/write_sys_reg()
  KVM: arm64: nv: Save/Restore vEL2 sysregs
  KVM: arm64: nv: Handle traps for timer _EL02 and _EL2 sysregs
    accessors
  KVM: arm64: nv: vgic: Allow userland to set VGIC maintenance IRQ

Christoffer Dall (16):
  KVM: arm64: nv: Introduce nested virtualization VCPU feature
  KVM: arm64: nv: Reset VCPU to EL2 registers if VCPU nested virt is set
  KVM: arm64: nv: Allow userspace to set PSR_MODE_EL2x
  KVM: arm64: nv: Add nested virt VCPU primitives for vEL2 VCPU state
  KVM: arm64: nv: Handle trapped ERET from virtual EL2
  KVM: arm64: nv: Emulate PSTATE.M for a guest hypervisor
  KVM: arm64: nv: Trap EL1 VM register accesses in virtual EL2
  KVM: arm64: nv: Only toggle cache for virtual EL2 when SCTLR_EL2
    changes
  KVM: arm/arm64: nv: Support multiple nested stage 2 mmu structures
  KVM: arm64: nv: Implement nested Stage-2 page table walk logic
  KVM: arm64: nv: Handle shadow stage 2 page faults
  KVM: arm64: nv: Unmap/flush shadow stage 2 page tables
  KVM: arm64: nv: arch_timer: Support hyp timer emulation
  KVM: arm64: nv: vgic-v3: Take cpu_if pointer directly instead of vcpu
  KVM: arm64: nv: vgic: Emulate the HW bit in software
  KVM: arm64: nv: Add nested GICv3 tracepoints

Dave Martin (1):
  KVM: arm64: Migrate _elx sysreg accessors to msr_s/mrs_s

Jintack Lim (21):
  arm64: Add ARM64_HAS_NESTED_VIRT cpufeature
  KVM: arm64: nv: Add EL2 system registers to vcpu context
  KVM: arm64: nv: Support virtual EL2 exceptions
  KVM: arm64: nv: Inject HVC exceptions to the virtual EL2
  KVM: arm64: nv: Trap SPSR_EL1, ELR_EL1 and VBAR_EL1 from virtual EL2
  KVM: arm64: nv: Trap CPACR_EL1 access in virtual EL2
  KVM: arm64: nv: Set a handler for the system instruction traps
  KVM: arm64: nv: Handle PSCI call via smc from the guest
  KVM: arm64: nv: Respect virtual HCR_EL2.TWX setting
  KVM: arm64: nv: Respect virtual CPTR_EL2.TFP setting
  KVM: arm64: nv: Respect the virtual HCR_EL2.NV bit setting
  KVM: arm64: nv: Respect virtual HCR_EL2.TVM and TRVM settings
  KVM: arm64: nv: Respect the virtual HCR_EL2.NV1 bit setting
  KVM: arm64: nv: Emulate EL12 register accesses from the virtual EL2
  KVM: arm64: nv: Configure HCR_EL2 for nested virtualization
  KVM: arm64: nv: Pretend we only support larger-than-host page sizes
  KVM: arm64: nv: Introduce sys_reg_desc.forward_trap
  KVM: arm64: nv: Rework the system instruction emulation framework
  KVM: arm64: nv: Trap and emulate AT instructions from virtual EL2
  KVM: arm64: nv: Trap and emulate TLBI instructions from virtual EL2
  KVM: arm64: nv: Nested GICv3 Support

Marc Zyngier (17):
  KVM: arm64: Move __load_guest_stage2 to kvm_mmu.h
  KVM: arm64: nv: Reset VMPIDR_EL2 and VPIDR_EL2 to sane values
  KVM: arm64: nv: Handle SPSR_EL2 specially
  KVM: arm64: nv: Refactor vcpu_{read,write}_sys_reg
  KVM: arm64: nv: Don't expose SVE to nested guests
  KVM: arm64: nv: Hide RAS from nested guests
  KVM: arm/arm64: nv: Factor out stage 2 page table data from struct kvm
  KVM: arm64: nv: Move last_vcpu_ran to be per s2 mmu
  KVM: arm64: nv: Don't always start an S2 MMU search from the beginning
  KVM: arm64: nv: Propagate CNTVOFF_EL2 to the virtual EL1 timer
  KVM: arm64: nv: Load timer before the GIC
  KVM: arm64: nv: Implement maintenance interrupt forwarding
  arm64: KVM: nv: Add handling of EL2-specific timer registers
  arm64: KVM: nv: Honor SCTLR_EL2.SPAN on entering vEL2
  arm64: KVM: nv: Handle SCTLR_EL2 RES0/RES1 bits
  arm64: KVM: nv: Restrict S2 RD/WR permissions to match the guest's
  arm64: KVM: nv: Allow userspace to request KVM_ARM_VCPU_NESTED_VIRT

 .../admin-guide/kernel-parameters.txt         |    4 +
 .../virtual/kvm/devices/arm-vgic-v3.txt       |    9 +
 arch/arm/include/asm/kvm_asm.h                |    5 +-
 arch/arm/include/asm/kvm_emulate.h            |    3 +
 arch/arm/include/asm/kvm_host.h               |   31 +-
 arch/arm/include/asm/kvm_hyp.h                |   25 +-
 arch/arm/include/asm/kvm_mmu.h                |   83 +-
 arch/arm/include/asm/kvm_nested.h             |    9 +
 arch/arm/include/uapi/asm/kvm.h               |    1 +
 arch/arm/kvm/hyp/switch.c                     |   11 +-
 arch/arm/kvm/hyp/tlb.c                        |   13 +-
 arch/arm64/include/asm/cpucaps.h              |    3 +-
 arch/arm64/include/asm/esr.h                  |    4 +-
 arch/arm64/include/asm/kvm_arm.h              |   28 +-
 arch/arm64/include/asm/kvm_asm.h              |    9 +-
 arch/arm64/include/asm/kvm_coproc.h           |    2 +-
 arch/arm64/include/asm/kvm_emulate.h          |  157 +-
 arch/arm64/include/asm/kvm_host.h             |  105 +-
 arch/arm64/include/asm/kvm_hyp.h              |   82 +-
 arch/arm64/include/asm/kvm_mmu.h              |   62 +-
 arch/arm64/include/asm/kvm_nested.h           |   68 +
 arch/arm64/include/asm/sysreg.h               |  143 +-
 arch/arm64/include/uapi/asm/kvm.h             |    2 +
 arch/arm64/kernel/cpufeature.c                |   26 +
 arch/arm64/kvm/Makefile                       |    4 +
 arch/arm64/kvm/emulate-nested.c               |  223 +++
 arch/arm64/kvm/guest.c                        |    6 +
 arch/arm64/kvm/handle_exit.c                  |   76 +-
 arch/arm64/kvm/hyp/Makefile                   |    1 +
 arch/arm64/kvm/hyp/at.c                       |  217 +++
 arch/arm64/kvm/hyp/switch.c                   |   86 +-
 arch/arm64/kvm/hyp/sysreg-sr.c                |  267 ++-
 arch/arm64/kvm/hyp/tlb.c                      |  129 +-
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c      |    2 +-
 arch/arm64/kvm/inject_fault.c                 |   12 -
 arch/arm64/kvm/nested.c                       |  551 +++++++
 arch/arm64/kvm/regmap.c                       |    4 +-
 arch/arm64/kvm/reset.c                        |    7 +
 arch/arm64/kvm/sys_regs.c                     | 1460 +++++++++++++++--
 arch/arm64/kvm/sys_regs.h                     |    6 +
 arch/arm64/kvm/trace.h                        |   58 +-
 include/kvm/arm_arch_timer.h                  |    6 +
 include/kvm/arm_vgic.h                        |   28 +-
 virt/kvm/arm/arch_timer.c                     |  158 +-
 virt/kvm/arm/arm.c                            |   62 +-
 virt/kvm/arm/hyp/vgic-v3-sr.c                 |   35 +-
 virt/kvm/arm/mmio.c                           |   12 +-
 virt/kvm/arm/mmu.c                            |  445 +++--
 virt/kvm/arm/trace.h                          |    6 +-
 virt/kvm/arm/vgic/vgic-init.c                 |   30 +
 virt/kvm/arm/vgic/vgic-kvm-device.c           |   22 +
 virt/kvm/arm/vgic/vgic-nested-trace.h         |  137 ++
 virt/kvm/arm/vgic/vgic-v2.c                   |   10 +-
 virt/kvm/arm/vgic/vgic-v3-nested.c            |  236 +++
 virt/kvm/arm/vgic/vgic-v3.c                   |   40 +-
 virt/kvm/arm/vgic/vgic.c                      |   74 +-
 56 files changed, 4683 insertions(+), 612 deletions(-)
 create mode 100644 arch/arm/include/asm/kvm_nested.h
 create mode 100644 arch/arm64/include/asm/kvm_nested.h
 create mode 100644 arch/arm64/kvm/emulate-nested.c
 create mode 100644 arch/arm64/kvm/hyp/at.c
 create mode 100644 arch/arm64/kvm/nested.c
 create mode 100644 virt/kvm/arm/vgic/vgic-nested-trace.h
 create mode 100644 virt/kvm/arm/vgic/vgic-v3-nested.c

-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
