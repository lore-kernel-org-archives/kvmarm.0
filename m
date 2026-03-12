Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3090427470;
	Thu, 12 Mar 2026 08:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302716; cv=none; b=YzB13laBKM1nSKZPD7deFTY/gNk+8VKvyWYJphOU1GDHFRzJU3PqZWlKu9GmpbPQZKP0lopllbyYPBWIjEMTDMrYJv9tLGIPV6nm7RK+mwJuT5irN75CjILDW7svz39OA7Rv/woSrLaxR6RXTcChTuQyqGisVhSD5BDqDe6i2Hs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302716; c=relaxed/simple;
	bh=Zug2KbC+qKpyPQFy5aZ3Snq91MpXjqLfX4iRpg+DcFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jCJ5qtCTbI5zUTTr5jvIGn3FCU3UReye6tGSAnCxlt++1NcxIXv9LmfEL6C12+Kt7m/PIm2OsopTKg2C0d+c1cEfZxrMTNZ9l5UcClbcF6JhVsjnbq/j/hL2gHfVj1AzY7Y8jWce/vxrlNsSUOYjqj2Xt5I2ZGtV55DJa8PevTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Tu3KriES; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Tu3KriES"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57EF2C19424;
	Thu, 12 Mar 2026 08:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302715;
	bh=Zug2KbC+qKpyPQFy5aZ3Snq91MpXjqLfX4iRpg+DcFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tu3KriESxpam7LaWZWZ71I3C9oSaaLmYWjY7TnTHc9tYehqRs99ZU2EVoCikCq0aY
	 pO2hXD5lgOdZjVRXRf5ZPU9eKta2PUUbXI8LOJSCQa+Gk6aDZ7WvCERLNJ7MyBoSyu
	 DKvU9vFp52Bc482JU9xeRs2rN3WmiYyQqFmyNVIA6rCWgfe2aowzo+BswwDLrBUA+n
	 cp7vq6NcR5lfaIX0yy/p0UZJFG5BZ+1HYxKqwAcdyV5uK5/pRuyj7WJ2TGy7K96KW7
	 Hc1ZU09UGYvwfoEQ75sfGhNhvXccHeV8LTNkk/q4H5H0QOd/g+ulMt05bClOKBClHR
	 JIXAXdiQonmUA==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org,
	"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Dan Williams <dan.j.williams@intel.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Steven Price <steven.price@arm.com>
Subject: [RFC PATCH v3 04/11] coco: guest: arm64: Support guest-initiated TDI lock/unlock transitions
Date: Thu, 12 Mar 2026 13:34:35 +0530
Message-ID: <20260312080442.3485633-5-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260312080442.3485633-1-aneesh.kumar@kernel.org>
References: <20260312080442.3485633-1-aneesh.kumar@kernel.org>
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

Cc: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alexey Kardashevskiy <aik@amd.com>
Cc: Samuel Ortiz <sameo@rivosinc.com>
Cc: Xu Yilun <yilun.xu@linux.intel.com>
Cc: Suzuki K Poulose <Suzuki.Poulose@arm.com>
Cc: Steven Price <steven.price@arm.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/arm-cca-guest/Makefile  |  2 +-
 drivers/virt/coco/arm-cca-guest/arm-cca.c |  9 ++++--
 drivers/virt/coco/arm-cca-guest/rsi-da.c  | 34 +++++++++++++++++++++++
 drivers/virt/coco/arm-cca-guest/rsi-da.h  |  2 ++
 4 files changed, 44 insertions(+), 3 deletions(-)
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
index 07f74f67d22c..5e3a66315c70 100644
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
index 858bfdaf59c9..3619a75e160e 100644
--- a/drivers/virt/coco/arm-cca-guest/rsi-da.h
+++ b/drivers/virt/coco/arm-cca-guest/rsi-da.h
@@ -32,4 +32,6 @@ static inline int rsi_vdev_id(struct pci_dev *pdev)
 	       PCI_DEVID(pdev->bus->number, pdev->devfn);
 }
 
+int cca_device_lock(struct pci_dev *pdev);
+int cca_device_unlock(struct pci_dev *pdev);
 #endif
-- 
2.43.0

