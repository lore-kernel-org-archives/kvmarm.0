Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A60EEEBB;
	Thu, 12 Mar 2026 08:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302891; cv=none; b=iu9ULjdzM9DuSk+YDuXVutrkeUR6gIOmLkOUD/2tMOF8+hCL3C1tspXEO/eNYJTOc6kmKMG6WZeFkx8oGVjVv8wY79vFT6JmGv1+gLF2onamqCPKa00hR88DuVly2DBS6njLbOR1m1LkKUTIQYPUsE0onLNrp8DRY3zTIYs6YLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302891; c=relaxed/simple;
	bh=aRm1lQS3hKRKbdoEPdvu+WNUSy7Gwarjmise2b85Vgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4sbkJUPG3mh+Rb3MZPnu6QmUYq2F0IaLTvpwGtuyi8orBH0ETjIogHWMFqEi74hZ5MNfDaPpo9o3veKJca8w+zUsat/hde+LSYYA+CxlNoIUAP0hE07H/A6O/FsOjBuIdZ5XbnMgvVeB1AVlZLHVcV+NscYLNxMZ3bgz8qOT/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bFpo44/U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bFpo44/U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5422FC116C6;
	Thu, 12 Mar 2026 08:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302891;
	bh=aRm1lQS3hKRKbdoEPdvu+WNUSy7Gwarjmise2b85Vgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFpo44/U/N1ipatJJVRukyln2v17e8P+esAc0gg2qhWDEeF9925wNHYRytXglL7Xp
	 RpCJogCioAY94h2Opiit1ZxFaPVTZ9PP7FlQbhcXTqPOiwB55vf4AD6a0jeWR+KH9D
	 uPRCp8P6Nx5IotKhV0j8YNu1AnGetTN+1abO8rmgyKzYG/AVG/ufE44eIZeApJJqSS
	 1FIiiuCRIfPwETzk6R6dgCaZAmLKT9NiHGH33xQenlT8dM7cSMi6GQ4/GzoVTSfDUs
	 RIdS2asfLPef+QPCyHzD2TgmJ18NV53C9mWZOxxdrCinR2Ip5dyUqa6yEsBRBgwErb
	 9U+ED3A13vnfQ==
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
Subject: [RFC PATCH v3 03/12] coco: host: arm64: Add helpers to unlock and destroy RMM vdev
Date: Thu, 12 Mar 2026 13:37:34 +0530
Message-ID: <20260312080743.3487326-4-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260312080743.3487326-1-aneesh.kumar@kernel.org>
References: <20260312080743.3487326-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

- define the SMCCC IDs and inline wrappers for `RMI_VDEV_UNLOCK` and
  RMI_VDEV_DESTROY
- extend `vdev_create()` to treat communication failures as fatal and
  tear down the newly created vdev
- provide `vdev_unlock_and_destroy()` that drives the vdev back to the
  unlocked state, issues the destroy call, and frees the delegated granule
- hook the new helper into the TSM unbind path so host cleanup always
  unlock and destroy RMM vdev and releases cached buffers

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
 arch/arm64/include/asm/rmi_cmds.h        | 22 ++++++++++
 arch/arm64/include/asm/rmi_smc.h         |  2 +
 drivers/virt/coco/arm-cca-host/arm-cca.c | 25 ++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.c  | 52 ++++++++++++++++++++++--
 drivers/virt/coco/arm-cca-host/rmi-da.h  |  2 +
 5 files changed, 100 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index 2a86de5eb160..5964549aca23 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -639,4 +639,26 @@ static inline unsigned long rmi_vdev_lock(unsigned long rd,
 	return res.a0;
 }
 
+static inline unsigned long rmi_vdev_unlock(unsigned long rd,
+					    unsigned long pdev_phys,
+					    unsigned long vdev_phys)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_UNLOCK, rd, pdev_phys, vdev_phys, &res);
+
+	return res.a0;
+}
+
+static inline unsigned long rmi_vdev_destroy(unsigned long rd,
+					     unsigned long pdev_phys,
+					     unsigned long vdev_phys)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_DESTROY, rd, pdev_phys, vdev_phys, &res);
+
+	return res.a0;
+}
+
 #endif /* __ASM_RMI_CMDS_H */
diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index 20c36a01df94..95ddbc6dd1e0 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -57,7 +57,9 @@
 #define SMC_RMI_VDEV_ABORT		SMC_RMI_CALL(0x0185)
 #define SMC_RMI_VDEV_COMMUNICATE	SMC_RMI_CALL(0x0186)
 #define SMC_RMI_VDEV_CREATE		SMC_RMI_CALL(0x0187)
+#define SMC_RMI_VDEV_DESTROY		SMC_RMI_CALL(0x0188)
 #define SMC_RMI_VDEV_GET_STATE		SMC_RMI_CALL(0x0189)
+#define SMC_RMI_VDEV_UNLOCK		SMC_RMI_CALL(0x018A)
 
 #define SMC_RMI_VDEV_LOCK		SMC_RMI_CALL(0x01D2)
 
diff --git a/drivers/virt/coco/arm-cca-host/arm-cca.c b/drivers/virt/coco/arm-cca-host/arm-cca.c
index ae62749f36e8..1c17269809a1 100644
--- a/drivers/virt/coco/arm-cca-host/arm-cca.c
+++ b/drivers/virt/coco/arm-cca-host/arm-cca.c
@@ -253,12 +253,37 @@ static struct pci_tdi *cca_tsm_bind(struct pci_dev *pdev, struct kvm *kvm, u32 t
 	return &no_free_ptr(host_tdi)->tdi;
 }
 
+/*
+ * All device memory should be unmapped by now.
+ * 1. A pci device destroy will cause a driver remove (vfio) which will have
+ *    done a dmabuf based unmap
+ * 2. A vdevice/idevice destroy from VMM should have done a unmap_private_range
+ *    vm ioctl before
+ * 3. A guest unlock request should have done a rsi_invalidiate_mem_mapping
+ *    before unlock rhi
+ * 4. vfio_pci_core_close_device() should trigger tsm unbind if vdevice is not
+ *    already distroyed and that path involves vfio_pci_dma_buf_cleanup() which
+ *    should get kvm to unmap the devmap
+ */
+static void cca_tsm_unbind(struct pci_tdi *tdi)
+{
+	struct cca_host_tdi *host_tdi;
+	struct realm *realm = &tdi->kvm->arch.realm;
+
+	host_tdi = container_of(tdi, struct cca_host_tdi, tdi);
+	cca_vdev_unlock_and_destroy(realm, tdi->pdev, tdi->pdev->tsm->dsm_dev);
+	kvfree(host_tdi->interface_report);
+	kvfree(host_tdi->measurements);
+	kfree(host_tdi);
+}
+
 static struct pci_tsm_ops cca_link_pci_ops = {
 	.probe = cca_tsm_pci_probe,
 	.remove = cca_tsm_pci_remove,
 	.connect = cca_tsm_connect,
 	.disconnect = cca_tsm_disconnect,
 	.bind = cca_tsm_bind,
+	.unbind = cca_tsm_unbind,
 };
 
 static void cca_link_tsm_remove(void *tsm_dev)
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index 336a4f5a832d..2181430c47b5 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -771,15 +771,25 @@ void *cca_vdev_create(struct realm *realm, struct pci_dev *pdev,
 	host_tdi->rmm_vdev = rmm_vdev;
 	host_tdi->realm = realm;
 
-	submit_vdev_state_transition_work(pdev, RMI_VDEV_UNLOCKED);
+	ret = submit_vdev_state_transition_work(pdev, RMI_VDEV_UNLOCKED);
+	/* failure is treated as rmi_vdev_create failure */
+	if (ret)
+		goto err_vdev_comm;
 
-	ret = rmi_vdev_lock(rd_phys, rmm_pdev_phys, rmm_vdev_phys);
+	if (rmi_vdev_lock(rd_phys, rmm_pdev_phys, rmm_vdev_phys)) {
+		ret = -ENXIO;
+		goto err_vdev_comm;
+	}
 
-	submit_vdev_state_transition_work(pdev, RMI_VDEV_LOCKED);
+	ret = submit_vdev_state_transition_work(pdev, RMI_VDEV_LOCKED);
+	if (ret)
+		goto err_vdev_comm;
 
 	free_page((unsigned long)params);
 	return rmm_vdev;
 
+err_vdev_comm:
+	rmi_vdev_destroy(rd_phys, rmm_pdev_phys, rmm_vdev_phys);
 err_vdev_create:
 	free_page((unsigned long)params);
 err_params_alloc:
@@ -791,3 +801,39 @@ void *cca_vdev_create(struct realm *realm, struct pci_dev *pdev,
 err_out:
 	return ERR_PTR(ret);
 }
+
+void cca_vdev_unlock_and_destroy(struct realm *realm,
+				 struct pci_dev *pdev, struct pci_dev *pf0_dev)
+{
+	int ret;
+	phys_addr_t rmm_pdev_phys;
+	phys_addr_t rmm_vdev_phys;
+	struct cca_host_pf0_dsc *pf0_dsc;
+	struct cca_host_tdi *host_tdi;
+	phys_addr_t rd_phys = virt_to_phys(realm->rd);
+
+	host_tdi = to_cca_host_tdi(pdev);
+	rmm_vdev_phys = virt_to_phys(host_tdi->rmm_vdev);
+
+	pf0_dsc = to_cca_pf0_dsc(pf0_dev);
+	rmm_pdev_phys = virt_to_phys(pf0_dsc->rmm_pdev);
+	if (rmi_vdev_unlock(rd_phys, rmm_pdev_phys, rmm_vdev_phys)) {
+		pci_err(pdev, "failed to unlock vdev\n");
+		goto unlock_err;
+	}
+
+	ret = submit_vdev_state_transition_work(pdev, RMI_VDEV_UNLOCKED);
+	if (ret)
+		pci_err(pdev, "failed to unlock vdev (%d)\n", ret);
+
+unlock_err:
+	/* Try to destroy even in case of error */
+	if (rmi_vdev_destroy(rd_phys, rmm_pdev_phys, rmm_vdev_phys))
+		pci_err(pdev, "failed to destroy vdev\n");
+
+	if (!rmi_granule_undelegate(rmm_vdev_phys))
+		free_page((unsigned long)host_tdi->rmm_vdev);
+
+	host_tdi->rmm_vdev = NULL;
+	host_tdi->realm = NULL;
+}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index e92078ae9a90..9b0af1ac208f 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -141,4 +141,6 @@ int cca_pdev_ide_setup(struct pci_dev *pdev);
 void cca_pdev_stop_and_destroy(struct pci_dev *pdev);
 void *cca_vdev_create(struct realm *realm, struct pci_dev *pdev,
 		      struct pci_dev *pf0_dev, u32 guest_rid);
+void cca_vdev_unlock_and_destroy(struct realm *realm, struct pci_dev *pdev,
+				 struct pci_dev *pf0_dev);
 #endif
-- 
2.43.0

