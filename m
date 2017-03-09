From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 00/15] arm64/kvm: use common sysreg definitions
Date: Thu,  9 Mar 2017 17:07:12 +0000
Message-ID: <1489079247-31092-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4025D40962
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 12:06:19 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id OxgWDH-Vb14G for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 12:06:17 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B659540625
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 12:06:17 -0500 (EST)
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

Currently we duplicate effort in maintaining system register encodings across
arm64's <asm/sysreg.h>, KVM's sysreg tables, and other places. This redundancy
is unfortunate, and as encodings are encoded in-place without any mnemonic,
this ends up more painful to read than necessary.

This series ameliorates this by making <asm/sysreg.h> the canonical location
for (architected) system register encodings, with other users building atop of
this, e.g. with KVM deriving its sysreg table values from the common mnemonics.

I've only attacked AArch64-native SYS encodings, and ignored CP{15,14}
registers for now, but these could be handled similarly. Largely, I've stuck to
only what KVM needs, though for the debug and perfmon groups it was easier to
take the whole group from the ARM ARM than to filter them to only what KVM
needed today.

To verify that I haven't accidentally broken KVM, I've diffed sys_regs.o and
sys_regs_generic_v8.o on a section-by-section basis before and after the series
is applied. The .text, .data, and .rodata sections (and most others) are
identical. The __bug_table section, and some .debug* sections differ, and this
appears to be due to line numbers changing due to removed lines.

One thing I wasn't sure how to address was banks of registers such as
PMEVCNTR<n>_EL0. We currently enumerate all cases for our GICv3 definitions,
but it seemed painful to expand ~30 cases for PMEVCNTR<n>_EL0 and friends, and
for these I've made the macros take an 'n' parameter. It would be nice to be
consistent either way, and I'm happy to expand those cases.

I've pushed thes series out to a branch [1] based on v4.11-rc1. It looks like
git rebase is also happy to apply the patches atop of the kvm-arm-for-4.11-rc2
tag.

Thanks,
Mark.

Since RFC [2]:
* Rebase to v4.11-rc1, solving a trivial conflict.
* Handle the physical counter registers.
* Verified section differences again.

Thanks,
Mark.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git arm64/common-sysreg
[2] http://lists.infradead.org/pipermail/linux-arm-kernel/2017-January/484693.html

Mark Rutland (15):
  arm64: sysreg: sort by encoding
  arm64: sysreg: add debug system registers
  arm64: sysreg: add performance monitor registers
  arm64: sysreg: subsume GICv3 sysreg definitions
  arm64: sysreg: add physical timer registers
  arm64: sysreg: add register encodings used by KVM
  arm64: sysreg: add Set/Way sys encodings
  KVM: arm64: add SYS_DESC()
  KVM: arm64: Use common debug sysreg definitions
  KVM: arm64: Use common performance monitor sysreg definitions
  KVM: arm64: Use common GICv3 sysreg definitions
  KVM: arm64: Use common physical timer sysreg definitions
  KVM: arm64: use common invariant sysreg definitions
  KVM: arm64: Use common sysreg definitions
  KVM: arm64: Use common Set/Way sys definitions

 arch/arm64/include/asm/arch_gicv3.h  |  81 ++------
 arch/arm64/include/asm/sysreg.h      | 162 +++++++++++++++-
 arch/arm64/kernel/head.S             |   8 +-
 arch/arm64/kvm/sys_regs.c            | 358 +++++++++++------------------------
 arch/arm64/kvm/sys_regs.h            |   5 +
 arch/arm64/kvm/sys_regs_generic_v8.c |   4 +-
 6 files changed, 284 insertions(+), 334 deletions(-)

-- 
1.9.1
