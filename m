From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC v2 07/12] KVM: arm/arm64: Adapt vgic_v3_check_base to multiple rdist regions
Date: Tue, 27 Mar 2018 16:04:11 +0200
Message-ID: <1522159456-10419-8-git-send-email-eric.auger@redhat.com>
References: <1522159456-10419-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1522159456-10419-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org
Cc: andre.przywara@arm.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

We introduce a new helper to check there is no overlap between
dist region (if set) and registered rdist regions. This both
handles the case of legacy single rdist region (implicitly sized
with the number of online vcpus) and the new case of multiple
explicitly sized rdist regions.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 virt/kvm/arm/vgic/vgic-v3.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 9a19129..993939d 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -426,31 +426,23 @@ bool vgic_v3_rdist_overlap(struct kvm *kvm, gpa_t base, size_t size)
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
+	list_for_each_entry(rdreg, &d->rd_regions, list) {
+		if (rdreg->base + vgic_v3_rd_region_size(kvm, rdreg) <
+			rdreg->base)
+			return false;
+	}
 
-	/* Both base addresses must be set to check if they overlap */
-	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base) || !rdreg)
+	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base))
 		return true;
 
-	if (d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE <= rdreg->base)
-		return true;
-
-	if (rdreg->base + redist_size <= d->vgic_dist_base)
-		return true;
-
-	return false;
+	return !vgic_v3_rdist_overlap(kvm, d->vgic_dist_base,
+				      KVM_VGIC_V3_DIST_SIZE);
 }
 
 /**
-- 
2.5.5
