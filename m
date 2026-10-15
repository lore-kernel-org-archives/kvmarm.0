Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E6D615326AD
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074400; cv=none; b=BZorlhFG8yalF4qCgAaHb3KHqKw5ULL+xqmk/RAs68SBK3U+F6epItxpqMgZa9U0sh7EYxQYOuMYp8osD3Wg8rAIA5dsDpO/rhlLv2p/oNb9Ix609RXlc4GpaKdal05OS2lPSOOrj+GnZlc6+vr3HLoN6zNOUjaad9NktzzA7g4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074400; c=relaxed/simple;
	bh=8nTqK/gXGNpBA+7zpgdbk84taZTWcv+6ZB6Xx4LiXow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YdfHUsAFdPi7jgInc1lw1+G2VxPwzmJlA/MFaq9yVI0AYTWHU7zj95L7dwnhETv95SFGOqtfDtaSawpIcpBIxbYIDw/A+PGtv0A1sBsGFIFxIKgOTa2oUsc8xzI0O4au0yVYVywSL8J1bUn7J7VjtoxxoVrMl8p7EZfJii1mZvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=nvoCIcaY; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="nvoCIcaY"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8E33115A1;
	Thu, 15 Oct 2026 07:26:24 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.2.198.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 09FD13F871;
	Thu, 15 Oct 2026 07:26:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792074387; bh=8nTqK/gXGNpBA+7zpgdbk84taZTWcv+6ZB6Xx4LiXow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nvoCIcaYVX/M+nkfRxZxnsW4WBC6eqMTL9bQlMjOLUyhc7E0U0zSrEaAfz8ri7xuH
	 DEd+xCSjAC7Q6cL+zkrjTFh25cwBU49kQG5kkhxfabhCxph0XE3fXfM01XDMup41TH
	 0cFv16GLInzBr5OzeKSW0LX/qH2d9uG/dingM8vg=
From: Ryan Roberts <ryan.roberts@arm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Alex Williamson <alex@shazbot.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Rob Herring <robh@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	Oded Gabbay <ogabbay@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	devicetree@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-doc@vger.kernel.org
Subject: [RFC PATCH v2 07/15] misc/arm-cla: Set up memory translation context
Date: Thu, 15 Oct 2026 15:25:41 +0100
Message-ID: <20261015142552.4128028-8-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261015142552.4128028-1-ryan.roberts@arm.com>
References: <20261015142552.4128028-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

CLA accelerators use a Memory Translation Context to describe the
page-table and memory-system configuration used for DMA through the CPU
MMU. Set up the kernel-owned MTC during CLA bringup so later context
switches only need to replace the user TTBR0 value.

Populate the MTC from the CPU EL1 configuration, including SCTLR, MAIR,
TCR and TCR2 where present. Configure the accelerator to run as EL0, put
the ASID in TTBR0 and disable TTBR1 translations because the driver only
installs user contexts in the TTBR0 range. When running at EL2, also
program the host HCR state.

Add SETCTX and GETCTX launch helpers for MTC register access. Use the
first available accelerator ID for these operations, since the MTC is
shared by the CLA but the operation still requires a valid accelerator
ID.

Clear the MTC on CPU teardown, and add helpers to install and uninstall
a user translation context by updating TTBR0 with the process page
table, ASID and CnP state.

Co-developed-by: Jean-Philippe Brucker <jpb@kernel.org>
Signed-off-by: Jean-Philippe Brucker <jpb@kernel.org>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 drivers/misc/arm-cla/Makefile   |   1 +
 drivers/misc/arm-cla/arm-cla.h  |  24 ++++
 drivers/misc/arm-cla/cla-init.c |  10 +-
 drivers/misc/arm-cla/cla-mtc.c  | 206 ++++++++++++++++++++++++++++++++
 drivers/misc/arm-cla/cla-ops.c  |  52 ++++++++
 5 files changed, 291 insertions(+), 2 deletions(-)
 create mode 100644 drivers/misc/arm-cla/cla-mtc.c

diff --git a/drivers/misc/arm-cla/Makefile b/drivers/misc/arm-cla/Makefile
index c1b14155454d..df3ad7e4a1b4 100644
--- a/drivers/misc/arm-cla/Makefile
+++ b/drivers/misc/arm-cla/Makefile
@@ -2,6 +2,7 @@
 
 arm-cla-y := \
 	cla-init.o \
+	cla-mtc.o \
 	cla-ops.o \
 	cla-regs.o \
 	cla-topology.o
diff --git a/drivers/misc/arm-cla/arm-cla.h b/drivers/misc/arm-cla/arm-cla.h
index 6d72d57e5422..40e95d3128ad 100644
--- a/drivers/misc/arm-cla/arm-cla.h
+++ b/drivers/misc/arm-cla/arm-cla.h
@@ -83,8 +83,20 @@ struct cla_regs_pl0 {
 	u64 regstate[];
 };
 
+/**
+ * struct cla_ctx_key - Unique context identifier
+ * @mm: For PL0 contexts, the mm.
+ * @file: for PL0 contexts, the file.
+ */
+struct cla_ctx_key {
+	struct mm_struct *mm;
+	struct file *file;
+};
+
 struct cla_ctx {
+	struct cla_ctx_key key;
 	void **regs;
+	unsigned int asid;
 };
 
 extern struct xarray cla_domains;
@@ -139,6 +151,10 @@ int cla_op_regread(struct cla_dev *dev, unsigned int accid, unsigned int regidx,
 		   size_t nregs, u64 *regs);
 int cla_op_regwrite(struct cla_dev *dev, unsigned int accid,
 		    unsigned int regidx, size_t nregs, u64 *regs);
+int cla_op_setctx(struct cla_dev *dev, unsigned int regidx, size_t nregs,
+		  u64 *regs);
+int cla_op_getctx(struct cla_dev *dev, unsigned int regidx, size_t nregs,
+		  u64 *regs);
 int cla_op_entersr(struct cla_dev *dev, unsigned int accid, u64 *srstate);
 int cla_op_exitsr(struct cla_dev *dev, unsigned int accid, u64 *srstate);
 
@@ -149,4 +165,12 @@ int cla_regs_uninstall(struct cla_dev *dev, struct cla_ctx *ctx,
 int cla_ctx_alloc_regs(struct cla_domain *domain, struct cla_ctx *ctx);
 void cla_ctx_free_regs(struct cla_domain *domain, struct cla_ctx *ctx);
 
+int cla_mtc_setup(struct cla_dev *dev);
+int cla_mtc_clear(struct cla_dev *dev);
+int cla_mtc_install(struct cla_dev *dev, struct cla_ctx *ctx);
+int cla_mtc_uninstall(struct cla_dev *dev, struct cla_ctx *ctx);
+int cla_mtc_get_ctx(struct cla_ctx *ctx);
+void cla_mtc_put_ctx(struct cla_ctx *ctx);
+void cla_mtc_leak_ctx(struct cla_ctx *ctx);
+
 #endif /* _ARM_CLA_H_ */
diff --git a/drivers/misc/arm-cla/cla-init.c b/drivers/misc/arm-cla/cla-init.c
index a4d2ffaa3136..58f37787a59c 100644
--- a/drivers/misc/arm-cla/cla-init.c
+++ b/drivers/misc/arm-cla/cla-init.c
@@ -184,7 +184,8 @@ static void cla_dev_reinit(struct cla_dev *dev)
 	if (dev->broken)
 		return;
 
-	if (WARN_ON(cla_op_reset_all(dev))) {
+	if (WARN_ON(cla_op_reset_all(dev)) ||
+	    WARN_ON(cla_mtc_clear(dev))) {
 		dev->broken = true;
 		return;
 	}
@@ -242,9 +243,14 @@ static int cla_dev_setup(unsigned int cpu)
 
 	cla_reg_write(dev, CLA_REG_PL0CTRL, plxctrl_val);
 
-	if (dev->accelerators)
+	if (dev->accelerators) {
+		ret = cla_mtc_setup(dev);
+		if (ret)
+			goto err;
+
 		cla_info(dev, "available accelerators: 0x%02x\n",
 			 dev->accelerators);
+	}
 
 	dev->discovered = true;
 	return 0;
diff --git a/drivers/misc/arm-cla/cla-mtc.c b/drivers/misc/arm-cla/cla-mtc.c
new file mode 100644
index 000000000000..9ab25085dfdf
--- /dev/null
+++ b/drivers/misc/arm-cla/cla-mtc.c
@@ -0,0 +1,206 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Arm CLA driver - memory translation context
+ *
+ * Copyright 2026 Arm Limited.
+ */
+
+#include <asm/kvm_arm.h>
+#include <linux/mmu_context.h>
+
+#include "arm-cla.h"
+
+#define cla_kernel_mtc \
+	(cla_kernel_pl == 2 ? CLA_MTC_REGIDX_PL2 : CLA_MTC_REGIDX_PL1)
+
+/**
+ * cla_mtc_setup - initialize the memory translation context
+ * @dev: CLA device
+ *
+ * Return: 0 on success, or a negative error code.
+ */
+int cla_mtc_setup(struct cla_dev *dev)
+{
+	int ret;
+	u64 tcr;
+	u64 regs[2 * CLA_MTC_PL_SIZE] = {};
+	u64 *kregs = &regs[cla_kernel_mtc];
+	size_t regs_size = cla_kernel_pl * CLA_MTC_PL_SIZE;
+	u64 reserved_ttbr = phys_to_ttbr(page_to_phys(ZERO_PAGE(0)));
+
+	/*
+	 * The MTC registers deliberately have the same layout as their arm64
+	 * sysreg counterparts. Where MTC registers don't define a particular
+	 * field, it is specified as "reserved RAZ/WI", so we can safely copy
+	 * the whole arm64 register value to the MTC register without needing to
+	 * do any masking. That just leaves the possibility of the CPU
+	 * supporting a VMSA feature which is necessary for correct sharing of
+	 * pgtables that the MTC doesn't support (e.g. MTE, PIE, POE);
+	 * Fortunately, CLA is part of the CPU implementation so this is
+	 * guaranteed never to happen.
+	 */
+
+	/* The accelerator always runs as EL0 */
+	kregs[CLA_MTC_PSTATE] = FIELD_PREP(CLA_MTC_PSTATE_EL, 0) |
+				FIELD_PREP(CLA_MTC_PSTATE_PAN,
+					   system_uses_hw_pan());
+	kregs[CLA_MTC_TTBR0] = reserved_ttbr;
+	kregs[CLA_MTC_TTBR1] = reserved_ttbr;
+	kregs[CLA_MTC_SCTLR] = read_sysreg(sctlr_el1);
+	kregs[CLA_MTC_MAIR] = read_sysreg(mair_el1);
+
+	if (cpus_have_final_cap(ARM64_HAS_TCR2))
+		kregs[CLA_MTC_TCR2] = read_sysreg_s(SYS_TCR2_EL1);
+
+	tcr = read_sysreg(tcr_el1);
+	/*
+	 * Put ASID in TTBR0, so that we only have one reg to update when
+	 * switching context.
+	 */
+	FIELD_MODIFY(TCR_EL1_A1, &tcr, 0);
+	/*
+	 * We never map anything in the TTBR1 VA range so explicitly disable
+	 * translations via TTBR1.
+	 */
+	FIELD_MODIFY(TCR_EL1_EPD1_MASK, &tcr, 1);
+	kregs[CLA_MTC_TCR] = tcr;
+
+	if (cla_kernel_pl == 2) {
+		/* E2H and TGE */
+		regs[CLA_MTC_HCR_EL2] = HCR_HOST_VHE_FLAGS;
+	}
+
+	/*
+	 * All accelerators are idle, meaning there can't be any memory
+	 * transactions happening. So it is safe to setup the MTC in any order.
+	 * i.e. there is no issue with setting SCTLR.M=1 before we have
+	 * configured MAIR or TCR2.
+	 */
+	ret = cla_op_setctx(dev, CLA_MTC_REGIDX_PL1, regs_size, regs);
+	if (ret) {
+		WARN_ON(cla_mtc_clear(dev));
+		return ret;
+	}
+
+	return 0;
+}
+
+/**
+ * cla_mtc_clear - clear the memory translation context
+ * @dev: CLA device
+ *
+ * Return: 0 on success, or a negative error code.
+ */
+int cla_mtc_clear(struct cla_dev *dev)
+{
+	/* Don't set the RES1 bit in VTCR_EL2 because in MTC they are RAZ/WI. */
+	u64 regs[2 * CLA_MTC_PL_SIZE] = {};
+	size_t regs_size = cla_kernel_pl * CLA_MTC_PL_SIZE;
+
+	/* SETCTX fails if there is no ACCID */
+	if (!dev->accelerators)
+		return 0;
+
+	/*
+	 * All accelerators are idle, meaning there can't be any memory
+	 * transactions happening. So it is safe to clear the MTC in any order.
+	 * i.e. there is no issue with clearing TTBRx before setting SCTLR.M=0.
+	 */
+	return cla_op_setctx(dev, CLA_MTC_REGIDX_PL1, regs_size, regs);
+}
+
+static int cla_mtc_install_s1(struct cla_dev *dev, struct cla_ctx *ctx)
+{
+	u64 ttbr0;
+
+	/* SETCTX fails if there is no ACCID */
+	if (!dev->accelerators)
+		return 0;
+
+	ttbr0 = phys_to_ttbr(virt_to_phys(ctx->key.mm->pgd)) |
+		FIELD_PREP(TTBRx_EL1_ASID_MASK, ctx->asid);
+
+	if (system_supports_cnp())
+		ttbr0 |= TTBRx_EL1_CnP;
+
+	return cla_op_setctx(dev, cla_kernel_mtc + CLA_MTC_TTBR0, 1, &ttbr0);
+}
+
+static int cla_mtc_uninstall_s1(struct cla_dev *dev)
+{
+	u64 ttbr0 = phys_to_ttbr(page_to_phys(ZERO_PAGE(0)));
+
+	/* SETCTX fails if there is no ACCID */
+	if (!dev->accelerators)
+		return 0;
+
+	return cla_op_setctx(dev, cla_kernel_mtc + CLA_MTC_TTBR0, 1, &ttbr0);
+}
+
+/**
+ * cla_mtc_install - enable a translation context
+ * @dev: CLA device
+ * @ctx: context to install
+ *
+ * Return: 0 on success, or a negative error code.
+ */
+int cla_mtc_install(struct cla_dev *dev, struct cla_ctx *ctx)
+{
+	return cla_mtc_install_s1(dev, ctx);
+}
+
+/**
+ * cla_mtc_uninstall - disable the translation context
+ * @dev: CLA device
+ * @ctx: context to remove
+ *
+ * Return: 0 on success, or a negative error code.
+ */
+int cla_mtc_uninstall(struct cla_dev *dev, struct cla_ctx *ctx)
+{
+	return cla_mtc_uninstall_s1(dev);
+}
+
+/**
+ * cla_mtc_get_ctx - Get translation information
+ * @ctx: context to get
+ *
+ * Grab the information needed for installing this context.
+ * For stage 1 MTC, pin the ASID.
+ *
+ * Return: 0 on success, or a negative error code.
+ */
+int cla_mtc_get_ctx(struct cla_ctx *ctx)
+{
+	ctx->asid = arm64_mm_context_get(ctx->key.mm);
+	if (ctx->asid == 0)
+		return -ENOSPC;
+
+	return 0;
+}
+
+/**
+ * cla_mtc_put_ctx - Release translation information
+ * @ctx: context to release
+ *
+ * Undo cla_mtc_get_ctx().
+ */
+void cla_mtc_put_ctx(struct cla_ctx *ctx)
+{
+	arm64_mm_context_put(ctx->key.mm);
+}
+
+/**
+ * cla_mtc_leak_ctx - Leak the memory translation config
+ * @ctx: the stuck context
+ *
+ * On catastrophic hardware failure, when we lose control of the device and
+ * cannot uninstall the context, take a reference to the memory context so that
+ * it doesn't get freed. The page directory may be accessed by the hardware
+ * sometime in the future and must not be reallocated.
+ */
+void cla_mtc_leak_ctx(struct cla_ctx *ctx)
+{
+	WARN(1, "leaking PL0 context\n");
+	mmgrab(ctx->key.mm);
+}
diff --git a/drivers/misc/arm-cla/cla-ops.c b/drivers/misc/arm-cla/cla-ops.c
index bb0bac5c2d35..ceca84fd58a9 100644
--- a/drivers/misc/arm-cla/cla-ops.c
+++ b/drivers/misc/arm-cla/cla-ops.c
@@ -249,6 +249,10 @@ static int cla_op_access_reg(struct cla_dev *dev, u8 op,
 	case CLA_LAUNCH_OP_REGWRITE:
 		max_regidx = 0x100000000;
 		break;
+	case CLA_LAUNCH_OP_SETCTX:
+	case CLA_LAUNCH_OP_GETCTX:
+		max_regidx = 0x80;
+		break;
 	default:
 		WARN_ON(1);
 		return -EINVAL;
@@ -315,6 +319,54 @@ int cla_op_regwrite(struct cla_dev *dev, unsigned int accid,
 				 accid, regidx, nregs, regs);
 }
 
+/**
+ * cla_op_setctx - launch SETCTX operation.
+ * @dev: CLA device.
+ * @regidx: first MTC register index.
+ * @nregs: number of registers to set. Can be greater than 8 (accessed with
+ *         multiple SETCTX operations).
+ * @regs: register content, array of length @nregs.
+ *
+ * Return: 0 on success, or an error.
+ */
+int cla_op_setctx(struct cla_dev *dev, unsigned int regidx, size_t nregs,
+		  u64 *regs)
+{
+	/*
+	 * Even though the MTC is shared between all accelerators, accid must be
+	 * valid. If no accelerator is attached, the op fails.
+	 */
+	if (!dev->accelerators)
+		return -ENODEV;
+
+	return cla_op_access_reg(dev, CLA_LAUNCH_OP_SETCTX, CLA_DATA_IN,
+				 __ffs(dev->accelerators), regidx, nregs, regs);
+}
+
+/**
+ * cla_op_getctx - launch GETCTX operation.
+ * @dev: CLA device.
+ * @regidx: first MTC register index.
+ * @nregs: number of registers to get. Can be greater than 8 (accessed with
+ *         multiple GETCTX operations).
+ * @regs: register content, array of length @nregs.
+ *
+ * Return: 0 on success, or an error.
+ */
+int cla_op_getctx(struct cla_dev *dev, unsigned int regidx, size_t nregs,
+		  u64 *regs)
+{
+	/*
+	 * Even though the MTC is shared between all accelerators, accid must be
+	 * valid. If no accelerator is attached, the op fails.
+	 */
+	if (!dev->accelerators)
+		return -ENODEV;
+
+	return cla_op_access_reg(dev, CLA_LAUNCH_OP_GETCTX, CLA_DATA_OUT,
+				 __ffs(dev->accelerators), regidx, nregs, regs);
+}
+
 /**
  * cla_op_entersr - launch ENTERSR operation.
  * @dev: CLA device.
-- 
2.43.0

