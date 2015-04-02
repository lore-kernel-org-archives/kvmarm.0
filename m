From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 25/27] KVM: arm/arm64: prepare GICv3 emulation to use
 kvm_io_bus MMIO handling
Date: Thu,  2 Apr 2015 11:05:29 +0100
Message-ID: <1427969131-8445-26-git-send-email-marc.zyngier@arm.com>
References: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F00E94AE33
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2015 06:20:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9pTHqfH6ozsB for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Apr 2015 06:20:38 -0400 (EDT)
Received: from inca-roads.misterjones.org (inca-roads.misterjones.org
 [213.251.177.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 110514AE2B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Apr 2015 06:20:38 -0400 (EDT)
In-Reply-To: <1427969131-8445-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Andre Przywara <andre.przywara@arm.com>

Using the framework provided by the recent vgic.c changes, we
register a kvm_io_bus device on mapping the virtual GICv3 resources.
The distributor mapping is pretty straight forward, but the
redistributors need some more love, since they need to be tagged with
the respective redistributor (read: VCPU) they are connected with.
We use the kvm_io_bus framework to register one devices per VCPU.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 include/kvm/arm_vgic.h      |  1 +
 virt/kvm/arm/vgic-v3-emul.c | 39 ++++++++++++++++++++++++++++++++++++++-
 2 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4523984..d6705f4 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -252,6 +252,7 @@ struct vgic_dist {
 
 	struct vgic_vm_ops	vm_ops;
 	struct vgic_io_device	dist_iodev;
+	struct vgic_io_device	*redist_iodevs;
 };
 
 struct vgic_v2_cpu_if {
diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index 2f03a36..eb1a797 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -758,6 +758,9 @@ static int vgic_v3_map_resources(struct kvm *kvm,
 {
 	int ret = 0;
 	struct vgic_dist *dist = &kvm->arch.vgic;
+	gpa_t rdbase = dist->vgic_redist_base;
+	struct vgic_io_device *iodevs = NULL;
+	int i;
 
 	if (!irqchip_in_kernel(kvm))
 		return 0;
@@ -783,7 +786,41 @@ static int vgic_v3_map_resources(struct kvm *kvm,
 		goto out;
 	}
 
-	kvm->arch.vgic.ready = true;
+	ret = vgic_register_kvm_io_dev(kvm, dist->vgic_dist_base,
+				       GIC_V3_DIST_SIZE, vgic_v3_dist_ranges,
+				       -1, &dist->dist_iodev);
+	if (ret)
+		goto out;
+
+	iodevs = kcalloc(dist->nr_cpus, sizeof(iodevs[0]), GFP_KERNEL);
+	if (!iodevs) {
+		ret = -ENOMEM;
+		goto out_unregister;
+	}
+
+	for (i = 0; i < dist->nr_cpus; i++) {
+		ret = vgic_register_kvm_io_dev(kvm, rdbase,
+					       SZ_128K, vgic_redist_ranges,
+					       i, &iodevs[i]);
+		if (ret)
+			goto out_unregister;
+		rdbase += GIC_V3_REDIST_SIZE;
+	}
+
+	dist->redist_iodevs = iodevs;
+	dist->ready = true;
+	goto out;
+
+out_unregister:
+	kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS, &dist->dist_iodev.dev);
+	if (iodevs) {
+		for (i = 0; i < dist->nr_cpus; i++) {
+			if (iodevs[i].dev.ops)
+				kvm_io_bus_unregister_dev(kvm, KVM_MMIO_BUS,
+							  &iodevs[i].dev);
+		}
+	}
+
 out:
 	if (ret)
 		kvm_vgic_destroy(kvm);
-- 
2.1.4
