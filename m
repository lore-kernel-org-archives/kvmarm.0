From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 3/4] KVM: arm/arm64: vgic_init: Cleanup reference to
 process_maintenance
Date: Fri,  4 May 2018 17:15:58 +0100
Message-ID: <20180504161559.22852-4-marc.zyngier@arm.com>
References: <20180504161559.22852-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3FBAF49FA9
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 May 2018 12:07:08 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P4y8zhYNG3ue for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 May 2018 12:06:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA59549FC0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 May 2018 12:06:45 -0400 (EDT)
In-Reply-To: <20180504161559.22852-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, Valentin Schneider <valentin.schneider@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Valentin Schneider <valentin.schneider@arm.com>

One comment still mentioned process_maintenance operations after
commit af0614991ab6 ("KVM: arm/arm64: vgic: Get rid of unnecessary
process_maintenance operation")

Update the comment to point to vgic_fold_lr_state instead, which
is where maintenance interrupts are taken care of.

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 68378fe17a0e..e07156c30323 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -423,7 +423,7 @@ static irqreturn_t vgic_maintenance_handler(int irq, void *data)
 	 * We cannot rely on the vgic maintenance interrupt to be
 	 * delivered synchronously. This means we can only use it to
 	 * exit the VM, and we perform the handling of EOIed
-	 * interrupts on the exit path (see vgic_process_maintenance).
+	 * interrupts on the exit path (see vgic_fold_lr_state).
 	 */
 	return IRQ_HANDLED;
 }
-- 
2.14.2
