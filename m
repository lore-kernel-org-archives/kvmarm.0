Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9C33C00140
	for <kvmarm@archiver.kernel.org>; Mon, 15 Aug 2022 22:58:12 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6004F4D869;
	Mon, 15 Aug 2022 18:58:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PyFeujdK2Rmf; Mon, 15 Aug 2022 18:58:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 28F704D873;
	Mon, 15 Aug 2022 18:58:11 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 86A3F4D870
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 18:58:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hapvRe5aTcVp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Aug 2022 18:58:08 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 302914D869
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Aug 2022 18:58:08 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id B81D5B81240;
 Mon, 15 Aug 2022 22:58:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54440C433C1;
 Mon, 15 Aug 2022 22:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1660604285;
 bh=/1EIRdCVKSNgeXbA7Gv2MZmhXL4LS0GaJTCyyJXfCXs=;
 h=From:To:Cc:Subject:Date:From;
 b=OYiFgILzQ8wy6Sn14CBc92Bi+aTkJ8YF2lXd38GXusl/T1u7f2KyU/LcBmk1N1NK6
 gn6JO0dnF0jnjkLdeHeBlLcMxKT4e7YbxmXYUbiOcgcCJDaH3c/Ub09K7neZav62rx
 1DkYPz2vaSybMDCdbo+VEUKf6pfherVPUNLSEQ5PgVaFgfTp4vz2+zkAPcYeUxfW/z
 JdgpYhZBpXZGc1p1kmzfLdZ1kfjdUQ97jgArbAko2LA545jNI+QkvyL2vEX0PqZFB2
 6I93BwVBcSqkvH0wi89hbQU5LqKswjyYt1Vmta7ER1lE90+f++7fnajbewjXDyw4Cg
 6FOCDTeUkZXBw==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v3 0/7] arm64/sve: Clean up KVM integration and optimise
 syscalls
Date: Mon, 15 Aug 2022 23:55:22 +0100
Message-Id: <20220815225529.930315-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3946; i=broonie@kernel.org;
 h=from:subject; bh=/1EIRdCVKSNgeXbA7Gv2MZmhXL4LS0GaJTCyyJXfCXs=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBi+s7ZKDHUz7u/24O0RUMFVTeL7WYmDUMTNEOqkSwt
 986efQqJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYvrO2QAKCRAk1otyXVSH0AhQB/
 sErzRcpebSpRPbvaCNbjL71e5MzOvGVi5dxoeEbGIJS1CcoaONqQ/5Yp30xZigVaFWiJJlvC0fNBQ6
 Yib8bg+jDy7JBGqkBQGMo04is+bkqadXLhoozQth9NAVJiMHqMRMSijwUo9aj3RcF5pP8jae6yQFaV
 m8mDGvZyCLTL+3YOK3SevJRxRjhvvdLrqsbGKtZNKnV4Nylkb+QocbDq2BNxm6vqmsgvtY8ecXvQ7M
 GWH0rEZPcWmOAGir7H6QFKoA7S0Cs+9n/p7jwl27bpmxmKTPfpjv49S+sOQJacayBDV8l2LdKMw4hb
 HKnno5rZ+gdIqpuhvfxjbnVQMr4BUb
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Marc Zyngier <maz@kernel.org>, Zhang Lei <zhang.lei@jp.fujitsu.com>,
 Mark Brown <broonie@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

This patch series attempts to clarify the tracking of which set of
floating point registers we save on systems supporting SVE, particularly
with reference to KVM, and then uses the results of this clarification
to improve the performance of simple syscalls where we return directly
to userspace in cases where userspace is using SVE.

At present we track which register state is active by using the TIF_SVE
flag for the current task which also controls if userspace is able to
use SVE, this is reasonably straightforward if limiting but for KVM it
gets a bit hairy since we may have guest state loaded in registers. This
results in KVM modifying TIF_SVE for the VMM task while the guest is
running which doesn't entirely help make things easy to follow. To help
make things clearer the series changes things so that in addition to
TIF_SVE we explicitly track both the type of registers that are
currently saved in the task struct and the type of registers that we
should save when we do so. TIF_SVE then solely controls if userspace
can use SVE without trapping, it has no function for KVM guests and we
can remove the code for managing it from KVM.

The refactoring to add the separate tracking is initially done by adding
the new state together with checks that the state corresponds to
expectations when we look at it before subsequent patches make use of
the separated state, the goal being to both split out the more repetitive
bits of tha change and make it easier to debug any problems that might
arise.

With the state tracked separately we then start to optimise the
performance of syscalls when the process is using SVE. Currently every
syscall disables SVE for userspace which means that we need to trap to
EL1 again on the next SVE instruction, flush the SVE registers, and
reenable SVE for EL0, creating overhead for tasks that mix SVE and
syscalls. We build on the above refactoring to eliminate this overhead
for simple syscalls which return directly to userspace by keeping SVE
enabled unless we need to reload the state from memory, meaning that if
syscalls do not block we avoid the overhead of trapping to EL1 again on
next use of SVE.

v3:
 - Rebase onto my series "arm64/sme: SME related fixes" since there is a
   direct dependency on the signal fix and testing is much easier with
   the bug fixes rolled in.
 - s/type/fp_type/ in struct fpsimd_last_state_struct.
 - Add comment about the V register storage being ignored when data is
   stored in SVE format.
 - Move dropping of special casing for FPSIMD register state in SME
   into a separate patch later in the series.
 - Simplify logic in task_fpsimd_load().
 - Remove support for leaving the SVE state not shared with FPSIMD
   untouched, keep the unconditional flush.
v2:
 - Rebase onto v5.19-rc3.
 - Don't warn when restoring streaming mode SVE without TIF_SVE.

Mark Brown (7):
  KVM: arm64: Discard any SVE state when entering KVM guests
  arm64/fpsimd: Track the saved FPSIMD state type separately to TIF_SVE
  arm64/fpsimd: Have KVM explicitly say which FP registers to save
  arm64/fpsimd: Stop using TIF_SVE to manage register saving in KVM
  arm64/fpsimd: Load FP state based on recorded data type
  arm64/fpsimd: SME no longer requires SVE register state
  arm64/sve: Leave SVE enabled on syscall if we don't context switch

 arch/arm64/include/asm/fpsimd.h    |   4 +-
 arch/arm64/include/asm/kvm_host.h  |   1 +
 arch/arm64/include/asm/processor.h |   7 ++
 arch/arm64/kernel/fpsimd.c         | 137 +++++++++++++++++++++++------
 arch/arm64/kernel/process.c        |   2 +
 arch/arm64/kernel/ptrace.c         |   5 +-
 arch/arm64/kernel/signal.c         |   7 +-
 arch/arm64/kernel/syscall.c        |  19 ++--
 arch/arm64/kvm/fpsimd.c            |  16 ++--
 9 files changed, 148 insertions(+), 50 deletions(-)


base-commit: bb357a5e4232401e587da41329d8de5b42acd10e
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
