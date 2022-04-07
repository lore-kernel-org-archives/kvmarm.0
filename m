Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9404C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  7 Apr 2022 16:23:39 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C644F4A119;
	Thu,  7 Apr 2022 12:23:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EbKplHbPOLYN; Thu,  7 Apr 2022 12:23:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B5C449F4A;
	Thu,  7 Apr 2022 12:23:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 237C549EEF
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 12:23:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oAyB4OZJ2A2V for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Apr 2022 12:23:34 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CF51B40CDE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Apr 2022 12:23:34 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2E2B912FC;
 Thu,  7 Apr 2022 09:23:34 -0700 (PDT)
Received: from e121798.cable.virginm.net (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id CA8823F73B;
 Thu,  7 Apr 2022 09:23:32 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org, james.morse@arm.com,
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu, mark.rutland@arm.com
Subject: [PATCH 0/5] arm64: Treat ESR_ELx as a 64-bit register
Date: Thu,  7 Apr 2022 17:23:22 +0100
Message-Id: <20220407162327.396183-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
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

ESR_EL{1,2} were originally 32-bit register, then were extended to 64-bit
with the upper 32 bits RES0, and in ARM DDI 0487H.a the FEAT_LS64 feature
was added which makes use of the upper bits. This series aims to teach
Linux to treat it consistently as a 64-bit register with the goal of making
it easier to add support in the future for features that make use of the
upper 32 bits.

Patches #1 ("arm64: Make ESR_ELx_xVC_IMM_MASK compatible with assembly")
and #2 ("arm64: compat: Do not treat syscall number as ESR_ELx for a bad
syscall") are fixes for some minor issues which I found while working on
changing ESR_ELx to 64-bit.

Patches #3 ("arm64: Treat ESR_ELx as a 64bit register") and #4 ("KVM:
arm64: Treat ESR_EL2 as a 64-bit register") are where the change is
implemented. I chose to make the KVM a separate patch because KVM prefers
u64 for the registers.

And in patch #5 ("KVM: arm64: uapi: Add kvm_debug_exit_arch.hsr_high") I
add a new field to the user API struct kvm_debug_exit_arch that represents
the higher 32 bits (details in the patch).

Tested by running ltp and kvm-unit-tests on a rockpro64.

Alexandru Elisei (5):
  arm64: Make ESR_ELx_xVC_IMM_MASK compatible with assembly
  arm64: compat: Do not treat syscall number as ESR_ELx for a bad
    syscall
  arm64: Treat ESR_ELx as a 64bit register
  KVM: arm64: Treat ESR_EL2 as a 64-bit register
  KVM: arm64: uapi: Add kvm_debug_exit_arch.hsr_high

 arch/arm64/include/asm/debug-monitors.h |  4 +-
 arch/arm64/include/asm/esr.h            |  8 +--
 arch/arm64/include/asm/exception.h      | 28 +++++-----
 arch/arm64/include/asm/kvm_emulate.h    |  6 +--
 arch/arm64/include/asm/kvm_host.h       |  2 +-
 arch/arm64/include/asm/kvm_ras.h        |  2 +-
 arch/arm64/include/asm/system_misc.h    |  4 +-
 arch/arm64/include/asm/traps.h          | 12 ++---
 arch/arm64/include/uapi/asm/kvm.h       |  1 +
 arch/arm64/kernel/debug-monitors.c      | 12 ++---
 arch/arm64/kernel/entry-common.c        |  6 +--
 arch/arm64/kernel/fpsimd.c              |  6 +--
 arch/arm64/kernel/hw_breakpoint.c       |  4 +-
 arch/arm64/kernel/kgdb.c                |  6 +--
 arch/arm64/kernel/probes/kprobes.c      |  4 +-
 arch/arm64/kernel/probes/uprobes.c      |  4 +-
 arch/arm64/kernel/sys_compat.c          |  2 +-
 arch/arm64/kernel/traps.c               | 66 +++++++++++------------
 arch/arm64/kvm/handle_exit.c            | 15 +++---
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/sys_regs.c      |  2 +-
 arch/arm64/kvm/hyp/vgic-v3-sr.c         |  4 +-
 arch/arm64/kvm/inject_fault.c           |  4 +-
 arch/arm64/kvm/sys_regs.c               |  4 +-
 arch/arm64/mm/fault.c                   | 70 ++++++++++++-------------
 25 files changed, 140 insertions(+), 138 deletions(-)

-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
