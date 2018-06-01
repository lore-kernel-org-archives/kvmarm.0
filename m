From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 27/33] KVM: arm/arm64: Helper to register a new redistributor
 region
Date: Fri,  1 Jun 2018 16:27:41 +0100
Message-ID: <20180601152747.23613-28-marc.zyngier@arm.com>
References: <20180601152747.23613-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC17E4A197
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jun 2018 11:22:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mmnJ71pu5ZqG for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Jun 2018 11:22:02 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E17BB4A169
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jun 2018 11:18:09 -0400 (EDT)
In-Reply-To: <20180601152747.23613-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

We introduce a new helper that creates and inserts a new redistributor
region into the rdist region list. This helper both handles the case
where the redistributor region size is known at registration time
and the legacy case where it is not (eventually depending on the number
of online vcpus). Depending on pfns, we perform all the possible checks
that we can do:

- end of memory crossing
- incorrect alignment of the base address
- collision with distributor region if already defined
- collision with already registered rdist regions
- check of the new index

Rdist regions must be inserted by increasing order of indices. Indices
must be contiguous.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 89 ++++++++++++++++++++++++++------
 virt/kvm/arm/vgic/vgic.h         |  8 +++
 2 files changed, 81 insertions(+), 16 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index ce5c927fad06..3dbc057f861b 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -680,14 +680,63 @@ static int vgic_register_all_redist_iodevs(struct kvm *kvm)
 	return ret;
 }
 
-int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
+/**
+ * vgic_v3_insert_redist_region - Insert a new redistributor region
+ *
+ * Performs various checks before inserting the rdist region in the list.
+ * Those tests depend on whether the size of the rdist region is known
+ * (ie. count != 0). The list is sorted by rdist region index.
+ *
+ * @kvm: kvm handle
+ * @index: redist region index
+ * @base: base of the new rdist region
+ * @count: number of redistributors the region is made of (0 in the old style
+ * single region, whose size is induced from the number of vcpus)
+ *
+ * Return 0 on success, < 0 otherwise
+ */
+static int vgic_v3_insert_redist_region(struct kvm *kvm, uint32_t index,
+					gpa_t base, uint32_t count)
 {
-	struct vgic_dist *vgic = &kvm->arch.vgic;
+	struct vgic_dist *d = &kvm->arch.vgic;
 	struct vgic_redist_region *rdreg;
+	struct list_head *rd_regions = &d->rd_regions;
+	size_t size = count * KVM_VGIC_V3_REDIST_SIZE;
 	int ret;
 
-	/* vgic_check_ioaddr makes sure we don't do this twice */
-	if (!list_empty(&vgic->rd_regions))
+	/* single rdist region already set ?*/
+	if (!count && !list_empty(rd_regions))
+		return -EINVAL;
+
+	/* cross the end of memory ? */
+	if (base + size < base)
+		return -EINVAL;
+
+	if (list_empty(rd_regions)) {
+		if (index != 0)
+			return -EINVAL;
+	} else {
+		rdreg = list_last_entry(rd_regions,
+					struct vgic_redist_region, list);
+		if (index != rdreg->index + 1)
+			return -EINVAL;
+
+		/* Cannot add an explicitly sized regions after legacy region */
+		if (!rdreg->count)
+			return -EINVAL;
+	}
+
+	/*
+	 * For legacy single-region redistributor regions (!count),
+	 * check that the redistributor region does not overlap with the
+	 * distributor's address space.
+	 */
+	if (!count && !IS_VGIC_ADDR_UNDEF(d->vgic_dist_base) &&
+		vgic_dist_overlap(kvm, base, size))
+		return -EINVAL;
+
+	/* collision with any other rdist region? */
+	if (vgic_v3_rdist_overlap(kvm, base, size))
 		return -EINVAL;
 
 	rdreg = kzalloc(sizeof(*rdreg), GFP_KERNEL);
@@ -696,17 +745,29 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
 
 	rdreg->base = VGIC_ADDR_UNDEF;
 
-	ret = vgic_check_ioaddr(kvm, &rdreg->base, addr, SZ_64K);
+	ret = vgic_check_ioaddr(kvm, &rdreg->base, base, SZ_64K);
 	if (ret)
-		goto out;
+		goto free;
 
-	rdreg->base = addr;
-	if (!vgic_v3_check_base(kvm)) {
-		ret = -EINVAL;
-		goto out;
-	}
+	rdreg->base = base;
+	rdreg->count = count;
+	rdreg->free_index = 0;
+	rdreg->index = index;
 
-	list_add(&rdreg->list, &vgic->rd_regions);
+	list_add_tail(&rdreg->list, rd_regions);
+	return 0;
+free:
+	kfree(rdreg);
+	return ret;
+}
+
+int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
+{
+	int ret;
+
+	ret = vgic_v3_insert_redist_region(kvm, 0, addr, 0);
+	if (ret)
+		return ret;
 
 	/*
 	 * Register iodevs for each existing VCPU.  Adding more VCPUs
@@ -717,10 +778,6 @@ int vgic_v3_set_redist_base(struct kvm *kvm, u64 addr)
 		return ret;
 
 	return 0;
-
-out:
-	kfree(rdreg);
-	return ret;
 }
 
 int vgic_v3_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr)
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index e9f192660097..1c8af4e4131c 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -286,6 +286,14 @@ vgic_v3_rd_region_size(struct kvm *kvm, struct vgic_redist_region *rdreg)
 }
 bool vgic_v3_rdist_overlap(struct kvm *kvm, gpa_t base, size_t size);
 
+static inline bool vgic_dist_overlap(struct kvm *kvm, gpa_t base, size_t size)
+{
+	struct vgic_dist *d = &kvm->arch.vgic;
+
+	return (base + size > d->vgic_dist_base) &&
+		(base < d->vgic_dist_base + KVM_VGIC_V3_DIST_SIZE);
+}
+
 int vgic_its_resolve_lpi(struct kvm *kvm, struct vgic_its *its,
 			 u32 devid, u32 eventid, struct vgic_irq **irq);
 struct vgic_its *vgic_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
-- 
2.17.1
