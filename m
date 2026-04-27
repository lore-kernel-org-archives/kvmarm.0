Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA6A3890F9;
	Mon, 27 Apr 2026 06:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777272757; cv=none; b=Uhap6aNs/cCxkdWZgY7rYs37SeEVJ1IrUjM1BWJbd6Eir7FHtjxBz+hFB+RYcdHvloPwcqCCI1G+TukMT2ZK5/K+2ZuM4DaZZ8Fvyg0A5pYtDbfVBcguppnmXLQm57mfTDdIpWiv/MQ9XhxQEP8Mn8KIXLnEl+dNsRq3Ccelp4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777272757; c=relaxed/simple;
	bh=sHgmPkt+ZMIm9QVi6ISjsSY+hW0JjlGh+/3Y1MgSYYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ra63NQOSEf4xPdsghXtIRNpr2VHyv63Urzt6yU6/M+lYQKUY+86zaYemIGFQ9MgHl3K9vUlm4wNbIhZPignIbTEBGgjUOoe8LNyl3PPGphR3xSuokxlQzAqqic8hU6DIWul8D2I5tuhMLB/Ysz1k/ZD1ajEHykpnBPsjYUkf/v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WFLBpYzb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WFLBpYzb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A2B8C19425;
	Mon, 27 Apr 2026 06:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777272757;
	bh=sHgmPkt+ZMIm9QVi6ISjsSY+hW0JjlGh+/3Y1MgSYYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WFLBpYzbZkmib/2ByFRj9MNGPT57k2TSMgyA679dJlvIrHzzBsxNJuUJPr1FpwHzH
	 u4ScNaIoAZ5hr3K64s5Vxm5CtdG6oAZfH6+GIk2HkvaLVOyPobMi/XbzUem4QtURw7
	 9HgjeAz91aHlTC+V5KLC6BZcrxKu5tVG8yeJXbe5AL4Cb04/qLBeuy30syfBhABPxH
	 KZRlRmK9SKky/MY75SXJNy1GeG3wjXA5GKgYIqdZyu9zYbwbuIhJLdzu/n+7pmm/+a
	 P0R8z3XWfdSIeTqfyHA/InRdkbdlOM3Dxh0SM3h/GqeRTpChSfqr9veDBD9ltqsvhZ
	 zsz2raXN9LkUg==
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
Subject: [RFC PATCH v4 11/14] coco: host: arm64: Connect RMM pdev streams for IDE devices
Date: Mon, 27 Apr 2026 12:21:18 +0530
Message-ID: <20260427065121.916615-12-aneesh.kumar@kernel.org>
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

Add the RMI definitions for pdev stream management, including the stream
parameter layout and helpers for RMI_PDEV_STREAM_CONNECT,
RMI_PDEV_STREAM_COMPLETE, and RMI_PDEV_STREAM_DISCONNECT.

Create an RMM pdev for the endpoint's root port when needed, build the
non-coherent stream parameters from the endpoint/root-port pdevs, IDE
stream ID, and bridge address windows, and issue the RMM stream connect
before enabling IDE on the endpoint.

Store the returned stream handle in the PF0 descriptor

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/asm/rmi_cmds.h        |  37 +++++++
 arch/arm64/include/asm/rmi_smc.h         |  39 +++++++
 drivers/virt/coco/arm-cca-host/arm-cca.c | 127 +++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.c  |  40 ++++++-
 drivers/virt/coco/arm-cca-host/rmi-da.h  |  57 ++++++++++
 5 files changed, 299 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index 00e0a08e17a6..c82d4d9cbc06 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -774,4 +774,41 @@ static inline unsigned long rmi_pdev_set_pubkey(unsigned long pdev_phys, unsigne
 	return res.a0;
 }
 
+
+static inline unsigned long rmi_pdev_stream_connect(unsigned long stream_params_phys,
+		unsigned long *stream_handle)
+{
+
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_STREAM_CONNECT, stream_params_phys, &res);
+
+	*stream_handle = res.a1;
+	return res.a0;
+}
+
+static inline unsigned long rmi_pdev_stream_complete(unsigned long pdev1_phys,
+		unsigned long pdev2_phys, unsigned long stream_handle)
+{
+
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_STREAM_COMPLETE, pdev1_phys,
+			     pdev2_phys, stream_handle, &res);
+
+	return res.a0;
+}
+
+static inline unsigned long rmi_pdev_stream_disconnect(unsigned long pdev1_phys,
+		unsigned long pdev2_phys, unsigned long stream_handle)
+{
+
+	struct arm_smccc_res res;
+
+	arm_smccc_1_1_invoke(SMC_RMI_PDEV_STREAM_DISCONNECT, pdev1_phys,
+			     pdev2_phys, stream_handle, &res);
+
+	return res.a0;
+}
+
 #endif /* __ASM_RMI_CMDS_H */
diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index e9437d56996a..7b16f1540a0e 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -556,4 +556,43 @@ struct rmi_public_key_params {
 	};
 };
 
+#define MAX_STREAM_ADDR_RANGE	16
+
+enum rmi_pdev_stream_type {
+	RMI_PDEV_STREAM_NON_TEE,
+	RMI_PDEV_STREAM_NCOH,
+	RMI_PDEV_STREAM_COH,
+	RMI_PDEV_STREAM_NCOH_SYS,
+	RMI_PDEV_STREAM_COH_SYS,
+	RMI_PDEV_STREAM_NCOH_P2P,
+	RMI_PDEV_STREAM_COH_CMEM,
+};
+
+struct rmi_addr_range {
+	u64 base; /* inclusive */
+	u64 top;  /* exclusive */
+};
+
+struct rmi_pdev_stream_params {
+	union {
+		struct {
+			u64 flags;
+			union {
+				u8 type;
+				u8 padding1[8];
+			};
+			u64 pdev_1;
+			u64 pdev_2;
+			u64 ide_sid;
+			u64 num_addr_range;
+		};
+		u8 padding2[0x100];
+	};
+
+	union { /* 0x100 */
+		struct rmi_addr_range addr_range[MAX_STREAM_ADDR_RANGE];
+		u8 padding3[0xF00];
+	};
+};
+
 #endif /* __ASM_RMI_SMC_H */
diff --git a/drivers/virt/coco/arm-cca-host/arm-cca.c b/drivers/virt/coco/arm-cca-host/arm-cca.c
index f0aa4e46e96c..de7a2e156549 100644
--- a/drivers/virt/coco/arm-cca-host/arm-cca.c
+++ b/drivers/virt/coco/arm-cca-host/arm-cca.c
@@ -134,6 +134,126 @@ static int alloc_stream_id(struct pci_host_bridge *hb)
 	return stream_id;
 }
 
+static int cca_root_port_pdev_create(struct pci_dev *rp, struct tsm_dev *tsm_dev)
+{
+	int ret;
+	struct cca_host_rp_dsc *rp_dsc;
+
+	/* We are under pci_tsm_rwsem. */
+	lockdep_assert_held_write(&pci_tsm_rwsem);
+
+	rp_dsc = kzalloc_obj(*rp_dsc);
+	if (!rp_dsc)
+		return -ENOMEM;
+
+	/* we expect this to be asigned early */
+	rp->tsm = &rp_dsc->pci;
+	rp->tsm->dsm_dev = rp;
+	rp->tsm->pdev = rp;
+	rp->tsm->tsm_dev = tsm_dev;
+	mutex_init(&rp_dsc->pdev.object_lock);
+
+	ret = init_dev_communication_buffers(rp, &rp_dsc->pdev.comm_data);
+	if (ret)
+		goto err_comm_buff;
+
+	ret = cca_pdev_create(rp);
+	if (ret)
+		goto err_pdev_create;
+
+	/*
+	 * device communication is still required even though
+	 * there is not identity collection
+	 */
+	ret = cca_pdev_collect_identity(rp);
+	if (ret)
+		goto pdev_destroy;
+
+	return 0;
+
+pdev_destroy:
+	cca_pdev_stop_and_destroy(rp);
+err_pdev_create:
+	free_dev_communication_buffers(&rp_dsc->pdev.comm_data);
+err_comm_buff:
+	kfree(rp_dsc);
+	rp->tsm = NULL;
+	return ret;
+}
+
+static int pci_dev_addr_range(struct pci_dev *pdev, struct rmi_addr_range *pdev_addr)
+{
+	int naddr = 0;
+	struct pci_dev *br;
+	struct resource *mem, *pref;
+
+	br = pci_upstream_bridge(pdev);
+	if (!br)
+		return 0;
+
+	mem = pci_resource_n(br, PCI_BRIDGE_MEM_WINDOW);
+	pref = pci_resource_n(br, PCI_BRIDGE_PREF_MEM_WINDOW);
+	if (resource_assigned(mem))
+		naddr = insert_addr_range_sorted(pdev_addr, naddr,
+						 mem->start, mem->end + 1);
+	if (resource_assigned(pref))
+		naddr = insert_addr_range_sorted(pdev_addr, naddr,
+						 pref->start, pref->end + 1);
+
+	return naddr;
+}
+
+static int cca_pdev_create_ncoh_stream(struct pci_dev *pdev, unsigned long stream_id)
+{
+	int ret;
+	long stream_handle;
+	struct cca_host_rp_dsc *rp_dsc;
+	struct rmi_pdev_stream_params *params;
+	struct pci_dev *rp = pcie_find_root_port(pdev);
+	struct cca_host_pf0_ep_dsc *pf0_ep_dsc = to_cca_pf0_ep_dsc(pdev);
+
+	if (!rp->tsm) {
+		ret = cca_root_port_pdev_create(rp, pf0_ep_dsc->pci.base_tsm.tsm_dev);
+		if (ret)
+			return ret;
+		rp_dsc = to_cca_rp_dsc(rp);
+	} else {
+		rp_dsc = to_cca_rp_dsc(rp);
+		/* Make sure they use the same TSM */
+		if (rp->tsm->tsm_dev != pf0_ep_dsc->pci.base_tsm.tsm_dev)
+			return -EINVAL;
+	}
+
+
+	params = (struct rmi_pdev_stream_params *)get_zeroed_page(GFP_KERNEL);
+	if (!params)
+		return -ENOMEM;
+
+	params->flags = 0;
+	params->type = RMI_PDEV_STREAM_NCOH;
+	params->pdev_1 = virt_to_phys(pf0_ep_dsc->pdev.rmm_pdev);
+	params->pdev_2 = virt_to_phys(rp_dsc->pdev.rmm_pdev);
+	params->ide_sid = stream_id;
+	params->num_addr_range = pci_dev_addr_range(pdev, params->addr_range);
+
+	ret = cca_pdev_stream_connect(pdev, rp, params, &stream_handle);
+	if (!ret)
+		pf0_ep_dsc->stream_handle = stream_handle;
+
+	free_page((unsigned long)params);
+	return ret;
+}
+
+static int cca_pdev_create_streams(struct pci_dev *pdev, unsigned long stream_id)
+{
+	switch (pci_pcie_type(pdev)) {
+	case PCI_EXP_TYPE_ENDPOINT:
+		return cca_pdev_create_ncoh_stream(pdev, stream_id);
+	default:
+		return -EINVAL;
+	}
+}
+
 static inline bool cca_pdev_need_sel_ide_streams(struct pci_dev *pdev)
 {
 	return pci_pcie_type(pdev) == PCI_EXP_TYPE_ENDPOINT;
@@ -202,6 +322,10 @@ static int cca_tsm_connect(struct pci_dev *pdev)
 		if (ret)
 			goto pdev_destroy;
 	}
+	/* Create IDE streams */
+	ret = cca_pdev_create_streams(pdev, stream_id);
+	if (ret)
+		goto pdev_destroy;
 	/*
 	 * Once ide is setup, enable the stream at the endpoint
 	 * Root port will be done by RMM
@@ -239,6 +363,7 @@ static void cca_tsm_disconnect(struct pci_dev *pdev)
 	int stream_id;
 	struct pci_ide *ide;
 	struct cca_host_pf0_ep_dsc *pf0_ep_dsc;
+	struct pci_dev *rp = pcie_find_root_port(pdev);
 
 	pf0_ep_dsc = to_cca_pf0_ep_dsc(pdev);
 	if (!pf0_ep_dsc)
@@ -249,6 +374,8 @@ static void cca_tsm_disconnect(struct pci_dev *pdev)
 		stream_id = ide->stream_id;
 	}
 
+	cca_pdev_disconnect_stream(pdev, rp, pf0_ep_dsc->stream_handle);
+
 	cca_pdev_stop_and_destroy(pdev);
 	free_dev_communication_buffers(&pf0_ep_dsc->pdev.comm_data);
 
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index 28f450e2db27..a10ac6ff03d1 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -62,6 +62,10 @@ static int init_pdev_params(struct pci_dev *pdev, struct rmi_pdev_params *params
 		category = RMI_PDEV_FLAGS_CATEGORY_OFF_CHIP_EP;
 		break;
 	}
+	case PCI_EXP_TYPE_ROOT_PORT: {
+		category = RMI_PDEV_FLAGS_CATEGORY_ROOT_PORT;
+		break;
+	}
 	default:
 		return -EINVAL;
 	}
@@ -770,7 +774,7 @@ static void stream_connect_workfn(struct work_struct *work)
 	mutex_unlock(&pdev_dsc->object_lock);
 }
 
-static int __maybe_unused submit_stream_work(struct pci_dev *pdev1, struct pci_dev *pdev2,
+static int submit_stream_work(struct pci_dev *pdev1, struct pci_dev *pdev2,
 		unsigned long stream_handle)
 {
 	phys_addr_t rmm_pdev1_phys, rmm_pdev2_phys = 0;
@@ -814,6 +818,40 @@ static int __maybe_unused submit_stream_work(struct pci_dev *pdev1, struct pci_d
 	rmm_pdev1_phys = virt_to_phys(pdev_dsc1->rmm_pdev);
 	if (pdev2)
 		rmm_pdev2_phys = virt_to_phys(pdev_dsc2->rmm_pdev);
+	/*
+	 * If we had device communication error, this will error out.
+	 */
+	if (rmi_pdev_stream_complete(rmm_pdev1_phys, rmm_pdev2_phys, stream_handle))
+		return -EIO;
 
 	return 0;
 }
+
+int cca_pdev_stream_connect(struct pci_dev *pdev1, struct pci_dev *pdev2,
+		struct rmi_pdev_stream_params *stream_params,
+		unsigned long *stream_handle)
+{
+	phys_addr_t stream_params_phys = virt_to_phys(stream_params);
+
+	if (rmi_pdev_stream_connect(stream_params_phys, stream_handle))
+		return -EIO;
+
+	return submit_stream_work(pdev1, pdev2, *stream_handle);
+}
+
+int cca_pdev_disconnect_stream(struct pci_dev *pdev1,
+		struct pci_dev *pdev2, unsigned long stream_handle)
+{
+
+	phys_addr_t rmm_pdev2_phys = 0;
+	struct cca_host_pdev_dsc *pdev_dsc1 = to_cca_pdev_dsc(pdev1);
+
+	if (pdev2)
+		rmm_pdev2_phys = virt_to_phys(to_cca_pdev_dsc(pdev2)->rmm_pdev);
+
+	if (rmi_pdev_stream_disconnect(virt_to_phys(pdev_dsc1->rmm_pdev),
+				       rmm_pdev2_phys, stream_handle))
+		return -EIO;
+
+	return submit_stream_work(pdev1, pdev2, stream_handle);
+}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index 5b0f43493485..ea5f7df3541f 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -72,6 +72,7 @@ struct cca_host_pdev_dsc {
  * @pci: Physical Function 0 TDISP link context
  * @pdev: pdev communication context
  * @sel_stream: Selective IDE Stream descriptor
+ * @stream_handle: Stream handle returned by stream connect
  * @rmi_signature_algorithm: Signature algorithm used for public key
  * @cert_chain: cetrificate chain
  * @vca: SPDM's Version-Capabilities-Algorithms cache object
@@ -80,6 +81,7 @@ struct cca_host_pf0_ep_dsc {
 	struct pci_tsm_pf0 pci;
 	struct cca_host_pdev_dsc pdev;
 	struct pci_ide *sel_stream;
+	unsigned long stream_handle;
 
 	uint8_t rmi_signature_algorithm;
 	struct {
@@ -93,6 +95,17 @@ struct cca_host_pf0_ep_dsc {
 	struct cache_object *vca;
 };
 
+/**
+ * struct cca_host_rp_dsc - Root-port pdev context for stream coordination.
+ * @pci: Root-port TSM link context
+ * @pdev: Common pdev communication context
+ * @tsm_ref: Reference count held by connected endpoint streams
+ */
+struct cca_host_rp_dsc {
+	struct pci_tsm pci;
+	struct cca_host_pdev_dsc pdev;
+};
+
 struct cca_host_fn_dsc {
 	struct pci_tsm pci;
 };
@@ -101,6 +114,30 @@ enum dev_comm_type {
 	PDEV_COMMUNICATE = 0x1,
 };
 
+static inline int insert_addr_range_sorted(struct rmi_addr_range *addr_range,
+		int nr_addr_range, resource_size_t start, resource_size_t top)
+{
+	int index = nr_addr_range;
+
+	while (index > 0) {
+		struct rmi_addr_range *prev = &addr_range[index - 1];
+
+		if (prev->base < start)
+			break;
+
+		if (prev->base == start && prev->top <= top)
+			break;
+
+		addr_range[index] = *prev;
+		index--;
+	}
+
+	addr_range[index].base = start;
+	addr_range[index].top = top;
+
+	return nr_addr_range + 1;
+}
+
 static inline struct cca_host_pf0_ep_dsc *to_cca_pf0_ep_dsc(struct pci_dev *pdev)
 {
 	struct pci_tsm *tsm = pdev->tsm;
@@ -118,14 +155,29 @@ static inline struct cca_host_fn_dsc *to_cca_fn_dsc(struct pci_dev *pdev)
 	return container_of(tsm, struct cca_host_fn_dsc, pci);
 }
 
+static inline struct cca_host_rp_dsc *to_cca_rp_dsc(struct pci_dev *pdev)
+{
+	struct pci_tsm *tsm = pdev->tsm;
+
+	if (!tsm || pci_pcie_type(pdev) != PCI_EXP_TYPE_ROOT_PORT)
+		return NULL;
+
+	return container_of(tsm, struct cca_host_rp_dsc, pci);
+}
+
 static inline struct cca_host_pdev_dsc *to_cca_pdev_dsc(struct pci_dev *pdev)
 {
 	struct cca_host_pf0_ep_dsc *pf0_ep_dsc;
+	struct cca_host_rp_dsc *rp_dsc;
 
 	pf0_ep_dsc = to_cca_pf0_ep_dsc(pdev);
 	if (pf0_ep_dsc)
 		return &pf0_ep_dsc->pdev;
 
+	rp_dsc = to_cca_rp_dsc(pdev);
+	if (rp_dsc)
+		return &rp_dsc->pdev;
+
 	return NULL;
 }
 
@@ -152,5 +204,10 @@ int cca_pdev_collect_identity(struct pci_dev *pdev);
 bool cca_pdev_needs_key(struct pci_dev *pdev);
 int cca_pdev_set_public_key(struct pci_dev *pdev);
 void cca_pdev_stop_and_destroy(struct pci_dev *pdev);
+int cca_pdev_stream_connect(struct pci_dev *pdev1, struct pci_dev *pdev2,
+		struct rmi_pdev_stream_params *stream_params,
+		unsigned long *stream_handle);
+int cca_pdev_disconnect_stream(struct pci_dev *pdev1,
+		struct pci_dev *pdev2, unsigned long stream_handle);
 
 #endif
-- 
2.43.0

