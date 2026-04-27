Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECDF385507;
	Mon, 27 Apr 2026 08:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280106; cv=none; b=LlKSAvBaiPveEr1sCECVs8TRUcv28QE6fSrNVVC3zrnRd4jlnuinO3GWFxmxj3mqnS4/zdGP/dOCJ8kru0RUo0DmDV7nzqbUZ+hbrjFa8h4hoToYrWNVJU8dnol8fFjWE/l+C99HWTbwJIhdiDnzm0nNUh6gI4xjxf44fpDZ4hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280106; c=relaxed/simple;
	bh=LXV+r9kFhShkW3woqwoWMcFfbrEWeY/nBG9pHj7xGPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WRhMLWiXnyd8X1bc+wG/HLogjSPJDnJwId5Oe6X5CV+N7xf8KYzMkwft6eAXQRyaq/aomH0odj27IXWdJwSU6l6ZG29d1nyMaI9Wt5FnOTribG35stdbMUjcfHinFG0WQOpARXtBW/7Zs6KUlZNCRPcUqK0+VKaFyMTAith5re4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UXIWP0Mr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UXIWP0Mr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 271D0C2BCB9;
	Mon, 27 Apr 2026 08:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777280105;
	bh=LXV+r9kFhShkW3woqwoWMcFfbrEWeY/nBG9pHj7xGPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXIWP0MrHk6JikCbBUQDEWSNQOsPSsuy+SjfYK1FEkJy1Zgv6PHSzaT6uXtYkjcRa
	 Uxp6Q2stfe7bFUo+Ikp4BZq5l5J8C51PNEWG2W5eDJU323JOfXYuue+xUTKY8anf5q
	 OxeL4b3/Py+7LQRa0NcngMvuBdc/Oel4NYx/BUshwmEtgYJIempNJaIojt8rJma96w
	 818XAv8F7RyYmHUsPxqFqVuTDpTQKzlBcyY6A2JHnKO1w7Ma+ruU1pjmZMA6i5W6BR
	 3ycUKHmrv8fI/aoP4zfEoEBSgAWiyCCTd4L/jFt6J/zngSccLjCktUvPzTktQeaBCW
	 bDSEFMk6ZUsJA==
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
	Joerg Roedel <joro@8bytes.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Samuel Ortiz <sameo@rivosinc.com>,
	Steven Price <steven.price@arm.com>,
	Suzuki K Poulose <Suzuki.Poulose@arm.com>,
	Will Deacon <will@kernel.org>,
	Xu Yilun <yilun.xu@linux.intel.com>
Subject: [RFC PATCH v4 11/16] coco: host: arm64: Fetch interface report via RMI
Date: Mon, 27 Apr 2026 14:23:39 +0530
Message-ID: <20260427085344.941627-12-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427085344.941627-1-aneesh.kumar@kernel.org>
References: <20260427085344.941627-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- define __RHI_DA_VDEV_GET_INTERFACE_REPORT for guest requests and
  expose the RMI SMC ID/wrapper for RMI_VDEV_GET_INTERFACE_REPORT
- teach the CCA host driver to handle the new guest request by fetching
  the report from RMM using rmi_vdev_get_interface_report() and
  refreshing the cached buffer
- add a helper that submits a DOE work to pull the latest report into
  the cache

This lets guests request up-to-date interface reports via RHI

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/rmi_cmds.h        | 12 ++++++
 arch/arm64/include/uapi/asm/rmi-da.h     |  3 ++
 drivers/virt/coco/arm-cca-host/arm-cca.c |  4 ++
 drivers/virt/coco/arm-cca-host/rmi-da.c  | 54 +++++++++++++++++++++++-
 drivers/virt/coco/arm-cca-host/rmi-da.h  |  1 +
 5 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index aa7ef9f07517..b3c04029bb47 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -969,4 +969,16 @@ static inline unsigned long rmi_vdev_destroy(unsigned long rd,
 	return res.a0;
 }
 
+static inline unsigned long rmi_vdev_get_interface_report(unsigned long rd,
+					     unsigned long pdev_phys,
+					     unsigned long vdev_phys)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_GET_INTERFACE_REPORT,
+			     rd, pdev_phys, vdev_phys, &res);
+
+	return res.a0;
+}
+
 #endif /* __ASM_RMI_CMDS_H */
diff --git a/arch/arm64/include/uapi/asm/rmi-da.h b/arch/arm64/include/uapi/asm/rmi-da.h
index 5ec3413dce94..8d36a4c59849 100644
--- a/arch/arm64/include/uapi/asm/rmi-da.h
+++ b/arch/arm64/include/uapi/asm/rmi-da.h
@@ -18,4 +18,7 @@ struct arm64_vdev_object_read_guest_req {
 };
 #define __RHI_DA_OBJECT_READ		0x2
 
+/* No arguments to this guest request */
+#define __RHI_DA_VDEV_UPDATE_INTERFACE_REPORT 0x3
+
 #endif
diff --git a/drivers/virt/coco/arm-cca-host/arm-cca.c b/drivers/virt/coco/arm-cca-host/arm-cca.c
index 4bf1f1b394af..2955993d29ac 100644
--- a/drivers/virt/coco/arm-cca-host/arm-cca.c
+++ b/drivers/virt/coco/arm-cca-host/arm-cca.c
@@ -561,6 +561,10 @@ static ssize_t cca_tsm_guest_req(struct pci_tdi *tdi, enum pci_tsm_req_scope sco
 			/* error */
 			return len;
 		}
+		case __RHI_DA_VDEV_UPDATE_INTERFACE_REPORT:
+		{
+			return cca_vdev_update_interface_report(pdev);
+		}
 		default:
 			return -EINVAL;
 		}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index 63b20c8aef54..1862e4ff8cbb 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -1138,7 +1138,7 @@ void cca_vdev_unlock_and_destroy(struct realm *realm,
 	host_tdi->realm = NULL;
 }
 
-static void __maybe_unused vdev_fetch_object_workfn(struct work_struct *work)
+static void vdev_fetch_object_workfn(struct work_struct *work)
 {
 	int state;
 	struct pci_tsm *tsm;
@@ -1257,3 +1257,55 @@ int cca_vdev_read_cached_object(struct pci_dev *pdev, int type,
 
 	return len;
 }
+
+static int vdev_update_interface_report_cache(struct pci_dev *pdev)
+{
+	struct dev_comm_work comm_work;
+	struct cca_host_tdi *host_tdi = to_cca_host_tdi(pdev);
+	struct cca_host_comm_data *comm_data = to_cca_comm_data(pdev);
+
+	INIT_WORK_ONSTACK(&comm_work.work, vdev_fetch_object_workfn);
+	comm_work.tsm = pdev->tsm;
+	if (host_tdi->interface_report) {
+		comm_work.cache_buf = host_tdi->interface_report->buf;
+		comm_work.cache_offset = &host_tdi->interface_report->offset;
+		comm_work.cache_size = host_tdi->interface_report->size;
+	} else {
+		comm_work.cache_buf = NULL;
+		comm_work.cache_offset = NULL;
+		comm_work.cache_size = 0;
+	}
+
+	queue_work(comm_data->work_queue, &comm_work.work);
+	flush_work(&comm_work.work);
+	destroy_work_on_stack(&comm_work.work);
+
+	if (comm_work.cache_size == 0)
+		return -ENXIO;
+	return 0;
+}
+
+int cca_vdev_update_interface_report(struct pci_dev *pdev)
+{
+	phys_addr_t rmm_pdev_phys;
+	phys_addr_t rmm_vdev_phys;
+	struct cca_host_pdev_dsc *pdev_dsc;
+	struct cca_host_tdi *host_tdi;
+	struct realm *realm;
+	phys_addr_t rd_phys;
+
+	host_tdi = to_cca_host_tdi(pdev);
+	rmm_vdev_phys = virt_to_phys(host_tdi->rmm_vdev);
+	realm = &host_tdi->tdi.kvm->arch.realm;
+	rd_phys = virt_to_phys(realm->rd);
+
+	pdev_dsc = to_cca_pdev_dsc(pdev->tsm->dsm_dev);
+	rmm_pdev_phys = virt_to_phys(pdev_dsc->rmm_pdev);
+
+	if (rmi_vdev_get_interface_report(rd_phys,
+					  rmm_pdev_phys, rmm_vdev_phys))
+		return -ENXIO;
+
+	/* get and update the interface report cache. */
+	return vdev_update_interface_report_cache(pdev);
+}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index c1fc7c01943e..b114bf4d4202 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -248,5 +248,6 @@ void cca_vdev_unlock_and_destroy(struct realm *realm, struct pci_dev *pdev,
 int cca_vdev_get_object_size(struct pci_dev *pdev, int type);
 int cca_vdev_read_cached_object(struct pci_dev *pdev, int type, unsigned long offset,
 		unsigned long max_len, void __user *user_buf);
+int cca_vdev_update_interface_report(struct pci_dev *pdev);
 
 #endif
-- 
2.43.0

