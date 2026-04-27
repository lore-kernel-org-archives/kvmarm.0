Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB9939A804;
	Mon, 27 Apr 2026 08:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777278515; cv=none; b=DQPMKKPefbLIBDkprPBKrvCAPJNlUhKlesqR+b11XNFDzqF4HC67f/8lCvug1ADp6rnTI9yvViDhuF9n/ngl4H5ewVwnBlqJIsbcfXwF7ds+KojOS2fe8xqwmDBL6zY1xLZlLRsz/PhKjPd7AFQsikJ39Nn2Ff4uCA9ZJqjO3M4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777278515; c=relaxed/simple;
	bh=jWDox4PMeXivGPI3967QCwIkfrrCveT4HT7lOBVxKvQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KI0p9n2itu051hEuVEX7ZiBzsxNpIq7E8Ay6Lefq5SNX4zYobG9Ak/x7rE72hlmFVZZ4LUdAehmHtzLyzrTphLXqc5SZZPTj7orFzv6DpDjD83VcZKCFqwKLObVy+9dd2REZ88yDrQMCvwwTlBspYx2hndA1m+IfFVZljWTFesw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UyW/3dlO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UyW/3dlO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39541C2BCB4;
	Mon, 27 Apr 2026 08:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777278514;
	bh=jWDox4PMeXivGPI3967QCwIkfrrCveT4HT7lOBVxKvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UyW/3dlOMlRwKnrOYnLbYnIDHNXE7tD9O4VWiIfBYUg35tWP0ARIVH1awxO2vHjin
	 DqBizOBPL6vdSGnIEJvtkIVrKEftfehCRX1UhXBZhS6KH7KeRi677YK99/JyPzsFkr
	 YLR1cWGLVX4zz+Msl2nq1rUCSr6c9s38+DGkNXKJTKMgK/waqwzMNVoyvkqyacom/k
	 lT5gOAe+8NtlcPP4RMG+ZpueZI/3FJXf6+glp6YpK6kQkut5NtEJKj1Ckaj1b98Ert
	 iCCWivn83c/f7ZKhPxswIbODnxApI9YoSHGxen3zgAho8kRw6aMF9WJt+VKZZOLsHS
	 7LL7Wanik2fGQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [RFC PATCH v4 04/11] coco: guest: arm64: Support guest-initiated TDI lock/unlock transitions
Date: Mon, 27 Apr 2026 13:57:58 +0530
Message-ID: <20260427082805.931832-5-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427082805.931832-1-aneesh.kumar@kernel.org>
References: <20260427082805.931832-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add guest helpers to drive TDI state transitions through RHI:
- cca_device_lock() -> RHI_DA_TDI_CONFIG_LOCKED
- cca_device_unlock() -> RHI_DA_TDI_CONFIG_UNLOCKED

Use these helpers in the PCI TSM lock/unlock callbacks so a successful
lock path returns a live pci_tsm handle and unlock transitions the device
back to unlocked state.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/arm-cca-guest/Makefile  |  2 +-
 drivers/virt/coco/arm-cca-guest/arm-cca.c |  9 ++++--
 drivers/virt/coco/arm-cca-guest/rsi-da.c  | 34 +++++++++++++++++++++++
 drivers/virt/coco/arm-cca-guest/rsi-da.h  |  3 ++
 4 files changed, 45 insertions(+), 3 deletions(-)
 create mode 100644 drivers/virt/coco/arm-cca-guest/rsi-da.c

diff --git a/drivers/virt/coco/arm-cca-guest/Makefile b/drivers/virt/coco/arm-cca-guest/Makefile
index 65c4cc52c154..11db7af095c9 100644
--- a/drivers/virt/coco/arm-cca-guest/Makefile
+++ b/drivers/virt/coco/arm-cca-guest/Makefile
@@ -2,4 +2,4 @@
 obj-$(CONFIG_ARM_CCA_GUEST) += arm-cca-guest.o
 
 arm-cca-guest-y +=  arm-cca.o
-arm-cca-guest-$(CONFIG_PCI_TSM) +=  rhi-da.o
+arm-cca-guest-$(CONFIG_PCI_TSM) +=  rhi-da.o rsi-da.o
diff --git a/drivers/virt/coco/arm-cca-guest/arm-cca.c b/drivers/virt/coco/arm-cca-guest/arm-cca.c
index 0c12aae85e6d..d4880ca59fc5 100644
--- a/drivers/virt/coco/arm-cca-guest/arm-cca.c
+++ b/drivers/virt/coco/arm-cca-guest/arm-cca.c
@@ -211,14 +211,19 @@ static struct pci_tsm *cca_tsm_lock(struct tsm_dev *tsm_dev, struct pci_dev *pde
 	if (ret)
 		return ERR_PTR(ret);
 
-	/* For now always return an error */
-	return ERR_PTR(-EIO);
+	ret = cca_device_lock(pdev);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return &no_free_ptr(cca_dsc)->pci.base_tsm;
 }
 
 static void cca_tsm_unlock(struct pci_tsm *tsm)
 {
 	struct cca_guest_dsc *cca_dsc = to_cca_guest_dsc(tsm->pdev);
 
+	cca_device_unlock(tsm->pdev);
+
 	kfree(cca_dsc);
 }
 
diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.c b/drivers/virt/coco/arm-cca-guest/rsi-da.c
new file mode 100644
index 000000000000..2c3017933fb0
--- /dev/null
+++ b/drivers/virt/coco/arm-cca-guest/rsi-da.c
@@ -0,0 +1,34 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 ARM Ltd.
+ */
+
+#include <linux/pci.h>
+#include <asm/rsi_cmds.h>
+
+#include "rsi-da.h"
+#include "rhi-da.h"
+
+int cca_device_lock(struct pci_dev *pdev)
+{
+	int ret;
+
+	ret = rhi_vdev_set_tdi_state(pdev, RHI_DA_TDI_CONFIG_LOCKED);
+	if (ret) {
+		pci_err(pdev, "failed to lock the device (%d)\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+int cca_device_unlock(struct pci_dev *pdev)
+{
+	int ret;
+
+	ret = rhi_vdev_set_tdi_state(pdev, RHI_DA_TDI_CONFIG_UNLOCKED);
+	if (ret) {
+		pci_err(pdev, "failed to unlock the device (%d)\n", ret);
+		return ret;
+	}
+	return 0;
+}
diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.h b/drivers/virt/coco/arm-cca-guest/rsi-da.h
index 858bfdaf59c9..06fcea95d888 100644
--- a/drivers/virt/coco/arm-cca-guest/rsi-da.h
+++ b/drivers/virt/coco/arm-cca-guest/rsi-da.h
@@ -32,4 +32,7 @@ static inline int rsi_vdev_id(struct pci_dev *pdev)
 	       PCI_DEVID(pdev->bus->number, pdev->devfn);
 }
 
+int cca_device_lock(struct pci_dev *pdev);
+int cca_device_unlock(struct pci_dev *pdev);
+
 #endif
-- 
2.43.0

