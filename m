Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1681832BF5D;
	Thu, 12 Mar 2026 08:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773302897; cv=none; b=sjn95efYI7xgnjCIxx60bXaq9LnzwKD5V2UDn1D7/NylSoetlWn/qxoF7lzxyMkmSRTJm4N5EhajxsFrIuewEwcbjVa0hlBTYmv7RibU7pQWjkWrfJKGmz7ws08GN4nfem5jcsEVBGwvHraOqzJFZv6gnmpEEitR7ro+SRXgRAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773302897; c=relaxed/simple;
	bh=FSdn3t2ZY8cGMCVtv3JbZnrDXMLmGAeljHmGpvgJjPk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mQkmsdXTsh03pJf0F0z3uwV5e0TCOHUJFozk5bcJWg/JBlewNg/SGuJfbIBJ5neOMXwzqlm5rL55IjhM3TGScI9UN8sxPEokNubA0JgME5RxHqL2QSJbEGrvbCWbwshVUcakfOu6IkKDtNHn8yYM78XVRD/BgrBeaxvLtV8Zt/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KkG3olXy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KkG3olXy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8603C116C6;
	Thu, 12 Mar 2026 08:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773302897;
	bh=FSdn3t2ZY8cGMCVtv3JbZnrDXMLmGAeljHmGpvgJjPk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KkG3olXyYebeC6IwHKpT3yrm/H9lmUq0KKiBEXIR8U0/MgSH+b1Ye6pKSFWKexYwq
	 szRcQQkseoKNHYuZdYP9//+EiqeIpU26XkwgDX2TWtTfeMhyPip/qqV0Ko+R0KJ0uH
	 Z4nZJknSBrovTbQt/KxPreBbaz6wnVZN9s0hRD20wWo+mKetYbSoltNRj6+JjOOLvU
	 SqAAMEi/OL2PQM53C52tBcp1AxgXl6bJvvg0qncdIyLGdQreo5MXlRdkzRtCwNx8Wr
	 14x6H01MA+fzBFsljIXiJiheFKabD5k54iYELAnQP7xRXEKVry1y7Jj3Gm77yKOmqJ
	 4ndcZEQlqiNeA==
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
Subject: [RFC PATCH v3 04/12] coco: host: arm64: Add support for da object read RHI handling
Date: Thu, 12 Mar 2026 13:37:35 +0530
Message-ID: <20260312080743.3487326-5-aneesh.kumar@kernel.org>
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

Device assignment-related RHI calls result in a REC exit, which is
handled by the tsm guest_request callback.

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
 arch/arm64/include/asm/rhi.h             |  4 ++
 arch/arm64/include/uapi/asm/rmi-da.h     | 19 +++++
 drivers/virt/coco/arm-cca-host/arm-cca.c | 75 +++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.c  | 91 ++++++++++++++++++++++++
 drivers/virt/coco/arm-cca-host/rmi-da.h  |  4 ++
 5 files changed, 193 insertions(+)
 create mode 100644 arch/arm64/include/uapi/asm/rmi-da.h

diff --git a/arch/arm64/include/asm/rhi.h b/arch/arm64/include/asm/rhi.h
index 8f9ea4a4bb7c..3c84fedba4ab 100644
--- a/arch/arm64/include/asm/rhi.h
+++ b/arch/arm64/include/asm/rhi.h
@@ -79,4 +79,8 @@ enum rhi_tdi_state {
 #define RHI_DA_VDEV_SET_TDI_STATE	SMC_RHI_CALL(0x0054)
 #define RHI_DA_VDEV_ABORT		SMC_RHI_CALL(0x0056)
 
+/* guest request operation nr */
+#define __RHI_DA_OBJECT_SIZE		0x1
+#define __RHI_DA_OBJECT_READ		0x2
+
 #endif
diff --git a/arch/arm64/include/uapi/asm/rmi-da.h b/arch/arm64/include/uapi/asm/rmi-da.h
new file mode 100644
index 000000000000..8743d9a2e5f7
--- /dev/null
+++ b/arch/arm64/include/uapi/asm/rmi-da.h
@@ -0,0 +1,19 @@
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
+
+struct arm64_vdev_object_read_guest_req {
+	__u32 req_type;
+	__u32 object_type;
+	__aligned_u64 offset;
+};
+
+#endif
diff --git a/drivers/virt/coco/arm-cca-host/arm-cca.c b/drivers/virt/coco/arm-cca-host/arm-cca.c
index 1c17269809a1..8678acd84d7d 100644
--- a/drivers/virt/coco/arm-cca-host/arm-cca.c
+++ b/drivers/virt/coco/arm-cca-host/arm-cca.c
@@ -13,6 +13,7 @@
 #include <linux/cleanup.h>
 #include <linux/kvm_host.h>
 #include <linux/pci.h>
+#include <asm/rmi-da.h>
 
 #include "rmi-da.h"
 
@@ -277,6 +278,79 @@ static void cca_tsm_unbind(struct pci_tdi *tdi)
 	kfree(host_tdi);
 }
 
+static ssize_t cca_tsm_guest_req(struct pci_tdi *tdi, enum pci_tsm_req_scope scope,
+				 sockptr_t req, size_t req_len,
+				 sockptr_t resp, size_t resp_len,
+				 u64 *tsm_code)
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
@@ -284,6 +358,7 @@ static struct pci_tsm_ops cca_link_pci_ops = {
 	.disconnect = cca_tsm_disconnect,
 	.bind = cca_tsm_bind,
 	.unbind = cca_tsm_unbind,
+	.guest_req = cca_tsm_guest_req,
 };
 
 static void cca_link_tsm_remove(void *tsm_dev)
diff --git a/drivers/virt/coco/arm-cca-host/rmi-da.c b/drivers/virt/coco/arm-cca-host/rmi-da.c
index 2181430c47b5..fb623e5e5b62 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.c
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.c
@@ -12,6 +12,7 @@
 #include <keys/asymmetric-type.h>
 #include <keys/x509-parser.h>
 #include <linux/kvm_types.h>
+#include <linux/kvm_host.h>
 #include <asm/kvm_rmi.h>
 
 #include "rmi-da.h"
@@ -837,3 +838,93 @@ void cca_vdev_unlock_and_destroy(struct realm *realm,
 	host_tdi->rmm_vdev = NULL;
 	host_tdi->realm = NULL;
 }
+
+int cca_vdev_get_object_size(struct pci_dev *pdev, int type)
+{
+	long len;
+	struct pci_tsm *tsm = pdev->tsm;
+	struct cca_host_pf0_dsc *pf0_dsc;
+	struct cca_host_tdi *host_tdi;
+
+	if (!tsm)
+		return -EINVAL;
+
+	pf0_dsc = to_cca_pf0_dsc(tsm->dsm_dev);
+	host_tdi = to_cca_host_tdi(pdev);
+
+	guard(mutex)(&pf0_dsc->object_lock);
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
+		if (!pf0_dsc->cert_chain.cache)
+			return -EINVAL;
+		len = pf0_dsc->cert_chain.cache->offset;
+	} else if (type == RHI_DA_OBJECT_VCA) {
+		if (!pf0_dsc->vca)
+			return -EINVAL;
+		len = pf0_dsc->vca->offset;
+	} else {
+		return -EINVAL;
+	}
+
+	return len;
+}
+
+int cca_vdev_read_cached_object(struct pci_dev *pdev, int type,
+				unsigned long offset,
+				unsigned long max_len, void __user *user_buf)
+{
+	void *buf;
+	unsigned long len;
+	struct cca_host_pf0_dsc *pf0_dsc;
+	struct cca_host_tdi *host_tdi;
+	struct pci_tsm *tsm = pdev->tsm;
+
+	if (!tsm)
+		return -EINVAL;
+
+	pf0_dsc = to_cca_pf0_dsc(tsm->dsm_dev);
+	host_tdi = to_cca_host_tdi(pdev);
+
+	guard(mutex)(&pf0_dsc->object_lock);
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
+		if (!pf0_dsc->cert_chain.cache)
+			return -EINVAL;
+		len = pf0_dsc->cert_chain.cache->offset;
+		buf = pf0_dsc->cert_chain.cache->buf;
+	} else if (type == RHI_DA_OBJECT_VCA) {
+		if (!pf0_dsc->vca)
+			return -EINVAL;
+		len = pf0_dsc->vca->offset;
+		buf = pf0_dsc->vca->buf;
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
index 9b0af1ac208f..9cc587393d02 100644
--- a/drivers/virt/coco/arm-cca-host/rmi-da.h
+++ b/drivers/virt/coco/arm-cca-host/rmi-da.h
@@ -11,6 +11,7 @@
 #include <linux/pci-tsm.h>
 #include <linux/sizes.h>
 #include <asm/rmi_smc.h>
+#include <asm/rhi.h>
 
 #define MAX_CACHE_OBJ_SIZE	SZ_16M
 #define CACHE_CHUNK_SIZE	SZ_4K
@@ -143,4 +144,7 @@ void *cca_vdev_create(struct realm *realm, struct pci_dev *pdev,
 		      struct pci_dev *pf0_dev, u32 guest_rid);
 void cca_vdev_unlock_and_destroy(struct realm *realm, struct pci_dev *pdev,
 				 struct pci_dev *pf0_dev);
+int cca_vdev_get_object_size(struct pci_dev *pdev, int type);
+int cca_vdev_read_cached_object(struct pci_dev *pdev, int type, unsigned long offset,
+				unsigned long max_len, void __user *user_buf);
 #endif
-- 
2.43.0

