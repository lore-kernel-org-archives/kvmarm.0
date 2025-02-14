Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6691713D246
	for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 02:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739498585; cv=none; b=kna7gZIBR6E/xw0Xb2kWsAN8WM/Ka32DGOczTE6W+n7kO8aAETicqKWUWimlVnI08YUDDiC1NVnRKUzO6+iwBhg+rNTtPvPm2acImxtwsHMcnpIbMt342Hk4paB47Ym7EVmGZCoJl5djptNGc0Ks/13FBPFSTUj9QkEqjBZL2gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739498585; c=relaxed/simple;
	bh=PSADQPxuoHivUdtWfr7d7okdA68LTnuyHfJWsgrhb3I=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=b2kox0sAbT+SDBQE5bx9F3aiq6lQpK/34x+bgtAAaz98TQc0N//Q5NDq7Waluh6l7mnINLSYN5UmpTSQaOV6y2B5+kVMNwN1/AlpSNlj+zsoyxRELGBMo64gbhrWN3sBbhN32YgS4jIgEw7epIIA7VRF6AHPbjvLWEHNsOd+bPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sd/lWVrK; arc=none smtp.client-ip=209.85.214.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--jingzhangos.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sd/lWVrK"
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-21f7519ae0cso31754645ad.3
        for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 18:03:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739498582; x=1740103382; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Pu+yCU8a3zHiD33i1SjhqECQAo1I4nsEwt4OD4Fy6ew=;
        b=Sd/lWVrK0Jr+Ks4j2OHx4EePSJ/xGiI5yYGfPX0I1A4CbmeIom9MHDOB2wyFyPZOLS
         VRbgO+tazDcvqKHQ0xVUMiybeyXfEXsAL7CIerBVREK6+bFqSijfwi7pTgkEKJVoyOzD
         xYhogK9e6+uym8K+bnMja58pDohQXS1BVPigSydb6WMGUMmWMOmO7ro6LnjSayS+v99S
         3jCcbeO+DJgDzKAAWjfh9vdCzS15YrLb4Y3M3fnWDGPLz2vZAP0o6uJbvLH5q9949N2d
         r39OkuzdF5HTouE+ZpKIfu2NFidZ8hdWHuEZxGDVoMcFazvqvl0jvBRgWfSg5Uvpng/k
         AHEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739498582; x=1740103382;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Pu+yCU8a3zHiD33i1SjhqECQAo1I4nsEwt4OD4Fy6ew=;
        b=ApIenu9O7Gm/cgLNGs0ITdZNJgsi6PcLS5YC/f+l+wuwc4p64kn/rJ0SLvF9N4rwxs
         gANrXlzARI9skmq8eJas6qks+NztrdsYQS2RncsWCtgEz4+Pg0CsLa80BojGB0Q2PGhA
         21PhJTvyaDVBVn4eDf/35EhCV4iwGIhjJIiC1Ufs71/OUJUYbBBHbv5gLib7NxFV6zwh
         RcaZrhrM2e0RLUqfFiozPxtrp15xRrfQ0oJ5QxfU2YuX/ubUe8g2uFbRkCEVLNEgudIM
         /XqysBMZiyUp1ZqYo+VxEbEqvMWKnIgbb7TWPI1iDpC0hKuON/rZ/0P7bSBd1Cu4nJF9
         8odg==
X-Gm-Message-State: AOJu0YxzYz34GiKAoAdrw94F3wOnhquHeztlb0MRRYNQM09hq15wyL70
	UFu4QmoxYiIh+A2SERQPd2NGLiPMYtIxtW9j1qecNQNmAy76Hl+z7YsUyJm9A2fcAmqV1IH42KW
	CQmoEC3MPZ8xEuE5vU2d9CzMC/e+ii0VcC4ZBie8ttVu8fLTV7n7Nnj5I2Z4tZNpoiqy15VZuQ/
	GQzNzhVPzN2N6oRPyTMALsdSqceXI9V1pmPXBko/4BarupOVmhiwJkxZmaUAE=
X-Google-Smtp-Source: AGHT+IGDKMv9Ge+LtmxttXGfU0XRYxQrxU7yp68UK4PfQ4QF6cygJ52uXtFtg4A3ivblm2asbdQbQxNdGvLwybi7kA==
X-Received: from pgka3.prod.google.com ([2002:a63:e843:0:b0:ad5:4a28:559a])
 (user=jingzhangos job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:6a05:b0:1ed:8cd8:77fb with SMTP id adf61e73a8af0-1ee5c739d63mr14674047637.16.1739498582541;
 Thu, 13 Feb 2025 18:03:02 -0800 (PST)
Date: Thu, 13 Feb 2025 18:02:58 -0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250214020258.2436469-1-jingzhangos@google.com>
Subject: [PATCH v1] KVM: arm64: vgic-its: Add debugfs interface to expose ITS tables
From: Jing Zhang <jingzhangos@google.com>
To: KVMARM <kvmarm@lists.linux.dev>, ARMLinux <linux-arm-kernel@lists.infradead.org>
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"

This commit introduces a debugfs interface to display the contents of the
VGIC Interrupt Translation Service (ITS) tables.

The ITS tables map Device/Event IDs to Interrupt IDs and target processors.
Exposing this information through debugfs allows for easier inspection and
debugging of the interrupt routing configuration.

The debugfs interface presents the ITS table data in a tabular format:

  Device ID: 0, Event ID Range: [0 - 65535]
  EVENT_ID    INTID  HWINTID   TARGET   COL_ID HW
  -----------------------------------------------
         0       32        0        0        0  0
         1       33        0        0        0  0
         2       34        0        0        0  0
       ...      ...      ...      ...      ... ..

The output is generated using the seq_file interface, allowing for efficient
handling of potentially large ITS tables.

This interface is read-only and does not allow modification of the ITS
tables. It is intended for debugging and informational purposes only.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
rfc -> v1:
 - Rebase on to v6.14-rc2.
 - Retained only the debugfs interface patch from the original RFC [1].

[1] https://lore.kernel.org/all/20250113193128.1533449-1-jingzhangos@google.com
---
 arch/arm64/kvm/Makefile              |   2 +-
 arch/arm64/kvm/vgic/vgic-its-debug.c | 234 +++++++++++++++++++++++++++
 arch/arm64/kvm/vgic/vgic-its.c       |  39 +----
 arch/arm64/kvm/vgic/vgic.h           |  33 ++++
 4 files changed, 276 insertions(+), 32 deletions(-)
 create mode 100644 arch/arm64/kvm/vgic/vgic-its-debug.c

diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 3cf7adb2b5038..b1e7b9c29589c 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -23,7 +23,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 vgic/vgic-v3.o vgic/vgic-v4.o \
 	 vgic/vgic-mmio.o vgic/vgic-mmio-v2.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
-	 vgic/vgic-its.o vgic/vgic-debug.o
+	 vgic/vgic-its.o vgic/vgic-debug.o vgic/vgic-its-debug.o
 
 kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
diff --git a/arch/arm64/kvm/vgic/vgic-its-debug.c b/arch/arm64/kvm/vgic/vgic-its-debug.c
new file mode 100644
index 0000000000000..1ff0dd0137939
--- /dev/null
+++ b/arch/arm64/kvm/vgic/vgic-its-debug.c
@@ -0,0 +1,234 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * vgic-its-debug.c - Debugfs interface for exposing VGIC ITS tables.
+ *
+ * Copyright (C) 2025 Google
+ *
+ * This file provides a debugfs interface to display the contents of the
+ * VGIC Interrupt Translation Service (ITS) tables. This allows for
+ * inspection of the mapping between Event IDs, Interrupt IDs, and target
+ * processors. The information is presented in a tabular format through a
+ * seq_file interface.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/kvm_host.h>
+#include <linux/seq_file.h>
+#include <kvm/arm_vgic.h>
+#include "vgic.h"
+
+/**
+ * struct vgic_its_iter - Iterator for traversing VGIC ITS tables.
+ * @dev: Pointer to the current its_device being processed.
+ * @ite: Pointer to the current its_ite within the device being processed.
+ *
+ * This structure is used to maintain the current position during iteration
+ * over the ITS tables. It holds pointers to both the current device and the
+ * current ITE within that device.
+ */
+struct vgic_its_iter {
+	struct its_device *dev;
+	struct its_ite *ite;
+};
+
+/**
+ * end_of_iter - Checks if the iterator has reached the end of the ITS tables.
+ * @iter: The iterator to check.
+ *
+ * Return: True if the iterator is at the end, false otherwise.
+ */
+static inline bool end_of_iter(struct vgic_its_iter *iter)
+{
+	return !iter->dev && !iter->ite;
+}
+
+/**
+ * iter_next - Advances the iterator to the next entry in the ITS tables.
+ * @its: The VGIC ITS structure.
+ * @iter: The iterator to advance.
+ *
+ * This function moves the iterator to the next ITE within the current device,
+ * or to the first ITE of the next device if the current ITE is the last in
+ * the device. If the current device is the last device, the iterator is set
+ * to indicate the end of iteration.
+ */
+static void iter_next(struct vgic_its *its, struct vgic_its_iter *iter)
+{
+	struct its_device *dev = iter->dev;
+	struct its_ite *ite = iter->ite;
+
+	if (!ite || list_is_last(&ite->ite_list, &dev->itt_head)) {
+		if (list_is_last(&dev->dev_list, &its->device_list)) {
+			dev = NULL;
+			ite = NULL;
+		} else {
+			dev = list_next_entry(dev, dev_list);
+			ite = list_first_entry_or_null(&dev->itt_head,
+						       struct its_ite,
+						       ite_list);
+		}
+	} else {
+		ite = list_next_entry(ite, ite_list);
+	}
+
+	iter->dev = dev;
+	iter->ite = ite;
+}
+
+/**
+ * vgic_its_debug_start - Start function for the seq_file interface.
+ * @s: The seq_file structure.
+ * @pos: The starting position (offset).
+ *
+ * This function initializes the iterator to the beginning of the ITS tables
+ * and advances it to the specified position. It acquires the its_lock mutex
+ * to protect shared data.
+ *
+ * Return: An iterator pointer on success, NULL if no devices are found or
+ *         the end of the list is reached, or ERR_PTR(-ENOMEM) on memory
+ *         allocation failure.
+ */
+static void *vgic_its_debug_start(struct seq_file *s, loff_t *pos)
+{
+	struct vgic_its *its = s->private;
+	struct vgic_its_iter *iter;
+	struct its_device *dev;
+	loff_t offset = *pos;
+
+	mutex_lock(&its->its_lock);
+
+	dev = list_first_entry_or_null(&its->device_list,
+				       struct its_device, dev_list);
+	if (!dev)
+		return NULL;
+
+	iter = kmalloc(sizeof(*iter), GFP_KERNEL);
+	if (!iter)
+		return ERR_PTR(-ENOMEM);
+
+	iter->dev = dev;
+	iter->ite = list_first_entry_or_null(&dev->itt_head,
+					     struct its_ite, ite_list);
+
+	while (!end_of_iter(iter) && offset--)
+		iter_next(its, iter);
+
+	if (end_of_iter(iter)) {
+		kfree(iter);
+		return NULL;
+	}
+
+	return iter;
+}
+
+/**
+ * vgic_its_debug_next - Next function for the seq_file interface.
+ * @s: The seq_file structure.
+ * @v: The current iterator.
+ * @pos: The current position (offset).
+ *
+ * This function advances the iterator to the next entry and increments the
+ * position.
+ *
+ * Return: An iterator pointer on success, or NULL if the end of the list is
+ *         reached.
+ */
+static void *vgic_its_debug_next(struct seq_file *s, void *v, loff_t *pos)
+{
+	struct vgic_its *its = s->private;
+	struct vgic_its_iter *iter = v;
+
+	++*pos;
+	iter_next(its, iter);
+
+	if (end_of_iter(iter)) {
+		kfree(iter);
+		return NULL;
+	}
+	return iter;
+}
+
+/**
+ * vgic_its_debug_stop - Stop function for the seq_file interface.
+ * @s: The seq_file structure.
+ * @v: The current iterator.
+ *
+ * This function frees the iterator and releases the its_lock mutex.
+ */
+static void vgic_its_debug_stop(struct seq_file *s, void *v)
+{
+	struct vgic_its *its = s->private;
+	struct vgic_its_iter *iter = v;
+
+	if (!IS_ERR_OR_NULL(iter))
+		kfree(iter);
+	mutex_unlock(&its->its_lock);
+}
+
+/**
+ * vgic_its_debug_show - Show function for the seq_file interface.
+ * @s: The seq_file structure.
+ * @v: The current iterator.
+ *
+ * This function formats and prints the ITS table entry information to the
+ * seq_file output.
+ *
+ * Return: 0 on success.
+ */
+static int vgic_its_debug_show(struct seq_file *s, void *v)
+{
+	struct vgic_its_iter *iter = v;
+	struct its_device *dev = iter->dev;
+	struct its_ite *ite = iter->ite;
+
+	if (list_is_first(&ite->ite_list, &dev->itt_head)) {
+		seq_printf(s, "\n");
+		seq_printf(s, "Device ID: %u, Event ID Range: [0 - %llu]\n",
+			   dev->device_id, BIT_ULL(dev->num_eventid_bits) - 1);
+		seq_printf(s, "EVENT_ID    INTID  HWINTID   TARGET   COL_ID HW\n");
+		seq_printf(s, "-----------------------------------------------\n");
+	}
+
+	if (ite && ite->irq && ite->collection) {
+		seq_printf(s, "%8u %8u %8u %8u %8u %2d\n",
+			   ite->event_id, ite->irq->intid, ite->irq->hwintid,
+			   ite->collection->target_addr,
+			   ite->collection->collection_id, ite->irq->hw);
+	}
+
+	return 0;
+}
+
+static const struct seq_operations vgic_its_debug_sops = {
+	.start = vgic_its_debug_start,
+	.next  = vgic_its_debug_next,
+	.stop  = vgic_its_debug_stop,
+	.show  = vgic_its_debug_show
+};
+
+DEFINE_SEQ_ATTRIBUTE(vgic_its_debug);
+
+/**
+ * vgic_its_debug_init - Initializes the debugfs interface for VGIC ITS.
+ * @dev: The KVM device structure.
+ *
+ * This function creates a debugfs file named "vgic-its-state@%its_base"
+ * to expose the ITS table information.
+ *
+ * Return: 0 on success.
+ */
+int vgic_its_debug_init(struct kvm_device *dev)
+{
+	struct vgic_its *its = dev->private;
+	char name[32];
+
+	snprintf(name, sizeof(name), "vgic-its-state@%llx", (u64)its->vgic_its_base);
+	debugfs_create_file(name, 0444, dev->kvm->debugfs_dentry, its, &vgic_its_debug_fops);
+
+	return 0;
+}
+
+void vgic_its_debug_destroy(struct kvm_device *dev)
+{
+}
+
diff --git a/arch/arm64/kvm/vgic/vgic-its.c b/arch/arm64/kvm/vgic/vgic-its.c
index fb96802799c6f..569f9da9049fe 100644
--- a/arch/arm64/kvm/vgic/vgic-its.c
+++ b/arch/arm64/kvm/vgic/vgic-its.c
@@ -154,36 +154,6 @@ static struct vgic_irq *vgic_add_lpi(struct kvm *kvm, u32 intid,
 	return irq;
 }
 
-struct its_device {
-	struct list_head dev_list;
-
-	/* the head for the list of ITTEs */
-	struct list_head itt_head;
-	u32 num_eventid_bits;
-	gpa_t itt_addr;
-	u32 device_id;
-};
-
-#define COLLECTION_NOT_MAPPED ((u32)~0)
-
-struct its_collection {
-	struct list_head coll_list;
-
-	u32 collection_id;
-	u32 target_addr;
-};
-
-#define its_is_collection_mapped(coll) ((coll) && \
-				((coll)->target_addr != COLLECTION_NOT_MAPPED))
-
-struct its_ite {
-	struct list_head ite_list;
-
-	struct vgic_irq *irq;
-	struct its_collection *collection;
-	u32 event_id;
-};
-
 /**
  * struct vgic_its_abi - ITS abi ops and settings
  * @cte_esz: collection table entry size
@@ -1938,6 +1908,8 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
 
 	mutex_lock(&its->its_lock);
 
+	vgic_its_debug_destroy(kvm_dev);
+
 	vgic_its_free_device_list(kvm, its);
 	vgic_its_free_collection_list(kvm, its);
 	vgic_its_invalidate_cache(its);
@@ -2771,7 +2743,12 @@ static int vgic_its_set_attr(struct kvm_device *dev,
 		if (ret)
 			return ret;
 
-		return vgic_register_its_iodev(dev->kvm, its, addr);
+		ret = vgic_register_its_iodev(dev->kvm, its, addr);
+		if (ret)
+			return ret;
+
+		return vgic_its_debug_init(dev);
+
 	}
 	case KVM_DEV_ARM_VGIC_GRP_CTRL:
 		return vgic_its_ctrl(dev->kvm, its, attr->attr);
diff --git a/arch/arm64/kvm/vgic/vgic.h b/arch/arm64/kvm/vgic/vgic.h
index 122d95b4e2845..c2891d7b5e62e 100644
--- a/arch/arm64/kvm/vgic/vgic.h
+++ b/arch/arm64/kvm/vgic/vgic.h
@@ -172,6 +172,36 @@ struct vgic_reg_attr {
 	gpa_t addr;
 };
 
+struct its_device {
+	struct list_head dev_list;
+
+	/* the head for the list of ITTEs */
+	struct list_head itt_head;
+	u32 num_eventid_bits;
+	gpa_t itt_addr;
+	u32 device_id;
+};
+
+#define COLLECTION_NOT_MAPPED ((u32)~0)
+
+struct its_collection {
+	struct list_head coll_list;
+
+	u32 collection_id;
+	u32 target_addr;
+};
+
+#define its_is_collection_mapped(coll) ((coll) && \
+				((coll)->target_addr != COLLECTION_NOT_MAPPED))
+
+struct its_ite {
+	struct list_head ite_list;
+
+	struct vgic_irq *irq;
+	struct its_collection *collection;
+	u32 event_id;
+};
+
 int vgic_v3_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
 		       struct vgic_reg_attr *reg_attr);
 int vgic_v2_parse_attr(struct kvm_device *dev, struct kvm_device_attr *attr,
@@ -353,4 +383,7 @@ static inline bool kvm_has_gicv3(struct kvm *kvm)
 	return kvm_has_feat(kvm, ID_AA64PFR0_EL1, GIC, IMP);
 }
 
+int vgic_its_debug_init(struct kvm_device *dev);
+void vgic_its_debug_destroy(struct kvm_device *dev);
+
 #endif

base-commit: a64dcfb451e254085a7daee5fe51bf22959d52d3
-- 
2.48.1.601.g30ceb7b040-goog

