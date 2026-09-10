Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E88449BD93;
	Thu, 10 Sep 2026 14:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789049204; cv=none; b=dzxEgq80eDQ/m/9BOJNivAQctRZs5tt8IJMKq6LltgKUvura+x4X4fhsRtswC0UAUawUgQCASb/OzKoPobjpaS5e1pMIdVlQ96Sz58rVbkcfzIJCFOyGBIQNEFWZ0ukTaCHkogeZ94QCf07ExxFNqQknD4RAb25cLlDfNoJT0AY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789049204; c=relaxed/simple;
	bh=WTY08XsToLDsIhZRuFf85W24Ek1Sy7sZ+oJpkuL/lbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnBznplQ9i0OIvxh2joJRWsMjCWIwF74HwzNLQGJp/q8Lt6mhsAkJ4LOfx94A4bXVrmwfA2KWnOj1pBXeNlBxbqThI4FEgIFUA7L/+AlzhJgr9GkoVoIx6tPrOEv2fdeOc3M4Yhav9qVR9eYhT5jFvlhFpDH+ULBDrK5OkdJ22Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mqh0EZzx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mqh0EZzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9841F000FF;
	Thu, 10 Sep 2026 14:06:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049201;
	bh=iX8SSvkP0TRGmeqvD2oG6hiYGm+9zRzWtG9NpyIedjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mqh0EZzxseos9g49gSpPyaDSDP5fp4uJNWI8WD3DmpUAhySxNIDdub8DwxX7JS1MY
	 OFcPexKHHMz+mcZu2x29KuhaokyCG42H3Nq7ApOk0qP4BLWTHpGrnsjysSgjtqLTjp
	 OwbfD6Vn9XrH8UOrFUGbqdy1RvCWhJjjp7/GxgRvL2gWHMPSJ7rRyTjUMLf7xieWxv
	 MQfJw++DEPr/ywU9RirDxo/9CXhOMoVB3JYSSIbdCLWyKdSn9POChncwl6iFZ6Qu9e
	 4UDqBBOuFfKw6Yky6O8B58cQsOIquQw8T4RbS7c1mlQzSNrmp0Kt6T7+lnbg8doAQZ
	 pWGDwku8uJ3uw==
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
Subject: [PATCH v5 12/15] coco: host: arm64: Refcount root-port pdevs used by IDE streams
Date: Thu, 10 Sep 2026 19:35:05 +0530
Message-ID: <20260910140509.868402-13-aneesh.kumar@kernel.org>
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

Keep the root-port RMM pdev alive while endpoint IDE streams are attached
to it.

Add a kref to the root-port descriptor, take a reference when reusing an
existing root-port pdev for stream setup, and drop it when the endpoint
disconnects. Release the root-port pdev once the final reference is
dropped, tearing down the RMM object and its communication buffers at that
point.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/arm-cca-host/main.c   | 31 ++++++++++++++++++++++---
 drivers/virt/coco/arm-cca-host/rmi-da.h |  4 ++++
 2 files changed, 32 insertions(+), 3 deletions(-)

diff --git a/drivers/virt/coco/arm-cca-host/main.c b/drivers/virt/coco/arm-cca-host/main.c
index d357bad14325..b74fe1fb14fd 100644
--- a/drivers/virt/coco/arm-cca-host/main.c
+++ b/drivers/virt/coco/arm-cca-host/main.c
@@ -113,6 +113,23 @@ static inline void free_dev_communication_buffers(struct cca_host_comm_data *com
 	free_page((unsigned long)comm_data->io_params);
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
@@ -127,6 +144,7 @@ static int cca_root_port_pdev_create(struct pci_dev *rp, struct tsm_dev *tsm_dev
 	rp->tsm->dsm_dev = rp;
 	rp->tsm->pdev = rp;
 	rp->tsm->tsm_dev = tsm_dev;
+	kref_init(&rp_dsc->tsm_ref);
 	mutex_init(&rp_dsc->pdev.object_lock);
 
 	ret = init_dev_communication_buffers(rp, &rp_dsc->pdev.comm_data);
@@ -198,12 +216,15 @@ static int cca_pdev_create_ncoh_stream(struct pci_dev *pdev, unsigned long strea
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
 	params->stream_type = RMI_PDEV_STREAM_NCOH;
@@ -213,7 +234,9 @@ static int cca_pdev_create_ncoh_stream(struct pci_dev *pdev, unsigned long strea
 	params->num_addr_range = pci_dev_addr_range(pdev, params->addr_range);
 
 	ret = cca_pdev_stream_connect(pdev, rp, params, &stream_handle);
-	if (!ret)
+	if (ret)
+		cca_root_port_pdev_put(rp_dsc);
+	else
 		pf0_ep_dsc->stream_handle = stream_handle;
 
 	free_page((unsigned long)params);
@@ -339,6 +362,8 @@ static void __maybe_unused cca_tsm_disconnect(struct pci_dev *pdev)
 		ide = pf0_ep_dsc->sel_stream;
 
 	cca_pdev_disconnect_stream(pdev, rp, pf0_ep_dsc->stream_handle);
+	if (rp)
+		cca_root_port_pdev_put(to_cca_rp_dsc(rp));
 
 	cca_pdev_stop_and_destroy(pdev);
 	free_dev_communication_buffers(&pf0_ep_dsc->pdev.comm_data);
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index ed5d3a58096d..b76cb4af8436 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -12,6 +12,9 @@
 #include <linux/pci-ide.h>
 #include <linux/pci-tsm.h>
 #include <linux/sizes.h>
+#include <linux/atomic.h>
+#include <linux/kref.h>
+#include <linux/wait.h>
 
 #define MAX_CACHE_OBJ_SIZE	SZ_16M
 #define CACHE_CHUNK_SIZE	SZ_4K
@@ -104,6 +107,7 @@ struct cca_host_pf0_ep_dsc {
 struct cca_host_rp_dsc {
 	struct pci_tsm pci;
 	struct cca_host_pdev_dsc pdev;
+	struct kref tsm_ref;
 };
 
 struct cca_host_fn_dsc {
-- 
2.43.0

