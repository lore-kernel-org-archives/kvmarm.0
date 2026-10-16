Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F22634E13FB
	for <kvmarm@lists.linux.dev>; Fri, 16 Oct 2026 15:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792166396; cv=none; b=RBM0yCn92n1V6hrI4RNCckCIvIzblurpo23TuqpZu9nQmF/jUN8fEI8iZ2smZq3rhKjf8W+z7L1indKTNvqqUjqrZdVzmdzOOslSVzbVzfY34daXhB5hoX3C4/3PPSo00rskiSfZkb5kZyrYZ0+DlOYjppcTQTrhuNuac8swXB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792166396; c=relaxed/simple;
	bh=cU7zI8snHMqhPF1kf8oDbGPNrhrBxAXCnCrVu3HFSfg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VPAOC2XsG8U/Lde4TGhojDNL8aY0Fmp8Q/b/XHU7CyV3/Lmwf2LBOW7vcgPw5vVn2Gqmjx+xUH2SVK4NlkV16zWixqbh4Y+4Rcc9NIrNFBzC0ZVvqbg0jKWf7zjJu4Xs8loter+VXwaacfJFZCZluWd8pkKGHk8CEEagHPjGPPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=MtFzPKTM; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="MtFzPKTM"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2F6331516;
	Fri, 16 Oct 2026 08:59:51 -0700 (PDT)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 996A03F673;
	Fri, 16 Oct 2026 08:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792166394; bh=cU7zI8snHMqhPF1kf8oDbGPNrhrBxAXCnCrVu3HFSfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MtFzPKTMzwMErkk5D12Rg+92aBeM8s7F1Sao5QU93eqVEy01yXSzlYPSuCVk3+vYY
	 cvLNVsyU1uzCh+/oGd0HRHQTtjECtznkhxwpUGyHnztqgEe1nKN3fl7CDTQoDqE1DX
	 6+us53TJ173a5VbxN2VTdEEH9e2Jd//lJ/Ta+QTA=
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
Subject: [PATCH 13/16] KVM: arm64: gic-v5: Implement irq forwarding
Date: Fri, 16 Oct 2026 16:57:38 +0100
Message-Id: <20261016155741.979985-14-sascha.bischoff@arm.com>
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

GICv5, like GICv4, supports direct injection of interrupts via the
ITS. Move the existing GICv4 interface behind a common shim that selects
the appropriate implementation. For GICv5 forwarding, the ITS driver
replaces a host ITTE with one targeting a guest. The host no longer
receives that interrupt until forwarding is removed and the host ITTE is
restored.

A guest can make multiple DeviceID/EventID pairs resolve to the same
LPI, even though it should not. Track the cache entry responsible for
direct injection, and let only that entry tear it down during guest
invalidation. Explicitly unforwarding an IRQ clears the owner without
removing the cached translation.

The ITS driver writes the virtual ITTE before invalidating its cache.
If invalidation times out, attempt to restore the host ITTE before
falling back to software injection. If the restoration also times out,
keep the host IRQ association and a separate LPI reference so
unforwarding can be retried even after the guest invalidates the
translation. Clear KVM's forwarding state only after the host ITTE has
been restored.

Forwarding can be set up from another process's address space through
IRQ bypass. A cache miss in this path must still walk the guest's DT and
ITT. Read the entries from the VM's mm using access_remote_vm() when
the caller does not have that mm. Hold an mm reference and protect the
memslot lookup with SRCU, and fail the lookup on a short read.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/arm.c              |   6 +-
 arch/arm64/kvm/vgic/vgic-its-v5.c | 122 +++++++++++++++++++-----
 arch/arm64/kvm/vgic/vgic-mmio.c   |  10 +-
 arch/arm64/kvm/vgic/vgic-v5.c     | 148 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic.c        |  17 ++++
 arch/arm64/kvm/vgic/vgic.h        |   8 ++
 include/kvm/arm_vgic.h            |  11 +++
 7 files changed, 296 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index d593ba9280933..2d9b2bc8f0c45 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -3171,7 +3171,7 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 	if (irq_entry->type != KVM_IRQ_ROUTING_MSI)
 		return 0;
 
-	return kvm_vgic_v4_set_forwarding(irqfd->kvm, prod->irq,
+	return kvm_vgic_set_forwarding(irqfd->kvm, prod->irq,
 					  &irqfd->irq_entry);
 }
 
@@ -3185,7 +3185,7 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	if (irq_entry->type != KVM_IRQ_ROUTING_MSI)
 		return;
 
-	kvm_vgic_v4_unset_forwarding(irqfd->kvm, prod->irq);
+	kvm_vgic_unset_forwarding(irqfd->kvm, prod->irq);
 }
 
 void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
@@ -3204,7 +3204,7 @@ void kvm_arch_update_irqfd_routing(struct kvm_kernel_irqfd *irqfd,
 	 *
 	 * Unmap the vLPI and fall back to software LPI injection.
 	 */
-	return kvm_vgic_v4_unset_forwarding(irqfd->kvm, irqfd->producer->irq);
+	kvm_vgic_unset_forwarding(irqfd->kvm, irqfd->producer->irq);
 }
 
 void kvm_arch_irq_bypass_stop(struct irq_bypass_consumer *cons)
diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic-its-v5.c
index 62c1ca8004007..e71cd67652bae 100644
--- a/arch/arm64/kvm/vgic/vgic-its-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
@@ -5,6 +5,7 @@
 
 #include <linux/kthread.h>
 #include <linux/kvm_host.h>
+#include <linux/mm.h>
 #include <linux/sched/mm.h>
 #include <linux/slab.h>
 
@@ -31,7 +32,41 @@ static void its_cache_drop_translation(struct kvm *kvm,
 				       struct its_cache_translation_entry *entry)
 {
 	struct vgic_irq *irq = entry->irq;
+	unsigned long flags;
+	int virq = 0;
+	bool hw = false;
+	bool drop_forwarding_ref = false;
 
+	/*
+	 * Multiple translations can share an LPI as we have no way of stopping
+	 * the guest from doing so. Only the entry associated with direct injection
+	 * may tear down the IRQ's forwarding state, as otherwise we can end up
+	 * accidentally tearing something down. Realistically, this only would
+	 * result in a performance degradation, but we might as well avoid that
+	 * in the first place if we can.
+	 */
+	raw_spin_lock_irqsave(&irq->irq_lock, flags);
+	if (irq->forwarding_owner == entry) {
+		/* The entry is about to be freed, even if unforwarding fails. */
+		irq->forwarding_owner = NULL;
+		virq = irq->host_irq;
+		hw = irq->hw;
+	}
+	raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+
+	if (hw && !WARN_ON_ONCE(gicv5_its_disable_direct_injection(virq))) {
+		raw_spin_lock_irqsave(&irq->irq_lock, flags);
+		if (irq->hw && irq->host_irq == virq &&
+		    !irq->forwarding_owner) {
+			irq->hw = false;
+			irq->host_irq = 0;
+			drop_forwarding_ref = true;
+		}
+		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
+	}
+
+	if (drop_forwarding_ref)
+		vgic_put_irq(kvm, irq);
 	vgic_put_irq(kvm, irq);
 	kfree(entry);
 }
@@ -50,7 +85,8 @@ static void its_cache_drop_removed_translations(struct kvm *kvm,
 
 static int its_cache_add_translation(struct kvm *kvm, struct vgic_v5_its *its,
 				     u32 device_id, u16 event_id,
-				     struct vgic_irq *irq)
+				     struct vgic_irq *irq,
+				     void **owner)
 {
 	u64 key = ((u64)device_id << 16) | (u64)event_id;
 	struct its_cache_translation_entry *entry;
@@ -78,6 +114,8 @@ static int its_cache_add_translation(struct kvm *kvm, struct vgic_v5_its *its,
 	}
 
 	its_cache_drop_removed_translations(kvm, &removed);
+	if (owner)
+		*owner = entry;
 
 	return 0;
 }
@@ -129,7 +167,8 @@ static void its_cache_clear_translations(struct vgic_v5_its *its)
 
 static int its_cache_look_up_translation(struct vgic_v5_its *its,
 					 u32 device_id, u16 event_id,
-					 struct vgic_irq **irq)
+					 struct vgic_irq **irq,
+					 void **owner)
 {
 	u64 key = ((u64)device_id << 16) | (u64)event_id;
 	struct its_cache_translation_entry *entry;
@@ -142,6 +181,8 @@ static int its_cache_look_up_translation(struct vgic_v5_its *its,
 				return -ENXIO;
 
 			*irq = entry->irq;
+			if (owner)
+				*owner = entry;
 			return 0;
 		}
 	}
@@ -287,6 +328,37 @@ static void its_cache_handle_inv_eventr(struct vgic_v5_its *its)
 					       itt_l2sz);
 }
 
+static int vgic_v5_its_read_entry(struct kvm *kvm, gpa_t gpa, __le64 *entry)
+{
+	struct mm_struct *mm = kvm->mm;
+	unsigned long hva;
+	int srcu_idx, ret;
+
+	if (current->mm == mm)
+		return kvm_read_guest_lock(kvm, gpa, entry, sizeof(*entry));
+
+	/* Forwarding setup can run in the IRQ producer's address space. */
+	if (!mmget_not_zero(mm))
+		return -EFAULT;
+
+	srcu_idx = srcu_read_lock(&kvm->srcu);
+	hva = gfn_to_hva_prot(kvm, gpa >> PAGE_SHIFT, NULL);
+	if (kvm_is_error_hva(hva)) {
+		ret = -EFAULT;
+		goto out;
+	}
+
+	/* Table entries are 8-byte aligned, so each read fits in one page. */
+	ret = access_remote_vm(mm, hva + offset_in_page(gpa), entry,
+			       sizeof(*entry), 0);
+
+out:
+	srcu_read_unlock(&kvm->srcu, srcu_idx);
+	mmput(mm);
+
+	return ret == sizeof(*entry) ? 0 : -EFAULT;
+}
+
 static int parse_linear_dt(struct kvm *kvm, gpa_t dt_base, u32 device_id,
 			   gpa_t *itt_base, bool *two_level_itt,
 			   unsigned int *event_id_bits, unsigned int *itt_l2sz)
@@ -297,8 +369,7 @@ static int parse_linear_dt(struct kvm *kvm, gpa_t dt_base, u32 device_id,
 	int ret;
 
 	entry_addr = dt_base + device_id * sizeof(__le64);
-	ret = kvm_read_guest_lock(kvm, entry_addr, &dt_l2_entry,
-				  sizeof(dt_l2_entry));
+	ret = vgic_v5_its_read_entry(kvm, entry_addr, &dt_l2_entry);
 	if (ret) {
 		kvm_debug("Failed to read guest memory for L2 DT\n");
 		return ret;
@@ -348,8 +419,7 @@ static int parse_two_level_dt(struct kvm *kvm, gpa_t dt_base,
 	entry_addr = dt_base +
 		     (device_id >> device_id_l1_shift) * sizeof(__le64);
 
-	ret = kvm_read_guest_lock(kvm, entry_addr, &dt_l1_entry,
-				  sizeof(dt_l1_entry));
+	ret = vgic_v5_its_read_entry(kvm, entry_addr, &dt_l1_entry);
 	if (ret) {
 		kvm_debug("Failed to read guest memory for L1 DT\n");
 		return ret;
@@ -405,8 +475,7 @@ static int parse_linear_itt(struct kvm *kvm, u32 event_id, gpa_t itt_base,
 	gpa_t entry_addr = itt_base + event_id * sizeof(*itt_l2_entry);
 	int ret;
 
-	ret = kvm_read_guest_lock(kvm, entry_addr, itt_l2_entry,
-				  sizeof(*itt_l2_entry));
+	ret = vgic_v5_its_read_entry(kvm, entry_addr, itt_l2_entry);
 	if (ret)
 		kvm_debug("Failed to read guest memory for L2 ITT\n");
 
@@ -439,8 +508,7 @@ static int parse_two_level_itt(struct kvm *kvm, u32 event_id, gpa_t itt_base,
 
 	l1_event_id = event_id >> itt_split_bits;
 	entry_addr = itt_base + l1_event_id * sizeof(itt_l1_entry);
-	ret = kvm_read_guest_lock(kvm, entry_addr, &itt_l1_entry,
-				  sizeof(itt_l1_entry));
+	ret = vgic_v5_its_read_entry(kvm, entry_addr, &itt_l1_entry);
 	if (ret) {
 		kvm_debug("Failed to read guest memory for L1 ITT\n");
 		return ret;
@@ -516,7 +584,8 @@ struct vgic_v5_its *vgic_v5_msi_to_its(struct kvm *kvm, struct kvm_msi *msi)
 
 static int __vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its *its,
 				     u32 device_id, u32 event_id,
-				     struct vgic_irq **irq)
+				     struct vgic_irq **irq,
+				     void **owner)
 {
 	unsigned int itt_l2sz, event_id_bits;
 	__le64 itt_l2_entry;
@@ -535,13 +604,11 @@ static int __vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its *its,
 		return -ENXIO;
 	}
 
-	ret = its_cache_look_up_translation(its, device_id, (u16)event_id, irq);
+	ret = its_cache_look_up_translation(its, device_id, (u16)event_id, irq,
+					    owner);
 	if (!ret)
 		return 0;
 
-	if (WARN_ON_ONCE(kvm->mm != get_current()->mm))
-		return -EWOULDBLOCK;
-
 	ret = get_itt(kvm, its, device_id, &itt_base, &two_level_itt,
 		      &event_id_bits, &itt_l2sz);
 	if (ret) {
@@ -572,8 +639,8 @@ static int __vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its *its,
 		return PTR_ERR(*irq);
 
 	vgic_get_irq_ref(*irq);
-	ret = its_cache_add_translation(kvm, its, device_id, (u16)event_id,
-					 *irq);
+	ret = its_cache_add_translation(kvm, its, device_id, (u16)event_id, *irq,
+					owner);
 	if (ret) {
 		vgic_put_irq(kvm, *irq);
 		vgic_put_irq(kvm, *irq);
@@ -583,13 +650,24 @@ static int __vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its *its,
 	return ret;
 }
 
+int vgic_v5_its_resolve_lpi_locked(struct kvm *kvm,
+				   struct vgic_v5_its *its,
+				   u32 device_id, u32 event_id,
+				   struct vgic_irq **irq,
+				   void **owner)
+{
+	return __vgic_v5_its_resolve_lpi(kvm, its, device_id, event_id, irq,
+					 owner);
+}
+
 int vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its *its,
 			    u32 device_id, u32 event_id,
 			    struct vgic_irq **irq)
 {
 	guard(mutex)(&its->its_lock);
 
-	return __vgic_v5_its_resolve_lpi(kvm, its, device_id, event_id, irq);
+	return __vgic_v5_its_resolve_lpi(kvm, its, device_id, event_id, irq,
+					 NULL);
 }
 
 static void vgic_v5_its_inject_lpi(struct kvm *kvm, struct vgic_irq *irq)
@@ -657,8 +735,8 @@ int vgic_v5_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi)
 	if (!READ_ONCE(its->enabled))
 		return -EWOULDBLOCK;
 
-	ret = its_cache_look_up_translation(its, msi->devid, (u16)msi->data,
-					    &irq);
+	ret = its_cache_look_up_translation(its, msi->devid, (u16)msi->data, &irq,
+					    NULL);
 	if (ret)
 		return -EWOULDBLOCK;
 
@@ -680,7 +758,7 @@ static void vgic_v5_its_handle_read_event(struct kvm *kvm,
 	its->read_event_datar.virt = false;
 
 	ret = __vgic_v5_its_resolve_lpi(kvm, its, its->didr.device_id,
-					its->eidr.event_id, &irq);
+					its->eidr.event_id, &irq, NULL);
 	if (ret)
 		return;
 
@@ -704,7 +782,7 @@ static void vgic_v5_its_handle_gen_event(struct kvm *kvm,
 
 	ret = __vgic_v5_its_resolve_lpi(kvm, its,
 					its->gen_event_didr.device_id,
-					its->gen_event_eidr.event_id, &irq);
+					its->gen_event_eidr.event_id, &irq, NULL);
 	if (ret)
 		return;
 
diff --git a/arch/arm64/kvm/vgic/vgic-mmio.c b/arch/arm64/kvm/vgic/vgic-mmio.c
index 44f4a7f33fa3e..ca57275f87f67 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio.c
@@ -1144,6 +1144,8 @@ int vgic_register_dist_iodev(struct kvm *kvm, gpa_t dist_base_address,
 
 bool vgic_supports_direct_msis(struct kvm *kvm)
 {
+	const struct vgic_dist *dist = &kvm->arch.vgic;
+
 	/*
 	 * Deliberately conflate vLPI and vSGI support on GICv4.1 hardware,
 	 * indirectly allowing userspace to control whether or not vPEs are
@@ -1152,7 +1154,13 @@ bool vgic_supports_direct_msis(struct kvm *kvm)
 	if (system_supports_direct_sgis() && !vgic_supports_direct_sgis(kvm))
 		return false;
 
-	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
+	if (kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm))
+		return true;
+	if (kvm_vgic_global_state.type == VGIC_V5 && vgic_has_its(kvm) &&
+	    dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V5)
+		return true;
+
+	return false;
 }
 
 bool vgic_has_its(struct kvm *kvm)
diff --git a/arch/arm64/kvm/vgic/vgic-v5.c b/arch/arm64/kvm/vgic/vgic-v5.c
index c90e00f56b298..970df3f41cf24 100644
--- a/arch/arm64/kvm/vgic/vgic-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-v5.c
@@ -1660,3 +1660,151 @@ int vgic_v5_check_msi(struct kvm *kvm, struct kvm_msi *msi)
 
 	return 0;
 }
+
+static struct vgic_v5_its *
+vgic_v5_get_its(struct kvm *kvm, struct kvm_kernel_irq_routing_entry *irq_entry)
+{
+	struct kvm_msi msi = (struct kvm_msi){
+		.address_lo = irq_entry->msi.address_lo,
+		.address_hi = irq_entry->msi.address_hi,
+		.data = irq_entry->msi.data,
+		.flags = irq_entry->msi.flags,
+		.devid = irq_entry->msi.devid,
+	};
+
+	return vgic_v5_msi_to_its(kvm, &msi);
+}
+
+int kvm_vgic_v5_set_forwarding(struct kvm *kvm, int virq,
+			       struct kvm_kernel_irq_routing_entry *irq_entry)
+{
+	struct vgic_v5_its *its_data;
+	struct vgic_irq *irq;
+	void *owner;
+	bool hw;
+	int ret;
+
+	if (!vgic_has_its(kvm))
+		return 0;
+
+	/* Look up the ITS; bail out if we can't look it up */
+	its_data = vgic_v5_get_its(kvm, irq_entry);
+	if (IS_ERR(its_data))
+		return 0;
+
+	/*
+	 * Look up and cache the translation. Bail out if we failed to look up
+	 * the translation at this stage. If the translation becomes valid at a
+	 * later stage, we should fall back to software-based injection.
+	 */
+	guard(mutex)(&its_data->its_lock);
+
+	ret = vgic_v5_its_resolve_lpi_locked(kvm, its_data,
+					     irq_entry->msi.devid,
+					     irq_entry->msi.data, &irq, &owner);
+	if (ret)
+		return 0;
+
+	scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+		hw = irq->hw;
+	}
+
+	if (hw)
+		goto out_put_irq;
+
+	ret = gicv5_its_enable_direct_injection(virq, vgic_v5_vm_id(kvm),
+						vgic_v5_get_hwirq_id(irq->intid));
+	if (ret) {
+		if (ret != -ETIMEDOUT)
+			goto out_put_irq;
+
+		/* The ITTE was written; confirm restoration before falling back. */
+		if (!gicv5_its_disable_direct_injection(virq))
+			goto out_put_irq;
+
+		/* Keep the host IRQ association so a later unforward can retry. */
+		ret = 0;
+	}
+
+	scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+		if (!irq->hw) {
+			/* Keep the LPI available if invalidation must retry unforwarding. */
+			vgic_get_irq_ref(irq);
+			irq->hw = true;
+			irq->host_irq = virq;
+			/*
+			 * Record the entry responsible for this host IRQ, even if
+			 * cleanup after a failed sync is still pending. Only this
+			 * entry may unforward on invalidation; another translation
+			 * could map to the same LPI.
+			 */
+			irq->forwarding_owner = owner;
+		} else {
+			ret = -EBUSY;
+		}
+	}
+
+	if (ret)
+		WARN_ON_ONCE(gicv5_its_disable_direct_injection(virq));
+
+out_put_irq:
+	vgic_put_irq(kvm, irq);
+
+	return 0;
+}
+
+static struct vgic_irq *vgic_v5_host_irq_get_lpi(struct kvm *kvm, int host_irq)
+{
+	struct vgic_irq *irq;
+	unsigned long idx;
+
+	guard(rcu)();
+	xa_for_each(&kvm->arch.vgic.lpi_xa, idx, irq) {
+		if (!irq->hw || irq->host_irq != host_irq)
+			continue;
+
+		if (!vgic_try_get_irq_ref(irq))
+			return NULL;
+
+		return irq;
+	}
+
+	return NULL;
+}
+
+void kvm_vgic_v5_unset_forwarding(struct kvm *kvm, int virq)
+{
+	struct vgic_irq *irq;
+	bool drop_forwarding_ref = false;
+
+	if (!vgic_has_its(kvm))
+		return;
+
+	/*
+	 * Note: We don't remove the entry from our translation cache here. It
+	 * is up to the guest to invalidate the old translations, and hence the
+	 * removal path is tied into ITS_INV_DEVICER and ITS_INV_EVENTR, rather
+	 * than being explicitly called here.
+	 */
+	irq = vgic_v5_host_irq_get_lpi(kvm, virq);
+	if (!irq)
+		return;
+
+	if (WARN_ON_ONCE(gicv5_its_disable_direct_injection(virq)))
+		goto out_put_irq;
+
+	scoped_guard(raw_spinlock_irqsave, &irq->irq_lock) {
+		if (irq->hw && irq->host_irq == virq) {
+			irq->hw = false;
+			irq->host_irq = 0;
+			irq->forwarding_owner = NULL;
+			drop_forwarding_ref = true;
+		}
+	}
+
+	if (drop_forwarding_ref)
+		vgic_put_irq(kvm, irq);
+
+out_put_irq:
+	vgic_put_irq(kvm, irq);
+}
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index bc0171c479a95..ea5ed49080cd8 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -1439,3 +1439,20 @@ void vgic_irq_handle_resampling(struct vgic_irq *irq,
 			vgic_irq_set_phys_active(irq, false);
 	}
 }
+
+int kvm_vgic_set_forwarding(struct kvm *kvm, int irq,
+			    struct kvm_kernel_irq_routing_entry *irq_entry)
+{
+	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V5)
+		return kvm_vgic_v5_set_forwarding(kvm, irq, irq_entry);
+	else
+		return kvm_vgic_v4_set_forwarding(kvm, irq, irq_entry);
+}
+
+void kvm_vgic_unset_forwarding(struct kvm *kvm, int irq)
+{
+	if (kvm->arch.vgic.vgic_model == KVM_DEV_TYPE_ARM_VGIC_V5)
+		kvm_vgic_v5_unset_forwarding(kvm, irq);
+	else
+		kvm_vgic_v4_unset_forwarding(kvm, irq);
+}
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 3d06786142c2d..70ad0641d4f45 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -367,8 +367,16 @@ struct vgic_v5_its *vgic_v5_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
 int vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its *its,
 			    u32 device_id, u32 event_id,
 			    struct vgic_irq **irq);
+int vgic_v5_its_resolve_lpi_locked(struct kvm *kvm,
+				   struct vgic_v5_its *its,
+				   u32 device_id, u32 event_id,
+				   struct vgic_irq **irq,
+				   void **owner);
 int vgic_v5_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
 int vgic_v5_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi);
+int kvm_vgic_v5_set_forwarding(struct kvm *kvm, int irq,
+			       struct kvm_kernel_irq_routing_entry *irq_entry);
+void kvm_vgic_v5_unset_forwarding(struct kvm *kvm, int irq);
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
 void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu);
 int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index bf970275868c9..e3271f9301675 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -296,6 +296,13 @@ struct vgic_irq {
 	refcount_t refcount;		/* Used for LPIs */
 	u32 hwintid;			/* HW INTID number */
 	unsigned int host_irq;		/* linux irq corresponding to hwintid */
+	/*
+	 * Opaque identity of the mapping responsible for direct injection. On
+	 * invalidation, only the matching mapping may disable forwarding.
+	 * Protected by irq_lock. It can be NULL while an unforward retry is
+	 * pending after the mapping has been invalidated.
+	 */
+	void *forwarding_owner;
 	union {
 		u8 targets;			/* GICv2 target VCPUs mask */
 		u32 mpidr;			/* GICv3 target VCPU */
@@ -938,6 +945,10 @@ bool vgic_v5_ppi_queue_irq_unlock(struct kvm *kvm, struct vgic_irq *irq,
 				  unsigned long flags);
 void vgic_v5_set_ppi_dvi(struct kvm_vcpu *vcpu, struct vgic_irq *irq, bool dvi);
 
+int kvm_vgic_set_forwarding(struct kvm *kvm, int irq,
+			    struct kvm_kernel_irq_routing_entry *irq_entry);
+void kvm_vgic_unset_forwarding(struct kvm *kvm, int irq);
+
 bool vgic_state_is_nested(struct kvm_vcpu *vcpu);
 
 /* CPU HP callbacks */
-- 
2.34.1

