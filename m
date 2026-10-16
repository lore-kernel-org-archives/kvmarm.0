Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 231BB416853
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792166292; cv=none; b=nByIWu+UbJO/07qKOJ62jN8QgwmDcbgvVqWr/O4o02fYJmi9z3d4BGwQMpfMBteYhaDGZCoEpXT2VNvMuV29HJqNQMs2arvBL/Oa8XNaNBbt9ZsaZHJhwRALYc89QnWQ3JZs7OMKvghKF2lzhPfog5GpGt/WqQNPwzPafPurcxI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792166292; c=relaxed/simple;
	bh=VRcHVMbmC3xrM9vkRi+4PKmUxVTX/6E2cOOmLbHneV8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fbpNoxs2esWRBBUj0jMYxeKTsamOUyWLGDEgRji48YJnPh1Nr8WQkC6LQ5bpPwpUHHP8DAHL++W28K4xNgITwuMPfVCfagc9wdu/ynUbrNSyeBfBt6HZtIOhnwGpv4ERGCaJGv++xPpmTdA6Lj/VbX56ETthelQBvazD2Z8fYN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=bk+567W8; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="bk+567W8"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4CC461516;
	Fri, 16 Oct 2026 08:58:07 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 058123F673;
	Fri, 16 Oct 2026 08:58:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792166290; bh=VRcHVMbmC3xrM9vkRi+4PKmUxVTX/6E2cOOmLbHneV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bk+567W8FwjhG2yGx+uVOWwPx9YYall/QYpM/oMHbLx4kcZrIbkTvmzPK0Eu8caY8
	 smCww59PX6XEkXMDvudmmUDbQ2o8l44RMtpsXGHjQEpgRvyxLy0ycaMQZIdZdYeIcc
	 7UMmE2WONYoiLqes7uBn8mn/IFcqDncUH/74YUKk=
From: Sascha Bischoff <sascha.bischoff@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org
Cc: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	peter.maydell@linaro.org,
	lpieralisi@kernel.org,
	timothy.hayes@arm.com,
	fuad.tabba@linux.dev
Subject: [PATCH 01/16] KVM: arm64: vgic: Split out common LPI allocation
Date: Fri, 16 Oct 2026 16:57:26 +0100
Message-Id: <20261016155741.979985-2-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261016155741.979985-1-sascha.bischoff@arm.com>
References: <20261016155741.979985-1-sascha.bischoff@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The GICv3 ITS code currently owns vgic_add_lpi(), even though the
first half of the helper is not ITS specific. It allocates or finds
the VM-wide vgic_irq object in lpi_xa and initializes the common LPI
state before the GICv3 ITS code reads the property table and pending
state.

GICv5 needs to reuse the same LPI object lifetime and refcounting, but
without inheriting GICv3 ITS policy such as forcing LPIs into Group 1
or reading the GICv3 property table. Move the common allocation and
xarray insertion logic into vgic.c, expose it through vgic.h, and keep
a GICv3 ITS wrapper for the property-table and pending-state
synchronization.

This keeps the GICv3 behaviour unchanged while making the common LPI
storage usable by other VGIC users.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 73 +++++-----------------------------
 arch/arm64/kvm/vgic/vgic.c     | 72 +++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h     |  2 +
 3 files changed, 83 insertions(+), 64 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index e5657cb603567..8e7bee1bae95d 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -66,77 +66,22 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
 		__ret;							\
 	})
 
-/*
- * Creates a new (reference to a) struct vgic_irq for a given LPI.
- * If this LPI is already mapped on another ITS, we increase its refcount
- * and return a pointer to the existing structure.
- * If this is a "new" LPI, we allocate and initialize a new struct vgic_irq.
- * This function returns a pointer to the _unlocked_ structure.
- */
-static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
-				     struct kvm_vcpu *vcpu)
+static struct vgic_irq *vgic_its_add_lpi(struct kvm *kvm, u32 intid,
+					 struct kvm_vcpu *vcpu)
 {
-	struct vgic_dist *dist = &kvm->arch.vgic;
-	struct vgic_irq *irq = vgic_get_irq(kvm, intid), *oldirq;
-	unsigned long flags;
+	struct vgic_irq *irq;
 	int ret;
 
-	/* In this case there is no put, since we keep the reference. */
+	irq = vgic_get_irq(kvm, intid);
 	if (irq)
 		return irq;
 
-	irq = kzalloc_obj(struct vgic_irq, GFP_KERNEL_ACCOUNT);
-	if (!irq)
-		return ERR_PTR(-ENOMEM);
-
-	ret = xa_reserve_irq(&dist->lpi_xa, intid, GFP_KERNEL_ACCOUNT);
-	if (ret) {
-		kfree(irq);
-		return ERR_PTR(ret);
-	}
-
-	INIT_LIST_HEAD(&irq->ap_list);
-	raw_spin_lock_init(&irq->irq_lock);
+	irq = vgic_add_lpi(kvm, intid, vcpu);
+	if (IS_ERR(irq))
+		return irq;
 
-	irq->config = VGIC_CONFIG_EDGE;
-	refcount_set(&irq->refcount, 1);
-	irq->intid = intid;
-	irq->target_vcpu = vcpu;
 	irq->group = 1;
 
-	xa_lock_irqsave(&dist->lpi_xa, flags);
-
-	/*
-	 * There could be a race with another vgic_add_lpi(), so we need to
-	 * check that we don't add a second list entry with the same LPI.
-	 */
-	oldirq = xa_load(&dist->lpi_xa, intid);
-	if (vgic_try_get_irq_ref(oldirq)) {
-		/* Someone was faster with adding this LPI, lets use that. */
-		kfree(irq);
-		irq = oldirq;
-	} else {
-		/*
-		 * The entry is either empty or contains a dead LPI (refcount=0)
-		 * from the deferred release path, pending cleanup by
-		 * vgic_release_deleted_lpis(). Evict and free it if present.
-		 */
-		oldirq = __xa_store(&dist->lpi_xa, intid, irq,
-				    GFP_NOWAIT | __GFP_ACCOUNT);
-		ret = xa_err(oldirq);
-		if (ret) {
-			xa_unlock_irqrestore(&dist->lpi_xa, flags);
-			kfree(irq);
-
-			return ERR_PTR(ret);
-		}
-
-		if (oldirq && !WARN_ON_ONCE(refcount_read(&oldirq->refcount)))
-			kfree_rcu(oldirq, rcu);
-	}
-
-	xa_unlock_irqrestore(&dist->lpi_xa, flags);
-
 	/*
 	 * We "cache" the configuration table entries in our struct vgic_irq's.
 	 * However we only have those structs for mapped IRQs, so we read in
@@ -1092,7 +1037,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	if (its_is_collection_mapped(collection))
 		vcpu = collection_to_vcpu(kvm, collection);
 
-	irq = vgic_add_lpi(kvm, lpi_nr, vcpu);
+	irq = vgic_its_add_lpi(kvm, lpi_nr, vcpu);
 	if (IS_ERR(irq)) {
 		if (new_coll)
 			vgic_its_free_collection(its, coll_id);
@@ -2203,7 +2148,7 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 	if (its_is_collection_mapped(collection))
 		vcpu = kvm_get_vcpu_by_id(kvm, collection->target_addr);
 
-	irq = vgic_add_lpi(kvm, lpi_id, vcpu);
+	irq = vgic_its_add_lpi(kvm, lpi_id, vcpu);
 	if (IS_ERR(irq)) {
 		its_free_ite(kvm, ite);
 		return PTR_ERR(irq);
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index c2726d4c06e6e..bc0171c479a95 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -79,6 +79,78 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u32 intid)
 	return irq;
 }
 
+/*
+ * Creates a new (reference to a) struct vgic_irq for a given LPI.
+ * If this LPI already exists, we increase its refcount and return it.
+ * If this is a "new" LPI, we allocate and initialize a new struct vgic_irq.
+ * This function returns a pointer to the _unlocked_ structure.
+ */
+struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
+			      struct kvm_vcpu *vcpu)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_irq *irq = vgic_get_irq(kvm, intid), *oldirq;
+	unsigned long flags;
+	int ret;
+
+	/* In this case there is no put, since we keep the reference. */
+	if (irq)
+		return irq;
+
+	irq = kzalloc_obj(struct vgic_irq, GFP_KERNEL_ACCOUNT);
+	if (!irq)
+		return ERR_PTR(-ENOMEM);
+
+	ret = xa_reserve_irq(&dist->lpi_xa, intid, GFP_KERNEL_ACCOUNT);
+	if (ret) {
+		kfree(irq);
+		return ERR_PTR(ret);
+	}
+
+	INIT_LIST_HEAD(&irq->ap_list);
+	raw_spin_lock_init(&irq->irq_lock);
+
+	irq->config = VGIC_CONFIG_EDGE;
+	refcount_set(&irq->refcount, 1);
+	irq->intid = intid;
+	irq->target_vcpu = vcpu;
+
+	xa_lock_irqsave(&dist->lpi_xa, flags);
+
+	/*
+	 * There could be a race with another vgic_add_lpi(), so we need to
+	 * check that we don't add a second list entry with the same LPI.
+	 */
+	oldirq = xa_load(&dist->lpi_xa, intid);
+	if (vgic_try_get_irq_ref(oldirq)) {
+		/* Someone was faster with adding this LPI, lets use that. */
+		kfree(irq);
+		irq = oldirq;
+	} else {
+		/*
+		 * The entry is either empty or contains a dead LPI (refcount=0)
+		 * from the deferred release path, pending cleanup by
+		 * vgic_release_deleted_lpis(). Evict and free it if present.
+		 */
+		oldirq = __xa_store(&dist->lpi_xa, intid, irq,
+				    GFP_NOWAIT | __GFP_ACCOUNT);
+		ret = xa_err(oldirq);
+		if (ret) {
+			xa_unlock_irqrestore(&dist->lpi_xa, flags);
+			kfree(irq);
+
+			return ERR_PTR(ret);
+		}
+
+		if (oldirq && !WARN_ON_ONCE(refcount_read(&oldirq->refcount)))
+			kfree_rcu(oldirq, rcu);
+	}
+
+	xa_unlock_irqrestore(&dist->lpi_xa, flags);
+
+	return irq;
+}
+
 /*
  * This looks up the virtual interrupt ID to get the corresponding
  * struct vgic_irq. It also increases the refcount, so any caller is expected
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 97fc3bdf520e5..c33cdd7098df5 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -280,6 +280,8 @@ vgic_get_mmio_region(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
 		     gpa_t addr, int len);
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid);
 struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid);
+struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
+			      struct kvm_vcpu *vcpu);
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
 struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq);
 bool vgic_get_phys_line_level(struct vgic_irq *irq);
-- 
2.34.1

