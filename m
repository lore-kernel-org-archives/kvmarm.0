Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793648710;
	b=Yc0h+vNRitaj2/n6eCNQwmCFzM6MH0LIq/H+7QM30Gb93i4cNLPpRR43XRYXQkj82O5U
	 jcPDQMdCymJVKAAxQ4cdRXFlbSji4aSwPDEPIoj5Emp85LSZVH93LnrWv6mlXG6wh2sIJ
	 royrkLVMkaGNuBtNTaPkpmA8S/uYJQj/ejKBmQfXYPt73uPpbFMuJIe9cXRdFL9kmiM2Z
	 gohsM+VtV3owkRNM3y1VfhrctkqBbQKuNlSWpx6XaV6vx4nu7VnOkd9AkiNdswmJzvhpE
	 ATdQcNjMLYfSDTU5Akv5c7UP2iujkj7yMDH6Fax32eiD7f5TtH6xtuQeUtv0w3/JLRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793648710;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=3ygiqX61PrFH9HwNeh9XfilPxDP9qCP4o+ydEiPw9Bk=;
	b=PSIqf4iTecAO/4cemMZyssmtzwSlgv2yxRzlP+zBAh61d6ws6PvWChh4bNOype4vOvAo
	 rHE9t+qdhYboZIRjg2edLa1jGmdauRg4oWOjHGbdpMAIgKPR98yrwHMwk1psWUjbWUMnN
	 JVs7wGcAL6dE7Y0wmp+mmtG43WLXVSsgPb06nsdewwzRkLofx74Xralzph90tn+4b6S5/
	 nVR2rebWVeztftSnSWwtp4r15XIR3EbOGgi4AsFIMF9e/9Mh9ErRMfJMsoLPC9sWmQlGF
	 q2Ib7JvF4x7spqY1n7/D3aWW6khN8cPmKXEJiQY6rBqRYPtvWV8BY2d9ls2xHozzw9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Jz5k6nBm;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86BD1606A334
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 19:45:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 86BD1606A334
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=Jz5k6nBm
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF3A3175D;
	Mon,  2 Nov 2026 11:45:04 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 21A643F673;
	Mon,  2 Nov 2026 11:45:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793648707; bh=ZuYr6qVTm1wwSQygOFIq7lWk/77FuQwOyMFBHE73dr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jz5k6nBm/Xaq84x/5pG9Jfi3QGvXwl4d+Y5Xadru0YNR8EzOD8+0iUUG708It8KxS
	 wsm0+/5Xv39qyMuk+f2ec0y0lFI6LSwJrnU/m/nRaNiEOu/Xb4doLl/XXXav2RI1rP
	 puR2xt/SkYk/AdDo5gJ3f7XHc4PlOf7HzZtiXvDI=
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
Subject: [PATCH v2 01/16] KVM: arm64: vgic: Split out common LPI allocation
Date: Mon,  2 Nov 2026 19:44:39 +0000
Message-Id: <20261102194454.4086911-2-sascha.bischoff@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261102194454.4086911-1-sascha.bischoff@arm.com>
References: <20261102194454.4086911-1-sascha.bischoff@arm.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The GICv3 ITS code currently owns vgic_add_lpi(), even though the
first half of the helper is not ITS specific. It allocates or finds
the VM-wide vgic_irq object in lpi_xa and initialises the common LPI
state before the GICv3 ITS code reads the property table and pending
state.

GICv5 needs to reuse the same LPI object lifetime and refcounting, but
without reading the GICv3 property table. Move the allocation and
xarray insertion path into vgic_alloc_lpi() in vgic.c. Both
vgic_add_lpi() and the GICv3 ITS wrapper perform an initial lookup,
then call this helper on a miss. The ITS wrapper continues to load the
property and pending state, while GICv5 can use the common allocator
without GICv3 setup.

Keeping the lookup outside vgic_alloc_lpi() preserves GICv3 behaviour
when another caller inserts the LPI during allocation: the ITS wrapper
still performs its setup on the returned LPI. A second lookup inside
the allocator could instead treat it as already initialised and skip
that setup.

Initialise LPIs as Group 1 before publishing them in lpi_xa. GICv3
LPIs are Group 1, and another vCPU can find a new LPI as soon as it is
published. GICv5 does not use the group field.

This preserves the intended GICv3 behaviour while making the common
LPI storage usable by other VGIC users.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-its.c | 75 ++++---------------------------
 arch/arm64/kvm/vgic/vgic.c     | 82 ++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.h     |  4 ++
 3 files changed, 95 insertions(+), 66 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index 7e9b265b1f521..34c1c89bfbfe1 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -66,76 +66,19 @@ static int update_lpi_config(struct kvm *kvm, struct vgic_irq *irq,
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
-
-	irq->config = VGIC_CONFIG_EDGE;
-	refcount_set(&irq->refcount, 1);
-	irq->intid = intid;
-	irq->target_vcpu = vcpu;
-	irq->group = 1;
-
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
+	irq = vgic_alloc_lpi(kvm, intid, vcpu);
+	if (IS_ERR(irq))
+		return irq;
 
 	/*
 	 * We "cache" the configuration table entries in our struct vgic_irq's.
@@ -1133,7 +1076,7 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
 	if (its_is_collection_mapped(collection))
 		vcpu = collection_to_vcpu(kvm, collection);
 
-	irq = vgic_add_lpi(kvm, lpi_nr, vcpu);
+	irq = vgic_its_add_lpi(kvm, lpi_nr, vcpu);
 	if (!IS_ERR(irq) && !vgic_its_map_lpi(kvm, ite, irq, vcpu))
 		irq = ERR_PTR(-EEXIST);
 	if (IS_ERR(irq)) {
@@ -2269,7 +2212,7 @@ static int vgic_its_restore_ite(struct vgic_its *its, u32 event_id,
 	if (its_is_collection_mapped(collection))
 		vcpu = kvm_get_vcpu_by_id(kvm, collection->target_addr);
 
-	irq = vgic_add_lpi(kvm, lpi_id, vcpu);
+	irq = vgic_its_add_lpi(kvm, lpi_id, vcpu);
 	if (IS_ERR(irq)) {
 		its_free_ite(kvm, ite);
 		return PTR_ERR(irq);
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index bea848c93a990..d1a1a2cea386e 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -79,6 +79,88 @@ static struct vgic_irq *vgic_get_lpi(struct kvm *kvm, u32 intid)
 	return irq;
 }
 
+/* Allocate an LPI or acquire one inserted by a concurrent caller. */
+struct vgic_irq *vgic_alloc_lpi(struct kvm *kvm, u32 intid,
+				struct kvm_vcpu *vcpu)
+{
+	struct vgic_dist *dist = &kvm->arch.vgic;
+	struct vgic_irq *irq, *oldirq;
+	unsigned long flags;
+	int ret;
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
+	irq->group = 1;
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
+/*
+ * Creates a new (reference to a) struct vgic_irq for a given LPI.
+ * If this LPI already exists, we increase its refcount and return it.
+ * If this is a "new" LPI, we allocate and initialize a new struct vgic_irq.
+ * This function returns a pointer to the _unlocked_ structure.
+ */
+struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
+			      struct kvm_vcpu *vcpu)
+{
+	struct vgic_irq *irq = vgic_get_irq(kvm, intid);
+
+	/* In this case there is no put, since we keep the reference. */
+	if (irq)
+		return irq;
+
+	return vgic_alloc_lpi(kvm, intid, vcpu);
+}
+
 /*
  * This looks up the virtual interrupt ID to get the corresponding
  * struct vgic_irq. It also increases the refcount, so any caller is expected
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 97fc3bdf520e5..8792953057bb7 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -280,6 +280,10 @@ vgic_get_mmio_region(struct kvm_vcpu *vcpu, struct vgic_io_device *iodev,
 		     gpa_t addr, int len);
 struct vgic_irq *vgic_get_irq(struct kvm *kvm, u32 intid);
 struct vgic_irq *vgic_get_vcpu_irq(struct kvm_vcpu *vcpu, u32 intid);
+struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
+			      struct kvm_vcpu *vcpu);
+struct vgic_irq *vgic_alloc_lpi(struct kvm *kvm, u32 intid,
+				struct kvm_vcpu *vcpu);
 void vgic_put_irq(struct kvm *kvm, struct vgic_irq *irq);
 struct kvm_vcpu *vgic_target_oracle(struct vgic_irq *irq);
 bool vgic_get_phys_line_level(struct vgic_irq *irq);
-- 
2.34.1

