Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43A14221703
	for <kvmarm@lists.linux.dev>; Thu, 24 Jul 2025 06:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753338505; cv=none; b=K+BrPcirqs2ZeJtv3+427oD8vW09MNxTKeVTuxOy+e4cH9LGTZAxq0cRrGcYyU/u+6OKIsDefsdKGCGRl//ZPQTzv8nLHjGCmc1bjwUcuR4CUY6tDLAWDDrgXPgh/Kzsv7LLmVmrUclTMFh2OM2JT7mlv/gxjfe469JHvtAYgaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753338505; c=relaxed/simple;
	bh=6Tg6HCKB3dj8Mr+zKdfIu4J7XRtRG0qwhi4IddzAFgU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KuK9/QnWZxhyZtmQElicl6UqPU/XyHAsufO3N7WUoDInh2HqXRVpFKtzi0v4Wq6pWP49SK8V7r6Hsv4/u0b5bq/+xoTNDRZuQF8vgTz0S3DRz+D1LkODAMKCLa7t1o3QjwwZ6L0DPkg72ZiEV5MdZUmrMkTQRB30kwRVQbn3cYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Bv9rkRTg; arc=none smtp.client-ip=95.215.58.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Bv9rkRTg"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1753338501;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/oDO21r0mP4ShDh2em3AtDPY31GPcfXwrwzVC6NWU4o=;
	b=Bv9rkRTgrY81JCKP9MM0AiAmmUkSE/3eXGAp17spxsG6a5G1E3IS1hB9ORIhypzXN693Ld
	Nyd70d/ueORTngoJOWDAPlmNrfABkdRIwNUGddD4kexu5PzNWDEOo9R1ayIVfPLDAoxuX/
	DuB/W5rpzSqkiLdpqIkv+3ieU57X2Hw=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Eric Auger <eauger@redhat.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v5 1/6] KVM: arm64: Disambiguate support for vSGIs v. vLPIs
Date: Wed, 23 Jul 2025 23:28:00 -0700
Message-Id: <20250724062805.2658919-2-oliver.upton@linux.dev>
In-Reply-To: <20250724062805.2658919-1-oliver.upton@linux.dev>
References: <20250724062805.2658919-1-oliver.upton@linux.dev>
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
predicates and replace some open-coded checks for vSGIs, including an
opportunistic fix to always check if the CPUIF is capable of handling
vSGIs.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c    |  9 ++++-----
 arch/arm64/kvm/vgic/vgic-mmio-v3.c | 16 ++++++++++------
 arch/arm64/kvm/vgic/vgic-v4.c      |  4 ++--
 arch/arm64/kvm/vgic/vgic.c         |  4 ++--
 arch/arm64/kvm/vgic/vgic.h         |  7 +++++++
 5 files changed, 25 insertions(+), 15 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index eb1205654ac8..0d8bc2ac627a 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -391,11 +391,10 @@ int vgic_init(struct kvm *kvm)
 		goto out;
 
 	/*
-	 * If we have GICv4.1 enabled, unconditionally request enable the
-	 * v4 support so that we get HW-accelerated vSGIs. Otherwise, only
-	 * enable it if we present a virtual ITS to the guest.
+	 * Ensure vPEs are allocated if direct IRQ injection (e.g. vSGIs,
+	 * vLPIs) is supported.
 	 */
-	if (vgic_supports_direct_msis(kvm)) {
+	if (vgic_supports_direct_irqs(kvm)) {
 		ret = vgic_v4_init(kvm);
 		if (ret)
 			goto out;
@@ -443,7 +442,7 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 		dist->vgic_cpu_base = VGIC_ADDR_UNDEF;
 	}
 
-	if (vgic_supports_direct_msis(kvm))
+	if (vgic_supports_direct_irqs(kvm))
 		vgic_v4_teardown(kvm);
 
 	xa_destroy(&dist->lpi_xa);
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index ae4c0593d114..8f0f460b6a61 100644
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
+		if (!vgic_supports_direct_sgis(vcpu->kvm))
 			val &= ~GICD_CTLR_nASSGIreq;
 
 		dist->enabled = val & GICD_CTLR_ENABLE_SS_G1;
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index 193946108192..e7e284d47a77 100644
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

