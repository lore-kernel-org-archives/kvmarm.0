Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6044A091E;
	Thu, 10 Sep 2026 14:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789049190; cv=none; b=S0NmhfqLmUEPlkoRVRcB7zp6+6osPFEfREvzrAzJtzMOsyZPjMcfScI9o9U6kXlXn6H+gKpTP6foWbhElPG82qR7pyByyaRK/o/Qb6W/gkW8oYcJq7isbxGyuJdqNtFdrUbO9wo6Grwhia9lGrZ7NGanIqjU6QgT5Zl3lZX42t8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789049190; c=relaxed/simple;
	bh=taXXnEltMXc9aNtgN/w1xijUJ7aoLs7yN+b1YTkYWG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CV2oi0fVjj4iChCyxT9XLNFh5Q9zC786mv11rVlN1JRfEkQkP73pfofqijntT6Qx4iM5RwLaRIZ0Rahoe+5VEQsb4oI0wVm5FQhYx+Z8x+F1tAgMQGrdFhJYiky/84iGczwRjEu6PupaVnkcPGB5oTrsKu4OVf4stCae4dFKgCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A1dpld/G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A1dpld/G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9152B1F0089A;
	Thu, 10 Sep 2026 14:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049188;
	bh=6ePdmdhx3YlI4NyqTdkO5yb3MhPJf9n4y0d3TQqzJF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A1dpld/GBSZOH1TNTJr5kYxNV+DfGgq1JfY0b/u8mLoNLtS4flgJVU6Bvtk1QtMyI
	 GTSEHrqDBT45BuF3S54rAEWELGzutsIt1kpflUDwBOvnaf4rX9p3NwEggafQ4+ezvS
	 e3V7OLrG3VI5Hw1yrLCLhIOl82bnkKp4RYn20NrC9oZ8wzMWWGHyKWqBVAmyMu+rvF
	 UQfxnw2jDlwIV8U8JW+ut2xnyWRCtJXLDeCdt3GLfdCvDmYkYqwVESouicyLZ1VaOI
	 VTqmvoWMcyhecCDktcegZAe2s6cmiWthxXuzjKrth76WvntMnCQLRg8PFsrO5oaVMI
	 b3jOGouQAbnlg==
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
Subject: [PATCH v5 10/15] coco: host: arm64: Coordinate peer stream waits during pdev communication
Date: Thu, 10 Sep 2026 19:35:03 +0530
Message-ID: <20260910140509.868402-11-aneesh.kumar@kernel.org>
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

RMM stream operations can return RMI_DEV_COMM_EXIT_STREAM_WAIT while
one side waits for the peer stream to reach the matching point in the
protocol.

Teach arm-cca host device communication to detect STREAM_WAIT and add
a helper that runs pdev communication for both sides in parallel until
each side has made enough progress, then issue rmi_pdev_stream_complete().

This provides the synchronization needed for stream connect,
disconnect, key refresh, and key purge operations.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/arm-cca-host/rmi-da.c | 116 +++++++++++++++++++++++-
 drivers/virt/coco/arm-cca-host/rmi-da.h |  13 +++
 include/linux/arm-smccc-rmi.h           |   1 +
 3 files changed, 125 insertions(+), 5 deletions(-)

diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index a046edb6be86..784572116064 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -192,7 +192,7 @@ static inline gfp_t cache_obj_id_to_gfp_flags(u8 cache_obj_id)
 	return GFP_KERNEL_ACCOUNT;
 }
 
-static int _do_dev_communicate(enum dev_comm_type type, struct pci_tsm *tsm)
+static int _do_dev_communicate(enum dev_comm_type type, struct pci_tsm *tsm, int *stream_wait)
 {
 	unsigned long rmi_ret;
 	gfp_t cache_alloc_flags;
@@ -324,11 +324,17 @@ static int _do_dev_communicate(enum dev_comm_type type, struct pci_tsm *tsm)
 	if (pending_dev_communicate(io_exit))
 		goto redo_communicate;
 
+	if (io_exit->flags & RMI_DEV_COMM_EXIT_STREAM_WAIT) {
+		if (stream_wait)
+			*stream_wait = 1;
+		else
+			WARN(1, "Unexpected Stream wait status\n");
+	}
 	return 0;
 }
 
 static int do_dev_communicate(enum dev_comm_type type,
-		struct pci_tsm *tsm, unsigned long error_state)
+		struct pci_tsm *tsm, unsigned long error_state, int *stream_wait)
 {
 	int ret, state = error_state;
 	struct rmi_dev_comm_enter *io_enter;
@@ -337,8 +343,10 @@ static int do_dev_communicate(enum dev_comm_type type,
 	io_enter = &pdev_dsc->comm_data.io_params->enter;
 	io_enter->resp_len = 0;
 	io_enter->status = RMI_DEV_COMM_NONE;
+	if (stream_wait)
+		*stream_wait = 0;
 
-	ret = _do_dev_communicate(type, tsm);
+	ret = _do_dev_communicate(type, tsm, stream_wait);
 	if (ret) {
 		if (type == PDEV_COMMUNICATE)
 			rmi_pdev_abort(virt_to_phys(pdev_dsc->rmm_pdev));
@@ -366,7 +374,7 @@ static int wait_for_dev_state(enum dev_comm_type type, struct pci_tsm *tsm,
 	int state;
 
 	do {
-		state = do_dev_communicate(type, tsm, error_state);
+		state = do_dev_communicate(type, tsm, error_state, NULL);
 
 		if (state == target_state || state == error_state)
 			return state;
@@ -584,7 +592,7 @@ static void pdev_collect_identity_workfn(struct work_struct *work)
 
 	guard(mutex)(&pdev_dsc->object_lock);
 
-	do_dev_communicate(PDEV_COMMUNICATE, tsm, RMI_PDEV_ERROR);
+	do_dev_communicate(PDEV_COMMUNICATE, tsm, RMI_PDEV_ERROR, NULL);
 
 	/*
 	 * Don't worry about communication error. The caller will look at
@@ -703,3 +711,101 @@ void cca_pdev_stop_and_destroy(struct pci_dev *pdev)
 		free_page((unsigned long)pdev_dsc->rmm_pdev);
 	pdev_dsc->rmm_pdev = NULL;
 }
+
+static void stream_connect_workfn(struct work_struct *work)
+{
+	int state;
+	int peer_wait = 0;
+	struct pci_tsm *tsm;
+	int my_index, peer_index, target;
+	struct stream_connect_work *stream_work;
+	struct cca_host_pdev_dsc *pdev_dsc;
+
+	stream_work = container_of(work, struct stream_connect_work, work);
+	tsm = stream_work->tsm;
+	pdev_dsc = to_cca_pdev_dsc(tsm->dsm_dev);
+
+	my_index = stream_work->my_index;
+	peer_index = my_index ^ 0x1;
+
+redo_communicate:
+	mutex_lock(&pdev_dsc->object_lock);
+
+	state = do_dev_communicate(PDEV_COMMUNICATE, tsm, RMI_PDEV_ERROR, &peer_wait);
+	if (state != RMI_PDEV_ERROR && peer_wait) {
+
+		if (!stream_work->has_peer) {
+			WARN(1, "Unexpected STREAM_WAIT without peer stream\n");
+			mutex_unlock(&pdev_dsc->object_lock);
+			return;
+		}
+		/*
+		 * Record a fresh target val for this side, then wait until
+		 * peer reaches at least the same target.
+		 */
+		target = atomic_inc_return(&stream_work->sync->val[my_index]);
+
+		wake_up_all(&stream_work->sync->wq);
+
+		mutex_unlock(&pdev_dsc->object_lock);
+
+		/* Wait for peer to make matching progress */
+		wait_event(stream_work->sync->wq,
+			   atomic_read(&stream_work->sync->val[peer_index]) >= target);
+		goto redo_communicate;
+	}
+
+	/* Signal peer if it is waiting on me */
+	atomic_inc_return(&stream_work->sync->val[my_index]);
+	wake_up_all(&stream_work->sync->wq);
+
+	mutex_unlock(&pdev_dsc->object_lock);
+}
+
+static int __maybe_unused submit_stream_work(struct pci_dev *pdev1, struct pci_dev *pdev2,
+		unsigned long stream_handle)
+{
+	phys_addr_t rmm_pdev1_phys, rmm_pdev2_phys = 0;
+	struct cca_host_comm_data *comm_data_pdev1, *comm_data_pdev2;
+	struct cca_host_pdev_dsc *pdev_dsc1, *pdev_dsc2 = NULL;
+	struct stream_sync sync;
+	struct stream_connect_work stream_work_pdev1, stream_work_pdev2;
+
+	comm_data_pdev1 = to_cca_comm_data(pdev1);
+	init_waitqueue_head(&sync.wq);
+	atomic_set(&sync.val[0], 0);
+	atomic_set(&sync.val[1], 0);
+
+	pdev_dsc1 = to_cca_pdev_dsc(pdev1);
+	INIT_WORK_ONSTACK(&stream_work_pdev1.work, stream_connect_workfn);
+	stream_work_pdev1.tsm = pdev1->tsm;
+	stream_work_pdev1.sync = &sync;
+	stream_work_pdev1.my_index = 0;
+	stream_work_pdev1.has_peer = !!pdev2;
+	queue_work(comm_data_pdev1->work_queue, &stream_work_pdev1.work);
+
+	if (pdev2) {
+		comm_data_pdev2 = to_cca_comm_data(pdev2);
+		pdev_dsc2 = to_cca_pdev_dsc(pdev2);
+		INIT_WORK_ONSTACK(&stream_work_pdev2.work, stream_connect_workfn);
+		stream_work_pdev2.tsm = pdev2->tsm;
+		stream_work_pdev2.sync = &sync;
+		stream_work_pdev2.my_index = 1;
+		stream_work_pdev2.has_peer = true;
+		queue_work(comm_data_pdev2->work_queue, &stream_work_pdev2.work);
+	}
+
+	flush_work(&stream_work_pdev1.work);
+	if (pdev2) {
+		flush_work(&stream_work_pdev2.work);
+		destroy_work_on_stack(&stream_work_pdev2.work);
+	}
+
+	destroy_work_on_stack(&stream_work_pdev1.work);
+
+	rmm_pdev1_phys = virt_to_phys(pdev_dsc1->rmm_pdev);
+	if (pdev2)
+		rmm_pdev2_phys = virt_to_phys(pdev_dsc2->rmm_pdev);
+
+	return 0;
+}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index dc5dc4246591..7b8fe0de7b90 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -27,6 +27,19 @@ struct dev_comm_work {
 	struct work_struct work;
 };
 
+struct stream_sync {
+	wait_queue_head_t wq;
+	atomic_t val[2];
+};
+
+struct stream_connect_work {
+	struct pci_tsm *tsm;
+	struct work_struct work;
+	struct stream_sync *sync;
+	u8 my_index;
+	bool has_peer;
+};
+
 struct cca_host_comm_data {
 	void *rsp_buff;
 	void *req_buff;
diff --git a/include/linux/arm-smccc-rmi.h b/include/linux/arm-smccc-rmi.h
index fdc830379060..1640f2f43344 100644
--- a/include/linux/arm-smccc-rmi.h
+++ b/include/linux/arm-smccc-rmi.h
@@ -540,6 +540,7 @@ struct rmi_pdev_params {
 #define RMI_DEV_COMM_EXIT_WAIT		BIT(3)
 #define RMI_DEV_COMM_EXIT_RSP_RESET	BIT(4)
 #define RMI_DEV_COMM_EXIT_MULTI		BIT(5)
+#define RMI_DEV_COMM_EXIT_STREAM_WAIT	BIT(6)
 
 #define RMI_DEV_COMM_NONE	0
 #define RMI_DEV_COMM_RESPONSE	1
-- 
2.43.0

