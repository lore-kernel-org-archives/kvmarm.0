From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 0/2] GICv3 world-switch fixes for -next
Date: Mon, 10 Apr 2017 10:19:42 +0100
Message-ID: <20170410091944.19963-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 064A040C55
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Apr 2017 05:17:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0eETLDnsfbWw for <kvmarm@lists.cs.columbia.edu>;
 Mon, 10 Apr 2017 05:17:38 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4CBB40BC5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 10 Apr 2017 05:17:38 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Here's a couple of fixes for issues I've spotted when running our
current -next branch on a GICv3 system.

The first patch fixes our v2-on-v3 handling of VMCR_EL2, which cannot
be safely save/restored when ICC_SRE_EL1.SRE is set (in that case,
VMCR_EL2.VFIQen is RES1, and Group0 interrupts get delivered as
FIQ). This is effectively de-optimizing VMCR_EL2 save/restore for
v2-on-v3, which is a pretty rare use case.

The second patch fixes a typo that leads to a HYP panic when the CPU
accesses an unimplemented list register, or the corruption of some
memory if all 16 architectural list registers are used.

Both patches tested on -rc6 + kvmarm/next on a rk3399 platform.

Marc Zyngier (2):
  KVM: arm/arm64: vgic-v3: De-optimize VMCR save/restore when emulating
    a GICv2
  KVM: arm/arm64: vgic-v3: Fix off-by-one LR access

 virt/kvm/arm/hyp/vgic-v3-sr.c | 10 +++++++---
 virt/kvm/arm/vgic/vgic.c      | 26 ++++++++++++++++++++------
 2 files changed, 27 insertions(+), 9 deletions(-)

-- 
2.11.0
