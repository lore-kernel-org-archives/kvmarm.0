From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 0/4] KVM: arm/arm64: vgic-v3: Group0 SGI support
Date: Fri, 10 Aug 2018 11:14:18 +0100
Message-ID: <20180810101422.3569-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5CD754A0CC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Aug 2018 06:14:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bXC95rAPi14l for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Aug 2018 06:14:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38024408AD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Aug 2018 06:14:35 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Although we now have Group0 support, we still miss support for Group0
SGIs (which amounts to handling ICC_SGI0R_EL1 and ICC_ASGI1R_EL1
traps), and this small series adds such support.

I appreciate this is *very* late for 4.19, yet I'd like to take it in
as they complement Christoffer's Group0 support, and It'd be annoying
to have something incomplete in 4.19.

Please shout if you spot something that doesn't look quite right.

Thanks,

	M.

* From v1:
  - Clarified the condition for which a G1 SGI can be queued
  - Added ABs abd RBs from Christoffer and Eric

Marc Zyngier (4):
  KVM: arm64: Remove non-existent AArch32 ICC_SGI1R encoding
  KVM: arm/arm64: vgic-v3: Add core support for Group0 SGIs
  KVM: arm64: vgic-v3: Add support for ICC_SGI0R_EL1 and ICC_ASGI1R_EL1
    accesses
  KVM: arm: vgic-v3: Add support for ICC_SGI0R and ICC_ASGI1R accesses

 arch/arm/kvm/coproc.c            | 25 ++++++++++++++++++-
 arch/arm64/include/asm/sysreg.h  |  2 ++
 arch/arm64/kvm/sys_regs.c        | 43 +++++++++++++++++++++++++++++---
 include/kvm/arm_vgic.h           |  2 +-
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 19 +++++++++++---
 5 files changed, 81 insertions(+), 10 deletions(-)

-- 
2.18.0
