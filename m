From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 26/33] KVM: arm/arm64: Adapt vgic_v3_check_base to multiple
 rdist regions
Date: Fri,  1 Jun 2018 16:27:40 +0100
Message-ID: <20180601152747.23613-27-marc.zyngier@arm.com>
References: <20180601152747.23613-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20180601152747.23613-1-marc.zyngier@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Mark Rutland <mark.rutland@arm.com>, Peter Maydell <peter.maydell@linaro.org>, kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@arm.com>, kvmarm@lists.cs.columbia.edu, Eric Auger <eric.auger@redhat.com>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

vgic_v3_check_base() currently only handles the case of a unique
legacy redistributor region whose size is not explicitly set but
inferred, instead, from the number of online vcpus.

We adapt it to handle the case of multiple redistributor regions
with explicitly defined size. We rely on two new helpers:
- vgic_v3_rdist_overlap() is used to detect overlap with the dist
  region if defined
- vgic_v3_rd_region_size computes the size of the redist region,
  would it be a legacy unique region or a new explicitly sized
  region.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v3.c | 49 ++++++++++++++++++++++++-------------
 virt/kvm/arm/vgic/vgic.h    | 10 ++++++++
 2 files changed, 42 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 2a11fe89943a..ce4476a08f5b 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -419,6 +419,29 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 	return 0;
 }
 
+/**
+ * vgic_v3_rdist_overlap - check if a region overlaps with any
+ * existing redistributor region
+ *
+ * @kvm: kvm handle
+ * @base: base of the region
+ * @size: size of region
+ *
+ * Return: true if there is an overlap
+ */
+bool vgic_v3_rdist_overlap(struct kvm *kvm, gpa_t base, size_t size)
+{
+	struct vgic_dist *d = &kvm->arch.vgic;
+	struct vgic_redist_region *rdreg;
+
+	list_for_each_entry(rdreg, &d->rd_regions, list) {
+		if ((base + size > rdreg->base) &&
+			(base < rdreg->base + vgic_v3_rd_region_size(kvm, rdreg)))
+			return true;
+	}
+	return false;
+}
+
 /*
  * Check for overlapping regions and for regions crossing the end of memory
  * for base addresses which have already been set.
@@ -426,31 +449,23 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 bool vgic_v3_check_base(struct kvm *kvm)
 {
 	struct vgic_dist *d = &kvm->arch.vgic;
-	gpa_t redist_size = KVM_VGIC_V3_REDIST_SIZE;
-	struct vgic_redist_region *rdreg =
-		list_first_entry(&d->rd_regions,
-				 struct vgic_redist_region, list);
-
-	redist_size *= atomic_read(&kvm->online_vcpus);
+	struct vgic_redist_region *rdreg;
 
 	if (!IS_VGIC_ADDR_UNDEF(d->vgic_dist_base) &&
 	    d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE < d->vgic_dist_base)
 		return false;
 
-	if (rdreg && (rdreg->base + redist_size < rdreg->base))
-		return false;
-
-	/* Both base addresses must be set to check if they overlap */
-	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base) || !rdreg)
-		return true;
-
-	if (d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE <= rdreg->base)
-		return true;
+	list_for_each_entry(rdreg, &d->rd_regions, list) {
+		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
+			rdreg->base)
+			return false;
+	}
 
-	if (rdreg->base + redist_size <= d->vgic_dist_base)
+	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
 		return true;
 
-	return false;
+	return !vgic_v3_rdist_overlap(kvm, d->vgic_dist_base,
+				      KVM_VGIC_V3_DIST_SIZE);
 }
 
 /**
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index fddd57ff6529..e9f192660097 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -276,6 +276,16 @@ vgic_v3_redist_region_full(struct vgic_redist_region *region)
 
 struct vgic_redist_region *vgic_v3_rdist_free_slot(struct list_head *rdregs);
 
+static inline size_t
+vgic_v3_rd_region_size(struct kvm *kvm, struct vgic_redist_region *rdreg)
+{
+	if (!rdreg->count)
+		return atomic_read(&kvm->online_vcpus) * KVM_VGIC_V3_REDIST_SIZE;
+	else
+		return rdreg->count * KVM_VGIC_V3_REDIST_SIZE;
+}
+bool vgic_v3_rdist_overlap(struct kvm *kvm, gpa_t base, size_t size);
+
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq);
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
-- 
2.17.1
