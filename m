From: Mark Rutland <mark.rutland@arm.com>
Subject: [RFC PATCH 00/13] arm64/kvm: use common sysreg definitions
Date: Tue, 31 Jan 2017 18:05:38 +0000
Message-ID: <1485885951-2747-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 306D5405DA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:06:45 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AHiY-OJl89ta for <kvmarm@lists.cs.columbia.edu>;
 Tue, 31 Jan 2017 13:06:42 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3E0940194
 for <kvmarm@lists.cs.columbia.edu>; Tue, 31 Jan 2017 13:06:42 -0500 (EST)
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
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Whenever we add new functionality involving new system registers, we need to
add sys_reg() definitions so that we can access the registers regardless of
whether the toolchain can assemble them. At the same time, we have to add
duplicate definitions of the register encodings to KVM's sysreg tables, so that
we can handle any configurable traps. This redundancy is unfortunate, and
defining the encodings directly in the sysreg tables can make those tables
difficult to read.

This series attempts to address both of these issues by allowing us to use
common sys_reg() mnemonics in <asm/sysreg.h> to initialise KVM's sysreg tables.
To that end, this series tries to make <asm/sysreg.h> the canonical location
for common sysreg encodings.

Largely, I've only attacked the AArch64-native SYS encodings required by KVM
today, though for the debug and perfmon groups it was easier to take the whole
group from the ARM ARM than to filter them to only what KVM needed. I've
ignored CP{15,14} registers for now, but these could be encoded similarly.

To verify that I haven't accidentally broken KVM, I've diffed sys_regs.o and
sys_regs_generic_v8.o on a section-by-section basis before and after the series
is applied. The .text, .data, and .rodata sections (and most others) are
identical. The __bug_table section, and some .debug* sections differ, and this
appears to be due to line numbers changing due to removed lines.

One thing I wasn't sure how to address was banks of registers such as
PMEVCNTR<n>_EL0. We currently enumerate all cases for our GICv3 definitions,
but it seemed painful to expand ~30 cases for PMEVCNTR<n>_EL0 and friends, and
for these I've made the macros take an 'n' parameter.

The series is based on the arm64/for-next/core branch, since it relies on
commit c9ee0f98662a6e35 ("arm64: cpufeature: Define helpers for sys_reg id")
for the definition of SYS_DESC().

Thanks,
Mark.

Mark Rutland (13):
  arm64: sysreg: sort by encoding
  arm64: sysreg: add debug system registers
  arm64: sysreg: add performance monitor registers
  arm64: sysreg: subsume GICv3 sysreg definitions
  arm64: sysreg: add register encodings used by KVM
  arm64: sysreg: add Set/Way sys encodings
  arm64: kvm: add SYS_DESC()
  arm64: kvm: Use common debug sysreg definitions
  arm64: kvm: Use common performance monitor sysreg definitions
  arm64: kvm: Use common GICv3 sysreg definitions
  arm64: kvm: use common invariant sysreg definitions
  arm64: kvm: Use common sysreg definitions
  arm64: kvm: Use common Set/Way sys definitions

 arch/arm64/include/asm/arch_gicv3.h  |  81 ++-------
 arch/arm64/include/asm/sysreg.h      | 158 +++++++++++++++-
 arch/arm64/kernel/head.S             |   8 +-
 arch/arm64/kvm/sys_regs.c            | 344 +++++++++++------------------------
 arch/arm64/kvm/sys_regs.h            |   5 +
 arch/arm64/kvm/sys_regs_generic_v8.c |   4 +-
 6 files changed, 276 insertions(+), 324 deletions(-)

-- 
1.9.1
