Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39D5F242D8D
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 21:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752095680; cv=none; b=lrQYO3h3VnLenp4d6vmKJ2XzsifM4SWatj+Gk1c3qAF+Tf2zcnHQhU6t7HHu5lPeDoHClWMQrj9XXzCKoiik7toVcRjVcDEIY6ySLbbajm7a8PWFMDZVcM7n1vr7qm5FqzsSpV/TUCU8Xi1aEMEfM97+a0GSMyMdNRZtskFe+A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752095680; c=relaxed/simple;
	bh=exqVLRwpwuCOQC9IT5iwYqELRXYq89eb52Yuat4kWLY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JtXXg8pKyoVQCDNDykZDLFkKJGrRJNlNxe7MunCNsOhDnj0G0GQt5tR3Z24BCnWjwnJ9WRGg33LBZtX4r98Yfv0ZcMkaIOCEhzfLfBGSctalYnL7d2iWm1VkLsy0GS9wn88jiaaXtoz1ewpmrRi4EXel1F4ODh9vQo8PbihYOKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=FID9ifHl; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="FID9ifHl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752095675;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=B738AoyJ/h4halYpeYrAMe188MqTplMo1ire1/6wuJ8=;
	b=FID9ifHlF3uCdIVjFGp6aUd255T13keXlbAAEuXHDXXacTeGo8pcMqgkzDubq4FOjtLD8N
	uAAsxudroOn0+InZizVHjsDmWOgqGd0gv6t1TtayRThgy4tN3jnaSYlKXLqEIPgUoQbcfT
	DjsIBFbpH1bBGNES/g3FonV+LOAXIeo=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 4/6] KVM: arm64: vgic-v3: Allow userspace to write GICD_TYPER2.nASSGIcap
Date: Wed,  9 Jul 2025 14:14:15 -0700
Message-Id: <20250709211417.2074487-5-oliver.upton@linux.dev>
In-Reply-To: <20250709211417.2074487-1-oliver.upton@linux.dev>
References: <20250709211417.2074487-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

From: Raghavendra Rao Ananta <rananta@google.com>

KVM unconditionally advertises GICD_TYPER2.nASSGIcap (which internally
implies vSGIs) on GICv4.1 systems. Allow userspace to change whether a
VM supports the feature. Only allow changes prior to VGIC initialization
as at that point vPEs need to be allocated for the VM.

For convenience, bundle support for vLPIs and vSGIs behind this feature,
allowing userspace to control vPE allocation for VMs in environments
that may be constrained on vPE IDs.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-init.c       |  3 +++
 arch/arm64/kvm/vgic/vgic-kvm-device.c |  1 +
 arch/arm64/kvm/vgic/vgic-mmio-v3.c    | 19 +++++++++++++++++--
 arch/arm64/kvm/vgic/vgic.h            |  1 +
 include/kvm/arm_vgic.h                |  3 +++
 5 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index 487e902b040c..80c07d5a7d7a 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -166,6 +166,9 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	else
 		INIT_LIST_HEAD(&kvm->arch.vgic.rd_regions);
 
+	if (type == KVM_DEV_TYPE_ARM_VGIC_V3)
+		kvm->arch.vgic.nassgicap = system_supports_direct_sgis();
+
 out_unlock:
 	mutex_unlock(&kvm->arch.config_lock);
 	kvm_unlock_all_vcpus(kvm);
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 15d9772a53c8..37beb6f32b3d 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -515,6 +515,7 @@ static bool reg_allowed_pre_init(struct kvm_device_attr *attr)
 
 	switch (attr->attr & KVM_DEV_ARM_VGIC_OFFSET_MASK) {
 	case GICD_IIDR:
+	case GICD_TYPER2:
 		return true;
 	default:
 		return false;
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 1a9c5b4418b2..1a24dde8ffdc 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -53,11 +53,16 @@ bool vgic_supports_direct_msis(struct kvm *kvm)
 	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
 }
 
-bool vgic_supports_direct_sgis(struct kvm *kvm)
+bool system_supports_direct_sgis(void)
 {
 	return kvm_vgic_global_state.has_gicv4_1 && gic_cpuif_has_vsgi();
 }
 
+bool vgic_supports_direct_sgis(struct kvm *kvm)
+{
+	return kvm->arch.vgic.nassgicap;
+}
+
 /*
  * The Revision field in the IIDR have the following meanings:
  *
@@ -163,8 +168,18 @@ static int vgic_mmio_uaccess_write_v3_misc(struct kvm_vcpu *vcpu,
 
 	switch (addr & 0x0c) {
 	case GICD_TYPER2:
-		if (val != vgic_mmio_read_v3_misc(vcpu, addr, len))
+		reg = vgic_mmio_read_v3_misc(vcpu, addr, len);
+
+		if (reg == val)
+			return 0;
+		if (vgic_initialized(vcpu->kvm))
+			return -EBUSY;
+		if ((reg ^ val) & ~GICD_TYPER2_nASSGIcap)
 			return -EINVAL;
+		if (!system_supports_direct_sgis() && val)
+			return -EINVAL;
+
+		dist->nassgicap = val & GICD_TYPER2_nASSGIcap;
 		return 0;
 	case GICD_IIDR:
 		reg = vgic_mmio_read_v3_misc(vcpu, addr, len);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index ebf9ed6adeac..96048ec59d0d 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -369,6 +369,7 @@ void vgic_its_invalidate_all_caches(struct kvm *kvm);
 int vgic_its_inv_lpi(struct kvm *kvm, struct vgic_irq *irq);
 int vgic_its_invall(struct kvm_vcpu *vcpu);
 
+bool system_supports_direct_sgis(void);
 bool vgic_supports_direct_msis(struct kvm *kvm);
 bool vgic_supports_direct_sgis(struct kvm *kvm);
 
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 4a34f7f0a864..1b4886f3fb20 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -264,6 +264,9 @@ struct vgic_dist {
 	/* distributor enabled */
 	bool			enabled;
 
+	/* Supports SGIs without active state */
+	bool			nassgicap;
+
 	/* Wants SGIs without active state */
 	bool			nassgireq;
 
-- 
2.39.5

