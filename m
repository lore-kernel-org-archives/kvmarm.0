Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901CB340DB8;
	Thu, 10 Sep 2026 14:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789049210; cv=none; b=EMy2Bdmc8RWYMeKXx2J0YoRORDvh+OWFAFfWwPA9+hlSUbyw2EGRUyGrx2RJdOFk+3WvBup2ABrCdqqt3r/mqQ+9HAoB5jiGSc09xSaby0bM6OF0Bj0AtdzBkKDk1FbOwwellruPBWWDCMSJGroRkvjdou3kYhfoHPvQZZGWcSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789049210; c=relaxed/simple;
	bh=9y6ofKb3CBBnvWD+XTFAP396QOIyR9mesB2l9nFChzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=INpxFu6i7LRYPQZqOyLPm3Nsb4zS6hYxkDleJG2gbs9SA6LjP9a7Yh+xQ9A5n9WveCZ4viCJFRo4ycDl1+/Y6lKRzNpfqlexsl7H0c+q6IRWvLpj5/IDEjFIRoc8XmO8uqy/geky6fnCPmCxpRrY8jyA3KHcrKZ97ljlTuaG4VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aW3wpbY0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aW3wpbY0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DD071F00893;
	Thu, 10 Sep 2026 14:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049208;
	bh=8e//6G86LJaRiE5M1GpEgb21G8bE9NJI6seWzHEhfuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aW3wpbY0PM7OcZjDE1nbBr0vGfPf7IFR0Qp27bMXeU8oMPZr63E6tj1BXROkMDg0a
	 opgzzg1Gh0sGIMesLRT0+m8aaT8PzFsnfAKUDn/bPodv3kdeRM9zT0nA3RSXW6LThj
	 KRsz2AEiHMTwErtBO2ozWkwV0Toi6DaYcj6m9ufsXHsY08lT4BSI/397OvV9Sc7Rrs
	 mbWv9bri20OlsIKwkm57YDUOcFVyplavzltFuYgINahgBzD4tb6uliiMG7FpzdvomL
	 DXS9VWWhMU8zDo8sXPrrozdOhX+L22aGby9qF/InfPWJxjvz9ssqwzlYAU2kOKFqk2
	 IrwzkH5OVTmWw==
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
Subject: [PATCH v5 13/15] PCI/TSM: Move CMA DOE mailbox discovery out of pci_tsm_pf0_constructor()
Date: Thu, 10 Sep 2026 19:35:06 +0530
Message-ID: <20260910140509.868402-14-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260910140509.868402-1-aneesh.kumar@kernel.org>
References: <20260910140509.868402-1-aneesh.kumar@kernel.org>
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
 drivers/crypto/ccp/sev-dev-tsm.c      | 13 +++++++++++++
 drivers/pci/tsm.c                     | 13 +++++++------
 drivers/virt/coco/arm-cca-host/main.c | 15 ++++++++++++---
 3 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev-tsm.c b/drivers/crypto/ccp/sev-dev-tsm.c
index 46f2539d2d5a..e55eaca16998 100644
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
diff --git a/drivers/pci/tsm.c b/drivers/pci/tsm.c
index 5fdcd7f2e820..34805b7ba7a0 100644
--- a/drivers/pci/tsm.c
+++ b/drivers/pci/tsm.c
@@ -744,12 +744,13 @@ int pci_tsm_pf0_constructor(struct pci_dev *pdev, struct pci_tsm_pf0 *tsm,
 			    struct tsm_dev *tsm_dev)
 {
 	mutex_init(&tsm->lock);
-	tsm->doe_mb = pci_find_doe_mailbox(pdev, PCI_VENDOR_ID_PCI_SIG,
-					   PCI_DOE_FEATURE_CMA);
-	if (!tsm->doe_mb) {
-		pci_warn(pdev, "TSM init failure, no CMA mailbox\n");
-		return -ENODEV;
-	}
+	/*
+	 * Note, low-level TSM driver responsible for determining if it wants to
+	 * proceed with a device that has no DOE mailbox. TSM may have an
+	 * alternate method for coordinating TDISP.
+	 */
+	if (!tsm->doe_mb)
+		pci_dbg(pdev, "No CMA mailbox\n");
 
 	return pci_tsm_link_constructor(pdev, &tsm->base_tsm, tsm_dev);
 }
diff --git a/drivers/virt/coco/arm-cca-host/main.c b/drivers/virt/coco/arm-cca-host/main.c
index b74fe1fb14fd..70cbff181561 100644
--- a/drivers/virt/coco/arm-cca-host/main.c
+++ b/drivers/virt/coco/arm-cca-host/main.c
@@ -12,6 +12,7 @@
 #include <linux/tsm.h>
 #include <linux/vmalloc.h>
 #include <linux/cleanup.h>
+#include <linux/pci-doe.h>
 
 #include "rmi-da.h"
 
@@ -33,14 +34,22 @@ static struct pci_tsm *cca_tsm_pci_probe(struct tsm_dev *tsm_dev, struct pci_dev
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
-- 
2.43.0

