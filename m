From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 14/26] KVM: arm/arm64: GICv4: Handle CLEAR applied to a VLPI
Date: Fri, 27 Oct 2017 15:28:43 +0100
Message-ID: <20171027142855.21584-15-marc.zyngier@arm.com>
References: <20171027142855.21584-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DDC140A74
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 10:28:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 22tawBK0TRtt for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Oct 2017 10:28:23 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6D96F49D60
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Oct 2017 10:28:23 -0400 (EDT)
In-Reply-To: <20171027142855.21584-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Christoffer Dall <cdall@linaro.org>, Andre Przywara <Andre.Przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Handling CLEAR is pretty easy. Just ask the ITS driver to clear
the corresponding pending bit (which will turn into a CLEAR
command on the physical side).

Acked-by: Christoffer Dall <cdall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 42ffb9084bb7..5778b50911e8 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1070,6 +1070,10 @@ static int vgic_its_cmd_handle_clear(struct kvm *kvm, struct vgic_its *its,
 
 	ite->irq->pending_latch = false;
 
+	if (ite->irq->hw)
+		return irq_set_irqchip_state(ite->irq->host_irq,
+					     IRQCHIP_STATE_PENDING, false);
+
 	return 0;
 }
 
-- 
2.11.0
