From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 0/3] arm64: alternative: add auto-nop support
Date: Wed,  7 Sep 2016 11:07:07 +0100
Message-ID: <1473242830-26246-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DD33C49B40
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2016 05:59:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ETw0fWpEJWkp for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Sep 2016 05:59:05 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B71D04998D
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Sep 2016 05:59:05 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, will.deacon@arm.com, dave.martin@arm.com, catalin.marinas@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

In some cases where we use pairs of alternative sequences, only one sequence
does valuable work, and the other consists solely of NOPs. We have to manually
ensure that both sequences are the same size, and some NOP sleds are partially
contained unddef ifdefs.

Maintaining this balance is tedious, and the presence of these makes the code
more painful to read than is necessary. These patches add helpers to handle
these cases automatically, making the code more maintainable, and easier to
read.

Thanks,
Mark.

Mark Rutland (3):
  arm64: alternative: add auto-nop infrastructure
  arm64: use alternative auto-nop
  arm64/kvm: use alternative auto-nop

 arch/arm64/include/asm/alternative.h | 71 +++++++++++++++++++++++++++---------
 arch/arm64/include/asm/kvm_mmu.h     | 10 ++---
 arch/arm64/kernel/entry.S            | 10 +----
 arch/arm64/kvm/hyp.S                 |  6 +--
 arch/arm64/lib/copy_page.S           | 13 ++-----
 arch/arm64/mm/proc.S                 |  9 +----
 6 files changed, 66 insertions(+), 53 deletions(-)

-- 
1.9.1
