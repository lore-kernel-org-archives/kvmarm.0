Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 326B52E2850;
	Mon, 27 Apr 2026 06:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777272752; cv=none; b=g5HKBZGNWh+o6xAPxUT2vvAWUJHsO0WU/CX9nd1blKm1Dsu3YU2qVXrgDoF6UCRyNq2sUXzhl1Q8cb+q2MrT28bQfcVwhPc2Br7qzl4kUCNfVNWylZuLoEcvElHnrO1TvOin6Sv877uvrXBEXBfuJ2AHlQpK3sYAWdM9wzsbLE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777272752; c=relaxed/simple;
	bh=6Sw133FYh53nGQovcs9D8dmPUc0HpnR58dh4gpbmiQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lRRUB/Cl3sydPc9m6NWJVw0L18nybmYUJBKCOnI3kg1LVCnidUgPYkMX16BkL5ATdgYECbbGyZy5SMmrcH5fT5vm0X3wZF8CmK4SKnSZqw6K41Y+733V3M5ouj86L7Pkdp9qIKNn8zfCTIg3iqF2S6g31HkNZNx+5lHruyDtEeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=noOqHOyX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="noOqHOyX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BDBC19425;
	Mon, 27 Apr 2026 06:52:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777272751;
	bh=6Sw133FYh53nGQovcs9D8dmPUc0HpnR58dh4gpbmiQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=noOqHOyXTbTN+psr4aaXatkYLw1cGUbB2hBh0g9du2NZGYAio1C1KdP/NY5MKcWKH
	 RdSLwYfrCd6PJNjBSj1gM7xYIyY41+vNLOGmblrWR6GLBSwqBwf1iKmqVgVJ/Hafr0
	 5bVgmhSMAT4Me22LcOALIMRPkxJAwGKBEw7Jh3VNSFzjv0L8+U2Otm+zeptdtqo8gP
	 udXt5++O/JNiYem/bQUo29ZorcpEl29LruigypoddqJebf1SeDF9yHrOAy91fccPDA
	 NSFKAKtt5uRp5nBusFEoffzjzEum9/nTwvJ0k/8PXZHU2VveKurIuFS86g9YSQFQN1
	 WiGTuqFwFc3qg==
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
Subject: [RFC PATCH v4 10/14] coco: host: arm64: Coordinate peer stream waits during pdev communication
Date: Mon, 27 Apr 2026 12:21:17 +0530
Message-ID: <20260427065121.916615-11-aneesh.kumar@kernel.org>
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
 arch/arm64/include/asm/rmi_smc.h        |   1 +
 drivers/virt/coco/arm-cca-host/rmi-da.c | 116 +++++++++++++++++++++++-
 drivers/virt/coco/arm-cca-host/rmi-da.h |  13 +++
 3 files changed, 125 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/rmi_smc.h b/arch/arm64/include/asm/rmi_smc.h
index 7a5d57a8be7a..e9437d56996a 100644
--- a/arch/arm64/include/asm/rmi_smc.h
+++ b/arch/arm64/include/asm/rmi_smc.h
@@ -484,6 +484,7 @@ struct rmi_pdev_params {
 #define RMI_DEV_COMM_EXIT_WAIT		BIT(3)
 #define RMI_DEV_COMM_EXIT_RSP_RESET	BIT(4)
 #define RMI_DEV_COMM_EXIT_MULTI		BIT(5)
+#define RMI_DEV_COMM_EXIT_STREAM_WAIT	BIT(6)
 
 #define RMI_DEV_COMM_NONE	0
 #define RMI_DEV_COMM_RESPONSE	1
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index cb654d1b2eb3..28f450e2db27 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -197,7 +197,7 @@ static inline gfp_t cache_obj_id_to_gfp_flags(u8 cache_obj_id)
 	return GFP_KERNEL_ACCOUNT;
 }
 
-static int _do_dev_communicate(enum dev_comm_type type, struct pci_tsm *tsm)
+static int _do_dev_communicate(enum dev_comm_type type, struct pci_tsm *tsm, int *stream_wait)
 {
 	unsigned long rmi_ret;
 	gfp_t cache_alloc_flags;
@@ -329,11 +329,17 @@ static int _do_dev_communicate(enum dev_comm_type type, struct pci_tsm *tsm)
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
@@ -342,8 +348,10 @@ static int do_dev_communicate(enum dev_comm_type type,
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
@@ -371,7 +379,7 @@ static int wait_for_dev_state(enum dev_comm_type type, struct pci_tsm *tsm,
 	int state;
 
 	do {
-		state = do_dev_communicate(type, tsm, error_state);
+		state = do_dev_communicate(type, tsm, error_state, NULL);
 
 		if (state == target_state || state == error_state)
 			return state;
@@ -593,7 +601,7 @@ static void pdev_collect_identity_workfn(struct work_struct *work)
 
 	guard(mutex)(&pdev_dsc->object_lock);
 
-	do_dev_communicate(PDEV_COMMUNICATE, tsm, RMI_PDEV_ERROR);
+	do_dev_communicate(PDEV_COMMUNICATE, tsm, RMI_PDEV_ERROR, NULL);
 
 	/*
 	 * Don't worry about communication error. The caller will look at
@@ -711,3 +719,101 @@ void cca_pdev_stop_and_destroy(struct pci_dev *pdev)
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
index 240b2993ae53..5b0f43493485 100644
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
-- 
2.43.0

