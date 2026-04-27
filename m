Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FBC39C649;
	Mon, 27 Apr 2026 08:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777278541; cv=none; b=owK9JBiREu9j4W58qDaicXzANi8YUZjQzYa/bXZ9TI2kS5nZBmKS5Vv82wBn6dfy5csACVUCCQuRjC81+Lb7Gm2gABZTkWAEVYM14JihhbnVtPM6CEyvi1t21O8EJFQdPPRb+rx0JD4zptSz8Z3Q2qnsMR3EuxaZka+DhMVyHOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777278541; c=relaxed/simple;
	bh=UqzR/91cMXtsVPaYNh22dFqFyvgw+gFdrAZVLiKKdbU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I80duCtvyYyeGBc5hMHC7+hV+aRLEY5GlBElnyK8AZ5a3eZgYACq5Ec4QIN6uzaR6pXzTWYNKkkjSs1z4GNIPEHZKv2l1xfMlK+hYz8kr1iIOqQIV+2s2KlKkAUPK0/xZSXBq7mYyysPY6+MuSx/6QcHPZ93E6ymm57tkvKa1Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hzORlFTC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hzORlFTC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4912C19425;
	Mon, 27 Apr 2026 08:28:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777278541;
	bh=UqzR/91cMXtsVPaYNh22dFqFyvgw+gFdrAZVLiKKdbU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hzORlFTCg8Ml22jww/RSI0Grz/L/0in7g/0z11wdgbHJzhdgnrwARXHQF2dsUQSTV
	 RVK7uAUABqaOR+XERlmU+MLbp7O1i9/neHOEBIZqVeIr1Yl0u7fmQVfIB5EorSsgK0
	 0v5SM0081Nv9QqFIJpZuSlfJzOIODkg8n6dTu1AUvoRcrDLQUtL7P7JTQdG5DIMFUy
	 cmi1/aVEsCSbXVAHcJYnSn4HEAp27kviuoGk6XvJdQCfi9qqDpWCEbuxygAgSNZ4pJ
	 p5q+3MNuoRtFmuNcUcU3Lkq3Zf8biREzVU9KL0O2oxUwwwPbJnKhWM7ztpODvU9oxS
	 A4NxXu74akg1A==
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
	Xu Yilun <yilun.xu@linux.intel.com>,
	Jonathan Cameron <jonathan.cameron@huawei.com>
Subject: [RFC PATCH v4 09/11] coco: guest: arm64: Hook TSM accept to Realm TDISP RUN transition
Date: Mon, 27 Apr 2026 13:58:03 +0530
Message-ID: <20260427082805.931832-10-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260427082805.931832-1-aneesh.kumar@kernel.org>
References: <20260427082805.931832-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an accept callback in pci_tsm_ops and implement cca_device_accept() to:
- verify evidence generation (lock_nonce)
- allocate and register protected MMIO ranges
- transition TDI state to RUN

Reviewed-by: Jonathan Cameron <jonathan.cameron@huawei.com>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/virt/coco/arm-cca-guest/arm-cca.c | 20 +++++++++++
 drivers/virt/coco/arm-cca-guest/rsi-da.c  | 43 +++++++++++++++++++++++
 drivers/virt/coco/arm-cca-guest/rsi-da.h  |  1 +
 3 files changed, 64 insertions(+)

diff --git a/drivers/virt/coco/arm-cca-guest/arm-cca.c b/drivers/virt/coco/arm-cca-guest/arm-cca.c
index 320dd5aa7b9a..b29b3948a454 100644
--- a/drivers/virt/coco/arm-cca-guest/arm-cca.c
+++ b/drivers/virt/coco/arm-cca-guest/arm-cca.c
@@ -499,9 +499,29 @@ static void cca_tsm_unlock(struct pci_tsm *tsm)
 	kfree(cca_dsc);
 }
 
+static int __cca_tsm_accept(struct pci_dev *pdev, unsigned long lock_nonce)
+{
+	int ret;
+
+	ret = cca_device_accept(pdev, lock_nonce);
+	if (ret) {
+		pci_err(pdev, "failed to transition the device to run state (%d)\n", ret);
+		return ret;
+	}
+	return 0;
+}
+
+static int cca_tsm_accept(struct pci_dev *pdev)
+{
+	struct cca_guest_dsc *dsc = to_cca_guest_dsc(pdev);
+
+	return __cca_tsm_accept(pdev, dsc->dev_info.lock_nonce);
+}
+
 static struct pci_tsm_ops cca_devsec_pci_ops = {
 	.lock = cca_tsm_lock,
 	.unlock = cca_tsm_unlock,
+	.accept	 = cca_tsm_accept,
 };
 
 static void cca_devsec_tsm_remove(void *tsm_dev)
diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.c b/drivers/virt/coco/arm-cca-guest/rsi-da.c
index 039138768f8f..7c2b28fa43a1 100644
--- a/drivers/virt/coco/arm-cca-guest/rsi-da.c
+++ b/drivers/virt/coco/arm-cca-guest/rsi-da.c
@@ -230,3 +230,46 @@ int cca_verify_digests(u64 hash_algo,
 	}
 	return 0;
 }
+
+int cca_device_accept(struct pci_dev *pdev, unsigned long lock_nonce)
+{
+	int ret;
+	struct cca_guest_dsc *dsc = to_cca_guest_dsc(pdev);
+
+	if (lock_nonce != dsc->dev_info.lock_nonce) {
+		pci_err(pdev, "Device evidence generation mismatch\n");
+		return -EIO;
+	}
+
+	/* Allocation private mmio range based on interface report. */
+	struct pci_tsm_mmio *tsm_mmio __free(kfree) = pci_tsm_mmio_alloc(pdev);
+	if (!tsm_mmio) {
+		pci_err(pdev, "Protected mmio range allocation failure\n");
+		return -ENOMEM;
+	}
+
+	/*
+	 * Present the private mmio range in the resource hierarchy.
+	 * We don't use this for ioremap, ioremap check the RIPAS value.
+	 */
+	ret = pci_tsm_mmio_setup(pdev, tsm_mmio);
+	if (ret) {
+		pci_err(pdev, "Protected mmio setup failure\n");
+		return ret;
+	}
+
+	ret = cca_map_evidence_report_range(pdev, tsm_mmio);
+	if (ret) {
+		pci_err(pdev, "failed to validate the interface report\n");
+		return ret;
+	}
+
+	ret = rhi_vdev_set_tdi_state(pdev, RHI_DA_TDI_CONFIG_RUN);
+	if (ret) {
+		pci_err(pdev, "failed to switch the device (%u) to RUN state\n", ret);
+		return ret;
+	}
+
+	dsc->pci.mmio = no_free_ptr(tsm_mmio);
+	return 0;
+}
diff --git a/drivers/virt/coco/arm-cca-guest/rsi-da.h b/drivers/virt/coco/arm-cca-guest/rsi-da.h
index 07a044d3e335..eeb049d374c5 100644
--- a/drivers/virt/coco/arm-cca-guest/rsi-da.h
+++ b/drivers/virt/coco/arm-cca-guest/rsi-da.h
@@ -61,5 +61,6 @@ int cca_verify_digests(u64 hash_algo,
 		uint8_t *interface_report, size_t interface_report_size,
 		uint8_t *measurements, size_t measurements_size,
 		struct rsi_vdevice_info *dev_info);
+int cca_device_accept(struct pci_dev *pdev, unsigned long lock_nonce);
 
 #endif
-- 
2.43.0

