From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v2] KVM: arm/arm64: vgic-its: Fix vgicv4 init
Date: Mon,  8 Jan 2018 10:52:54 +0100
Message-ID: <1515405174-21066-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

Commit 3d1ad640f8c94 ("KVM: arm/arm64: Fix GICv4 ITS initialization
issues") moved the vgic_supports_direct_msis() check in vgic_v4_init().
However when vgic_v4_init is called from vgic_its_create(), the has_its
field is not yet set. Hence vgic_supports_direct_msis returns false and
vgic_v4_init does nothing.

Let's move the check back to vgic_v4_init caller.

Fixes: 3d1ad640f8c94 ("KVM: arm/arm64: Fix GICv4 ITS initialization issues")
Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- move the check to the caller
- identify the right commit this patch fixes
---
 virt/kvm/arm/vgic/vgic-init.c | 8 +++++---
 virt/kvm/arm/vgic/vgic-its.c  | 2 +-
 virt/kvm/arm/vgic/vgic-v4.c   | 3 ---
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 6231012..40be908 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -285,9 +285,11 @@ int vgic_init(struct kvm *kvm)
 	if (ret)
 		goto out;
 
-	ret = vgic_v4_init(kvm);
-	if (ret)
-		goto out;
+	if (vgic_supports_direct_msis(kvm)) {
+		ret = vgic_v4_init(kvm);
+		if (ret)
+			goto out;
+	}
 
 	kvm_for_each_vcpu(i, vcpu, kvm)
 		kvm_vgic_vcpu_enable(vcpu);
diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 8e633bd..aebc88d 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1687,7 +1687,7 @@ static int vgic_its_create(struct kvm_device *dev, u32 type)
 	if (!its)
 		return -ENOMEM;
 
-	if (vgic_initialized(dev->kvm)) {
+	if (kvm_vgic_global_state.has_gicv4 && vgic_initialized(dev->kvm)) {
 		int ret = vgic_v4_init(dev->kvm);
 		if (ret < 0) {
 			kfree(its);
diff --git a/virt/kvm/arm/vgic/vgic-v4.c b/virt/kvm/arm/vgic/vgic-v4.c
index 4a37292..666abb1 100644
--- a/virt/kvm/arm/vgic/vgic-v4.c
+++ b/virt/kvm/arm/vgic/vgic-v4.c
@@ -118,9 +118,6 @@ int vgic_v4_init(struct kvm *kvm)
 	struct kvm_vcpu *vcpu;
 	int i, nr_vcpus, ret;
 
-	if (!vgic_supports_direct_msis(kvm))
-		return 0; /* Nothing to see here... move along. */
-
 	if (dist->its_vm.vpes)
 		return 0;
 
-- 
2.5.5
