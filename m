Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 524AF37C90D;
	Mon, 27 Apr 2026 08:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280100; cv=none; b=svq3oPsG2GlW8Sibgq+J1cY0ardpSJCDZFN4587jckCV8Oj+R/qWl+SZJgJLnplQJQWf8PsrrBCl8RjXnXbzQEa14+et/rxMLU4LtE8BQOX3T42S9p2iU44P+x+y6uI61JH4AS6XnDx3bf9R87tkPBqSqaNzNNoUZuu6G7fsKCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280100; c=relaxed/simple;
	bh=FMIwcNzgQyYKvL/+VdDInu0xZqfxtBHYoAbYHmw9Y1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X53g18LgVlvL2XP4MSuY2Uqxmqa1hyrp3Xn+Z0S685S7IRMWaep99R/S6+y4qw8qBYD6KiK1guEjGzDxHPemWeT5vlo4X/lr04mIt2EKhkeposj5tfXNv6GsiihiyibCQU0zPpuxLBbUHmCKdJtm8Fbvh3LCUFsmwFDy9wZcuh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pwAEva7E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pwAEva7E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D0BC2BCB4;
	Mon, 27 Apr 2026 08:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777280099;
	bh=FMIwcNzgQyYKvL/+VdDInu0xZqfxtBHYoAbYHmw9Y1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pwAEva7Eiw8ewW8ECOCxJreq6BTnnayRalaegblh3LPzBMyCpU9hX/F8BuQ07JFJ7
	 CEwNANrORLr1mnf308c/D1nWoEdyjp25pPwhH8j8HINKwWWvZuaBwF/BjAgAHp/4mZ
	 96F2wDws84i4E2I9xaMrpPSpr+n6WYxAHtG9yufJ0k9s9o/nt7sHxgE8bKqAERUDD0
	 fryzmuOm3GRQrpDlEHHojWOo3Wj6v+xyLk2P/hkOCCN3NbUjIaknN7Eyd2mZkDMtXp
	 BRLqba+30jEu3ZpnOYdy2/svbk/siPHCgS+sVwlmG9S7cWGriWirEf49lluDpqgk7G
	 roPawwNSsmf7A==
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
Subject: [RFC PATCH v4 10/16] coco: host: arm64: Add helper for cached object fetches
Date: Mon, 27 Apr 2026 14:23:38 +0530
Message-ID: <20260427085344.941627-11-aneesh.kumar@kernel.org>
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

Introduce vdev_fetch_object_work() so we have a single workqueue handler
that refreshes any cached Realm object (interface report, measurements,
certificates). The helper receives the cache buffer/offset/size via
dev_comm_work, clears the existing contents under dsm_dev.object_lock,
performs the VDEV_COMMUNICATE call, and uses the updated size to signal
failures back to the caller once the work completes.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/arm-cca-host/rmi-da.c | 26 +++++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.h |  3 +++
 2 files changed, 29 insertions(+)

diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index 3db42c21dab0..63b20c8aef54 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -1138,6 +1138,32 @@ void cca_vdev_unlock_and_destroy(struct realm *realm,
 	host_tdi->realm = NULL;
 }
 
+static void __maybe_unused vdev_fetch_object_workfn(struct work_struct *work)
+{
+	int state;
+	struct pci_tsm *tsm;
+	struct cca_host_pdev_dsc *pdev_dsc;
+	struct dev_comm_work *setup_work;
+
+	setup_work = container_of(work, struct dev_comm_work, work);
+	tsm = setup_work->tsm;
+	pdev_dsc = to_cca_pdev_dsc(tsm->dsm_dev);
+
+	guard(mutex)(&pdev_dsc->object_lock);
+
+	if (setup_work->cache_size) {
+		memset(setup_work->cache_buf, 0, setup_work->cache_size);
+		*setup_work->cache_offset = 0;
+	}
+	state = do_dev_communicate(VDEV_COMMUNICATE, tsm, RMI_VDEV_ERROR, NULL);
+	/* return status through dev_comm_work.cache_cache */
+	if (state == RMI_VDEV_ERROR)
+		setup_work->cache_size = 0;
+	else
+		/* indicate success. This value is not used. */
+		setup_work->cache_size = CACHE_CHUNK_SIZE;
+}
+
 int cca_vdev_get_object_size(struct pci_dev *pdev, int type)
 {
 	long len;
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index 4f1a61a5dcfa..c1fc7c01943e 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -28,6 +28,9 @@ struct cache_object {
 struct dev_comm_work {
 	struct pci_tsm *tsm;
 	int target_state;
+	u8 *cache_buf;
+	int *cache_offset;
+	int cache_size;
 	struct work_struct work;
 };
 
-- 
2.43.0

