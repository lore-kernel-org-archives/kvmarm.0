From: James Morse <james.morse@arm.com>
Subject: [RESEND PATCH v4 0/9] SError rework (- RAS & IESB for firmware first
 support)
Date: Thu,  2 Nov 2017 12:12:33 +0000
Message-ID: <20171102121242.8925-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C31249D29
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Nov 2017 08:12:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iNvdvmCw-aL2 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Nov 2017 08:12:53 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6AAA40795
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Nov 2017 08:12:53 -0400 (EDT)
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
Cc: Julien Thierry <julien.thierry@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, wangxiongfeng2@huawei.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hello,

This is repost of the SError Rework bits of the bigger series [0].
None of these patches have changed since v3.

Thanks,

James


[0] https://www.spinics.net/lists/arm-kernel/msg612870.html


James Morse (8):
  arm64: explicitly mask all exceptions
  arm64: introduce an order for exceptions
  arm64: Move the async/fiq helpers to explicitly set process context
    flags
  arm64: Mask all exceptions during kernel_exit
  arm64: entry.S: Remove disable_dbg
  arm64: entry.S: convert el1_sync
  arm64: entry.S convert el0_sync
  arm64: entry.S: convert elX_irq

Xie XiuQi (1):
  arm64: entry.S: move SError handling into a C function for future
    expansion

 arch/arm64/Kconfig                 |  2 +-
 arch/arm64/include/asm/assembler.h | 46 ++++++++++++--------
 arch/arm64/include/asm/daifflags.h | 72 +++++++++++++++++++++++++++++++
 arch/arm64/include/asm/irqflags.h  | 40 ++++++------------
 arch/arm64/kernel/debug-monitors.c |  5 ++-
 arch/arm64/kernel/entry.S          | 86 ++++++++++++++++++++++----------------
 arch/arm64/kernel/hibernate.c      |  5 ++-
 arch/arm64/kernel/machine_kexec.c  |  4 +-
 arch/arm64/kernel/setup.c          |  8 ++--
 arch/arm64/kernel/signal.c         |  8 +++-
 arch/arm64/kernel/smp.c            | 12 ++----
 arch/arm64/kernel/suspend.c        |  7 ++--
 arch/arm64/kernel/traps.c          | 16 ++++++-
 arch/arm64/mm/proc.S               |  9 ++--
 14 files changed, 211 insertions(+), 109 deletions(-)
 create mode 100644 arch/arm64/include/asm/daifflags.h

-- 
2.15.0.rc2
