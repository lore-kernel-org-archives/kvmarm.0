From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 44/59] KVM: arm/arm64: GICv4: Handle MOVI applied to a VLPI
Date: Mon, 31 Jul 2017 18:26:22 +0100
Message-ID: <20170731172637.29355-45-marc.zyngier@arm.com>
References: <20170731172637.29355-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C2A9449C99
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:27:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2CfFi6gQaL-W for <kvmarm@lists.cs.columbia.edu>;
 Mon, 31 Jul 2017 13:27:09 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C5B9949C67
 for <kvmarm@lists.cs.columbia.edu>; Mon, 31 Jul 2017 13:27:09 -0400 (EDT)
In-Reply-To: <20170731172637.29355-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: Jason Cooper <jason@lakedaemon.net>, Thomas Gleixner <tglx@linutronix.de>
List-Id: kvmarm@lists.cs.columbia.edu

When the guest issues a MOVI, we need to tell the physical ITS
that we're now targetting a new vcpu. This is done by extracting
the current mapping, updating the target, and reapplying the
mapping. The core ITS code should do the right thing.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 79bac93d3e7d..aaad577ce328 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -706,6 +706,19 @@ static int vgic_its_cmd_handle_movi(struct kvm *kvm, struct vgic_its *its,
 	ite->irq->target_vcpu = vcpu;
 	spin_unlock(&ite->irq->irq_lock);
 
+	if (ite->irq->hw) {
+		struct its_vlpi_map map;
+		int ret;
+
+		ret = its_get_vlpi(ite->irq->host_irq, &map);
+		if (ret)
+			return ret;
+
+		map.vpe_idx = vcpu->vcpu_id;
+
+		return its_map_vlpi(ite->irq->host_irq, &map);
+	}
+
 	return 0;
 }
 
-- 
2.11.0
