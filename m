Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF5E336EE9;
	Thu, 12 Mar 2026 08:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302903; cv=none; b=Nv8kurg31/snYeL37j6/xykADsuenfe5gPRyqtGQtCyKEh4IhyVike+gRO0cbBVUIEApc8EMjdt+hk8oGqT84IHcH9yahjf8Zt8WjqwI6yY6n3vl+bGuX5gj1snB/bpumW2a8uIMuilW5A5fKX2KPv86HPWjfmmNKE1fWf5igIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302903; c=relaxed/simple;
	bh=6oxYUlhIPNcGLPWh6+ePdyyXxOdiu08NF6PV/UFRNTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Htvg8vhGbFQERmoJu5pF6mK7wh/+Rj1HPxGr4/m1tkJV+7ykkQBlB0y5cVJExhVMucTM80P2W9zd2PnFVN4Y7xKUr/POWK3jeGWVVAAX3F1DzqAHqrEPtsj5K2VRcCpbL6xJ+1sdF9uttl/zEfiWSPPkndHvQdbq2tVtuHhYKdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gh5dIoLf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gh5dIoLf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A04BC2BCB1;
	Thu, 12 Mar 2026 08:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302903;
	bh=6oxYUlhIPNcGLPWh6+ePdyyXxOdiu08NF6PV/UFRNTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gh5dIoLfVBblTJJauVhG+hFltAlcK7CckK3o6zMjiQuvg0k1xTtJdurG0wSDPK8AZ
	 cXRNkkzwUwQAyzYYjhJM4wVd019RNZ61aTRT0FHx01RHeHp+O+4QGcw00lZrzqwYNP
	 3Dtk38koTTnYQ/2L/9W1GjGNTFS8MJIUOGxnvWII9XeokaRwSJ95voBoa/BLkL5z4w
	 +DNcJc+BVNxMkQTaDC3ydYEhYXcOrZWtzGz6eD21dTtZSwGH2sUn8lCjyKTP/tywmq
	 3b9wPXBZpcfEkThpvYzymZ3BaWVs9f/OsqImGkrn/FIZR4gAWsrb2YtKtx/hNCili8
	 k16v7IPlL3PSg==
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
Subject: [RFC PATCH v3 05/12] coco: host: arm64: Add helper for cached object fetches
Date: Thu, 12 Mar 2026 13:37:36 +0530
Message-ID: <20260312080743.3487326-6-aneesh.kumar@kernel.org>
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

Introduce vdev_fetch_object_work() so we have a single workqueue handler
that refreshes any cached Realm object (interface report, measurements,
certificates). The helper receives the cache buffer/offset/size via
dev_comm_work, clears the existing contents under dsm_dev.object_lock,
performs the VDEV_COMMUNICATE call, and uses the updated size to signal
failures back to the caller once the work completes.

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
 drivers/virt/coco/arm-cca-host/rmi-da.c | 28 +++++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.h |  3 +++
 2 files changed, 31 insertions(+)

diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index fb623e5e5b62..123cda44535c 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -839,6 +839,34 @@ void cca_vdev_unlock_and_destroy(struct realm *realm,
 	host_tdi->realm = NULL;
 }
 
+static void __maybe_unused vdev_fetch_object_workfn(struct work_struct *work)
+{
+	int state;
+	struct pci_tsm *tsm;
+	struct cca_host_pf0_dsc *pf0_dsc;
+	struct dev_comm_work *setup_work;
+
+	setup_work = container_of(work, struct dev_comm_work, work);
+	tsm = setup_work->tsm;
+	pf0_dsc = to_cca_pf0_dsc(tsm->dsm_dev);
+
+	guard(mutex)(&pf0_dsc->object_lock);
+
+	if (setup_work->cache_size) {
+		memset(setup_work->cache_buf, 0, setup_work->cache_size);
+		*setup_work->cache_offset = 0;
+	}
+	state = do_dev_communicate(VDEV_COMMUNICATE, tsm, RMI_VDEV_ERROR);
+	/* return status through dev_comm_work.cache_cache */
+	if (state == RMI_VDEV_ERROR)
+		setup_work->cache_size = 0;
+	else
+		/* indicate success. This value is not used. */
+		setup_work->cache_size = CACHE_CHUNK_SIZE;
+
+	complete(&setup_work->complete);
+}
+
 int cca_vdev_get_object_size(struct pci_dev *pdev, int type)
 {
 	long len;
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index 9cc587393d02..c4f31986389c 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -24,6 +24,9 @@ struct cache_object {
 struct dev_comm_work {
 	struct pci_tsm *tsm;
 	int target_state;
+	u8 *cache_buf;
+	int *cache_offset;
+	int cache_size;
 	struct work_struct work;
 	struct completion complete;
 };
-- 
2.43.0

