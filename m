From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/2] arm64: KVM: Use instruction patching for GIC world switch
Date: Fri, 12 Jun 2015 12:06:35 +0100
Message-ID: <1434107197-4919-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 823C854E8C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jun 2015 06:56:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wpPWQvH0Ki8J for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Jun 2015 06:56:26 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DF43154E8A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Jun 2015 06:56:25 -0400 (EDT)
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
Cc: Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

The current way we deal with the GIC world switch on arm64 is a bit
convoluted. As we have two possible backends, we rely on a couple of
indirections set at boot time. These indirection never change, so it
would make more sense to directly patch in a branch to the right
function.

To do this, we introduce a new CPU feature that detect the presence of
a GICv3 CPU interface. When detected, we patch branches to the GICv3
save/restore functions that otherwise point to the GICv2 backend.

Tested on both GICv2 (Juno, Seattle) and GICv3 (FVP Base model).

These patches have been on the various lists for quite a while as part
of a series dealing with instruction patching. Now that the
prerequisite are queued for 4.2, it would make sense for these to be
merged alongside.

Catalin, would you mind taking them through the arm64 tree?

Marc Zyngier (2):
  arm64: alternative: Introduce feature for GICv3 CPU interface
  arm64: KVM: Switch vgic save/restore to alternative_insn

 arch/arm/include/asm/kvm_host.h     |  5 -----
 arch/arm64/include/asm/cpufeature.h |  8 +++++++-
 arch/arm64/include/asm/kvm_asm.h    |  5 -----
 arch/arm64/include/asm/kvm_host.h   | 23 -----------------------
 arch/arm64/kernel/asm-offsets.c     |  1 -
 arch/arm64/kernel/cpufeature.c      | 16 ++++++++++++++++
 arch/arm64/kvm/hyp.S                | 18 ++++--------------
 virt/kvm/arm/vgic.c                 |  3 ---
 8 files changed, 27 insertions(+), 52 deletions(-)

-- 
2.1.4
