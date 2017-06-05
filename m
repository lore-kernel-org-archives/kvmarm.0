From: Mark Rutland <mark.rutland@arm.com>
Subject: [PATCH 0/2] arm64/kvm: use SYS_REG_DESC() for VGIC-v3
Date: Mon,  5 Jun 2017 14:19:59 +0100
Message-ID: <1496668801-16064-1-git-send-email-mark.rutland@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0241C40C07
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jun 2017 09:16:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DCK34Ru5CIIz for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Jun 2017 09:16:43 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B2DB405DA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Jun 2017 09:16:42 -0400 (EDT)
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

While looking around, I spotted that the VGIC-v3 code still uses open-coded SYS
encodings. These patches migrate said code to use common <asm/sysreg.h>
mnemonics, as we do for the rest of the AArch64 sysregs.

This is based on Marc's kvm-arm64/gicv3-cpuif-mediated-access branch [1].

Thanks,
Mark.

[1] git://git.kernel.org/pub/scm/linux/kernel/git/maz/arm-platforms.git kvm-arm64/gicv3-cpuif-mediated-access

Mark Rutland (2):
  arm64/kvm: sysreg: fix typo'd SYS_ICC_IGRPEN*_EL1
  arm64/kvm: vgic: use SYS_DESC()

 arch/arm64/include/asm/arch_gicv3.h |  2 +-
 arch/arm64/include/asm/sysreg.h     | 12 ++++++++--
 arch/arm64/kvm/vgic-sys-reg-v3.c    | 45 +++++++++++++------------------------
 virt/kvm/arm/hyp/vgic-v3-sr.c       |  4 ++--
 4 files changed, 28 insertions(+), 35 deletions(-)

-- 
1.9.1
