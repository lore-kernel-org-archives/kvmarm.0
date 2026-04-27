Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E8FB3264FA;
	Mon, 27 Apr 2026 06:52:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777272762; cv=none; b=u2FYawRbaSW3myvvgTGanCEkCLPmwIN/RiF3FCeOsGNsR7LhhF+0jNqWunu0Py9ulmT+64XlTpqJXErA6Hi2BvM5ttxz8kfhHQ0tM4bm83bFBVVakAg7sU9WcIQxf8uUet8TB3wBl1ny06hMF/650mHndO0PIuKnRbkHoa5Hbhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777272762; c=relaxed/simple;
	bh=Lgmbk9xMIpHvR05nzEfVzoIynoOoPTPEvkqEGSPDfJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJmkRIyw6uhqvXY7nkEqUyfu5InSjsFQy8vcdhcNO0ORfc25sUAQqShSr6OV2EipxqSxgtSXu7Twi/gyy1v1eqHYAV3E6oL9dCHMuioJ9Z5vaway8MTb35CUZwhvFUrkUOiX8af/0KaqaoQId2Tr2dwtgX0zc/h5ehFpKhQ8xgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BJHUouHR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BJHUouHR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A31C19425;
	Mon, 27 Apr 2026 06:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777272762;
	bh=Lgmbk9xMIpHvR05nzEfVzoIynoOoPTPEvkqEGSPDfJo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BJHUouHRSkmYTywbg9zws+4kV6xqUuhelqXjP+HvFWKQTtaWZB3KY4x2DO0M8T3ch
	 EBhGzDyiKKYgXnZLScnZ8eXFbi0WIkFZMcMOF4H6F7A4Cm54wExxYkdJEwiVa0ZjZ3
	 PgKpu/nB3UTf2R5wTmqrvp0JUjbfj4hFzkbku5ABJTI4MlspkV98vV7jCDW2qThHeE
	 yK7qBfI2NNwO+uhtU8kYkhHm62poGTRsLzD7c4N/ZOYqhzs8mltEvj/mN1dS10wKi0
	 RI3N9JilK7PoxhGdA+AxzFFdMHMhg67xZw05lCdCfDF9WQDflK+tY45dJtz6ZnbNKB
	 kd4vd263wK6Bw==
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
Subject: [RFC PATCH v4 12/14] coco: host: arm64: Refcount root-port pdevs used by IDE streams
Date: Mon, 27 Apr 2026 12:21:19 +0530
Message-ID: <20260427065121.916615-13-aneesh.kumar@kernel.org>
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

Keep the root-port RMM pdev alive while endpoint IDE streams are attached
to it.

Add a kref to the root-port descriptor, take a reference when reusing an
existing root-port pdev for stream setup, and drop it when the endpoint
disconnects. Release the root-port pdev once the final reference is
dropped, tearing down the RMM object and its communication buffers at that
point.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/arm-cca-host/arm-cca.c | 31 +++++++++++++++++++++---
 drivers/virt/coco/arm-cca-host/rmi-da.h  |  4 +++
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/virt/coco/arm-cca-host/arm-cca.c b/drivers/virt/coco/arm-cca-host/arm-cca.c
index de7a2e156549..0b1200f591ab 100644
--- a/drivers/virt/coco/arm-cca-host/arm-cca.c
+++ b/drivers/virt/coco/arm-cca-host/arm-cca.c
@@ -134,6 +134,23 @@ static int alloc_stream_id(struct pci_host_bridge *hb)
 	return stream_id;
 }
 
+static void cca_root_port_pdev_release(struct kref *kref)
+{
+	struct cca_host_rp_dsc *rp_dsc = container_of(kref, struct cca_host_rp_dsc,
+						      tsm_ref);
+	struct pci_dev *rp = rp_dsc->pci.pdev;
+
+	cca_pdev_stop_and_destroy(rp);
+	free_dev_communication_buffers(&rp_dsc->pdev.comm_data);
+	rp->tsm = NULL;
+	kfree(rp_dsc);
+}
+
+static inline void cca_root_port_pdev_put(struct cca_host_rp_dsc *rp_dsc)
+{
+	kref_put(&rp_dsc->tsm_ref, cca_root_port_pdev_release);
+}
+
 static int cca_root_port_pdev_create(struct pci_dev *rp, struct tsm_dev *tsm_dev)
 {
 	int ret;
@@ -151,6 +168,7 @@ static int cca_root_port_pdev_create(struct pci_dev *rp, struct tsm_dev *tsm_dev
 	rp->tsm->dsm_dev = rp;
 	rp->tsm->pdev = rp;
 	rp->tsm->tsm_dev = tsm_dev;
+	kref_init(&rp_dsc->tsm_ref);
 	mutex_init(&rp_dsc->pdev.object_lock);
 
 	ret = init_dev_communication_buffers(rp, &rp_dsc->pdev.comm_data);
@@ -222,12 +240,15 @@ static int cca_pdev_create_ncoh_stream(struct pci_dev *pdev, unsigned long strea
 		/* Make sure they use the same TSM */
 		if (rp->tsm->tsm_dev != pf0_ep_dsc->pci.base_tsm.tsm_dev)
 			return -EINVAL;
-	}
 
+		kref_get(&rp_dsc->tsm_ref);
+	}
 
 	params = (struct rmi_pdev_stream_params *)get_zeroed_page(GFP_KERNEL);
-	if (!params)
+	if (!params) {
+		cca_root_port_pdev_put(rp_dsc);
 		return -ENOMEM;
+	}
 
 	params->flags = 0;
 	params->type = RMI_PDEV_STREAM_NCOH;
@@ -237,7 +258,9 @@ static int cca_pdev_create_ncoh_stream(struct pci_dev *pdev, unsigned long strea
 	params->num_addr_range = pci_dev_addr_range(pdev, params->addr_range);
 
 	ret = cca_pdev_stream_connect(pdev, rp, params, &stream_handle);
-	if (!ret)
+	if (ret)
+		cca_root_port_pdev_put(rp_dsc);
+	else
 		pf0_ep_dsc->stream_handle = stream_handle;
 
 	free_page((unsigned long)params);
@@ -375,6 +398,8 @@ static void cca_tsm_disconnect(struct pci_dev *pdev)
 	}
 
 	cca_pdev_disconnect_stream(pdev, rp, pf0_ep_dsc->stream_handle);
+	if (rp)
+		cca_root_port_pdev_put(to_cca_rp_dsc(rp));
 
 	cca_pdev_stop_and_destroy(pdev);
 	free_dev_communication_buffers(&pf0_ep_dsc->pdev.comm_data);
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index ea5f7df3541f..798a8ed7505f 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -10,6 +10,9 @@
 #include <linux/pci-ide.h>
 #include <linux/pci-tsm.h>
 #include <linux/sizes.h>
+#include <linux/atomic.h>
+#include <linux/kref.h>
+#include <linux/wait.h>
 #include <asm/rmi_cmds.h>
 #include <asm/rmi_smc.h>
 
@@ -104,6 +107,7 @@ struct cca_host_pf0_ep_dsc {
 struct cca_host_rp_dsc {
 	struct pci_tsm pci;
 	struct cca_host_pdev_dsc pdev;
+	struct kref tsm_ref;
 };
 
 struct cca_host_fn_dsc {
-- 
2.43.0

