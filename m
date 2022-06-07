Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45748C43334
	for <kvmarm@archiver.kernel.org>; Tue,  7 Jun 2022 13:23:32 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CADEF4B2E6;
	Tue,  7 Jun 2022 09:23:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YOkQg0oiVpmc; Tue,  7 Jun 2022 09:23:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 82D144B303;
	Tue,  7 Jun 2022 09:23:30 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F36044B2E6
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 09:23:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8E-FPZNciY4X for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jun 2022 09:23:27 -0400 (EDT)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A081B4B2CC
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jun 2022 09:23:27 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id DE557B81C97;
 Tue,  7 Jun 2022 13:23:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8860BC385A5;
 Tue,  7 Jun 2022 13:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654608204;
 bh=mDDgwCEqh8ziAAvLFOM+TkEO9LiwTF1qN4IOx91PehA=;
 h=From:To:Cc:Subject:Date:From;
 b=R+KE1+Je9/lDpMQzDO7Q9NKxBQ+FODkP9EZ8yrEULAEflzDhFoGdkt956j0OuWXdy
 WAZ48/ytiTuqMdhlyBfCjlV8dyo/FQybo9GJJLN0QMuo/0A/SwdjbkNJyyGE56Yyu+
 Af3O8VuCn042lxW4Uqz/kJARP+kZu4MrCsoYM1EMiZrY/A+HQ4yiHMCZBuGA/5O4Hv
 dL4ZGxZiIwx8+GKK8MuoIaH8aC7MuV/hODR11JrvrJObUil90g24QiPfZpBZJhXqNo
 e8bgrftmeVT0BrqB6xy+YBnoLNXeffwGQlvhVxFYTpwwtB7WdUncip8RwKIQdGUxqH
 w3bmrsZ/EBr4A==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v1 0/7] arm64/sve: Clean up KVM integration and optimise
 syscalls
Date: Tue,  7 Jun 2022 14:17:28 +0100
Message-Id: <20220607131735.1300726-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3507; h=from:subject;
 bh=mDDgwCEqh8ziAAvLFOM+TkEO9LiwTF1qN4IOx91PehA=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBin0/nHdZwQmTT2Puff1EJCTrKkDZucRYznmA1RzSB
 LEUcHByJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYp9P5wAKCRAk1otyXVSH0LQTB/
 9fodjpRxbUobuBa0MTKdpFWs+RoVkcbiRsd8eiBfOCfrQpmriio/x09iN536SDKm+4hT2SBCE2EjZg
 UCpL65Oe4eCKREA0BX+XIUIRuErK65I04GvdZQTsj4wyqzqFafqGDJzj5FLbX1S8CL0ttBTXm+yet6
 sUq4A9M+vc1MfaDUqgwx2tI/7436msW7IuxJjJ3yzzmc/Ly/cD7lnevlpFDdm0vdRTup8wsyqRQM3/
 lxrx8Gai7KZ9ctMssEPNn/V1Lz93ykE5eILYz7j23qY2YZRKJjg2tY3uYWJxbFBWUCzK1epMjmIq0m
 eSWRhYkq+W8q6yQ19VRp0m5/bTKuOZ
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
 arch/arm64/kernel/fpsimd.c         | 136 +++++++++++++++++++++++------
 arch/arm64/kernel/process.c        |   2 +
 arch/arm64/kernel/ptrace.c         |   6 +-
 arch/arm64/kernel/signal.c         |   3 +
 arch/arm64/kernel/syscall.c        |  53 ++++++++---
 arch/arm64/kvm/fpsimd.c            |  16 ++--
 9 files changed, 180 insertions(+), 48 deletions(-)


base-commit: f2906aa863381afb0015a9eb7fefad885d4e5a56
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
