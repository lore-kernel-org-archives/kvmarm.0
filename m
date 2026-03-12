Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9942D2E88BB;
	Thu, 12 Mar 2026 08:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302939; cv=none; b=TWRU88mrx5Zhl1Gil5nokrCdPIN5XmwRpn1YgCAqsra6C2DFlPe32JB3M5ua2xyObLdBKs7AJuNMs29CHk1LANV/HpA5vqy2aBonPeB5VQd26VSkk9p30M9srbKTdkfA7+pzV9vWMXk4TQm8VPHcSweWETFl0S72Qmkm4mH/cHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302939; c=relaxed/simple;
	bh=F+SD1gK/ryzJsR3fJzETL4gO9WXnEH2pDqIk5u0+PyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LPPjhpnYnMOuyufhCHjhTPpCeISPC4+NTRZKBRzqZ/GRkgyDJsoBK2BWXAamoA9MOK8ckguOzvI8NRVTT+h8Nr/1stBYoiTS+qgL/lZ35PQQ4ZRx7WlfP4qx04SlQh/hKQ8nZVdKLzFMiPExONMw3prb+KZXxZmXS+z8cwNmc6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FEWW391J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FEWW391J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE2DBC19424;
	Thu, 12 Mar 2026 08:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302939;
	bh=F+SD1gK/ryzJsR3fJzETL4gO9WXnEH2pDqIk5u0+PyI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FEWW391J9jzh11jpwatafPMHfucdZ05CXxCNGg5ddU6A5ttlJzc34/zGxUbI2Rgp8
	 1P2sdXtYNLRfcw3cFsS/b1rdi0uHB+w9MzKdpRkFFVhBRgEPFv5i1U2RATH9BrPZLl
	 7us7kglN2AeodLR6xkfe6TC+Fow9KLttbDwfgA30EzaPchm+hDcXkxPjxzu0vNw/aU
	 cY6TN4VdwQgs5X1d6o9oZx70cUELDxsYSTvKiSQ+pHJNmFr6LncfwZhmg3HTvaM8tj
	 1mUpYUCuJzcU4heWpP5me3g0qvh+1QrHJ9bf+oIKx2VY6td8915FeZ1ZfFtAzKJLss
	 GjPrmL4NSgbKQ==
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
Subject: [RFC PATCH v3 11/12] coco: host: arm64: Transition vdevs to TDISP RUN state
Date: Thu, 12 Mar 2026 13:37:42 +0530
Message-ID: <20260312080743.3487326-12-aneesh.kumar@kernel.org>
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

- define SMC_RMI_VDEV_START and the __RHI_DA_VDEV_SET_TDI_STATE
- let the host guest TSM request handler (__RHI_DA_SET_TDI_STATE) accept
  RHI_DA_TDI_CONFIG_RUN and call into rmi_vdev_start()
- The RHI_DA_TDI_CONFIG_UNLOCKED and RHI_DA_TDI_CONFIG_LOCKED transition
  will be handled by the VMM
- wait for the firmware to report vdev state as RMI_VDEV_STARTED before
  returning

With this in place, a guest can move a vdev from LOCKED into the TDISP
RUN state once attestation completes.

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
 arch/arm64/include/asm/rhi.h             |  1 +
 arch/arm64/include/asm/rmi_cmds.h        | 10 ++++++++++
 arch/arm64/include/asm/rmi_smc.h         |  1 +
 arch/arm64/include/uapi/asm/rmi-da.h     |  5 +++++
 drivers/virt/coco/arm-cca-host/arm-cca.c | 15 +++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.c  | 22 ++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.h  |  1 +
 7 files changed, 55 insertions(+)

diff --git a/arch/arm64/include/asm/rhi.h b/arch/arm64/include/asm/rhi.h
index ba9e11152c1b..68780918e28b 100644
--- a/arch/arm64/include/asm/rhi.h
+++ b/arch/arm64/include/asm/rhi.h
@@ -86,5 +86,6 @@ enum rhi_tdi_state {
 #define __RHI_DA_VDEV_GET_MEASUREMENTS	0x4
 #define __REC_EXIT_DA_VDEV_REQUEST	0x5
 #define __REC_EXIT_DA_VDEV_MAP		0x6
+#define __RHI_DA_VDEV_SET_TDI_STATE	0x7
 
 #endif
diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index 0c06a4f45346..688414f695f7 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -686,6 +686,16 @@ rmi_vdev_get_device_measurements(unsigned long rd, unsigned long pdev_phys,
 	return res.a0;
 }
 
+static inline unsigned long rmi_vdev_start(unsigned long rd, unsigned long pdev_phys,
+					   unsigned long vdev_phys)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_START, rd, pdev_phys, vdev_phys, &res);
+
+	return res.a0;
+}
+
 static inline unsigned long rmi_vdev_complete(unsigned long rec_phys, unsigned long vdev_phys)
 {
 	struct arm_smccc_res res;
diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index f4b8f1c9ba0b..384bde2d423e 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -67,6 +67,7 @@
 #define SMC_RMI_VDEV_GET_INTERFACE_REPORT SMC_RMI_CALL(0x01D0)
 #define SMC_RMI_VDEV_GET_DEV_MEASUREMENTS	SMC_RMI_CALL(0x01D1)
 #define SMC_RMI_VDEV_LOCK		SMC_RMI_CALL(0x01D2)
+#define SMC_RMI_VDEV_START		SMC_RMI_CALL(0x01D3)
 
 #define RMI_ABI_MAJOR_VERSION	1
 #define RMI_ABI_MINOR_VERSION	0
diff --git a/arch/arm64/include/uapi/asm/rmi-da.h b/arch/arm64/include/uapi/asm/rmi-da.h
index 20d3eab8ce64..dc2855cb05a8 100644
--- a/arch/arm64/include/uapi/asm/rmi-da.h
+++ b/arch/arm64/include/uapi/asm/rmi-da.h
@@ -35,4 +35,9 @@ struct arm64_vdev_device_memmap_guest_req {
 	__aligned_u64 pa_base;
 };
 
+struct arm64_vdev_set_tdi_state_guest_req {
+	__u32 req_type;
+	__u32 tdi_state;
+};
+
 #endif
diff --git a/drivers/virt/coco/arm-cca-host/arm-cca.c b/drivers/virt/coco/arm-cca-host/arm-cca.c
index 405542ffd9d1..9883bf9e0470 100644
--- a/drivers/virt/coco/arm-cca-host/arm-cca.c
+++ b/drivers/virt/coco/arm-cca-host/arm-cca.c
@@ -402,6 +402,21 @@ static ssize_t cca_tsm_guest_req(struct pci_tdi *tdi, enum pci_tsm_req_scope sco
 							    req_obj.gpa_top,
 							    req_obj.pa_base);
 		}
+		case __RHI_DA_VDEV_SET_TDI_STATE:
+		{
+			struct arm64_vdev_set_tdi_state_guest_req req_obj;
+
+			if (req_len != sizeof(req_obj))
+				return -EINVAL;
+
+			if (copy_from_user((void *)&req_obj, req.user, req_len))
+				return -EFAULT;
+
+			if (req_obj.tdi_state != RHI_DA_TDI_CONFIG_RUN)
+				return -EINVAL;
+
+			return cca_vdev_device_start(pdev);
+		}
 		default:
 			return -EINVAL;
 		}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index d76095a3e6c3..877a649dea13 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -1145,3 +1145,25 @@ int cca_vdev_device_map_validate(struct pci_dev *pdev, unsigned long vcpu_fd,
 	return realm_dev_mem_map(kvm, rec_phys, rmm_pdev_phys,
 				 rmm_vdev_phys, gpa_base, gpa_top, pa_base);
 }
+
+int cca_vdev_device_start(struct pci_dev *pdev)
+{
+	phys_addr_t rmm_pdev_phys;
+	phys_addr_t rmm_vdev_phys;
+	struct cca_host_pf0_dsc *pf0_dsc;
+	struct cca_host_tdi *host_tdi;
+	struct realm *realm;
+	phys_addr_t rd_phys;
+
+	host_tdi = to_cca_host_tdi(pdev);
+	rmm_vdev_phys = virt_to_phys(host_tdi->rmm_vdev);
+	realm = &host_tdi->tdi.kvm->arch.realm;
+	rd_phys = virt_to_phys(realm->rd);
+
+	pf0_dsc = to_cca_pf0_dsc(pdev->tsm->dsm_dev);
+	rmm_pdev_phys = virt_to_phys(pf0_dsc->rmm_pdev);
+
+	if (rmi_vdev_start(rd_phys, rmm_pdev_phys, rmm_vdev_phys))
+		return -ENXIO;
+	return submit_vdev_state_transition_work(pdev, RMI_VDEV_STARTED);
+}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index 60b10bce3140..51ef49cb482b 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -157,4 +157,5 @@ int cca_vdev_device_request(struct pci_dev *pdev, unsigned long rec_id);
 int cca_vdev_device_map_validate(struct pci_dev *pdev, unsigned long vcpu_fd,
 				 unsigned long gpa_base, unsigned long gpa_top,
 				 unsigned long pa_base);
+int cca_vdev_device_start(struct pci_dev *pdev);
 #endif
-- 
2.43.0

