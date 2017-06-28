From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 52/52] KVM: arm/arm64: GICv4: Enable VLPI support
Date: Wed, 28 Jun 2017 16:04:11 +0100
Message-ID: <20170628150411.15846-53-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3571D40D59
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:06:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id zoo5shJ8n5hp for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:05:57 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A61DD49C4C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:56 -0400 (EDT)
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

All it takes is for the has_v4 flag to be set in gic_kvm_info, and
we'll enable it...

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v3.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 96ea597db0e7..fb7bc3b93482 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -478,6 +478,12 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 	kvm_vgic_global_state.can_emulate_gicv2 = false;
 	kvm_vgic_global_state.ich_vtr_el2 = ich_vtr_el2;
 
+	/* GICv4 support? */
+	if (info->has_v4) {
+		kvm_vgic_global_state.has_gicv4 = true;
+		kvm_info("GICv4 support enabled\n");
+	}
+
 	if (!info->vcpu.start) {
 		kvm_info("GICv3: no GICV resource entry\n");
 		kvm_vgic_global_state.vcpu_base = 0;
-- 
2.11.0
