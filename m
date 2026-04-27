Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9900B3AB278;
	Mon, 27 Apr 2026 08:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777280093; cv=none; b=tSQJBp8dZcXA4b+mz2+0nnCj8U6qyo2mNq5uYC2bg8mvyw/7uyTxURFrQwR62aufZJSp7cYoOn9+QeUGra2olq4Bfy946SS+jBk3ibOMRNpv4+YOAPPw+mikI6TU9ueDojqaVxaqRvtqzcNv9DUdcBPDT2ZgmdLALy+m3Xxm7gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777280093; c=relaxed/simple;
	bh=akRHKPpwP0Keb8Cw+nrNL5vDKueX0ZffUjJeuchV62o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QchnlBE8jFxuNha9ivH1Q7Mg6ieVuZxU+FZ+cLJuUpRmLMwyeALcLoNeJdHFwj+y/BT/vXgK8lG9P42CiFg5we2qHOwE8e2FIOPONuvWya5b3Yk0AH0924SvnQaGwwv5Ersh89A+DCUyG/uW1e31a4HytNsMbxuZCaW8hXAD9R0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dwsVc26Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dwsVc26Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3517C2BCB4;
	Mon, 27 Apr 2026 08:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777280093;
	bh=akRHKPpwP0Keb8Cw+nrNL5vDKueX0ZffUjJeuchV62o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dwsVc26Yxm+WwPUISGblrpOpc8ZD3m+PtODyezcu55Wv3ajEF/+uiDCjdsjBE/alT
	 jCYZSOtJryXS9h2S2+qAY+AGysn9K4u+Ba3JKk5ZO37OivumnXDWIGjnmJaCAC47aH
	 eXsyDAgAfv1Ps4jMf8adIE1pRiQllX8MZ83L7kTSBbZ5NlAzv6BlFihXWd3/dqE8tn
	 bnGI1r6GDsMAtRIhvtT3yDT1NHn53zjKEmShbMBqrYZqeAVUYgRs/eIpEc7eIJV2mG
	 a1sArosFbsKWO1ypUsfvbDfD1UpYazjf7LnBBZpL4MUaj1n9vdEAlb3nnI/7pa9Lox
	 tn1HVLt2hML7A==
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
Subject: [RFC PATCH v4 09/16] coco: host: arm64: Add support for da object read RHI handling
Date: Mon, 27 Apr 2026 14:23:37 +0530
Message-ID: <20260427085344.941627-10-aneesh.kumar@kernel.org>
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

Device assignment-related RHI calls result in a REC exit, which is
handled by the tsm guest_request callback.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 arch/arm64/include/uapi/asm/rmi-da.h     | 21 ++++++
 drivers/virt/coco/arm-cca-host/arm-cca.c | 74 ++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.c  | 95 ++++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.h  |  3 +
 4 files changed, 193 insertions(+)
 create mode 100644 arch/arm64/include/uapi/asm/rmi-da.h

diff --git a/arch/arm64/include/uapi/asm/rmi-da.h b/arch/arm64/include/uapi/asm/rmi-da.h
new file mode 100644
index 000000000000..5ec3413dce94
--- /dev/null
+++ b/arch/arm64/include/uapi/asm/rmi-da.h
@@ -0,0 +1,21 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+
+#ifndef _UAPI__ASM_RMI_DA_H
+#define _UAPI__ASM_RMI_DA_H
+
+#include <linux/types.h>
+
+struct arm64_vdev_object_size_guest_req {
+	__u32 req_type;
+	__u32 object_type;
+};
+#define __RHI_DA_OBJECT_SIZE		0x1
+
+struct arm64_vdev_object_read_guest_req {
+	__u32 req_type;
+	__u32 object_type;
+	__aligned_u64 offset;
+};
+#define __RHI_DA_OBJECT_READ		0x2
+
+#endif
diff --git a/drivers/virt/coco/arm-cca-host/arm-cca.c b/drivers/virt/coco/arm-cca-host/arm-cca.c
index b75fa20513a9..4bf1f1b394af 100644
--- a/drivers/virt/coco/arm-cca-host/arm-cca.c
+++ b/drivers/virt/coco/arm-cca-host/arm-cca.c
@@ -14,6 +14,7 @@
 #include <linux/pci-doe.h>
 #include <linux/pci.h>
 #include <linux/kvm_host.h>
+#include <asm/rmi-da.h>
 
 #include "rmi-da.h"
 
@@ -497,6 +498,78 @@ static void cca_tsm_unbind(struct pci_tdi *tdi)
 	kfree(host_tdi);
 }
 
+static ssize_t cca_tsm_guest_req(struct pci_tdi *tdi, enum pci_tsm_req_scope scope,
+		sockptr_t req, size_t req_len, sockptr_t resp,
+		size_t resp_len, u64 *tsm_code)
+{
+	struct pci_dev *pdev = tdi->pdev;
+
+	if (req.is_kernel || resp.is_kernel)
+		return -EINVAL;
+
+	switch (scope) {
+	case PCI_TSM_REQ_INFO: {
+		u32 req_type;
+
+		if (get_user(req_type, (u32 __user *)req.user))
+			return -EFAULT;
+
+		switch (req_type) {
+		case __RHI_DA_OBJECT_SIZE: {
+			int object_size;
+			struct arm64_vdev_object_size_guest_req req_obj;
+
+			if (req_len != sizeof(req_obj))
+				return -EINVAL;
+
+			if (copy_from_user((void *)&req_obj, req.user, req_len))
+				return -EFAULT;
+			object_size = cca_vdev_get_object_size(pdev, req_obj.object_type);
+			if (object_size > 0) {
+				if (resp_len < sizeof(object_size))
+					return -EINVAL;
+				if (copy_to_user(resp.user, &object_size, sizeof(object_size)))
+					return -EFAULT;
+
+				if (resp_len != sizeof(object_size))
+					return resp_len - sizeof(object_size);
+				return 0;
+			}
+			/* error */
+			return object_size;
+		}
+		case __RHI_DA_OBJECT_READ:
+		{
+			int len;
+			struct arm64_vdev_object_read_guest_req req_obj;
+
+			if (req_len != sizeof(req_obj))
+				return -EINVAL;
+
+			if (copy_from_user((void *)&req_obj, req.user, req_len))
+				return -EFAULT;
+
+			len = cca_vdev_read_cached_object(pdev,
+							  req_obj.object_type,
+							  req_obj.offset,
+							  resp_len, resp.user);
+			if (len > 0) {
+				if (resp_len != len)
+					return resp_len - len;
+				return 0;
+			}
+			/* error */
+			return len;
+		}
+		default:
+			return -EINVAL;
+		}
+	}
+	default:
+		return -EINVAL;
+	}
+}
+
 static struct pci_tsm_ops cca_link_pci_ops = {
 	.probe = cca_tsm_pci_probe,
 	.remove = cca_tsm_pci_remove,
@@ -504,6 +577,7 @@ static struct pci_tsm_ops cca_link_pci_ops = {
 	.disconnect = cca_tsm_disconnect,
 	.bind = cca_tsm_bind,
 	.unbind = cca_tsm_unbind,
+	.guest_req = cca_tsm_guest_req,
 };
 
 static void cca_link_tsm_remove(void *tsm_dev)
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index ef25392562e0..3db42c21dab0 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -12,6 +12,7 @@
 #include <keys/asymmetric-type.h>
 #include <keys/x509-parser.h>
 #include <linux/kvm_types.h>
+#include <linux/kvm_host.h>
 #include <asm/kvm_rmi.h>
 
 #include "rmi-da.h"
@@ -1136,3 +1137,97 @@ void cca_vdev_unlock_and_destroy(struct realm *realm,
 	host_tdi->rmm_vdev = NULL;
 	host_tdi->realm = NULL;
 }
+
+int cca_vdev_get_object_size(struct pci_dev *pdev, int type)
+{
+	long len;
+	struct cca_host_tdi *host_tdi;
+	struct cca_host_pf0_ep_dsc *pf0_ep_dsc;
+	struct pci_tsm *tsm = pdev->tsm;
+	struct cca_host_pdev_dsc *pdev_dsc;
+
+	if (!tsm)
+		return -EINVAL;
+
+	pdev_dsc = to_cca_pdev_dsc(tsm->dsm_dev);
+	pf0_ep_dsc = to_cca_pf0_ep_dsc(tsm->dsm_dev);
+	host_tdi = to_cca_host_tdi(pdev);
+
+	guard(mutex)(&pdev_dsc->object_lock);
+	/* Determine the buffer that should be used */
+	if (type == RHI_DA_OBJECT_INTERFACE_REPORT) {
+		if (!host_tdi->interface_report)
+			return -EINVAL;
+		len = host_tdi->interface_report->offset;
+	} else if (type == RHI_DA_OBJECT_MEASUREMENT) {
+		if (!host_tdi->measurements)
+			return -EINVAL;
+		len = host_tdi->measurements->offset;
+	} else if (type == RHI_DA_OBJECT_CERTIFICATE) {
+		if (!pf0_ep_dsc->cert_chain.cache)
+			return -EINVAL;
+		len = pf0_ep_dsc->cert_chain.cache->offset;
+	} else if (type == RHI_DA_OBJECT_VCA) {
+		if (!pf0_ep_dsc->vca)
+			return -EINVAL;
+		len = pf0_ep_dsc->vca->offset;
+	} else {
+		return -EINVAL;
+	}
+
+	return len;
+}
+
+int cca_vdev_read_cached_object(struct pci_dev *pdev, int type,
+		unsigned long offset, unsigned long max_len,
+		void __user *user_buf)
+{
+	void *buf;
+	unsigned long len;
+	struct cca_host_tdi *host_tdi;
+	struct cca_host_pf0_ep_dsc *pf0_ep_dsc;
+	struct pci_tsm *tsm = pdev->tsm;
+	struct cca_host_pdev_dsc *pdev_dsc;
+
+	if (!tsm)
+		return -EINVAL;
+
+	pdev_dsc = to_cca_pdev_dsc(tsm->dsm_dev);
+	pf0_ep_dsc = to_cca_pf0_ep_dsc(tsm->dsm_dev);
+	host_tdi = to_cca_host_tdi(pdev);
+
+	guard(mutex)(&pdev_dsc->object_lock);
+	/* Determine the buffer that should be used */
+	if (type == RHI_DA_OBJECT_INTERFACE_REPORT) {
+		if (!host_tdi->interface_report)
+			return -EINVAL;
+		len = host_tdi->interface_report->offset;
+		buf = host_tdi->interface_report->buf;
+	} else if (type == RHI_DA_OBJECT_MEASUREMENT) {
+		if (!host_tdi->measurements)
+			return -EINVAL;
+		len = host_tdi->measurements->offset;
+		buf = host_tdi->measurements->buf;
+	} else if (type == RHI_DA_OBJECT_CERTIFICATE) {
+		if (!pf0_ep_dsc->cert_chain.cache)
+			return -EINVAL;
+		len = pf0_ep_dsc->cert_chain.cache->offset;
+		buf = pf0_ep_dsc->cert_chain.cache->buf;
+	} else if (type == RHI_DA_OBJECT_VCA) {
+		if (!pf0_ep_dsc->vca)
+			return -EINVAL;
+		len = pf0_ep_dsc->vca->offset;
+		buf = pf0_ep_dsc->vca->buf;
+	} else {
+		return -EINVAL;
+	}
+
+	/* Assume that the buffer is large enough for the whole report */
+	if (max_len < len)
+		return -E2BIG;
+
+	if (copy_to_user(user_buf, buf + offset, len))
+		return -EIO;
+
+	return len;
+}
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.h b/drivers/virt/coco/arm-cca-host/rmi-da.h
index 97f7eaf1f779..4f1a61a5dcfa 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -242,5 +242,8 @@ int cca_pdev_purge_stream_key(struct pci_dev *pdev1,
 		struct pci_dev *pdev2, unsigned long stream_handle);
 void cca_vdev_unlock_and_destroy(struct realm *realm, struct pci_dev *pdev,
 		struct pci_dev *pf0_dev);
+int cca_vdev_get_object_size(struct pci_dev *pdev, int type);
+int cca_vdev_read_cached_object(struct pci_dev *pdev, int type, unsigned long offset,
+		unsigned long max_len, void __user *user_buf);
 
 #endif
-- 
2.43.0

