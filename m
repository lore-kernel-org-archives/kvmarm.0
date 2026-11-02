Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793648745;
	b=OArbmN3WCIcY0OdAx7LCMF0VAeYlRm36g4xe0TrqVYj3/4EkXsbuc4D+A+WSN2z+mIZR
	 iqJqZjByx6SGt/mum706hKrN1Ubh+W4jed1SShQUUyjQaGwD+Iy9PVhfRBjlL0N8QKsKr
	 w8qnZ+BLPYEwbKKCPgBUMsCxRmdkfSkIWs9BbPf+lZT8iet2XY92/JHCazBZxbu9a+71/
	 /Dsyx98eWYDrW1x275m1Q9QnWZWfOqakmvmV6KG6B1yo205AA2K40v4z+DHSb/8Sl+8OQ
	 jlvJPUphLNLMzsoFCaWkzMeehD1azTi/f6AtM6E6gL3p1yCEhMxwMLQV8uVGRCil2Iw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793648745;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=o9Zj0uDrLtT59Cp5ilWqKygvn3OZ7IulIamM3tG1l8g=;
	b=BAlX3XCYjse/UADsDnoWPNOfPKXnUxczy76e5qjzRrJnhvcH6qvWdZTmaxUSRIK/G0nu
	 JkK5rKGQ7r0BFXBGEYP4zBrlwZGWSMlQDzZ9Z80GJseWlc+cT7ZG+dR5O4Y/zOYTsAlKz
	 rlPStJRCeVJlxG+7QzI3pWgvvY2eUdW5sjGYymKH4cOcuGZV0P+mOpVZxov6PQcANGhMA
	 DOj9onZx1kCtffpC6INm9WnN+3A9l/65iwaEdxdboI9QuRd8t5GQ7LK23BkVCku2tQaLz
	 0oiExmGwx48T715DuHDsaHakGjPw/IpxI0fCEkMSQvNiqKLJmqPyxoIIPOY69ZJ9sTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=DP5v9FC4;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F24A1606EEBC
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 19:45:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F24A1606EEBC
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=DP5v9FC4
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7129D16A3;
	Mon,  2 Nov 2026 11:45:41 -0800 (PST)
Received: from e133894.cambridge.arm.com (e133894.arm.com [10.2.80.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BA62B3F871;
	Mon,  2 Nov 2026 11:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793648744; bh=alN/4224zFytf27w5ONkJJlEll5Qao+G1kFWCP+heqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DP5v9FC4bJANz8W8DHeF9GlYzUAEokxRLfnup46ImzhOGp8t0wEBUpCEyazHKpamb
	 nS849c+h66nsDk5y05HhgMtmLw4Pr86PQs9UbSkwcTOCNFd0NofmrRuvioOkOclMCb
	 4OFVMlbgfKSWDT2LVRH4D+Ipaw2lHnG2Xs7cs4ys=
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
Subject: [PATCH v2 09/16] KVM: arm64: gic-v5: Add ITS MSI injection
Date: Mon,  2 Nov 2026 19:44:47 +0000
Message-Id: <20261102194454.4086911-10-sascha.bischoff@arm.com>
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

Now that KVM can resolve GICv5 ITS translations from guest memory,
allow userspace and irqfd MSI injection to target a virtual GICv5 ITS.

Add helpers to validate that an MSI address resolves to a GICv5 ITS
IODEV, find the ITS for an MSI, resolve the DeviceID/EventID pair to a
vgic_irq, and inject the resulting LPI with the GICv5 VDPEND path.
GICv5 MSIs require KVM_MSI_VALID_DEVID, as the DeviceID is part of the
ITS translation key.

Although MSI data is 32 bits, GICv5 supports only 16-bit EventIDs.
Reject a nonzero upper half before narrowing the EventID for cache
lookups, so malformed MSI data cannot alias a valid translation.

Provide both the slow path, which resolves the translation from guest
memory and populates the ITS cache, and the inatomic cached path used
by irqfd. If the cached path misses, irqfd retries in a work item. The
worker borrows the VM's mm while walking the guest tables, then drops
it before injecting the LPI.

Wire kvm_set_msi() and kvm_arch_set_irq_inatomic() to use the GICv5
ITS injection helpers for GICv5 VMs, while keeping the existing GICv3
ITS path unchanged for GICv3 VMs.

Signed-off-by: Sascha Bischoff <sascha.bischoff@arm.com>
---
 arch/arm64/kvm/vgic/vgic-irqfd.c  |   8 ++
 arch/arm64/kvm/vgic/vgic-its-v5.c | 132 ++++++++++++++++++++++++++++--
 arch/arm64/kvm/vgic/vgic.h        |   6 ++
 3 files changed, 139 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-irqfd.c b/arch/arm64/kvm/vgic/vgic-irqfd.c
index ee1a1b214f03c..c5f5ce8b80c1d 100644
--- a/arch/arm64/kvm/vgic/vgic-irqfd.c
+++ b/arch/arm64/kvm/vgic/vgic-irqfd.c
@@ -114,6 +114,10 @@ int kvm_set_msi(struct kvm_kernel_irq_routing_entry *e,
 		return -1;
 
 	kvm_populate_msi(e, &msi);
+
+	if (vgic_is_v5(kvm))
+		return vgic_v5_its_inject_msi(kvm, &msi);
+
 	return vgic_its_inject_msi(kvm, &msi);
 }
 
@@ -135,6 +139,10 @@ int kvm_arch_set_irq_inatomic(struct kvm_kernel_irq_routing_entry *e,
 			break;
 
 		kvm_populate_msi(e, &msi);
+
+		if (vgic_is_v5(kvm))
+			return vgic_v5_its_inject_cached_translation(kvm, &msi);
+
 		return vgic_its_inject_cached_translation(kvm, &msi);
 	}
 
diff --git a/arch/arm64/kvm/vgic/vgic-its-v5.c b/arch/arm64/kvm/vgic/vgic-its-v5.c
index 9f4783b243221..b69a1d107c0ae 100644
--- a/arch/arm64/kvm/vgic/vgic-its-v5.c
+++ b/arch/arm64/kvm/vgic/vgic-its-v5.c
@@ -3,8 +3,10 @@
  * Copyright (C) 2025 ARM Limited, All Rights Reserved.
  */
 
+#include <linux/kthread.h>
 #include <linux/kvm_host.h>
 #include <linux/rcupdate.h>
+#include <linux/sched/mm.h>
 #include <linux/slab.h>
 
 #include <asm/kvm_arm.h>
@@ -19,6 +21,7 @@
 
 #define VITS_V5_DEVICE_ID_BITS		16
 #define VITS_V5_EVENT_ID_BITS		16
+#define VITS_V5_UNMAPPED		1
 
 struct its_cache_translation_entry {
 	struct rcu_head rcu;
@@ -359,8 +362,46 @@ static int get_itte(struct kvm *kvm, u32 event_id, gpa_t itt_base,
 				   itt_l2_entry);
 }
 
+struct vgic_v5_its *vgic_v5_msi_to_its(struct kvm *kvm, struct kvm_msi *msi)
+{
+	struct kvm_io_device *kvm_io_dev;
+	struct vgic_io_device *iodev;
+	u64 address;
+
+	if (!vgic_has_its(kvm))
+		return ERR_PTR(-ENODEV);
+
+	if (!(msi->flags & KVM_MSI_VALID_DEVID))
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * MSI data is 32 bits, but GICv5 limits EventIDs to 16 bits.
+	 * Match that limit in the vITS.
+	 */
+	if (msi->data >> VITS_V5_EVENT_ID_BITS)
+		return ERR_PTR(-EINVAL);
+
+	address = (u64)msi->address_hi << 32 | msi->address_lo;
+
+	guard(srcu)(&kvm->srcu);
+
+	kvm_io_dev = kvm_io_bus_get_dev(kvm, KVM_MMIO_BUS, address);
+	if (!kvm_io_dev)
+		return ERR_PTR(-EINVAL);
+
+	if (kvm_io_dev->ops != &kvm_io_gic_ops)
+		return ERR_PTR(-EINVAL);
+
+	iodev = container_of(kvm_io_dev, struct vgic_io_device, dev);
+	if (iodev->iodev_type != IODEV_GICV5_ITS)
+		return ERR_PTR(-EINVAL);
+
+	return iodev->v5its;
+}
+
+/* A positive return means the guest has no usable translation. */
 static int __vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its *its,
-				     u32 device_id, u16 event_id,
+				     u32 device_id, u32 event_id,
 				     struct vgic_irq **irq)
 {
 	unsigned int itt_l2sz, event_id_bits;
@@ -372,13 +413,15 @@ static int __vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its *its,
 	int ret;
 
 	lockdep_assert_held(&its->its_lock);
+	if (event_id >> VITS_V5_EVENT_ID_BITS)
+		return -EINVAL;
 
 	if (!its->enabled) {
 		kvm_debug("Cannot look up LPI; vITS is disabled\n");
 		return -ENXIO;
 	}
 
-	ret = its_cache_look_up_translation(its, device_id, event_id, irq);
+	ret = its_cache_look_up_translation(its, device_id, (u16)event_id, irq);
 	if (!ret)
 		return 0;
 
@@ -389,23 +432,23 @@ static int __vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its *its,
 		      &event_id_bits, &itt_l2sz);
 	if (ret) {
 		kvm_debug("Error parsing guest's DT\n");
-		return ret;
+		return VITS_V5_UNMAPPED;
 	}
 
 	if (event_id >= 1UL << event_id_bits) {
 		kvm_debug("Event ID out of range\n");
-		return -E2BIG;
+		return VITS_V5_UNMAPPED;
 	}
 
 	ret = get_itte(kvm, event_id, itt_base, two_level_itt, itt_l2sz,
 		       &itt_l2_entry);
 	if (ret)
-		return ret;
+		return VITS_V5_UNMAPPED;
 
 	val = le64_to_cpu(itt_l2_entry);
 	if (!FIELD_GET(GICV5_ITTL2E_VALID, val)) {
 		kvm_debug("ITTE is not valid\n");
-		return -EINVAL;
+		return VITS_V5_UNMAPPED;
 	}
 
 	lpi = FIELD_GET(GICV5_ITTL2E_LPI_ID, val);
@@ -415,7 +458,8 @@ static int __vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its *its,
 		return PTR_ERR(*irq);
 
 	vgic_get_irq_ref(*irq);
-	ret = its_cache_add_translation(kvm, its, device_id, event_id, *irq);
+	ret = its_cache_add_translation(kvm, its, device_id, (u16)event_id,
+					 *irq);
 	if (ret) {
 		vgic_put_irq(kvm, *irq);
 		return 0;
@@ -424,12 +468,86 @@ static int __vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its *its,
 	return ret;
 }
 
+int vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its *its,
+			    u32 device_id, u32 event_id,
+			    struct vgic_irq **irq)
+{
+	guard(mutex)(&its->its_lock);
+
+	return __vgic_v5_its_resolve_lpi(kvm, its, device_id, event_id, irq);
+}
+
 static void vgic_v5_its_inject_lpi(struct kvm *kvm, struct vgic_irq *irq)
 {
 	kvm_call_hyp(__vgic_v5_vdpend, irq->intid, true,
 		     kvm->arch.vgic.gicv5_vm.vm_id);
 }
 
+int vgic_v5_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi)
+{
+	struct vgic_v5_its *its;
+	struct vgic_irq *irq;
+	bool borrowed_mm = false;
+	int ret;
+
+	its = vgic_v5_msi_to_its(kvm, msi);
+	if (IS_ERR(its))
+		return PTR_ERR(its);
+
+	/* An irqfd cache miss is resolved by a worker outside the VM's mm. */
+	if (current->mm != kvm->mm) {
+		if (WARN_ON_ONCE(current->mm || !(current->flags & PF_KTHREAD)))
+			return -EWOULDBLOCK;
+
+		if (!mmget_not_zero(kvm->mm))
+			return -EFAULT;
+
+		kthread_use_mm(kvm->mm);
+		borrowed_mm = true;
+	}
+
+	ret = vgic_v5_its_resolve_lpi(kvm, its, msi->devid, msi->data, &irq);
+	if (borrowed_mm) {
+		kthread_unuse_mm(kvm->mm);
+		mmput(kvm->mm);
+	}
+
+	if (ret < 0)
+		return ret;
+	/* KVM_SIGNAL_MSI reports guest translation failures as blocked MSIs. */
+	if (ret)
+		return 0;
+
+	vgic_v5_its_inject_lpi(kvm, irq);
+	vgic_put_irq(kvm, irq);
+
+	return 1;
+}
+
+int vgic_v5_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi)
+{
+	struct vgic_v5_its *its;
+	struct vgic_irq *irq;
+	int ret;
+
+	its = vgic_v5_msi_to_its(kvm, msi);
+	if (IS_ERR(its))
+		return PTR_ERR(its);
+
+	if (!READ_ONCE(its->enabled))
+		return -EWOULDBLOCK;
+
+	ret = its_cache_look_up_translation(its, msi->devid, (u16)msi->data,
+					    &irq);
+	if (ret)
+		return -EWOULDBLOCK;
+
+	vgic_v5_its_inject_lpi(kvm, irq);
+	vgic_put_irq(kvm, irq);
+
+	return 0;
+}
+
 static void vgic_v5_its_handle_read_event(struct kvm *kvm,
 					  struct vgic_v5_its *its)
 {
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 9e1cbcdedf3f5..64f6229fe555e 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -364,6 +364,12 @@ void vgic_v3_put(struct kvm_vcpu *vcpu);
 bool vgic_has_its(struct kvm *kvm);
 int kvm_vgic_register_its_device(void);
 int kvm_vgic_v5_register_its_device(void);
+struct vgic_v5_its *vgic_v5_msi_to_its(struct kvm *kvm, struct kvm_msi *msi);
+int vgic_v5_its_resolve_lpi(struct kvm *kvm, struct vgic_v5_its *its,
+			    u32 device_id, u32 event_id,
+			    struct vgic_irq **irq);
+int vgic_v5_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
+int vgic_v5_its_inject_cached_translation(struct kvm *kvm, struct kvm_msi *msi);
 void vgic_enable_lpis(struct kvm_vcpu *vcpu);
 void vgic_flush_pending_lpis(struct kvm_vcpu *vcpu);
 int vgic_its_inject_msi(struct kvm *kvm, struct kvm_msi *msi);
-- 
2.34.1

