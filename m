Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7D923AB86
	for <kvmarm@lists.linux.dev>; Wed,  9 Jul 2025 21:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752095674; cv=none; b=H/Nsj80pgzWxuSHlwY0lHykUX+4QhOFhoHcFQJRrwdRNZp7ZGhkhxN+0YvJL5lJuWjxjC1QMHGPPl23zX39ScShMTQAJBZe3bFlvQwoMBs5R8+9PIOV/CqfBRES7Kgy/QZ4Y2X1uaD1OgqNn0Rs2zLEVjgNmfxybHRhpXIuMTAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752095674; c=relaxed/simple;
	bh=Y2/EGLWUuMNXY+y8e8kInH91meqFWN73NS6M3TOv8W8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rclq/QACSgb9hftxu313XszrbWRIKXIxr3ciGB07v2HpyZ69BsV/8kshTKA+i92+SaoktxbwcXH6n1kEnuR8nAu1nxP7F3xVOTR2wh03MdK/Mpr7yP1uZvz9HQoaCPuieTqeERI3WZcNRWWQUrJ7WcIWkyu1TnXxuHGwMArcBSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=KTXE9SFl; arc=none smtp.client-ip=91.218.175.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="KTXE9SFl"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1752095671;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k1/1b/MQV2c3Vo6Q6wSPsTp6Oh80mG5G1UACk4br+RU=;
	b=KTXE9SFlvc3y+KV0cyNJV4rV2ukOnEtj5WDrYsoN7u8zps5z1I4vbLBTPbo3L+ibYbi/iZ
	87xvnz46pWvw4Kdj7a0gIVH7oWRXgZFvczOeh6yRmiGZyFBbV6iov2b3mEhEznqilQrLkC
	AACrADhBvqIFe0qx6M6UxF3xVX0knJ4=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH v4 2/6] KVM: arm64: vgic-v3: Consolidate MAINT_IRQ handling
Date: Wed,  9 Jul 2025 14:14:13 -0700
Message-Id: <20250709211417.2074487-3-oliver.upton@linux.dev>
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

Consolidate the duplicated handling of the VGICv3 maintenance IRQ
attribute as a regular GICv3 attribute, as it is neither a register nor
a common attribute.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 51 +++++++++++++--------------
 1 file changed, 25 insertions(+), 26 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index f9ae790163fb..e28cf68a49c3 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -303,12 +303,6 @@ static int vgic_get_common_attr(struct kvm_device *dev,
 			     VGIC_NR_PRIVATE_IRQS, uaddr);
 		break;
 	}
-	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ: {
-		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
-
-		r = put_user(dev->kvm->arch.vgic.mi_intid, uaddr);
-		break;
-	}
 	}
 
 	return r;
@@ -523,7 +517,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 	struct vgic_reg_attr reg_attr;
 	gpa_t addr;
 	struct kvm_vcpu *vcpu;
-	bool uaccess, post_init = true;
+	bool uaccess;
 	u32 val;
 	int ret;
 
@@ -539,9 +533,6 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 		/* Sysregs uaccess is performed by the sysreg handling code */
 		uaccess = false;
 		break;
-	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
-		post_init = false;
-		fallthrough;
 	default:
 		uaccess = true;
 	}
@@ -561,7 +552,7 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 
 	mutex_lock(&dev->kvm->arch.config_lock);
 
-	if (post_init != vgic_initialized(dev->kvm)) {
+	if (!vgic_initialized(dev->kvm)) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -591,19 +582,6 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 		}
 		break;
 	}
-	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
-		if (!is_write) {
-			val = dev->kvm->arch.vgic.mi_intid;
-			ret = 0;
-			break;
-		}
-
-		ret = -EINVAL;
-		if ((val < VGIC_NR_PRIVATE_IRQS) && (val >= VGIC_NR_SGIS)) {
-			dev->kvm->arch.vgic.mi_intid = val;
-			ret = 0;
-		}
-		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -630,8 +608,24 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
-	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
 		return vgic_v3_attr_regs_access(dev, attr, true);
+	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ: {
+		u32 __user *uaddr = (u32 __user *)attr->addr;
+		u32 val;
+
+		if (get_user(val, uaddr))
+			return -EFAULT;
+
+		guard(mutex)(&dev->kvm->arch.config_lock);
+		if (vgic_initialized(dev->kvm))
+			return -EBUSY;
+
+		if ((val < VGIC_NR_SGIS) || (val >= VGIC_NR_PRIVATE_IRQS))
+			return -EINVAL;
+
+		dev->kvm->arch.vgic.mi_intid = val;
+		return 0;
+	}
 	default:
 		return vgic_set_common_attr(dev, attr);
 	}
@@ -645,8 +639,13 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
 	case KVM_DEV_ARM_VGIC_GRP_REDIST_REGS:
 	case KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS:
 	case KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO:
-	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ:
 		return vgic_v3_attr_regs_access(dev, attr, false);
+	case KVM_DEV_ARM_VGIC_GRP_MAINT_IRQ: {
+		u32 __user *uaddr = (u32 __user *)(long)attr->addr;
+
+		guard(mutex)(&dev->kvm->arch.config_lock);
+		return put_user(dev->kvm->arch.vgic.mi_intid, uaddr);
+	}
 	default:
 		return vgic_get_common_attr(dev, attr);
 	}
-- 
2.39.5

