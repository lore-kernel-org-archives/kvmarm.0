Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF97F1799F
	for <kvmarm@lists.linux.dev>; Sat, 31 May 2025 01:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748654766; cv=none; b=aW1lnmsAw6HDcQYhKFa3T7aSR8fWyKM7mx7/u2omxCdhZo0VuHQasYcjUZMsWQpygpjFAdmx7H24hJ4Glh3lkDD7e8quwthpfMGbJz1nhlxqzzeZl2NngTuZD6RxQdSoktAWyKFGAeOpHo8d9y9lYCaATehMY89InRdb4tFrn3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748654766; c=relaxed/simple;
	bh=1bplC62znCuizte0w55BVDjG4001ZyW7sC7NP6RkFmE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VVeR1aj0li4QK+RZt1jq1K5r54Hllo6zskRQdqLKMxeOCMGESGrdYpq0+z07pMbL9wFvzsAVN/w1etqcakAHUw4FB2NGniyMLJ+iYcfTiqga3qLLKn8MN6oJB9/ZeSxcfvct5K+6pafms+UmFI76Drp4fkayC6KLUERc/HYhJ6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=YCMsEJhL; arc=none smtp.client-ip=91.218.175.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="YCMsEJhL"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1748654761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nTaX1E/8hty7SiEkf24p0yjVejk4lzFNpQQAJsKTcjU=;
	b=YCMsEJhLKvdyyjUa2liypABwBpzqLSJq9NcsQ07LG7vOkk4kqo53/rQIkMU/CIB8ORTXCt
	Vqk8RFCyNY7qNRcZIMgovsCfqCYeZTWEUe1xqbJvU1lwMAWC+WeCoTGseyHzAwLmrpx0v0
	XB1r4CW9jr5i4+isc2UMWFNx+mmJXPQ=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v2 3/4] KVM: arm64: Introduce attribute to control GICD_TYPER2.nASSGIcap
Date: Fri, 30 May 2025 18:25:44 -0700
Message-Id: <20250531012545.709887-4-oliver.upton@linux.dev>
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
 .../virt/kvm/devices/arm-vgic-v3.rst          | 29 +++++++++++++++
 arch/arm64/include/uapi/asm/kvm.h             |  3 ++
 arch/arm64/kvm/vgic/vgic-init.c               |  3 ++
 arch/arm64/kvm/vgic/vgic-kvm-device.c         | 37 +++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-mmio-v3.c            | 10 ++++-
 include/kvm/arm_vgic.h                        |  3 ++
 6 files changed, 84 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/devices/arm-vgic-v3.rst b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
index e860498b1e35..049d77eae591 100644
--- a/Documentation/virt/kvm/devices/arm-vgic-v3.rst
+++ b/Documentation/virt/kvm/devices/arm-vgic-v3.rst
@@ -306,3 +306,32 @@ Groups:
 
     The vINTID specifies which interrupt is generated when the vGIC
     must generate a maintenance interrupt. This must be a PPI.
+
+  KVM_DEV_ARM_VGIC_GRP_FEATURES
+   Attributes:
+
+    KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap
+      Control whether support for SGIs without an active state is exposed
+      to the VM. attr->addr points to a __u8 value which indicates whether
+      he feature is enabled / disabled.
+
+      A value of 0 indicates that the feature is disabled. A nonzero value
+      indicates that the feature is enabled.
+
+      This attribute can only be set prior to initializing the VGIC (i.e.
+      KVM_DEV_ARM_VGIC_CTRL_INIT).
+
+      Support for SGIs without an active state depends on hardware support.
+      Userspace can discover support for the feature by reading the
+      attribute after creating a VGICv3. It is possible that
+      KVM_DEV_ARM_VGIC_CTRL_INIT can later fail if this feature is enabled
+      and KVM is unable to allocate GIC vPEs for the VM.
+
+  Errors:
+
+    =======  ========================================================
+    -ENXIO   Invalid attribute in attr->attr
+    -EFAULT  Invalid user address in attr->addr
+    -EBUSY   The VGIC has already been initialized
+    -EINVAL  KVM doesn't support the requested feature setting
+    =======  ========================================================
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index ed5f3892674c..41e9ce412afd 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -417,6 +417,7 @@ enum {
 #define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO  7
 #define KVM_DEV_ARM_VGIC_GRP_ITS_REGS 8
 #define KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ  9
+#define KVM_DEV_ARM_VGIC_GRP_FEATURES 10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	10
 #define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
 			(0x3fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
@@ -429,6 +430,8 @@ enum {
 #define   KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES	3
 #define   KVM_DEV_ARM_ITS_CTRL_RESET		4
 
+#define   KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap	0
+
 /* Device Control API on vcpu fd */
 #define KVM_ARM_VCPU_PMU_V3_CTRL	0
 #define   KVM_ARM_VCPU_PMU_V3_IRQ		0
diff --git a/arch/arm64/kvm/vgic/vgic-init.c b/arch/arm64/kvm/vgic/vgic-init.c
index fd9e639cd665..93a616131ed6 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -132,6 +132,9 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 
 	kvm->arch.vgic.in_kernel = true;
 	kvm->arch.vgic.vgic_model = type;
+	if (type == KVM_DEV_TYPE_ARM_VGIC_V3)
+		kvm->arch.vgic.nassgicap = kvm_vgic_global_state.has_gicv4_1 &&
+					   gic_cpuif_has_vsgi();
 
 	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
 
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index b0baad68777c..c9d41ae9fe4f 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -626,6 +626,26 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 		dev->kvm->arch.vgic.mi_intid = val;
 		return 0;
 	}
+	case KVM_DEV_ARM_VGIC_GRP_FEATURES: {
+		u8 __user *uaddr = (u8 __user *)attr->addr;
+		u8 val;
+
+		if (attr->attr != KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap)
+			return -ENXIO;
+
+		if (get_user(val, uaddr))
+			return -EFAULT;
+
+		guard(mutex)(&dev->kvm->arch.config_lock);
+		if (vgic_initialized(dev->kvm))
+			return -EBUSY;
+
+		if (!(kvm_vgic_global_state.has_gicv4_1 && gic_cpuif_has_vsgi()) && val)
+			return -EINVAL;
+
+		dev->kvm->arch.vgic.nassgicap = val;
+		return 0;
+	}
 	default:
 		return vgic_set_common_attr(dev, attr);
 	}
@@ -646,6 +666,17 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
 		guard(mutex)(&dev->kvm->arch.config_lock);
 		return put_user(dev->kvm->arch.vgic.mi_intid, uaddr);
 	}
+	case KVM_DEV_ARM_VGIC_GRP_FEATURES: {
+		u8 __user *uaddr = (u8 __user *)attr->addr;
+		u8 val;
+
+		if (attr->attr != KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap)
+			return -ENXIO;
+
+		guard(mutex)(&dev->kvm->arch.config_lock);
+		val = dev->kvm->arch.vgic.nassgicap;
+		return put_user(val, uaddr);
+	}
 	default:
 		return vgic_get_common_attr(dev, attr);
 	}
@@ -683,8 +714,14 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
 			return 0;
 		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
 			return 0;
+		default:
+			return -ENXIO;
 		}
+	case KVM_DEV_ARM_VGIC_GRP_FEATURES:
+		return attr->attr != KVM_DEV_ARM_VGIC_FEATURE_nASSGIcap ?
+		       -ENXIO : 0;
 	}
+
 	return -ENXIO;
 }
 
diff --git a/arch/arm64/kvm/vgic/vgic-mmio-v3.c b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
index 1a9c5b4418b2..43f59e70e1a2 100644
--- a/arch/arm64/kvm/vgic/vgic-mmio-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-mmio-v3.c
@@ -50,12 +50,20 @@ bool vgic_has_its(struct kvm *kvm)
 
 bool vgic_supports_direct_msis(struct kvm *kvm)
 {
+	/*
+	 * Deliberately conflate vLPI and vSGI support on GICv4.1 hardware,
+	 * indirectly allowing userspace to control whether or not vPEs are
+	 * allocated for the VM.
+	 */
+	if (kvm_vgic_global_state.has_gicv4_1 && !vgic_supports_direct_sgis(kvm))
+		return false;
+
 	return kvm_vgic_global_state.has_gicv4 && vgic_has_its(kvm);
 }
 
 bool vgic_supports_direct_sgis(struct kvm *kvm)
 {
-	return kvm_vgic_global_state.has_gicv4_1 && gic_cpuif_has_vsgi();
+	return kvm->arch.vgic.nassgicap;
 }
 
 /*
diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 714cef854c1c..0e8cface0878 100644
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

