Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB2E3530DE2
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074375; cv=none; b=ftzDTbTEBBG5wWGsHi6NNp6rxy3fkDh52HWQVbrAemzfaNiKP3fjSe+EK6V54DvqW1fj551K1n0TxeuT24McXTv6vAP3E7xVR747dx2M4xppl5TpfeS99B39RjipPy3zd0vNiuZLhwcCvQf+BBT+m0j5z9Hy3sxir2N1C9eHO3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074375; c=relaxed/simple;
	bh=+sWSx7q4/Kw4lwtWKeviDU8sZZvwTr4UZ7T0bQPZcT4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wwum9NwnyZBSeC6MW99yDzgQaQYRnWQ/qL81s3x8aaRTtYAIRPAorBKlZAVvCIOK1atKv6m9aTiF3/rvCMOkOJ821MELyEmWz0DtExAtfHSlymuQw6QZNt2oBmey4qoNa3fyDMnIi92vkp0IEAfw9OoVd80LkLww8U2hL6MaMu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=DY769hD2; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="DY769hD2"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D13AD1576;
	Thu, 15 Oct 2026 07:26:07 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.2.198.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9DBEA3F871;
	Thu, 15 Oct 2026 07:26:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792074371; bh=+sWSx7q4/Kw4lwtWKeviDU8sZZvwTr4UZ7T0bQPZcT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DY769hD2aZ1vtvDesRp5NMChqCCV5ltsWck8QekzDyKNA0DuRSEd6vBFWyH1QeS54
	 D3A2S6P99KAJdEs0fWxHm2zMMUJIEv+q7Pf3PUgOMmlsGGz9aeoE2CCx8yJKLAp2mv
	 j74pglqhMvx/4mY3LDtwHKNK6hkAwZLwE1cdx1QE=
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
Subject: [RFC PATCH v2 02/15] misc/arm-cla: Add launch operation helpers
Date: Thu, 15 Oct 2026 15:25:36 +0100
Message-ID: <20261015142552.4128028-3-ryan.roberts@arm.com>
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

From: Jean-Philippe Brucker <jpb@kernel.org>

CLA commands are issued by writing optional payload registers,
programming the LAUNCH register and polling LRESP until the hardware
accepts or rejects the operation.

Add a common launch helper that performs this sequence on the CLA's
local CPU, waits for LRESP completion and translates launch response
codes into Linux errors.

Build accelerator reset and register read and write support on top of
it. The register read and write helpers split larger accesses into
multiple launch operations when an access crosses an eight-register
window.

Signed-off-by: Jean-Philippe Brucker <jpb@kernel.org>
---
 drivers/misc/arm-cla/Makefile   |   6 +
 drivers/misc/arm-cla/arm-cla.h  |  24 +++
 drivers/misc/arm-cla/cla-init.c |  12 ++
 drivers/misc/arm-cla/cla-ops.c  | 293 ++++++++++++++++++++++++++++++++
 4 files changed, 335 insertions(+)
 create mode 100644 drivers/misc/arm-cla/cla-init.c
 create mode 100644 drivers/misc/arm-cla/cla-ops.c

diff --git a/drivers/misc/arm-cla/Makefile b/drivers/misc/arm-cla/Makefile
index a4e40e534e6a..3fa8567c8b3e 100644
--- a/drivers/misc/arm-cla/Makefile
+++ b/drivers/misc/arm-cla/Makefile
@@ -1 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0-only
+
+arm-cla-y := \
+	cla-init.o \
+	cla-ops.o
+
+obj-$(CONFIG_ARM_CLA) += arm-cla.o
diff --git a/drivers/misc/arm-cla/arm-cla.h b/drivers/misc/arm-cla/arm-cla.h
index 1e8ffca28bc6..4884e4804ab3 100644
--- a/drivers/misc/arm-cla/arm-cla.h
+++ b/drivers/misc/arm-cla/arm-cla.h
@@ -7,6 +7,9 @@
 #ifndef _ARM_CLA_H_
 #define _ARM_CLA_H_
 
+#include <linux/device.h>
+#include <linux/io.h>
+
 #include "arm-cla-regs.h"
 
 /* Number of accelerators per CLA */
@@ -19,10 +22,12 @@
  *
  * Immutable state:
  * @cpu:		The CPU this CLA is attached to.
+ * @regs:		Registers accessed by the kernel.
  * @dev:		The platform device.
  */
 struct cla_dev {
 	unsigned int cpu;
+	void __iomem *regs;
 	struct device *dev;
 };
 
@@ -33,4 +38,23 @@ struct cla_dev {
 #define cla_err(_dev, fmt, ...) \
 	dev_err((_dev)->dev, "[%u] " fmt, (_dev)->cpu, ##__VA_ARGS__)
 
+static inline u64 cla_reg_read(struct cla_dev *dev, off_t reg)
+{
+	/* MMIO reads are all relaxed, since the driver doesn't use DMA. */
+	return readq_relaxed(dev->regs + reg);
+}
+
+static inline void cla_reg_write(struct cla_dev *dev, off_t reg, u64 val)
+{
+	/* MMIO writes are all relaxed, since the driver doesn't use DMA. */
+	return writeq_relaxed(val, dev->regs + reg);
+}
+
+int cla_op_wait_lresp(struct cla_dev *dev, u64 *lresp);
+int cla_op_reset(struct cla_dev *dev, unsigned int accid);
+int cla_op_regread(struct cla_dev *dev, unsigned int accid, unsigned int regidx,
+		   size_t nregs, u64 *regs);
+int cla_op_regwrite(struct cla_dev *dev, unsigned int accid,
+		    unsigned int regidx, size_t nregs, u64 *regs);
+
 #endif /* _ARM_CLA_H_ */
diff --git a/drivers/misc/arm-cla/cla-init.c b/drivers/misc/arm-cla/cla-init.c
new file mode 100644
index 000000000000..3d1f47592842
--- /dev/null
+++ b/drivers/misc/arm-cla/cla-init.c
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Arm CLA driver - probing and initialization
+ *
+ * Copyright 2026 Arm Limited.
+ */
+
+#include <linux/module.h>
+
+MODULE_DESCRIPTION("Arm Core Local Accelerator");
+MODULE_AUTHOR("Arm Limited");
+MODULE_LICENSE("GPL");
diff --git a/drivers/misc/arm-cla/cla-ops.c b/drivers/misc/arm-cla/cla-ops.c
new file mode 100644
index 000000000000..46026304a057
--- /dev/null
+++ b/drivers/misc/arm-cla/cla-ops.c
@@ -0,0 +1,293 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Arm CLA driver - Launch operations
+ *
+ * Copyright 2026 Arm Limited.
+ */
+
+#include <linux/iopoll.h>
+
+#include "arm-cla.h"
+
+/* Time to wait between two LRESP reads */
+#define CLA_LRESP_DELAY_US	1
+
+/*
+ * Time to wait for LRESP_PENDING to clear. Commands like REGREAD should
+ * complete in a few cycles, but ENTERSR and RESET may need to clean up
+ * some very large states depending on the work interrupted, and may need
+ * 1us or more. Some software models need a lot more time.
+ */
+#define CLA_LRESP_TIMEOUT_US	1000000 /* 1s! */
+
+/* Time to wait between two STATUS reads when polling for DMB */
+#define CLA_STATUS_DMB_DELAY_US	10
+
+/* Time to wait for STATUS_DMB to be set after a successful RESET or ENTERSR. */
+#define CLA_STATUS_DMB_TIMEOUT_US 1000000 /* 1s! */
+
+enum cla_launch_data_mode {
+	CLA_DATA_NONE,
+	CLA_DATA_IN,
+	CLA_DATA_OUT,
+};
+
+struct cla_launch {
+	u8	op;		/* opcode */
+	u8	ndata_m1;	/* Data size minus 1 */
+	u8	accid;		/* Accelerator ID */
+	bool	seq;		/* part of compound cmd */
+	u32	regidx;		/* Register index */
+
+	enum cla_launch_data_mode data_mode;
+	u64	*data;		/* In/out data */
+
+	u8	errcode;	/* Output error code */
+};
+
+/**
+ * cla_op_launch - Launch operation.
+ * @dev: CLA device.
+ * @launch: LAUNCH settings.
+ *
+ * 1. Check that no previous operation is pending.
+ * 2. If data_mode is %CLA_DATA_IN, write DATA registers.
+ * 3. Launch the operation, and wait for the response.
+ * 4. If data_mode is %CLA_DATA_OUT, read DATA registers into @launch->data.
+ *
+ * Return:
+ * * %0			- Success.
+ * * %-EAGAIN		- A previous operation is still pending. Nothing was
+ *			  written to DATA or LAUNCH.
+ * * %-ETIMEDOUT	- LAUNCH timed out (possibly no CLA at this address).
+ *			  Unless LRESP_PENDING eventually clears, this is
+ *			  unrecoverable.
+ * * %-ENODEV		- Accelerator not available.
+ * * %-EBUSY		- Accelerator is busy.
+ * * %-EIO		- LAUNCH error. @launch->errcode contains the LRESP
+ *			  error code.
+ */
+static int cla_op_launch(struct cla_dev *dev, struct cla_launch *launch)
+{
+	int i;
+	int ret;
+	u64 lresp;
+
+	if (WARN_ON(smp_processor_id() != dev->cpu))
+		return -EINVAL;
+
+	lresp = cla_reg_read(dev, CLA_REG_LRESP);
+	if (FIELD_GET(CLA_LRESP_PENDING, lresp))
+		return -EAGAIN;
+
+	if (launch->data_mode == CLA_DATA_IN)
+		for (i = 0; i < launch->ndata_m1 + 1; i++)
+			cla_reg_write(dev, CLA_REG_DATA(i), launch->data[i]);
+
+	/*
+	 * For operations that return a response, LAUNCH sets LRESP_PENDING or
+	 * provides an immediate response. So a previously completed error
+	 * response does not block a new LAUNCH and does not need to be
+	 * explicitly cleared.
+	 */
+	cla_reg_write(dev, CLA_REG_LAUNCH,
+		      FIELD_PREP(CLA_LAUNCH_OP, launch->op) |
+		      FIELD_PREP(CLA_LAUNCH_NDATA_M1, launch->ndata_m1) |
+		      FIELD_PREP(CLA_LAUNCH_ACCID, launch->accid) |
+		      FIELD_PREP(CLA_LAUNCH_SEQ, launch->seq) |
+		      FIELD_PREP(CLA_LAUNCH_REGIDX, launch->regidx));
+
+	ret = cla_op_wait_lresp(dev, &lresp);
+	if (ret) {
+		cla_err(dev, "launch failed with %d\n", ret);
+		return ret;
+	}
+
+	switch (FIELD_GET(CLA_LRESP_CODE, lresp)) {
+	case CLA_LRESP_OK:
+		break;
+	case CLA_LRESP_UNAVAIL:
+		return -ENODEV;
+	case CLA_LRESP_BUSY:
+		return -EBUSY;
+	case CLA_LRESP_ERROR:
+		launch->errcode = FIELD_GET(CLA_LRESP_ERRCODE, lresp);
+		return -EIO;
+	}
+
+	if (launch->data_mode == CLA_DATA_OUT)
+		for (i = 0; i < launch->ndata_m1 + 1; i++)
+			launch->data[i] = cla_reg_read(dev, CLA_REG_DATA(i));
+
+	return 0;
+}
+
+/**
+ * cla_op_wait_lresp - Wait for any LAUNCH op to complete.
+ * @dev: CLA device.
+ * @lresp: last LRESP value read.
+ *
+ * Return: 0 on success, -ETIMEDOUT in case of timeout.
+ */
+int cla_op_wait_lresp(struct cla_dev *dev, u64 *lresp)
+{
+	return readq_relaxed_poll_timeout_atomic(dev->regs + CLA_REG_LRESP,
+			*lresp, FIELD_GET(CLA_LRESP_PENDING, *lresp) == 0,
+			CLA_LRESP_DELAY_US, CLA_LRESP_TIMEOUT_US);
+}
+
+/*
+ * Wait for STATUS_DMB to be 1. Although RESET and ENTERSR both wait for
+ * accelerators to return to STATUS_IDLE, some writes may still be pending. When
+ * all accesses reach the PoC, STATUS_DMB is 1.
+ *
+ * This is needed for a few reasons:
+ *
+ * - Propagation of STATUS_EABORT. Until all writes are flushed and STATUS_DMB
+ *   is 1, external aborts may still happen. The next context must not see this
+ *   external abort reported in its status.
+ *
+ *   Note that EABORT cannot be injected into the previous context, it is not
+ *   part of the saved and restored STATUS bits.
+ *
+ * - Turning CLA power off.
+ *
+ * - Migrating an accelerator owner across CPUs, although the driver does not
+ *   support it.
+ *
+ * Return: -ETIMEDOUT on timeout. On success, return 0 and set *status to the
+ * last status read.
+ */
+static int cla_wait_status_dmb(struct cla_dev *dev, unsigned int accid, u64 *status)
+{
+	return poll_timeout_us(*status = cla_reg_read(dev, CLA_REG_STATUS(accid)),
+			       *status & CLA_STATUS_DMB,
+			       CLA_STATUS_DMB_DELAY_US,
+			       CLA_STATUS_DMB_TIMEOUT_US,
+			       /* sleep_before_read */ false);
+}
+
+/**
+ * cla_op_reset - Launch RESET operation for this accelerator.
+ * @dev: CLA device.
+ * @accid: accelerator ID.
+ *
+ * Return: 0 on success, 1 if there is no accelerator with this ID, or an error.
+ */
+int cla_op_reset(struct cla_dev *dev, unsigned int accid)
+{
+	int ret;
+	u64 status;
+	struct cla_launch launch = {
+		.op	= CLA_LAUNCH_OP_RESET,
+		.accid	= accid,
+	};
+
+	ret = cla_op_launch(dev, &launch);
+	if (ret) {
+		if (ret == -EIO && launch.errcode == CLA_ERRCODE_NOACC)
+			return 1;
+		return ret;
+	}
+
+	/* Wait for outstanding writes */
+	ret = cla_wait_status_dmb(dev, accid, &status);
+	if (ret)
+		return ret;
+
+	/*
+	 * If STATUS.EABORT is set, a RAS error report is available. Launch a
+	 * second reset to clear the bit. No need to wait for STATUS.DMB again
+	 * since all accelerators are idle from the first reset, so no more
+	 * memory writes could have been generated.
+	 */
+	if (status & CLA_STATUS_EABORT)
+		return cla_op_launch(dev, &launch);
+
+	return 0;
+}
+
+/* regidx is unsigned long here to avoid overflow during calculations */
+static int cla_op_access_reg(struct cla_dev *dev, u8 op,
+			     enum cla_launch_data_mode data_mode,
+			     unsigned int accid, unsigned long regidx,
+			     size_t nregs, u64 *regs)
+{
+	int ret = -EINVAL;
+	unsigned long max_regidx;
+	struct cla_launch launch = {
+		.op = op,
+		.accid = accid,
+		.data_mode = data_mode,
+	};
+
+	switch (op) {
+	case CLA_LAUNCH_OP_REGREAD:
+	case CLA_LAUNCH_OP_REGWRITE:
+		max_regidx = 0x100000000;
+		break;
+	default:
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	if (WARN_ON(regidx + nregs > max_regidx))
+		return -EINVAL;
+
+	/* 1 to 8 registers accessed at a time, within the same 8-reg group */
+	while (nregs > 0) {
+		u64 reg_group = ALIGN_DOWN(regidx, 8);
+		u64 max_reg = min(regidx + nregs, reg_group + 8);
+		u8 ndata = max_reg - regidx;
+
+		launch.ndata_m1 = ndata - 1;
+		launch.regidx = regidx;
+		launch.data = regs;
+
+		ret = cla_op_launch(dev, &launch);
+		if (ret)
+			break;
+
+		regidx += ndata;
+		regs += ndata;
+		nregs -= ndata;
+	}
+
+	return ret;
+}
+
+/**
+ * cla_op_regread - Launch REGREAD operations.
+ * @dev: CLA device.
+ * @accid: accelerator ID.
+ * @regidx: first register index.
+ * @nregs: number of registers. Can be greater than 8 (accessed with multiple
+ *         REGREAD operations).
+ * @regs: array of length @nregs.
+ *
+ * Return: 0 on success, or an error.
+ */
+int cla_op_regread(struct cla_dev *dev, unsigned int accid,
+			  unsigned int regidx, size_t nregs, u64 *regs)
+{
+	return cla_op_access_reg(dev, CLA_LAUNCH_OP_REGREAD, CLA_DATA_OUT,
+				 accid, regidx, nregs, regs);
+}
+
+/**
+ * cla_op_regwrite - Launch REGWRITE operations.
+ * @dev: CLA device.
+ * @accid: accelerator ID.
+ * @regidx: first register index.
+ * @nregs: number of registers. Can be greater than 8 (accessed with multiple
+ *         REGWRITE operations).
+ * @regs: array of length @nregs.
+ *
+ * Return: 0 on success, or an error.
+ */
+int cla_op_regwrite(struct cla_dev *dev, unsigned int accid,
+			   unsigned int regidx, size_t nregs, u64 *regs)
+{
+	return cla_op_access_reg(dev, CLA_LAUNCH_OP_REGWRITE, CLA_DATA_IN,
+				 accid, regidx, nregs, regs);
+}
-- 
2.43.0

