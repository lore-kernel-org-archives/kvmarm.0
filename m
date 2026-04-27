Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B793264FA;
	Mon, 27 Apr 2026 06:52:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777272768; cv=none; b=HdIjSlW8+1REhp4h/shtGaFJSefZymS22I6rQQWQ2gXM6+QeeONjj/qQxTuJaTM1DW2ktdDCyvg03NnZHUTaLxXNJ/Jvr+q1V1YwDVbgNO7b4Fq0Psi7vqQ1PiT5IYcpo3nESpxzCfzXNOk+6XK6IxnhWQfs9b6Zp8mlTkS/S6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777272768; c=relaxed/simple;
	bh=437kH86jrTn4c1Epnw3resuWckEvIYjsHBmw7fIP+EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5qRGNfPTTtWp7eZy4N0yFIls6wg1BqyoD7CtdkPz6OUgLjhha9W0vYCMV9UnjXKJBE9LhFFDg8sQxkJjWBMN0Fet1XlcB9cGM6y4U/zOAvjhVoGZhl+Zbk3GsZ3S/dcr/FT0XG66BqTlMoXFYvwwswo8yZqL29wiSTioQgakl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VsTz+yqz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VsTz+yqz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05037C2BCC4;
	Mon, 27 Apr 2026 06:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777272767;
	bh=437kH86jrTn4c1Epnw3resuWckEvIYjsHBmw7fIP+EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VsTz+yqzRX5JWFXZZf9VJOF0bKQiZOVuDoPji4g1OmLkdzebLsB7i4cbYXSfeRtx5
	 OvMcZDNbo6zJY/e2lIT01+Bq+26mBgFksiGi8UW5EOedPKDFI91fFD7iaz4icdS5+G
	 ZpcA79VuLeFLsJ38vg5yj29PUrrMYXmVYk8dQUqDt4UwvojIoCZT7Q+6pDc6w7n6wz
	 v4STTOPn8lwri6ZSGF3vcDKCEaEYx2hg2GSCjn79CvQR7ueHMn9Ho7H86liZ0QGP9D
	 aqz/pQ5iYC7EngUQpuaUrOpKeS7Wt417IWVlBkqqJATaz1pd0FTczxlP79EkIgqfZ2
	 Uf6XsOqxcIqXg==
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
Subject: [RFC PATCH v4 13/14] PCI/TSM: Move CMA DOE mailbox discovery out of pci_tsm_pf0_constructor()
Date: Mon, 27 Apr 2026 12:21:20 +0530
Message-ID: <20260427065121.916615-14-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427065121.916615-1-aneesh.kumar@kernel.org>
References: <20260427065121.916615-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

pci_tsm_pf0_constructor() currently looks up a CMA DOE mailbox and
fails PF0 initialization when one is not present. That is too strict
for all link TSM drivers.

Move CMA DOE mailbox discovery into the low-level PF0 probe callbacks
so each driver can decide whether a mailbox is mandatory.

Keep SEV-TIO and TDX requiring a CMA mailbox, while allowing the
arm-cca host path to proceed on PF0 devices that do not support IDE
and therefore have no DOE-based SPDM path.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/crypto/ccp/sev-dev-tsm.c         | 13 +++++++++++++
 drivers/pci/tsm/core.c                   | 14 ++++++++------
 drivers/virt/coco/arm-cca-host/arm-cca.c | 16 +++++++++++++---
 drivers/virt/coco/tdx-host/tdx-host.c    | 13 +++++++++++++
 4 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index b07ae529b591..a7506cbbe392 100644
--- a/drivers/crypto/ccp/sev-dev-tsm.c
+++ b/drivers/crypto/ccp/sev-dev-tsm.c
@@ -217,6 +217,19 @@ static struct pci_tsm *tio_pf0_probe(struct pci_dev *pdev, struct sev_device *se
 	if (rc)
 		return NULL;
 
+	/* if device have ide cap, setup doe mailbox */
+	if (pdev->ide_cap) {
+		struct pci_doe_mb *doe_mb;
+
+		doe_mb = pci_find_doe_mailbox(pdev, PCI_VENDOR_ID_PCI_SIG,
+					      PCI_DOE_FEATURE_CMA);
+		if (!doe_mb)
+			return NULL;
+		dsm->tsm.doe_mb = doe_mb;
+	} else {
+		return NULL;
+	}
+
 	pci_dbg(pdev, "TSM enabled\n");
 	dsm->sev = sev;
 	return &no_free_ptr(dsm)->tsm.base_tsm;
diff --git a/drivers/pci/tsm/core.c b/drivers/pci/tsm/core.c
index bb440135b8f7..900306a43161 100644
--- a/drivers/pci/tsm/core.c
+++ b/drivers/pci/tsm/core.c
@@ -1236,12 +1236,14 @@ int pci_tsm_pf0_constructor(struct pci_dev *pdev, struct pci_tsm_pf0 *tsm,
 			    struct tsm_dev *tsm_dev)
 {
 	mutex_init(&tsm->lock);
-	tsm->doe_mb = pci_find_doe_mailbox(pdev, PCI_VENDOR_ID_PCI_SIG,
-					   PCI_DOE_FEATURE_CMA);
-	if (!tsm->doe_mb) {
-		pci_warn(pdev, "TSM init failure, no CMA mailbox\n");
-		return -ENODEV;
-	}
+
+	/*
+	 * Note, low-level TSM driver responsible for determining if it wants to
+	 * proceed with a device that has no DOE mailbox. TSM may have an
+	 * alternate method for coordinating TDISP.
+	 */
+	if (!tsm->doe_mb)
+		pci_dbg(pdev, "no CMA mailbox\n");
 
 	return pci_tsm_link_constructor(pdev, &tsm->base_tsm, tsm_dev);
 }
diff --git a/drivers/virt/coco/arm-cca-host/arm-cca.c b/drivers/virt/coco/arm-cca-host/arm-cca.c
index 0b1200f591ab..265aa0cb612a 100644
--- a/drivers/virt/coco/arm-cca-host/arm-cca.c
+++ b/drivers/virt/coco/arm-cca-host/arm-cca.c
@@ -11,6 +11,8 @@
 #include <linux/tsm.h>
 #include <linux/vmalloc.h>
 #include <linux/cleanup.h>
+#include <linux/pci-doe.h>
+
 
 #include "rmi-da.h"
 
@@ -35,14 +37,22 @@ static struct pci_tsm *cca_tsm_pci_probe(struct tsm_dev *tsm_dev, struct pci_dev
 		return &no_free_ptr(fn_dsc)->pci;
 	}
 
-	if (!pdev->ide_cap)
-		return NULL;
-
 	struct cca_host_pf0_ep_dsc *pf0_ep_dsc __free(kfree) =
 		kzalloc(sizeof(*pf0_ep_dsc), GFP_KERNEL);
 	if (!pf0_ep_dsc)
 		return NULL;
 
+	/* if device have ide cap, setup doe mailbox */
+	if (pdev->ide_cap) {
+		struct pci_doe_mb *doe_mb;
+
+		doe_mb = pci_find_doe_mailbox(pdev, PCI_VENDOR_ID_PCI_SIG,
+					      PCI_DOE_FEATURE_CMA);
+		if (!doe_mb)
+			return NULL;
+		pf0_ep_dsc->pci.doe_mb = doe_mb;
+	}
+
 	ret = pci_tsm_pf0_constructor(pdev, &pf0_ep_dsc->pci, tsm_dev);
 	if (ret)
 		return NULL;
diff --git a/drivers/virt/coco/tdx-host/tdx-host.c b/drivers/virt/coco/tdx-host/tdx-host.c
index ea7c2167660f..4947b9bc2359 100644
--- a/drivers/virt/coco/tdx-host/tdx-host.c
+++ b/drivers/virt/coco/tdx-host/tdx-host.c
@@ -634,6 +634,19 @@ static struct pci_tsm *tdx_link_pf0_probe(struct tsm_dev *tsm_dev,
 	spdm_conf->vmm_spdm_cap = SPDM_CAP_KEY_UPD;
 	spdm_conf->certificate_slot_mask = 0xff;
 
+	/* if device have ide cap, setup doe mailbox */
+	if (pdev->ide_cap) {
+		struct pci_doe_mb *doe_mb;
+
+		doe_mb = pci_find_doe_mailbox(pdev, PCI_VENDOR_ID_PCI_SIG,
+					      PCI_DOE_FEATURE_CMA);
+		if (!doe_mb)
+			return NULL;
+		tlink->pci.doe_mb = doe_mb;
+	} else {
+		return NULL;
+	}
+
 	tlink->in_msg = no_free_ptr(in_msg);
 	tlink->out_msg = no_free_ptr(out_msg);
 	tlink->spdm_conf = no_free_ptr(spdm_conf);
-- 
2.43.0

