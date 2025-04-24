Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE6B1B423E
	for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 14:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745504065; cv=none; b=iZ8ocYvvkuS5EoI+xTYsSQkazBSTu4VfBSMzvZ/CGO/NhxWtWpOMKZ2eTFsDPu2GHi9aq4YjMTglwYkRz76VsMkJClDQ01pAkcckevCH2X+p6ocGW9p4oFKimBlw8rmlqAQN98s93mhIzuXKSTPA1AHz3GkOM+jw1s6i9lgaR7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745504065; c=relaxed/simple;
	bh=jJJ9JgoTw3N1VJhubYw/1Fl9AFSEgg6AWN3vhACh320=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gwP1jS3i16SX3FmcXWIoU7J7ivymf9xcPh8EEETEYRRooY7ve3yatoFvC7vl/30Um2Vq1ZstA/faKk/I/QEgH1EVZhcmxD4F15z1+P7OmU41bt5+aFo0abZxm7wOcRvvijGzxXiijzKDAkDqiUDQnPqC0Jmv50Zt+xK9UJXN+ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RF5R6VZn; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RF5R6VZn"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-39141ffa9fcso1251481f8f.0
        for <kvmarm@lists.linux.dev>; Thu, 24 Apr 2025 07:14:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745504059; x=1746108859; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JWj7uDN15UXCYW87dO7IIzOLdNiL+f7UvEUy/qTIHd4=;
        b=RF5R6VZnXcMOtC7xXzfa4VTx5Yscs5ImEzO3/5KL0V+17eCKkS7ChsxwFCNX9UD+GY
         4xImfY07pTnwtMcwyUnD+wwwcPB3bLHqAIZKnB4VkqOv4qaxaFB80H9j9sPg1h3PPqnd
         80+ma5mzKvDvqEREybWAUN0iaBMjH47f79KWRTrB+0dkxMe2cLAAiFxjG+9+5COP5Tbo
         955vGl6k9Lw30IUzRNe/TnMf8crnOP4xIiPxlUxysO2Z2BfyHYBkEqJaTgVYRoBxolp5
         c+19ITrly/6lji2rkbJMK2J1TUZ2FV73xZ3kVz3pUMD10dCzRUxVpR51xbdohL6f7klx
         qpow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745504059; x=1746108859;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JWj7uDN15UXCYW87dO7IIzOLdNiL+f7UvEUy/qTIHd4=;
        b=XOQ8+A8Gw+xvs+dSYntB4zIAeK7JLGGyEU4jHBvfx9vdx5PpSFzt1PGCtcIWBuLZ4Z
         JqVyqewtta8uowplPWgtq7PqdAulFNnX3agy/a9Hh3SXmCjGRl5R3TuyqCeS5k8zON6z
         Cnid7UG6oYspoLdY1db4EYVsK5rbxBzM7zlNmPfSfvA5U0NZ4sbR49RJIgn0xgWvdphc
         U1XA51zK14beGMi0WWxkWsqOQJeJ3SUXFjp5UpXrEZzNLZzHh3fUndziu9QWHFYp0Eg7
         73+TZUaNZw7jjTCc0SDWitc2ABRYdHYErXk6VaMbuaQG6lcUSVz3bVaofKKY1dDVtHnl
         NcCQ==
X-Forwarded-Encrypted: i=1; AJvYcCXys+85Tpm2A6bPVTa6X6VSs8kutTGPSheybKgMhFB/pKUc5/crzFt+NAAa7p2pDF7GsjdkLdE=@lists.linux.dev
X-Gm-Message-State: AOJu0YwKwNGZZLJjVt1SiB+ZzW0n1ryM4mZ43yXzo2xxHyJGO7Bjs+uj
	3nbcCczcvvk5QWJQvUVHbwP+CvLcddFwHvOWwXvUbGbvTVXKLqE+r6ROgUXUB10=
X-Gm-Gg: ASbGnct9gnYv6tF7rj+Mdr3/5ZyYhDamTeKE4+/ph3OEwqiJKNrQYO+jHg0ZOX1BGo4
	ktSHNSlv/gkDIEYZO59/3DW0Yisilz8MHrJrHHXWoNTulDRA2TXjz2WU15WWdIfxE1abQ14W56W
	Ys0XVmlMGCtNbBbQ9JIYJ5C2wLDdnwiAhUD6DZABKuF1qgIlxr/iIg31I//uimtvUXULpjXkawI
	yAe9lqMfqDilHkSzhEUv+a/qFjVhYN5BY5T+sPpCZIXgbIBHcQpigicgjTTNQ37vJ6KKFIGUOdO
	WujHw9XOvy6nLObx3UjVmorwAuGBJXV7yo4XQORUUd+Nia+kNyMBlU+qHUX+q9MYl/vdVDLn735
	vfUEDR7z3JBvg1JOki0OQVz4FaZM=
X-Google-Smtp-Source: AGHT+IEZ62CGRLn02mw6Sp1FYoWsMMZ/LoDmb0ZQtBfZ0JQt0jIozyM3jnvRsN2MwUnOvlF4h+jCiw==
X-Received: by 2002:a05:6000:184c:b0:39f:64ff:668d with SMTP id ffacd0b85a97d-3a06cfa5a65mr2546775f8f.40.1745504058677;
        Thu, 24 Apr 2025 07:14:18 -0700 (PDT)
Received: from seksu.systems-nuts.com (stevens.inf.ed.ac.uk. [129.215.164.122])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a06d4a8150sm2199951f8f.7.2025.04.24.07.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Apr 2025 07:14:18 -0700 (PDT)
From: Karim Manaouil <karim.manaouil@linaro.org>
To: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Cc: Karim Manaouil <karim.manaouil@linaro.org>,
	Alexander Graf <graf@amazon.com>,
	Alex Elder <elder@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>,
	Quentin Perret <qperret@google.com>,
	Rob Herring <robh@kernel.org>,
	Srinivas Kandagatla <srini@kernel.org>,
	Srivatsa Vaddagiri <quic_svaddagi@quicinc.com>,
	Will Deacon <will@kernel.org>,
	Haripranesh S <haripran@qti.qualcomm.com>,
	Carl van Schaik <cvanscha@qti.qualcomm.com>,
	Murali Nalajala <mnalajal@quicinc.com>,
	Sreenivasulu Chalamcharla <sreeniva@qti.qualcomm.com>,
	Trilok Soni <tsoni@quicinc.com>,
	Stefan Schmidt <stefan.schmidt@linaro.org>,
	Elliot Berman <quic_eberman@quicinc.com>,
	Alex Elder <elder@linaro.org>
Subject: [RFC PATCH 25/34] gunyah: Add Qualcomm Gunyah platform ops
Date: Thu, 24 Apr 2025 15:13:32 +0100
Message-Id: <20250424141341.841734-26-karim.manaouil@linaro.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250424141341.841734-1-karim.manaouil@linaro.org>
References: <20250424141341.841734-1-karim.manaouil@linaro.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Elliot Berman <quic_eberman@quicinc.com>

Qualcomm platforms have a firmware entity which performs access control
to physical pages. Dynamically started Gunyah virtual machines use the
QCOM_SCM_RM_MANAGED_VMID for access. Linux thus needs to assign access
to the memory used by guest VMs. Gunyah doesn't do this operation for us
since it is the current VM (typically VMID_HLOS) delegating the access
and not Gunyah itself. Use the Gunyah platform ops to achieve this so
that only Qualcomm platforms attempt to make the needed SCM calls.

Reviewed-by: Alex Elder <elder@linaro.org>
Co-developed-by: Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>
Signed-off-by: Prakruthi Deepak Heragu <quic_pheragu@quicinc.com>
Signed-off-by: Elliot Berman <quic_eberman@quicinc.com>
Signed-off-by: Karim Manaouil <karim.manaouil@linaro.org>
---
 drivers/virt/gunyah/Kconfig       |  13 ++
 drivers/virt/gunyah/Makefile      |   1 +
 drivers/virt/gunyah/gunyah_qcom.c | 220 ++++++++++++++++++++++++++++++
 3 files changed, 234 insertions(+)
 create mode 100644 drivers/virt/gunyah/gunyah_qcom.c

diff --git a/drivers/virt/gunyah/Kconfig b/drivers/virt/gunyah/Kconfig
index 23ba523d25dc..fe2823dc48ba 100644
--- a/drivers/virt/gunyah/Kconfig
+++ b/drivers/virt/gunyah/Kconfig
@@ -4,6 +4,7 @@ config GUNYAH
 	tristate "Gunyah Virtualization drivers"
 	depends on ARM64
 	select GUNYAH_PLATFORM_HOOKS
+	imply GUNYAH_QCOM_PLATFORM if ARCH_QCOM
 	help
 	  The Gunyah drivers are the helper interfaces that run in a guest VM
 	  such as basic inter-VM IPC and signaling mechanisms, and higher level
@@ -14,3 +15,15 @@ config GUNYAH
 
 config GUNYAH_PLATFORM_HOOKS
 	tristate
+
+config GUNYAH_QCOM_PLATFORM
+	tristate "Support for Gunyah on Qualcomm platforms"
+	depends on GUNYAH
+	select GUNYAH_PLATFORM_HOOKS
+	select QCOM_SCM
+	help
+	  Enable support for interacting with Gunyah on Qualcomm
+	  platforms. Interaction with Qualcomm firmware requires
+	  extra platform-specific support.
+
+	  Say Y/M here to use Gunyah on Qualcomm platforms.
diff --git a/drivers/virt/gunyah/Makefile b/drivers/virt/gunyah/Makefile
index 45cabba3110c..349c37e9f0ad 100644
--- a/drivers/virt/gunyah/Makefile
+++ b/drivers/virt/gunyah/Makefile
@@ -4,3 +4,4 @@ gunyah_rsc_mgr-y += rsc_mgr.o rsc_mgr_rpc.o
 
 obj-$(CONFIG_GUNYAH) += gunyah.o gunyah_rsc_mgr.o
 obj-$(CONFIG_GUNYAH_PLATFORM_HOOKS) += gunyah_platform_hooks.o
+obj-$(CONFIG_GUNYAH_QCOM_PLATFORM) += gunyah_qcom.o
diff --git a/drivers/virt/gunyah/gunyah_qcom.c b/drivers/virt/gunyah/gunyah_qcom.c
new file mode 100644
index 000000000000..f2342d51a018
--- /dev/null
+++ b/drivers/virt/gunyah/gunyah_qcom.c
@@ -0,0 +1,220 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2023-2024 Qualcomm Innovation Center, Inc. All rights reserved.
+ */
+
+#include <linux/arm-smccc.h>
+#include <linux/gunyah.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/firmware/qcom/qcom_scm.h>
+#include <linux/types.h>
+#include <linux/uuid.h>
+
+#define QCOM_SCM_RM_MANAGED_VMID 0x3A
+#define QCOM_SCM_MAX_MANAGED_VMID 0x3F
+
+static int
+qcom_scm_gunyah_rm_pre_mem_share(struct gunyah_rm *rm,
+				 struct gunyah_rm_mem_parcel *mem_parcel)
+{
+	struct qcom_scm_vmperm *new_perms __free(kfree) = NULL;
+	u64 src, src_cpy;
+	int ret = 0, i, n;
+	u16 vmid;
+
+	new_perms = kcalloc(mem_parcel->n_acl_entries, sizeof(*new_perms),
+			    GFP_KERNEL);
+	if (!new_perms)
+		return -ENOMEM;
+
+	for (n = 0; n < mem_parcel->n_acl_entries; n++) {
+		vmid = le16_to_cpu(mem_parcel->acl_entries[n].vmid);
+		if (vmid <= QCOM_SCM_MAX_MANAGED_VMID)
+			new_perms[n].vmid = vmid;
+		else
+			new_perms[n].vmid = QCOM_SCM_RM_MANAGED_VMID;
+		if (mem_parcel->acl_entries[n].perms & GUNYAH_RM_ACL_X)
+			new_perms[n].perm |= QCOM_SCM_PERM_EXEC;
+		if (mem_parcel->acl_entries[n].perms & GUNYAH_RM_ACL_W)
+			new_perms[n].perm |= QCOM_SCM_PERM_WRITE;
+		if (mem_parcel->acl_entries[n].perms & GUNYAH_RM_ACL_R)
+			new_perms[n].perm |= QCOM_SCM_PERM_READ;
+	}
+
+	src = BIT_ULL(QCOM_SCM_VMID_HLOS);
+
+	for (i = 0; i < mem_parcel->n_mem_entries; i++) {
+		src_cpy = src;
+		ret = qcom_scm_assign_mem(
+			le64_to_cpu(mem_parcel->mem_entries[i].phys_addr),
+			le64_to_cpu(mem_parcel->mem_entries[i].size), &src_cpy,
+			new_perms, mem_parcel->n_acl_entries);
+		if (ret)
+			break;
+	}
+
+	/* Did it work ok? */
+	if (!ret)
+		return 0;
+
+	src = 0;
+	for (n = 0; n < mem_parcel->n_acl_entries; n++) {
+		vmid = le16_to_cpu(mem_parcel->acl_entries[n].vmid);
+		if (vmid <= QCOM_SCM_MAX_MANAGED_VMID)
+			src |= BIT_ULL(vmid);
+		else
+			src |= BIT_ULL(QCOM_SCM_RM_MANAGED_VMID);
+	}
+
+	new_perms[0].vmid = QCOM_SCM_VMID_HLOS;
+	new_perms[0].perm = QCOM_SCM_PERM_EXEC | QCOM_SCM_PERM_WRITE |
+			    QCOM_SCM_PERM_READ;
+
+	for (i--; i >= 0; i--) {
+		src_cpy = src;
+		WARN_ON_ONCE(qcom_scm_assign_mem(
+			le64_to_cpu(mem_parcel->mem_entries[i].phys_addr),
+			le64_to_cpu(mem_parcel->mem_entries[i].size), &src_cpy,
+			new_perms, 1));
+	}
+
+	return ret;
+}
+
+static int
+qcom_scm_gunyah_rm_post_mem_reclaim(struct gunyah_rm *rm,
+				    struct gunyah_rm_mem_parcel *mem_parcel)
+{
+	struct qcom_scm_vmperm new_perms;
+	u64 src = 0, src_cpy;
+	int ret = 0, i, n;
+	u16 vmid;
+
+	new_perms.vmid = QCOM_SCM_VMID_HLOS;
+	new_perms.perm = QCOM_SCM_PERM_EXEC | QCOM_SCM_PERM_WRITE |
+			 QCOM_SCM_PERM_READ;
+
+	for (n = 0; n < mem_parcel->n_acl_entries; n++) {
+		vmid = le16_to_cpu(mem_parcel->acl_entries[n].vmid);
+		if (vmid <= QCOM_SCM_MAX_MANAGED_VMID)
+			src |= (1ull << vmid);
+		else
+			src |= (1ull << QCOM_SCM_RM_MANAGED_VMID);
+	}
+
+	for (i = 0; i < mem_parcel->n_mem_entries; i++) {
+		src_cpy = src;
+		ret = qcom_scm_assign_mem(
+			le64_to_cpu(mem_parcel->mem_entries[i].phys_addr),
+			le64_to_cpu(mem_parcel->mem_entries[i].size), &src_cpy,
+			&new_perms, 1);
+		WARN_ON_ONCE(ret);
+	}
+
+	return ret;
+}
+
+static int
+qcom_scm_gunyah_rm_pre_demand_page(struct gunyah_rm *rm, u16 vmid,
+				   enum gunyah_pagetable_access access,
+				   struct folio *folio)
+{
+	struct qcom_scm_vmperm new_perms[2];
+	unsigned int n = 1;
+	u64 src;
+
+	new_perms[0].vmid = QCOM_SCM_RM_MANAGED_VMID;
+	new_perms[0].perm = QCOM_SCM_PERM_EXEC | QCOM_SCM_PERM_WRITE |
+			    QCOM_SCM_PERM_READ;
+	if (access != GUNYAH_PAGETABLE_ACCESS_X &&
+	    access != GUNYAH_PAGETABLE_ACCESS_RX &&
+	    access != GUNYAH_PAGETABLE_ACCESS_RWX) {
+		new_perms[1].vmid = QCOM_SCM_VMID_HLOS;
+		new_perms[1].perm = QCOM_SCM_PERM_EXEC | QCOM_SCM_PERM_WRITE |
+				    QCOM_SCM_PERM_READ;
+		n++;
+	}
+
+	src = BIT_ULL(QCOM_SCM_VMID_HLOS);
+
+	return qcom_scm_assign_mem(__pfn_to_phys(folio_pfn(folio)),
+				   folio_size(folio), &src, new_perms, n);
+}
+
+static int
+qcom_scm_gunyah_rm_release_demand_page(struct gunyah_rm *rm, u16 vmid,
+				       enum gunyah_pagetable_access access,
+				       struct folio *folio)
+{
+	struct qcom_scm_vmperm new_perms;
+	u64 src;
+
+	new_perms.vmid = QCOM_SCM_VMID_HLOS;
+	new_perms.perm = QCOM_SCM_PERM_EXEC | QCOM_SCM_PERM_WRITE |
+			 QCOM_SCM_PERM_READ;
+
+	src = BIT_ULL(QCOM_SCM_RM_MANAGED_VMID);
+
+	if (access != GUNYAH_PAGETABLE_ACCESS_X &&
+	    access != GUNYAH_PAGETABLE_ACCESS_RX &&
+	    access != GUNYAH_PAGETABLE_ACCESS_RWX)
+		src |= BIT_ULL(QCOM_SCM_VMID_HLOS);
+
+	return qcom_scm_assign_mem(__pfn_to_phys(folio_pfn(folio)),
+				   folio_size(folio), &src, &new_perms, 1);
+}
+
+static struct gunyah_rm_platform_ops qcom_scm_gunyah_rm_platform_ops = {
+	.pre_mem_share = qcom_scm_gunyah_rm_pre_mem_share,
+	.post_mem_reclaim = qcom_scm_gunyah_rm_post_mem_reclaim,
+	.pre_demand_page = qcom_scm_gunyah_rm_pre_demand_page,
+	.release_demand_page = qcom_scm_gunyah_rm_release_demand_page,
+};
+
+/* {19bd54bd-0b37-571b-946f-609b54539de6} */
+static const uuid_t QCOM_EXT_UUID = UUID_INIT(0x19bd54bd, 0x0b37, 0x571b, 0x94,
+					      0x6f, 0x60, 0x9b, 0x54, 0x53,
+					      0x9d, 0xe6);
+
+#define GUNYAH_QCOM_EXT_CALL_UUID_ID                              \
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL, ARM_SMCCC_SMC_32, \
+			   ARM_SMCCC_OWNER_VENDOR_HYP, 0x3f01)
+
+static bool gunyah_has_qcom_extensions(void)
+{
+	struct arm_smccc_res res;
+	uuid_t uuid;
+	u32 *up;
+
+	arm_smccc_1_1_smc(GUNYAH_QCOM_EXT_CALL_UUID_ID, &res);
+
+	up = (u32 *)&uuid.b[0];
+	up[0] = lower_32_bits(res.a0);
+	up[1] = lower_32_bits(res.a1);
+	up[2] = lower_32_bits(res.a2);
+	up[3] = lower_32_bits(res.a3);
+
+	return uuid_equal(&uuid, &QCOM_EXT_UUID);
+}
+
+static int __init qcom_gunyah_platform_hooks_register(void)
+{
+	if (!gunyah_has_qcom_extensions())
+		return -ENODEV;
+
+	pr_info("Enabling Gunyah hooks for Qualcomm platforms.\n");
+
+	return gunyah_rm_register_platform_ops(
+		&qcom_scm_gunyah_rm_platform_ops);
+}
+
+static void __exit qcom_gunyah_platform_hooks_unregister(void)
+{
+	gunyah_rm_unregister_platform_ops(&qcom_scm_gunyah_rm_platform_ops);
+}
+
+module_init(qcom_gunyah_platform_hooks_register);
+module_exit(qcom_gunyah_platform_hooks_unregister);
+MODULE_DESCRIPTION("Qualcomm Technologies, Inc. Platform Hooks for Gunyah");
+MODULE_LICENSE("GPL");
-- 
2.39.5

