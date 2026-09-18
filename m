Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F312E2EEE92
	for <kvmarm@lists.linux.dev>; Fri, 18 Sep 2026 08:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.218
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789719796; cv=none; b=lqMkDv+zo656f26hDSYO5/EiJ38wHb0XKY866EFRv2uDpKtxdfwLvRsmrQ5q1HhnCQPDoshnhr0hx3pGr1rPuMyp0x8kHJfATbrPDuUPA2dpAOSExhw4OUtt98tKKqGi5RGZQvrDSCGIRn5Iy26h5FKREsIMMIqpy8ciKVscGDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789719796; c=relaxed/simple;
	bh=++Uj8D3gnWNfL3YjFHlJuXC+1Fs6HmFUENo26/NcBcs=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gRUh2BnODPdU508dxSruqdYDRsKRxpsGbYVsegLuOaGI8u2cvRqcwOMNTrdvCXMWQlpNGl3gh2b9RUPUYZI70fHzx77tkqMz+5i+T7FDk7b7nV33ftQuOKE/dE5IgyrKtvbItuircI2QpmGC5sJUScbIGMg9v4vQDtdOyzmkK3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=LKawxbqa; arc=none smtp.client-ip=113.46.200.218
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="LKawxbqa"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=BUadRvtTRwf/90/kezmgXzTksbWqnPXbUgezkbnF2dU=;
	b=LKawxbqagWZtqKJ5OfXIClN6O5kePR6fYGJ74aEwh84a/T/Y6nW+MwMqraUa96Hs3rCAUYE4L
	e3YromFj41MQ1QR/1DzTU2NtAEqgOwwTS8A2TDqaQdQr6pqLUX4vufA3nrXV52IcZ6sg//WDD0x
	GvD2QUiOebSHiyWA35VoJPQ=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4hmQLV3kJ8zpSy8;
	Fri, 18 Sep 2026 16:11:14 +0800 (CST)
Received: from dggpemr200003.china.huawei.com (unknown [7.185.36.25])
	by mail.maildlp.com (Postfix) with ESMTPS id 897A04057A;
	Fri, 18 Sep 2026 16:23:03 +0800 (CST)
Received: from huawei.com (10.50.159.234) by dggpemr200003.china.huawei.com
 (7.185.36.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Fri, 18 Sep
 2026 16:23:02 +0800
From: Yize Wang <wangyize7@huawei.com>
To: <maz@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
CC: <oupton@kernel.org>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<fuad.tabba@linux.dev>, <joey.gouly@arm.com>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>, <yuzenghui@huawei.com>, <mark.rutland@arm.com>,
	<zhengchuan@huawei.com>, <jiangjiacheng@huawei.com>, <wangyize7@huawei.com>,
	<yize_w1110@163.com>
Subject: [PATCH 2/2] KVM: arm64: Add VGIC v3 batch register access implementation
Date: Fri, 18 Sep 2026 16:18:15 +0800
Message-ID: <20260918081930.4014735-3-wangyize7@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260918081930.4014735-1-wangyize7@huawei.com>
References: <20260918081930.4014735-1-wangyize7@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemr200003.china.huawei.com (7.185.36.25)

Add vgic_v3_batch_access() to allow userspace to read or write
multiple VGIC registers in a single system call.

Introduce KVM_DEV_ARM_VGIC_ATTR_FLAG_LOCKED to modify the locking
and unlocking logic in vgic_v3_attr_regs_access to prevent repeated
locking and unlocking.

Wire up KVM_DEV_ARM_VGIC_GRP_BATCH_REGS in vgic_v3_set_attr(),
vgic_v3_get_attr(), and vgic_v3_has_attr().

Signed-off-by: Chuan Zheng <zhengchuan@huawei.com>
Signed-off-by: Yize Wang <wangyize7@huawei.com>
---
 arch/arm64/kvm/vgic/vgic-kvm-device.c | 113 ++++++++++++++++++++++++--
 1 file changed, 104 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/vgic/vgic-kvm-device.c b/arch/arm64/kvm/vgic/vgic-kvm-device.c
index 90be99443df3..ef0b2e8f68b2 100644
--- a/arch/arm64/kvm/vgic/vgic-kvm-device.c
+++ b/arch/arm64/kvm/vgic/vgic-kvm-device.c
@@ -566,14 +566,21 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 			return -EFAULT;
 	}
 
-	mutex_lock(&dev->kvm->lock);
+	/* If the caller has not indicated that it already holds the necessary locks
+	 * (e.g., via KVM_DEV_ARM_VGIC_ATTR_FLAG_LOCKED), we must acquire the VM lock
+	 * and pause all VCPUs to ensure consistent access to VGIC state. This prevents
+	 * race conditions with concurrent interrupt injection or VCPU execution.
+	 */
+	if (attr->flags != KVM_DEV_ARM_VGIC_ATTR_FLAG_LOCKED) {
+		mutex_lock(&dev->kvm->lock);
 
-	if (kvm_trylock_all_vcpus(dev->kvm)) {
-		mutex_unlock(&dev->kvm->lock);
-		return -EBUSY;
-	}
+		if (kvm_trylock_all_vcpus(dev->kvm)) {
+			mutex_unlock(&dev->kvm->lock);
+			return -EBUSY;
+		}
 
-	mutex_lock(&dev->kvm->arch.config_lock);
+		mutex_lock(&dev->kvm->arch.config_lock);
+	}
 
 	if (!(vgic_initialized(dev->kvm) || reg_allowed_pre_init(attr))) {
 		ret = -EBUSY;
@@ -611,9 +618,15 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 	}
 
 out:
-	mutex_unlock(&dev->kvm->arch.config_lock);
-	kvm_unlock_all_vcpus(dev->kvm);
-	mutex_unlock(&dev->kvm->lock);
+	/* Release the locks acquired at the beginning of this function,
+	 * but only if we actually acquired them.
+	 * The order of unlocking must be the reverse of locking.
+	 */
+	if (attr->flags != KVM_DEV_ARM_VGIC_ATTR_FLAG_LOCKED) {
+		mutex_unlock(&dev->kvm->arch.config_lock);
+		kvm_unlock_all_vcpus(dev->kvm);
+		mutex_unlock(&dev->kvm->lock);
+	}
 
 	if (!ret && uaccess && !is_write) {
 		u32 __user *uaddr = (u32 __user *)(unsigned long)attr->addr;
@@ -623,6 +636,81 @@ static int vgic_v3_attr_regs_access(struct kvm_device *dev,
 	return ret;
 }
 
+/* vgic_v3_batch_access - Batch access to VGIC registers
+ *
+ * @dev: The VGIC device
+ * @attr: The device attribute containing the batch entries
+ * @is_write: True for write, false for read
+ *
+ * This function allows userspace to read or write multiple VGIC registers
+ * in a single system call, reducing overhead during live migration.
+ *
+ * Returns: 0 on success, or the first error encountered.
+ * Individual entry errors are stored in entries[i].error.
+ */
+static int vgic_v3_batch_access(struct kvm_device *dev,
+				struct kvm_device_attr *attr, bool is_write)
+{
+	struct kvm_dev_arm_vgic_batch_entry __user *uentries;
+	struct kvm_dev_arm_vgic_batch_entry *entries;
+	struct kvm_device_attr sub_attr;
+	u32 count = attr->attr;
+	int ret = 0, i;
+
+	if (!count || count > KVM_DEV_ARM_VGIC_BATCH_MAX)
+		return -EINVAL;
+
+	entries = kvmalloc_array(count, sizeof(*entries), GFP_KERNEL);
+	if (!entries)
+		return -ENOMEM;
+
+	uentries = (void __user *)attr->addr;
+	if (copy_from_user(entries, uentries, count * sizeof(*entries))) {
+		kvfree(entries);
+		return -EFAULT;
+	}
+
+	mutex_lock(&dev->kvm->lock);
+	if (kvm_trylock_all_vcpus(dev->kvm)) {
+		mutex_unlock(&dev->kvm->lock);
+		kvfree(entries);
+		return -EBUSY;
+	}
+	mutex_lock(&dev->kvm->arch.config_lock);
+
+	/* Process each entry in the batch */
+	for (i = 0; i < count; i++) {
+		int err;
+
+		sub_attr.group = entries[i].group;
+		sub_attr.attr = entries[i].attr;
+		sub_attr.addr = (unsigned long)uentries +
+			i * sizeof(struct kvm_dev_arm_vgic_batch_entry) +
+			offsetof(struct kvm_dev_arm_vgic_batch_entry, val);
+
+		/* Set flag to indicate that locks are already held.
+		 * This prevents vgic_v3_attr_regs_access from acquiring locks again,
+		 * avoiding deadlock and overhead.
+		 */
+		sub_attr.flags = KVM_DEV_ARM_VGIC_ATTR_FLAG_LOCKED;
+
+		err = vgic_v3_attr_regs_access(dev, &sub_attr, is_write);
+
+		if (err) {
+			pr_err("group %d attr %lld get err %d\n",
+				sub_attr.group, sub_attr.attr, err);
+			ret = err;
+		}
+	}
+
+	mutex_unlock(&dev->kvm->arch.config_lock);
+	kvm_unlock_all_vcpus(dev->kvm);
+	mutex_unlock(&dev->kvm->lock);
+
+	kvfree(entries);
+	return ret;
+}
+
 static int vgic_v3_set_attr(struct kvm_device *dev,
 			    struct kvm_device_attr *attr)
 {
@@ -649,6 +737,8 @@ static int vgic_v3_set_attr(struct kvm_device *dev,
 		dev->kvm->arch.vgic.mi_intid = val;
 		return 0;
 	}
+	case KVM_DEV_ARM_VGIC_GRP_BATCH_REGS:
+		return vgic_v3_batch_access(dev, attr, true);
 	default:
 		return vgic_set_common_attr(dev, attr);
 	}
@@ -669,6 +759,8 @@ static int vgic_v3_get_attr(struct kvm_device *dev,
 		guard(mutex)(&dev->kvm->arch.config_lock);
 		return put_user(dev->kvm->arch.vgic.mi_intid, uaddr);
 	}
+	case KVM_DEV_ARM_VGIC_GRP_BATCH_REGS:
+		return vgic_v3_batch_access(dev, attr, false);
 	default:
 		return vgic_get_common_attr(dev, attr);
 	}
@@ -707,6 +799,9 @@ static int vgic_v3_has_attr(struct kvm_device *dev,
 		case KVM_DEV_ARM_VGIC_SAVE_PENDING_TABLES:
 			return 0;
 		}
+		break;
+	case KVM_DEV_ARM_VGIC_GRP_BATCH_REGS:
+		return 0;
 	}
 	return -ENXIO;
 }
-- 
2.43.0

