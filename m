From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH v4 0/3] KVM: arm/arm64: Allow to use KVM without in-kernel
 irqchip
Date: Mon, 17 Aug 2015 12:43:37 +0300
Message-ID: <cover.1439804074.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 939335C55F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2015 05:30:32 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uruOcRvw4CSp for <kvmarm@lists.cs.columbia.edu>;
 Mon, 17 Aug 2015 05:30:30 -0400 (EDT)
Received: from mailout4.w1.samsung.com (mailout4.w1.samsung.com
 [210.118.77.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B37345C556
 for <kvmarm@lists.cs.columbia.edu>; Mon, 17 Aug 2015 05:30:29 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NT8000KZ0CYQC80@mailout4.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Mon, 17 Aug 2015 10:43:46 +0100 (BST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This patch set brings back functionality which was broken in v4.0.
Unfortunately because of restrictions of such a hardware is is impossible
to take advantage of virtual architected timer, therefore guest, running
in such restricted mode, has to use some memory-mapped timer. But it is
still better than nothing.

v3 => v4:
- Revert back to using switch on kvm_vgic_hyp_init() return code. I decided
  to leave 'vgic_present = false' statement because it helps to understand
  the code.

v2 => v3:
- Improved commit messages, added references to commits where the respective
  functionality was broken
- Explicitly specify that the solution currently affects only vGIC and has
  nothing to do with timer.
- Fixed code style according to previous notes
- Removed ARM64 save/restore patch introduced in v2 because it was already
  obsolete for linux-next
- Modify KVM_CAP_IRQFD handling in correct place

v1 => v2:
- Do not use defensive approach in patch 0001. Use correct conditions in
  callers instead
- Added ARM64-specific code, without which attempt to run a VM ends in a
  HYP crash because of unset vGIC save/restore function pointers


Pavel Fedin (3):
  Fix NULL pointer dereference if KVM is used without in-kernel irqchip
  Detect vGIC presence at runtime
  Make KVM_CAP_IRQFD dependent on KVM_CAP_IRQCHIP

 arch/arm/kvm/arm.c  | 24 +++++++++++++++++++++---
 virt/kvm/kvm_main.c |  5 +++--
 2 files changed, 24 insertions(+), 5 deletions(-)

-- 
2.4.4
