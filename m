Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111B71799F
	for <kvmarm@lists.linux.dev>; Sat, 31 May 2025 01:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748654762; cv=none; b=ct9whPk6vCM3tYJBjobv9beCZwKFnVf2edrBNBrlxha2YLW4+lhQg30vNfFs1xxOLJaEVpdM6yNYGls9mupCyklNctozbBp63/Dl7XCCaedyzTA5V0mAtWZOdnmtQ/1NhdamtlDyq7H2UrPYbZOZY8iEchsfC32E0LPAbGiVmQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748654762; c=relaxed/simple;
	bh=CcR0UEhTtHzTeCIxydXjk50/KeCwYAZYn6b3Wqewaho=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=qfSdlNsm6lQxGVjhmSYmT4dykVLQwsuf7OdUBqE8GWooxXqEqeSFkj3GuPVf8Gzez386vf5Z1X92AsEbXxa+hZnbpOeQ8TN9G4qwtnmuyA2aVMzvRmUe3BoZo1kgXZGRbasyXXuvBWI+kiHT3W0BXnlNTkO2xV3KbGHRJaZZ4v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IsL5zSJX; arc=none smtp.client-ip=91.218.175.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IsL5zSJX"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748654757;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NX0lzwFtBTgjDoNzZiZMbw16dfqmnOXiPYhWKyrfwec=;
	b=IsL5zSJXUdjivX8d0omdr4K8BLHDEqXolZIvyv/o9ZSG3N5uCJl/4ei6S++ptjsUBKPwS3
	mpWxdmtaKG1oaPig0FnsrhWQifbSnToZsbfAHBYRi2n+CHE5yIM8nPQPWk4T2qfIxSaT6A
	kyG3rJMG9PuWmDg/6vvkxWe8vOld3/Y=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 1/4] KVM: arm64: Disambiguate support for vSGIs v. vLPIs
Date: Fri, 30 May 2025 18:25:42 -0700
Message-Id: <20250531012545.709887-2-oliver.upton@linux.dev>
In-Reply-To: <20250531012545.709887-1-oliver.upton@linux.dev>
References: <20250531012545.709887-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

vgic_supports_direct_msis() is a bit of a misnomer, as it returns true
if either vSGIs or vLPIs are supported. Pick it apart into a few
predicates and replace some open-coded checks for vSGIs.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c    |  4 ++--
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 16 ++++++++++------
 arch/arm64/kvm/vgic/vgic-v4.c      |  4 ++--
 arch/arm64/kvm/vgic/vgic.c         |  4 ++--
 arch/arm64/kvm/vgic/vgic.h         |  7 +++++++
 5 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 1f33e71c2a73..fd9e639cd665 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -370,7 +370,7 @@ int vgic_init(struct kvm *kvm)
 	 * v4 support so that we get HW-accelerated vSGIs. Otherwise, only
 	 * enable it if we present a virtual ITS to the guest.
 	 */
-	if (vgic_supports_direct_msis(kvm)) {
+	if (vgic_supports_direct_irqs(kvm)) {
 		ret = vgic_v4_init(kvm);
 		if (ret)
 			goto out;
@@ -418,7 +418,7 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 		dist->vgic_cpu_base = VGIC_ADDR_UNDEF;
 	}
 
-	if (vgic_supports_direct_msis(kvm))
+	if (vgic_supports_direct_irqs(kvm))
 		vgic_v4_teardown(kvm);
 
 	xa_destroy(&dist->lpi_xa);
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index ae4c0593d114..1a9c5b4418b2 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -50,8 +50,12 @@ bool vgic_has_its(struct kvm *kvm)
 
 bool vgic_supports_direct_msis(struct kvm *kvm)
 {
-	return (kvm_vgic_global_state.has_gicv4_1 ||
-		(kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm)));
+	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
+}
+
+bool vgic_supports_direct_sgis(struct kvm *kvm)
+{
+	return kvm_vgic_global_state.has_gicv4_1 && gic_cpuif_has_vsgi();
 }
 
 /*
@@ -86,7 +90,7 @@ static unsigned long vgic_mmio_read_v3_misc(struct kvm_vcpu *vcpu,
 		}
 		break;
 	case GICD_TYPER2:
-		if (kvm_vgic_global_state.has_gicv4_1 && gic_cpuif_has_vsgi())
+		if (vgic_supports_direct_sgis(vcpu->kvm))
 			value = GICD_TYPER2_nASSGIcap;
 		break;
 	case GICD_IIDR:
@@ -119,7 +123,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 		dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
 
 		/* Not a GICv4.1? No HW SGIs */
-		if (!kvm_vgic_global_state.has_gicv4_1 || !gic_cpuif_has_vsgi())
+		if (!vgic_supports_direct_sgis(vcpu->kvm))
 			val &= ~GICD_CTLR_nASSGIreq;
 
 		/* Dist stays enabled? nASSGIreq is RO */
@@ -133,7 +137,7 @@ static void vgic_mmio_write_v3_misc(struct kvm_vcpu *vcpu,
 		if (is_hwsgi != dist->nassgireq)
 			vgic_v4_configure_vsgis(vcpu->kvm);
 
-		if (kvm_vgic_global_state.has_gicv4_1 &&
+		if (vgic_supports_direct_sgis(vcpu->kvm) &&
 		    was_enabled != dist->enabled)
 			kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_RELOAD_GICv4);
 		else if (!was_enabled && dist->enabled)
@@ -178,7 +182,7 @@ static int vgic_mmio_uaccess_write_v3_misc(struct kvm_vcpu *vcpu,
 		}
 	case GICD_CTLR:
 		/* Not a GICv4.1? No HW SGIs */
-		if (!kvm_vgic_global_state.has_gicv4_1)
+		if (vgic_supports_direct_sgis(vcpu->kvm))
 			val &= ~GICD_CTLR_nASSGIreq;
 
 		dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index c7de6154627c..a9c772697a43 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -356,7 +356,7 @@ int vgic_v4_put(struct kvm_vcpu *vcpu)
 {
 	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
 
-	if (!vgic_supports_direct_msis(vcpu->kvm) || !vpe->resident)
+	if (!vgic_supports_direct_irqs(vcpu->kvm) || !vpe->resident)
 		return 0;
 
 	return its_make_vpe_non_resident(vpe, vgic_v4_want_doorbell(vcpu));
@@ -367,7 +367,7 @@ int vgic_v4_load(struct kvm_vcpu *vcpu)
 	struct its_vpe *vpe = &vcpu->arch.vgic_cpu.vgic_v3.its_vpe;
 	int err;
 
-	if (!vgic_supports_direct_msis(vcpu->kvm) || vpe->resident)
+	if (!vgic_supports_direct_irqs(vcpu->kvm) || vpe->resident)
 		return 0;
 
 	if (vcpu_get_flag(vcpu, IN_WFI))
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 8f8096d48925..f5148b38120a 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -951,7 +951,7 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	 * can be directly injected (GICv4).
 	 */
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head) &&
-	    !vgic_supports_direct_msis(vcpu->kvm))
+	    !vgic_supports_direct_irqs(vcpu->kvm))
 		return;
 
 	DEBUG_SPINLOCK_BUG_ON(!irqs_disabled());
@@ -965,7 +965,7 @@ void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 	if (can_access_vgic_from_kernel())
 		vgic_restore_state(vcpu);
 
-	if (vgic_supports_direct_msis(vcpu->kvm))
+	if (vgic_supports_direct_irqs(vcpu->kvm))
 		vgic_v4_commit(vcpu);
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 4349084cb9a6..ebf9ed6adeac 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -370,6 +370,13 @@ int vgic_its_inv_lpi(struct kvm *kvm, struct vgic_irq *irq);
 int vgic_its_invall(struct kvm_vcpu *vcpu);
 
 bool vgic_supports_direct_msis(struct kvm *kvm);
+bool vgic_supports_direct_sgis(struct kvm *kvm);
+
+static inline bool vgic_supports_direct_irqs(struct kvm *kvm)
+{
+	return vgic_supports_direct_msis(kvm) || vgic_supports_direct_sgis(kvm);
+}
+
 int vgic_v4_init(struct kvm *kvm);
 void vgic_v4_teardown(struct kvm *kvm);
 void vgic_v4_configure_vsgis(struct kvm *kvm);
-- 
2.39.5

