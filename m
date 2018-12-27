From: Peng Hao <peng.hao2@zte.com.cn>
Subject: [PATCH]  kvm:arm/arm64: vgic: remove unnecessary semicolon
Date: Thu, 27 Dec 2018 09:04:27 +0800
Message-ID: <1545872667-82509-1-git-send-email-peng.hao2@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 049D44A391
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Dec 2018 19:43:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DKSZyb8gaCGe for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Dec 2018 19:43:46 -0500 (EST)
Received: from mxct.zte.com.cn (out1.zte.com.cn [202.103.147.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C28F54A381
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Dec 2018 19:43:45 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: christoffer.dall@arm.com, marc.zyngier@arm.com
Cc: Peng Hao <peng.hao2@zte.com.cn>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Remove unnecessary semicolon in vgic_put_irq.

Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
---
 virt/kvm/arm/vgic/vgic.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 7cfdfbc..f9ff5c7 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -142,7 +142,7 @@ void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq)
 	if (!kref_put(&irq->refcount, vgic_irq_release)) {
 		spin_unlock_irqrestore(&dist->lpi_list_lock, flags);
 		return;
-	};
+	}
 
 	list_del(&irq->lpi_list);
 	dist->lpi_list_count--;
-- 
1.8.3.1
