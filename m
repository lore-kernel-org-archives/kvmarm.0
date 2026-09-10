Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E3449B1EE;
	Thu, 10 Sep 2026 14:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789049142; cv=none; b=pTUrftqLkr9UFNMsLykurLJadmT73YtAOBxMbreX8EUJmgbOL71yeqOh6wECdA/7roc0E7uAetACsG2W8zjl0Q9z9kOSEAyx4hyGKF7NAYX1wZmKu9b0QCcRJvqeeVcNP0yRIO8bYu6zp/WOeKDDoJoI7B73FE10EkkmPhEBbWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789049142; c=relaxed/simple;
	bh=7mPuM/AZRJSXKP7wuU+io+gr1+VytF+OXT2cLGSx4fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMHvEM4JW/6JuTFs5okvxeWuAtMcI6NHVsZANF4D2bU3d+ZnQXGaYs+KoFFLyZh2toa9eI4CAJleWd9PP6mLVZh2Yf4kfC/yneXc5WzDVrDu9rfjle/Nn6A5WqySUgNxHPwwEK68jEZ0weJlNFoYoHjN5mLRLCxNocK5p7VCUWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nUvZB22J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nUvZB22J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1F71F00893;
	Thu, 10 Sep 2026 14:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049139;
	bh=UHHL5Xy41RFnE2N8BFozRzMEXVLR7j90JEEQ4uUfGlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nUvZB22J+8U8Vtlshl0vdKHsFiyxB4LitKDQLFAc1j3p+LfmL5UbS6izofLwXSQ8I
	 Jn/FmJxCIppaRv/R1yiyQzNehyUn11GHf5IyTnuUhqharYaleH6mnExfwCEOyBLsyY
	 MuSM33tJx+jIzDo0/pVVfgwxZ8dS/CW3yFHwjp8ZwapWMy7VShBsVl+WtZtXhSnaz1
	 eWdT18ahpFg4JqcIKxhvGRqnkczNYQS40pDUqD8K9Ortazp7AggJvNiHfQTecMqbLG
	 Ggn28djz173LLEyp+eGmnrvTWZmJcCQk43vk757i7ijGDyIWqeHUZlXBHpGRQEI7Km
	 FM+YloDpS8Oqw==
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
Subject: [PATCH v5 03/15] coco: host: arm64: Add RMM pdev communication plumbing
Date: Thu, 10 Sep 2026 19:34:56 +0530
Message-ID: <20260910140509.868402-4-aneesh.kumar@kernel.org>
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

RMM pdev state transitions and SPDM exchanges are driven through
RMI_PDEV_COMMUNICATE after the pdev object has been created. Add the
host-side communication infrastructure needed to service those requests.

Define the RMI device communication ABI, add the PDEV_COMMUNICATE and
PDEV_ABORT SMCCC wrappers, and allocate the per-PF0 communication pages and
ordered workqueue. Add helpers that submit communication requests to RMM,
perform the requested DOE SPDM/Secure SPDM transfers, cache multi-part
device data such as VCA and certificate-chain objects, and wait for target
RMM pdev states under the pdev object lock.

This only adds the shared communication machinery. Later patches use it for
public-key registration, pdev initialization, stream setup, and the final
connect/disconnect callbacks.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/arm-cca-host/main.c   |  50 +++++
 drivers/virt/coco/arm-cca-host/rmi-da.c | 276 ++++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.h |  65 ++++++
 include/linux/arm-rmi-cmds.h            |  20 ++
 include/linux/arm-smccc-rmi.h           |  62 ++++++
 5 files changed, 473 insertions(+)

diff --git a/drivers/virt/coco/arm-cca-host/main.c b/drivers/virt/coco/arm-cca-host/main.c
index df2cc761f68b..ce16ce108db7 100644
--- a/drivers/virt/coco/arm-cca-host/main.c
+++ b/drivers/virt/coco/arm-cca-host/main.c
@@ -44,6 +44,7 @@ static struct pci_tsm *cca_tsm_pci_probe(struct tsm_dev *tsm_dev, struct pci_dev
 	ret = pci_tsm_pf0_constructor(pdev, &pf0_ep_dsc->pci, tsm_dev);
 	if (ret)
 		return NULL;
+	mutex_init(&pf0_ep_dsc->pdev.object_lock);
 
 	pci_dbg(pdev, "tsm enabled\n");
 	return &no_free_ptr(pf0_ep_dsc)->pci.base_tsm;
@@ -63,6 +64,55 @@ static void cca_tsm_pci_remove(struct pci_tsm *tsm)
 	}
 }
 
+static __maybe_unused int init_dev_communication_buffers(struct pci_dev *pdev,
+		struct cca_host_comm_data *comm_data)
+{
+	int ret = -ENOMEM;
+
+	comm_data->io_params = (struct rmi_dev_comm_data *)get_zeroed_page(GFP_KERNEL);
+	if (!comm_data->io_params)
+		goto err_out;
+
+	comm_data->rsp_buff = (void *)__get_free_page(GFP_KERNEL);
+	if (!comm_data->rsp_buff)
+		goto err_res_buff;
+
+	comm_data->req_buff = (void *)__get_free_page(GFP_KERNEL);
+	if (!comm_data->req_buff)
+		goto err_req_buff;
+
+	comm_data->work_queue = alloc_ordered_workqueue("%s %s DEV_COMM", 0,
+						dev_bus_name(&pdev->dev),
+						pci_name(pdev));
+	if (!comm_data->work_queue)
+		goto err_work_queue;
+
+	comm_data->io_params->enter.status = RMI_DEV_COMM_NONE;
+	comm_data->io_params->enter.resp_addr = virt_to_phys(comm_data->rsp_buff);
+	comm_data->io_params->enter.req_addr  = virt_to_phys(comm_data->req_buff);
+	comm_data->io_params->enter.resp_len = 0;
+
+	return 0;
+
+err_work_queue:
+	free_page((unsigned long)comm_data->req_buff);
+err_req_buff:
+	free_page((unsigned long)comm_data->rsp_buff);
+err_res_buff:
+	free_page((unsigned long)comm_data->io_params);
+err_out:
+	return ret;
+}
+
+static inline void free_dev_communication_buffers(struct cca_host_comm_data *comm_data)
+{
+	destroy_workqueue(comm_data->work_queue);
+
+	free_page((unsigned long)comm_data->req_buff);
+	free_page((unsigned long)comm_data->rsp_buff);
+	free_page((unsigned long)comm_data->io_params);
+}
+
 static inline bool cca_pdev_need_sel_ide_streams(struct pci_dev *pdev)
 {
 	return pci_pcie_type(pdev) == PCI_EXP_TYPE_ENDPOINT;
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index 863bb425e5c9..495a3bd2798f 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -6,6 +6,8 @@
 #include <linux/arm-rmi-cmds.h>
 #include <linux/pci.h>
 #include <linux/pci-ecam.h>
+#include <linux/pci-doe.h>
+#include <linux/delay.h>
 
 #include "rmi-da.h"
 
@@ -144,3 +146,277 @@ int cca_pdev_create(struct pci_dev *pci_dev)
 		free_page((unsigned long)rmm_pdev);
 	return ret;
 }
+
+static int doe_send_req_resp(struct pci_tsm *tsm)
+{
+	int data_obj_type;
+	struct cca_host_comm_data *comm_data = to_cca_comm_data(tsm->pdev);
+	struct rmi_dev_comm_exit *io_exit = &comm_data->io_params->exit;
+	u8 protocol = io_exit->protocol;
+
+	if (protocol == RMI_PROTOCOL_SPDM)
+		data_obj_type = PCI_DOE_FEATURE_CMA;
+	else if (protocol == RMI_PROTOCOL_SECURE_SPDM)
+		data_obj_type = PCI_DOE_FEATURE_SSESSION;
+	else
+		return -EINVAL;
+
+	/* delay the send */
+	if (io_exit->req_delay)
+		fsleep(io_exit->req_delay);
+
+	return pci_tsm_doe_transfer(tsm->dsm_dev, data_obj_type,
+				    comm_data->req_buff, io_exit->req_len,
+				    comm_data->rsp_buff, PAGE_SIZE);
+}
+
+static inline bool pending_dev_communicate(struct rmi_dev_comm_exit *io_exit)
+{
+	bool pending = io_exit->flags & (RMI_DEV_COMM_EXIT_CACHE_REQ |
+					 RMI_DEV_COMM_EXIT_CACHE_RSP |
+					 RMI_DEV_COMM_EXIT_SEND |
+					 RMI_DEV_COMM_EXIT_WAIT |
+					 RMI_DEV_COMM_EXIT_MULTI);
+	return pending;
+}
+
+static inline gfp_t cache_obj_id_to_gfp_flags(u8 cache_obj_id)
+{
+	/* These two cache objects are system objects. */
+	if (cache_obj_id == RMI_DEV_VCA || cache_obj_id == RMI_DEV_CERTIFICATE)
+		return GFP_KERNEL;
+	/* rest are per TDI which is associated to a VM */
+	return GFP_KERNEL_ACCOUNT;
+}
+
+static int _do_dev_communicate(enum dev_comm_type type, struct pci_tsm *tsm)
+{
+	unsigned long rmi_ret;
+	gfp_t cache_alloc_flags;
+	int nbytes, cp_len;
+	struct cache_object **cache_objp, *cache_obj;
+	struct cca_host_pdev_dsc *pdev_dsc = to_cca_pdev_dsc(tsm->dsm_dev);
+	struct cca_host_comm_data *comm_data = to_cca_comm_data(tsm->pdev);
+	struct rmi_dev_comm_enter *io_enter = &comm_data->io_params->enter;
+	struct rmi_dev_comm_exit *io_exit = &comm_data->io_params->exit;
+
+redo_communicate:
+
+	if (type == PDEV_COMMUNICATE)
+		rmi_ret = rmi_pdev_communicate(virt_to_phys(pdev_dsc->rmm_pdev),
+					       virt_to_phys(comm_data->io_params));
+	else
+		rmi_ret = RMI_ERROR_INPUT;
+	if (rmi_ret != RMI_SUCCESS) {
+		if (rmi_ret == RMI_BUSY)
+			return -EBUSY;
+		return -EIO;
+	}
+
+	if (io_exit->flags & RMI_DEV_COMM_EXIT_CACHE_REQ ||
+	    io_exit->flags & RMI_DEV_COMM_EXIT_CACHE_RSP) {
+		struct cca_host_pf0_ep_dsc *pf0_ep_dsc = to_cca_pf0_ep_dsc(tsm->dsm_dev);
+
+		if (!pf0_ep_dsc) {
+			WARN(1,
+			     "Device communication got cache request on wrong device\n");
+			return -EINVAL;
+		}
+
+		switch (io_exit->cache_object_id) {
+		case RMI_DEV_VCA:
+			cache_objp = &pf0_ep_dsc->vca;
+			break;
+		case RMI_DEV_CERTIFICATE:
+			cache_objp = &pf0_ep_dsc->cert_chain.cache;
+			break;
+		default:
+			return -EINVAL;
+		}
+		cache_obj = *cache_objp;
+		cache_alloc_flags = cache_obj_id_to_gfp_flags(io_exit->cache_object_id);
+		int cache_remaining;
+
+		if (io_exit->flags & RMI_DEV_COMM_EXIT_CACHE_REQ)
+			cp_len = io_exit->req_cache_len;
+		else
+			cp_len = io_exit->rsp_cache_len;
+
+		/* response and request len should be <= SZ_4k */
+		if (cp_len > CACHE_CHUNK_SIZE)
+			return -EINVAL;
+
+		/* new allocation */
+		if (!cache_obj) {
+			int obj_size = struct_size(cache_obj, buf,
+						   CACHE_CHUNK_SIZE);
+
+			cache_obj = kvmalloc(obj_size, cache_alloc_flags);
+			if (!cache_obj)
+				return -ENOMEM;
+
+			cache_obj->size = CACHE_CHUNK_SIZE;
+			cache_obj->offset = 0;
+			*cache_objp = cache_obj;
+		}
+
+		cache_remaining = cache_obj->size - cache_obj->offset;
+		if (cp_len > cache_remaining) {
+			struct cache_object *new_obj;
+			int new_size = struct_size(cache_obj, buf,
+						   cache_obj->size +
+						   CACHE_CHUNK_SIZE);
+
+			if (cache_obj->size + CACHE_CHUNK_SIZE > MAX_CACHE_OBJ_SIZE)
+				return -EINVAL;
+
+			new_obj = kvrealloc(cache_obj, new_size, cache_alloc_flags);
+			if (!new_obj)
+				return -ENOMEM;
+			new_obj->size = cache_obj->size + CACHE_CHUNK_SIZE;
+			*cache_objp = new_obj;
+		}
+
+		/* cache object can change above. */
+		cache_obj = *cache_objp;
+	}
+
+
+	if (io_exit->flags & RMI_DEV_COMM_EXIT_CACHE_REQ) {
+		memcpy(cache_obj->buf + cache_obj->offset,
+		       (comm_data->req_buff + io_exit->req_cache_offset), io_exit->req_cache_len);
+		cache_obj->offset += io_exit->req_cache_len;
+	}
+
+	if (io_exit->flags & RMI_DEV_COMM_EXIT_CACHE_RSP) {
+		memcpy(cache_obj->buf + cache_obj->offset,
+		       (comm_data->rsp_buff + io_exit->rsp_cache_offset), io_exit->rsp_cache_len);
+		cache_obj->offset += io_exit->rsp_cache_len;
+	}
+
+	/*
+	 * wait for last packet request from RMM.
+	 * We should not find this because our device communication is synchronous
+	 */
+	if (io_exit->flags & RMI_DEV_COMM_EXIT_WAIT)
+		return -EIO;
+
+	/* next packet to send */
+	if (io_exit->flags & RMI_DEV_COMM_EXIT_SEND) {
+		nbytes = doe_send_req_resp(tsm);
+		if (nbytes < 0) {
+			/* report error back to RMM */
+			io_enter->status = RMI_DEV_COMM_ERROR;
+		} else {
+			/* send response back to RMM */
+			io_enter->resp_len = nbytes;
+			io_enter->status = RMI_DEV_COMM_RESPONSE;
+		}
+	} else {
+		/* no data transmitted => no data received */
+		io_enter->resp_len = 0;
+		io_enter->status = RMI_DEV_COMM_NONE;
+	}
+
+	if (pending_dev_communicate(io_exit))
+		goto redo_communicate;
+
+	return 0;
+}
+
+static int do_dev_communicate(enum dev_comm_type type,
+		struct pci_tsm *tsm, unsigned long error_state)
+{
+	int ret, state = error_state;
+	struct rmi_dev_comm_enter *io_enter;
+	struct cca_host_pdev_dsc *pdev_dsc = to_cca_pdev_dsc(tsm->dsm_dev);
+
+	io_enter = &pdev_dsc->comm_data.io_params->enter;
+	io_enter->resp_len = 0;
+	io_enter->status = RMI_DEV_COMM_NONE;
+
+	ret = _do_dev_communicate(type, tsm);
+	if (ret) {
+		if (type == PDEV_COMMUNICATE)
+			rmi_pdev_abort(virt_to_phys(pdev_dsc->rmm_pdev));
+	} else {
+		/*
+		 * Some device communication error will transition the
+		 * device to error state. Report that.
+		 */
+		if (type == PDEV_COMMUNICATE) {
+			if (rmi_pdev_get_state(virt_to_phys(pdev_dsc->rmm_pdev),
+					       (enum rmi_pdev_state *)&state))
+				state = error_state;
+		}
+	}
+
+	if (state == error_state)
+		pci_err(tsm->pdev, "device communication error\n");
+
+	return state;
+}
+
+static int wait_for_dev_state(enum dev_comm_type type, struct pci_tsm *tsm,
+		unsigned long target_state, unsigned long error_state)
+{
+	int state;
+
+	do {
+		state = do_dev_communicate(type, tsm, error_state);
+
+		if (state == target_state || state == error_state)
+			return state;
+	} while (1);
+
+	/* can't reach */
+	return error_state;
+}
+
+static int wait_for_pdev_state(struct pci_tsm *tsm, enum rmi_pdev_state target_state)
+{
+	return wait_for_dev_state(PDEV_COMMUNICATE, tsm, target_state, RMI_PDEV_ERROR);
+}
+
+static void pdev_state_transition_workfn(struct work_struct *work)
+{
+	unsigned long state;
+	struct pci_tsm *tsm;
+	struct dev_comm_work *setup_work;
+	struct cca_host_pdev_dsc *pdev_dsc;
+
+	setup_work = container_of(work, struct dev_comm_work, work);
+	tsm = setup_work->tsm;
+	pdev_dsc = to_cca_pdev_dsc(tsm->dsm_dev);
+
+	guard(mutex)(&pdev_dsc->object_lock);
+	state = wait_for_pdev_state(tsm, setup_work->target_state);
+	WARN_ON(state != setup_work->target_state);
+}
+
+static int __maybe_unused submit_pdev_state_transition_work(struct pci_dev *pdev,
+		enum rmi_pdev_state target_state)
+{
+	enum rmi_pdev_state state;
+	struct dev_comm_work comm_work;
+	struct cca_host_pdev_dsc *pdev_dsc = to_cca_pdev_dsc(pdev);
+	struct cca_host_comm_data *comm_data = to_cca_comm_data(pdev);
+
+	INIT_WORK_ONSTACK(&comm_work.work, pdev_state_transition_workfn);
+	comm_work.tsm = pdev->tsm;
+	comm_work.target_state = target_state;
+
+	queue_work(comm_data->work_queue, &comm_work.work);
+
+	flush_work(&comm_work.work);
+	destroy_work_on_stack(&comm_work.work);
+
+	/* check if we reached target state */
+	if (rmi_pdev_get_state(virt_to_phys(pdev_dsc->rmm_pdev), &state))
+		return -EIO;
+
+	if (state != target_state)
+		/* no specific error for this */
+		return -1;
+	return 0;
+}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index f1580308777b..07034b034b53 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -11,13 +11,44 @@
 #include <linux/pci.h>
 #include <linux/pci-ide.h>
 #include <linux/pci-tsm.h>
+#include <linux/sizes.h>
+
+#define MAX_CACHE_OBJ_SIZE	SZ_16M
+#define CACHE_CHUNK_SIZE	SZ_4K
+struct cache_object {
+	int size;
+	int offset;
+	u8 buf[] __counted_by(size);
+};
+
+struct dev_comm_work {
+	struct pci_tsm *tsm;
+	int target_state;
+	struct work_struct work;
+};
+
+struct cca_host_comm_data {
+	void *rsp_buff;
+	void *req_buff;
+	struct rmi_dev_comm_data *io_params;
+	/*
+	 * Only one device communication request can be active at
+	 * a time. This limitation comes from using the DOE mailbox
+	 * at the pdev level. Requests such as get_measurements may
+	 * span multiple mailbox messages, which must not be
+	 * interleaved with other SPDM requests.
+	 */
+	struct workqueue_struct *work_queue;
+};
 
 /**
  * struct cca_host_pdev_dsc - Common RMM pdev context
+ * @comm_data: Shared device communication state for the DSM-owned pdev
  * @rmm_pdev: Delegated page backing the RMM pdev object
  * @object_lock: Serializes access to the RMM pdev object and PF0/TDI caches
  */
 struct cca_host_pdev_dsc {
+	struct cca_host_comm_data comm_data;
 	void *rmm_pdev;
 	/* lock kept here to simplify the generic lock/unlock paths. */
 	struct mutex object_lock;
@@ -28,17 +59,33 @@ struct cca_host_pdev_dsc {
  * @pci: Physical Function 0 TDISP link context
  * @pdev: pdev communication context
  * @sel_stream: Selective IDE Stream descriptor
+ * @cert_chain: cetrificate chain
+ * @vca: SPDM's Version-Capabilities-Algorithms cache object
  */
 struct cca_host_pf0_ep_dsc {
 	struct pci_tsm_pf0 pci;
 	struct cca_host_pdev_dsc pdev;
 	struct pci_ide *sel_stream;
+
+	struct {
+		struct cache_object *cache;
+
+		void *public_key;
+		size_t public_key_size;
+
+		bool valid;
+	} cert_chain;
+	struct cache_object *vca;
 };
 
 struct cca_host_fn_dsc {
 	struct pci_tsm pci;
 };
 
+enum dev_comm_type {
+	PDEV_COMMUNICATE = 0x1,
+};
+
 static inline struct cca_host_pf0_ep_dsc *to_cca_pf0_ep_dsc(struct pci_dev *pdev)
 {
 	struct pci_tsm *tsm = pdev->tsm;
@@ -67,6 +114,24 @@ static inline struct cca_host_pdev_dsc *to_cca_pdev_dsc(struct pci_dev *pdev)
 	return NULL;
 }
 
+static inline struct cca_host_comm_data *to_cca_comm_data(struct pci_dev *pdev)
+{
+	struct cca_host_pdev_dsc *pdev_dsc;
+
+	pdev_dsc = to_cca_pdev_dsc(pdev);
+	if (pdev_dsc)
+		return &pdev_dsc->comm_data;
+
+	if (!pdev->tsm || !pdev->tsm->dsm_dev)
+		return NULL;
+
+	pdev_dsc = to_cca_pdev_dsc(pdev->tsm->dsm_dev);
+	if (pdev_dsc)
+		return &pdev_dsc->comm_data;
+
+	return NULL;
+}
+
 int cca_pdev_create(struct pci_dev *pdev);
 
 #endif
diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
index 850ac8e230e2..c2fc80dd19cc 100644
--- a/include/linux/arm-rmi-cmds.h
+++ b/include/linux/arm-rmi-cmds.h
@@ -686,4 +686,24 @@ static inline unsigned long rmi_pdev_get_state(unsigned long pdev_phys, enum rmi
 	return res.a0;
 }
 
+static inline unsigned long rmi_pdev_communicate(unsigned long pdev_phys,
+						 unsigned long pdev_comm_data_phys)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_COMMUNICATE,
+			     pdev_phys, pdev_comm_data_phys, &res);
+
+	return res.a0;
+}
+
+static inline unsigned long rmi_pdev_abort(unsigned long pdev_phys)
+{
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_ABORT, pdev_phys, &res);
+
+	return res.a0;
+}
+
 #endif
diff --git a/include/linux/arm-smccc-rmi.h b/include/linux/arm-smccc-rmi.h
index 7241da55c753..3133b34354ce 100644
--- a/include/linux/arm-smccc-rmi.h
+++ b/include/linux/arm-smccc-rmi.h
@@ -534,4 +534,66 @@ struct rmi_pdev_params {
 	};
 };
 
+#define RMI_DEV_COMM_EXIT_CACHE_REQ	BIT(0)
+#define RMI_DEV_COMM_EXIT_CACHE_RSP	BIT(1)
+#define RMI_DEV_COMM_EXIT_SEND		BIT(2)
+#define RMI_DEV_COMM_EXIT_WAIT		BIT(3)
+#define RMI_DEV_COMM_EXIT_RSP_RESET	BIT(4)
+#define RMI_DEV_COMM_EXIT_MULTI		BIT(5)
+
+#define RMI_DEV_COMM_NONE	0
+#define RMI_DEV_COMM_RESPONSE	1
+#define RMI_DEV_COMM_ERROR	2
+
+#define RMI_PROTOCOL_SPDM		0
+#define RMI_PROTOCOL_SECURE_SPDM	1
+
+#define RMI_DEV_VCA			0
+#define RMI_DEV_CERTIFICATE		1
+#define RMI_DEV_MEASUREMENTS		2
+#define RMI_DEV_INTERFACE_REPORT	3
+
+struct rmi_dev_comm_enter {
+	union {
+		u8 status;
+		u64 padding0;
+	};
+	u64 req_addr;
+	u64 resp_addr;
+	u64 resp_len;
+	u8 padding1[0xe0];
+};
+
+struct rmi_dev_comm_exit {
+	u64 flags;
+	u64 req_cache_offset;
+	u64 req_cache_len;
+	u64 rsp_cache_offset;
+	u64 rsp_cache_len;
+	union {
+		u8 cache_object_id;
+		u8 padding0[0x8];
+	};
+
+	union {
+		u8 protocol;
+		u8 padding1[0x8];
+	};
+	u64 req_delay;
+	u64 req_len;
+	u64 rsp_timeout;
+	u8 padding2[0xb0];
+};
+
+struct rmi_dev_comm_data {
+	union { /* 0x0 */
+		struct rmi_dev_comm_enter enter;
+		u8 padding0[0x800];
+	};
+	union { /* 0x800 */
+		struct rmi_dev_comm_exit exit;
+		u8 padding1[0x800];
+	};
+};
+
 #endif /* __LINUX_ARM_SMCCC_RMI_H_ */
-- 
2.43.0

