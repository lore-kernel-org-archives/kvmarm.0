Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3D044A090E;
	Thu, 10 Sep 2026 14:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789049183; cv=none; b=fArSkN0PQKD5KeCh5oHGMfvOGxpc1Df2a/Rq4FSSt/iFJapV78qQvWhIA+MyybIa+V7x0OwhbH1IxQ9YXu6f/4lKqziT9ZUlWezlFiXdXILjmT3GoZvbpJ0X5YhNkQ7y0kVJiYJHMdX0YLR6iKTmvw/8y80WDGVPmqM3wdBStRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789049183; c=relaxed/simple;
	bh=bO5ZxRUTplC78RMoKS01ZkNJgF3nE7/LqS/iuXurVS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMtc1TD72ELJguAcbuNISun8+YQ4FsIbNAFKtIpQ5XCdJUYux0YJ1EvUkMOUAISiXR34/F66JtjGaW/sc16I0MXCIdBuF08FWJ/crdEYLwgHOR4X794at1wZMR1WmrNuFVqZhXtMJ5i/8gBIXi5FOBdbeUaHJWRsAQikPnrVNU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PjzpqKPH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PjzpqKPH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5749C1F00893;
	Thu, 10 Sep 2026 14:06:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049181;
	bh=IiIVREUxf6Ua6VFPmuswL/Ps0omblFjMc6DSuW760z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PjzpqKPHFvzO05/QxbvZ2IFnK2A1E4t7tiqS/xY/7O53ICZyAOUyJTbgcy3Cx0FAt
	 bshLtmA9+9vAcS+IROJguNAgIkMnxvW977zPKWBttXpllQdR2HEPq2xxmWoDHwtPSk
	 7s917CHvror+NMFSGnb66kP1wAc7vGr0H6g+vygjqTLnoU4PcwrjZdkPz/sz22qmIm
	 cIMBZyigMnrdP0QDbiz/kecD2ODAOZO0/4sJoJAm3FTtUIMkL6m/E93b/ySITHvXcX
	 /7TgICEnvfc4fVJaN0CoGmro4TnX5HAnu2g2nLKVGhMEq8gGCwjjBucKOcjK6PBC3F
	 reKcTrjAt5GIw==
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
Subject: [PATCH v5 09/15] coco: host: arm64: Initialize RMM pdev state for TDISP IDE connect
Date: Thu, 10 Sep 2026 19:35:02 +0530
Message-ID: <20260910140509.868402-10-aneesh.kumar@kernel.org>
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

Update connect() to:
- allocate device-communication buffers,
- create the RMM pdev object,
- perform initial device communication to collect identity, and
- set the device public key when the pdev enters NEEDS_KEY.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/arm-cca-host/main.c   | 47 ++++++++++---
 drivers/virt/coco/arm-cca-host/rmi-da.c | 90 ++++++++++++++++++++++++-
 drivers/virt/coco/arm-cca-host/rmi-da.h |  3 +
 3 files changed, 130 insertions(+), 10 deletions(-)

diff --git a/drivers/virt/coco/arm-cca-host/main.c b/drivers/virt/coco/arm-cca-host/main.c
index ce16ce108db7..318967bab8ca 100644
--- a/drivers/virt/coco/arm-cca-host/main.c
+++ b/drivers/virt/coco/arm-cca-host/main.c
@@ -64,7 +64,7 @@ static void cca_tsm_pci_remove(struct pci_tsm *tsm)
 	}
 }
 
-static __maybe_unused int init_dev_communication_buffers(struct pci_dev *pdev,
+static int init_dev_communication_buffers(struct pci_dev *pdev,
 		struct cca_host_comm_data *comm_data)
 {
 	int ret = -ENOMEM;
@@ -158,15 +158,43 @@ static int __maybe_unused cca_tsm_connect(struct pci_dev *pdev)
 		ide->partner[PCI_IDE_EP].default_stream = 1;
 		pci_ide_stream_setup(pdev, ide);
 		pci_ide_stream_setup(rp, ide);
+	}
 
-		/*
-		 * Once ide is setup, enable the stream at the endpoint
-		 * Root port will be done by RMM
-		 */
-		pci_ide_stream_enable(pdev, ide);
+	ret = init_dev_communication_buffers(pdev, &pf0_ep_dsc->pdev.comm_data);
+	if (ret)
+		goto err_comm_buff;
+	ret = cca_pdev_create(pdev);
+	if (ret)
+		goto err_pdev_create;
+
+	ret = cca_pdev_collect_identity(pdev);
+	if (ret)
+		goto pdev_destroy;
+
+	if (cca_pdev_needs_key(pdev)) {
+		ret = cca_pdev_set_public_key(pdev);
+		if (ret)
+			goto pdev_destroy;
 	}
+	/*
+	 * Once ide is setup, enable the stream at the endpoint
+	 * Root port will be done by RMM
+	 */
+	if (cca_pdev_need_sel_ide_streams(pdev))
+		pci_ide_stream_enable(pdev, ide);
+
 	return 0;
 
+pdev_destroy:
+	cca_pdev_stop_and_destroy(pdev);
+err_pdev_create:
+	free_dev_communication_buffers(&pf0_ep_dsc->pdev.comm_data);
+err_comm_buff:
+	if (cca_pdev_need_sel_ide_streams(pdev)) {
+		pci_ide_stream_teardown(rp, ide);
+		pci_ide_stream_teardown(pdev, ide);
+		pci_ide_stream_unregister(ide);
+	}
 err_stream:
 	if (cca_pdev_need_sel_ide_streams(pdev))
 		pci_ide_stream_free(ide);
@@ -185,13 +213,16 @@ static void __maybe_unused cca_tsm_disconnect(struct pci_dev *pdev)
 	if (!pf0_ep_dsc)
 		return;
 
-	if (cca_pdev_need_sel_ide_streams(pdev)) {
+	if (cca_pdev_need_sel_ide_streams(pdev))
 		ide = pf0_ep_dsc->sel_stream;
 
+	cca_pdev_stop_and_destroy(pdev);
+	free_dev_communication_buffers(&pf0_ep_dsc->pdev.comm_data);
+
+	if (cca_pdev_need_sel_ide_streams(pdev)) {
 		pci_ide_stream_release(ide);
 		pf0_ep_dsc->sel_stream = NULL;
 	}
-
 }
 
 static struct pci_tsm_ops cca_link_pci_ops = {
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index 394b6a87f2d3..a046edb6be86 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -381,7 +381,7 @@ static int wait_for_pdev_state(struct pci_tsm *tsm, enum rmi_pdev_state target_s
 	return wait_for_dev_state(PDEV_COMMUNICATE, tsm, target_state, RMI_PDEV_ERROR);
 }
 
-static int __maybe_unused parse_certificate_chain(struct pci_tsm *tsm)
+static int parse_certificate_chain(struct pci_tsm *tsm)
 {
 	struct cca_host_pf0_ep_dsc *pf0_ep_dsc;
 	unsigned int chain_size;
@@ -481,7 +481,7 @@ static inline int copy_key_part(u8 *buf, const u8 *key_buf, size_t sz)
 }
 
 DEFINE_FREE(key_param_free, struct rmi_public_key_params *, if (_T) key_param_free(_T))
-static int __maybe_unused pdev_set_public_key(struct pci_tsm *tsm)
+static int pdev_set_public_key(struct pci_tsm *tsm)
 {
 	struct cca_host_pf0_ep_dsc *pf0_ep_dsc;
 
@@ -572,6 +572,92 @@ static int submit_pdev_state_transition_work(struct pci_dev *pdev,
 	return 0;
 }
 
+static void pdev_collect_identity_workfn(struct work_struct *work)
+{
+	struct pci_tsm *tsm;
+	struct dev_comm_work *setup_work;
+	struct cca_host_pdev_dsc *pdev_dsc;
+
+	setup_work = container_of(work, struct dev_comm_work, work);
+	tsm = setup_work->tsm;
+	pdev_dsc = to_cca_pdev_dsc(tsm->dsm_dev);
+
+	guard(mutex)(&pdev_dsc->object_lock);
+
+	do_dev_communicate(PDEV_COMMUNICATE, tsm, RMI_PDEV_ERROR);
+
+	/*
+	 * Don't worry about communication error. The caller will look at
+	 * device state to find more about error
+	 */
+}
+
+int cca_pdev_collect_identity(struct pci_dev *pdev)
+{
+	enum rmi_pdev_state state;
+	struct dev_comm_work comm_work;
+	struct cca_host_pdev_dsc *pdev_dsc = to_cca_pdev_dsc(pdev);
+	struct cca_host_comm_data *comm_data = to_cca_comm_data(pdev);
+
+	/*
+	 * Device identity is collected by doing a device communication
+	 * after a pdev_create
+	 */
+	INIT_WORK_ONSTACK(&comm_work.work, pdev_collect_identity_workfn);
+	comm_work.tsm = pdev->tsm;
+
+	queue_work(comm_data->work_queue, &comm_work.work);
+
+	flush_work(&comm_work.work);
+	destroy_work_on_stack(&comm_work.work);
+
+	/* check for device communication error*/
+	if (rmi_pdev_get_state(virt_to_phys(pdev_dsc->rmm_pdev), &state))
+		return -EIO;
+
+	if (state == RMI_PDEV_ERROR)
+		return -EPROTO;
+
+	return 0;
+}
+
+bool cca_pdev_needs_key(struct pci_dev *pdev)
+{
+	enum rmi_pdev_state state;
+	struct cca_host_pdev_dsc *pdev_dsc = to_cca_pdev_dsc(pdev);
+
+	/*
+	 * Consider pdev_get_state failure as need key transition
+	 * and that will result in device communication failure, which
+	 * will handle this error.
+	 */
+	if (rmi_pdev_get_state(virt_to_phys(pdev_dsc->rmm_pdev), &state))
+		return true;
+
+	if (state == RMI_PDEV_NEEDS_KEY)
+		return true;
+	return false;
+}
+
+int cca_pdev_set_public_key(struct pci_dev *pdev)
+{
+	int ret;
+
+	/*
+	 * we now have certificate chain in dsm->cert_chain. Parse that and set
+	 * the pubkey.
+	 */
+	ret = parse_certificate_chain(pdev->tsm);
+	if (ret)
+		return ret;
+
+	ret = pdev_set_public_key(pdev->tsm);
+	if (ret)
+		return ret;
+
+	return submit_pdev_state_transition_work(pdev, RMI_PDEV_READY);
+}
+
 static inline int rmi_pdev_destroy(unsigned long pdev_phys,
 		unsigned long *rmi_ret)
 {
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index 92bcd9571cb8..dc5dc4246591 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -135,6 +135,9 @@ static inline struct cca_host_comm_data *to_cca_comm_data(struct pci_dev *pdev)
 }
 
 int cca_pdev_create(struct pci_dev *pdev);
+int cca_pdev_collect_identity(struct pci_dev *pdev);
+bool cca_pdev_needs_key(struct pci_dev *pdev);
+int cca_pdev_set_public_key(struct pci_dev *pdev);
 void cca_pdev_stop_and_destroy(struct pci_dev *pdev);
 
 #endif
-- 
2.43.0

