From: Pavel Fedin <p.fedin@samsung.com>
Subject: [PATCH 0/2] Allow to use KVM without in-kernel irqchip
Date: Tue, 07 Jul 2015 13:38:47 +0300
Message-ID: <cover.1436264839.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CA47A57DE2
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 06:27:28 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PBi39lFtI7Xk for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Jul 2015 06:27:26 -0400 (EDT)
Received: from mailout4.w1.samsung.com (mailout4.w1.samsung.com
 [210.118.77.14])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DE47E57DDB
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Jul 2015 06:27:26 -0400 (EDT)
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7.0.5.31.0 64bit (built May 5 2014))
 with ESMTP id <0NR400JAT5KUB380@mailout4.w1.samsung.com> for
 kvmarm@lists.cs.columbia.edu; Tue, 07 Jul 2015 11:38:54 +0100 (BST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: KVM-ARM mailing list <kvmarm@lists.cs.columbia.edu>
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

This patch set brings back functionality which was broken in v4.1. The
overall goal is to eventually enable using virtual timer too, but for now
changes affect only a possibility to run KVM itself. The guest currently
has to use another timer because there's no API to propagate interrupts
from in-kernel virtual timer to the interrupt controller emulated in
userspace.

Pavel Fedin (2):
  Fix NULL pointer dereferences if KVM is used without in-kernel irqchip
  Detect vGIC presence at runtime

 arch/arm/kvm/arm.c  | 19 ++++++++++++++++++-
 virt/kvm/arm/vgic.c |  5 ++++-
 2 files changed, 22 insertions(+), 2 deletions(-)

-- 
2.4.4
