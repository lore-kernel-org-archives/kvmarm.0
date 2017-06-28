From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 42/52] KVM: arm/arm64: GICv4: Handle MOVI applied to a VLPI
Date: Wed, 28 Jun 2017 16:04:01 +0100
Message-ID: <20170628150411.15846-43-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDA5949C51
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vGP9vOufHCJA for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:05:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E354E49C59
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:39 -0400 (EDT)
In-Reply-To: <20170628150411.15846-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
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
index ed52b94e8e6d..ee8355991bb1 100644
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
