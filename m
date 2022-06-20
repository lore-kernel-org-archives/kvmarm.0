Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C17DC433EF
	for <kvmarm@archiver.kernel.org>; Mon, 20 Jun 2022 12:42:19 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 00B194B4E3;
	Mon, 20 Jun 2022 08:42:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id N-X2AWttq+hM; Mon, 20 Jun 2022 08:42:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B72764B2B4;
	Mon, 20 Jun 2022 08:42:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15CE44B26C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 08:42:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dT18USLyQLXz for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Jun 2022 08:42:14 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A91914B253
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Jun 2022 08:42:14 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 6BF56B81145;
 Mon, 20 Jun 2022 12:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7082C3411B;
 Mon, 20 Jun 2022 12:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1655728932;
 bh=XzH1bHIjCEQTsR3/9eI6H7Suf2gm7bYmxSmt8xZueL0=;
 h=From:To:Cc:Subject:Date:From;
 b=sdGANufdTnKlxley5Jz3UDZCCoo/CjR6FTrB4TPOgozj4FVX045gd0ZegjaUCqbPk
 a2Hhp6kqHb55gE6T+sTcCn1tadio5fhxJoBSPwTojb7L+X8fA/ietCJ+rss5rYmLVN
 nsJplyqZS86meFflhLqg4tc9HxY9/rbF+xb31rznCqREy+Io+ZT2CmyuJPf4gLzavL
 mUK0cZCO82NGEwBr785aEkJWHlhcAUs7OTst/7F0tK1yANMfd27l/7F3P049ddLHjX
 kES+mSizf8W25xxbZrNKllQlhviueSPAkzfuW3YqGNqLzGHOnFzMkjB9ZUdnNlYpgZ
 HXkPwNvJMrqYw==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v2 0/7] arm64/sve: Clean up KVM integration and optimise
 syscalls
Date: Mon, 20 Jun 2022 13:41:51 +0100
Message-Id: <20220620124158.482039-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3608; h=from:subject;
 bh=XzH1bHIjCEQTsR3/9eI6H7Suf2gm7bYmxSmt8xZueL0=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBisGsNIgLKqM2gYzZ+CD7ZYH1hEnzUYnBRIT35ywmR
 vNCZd26JATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYrBrDQAKCRAk1otyXVSH0LPDB/
 0YJYU6N0u9Bti/TuAAvnm2GZksQWNh4rBVradci05uxJbIseuoYCt+/fwHbBZqV1pni9cIUKLxuaai
 3Kg5OTKWyX1Il8mltaXBQD8KWV8TYnBU0BVyl/T65JyXHeoiqJwEb8GZrjvha3O9Y0onegDr8w9g+w
 q0XrGYG9bBwpi8kZF/ulhLVXXLAwDcyrVPvQ5FvwxJXn2Y9kCzglYtBa9j+tCbSay96HoQ+QyMuryr
 z1bmTpu49NnUVxTCZHMEcagKADs8J9aOMW5s+yh0x6vn6mSr+3IKYqAEpozOd5nvYK9b05d4sNu9mu
 aSRYc7xbCJAPhLupa1eLjsxWbYN6fs
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
for simple syscalls which return directly to userspace by:

 - Keeping SVE enabled.
 - Not flushing the SVE state.

The removal of flushing is within our currently documented ABI but is a
change in our effective ABI so a sysctl is provided to revert to current
behaviour in case of problems or to allow testing of userspace.  If we
don't want to do this I think we should tighten our ABI documentation,
previously Catalin had indicated that he didn't want to tighten it.

v2:
 - Rebase onto v5.19-rc3.
 - Don't warn when restoring streaming mode SVE without TIF_SVE.

Mark Brown (7):
  KVM: arm64: Discard any SVE state when entering KVM guests
  arm64/fpsimd: Track the saved FPSIMD state type separately to TIF_SVE
  arm64/fpsimd: Have KVM explicitly say which FP registers to save
  arm64/fpsimd: Stop using TIF_SVE to manage register saving in KVM
  arm64/fpsimd: Load FP state based on recorded data type
  arm64/sve: Leave SVE enabled on syscall if we don't context switch
  arm64/sve: Don't zero non-FPSIMD register state on syscall by default

 arch/arm64/include/asm/fpsimd.h    |   4 +-
 arch/arm64/include/asm/kvm_host.h  |   1 +
 arch/arm64/include/asm/processor.h |   7 ++
 arch/arm64/kernel/fpsimd.c         | 131 ++++++++++++++++++++++++-----
 arch/arm64/kernel/process.c        |   2 +
 arch/arm64/kernel/ptrace.c         |   6 +-
 arch/arm64/kernel/signal.c         |   3 +
 arch/arm64/kernel/syscall.c        |  53 +++++++++---
 arch/arm64/kvm/fpsimd.c            |  16 ++--
 9 files changed, 179 insertions(+), 44 deletions(-)


base-commit: a111daf0c53ae91e71fd2bfe7497862d14132e3e
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
