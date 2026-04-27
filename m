Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF31F3890F1;
	Mon, 27 Apr 2026 08:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280068; cv=none; b=cj0Pyu5G6/+BQ/YCxMyKYYik9DlTeCjW/JQ9mkW5qmLoev0xfnSNfuw9Igl5WiAe0xASPrNw/ec5bnhzz6sqKA0mZ/RWNYp+I0QLfz2Vx6kE3umQjkCif1hLG9IWPULe6pMX5Ju1GGc/6BVyl9uPgmIiFHVpr048/sIvPw5Kw6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280068; c=relaxed/simple;
	bh=FOF/N6svtbYXkGkRtOl5nbIuWVYKzN47ZE69SrsJ4UY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRIGc2RAgoJsnAZzeoZumwcnBi7/JxkdyN3bdaBrsV1nmMvbe8YXAvqCQoYPVm53jO9HFvej1++50xjrooSs6omMfST21xlunNq75RB04FrBN7n4vg50YVsIHq5blSZq7nqzFrxmGp77i5ZhzDJ2bpjoEAHQscZZvF/9EOtABwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JA6emOxf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JA6emOxf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B94EEC2BCB4;
	Mon, 27 Apr 2026 08:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777280068;
	bh=FOF/N6svtbYXkGkRtOl5nbIuWVYKzN47ZE69SrsJ4UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JA6emOxfNKuMPIpJNxD+2IadSL623hobFCmhFlWMSMbQjYFishDijB7/UtSX0Pe+h
	 xWbIHh2Pa7DtK4ROee/n4yIFqpw9yWlBY5sk5y1l++Nz0XgRKuGdVA4+7mmzphHVTs
	 8SzFpmrNc11xxEl5MDjsFKwvfDu76kIZkGZ45q/m8Zl+jfgiYMLDiT8SLPVSKUnOb8
	 fmNWCALzAZ9PKceFAuXwcj9rndedMWmHoUR/tQRJN+72rU2bahiZuA7bgCMoMoDH1d
	 t8KjCLtQtDVo8FO/slKUtXFanJKJX73/RUL/5TDsu5Gk7jii73V8gHeg47GG6C3P8d
	 wFiIDcLkGCp7Q==
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
Subject: [RFC PATCH v4 05/16] coco: host: arm64: Add support for virtual device communication
Date: Mon, 27 Apr 2026 14:23:33 +0530
Message-ID: <20260427085344.941627-6-aneesh.kumar@kernel.org>
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

Add support for vdev_communicate with RMM.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/rmi_cmds.h       | 32 ++++++++++
 arch/arm64/include/asm/rmi_smc.h        |  7 +++
 drivers/virt/coco/arm-cca-host/rmi-da.c | 83 ++++++++++++++++++++++---
 drivers/virt/coco/arm-cca-host/rmi-da.h | 20 ++++++
 4 files changed, 135 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index 205fc200d1db..2925abde3882 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -871,4 +871,36 @@ int rmi_psmmu_st_l2_create(unsigned long psmmu_phys,
 int rmi_psmmu_st_l2_destroy(unsigned long psmmu_phys,
 		    unsigned long stream_id, unsigned long *rmi_ret);
 
+static inline unsigned long rmi_vdev_communicate(unsigned long rd_phys,
+		unsigned long pdev_phys, unsigned long vdev_phys,
+		unsigned long vdev_comm_data_phys)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_COMMUNICATE, rd_phys, pdev_phys,
+			     vdev_phys, vdev_comm_data_phys, &res);
+
+	return res.a0;
+}
+
+static inline unsigned long rmi_vdev_get_state(unsigned long vdev_phys,
+		enum rmi_vdev_state *state)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_GET_STATE, vdev_phys, &res);
+
+	*state = res.a1;
+	return res.a0;
+}
+
+static inline unsigned long rmi_vdev_abort(unsigned long vdev_phys)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_VDEV_ABORT, vdev_phys, &res);
+
+	return res.a0;
+}
+
 #endif /* __ASM_RMI_CMDS_H */
diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index 5b540d25914e..72e4a53b74b0 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -643,4 +643,11 @@ struct rmi_psmmu_params {
 	};
 };
 
+enum rmi_vdev_state {
+	RMI_VDEV_NEW,
+	RMI_VDEV_UNLOCKED,
+	RMI_VDEV_LOCKED,
+	RMI_VDEV_STARTED,
+	RMI_VDEV_ERROR,
+};
 #endif /* __ASM_RMI_SMC_H */
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index 33a2551fd09f..d61c3191c038 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -11,6 +11,8 @@
 #include <crypto/internal/rsa.h>
 #include <keys/asymmetric-type.h>
 #include <keys/x509-parser.h>
+#include <linux/kvm_types.h>
+#include <asm/kvm_rmi.h>
 
 #include "rmi-da.h"
 
@@ -217,6 +219,7 @@ static int _do_dev_communicate(enum dev_comm_type type, struct pci_tsm *tsm, int
 	gfp_t cache_alloc_flags;
 	int nbytes, cp_len;
 	struct cache_object **cache_objp, *cache_obj;
+	struct cca_host_tdi *host_tdi = to_cca_host_tdi(tsm->pdev);
 	struct cca_host_pdev_dsc *pdev_dsc = to_cca_pdev_dsc(tsm->dsm_dev);
 	struct cca_host_comm_data *comm_data = to_cca_comm_data(tsm->pdev);
 	struct rmi_dev_comm_enter *io_enter = &comm_data->io_params->enter;
@@ -228,7 +231,10 @@ static int _do_dev_communicate(enum dev_comm_type type, struct pci_tsm *tsm, int
 		rmi_ret = rmi_pdev_communicate(virt_to_phys(pdev_dsc->rmm_pdev),
 					       virt_to_phys(comm_data->io_params));
 	else
-		rmi_ret = RMI_ERROR_INPUT;
+		rmi_ret = rmi_vdev_communicate(virt_to_phys(host_tdi->realm->rd),
+					       virt_to_phys(pdev_dsc->rmm_pdev),
+					       virt_to_phys(host_tdi->rmm_vdev),
+					       virt_to_phys(comm_data->io_params));
 	if (rmi_ret != RMI_SUCCESS) {
 		if (rmi_ret == RMI_BUSY)
 			return -EBUSY;
@@ -252,6 +258,12 @@ static int _do_dev_communicate(enum dev_comm_type type, struct pci_tsm *tsm, int
 		case RMI_DEV_CERTIFICATE:
 			cache_objp = &pf0_ep_dsc->cert_chain.cache;
 			break;
+		case RMI_DEV_INTERFACE_REPORT:
+			cache_objp = &host_tdi->interface_report;
+			break;
+		case RMI_DEV_MEASUREMENTS:
+			cache_objp = &host_tdi->measurements;
+			break;
 		default:
 			return -EINVAL;
 		}
@@ -355,9 +367,11 @@ static int _do_dev_communicate(enum dev_comm_type type, struct pci_tsm *tsm, int
 static int do_dev_communicate(enum dev_comm_type type,
 		struct pci_tsm *tsm, unsigned long error_state, int *stream_wait)
 {
-	int ret, state = error_state;
+	int ret, state;
+	unsigned long rmi_ret;
 	struct rmi_dev_comm_enter *io_enter;
 	struct cca_host_pdev_dsc *pdev_dsc = to_cca_pdev_dsc(tsm->dsm_dev);
+	struct cca_host_tdi *host_tdi = to_cca_host_tdi(tsm->pdev);
 
 	io_enter = &pdev_dsc->comm_data.io_params->enter;
 	io_enter->resp_len = 0;
@@ -369,16 +383,23 @@ static int do_dev_communicate(enum dev_comm_type type,
 	if (ret) {
 		if (type == PDEV_COMMUNICATE)
 			rmi_pdev_abort(virt_to_phys(pdev_dsc->rmm_pdev));
+		else
+			rmi_vdev_abort(virt_to_phys(host_tdi->rmm_vdev));
+
+		state = error_state;
 	} else {
 		/*
 		 * Some device communication error will transition the
 		 * device to error state. Report that.
 		 */
-		if (type == PDEV_COMMUNICATE) {
-			if (rmi_pdev_get_state(virt_to_phys(pdev_dsc->rmm_pdev),
-					       (enum rmi_pdev_state *)&state))
-				state = error_state;
-		}
+		if (type == PDEV_COMMUNICATE)
+			rmi_ret = rmi_pdev_get_state(virt_to_phys(pdev_dsc->rmm_pdev),
+						     (enum rmi_pdev_state *)&state);
+		else
+			rmi_ret = rmi_vdev_get_state(virt_to_phys(host_tdi->rmm_vdev),
+						     (enum rmi_vdev_state *)&state);
+		if (rmi_ret)
+			state = error_state;
 	}
 
 	if (state == error_state)
@@ -408,6 +429,11 @@ static int wait_for_pdev_state(struct pci_tsm *tsm, enum rmi_pdev_state target_s
 	return wait_for_dev_state(PDEV_COMMUNICATE, tsm, target_state, RMI_PDEV_ERROR);
 }
 
+static int wait_for_vdev_state(struct pci_tsm *tsm, enum rmi_vdev_state target_state)
+{
+	return wait_for_dev_state(VDEV_COMMUNICATE, tsm, target_state, RMI_VDEV_ERROR);
+}
+
 static int parse_certificate_chain(struct pci_tsm *tsm)
 {
 	struct cca_host_pf0_ep_dsc *pf0_ep_dsc;
@@ -603,6 +629,49 @@ static int submit_pdev_state_transition_work(struct pci_dev *pdev,
 	return 0;
 }
 
+static void vdev_state_transition_workfn(struct work_struct *work)
+{
+	unsigned long state;
+	struct pci_tsm *tsm;
+	struct dev_comm_work *setup_work;
+	struct cca_host_pdev_dsc *pdev_dsc;
+
+	setup_work = container_of(work, struct dev_comm_work, work);
+	tsm = setup_work->tsm;
+
+	pdev_dsc = to_cca_pdev_dsc(tsm->dsm_dev);
+	guard(mutex)(&pdev_dsc->object_lock);
+
+	state = wait_for_vdev_state(tsm, setup_work->target_state);
+	WARN_ON(state != setup_work->target_state);
+}
+
+static int __maybe_unused submit_vdev_state_transition_work(struct pci_dev *pdev, int target_state)
+{
+	enum rmi_vdev_state state;
+	struct dev_comm_work comm_work;
+	struct cca_host_comm_data *comm_data = to_cca_comm_data(pdev);
+	struct cca_host_tdi *host_tdi = to_cca_host_tdi(pdev);
+
+	INIT_WORK_ONSTACK(&comm_work.work, vdev_state_transition_workfn);
+	comm_work.tsm = pdev->tsm;
+	comm_work.target_state = target_state;
+
+	queue_work(comm_data->work_queue, &comm_work.work);
+
+	flush_work(&comm_work.work);
+	destroy_work_on_stack(&comm_work.work);
+
+	/* check if we reached target state */
+	if (rmi_vdev_get_state(virt_to_phys(host_tdi->rmm_vdev), &state))
+		return -ENXIO;
+
+	if (state != target_state)
+		/* Protocol didn't take it to expected target state */
+		return -EPROTO;
+	return 0;
+}
+
 static void pdev_collect_identity_workfn(struct work_struct *work)
 {
 	struct pci_tsm *tsm;
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index 798a8ed7505f..88fa428f788e 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -116,6 +116,16 @@ struct cca_host_fn_dsc {
 
 enum dev_comm_type {
 	PDEV_COMMUNICATE = 0x1,
+	VDEV_COMMUNICATE = 0x2,
+};
+
+struct cca_host_tdi {
+	struct pci_tdi tdi;
+	struct realm *realm;
+	void *rmm_vdev;
+	/* protected by cca_host_pdev_dsc.object_lock */
+	struct cache_object *interface_report;
+	struct cache_object *measurements;
 };
 
 static inline int insert_addr_range_sorted(struct rmi_addr_range *addr_range,
@@ -203,6 +213,16 @@ static inline struct cca_host_comm_data *to_cca_comm_data(struct pci_dev *pdev)
 	return NULL;
 }
 
+static inline struct cca_host_tdi *to_cca_host_tdi(struct pci_dev *pdev)
+{
+	struct pci_tsm *tsm = pdev->tsm;
+
+	if (!tsm || !tsm->tdi)
+		return NULL;
+
+	return container_of(tsm->tdi, struct cca_host_tdi, tdi);
+}
+
 int cca_pdev_create(struct pci_dev *pdev);
 int cca_pdev_collect_identity(struct pci_dev *pdev);
 bool cca_pdev_needs_key(struct pci_dev *pdev);
-- 
2.43.0

