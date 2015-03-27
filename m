From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 0/5] arm64: Patching branches for fun and profit
Date: Fri, 27 Mar 2015 13:09:20 +0000
Message-ID: <1427461765-14462-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3788649FD7
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Mar 2015 09:02:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z+F4dzdYaWMk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Mar 2015 09:02:50 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 09A9049FC2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Mar 2015 09:02:49 -0400 (EDT)
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
Cc: "Jon Medhurst (Tixy)" <tixy@linaro.org>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <dave.martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The current alternative instruction framework is not kind to branches,
potentially leading to all kind of hacks in the code that uses
alternatives. This series expands it to deal with immediate branches
(for a start), and applies it to the VGIC world switch.

Patch #1 adds the required infrastructure to extract the immediate
from an instruction.

Patch #2 allows the use of an immediate b or bl instruction as an
alternative, computing the target branch as the instruction is being
patched in.

Patch #3 defines a feature framework that works exactly like the CPU
errata infrastructure (and shares a lot with it).

Patch #4 adds detection of the system register GICv3 CPU interface.

Patch #5 enables dynamic patching of the KVM code.

This has been tested with GICv3 on a FastModel.

* From v1:
- Fixed missing cpu_to_le32 when writing back the instruction
- Added Will's Acks.

* From v2:
- Replaced cpu_to_le32 with aarch_write_insn, which is the proper API
  and takes care of the potential pitfall if the text is read-only.
  Thanks to Tixy for suggesting this.

Marc Zyngier (5):
  arm64: insn: Add aarch64_insn_decode_immediate
  arm64: alternative: Allow immediate branch as alternative instruction
  arm64: Extract feature parsing code from cpu_errata.c
  arm64: alternative: Introduce feature for GICv3 CPU interface
  arm64: KVM: Switch vgic save/restore to alternative_insn

 arch/arm/include/asm/kvm_host.h     |  5 ---
 arch/arm64/include/asm/cpufeature.h | 23 ++++++++++-
 arch/arm64/include/asm/insn.h       |  1 +
 arch/arm64/include/asm/kvm_host.h   | 23 -----------
 arch/arm64/kernel/Makefile          |  2 +-
 arch/arm64/kernel/alternative.c     | 55 ++++++++++++++++++++++++-
 arch/arm64/kernel/asm-offsets.c     |  1 -
 arch/arm64/kernel/cpu_errata.c      | 36 ++---------------
 arch/arm64/kernel/cpufeature.c      | 63 +++++++++++++++++++++++++++++
 arch/arm64/kernel/cpuinfo.c         |  1 +
 arch/arm64/kernel/insn.c            | 81 +++++++++++++++++++++++++++++--------
 arch/arm64/kvm/hyp.S                | 18 ++-------
 virt/kvm/arm/vgic.c                 |  3 --
 13 files changed, 214 insertions(+), 98 deletions(-)
 create mode 100644 arch/arm64/kernel/cpufeature.c

-- 
2.1.4
