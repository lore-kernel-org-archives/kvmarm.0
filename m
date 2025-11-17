Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC53E33769F
	for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 18:48:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763405323; cv=none; b=PG6KAq5m00JSUc+en949gpiYzQQAL0mhWqiT0azS5f+txKSZIFhvuGvtoFOT6KKQTCblKlIRdu/xQk0cjtDy2ueuzjIub00e/uYUuxOpVYiSvBCf/W6BYeJ1S5Xnhbf47rPZvg9shZ68aD/K64LivOwc685ODBWbhwQiPR988tg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763405323; c=relaxed/simple;
	bh=X1SB8xBsyDP9CObrHvadpvuvmKMLHDjQeJHpDgXwBrU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KGFUK31UTMvvC755GEWQV55kLcoiVyfwxdSB+DGj6k86fCJD39OUJ4quBDWd9bhVCugJeZhhyUN0C46SwSKHsRDxm9Q32hoKQMOj5eM4EYbhIy6GwdJL6NB0eL7REsmtYNNplC5VC8betb0ot5T5SP4TyrJ77TJ5X89Um/gYL4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HUPlv6hb; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HUPlv6hb"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-42b2e448bd9so2994378f8f.1
        for <kvmarm@lists.linux.dev>; Mon, 17 Nov 2025 10:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763405318; x=1764010118; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VXBWv8Dw5hE8mlU4Sm4VTohDwotOri7T9rWgww1xmos=;
        b=HUPlv6hbdLEasy1TJDwPw/g3D/wY3JxLgf75UAi6l1pFIvXig9/dC6Oyf6CRftGmHO
         QA/6pXcqXv7mFG0jBZKDgA7W2T98T2CuXMR6b/2GwCwNwkPNCLjuvEzwmhcdu7E7r26b
         gWK76FRWCzG4KtcFl+wTSsbk4S+amj5xjoqbr9p3g8IeCb8ZmcfeBciIU1szoJouGEE4
         lKksCdEJzD3qtRFx06qpf7GZXYDWYBOhl/ssJzweLaJxAzsSo/s6tWbW0SqWR76AEz1w
         SIkoiyix6M4f++aOckTRKvQDWZDORVU7dStVDa+fdGxCHxRv1ABjgFt/DTVDDxCZP7Lm
         +RIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763405318; x=1764010118;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VXBWv8Dw5hE8mlU4Sm4VTohDwotOri7T9rWgww1xmos=;
        b=YC85eHEu52Kr+N7QUDqa89i6DVUInQEzJgxJ5AAd6VqyaS0CZtIUXQotkp5C5j+MrE
         pgeK98+Wm4r6ZXyGFH54+W+lUbVeA8tDNltXgLKgVkHRqcE0LluMpjpmkXZXhKZiCUh8
         HxbDWQhOTcnu2xvX1AQvXPaxogddK5+cM4i077JO8d9kqNwdU2yy2eg5W4KGY43NAcwG
         gnTrKk9lPs7VEJn7zhj2s5mCg+APy5SrVmm5QJzylRLEtLH5do4K8sVg9kJwtHnTRbSA
         34bIVCVKdzgoZMBKREjWBWfsDlW1roAfE+6XOR1S56sYWDYgsqIg0xl1LDjUXHYwbvZp
         1fqg==
X-Forwarded-Encrypted: i=1; AJvYcCWsyBZ0M+mY+2Sa0eHeecG4KfC0HrD3jURGWch6SScIxmOEHSOu2YYjkUgwiUv7gNludAM8VqA=@lists.linux.dev
X-Gm-Message-State: AOJu0YylBoTew8OALj9EZ+TFEe7Ig1OvUB8VrO5HZ8FsF8vzAyoc0lA3
	5XjXzNLL4eXGABDdcO2hxrlDk2fj9Ti8Wu+l3a8nZ/YWBglS1JBy0He7xwkocvqAlXyt2ZGRg72
	5TP/KVcJX8y7IUw==
X-Google-Smtp-Source: AGHT+IHQBDWwjO/s1zZNuEFY1oL5kAjhY98F1o68vfkU7yeDw2zqyTvhCAFTbYHvFaunhrv4os5cxfn9oBJJZA==
X-Received: from wrxe9.prod.google.com ([2002:a05:6000:1209:b0:428:563f:ce93])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:615:b0:42b:3a1b:f71a with SMTP id ffacd0b85a97d-42b5934e2b6mr13388046f8f.23.1763405318003;
 Mon, 17 Nov 2025 10:48:38 -0800 (PST)
Date: Mon, 17 Nov 2025 18:47:59 +0000
In-Reply-To: <20251117184815.1027271-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251117184815.1027271-1-smostafa@google.com>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
Message-ID: <20251117184815.1027271-13-smostafa@google.com>
Subject: [PATCH v5 12/27] iommu/arm-smmu-v3-kvm: Add SMMUv3 driver
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	praan@google.com, danielmentz@google.com, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

Add the skeleton for an Arm SMMUv3 driver at EL2.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/Makefile              |  5 ++++
 drivers/iommu/arm/Kconfig                     |  9 ++++++
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 29 +++++++++++++++++++
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  | 16 ++++++++++
 4 files changed, 59 insertions(+)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 8210788d6f88..197685817546 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -32,6 +32,11 @@ hyp-obj-y += ../../../kernel/smccc-call.o
 hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
 hyp-obj-y += $(lib-objs)
 
+HYP_SMMU_V3_DRV_PATH = ../../../../../drivers/iommu/arm/arm-smmu-v3
+
+hyp-obj-$(CONFIG_ARM_SMMU_V3_PKVM) += $(HYP_SMMU_V3_DRV_PATH)/pkvm/arm-smmu-v3.o \
+	$(HYP_SMMU_V3_DRV_PATH)/arm-smmu-v3-common-lib.o
+
 ##
 ## Build rules for compiling nVHE hyp code
 ## Output of this folder is `kvm_nvhe.o`, a partially linked object
diff --git a/drivers/iommu/arm/Kconfig b/drivers/iommu/arm/Kconfig
index ef42bbe07dbe..7eeb94d2499d 100644
--- a/drivers/iommu/arm/Kconfig
+++ b/drivers/iommu/arm/Kconfig
@@ -142,3 +142,12 @@ config QCOM_IOMMU
 	select ARM_DMA_USE_IOMMU
 	help
 	  Support for IOMMU on certain Qualcomm SoCs.
+
+config ARM_SMMU_V3_PKVM
+	bool "ARM SMMUv3 support for protected Virtual Machines"
+	depends on KVM && ARM64 && ARM_SMMU_V3=y
+	help
+	  Enable a SMMUv3 driver in the KVM hypervisor, to protect VMs against
+	  memory accesses from devices owned by the host.
+
+	  Say Y here if you intend to enable KVM in protected mode.
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
new file mode 100644
index 000000000000..fa8b71152560
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pKVM hyp driver for the Arm SMMUv3
+ *
+ * Copyright (C) 2022 Linaro Ltd.
+ */
+#include <asm/kvm_hyp.h>
+
+#include <nvhe/iommu.h>
+
+#include "arm_smmu_v3.h"
+
+size_t __ro_after_init kvm_hyp_arm_smmu_v3_count;
+struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
+
+static int smmu_init(void)
+{
+	return -ENOSYS;
+}
+
+static void smmu_host_stage2_idmap(phys_addr_t start, phys_addr_t end, int prot)
+{
+}
+
+/* Shared with the kernel driver in EL1 */
+struct kvm_iommu_ops smmu_ops = {
+	.init				= smmu_init,
+	.host_stage2_idmap		= smmu_host_stage2_idmap,
+};
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
new file mode 100644
index 000000000000..f6ad91d3fb85
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_ARM_SMMU_V3_H
+#define __KVM_ARM_SMMU_V3_H
+
+#include <asm/kvm_asm.h>
+
+struct hyp_arm_smmu_v3_device {
+};
+
+extern size_t kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count);
+#define kvm_hyp_arm_smmu_v3_count kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_count)
+
+extern struct hyp_arm_smmu_v3_device *kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_smmus);
+#define kvm_hyp_arm_smmu_v3_smmus kvm_nvhe_sym(kvm_hyp_arm_smmu_v3_smmus)
+
+#endif /* __KVM_ARM_SMMU_V3_H */
-- 
2.52.0.rc1.455.g30608eb744-goog

