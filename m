From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 12/12] KVM: arm/arm64: vgic: Remove useless arm-gic.h #include
Date: Fri, 19 Jun 2015 13:53:16 +0100
Message-ID: <1434718396-13110-13-git-send-email-marc.zyngier@arm.com>
References: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BF90756205
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2015 08:43:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oj7NUQeIPnup for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Jun 2015 08:43:22 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BBBD056206
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Jun 2015 08:43:22 -0400 (EDT)
In-Reply-To: <1434718396-13110-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@kernel.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, linux-arm-kernel@lists.infradead.org, Firo Yang <firogm@gmail.com>, Tiejun Chen <tiejun.chen@intel.com>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Back in the days, vgic.c used to have an intimate knowledge of
the actual GICv2. These days, this has been abstracted away into
hardware-specific backends.

Remove the now useless arm-gic.h #include directive, making it
clear that GICv2 specific code doesn't belong here.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 950064a..f94d887 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -26,8 +26,6 @@
 #include <linux/of_irq.h>
 #include <linux/uaccess.h>
 
-#include <linux/irqchip/arm-gic.h>
-
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_arm.h>
 #include <asm/kvm_mmu.h>
-- 
2.1.4
