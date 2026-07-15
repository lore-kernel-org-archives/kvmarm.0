Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285B044E04C
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784116772; cv=none; b=cwaztu3I8rCViR8n+ZJhupKYCVQSe3U+1JWrDepCuNDOLju+lI1Qg6q0UkuUAqkuvXNz80uJGiBXo5grqg0bmbm23j0bMrUQqebApV4qiofO6axHIhjBhGY6GiPLxK1RkVWVWvt0PvSAdBLUAxNK1TXYozomzizoxvOYmkhfPXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784116772; c=relaxed/simple;
	bh=WC65vWXV3XqwhhIiAJrzrK4KiHn25jMkRXgG6O/emvA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VK7xh1enBL0awkn41EmB5Cj53GL95B5dYm9nnLMVwdASpILCBnziqDnBme60X4wctp+TESRuZdIL1UhXDiLCT2Zt3qi+v7ZLo5dIhAAdANIeua34gy2RUo0bdK+/Xx8H7juZi/YrI93BoVPlqpBrpSLo5YmjDXXK6Q1Yb72Um5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AUnnhA9m; arc=none smtp.client-ip=209.85.218.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AUnnhA9m"
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-c1662ffbf57so193446066b.2
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 04:59:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784116765; x=1784721565; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KjYDN+7EM7Yvzl2aRWCfwJrzMD6Nz8HQwAfKQduR34E=;
        b=AUnnhA9mcIpMJDECET/oa+OUNdY/jrGsgDJ7+2M7Ap46IR33pnMcIuEtOL+3/DGsR8
         FWLVGNV4ATjsZhjVi/48SQRXe4aKm9DBh3iQhLz//ARhX6xmIWojd1Hg0XfQ/JaBMQlb
         l1xqie+XXWUxnqMIWBpEX/NeX5cRxDph5dbuKDAzCZvHNV+Qw6I1PkcB1HrA84i2k7JE
         ZODtGXfCve9cU6bryqssqJ0XZk4cmD/0qUCyIsz47/rD7kBhXFYKtjfUN8+QjNygsuBZ
         PaZoufTJL5nkbXyBuc0XVtPEKxhLmdYYEtUYrAjoqSD+hh2iJLsvQFmsB1eYunBy3tMM
         UVzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784116765; x=1784721565;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KjYDN+7EM7Yvzl2aRWCfwJrzMD6Nz8HQwAfKQduR34E=;
        b=AOgErTvvPYMJph8rkQ+2Wv5PX96WsqbNtkQjPwQRejK+wdr1aauvAb/utJ1OAn++3n
         Tf4UQAWWo6Dc+Jaaeoyf7qKOBU4bkfFczirP2LdcF0eMcjt9cv3Q2nrytwLpI0LzC5BT
         5kGkCs2AMcU0HDLwMYYI6Z+Wt079m8v5ZxFk6gLVcB1YHCHyK7mmN69dIimFaX3Xm4Lm
         JSqiRpwg5cFIhZkIn0dHqLF1lL+qu5UbO6wlJar2ZtTqtKJZ4vYZ3Kw5VxZhrpVkaZRS
         MYfVWyyfNsxn0Lk6zxuilduuRSby4fLWqQvDy6Up7GNnof1gDFIjEXs2+yqr4PCuo91o
         vcyA==
X-Forwarded-Encrypted: i=1; AHgh+Rq2iHz6jQBP5qVKOKjmMc1GEpBtvWFjtCiIB3QpSlYq9jQIjnKcMiRdAXdf3gTfr+jTqqITOYM=@lists.linux.dev
X-Gm-Message-State: AOJu0YxM6cSphlX9cQogCJn9NHl1ArGdzPb0EJ0nCVaVMUgRliSp0NJM
	IA9uPQfZR/i3QVB0o4xZY9JrjH+18BbPpO2fNlVvJ6XlIe1+1ndv/+xkSkWDdjHBxXtEsKlcaAT
	JeE/4E1iVw/v9Nw==
X-Received: from ejjr20.prod.google.com ([2002:a17:906:7054:b0:c12:9227:4a93])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:1804:b0:c12:34ed:da0b with SMTP id a640c23a62f3a-c1667b099abmr363811866b.55.1784116765282;
 Wed, 15 Jul 2026 04:59:25 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:58:51 +0000
In-Reply-To: <20260715115906.2664882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260715115906.2664882-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260715115906.2664882-11-smostafa@google.com>
Subject: [PATCH v7 10/24] iommu/arm-smmu-v3-kvm: Add SMMUv3 driver
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	sebastianene@google.com, keirf@google.com, 
	Jean-Philippe Brucker <jean-philippe@linaro.org>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Jean-Philippe Brucker <jean-philippe@linaro.org>

Add the skeleton for an Arm SMMUv3 driver at EL2.

The driver rely on an array of SMMUv3s on the system, where at
init it will donate the array and the resources of the SMMUv3s
so they can't be changed by the host after de-privilege.

This array will be populated in the next patch.

Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/nvhe/Makefile              |  5 ++
 drivers/iommu/arm/Kconfig                     |  9 ++
 .../iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c  | 87 +++++++++++++++++++
 .../iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h  | 27 ++++++
 4 files changed, 128 insertions(+)
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
 create mode 100644 drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h

diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index b3e7473f18d2..dcb75fb5b4f1 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -33,6 +33,11 @@ hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
 hyp-obj-$(CONFIG_NVHE_EL2_TRACING) += trace.o events.o
 hyp-obj-y += $(lib-objs)
 
+HYP_SMMU_V3_DRV_PATH = ../../../../../drivers/iommu/arm/arm-smmu-v3
+
+hyp-obj-$(CONFIG_ARM_SMMU_V3_PKVM) += $(HYP_SMMU_V3_DRV_PATH)/pkvm/arm-smmu-v3.o \
+	$(HYP_SMMU_V3_DRV_PATH)/arm-smmu-v3-common-lib.o
+
 # Path to simple_ring_buffer.c
 CFLAGS_trace.nvhe.o += -I$(srctree)/kernel/trace/
 
diff --git a/drivers/iommu/arm/Kconfig b/drivers/iommu/arm/Kconfig
index 5fac08b89dee..916f4723238d 100644
--- a/drivers/iommu/arm/Kconfig
+++ b/drivers/iommu/arm/Kconfig
@@ -141,3 +141,12 @@ config QCOM_IOMMU
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
index 000000000000..fee5db6c9c20
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm-smmu-v3.c
@@ -0,0 +1,87 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * pKVM hyp driver for the Arm SMMUv3
+ *
+ * Copyright (C) 2022 Linaro Ltd.
+ */
+#include <asm/kvm_hyp.h>
+
+#include <nvhe/iommu.h>
+#include <nvhe/mem_protect.h>
+
+#include "arm_smmu_v3.h"
+
+size_t __ro_after_init kvm_hyp_arm_smmu_v3_count;
+struct hyp_arm_smmu_v3_device *kvm_hyp_arm_smmu_v3_smmus;
+
+#define for_each_smmu(smmu) \
+	for ((smmu) = kvm_hyp_arm_smmu_v3_smmus; \
+	     (smmu) != &kvm_hyp_arm_smmu_v3_smmus[kvm_hyp_arm_smmu_v3_count]; \
+	     (smmu)++)
+
+/* Put the device in a state that can be probed by the host driver. */
+static void smmu_deinit_device(struct hyp_arm_smmu_v3_device *smmu)
+{
+	WARN_ON(__pkvm_hyp_donate_host_mmio(smmu->mmio_addr, smmu->mmio_size));
+	smmu->base = NULL;
+}
+
+static int smmu_init_device(struct hyp_arm_smmu_v3_device *smmu)
+{
+	unsigned long haddr;
+	int ret;
+
+	if (!PAGE_ALIGNED(smmu->mmio_addr | smmu->mmio_size))
+		return -EINVAL;
+
+	ret = __pkvm_host_donate_hyp_mmio(smmu->mmio_addr, smmu->mmio_size, &haddr);
+	if (ret)
+		return ret;
+
+	smmu->base = (void __iomem *)haddr;
+
+	return 0;
+}
+
+/* Called while is the host is still trusted. */
+static int smmu_init(void)
+{
+	size_t smmu_arr_size = PAGE_ALIGN(sizeof(*kvm_hyp_arm_smmu_v3_smmus) *
+					  kvm_hyp_arm_smmu_v3_count);
+	struct hyp_arm_smmu_v3_device *smmu;
+	u64 pfn, nr_pages;
+	int ret;
+
+	kvm_hyp_arm_smmu_v3_smmus = kern_hyp_va(kvm_hyp_arm_smmu_v3_smmus);
+	pfn = hyp_virt_to_pfn(kvm_hyp_arm_smmu_v3_smmus);
+	nr_pages = smmu_arr_size >> PAGE_SHIFT;
+
+	ret = __pkvm_host_donate_hyp(pfn, nr_pages);
+	if (ret)
+		return ret;
+
+	for_each_smmu(smmu) {
+		ret = smmu_init_device(smmu);
+		if (ret)
+			goto out_reclaim_smmu;
+	}
+
+	return 0;
+
+out_reclaim_smmu:
+	while (smmu != kvm_hyp_arm_smmu_v3_smmus)
+		smmu_deinit_device(--smmu);
+	WARN_ON(__pkvm_hyp_donate_host(pfn, nr_pages));
+	return ret;
+}
+
+static int smmu_host_stage2_idmap(phys_addr_t start, phys_addr_t end, int prot)
+{
+	return 0;
+}
+
+/* Shared with the kernel driver in EL1 */
+struct pkvm_iommu_ops smmu_ops = {
+	.init				= smmu_init,
+	.host_stage2_idmap		= smmu_host_stage2_idmap,
+};
diff --git a/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
new file mode 100644
index 000000000000..0d9e48b201f5
--- /dev/null
+++ b/drivers/iommu/arm/arm-smmu-v3/pkvm/arm_smmu_v3.h
@@ -0,0 +1,27 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef __KVM_ARM_SMMU_V3_H
+#define __KVM_ARM_SMMU_V3_H
+
+#include <asm/kvm_asm.h>
+
+/*
+ * Parameters from the trusted host:
+ * @mmio_addr		base address of the SMMU registers
+ * @mmio_size		size of the registers resource
+ *
+ * Other members are filled and used at runtime by the SMMU driver.
+ * @base		Virtual address of SMMU registers
+ */
+struct hyp_arm_smmu_v3_device {
+	phys_addr_t		mmio_addr;
+	size_t			mmio_size;
+	void __iomem		*base;
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
2.55.0.141.g00534a21ce-goog

