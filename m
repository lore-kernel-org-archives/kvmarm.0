Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 658511FBE9B
	for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 15:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749829979; cv=none; b=AID9sGmB/uZABSNKN8DmE01jy2i7AsvY9Hv1tGIeIIWeHuS5APCcBjR7+2ZsywpBmR0lX59YcKXTw274mkG2A5qP+wuf63SS7nuIayBVa3BV/eu01C5ZdYa+gTJXbGNUgcEkMJi37kl++VJ0rlqQnv3DxGWT9NJClTt1R4DxPP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749829979; c=relaxed/simple;
	bh=Lako0OAiwwW3qmvtQn9EFqpnvuUs1QbGAU5WOiOhGB8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bsxNUVyZMMTTu4/ncTeluBLV97piFvW+8M6TK/a2THoe2W9ftpVT/lv/oRs1RMW0/X/rQYENj+IDOZgUksFj385v/k6Yoy05pb8ffEtC4flUTBUEhCxaHRvFYfAHUcZfP//WZORwcLCZqefTb9Qxw1KeAhl/Kztv/CDRCp6w0v0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oleU6xnb; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--rananta.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oleU6xnb"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3ddc6d66787so30167005ab.3
        for <kvmarm@lists.linux.dev>; Fri, 13 Jun 2025 08:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1749829976; x=1750434776; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R6oERwEX9ihIeJP2v6QxDWL9BHMEBqaouPjaqIFm6Iw=;
        b=oleU6xnbFuRKOUoa2VGk4m5aPGU1GjBmV16EKZu4fCktcfKIKo0ANusDopaYUadW9q
         YSM3Lm43nPkNGcd9d9Ywqhdc1UmB4EBMKEjFSwpLr6WMrCMCqh/gxqaAo/NVMuAJaMQS
         iDDR3vI0YHKBCODx6AnGQlNeAw22lA0M5io2uga/EhBe2XeWDt+Fa5ij62MCcOCoOk4d
         ZgPVe59rMW5f2yBIo5n7MbO7o1KaRTZvAI4Q4YXmeaIRefdooYM5R0uW3yrk7PBryZPy
         TchYmcmdqgOhdsxyjptYTtF9RLcw45qFafWSROBgADcPvis+Wzlt/EQbCRP8BsO5XFE3
         Smbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749829976; x=1750434776;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R6oERwEX9ihIeJP2v6QxDWL9BHMEBqaouPjaqIFm6Iw=;
        b=vG9RZXh8vAqW2AmTMH1+mExEap11vcnQaC+tYJPRgjxHj/xfxG3+GTace99nQLoYqM
         tbw+C+4hsp+gmwYsRSPl//tofbtLGnpOdVKB5uJpe7ByqZbGAjZPFFdqiWUjG6U/uGAy
         rvsIZfALvxA1R0N4xdm37ghHSeRyLwokQgeY5zi7mw9qhcFhLc1AEFuUJTDLpdisPiHa
         rqoXSGEYKkEPWQ34oA9xSM04Mi5m5W0bDLf1Hr3lX8ONlLMS82JWeNJo9bKPpvzc5Lbl
         nNLNl4CEG0iptt/snITO9lzsVCXOFt8Z1JQZ1BjH4BtxaoQhHpO3L5sXBW9tErc6Cpyu
         P91Q==
X-Forwarded-Encrypted: i=1; AJvYcCUcFOIFdFaHUXgnT8cTr8TuOtZ4yniZ04GR2mvka6Km2br6pZpjZiSCTAGdkfgXPqRe6QM1oOc=@lists.linux.dev
X-Gm-Message-State: AOJu0YyewOzU9WFtjOrIWkxuMj7eLvF52SACLKMowsUAVg8R6KSJSpbG
	mNqgHfIdnh7NX67GYw4TP8Nv5eURclKaV11r1Wx6Abh8AeIu8nrn2HONlWBtvpKuXdCTTIQK6/0
	yRuxbMdvsHA==
X-Google-Smtp-Source: AGHT+IHQ02cONRw6pm1YF1fpfHYYr8pmJ6vodarmPvsSB72Fz6jp9DIzeYQOuK2lpV+1OvcWdDYWazQgvwWV
X-Received: from iobbr11.prod.google.com ([2002:a05:6602:388b:b0:867:6d21:ab61])
 (user=rananta job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6602:29a9:b0:864:4a1b:dfc5
 with SMTP id ca18e2360f4ac-875d3d2c717mr392436439f.9.1749829965739; Fri, 13
 Jun 2025 08:52:45 -0700 (PDT)
Date: Fri, 13 Jun 2025 15:52:37 +0000
In-Reply-To: <20250613155239.2029059-1-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250613155239.2029059-1-rananta@google.com>
X-Mailer: git-send-email 2.50.0.rc2.692.g299adb8693-goog
Message-ID: <20250613155239.2029059-4-rananta@google.com>
Subject: [PATCH v3 3/4] KVM: arm64: Introduce attribute to control GICD_TYPER2.nASSGIcap
From: Raghavendra Rao Ananta <rananta@google.com>
To: Oliver Upton <oliver.upton@linux.dev>, Marc Zyngier <maz@kernel.org>
Cc: Raghavendra Rao Anata <rananta@google.com>, Mingwei Zhang <mizhang@google.com>, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

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
 arch/arm64/kvm/vgic/vgic-v3.c                 |  5 ++-
 arch/arm64/kvm/vgic/vgic-v4.c                 |  2 +-
 include/kvm/arm_vgic.h                        |  3 ++
 8 files changed, 88 insertions(+), 4 deletions(-)

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
index 5e0e4559004b..944e24750ac4 100644
--- a/arch/arm64/kvm/vgic/vgic-init.c
+++ b/arch/arm64/kvm/vgic/vgic-init.c
@@ -157,6 +157,9 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 
 	kvm->arch.vgic.in_kernel = true;
 	kvm->arch.vgic.vgic_model = type;
+	if (type == KVM_DEV_TYPE_ARM_VGIC_V3)
+		kvm->arch.vgic.nassgicap = kvm_vgic_global_state.has_gicv4_1 &&
+					   gic_cpuif_has_vsgi();
 
 	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
 
diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index e28cf68a49c3..629f56063a13 100644
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
diff --git a/arch/arm64/kvm/vgic/vgic-v3.c b/arch/arm64/kvm/vgic/vgic-v3.c
index b9ad7c42c5b0..cb6bda9b3c6c 100644
--- a/arch/arm64/kvm/vgic/vgic-v3.c
+++ b/arch/arm64/kvm/vgic/vgic-v3.c
@@ -404,7 +404,8 @@ int vgic_v3_save_pending_tables(struct kvm *kvm)
 	 * The above vgic initialized check also ensures that the allocation
 	 * and enabling of the doorbells have already been done.
 	 */
-	if (kvm_vgic_global_state.has_gicv4_1) {
+	if (kvm_vgic_global_state.has_gicv4_1 &&
+	    vgic_supports_direct_irqs(kvm)) {
 		unmap_all_vpes(kvm);
 		vlpi_avail = true;
 	}
@@ -581,7 +582,7 @@ int vgic_v3_map_resources(struct kvm *kvm)
 		return -EBUSY;
 	}
 
-	if (kvm_vgic_global_state.has_gicv4_1)
+	if (vgic_supports_direct_sgis(kvm))
 		vgic_v4_configure_vsgis(kvm);
 
 	return 0;
diff --git a/arch/arm64/kvm/vgic/vgic-v4.c b/arch/arm64/kvm/vgic/vgic-v4.c
index e7e284d47a77..25e9da9e7a2d 100644
--- a/arch/arm64/kvm/vgic/vgic-v4.c
+++ b/arch/arm64/kvm/vgic/vgic-v4.c
@@ -245,7 +245,7 @@ int vgic_v4_init(struct kvm *kvm)
 
 	lockdep_assert_held(&kvm->arch.config_lock);
 
-	if (!kvm_vgic_global_state.has_gicv4)
+	if (!vgic_supports_direct_irqs(kvm))
 		return 0; /* Nothing to see here... move along. */
 
 	if (dist->its_vm.vpes)
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
2.50.0.rc2.692.g299adb8693-goog

