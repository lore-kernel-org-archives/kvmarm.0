From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 03/12] KVM: arm/arm64: Replace the single rdist region by a
 list
Date: Fri, 13 Apr 2018 10:20:49 +0200
Message-ID: <1523607658-9166-4-git-send-email-eric.auger@redhat.com>
References: <1523607658-9166-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C8284A0DF
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Apr 2018 04:12:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LjyBOzjHgTax for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Apr 2018 04:12:17 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A20B14A0BB
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Apr 2018 04:12:17 -0400 (EDT)
In-Reply-To: <1523607658-9166-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org
Cc: andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

At the moment KVM supports a single rdist region. We want to
support several separate rdist regions so let's introduce a list
of them. This patch currently only cares about a single
entry in this list as the functionality to register several redist
regions is not yet there. So this only translates the existing code
into something functionally similar using that new data struct.

The redistributor region handle is stored in the vgic_cpu structure
to allow later computation of the TYPER last bit.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 include/kvm/arm_vgic.h              | 14 +++++++++----
 virt/kvm/arm/vgic/vgic-init.c       | 16 ++++++++++++--
 virt/kvm/arm/vgic/vgic-kvm-device.c | 13 ++++++++++--
 virt/kvm/arm/vgic/vgic-mmio-v3.c    | 42 ++++++++++++++++++++++++++++---------
 virt/kvm/arm/vgic/vgic-v3.c         | 20 +++++++++++-------
 5 files changed, 79 insertions(+), 26 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 24f0394..e5c16d1 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -200,6 +200,14 @@ struct vgic_its {
 
 struct vgic_state_iter;
 
+struct vgic_redist_region {
+	uint32_t index;
+	gpa_t base;
+	uint32_t count; /* number of redistributors or 0 if single region */
+	uint32_t free_index; /* index of the next free redistributor */
+	struct list_head list;
+};
+
 struct vgic_dist {
 	bool			in_kernel;
 	bool			ready;
@@ -219,10 +227,7 @@ struct vgic_dist {
 		/* either a GICv2 CPU interface */
 		gpa_t			vgic_cpu_base;
 		/* or a number of GICv3 redistributor regions */
-		struct {
-			gpa_t		vgic_redist_base;
-			gpa_t		vgic_redist_free_offset;
-		};
+		struct list_head rd_regions;
 	};
 
 	/* distributor enabled */
@@ -310,6 +315,7 @@ struct vgic_cpu {
 	 */
 	struct vgic_io_device	rd_iodev;
 	struct vgic_io_device	sgi_iodev;
+	struct vgic_redist_region *rdreg;
 
 	/* Contains the attributes and gpa of the LPI pending tables. */
 	u64 pendbaser;
diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index c52f03d..6456371 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -167,8 +167,11 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	kvm->arch.vgic.vgic_model = type;
 
 	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
-	kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
-	kvm->arch.vgic.vgic_redist_base = VGIC_ADDR_UNDEF;
+
+	if (type == KVM_DEV_TYPE_ARM_VGIC_V2)
+		kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
+	else
+		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 
 out_unlock:
 	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
@@ -303,6 +306,7 @@ int vgic_init(struct kvm *kvm)
 static void kvm_vgic_dist_destroy(struct kvm *kvm)
 {
 	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_redist_region *rdreg, *next;
 
 	dist->ready = false;
 	dist->initialized = false;
@@ -311,6 +315,14 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 	dist->spis = NULL;
 	dist->nr_spis = 0;
 
+	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3) {
+		list_for_each_entry_safe(rdreg, next, &dist->rd_regions, list) {
+			list_del(&rdreg->list);
+			kfree(rdreg);
+		}
+		INIT_LIST_HEAD(&dist->rd_regions);
+	}
+
 	if (vgic_supports_direct_msis(kvm))
 		vgic_v4_teardown(kvm);
 }
diff --git a/virt/kvm/arm/vgic/vgic-kvm-device.c b/virt/kvm/arm/vgic/vgic-kvm-device.c
index 10ae6f3..e7b5a86 100644
--- a/virt/kvm/arm/vgic/vgic-kvm-device.c
+++ b/virt/kvm/arm/vgic/vgic-kvm-device.c
@@ -66,6 +66,7 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 	int r = 0;
 	struct vgic_dist *vgic = &kvm->arch.vgic;
 	phys_addr_t *addr_ptr, alignment;
+	uint64_t undef_value = VGIC_ADDR_UNDEF;
 
 	mutex_lock(&kvm->lock);
 	switch (type) {
@@ -84,7 +85,9 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 		addr_ptr = &vgic->vgic_dist_base;
 		alignment = SZ_64K;
 		break;
-	case KVM_VGIC_V3_ADDR_TYPE_REDIST:
+	case KVM_VGIC_V3_ADDR_TYPE_REDIST: {
+		struct vgic_redist_region *rdreg;
+
 		r = vgic_check_type(kvm, KVM_DEV_TYPE_ARM_VGIC_V3);
 		if (r)
 			break;
@@ -92,8 +95,14 @@ int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool write)
 			r = vgic_v3_set_redist_base(kvm, *addr);
 			goto out;
 		}
-		addr_ptr = &vgic->vgic_redist_base;
+		rdreg = list_first_entry(&vgic->rd_regions,
+					 struct vgic_redist_region, list);
+		if (!rdreg)
+			addr_ptr = &undef_value;
+		else
+			addr_ptr = &rdreg->base;
 		break;
+	}
 	default:
 		r = -ENODEV;
 	}
diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 671fe81..d1aab18 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -580,8 +580,10 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct vgic_dist *vgic = &kvm->arch.vgic;
+	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_io_device *rd_dev = &vcpu->arch.vgic_cpu.rd_iodev;
 	struct vgic_io_device *sgi_dev = &vcpu->arch.vgic_cpu.sgi_iodev;
+	struct vgic_redist_region *rdreg;
 	gpa_t rd_base, sgi_base;
 	int ret;
 
@@ -591,13 +593,17 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 	 * function for all VCPUs when the base address is set.  Just return
 	 * without doing any work for now.
 	 */
-	if (IS_VGIC_ADDR_UNDEF(vgic->vgic_redist_base))
+	rdreg = list_first_entry(&vgic->rd_regions,
+				 struct vgic_redist_region, list);
+	if (!rdreg)
 		return 0;
 
 	if (!vgic_v3_check_base(kvm))
 		return -EINVAL;
 
-	rd_base = vgic->vgic_redist_base + vgic->vgic_redist_free_offset;
+	vgic_cpu->rdreg = rdreg;
+
+	rd_base = rdreg->base + rdreg->free_index * KVM_VGIC_V3_REDIST_SIZE;
 	sgi_base = rd_base + SZ_64K;
 
 	kvm_iodevice_init(&rd_dev->dev, &kvm_io_gic_ops);
@@ -631,7 +637,7 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 		goto out;
 	}
 
-	vgic->vgic_redist_free_offset += 2 * SZ_64K;
+	rdreg->free_index++;
 out:
 	mutex_unlock(&kvm->slots_lock);
 	return ret;
@@ -673,19 +679,31 @@ static int vgic_register_all_redist_iodevs(struct kvm *kvm)
 int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
 {
 	struct vgic_dist *vgic = &kvm->arch.vgic;
+	struct vgic_redist_region *rdreg;
 	int ret;
 
 	/* vgic_check_ioaddr makes sure we don't do this twice */
-	ret = vgic_check_ioaddr(kvm, &vgic->vgic_redist_base, addr, SZ_64K);
-	if (ret)
-		return ret;
-
-	vgic->vgic_redist_base = addr;
-	if (!vgic_v3_check_base(kvm)) {
-		vgic->vgic_redist_base = VGIC_ADDR_UNDEF;
+	if (!list_empty(&vgic->rd_regions))
 		return -EINVAL;
+
+	rdreg = kzalloc(sizeof(*rdreg), GFP_KERNEL);
+	if (!rdreg)
+		return -ENOMEM;
+
+	rdreg->base = VGIC_ADDR_UNDEF;
+
+	ret = vgic_check_ioaddr(kvm, &rdreg->base, addr, SZ_64K);
+	if (ret)
+		goto out;
+
+	rdreg->base = addr;
+	if (!vgic_v3_check_base(kvm)) {
+		ret = -EINVAL;
+		goto out;
 	}
 
+	list_add(&rdreg->list, &vgic->rd_regions);
+
 	/*
 	 * Register iodevs for each existing VCPU.  Adding more VCPUs
 	 * afterwards will register the iodevs when needed.
@@ -695,6 +713,10 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
 		return ret;
 
 	return 0;
+
+out:
+	kfree(rdreg);
+	return ret;
 }
 
 int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index 8195f52..94de6cd 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -418,6 +418,9 @@ bool vgic_v3_check_base(struct kvm *kvm)
 {
 	struct vgic_dist *d = &kvm->arch.vgic;
 	gpa_t redist_size = KVM_VGIC_V3_REDIST_SIZE;
+	struct vgic_redist_region *rdreg =
+		list_first_entry(&d->rd_regions,
+				 struct vgic_redist_region, list);
 
 	redist_size *= atomic_read(&kvm->online_vcpus);
 
@@ -425,18 +428,17 @@ bool vgic_v3_check_base(struct kvm *kvm)
 	    d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE < d->vgic_dist_base)
 		return false;
 
-	if (!IS_VGIC_ADDR_UNDEF(d->vgic_redist_base) &&
-	    d->vgic_redist_base + redist_size < d->vgic_redist_base)
+	if (rdreg && (rdreg->base + redist_size < rdreg->base))
 		return false;
 
 	/* Both base addresses must be set to check if they overlap */
-	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base) ||
-	    IS_VGIC_ADDR_UNDEF(d->vgic_redist_base))
+	if (IS_VGIC_ADDR_UNDEF(d->vgic_dist_base) || !rdreg)
 		return true;
 
-	if (d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE <= d->vgic_redist_base)
+	if (d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE <= rdreg->base)
 		return true;
-	if (d->vgic_redist_base + redist_size <= d->vgic_dist_base)
+
+	if (rdreg->base + redist_size <= d->vgic_dist_base)
 		return true;
 
 	return false;
@@ -446,12 +448,14 @@ int vgic_v3_map_resources(struct kvm *kvm)
 {
 	int ret = 0;
 	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_redist_region *rdreg =
+		list_first_entry(&dist->rd_regions,
+				 struct vgic_redist_region, list);
 
 	if (vgic_ready(kvm))
 		goto out;
 
-	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base) ||
-	    IS_VGIC_ADDR_UNDEF(dist->vgic_redist_base)) {
+	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base) || !rdreg) {
 		kvm_err("Need to set vgic distributor addresses first\n");
 		ret = -ENXIO;
 		goto out;
-- 
2.5.5
