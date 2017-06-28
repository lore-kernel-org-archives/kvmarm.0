From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 38/52] KVM: arm/arm64: GICv4: Wire init/teardown of per-VM
 support
Date: Wed, 28 Jun 2017 16:03:57 +0100
Message-ID: <20170628150411.15846-39-marc.zyngier@arm.com>
References: <20170628150411.15846-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4A43940EFE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WopKCHJQurfR for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Jun 2017 11:05:33 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3ED9849C43
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Jun 2017 11:05:33 -0400 (EDT)
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

Should the HW support GICv4 and an ITS being associated with this
VM, let's init the its_vm and its_vpe structures.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-init.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 3a0b8999f011..0de1f0d986d4 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -285,8 +285,14 @@ int vgic_init(struct kvm *kvm)
 	if (ret)
 		goto out;
 
-	if (vgic_has_its(kvm))
+	if (vgic_has_its(kvm)) {
 		dist->msis_require_devid = true;
+		if (kvm_vgic_global_state.has_gicv4) {
+			ret = vgic_v4_init(kvm);
+			if (ret)
+				goto out;
+		}
+	}
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_vgic_vcpu_enable(vcpu);
@@ -323,6 +329,9 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 
 	kfree(dist->spis);
 	dist->nr_spis = 0;
+
+	if (kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm))
+		vgic_v4_teardown(kvm);
 }
 
 void kvm_vgic_vcpu_destroy(struct kvm_vcpu *vcpu)
-- 
2.11.0
