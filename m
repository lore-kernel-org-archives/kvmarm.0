From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v2 04/12] KVM: arm/arm64: Helper to locate free rdist index
Date: Tue, 27 Mar 2018 16:04:08 +0200
Message-ID: <1522159456-10419-5-git-send-email-eric.auger@redhat.com>
References: <1522159456-10419-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522159456-10419-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org
Cc: andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

We introduce vgic_v3_rdist_free_slot to help identifying
where we can place a new 2x64KB redistributor.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v3.c |  3 +--
 virt/kvm/arm/vgic/vgic-v3.c      | 17 +++++++++++++++++
 virt/kvm/arm/vgic/vgic.h         | 11 +++++++++++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index d1aab18..49ca176 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -593,8 +593,7 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 	 * function for all VCPUs when the base address is set.  Just return
 	 * without doing any work for now.
 	 */
-	rdreg = list_first_entry(&vgic->rd_regions,
-				 struct vgic_redist_region, list);
+	rdreg = vgic_v3_rdist_free_slot(&vgic->rd_regions);
 	if (!rdreg)
 		return 0;
 
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 7e696e6..6a7e4065 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -438,6 +438,23 @@ bool vgic_v3_check_base(struct kvm *kvm)
 	return false;
 }
 
+/**
+ * vgic_v3_rdist_free_slot - Look up registered rdist regions and identify one
+ * which has free space to put a new rdist regions
+ *
+ * If any, return this redist region handle, otherwise returns NULL.
+ */
+struct vgic_redist_region *vgic_v3_rdist_free_slot(struct list_head *rd_regions)
+{
+	struct vgic_redist_region *rdreg;
+
+	list_for_each_entry(rdreg, rd_regions, list) {
+		if (!vgic_v3_redist_region_full(rdreg))
+			return rdreg;
+	}
+	return NULL;
+}
+
 int vgic_v3_map_resources(struct kvm *kvm)
 {
 	int ret = 0;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index f5b8519..d5e89b8 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -248,6 +248,17 @@ static inline int vgic_v3_max_apr_idx(struct kvm_vcpu *vcpu)
 	}
 }
 
+static inline bool
+vgic_v3_redist_region_full(struct vgic_redist_region *region)
+{
+	if (!region->count)
+		return false;
+
+	return (region->free_index >= region->count);
+}
+
+struct vgic_redist_region *vgic_v3_rdist_free_slot(struct list_head *rdregs);
+
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq);
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
-- 
2.5.5
