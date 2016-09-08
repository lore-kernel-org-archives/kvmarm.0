From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: [PATCH v3 0/8] ARM: KVM: Support for vgic-v3
Date: Thu,  8 Sep 2016 17:06:42 +0100
Message-ID: <1473350810-10857-1-git-send-email-vladimir.murzin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5144249B36
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Sep 2016 11:59:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id orOAZOL2FZXU for <kvmarm@lists.cs.columbia.edu>;
 Thu,  8 Sep 2016 11:59:37 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A9C14998D
 for <kvmarm@lists.cs.columbia.edu>; Thu,  8 Sep 2016 11:59:37 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

This is an attempt to make use vgic-v3 under arch/arm since
save-restore functionality got re-written in C and can be shared
between arm/arm64 like it has already been done for vgic-v2 and timer.

With this patches I'm able to get 32 core an AArch32 ARMv8 guest boot:

...
GICv3: CPU31: found redistributor 703 region 0:0x000000003ffd0000
CPU31: thread -1, cpu 3, socket 7, mpidr 80000703
Brought up 32 CPUs
SMP: Total of 32 processors activated (768.00 BogoMIPS).
CPU: All CPU(s) started in SVC mode.
...

Additionally, quite lightweight test based on Self IPI guest test[1]
has been run with up to 255 cpus.

[1] http://www.spinics.net/lists/kvm/msg128974.html

Changelog:

    v2 -> v3
       - rebased on v4.8-rc5
       - commit messages are reworked to be more precise and clear (I
         hope so)
       - MPIDR_HWID_BITMASK is used to discard Aff3 in
         MPIDR_AFFINITY_LEVEL macro
       - cast to u64 is used instead of abuse of GENMASK_ULL while
         building value for typer register
       - static keys are used to select GIC backend
       - config option to guard ITS code is moved to separate patch

    v1 -> v2
       - rebased on v4.8-rc2
       - introduced guard for ITS code

Thanks!

Vladimir Murzin (8):
  arm64: KVM: Use static keys for selecting the GIC backend
  arm64: KVM: Move GIC accessors to arch_gicv3.h
  arm64: KVM: Move vgic-v3 save/restore to virt/kvm/arm/hyp
  KVM: arm64: vgic-its: Introduce config option to guard ITS specific
    code
  KVM: arm: vgic: Support 64-bit data manipulation on 32-bit host
    systems
  ARM: Change MPIDR_AFFINITY_LEVEL to ignore Aff3
  ARM: Move system register accessors to asm/cp15.h
  ARM: KVM: Support vgic-v3

 arch/arm/include/asm/arch_gicv3.h                 |   91 +++++++++++++++++----
 arch/arm/include/asm/cp15.h                       |   15 ++++
 arch/arm/include/asm/cputype.h                    |    3 +-
 arch/arm/include/asm/kvm_asm.h                    |    3 +
 arch/arm/include/asm/kvm_host.h                   |   13 +++
 arch/arm/include/asm/kvm_hyp.h                    |   20 +----
 arch/arm/include/asm/virt.h                       |    8 ++
 arch/arm/include/uapi/asm/kvm.h                   |    7 ++
 arch/arm/kernel/vmlinux.lds.S                     |    6 ++
 arch/arm/kvm/Makefile                             |    2 +
 arch/arm/kvm/arm.c                                |   19 +++++
 arch/arm/kvm/coproc.c                             |   36 ++++++++
 arch/arm/kvm/hyp/Makefile                         |    1 +
 arch/arm/kvm/hyp/switch.c                         |   12 ++-
 arch/arm64/include/asm/arch_gicv3.h               |   13 +++
 arch/arm64/include/asm/kvm_host.h                 |   15 ++++
 arch/arm64/include/asm/kvm_hyp.h                  |    2 -
 arch/arm64/include/asm/virt.h                     |    7 ++
 arch/arm64/kernel/vmlinux.lds.S                   |    6 ++
 arch/arm64/kvm/Kconfig                            |    4 +-
 arch/arm64/kvm/hyp/Makefile                       |    2 +-
 arch/arm64/kvm/hyp/switch.c                       |   19 ++---
 include/kvm/arm_vgic.h                            |    8 --
 {arch/arm64/kvm => virt/kvm/arm}/hyp/vgic-v3-sr.c |   13 ---
 virt/kvm/arm/vgic/vgic-kvm-device.c               |   11 +--
 virt/kvm/arm/vgic/vgic-mmio-v3.c                  |    8 +-
 virt/kvm/arm/vgic/vgic-mmio.c                     |    2 -
 virt/kvm/arm/vgic/vgic-mmio.h                     |    4 +-
 virt/kvm/arm/vgic/vgic.h                          |   54 +-----------
 29 files changed, 265 insertions(+), 139 deletions(-)
 rename {arch/arm64/kvm => virt/kvm/arm}/hyp/vgic-v3-sr.c (96%)

-- 
1.7.9.5
