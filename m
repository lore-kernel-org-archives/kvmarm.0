Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66CF35349AD
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074389; cv=none; b=KolD5ERWylEQX993SvRrByPyZUNB0Iu3CSNZ7p9XJ+Q+fn9CBVbQadNqmJfx1u0wh7H/2Lu0cdHMMvtJrl6e4P9xqI0u8SLwUf9X+M5PjaYB2xV61i2sDSTwlYTJdR4CU8WR/0mskRkwqGqPiHEJ4gpzO6+1PfhzpUQexJsQVAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074389; c=relaxed/simple;
	bh=HiQhnFeZAHqs9PJhZRil3wbZduwa+fFnW+iFYdZdmH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B4PPVQTIFpHVq/XauRe/e7EF01hkQsJ1X8peR9WblvHRMOlTEvVBKGAxOll8Wh5VCPaDyFLv3gp5hXSo5ns4dfyW2QMmNgW7eA/HMsxIEB2YfgnSa/HzrAR1/wKi+7CKsJ3LYsFZBX+5GxPaD1A/Ybno0VSZ2tli0wYeAqc6oGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=SDWu8jhh; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="SDWu8jhh"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2C16F1576;
	Thu, 15 Oct 2026 07:26:18 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.2.198.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 7B7ED3F871;
	Thu, 15 Oct 2026 07:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792074381; bh=HiQhnFeZAHqs9PJhZRil3wbZduwa+fFnW+iFYdZdmH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SDWu8jhhK2Uwim8I9VurlgaqdGpRUqONwrqUNPzTpFbJbYB1kvKcqV72rwQfnwoKW
	 z3Ur3+1b/kTNGEAmp4TYiDE7KmzF7EKNJCuaElW2LsJU6Prb/XDpRnj8ouN+Fv0o12
	 yIbs1X9uyNBINiulOs5f4k1ftww/INzuQNohd0n8=
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
Subject: [RFC PATCH v2 05/15] misc/arm-cla: Initialize devices on CPU bringup
Date: Thu, 15 Oct 2026 15:25:39 +0100
Message-ID: <20261015142552.4128028-6-ryan.roberts@arm.com>
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

CLA registers are only accessible from the CPU local to the CLA, so
perform device initialization from the CPU hotplug online callback.

Clear the DATA registers, reset each attached accelerator and verify
that it returns to the expected idle state. Record the set of usable
accelerators and expose only those through PL0CTRL, and through PL1CTRL
when the kernel is running at EL2.

Reset optional timestamp and PMU controls where available so userspace
starts from a predictable state, but do not fail probing if those
optional controls cannot be programmed.

On CPU teardown, reset all known accelerators and mark the device broken
if reset fails, since the hotplug teardown path cannot safely fail.

Signed-off-by: Jean-Philippe Brucker <jpb@kernel.org>
---
 drivers/misc/arm-cla/arm-cla.h  |  14 +++
 drivers/misc/arm-cla/cla-init.c | 191 +++++++++++++++++++++++++++++++-
 drivers/misc/arm-cla/cla-ops.c  |  23 ++++
 3 files changed, 227 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/arm-cla/arm-cla.h b/drivers/misc/arm-cla/arm-cla.h
index 61176c4fce0f..6890c813a5c3 100644
--- a/drivers/misc/arm-cla/arm-cla.h
+++ b/drivers/misc/arm-cla/arm-cla.h
@@ -27,16 +27,25 @@ struct cla_domain;
  * @regs:		Registers accessed by the kernel.
  * @dev:		The platform device.
  * @pfn:		Page of registers assigned to user.
+ * @accelerators:	Available accelerators.
  * @pg_offset:		Mmap offset of this device.
  * @domain:		The domain this CLA belongs to.
+ *
+ * Mutable, protected by CPU hotplug locking:
+ * @discovered:		Discovered state is cached.
+ * @broken:		Hardware failure.
  */
 struct cla_dev {
 	unsigned int cpu;
 	void __iomem *regs;
 	struct device *dev;
 	unsigned long pfn;
+	u8 accelerators;
 	unsigned long pg_offset;
 	struct cla_domain *domain;
+
+	bool discovered;
+	bool broken;
 };
 
 /**
@@ -61,6 +70,10 @@ extern struct cla_dev **cla_lut_cpu;
 extern struct cla_dev **cla_lut_pg;
 extern unsigned int cla_nr_devs;
 
+#define cla_for_each_accid(dev, accid) \
+	for ((accid) = 0; (accid) < CLA_NUM_ACC; (accid)++) \
+		for_each_if((dev)->accelerators & BIT(accid))
+
 #define cla_dbg(_dev, fmt, ...) \
 	dev_dbg((_dev)->dev, "[%u] " fmt, (_dev)->cpu, ##__VA_ARGS__)
 #define cla_info(_dev, fmt, ...) \
@@ -98,6 +111,7 @@ void cla_domains_free(void);
 
 int cla_op_wait_lresp(struct cla_dev *dev, u64 *lresp);
 int cla_op_reset(struct cla_dev *dev, unsigned int accid);
+int cla_op_reset_all(struct cla_dev *dev);
 int cla_op_regread(struct cla_dev *dev, unsigned int accid, unsigned int regidx,
 		   size_t nregs, u64 *regs);
 int cla_op_regwrite(struct cla_dev *dev, unsigned int accid,
diff --git a/drivers/misc/arm-cla/cla-init.c b/drivers/misc/arm-cla/cla-init.c
index 6818fb8c38ed..2974bf71033c 100644
--- a/drivers/misc/arm-cla/cla-init.c
+++ b/drivers/misc/arm-cla/cla-init.c
@@ -18,18 +18,204 @@
 
 static int cla_cpuhp_state = -1;
 
+static int cla_reset_ts(struct cla_dev *dev, unsigned int accid)
+{
+	int ret;
+	u64 reg;
+
+	ret = cla_op_regread(dev, accid, CLA_REG_ACAP, 1, &reg);
+	if (ret)
+		return ret;
+	if (!FIELD_GET(CLA_ACAP_TS, reg))
+		return 0;
+
+	/*
+	 * Disable TS control from userspace, provide TS from CNTP. If we do
+	 * have to provide a timer to userspace or a virtual offset to a guest,
+	 * we'll need to make sure we have access to both TSCTRLOWNER and
+	 * TSOFFOWNER. For now best effort.
+	 */
+	reg = FIELD_PREP(CLA_TSCTRLOWNER_PL, cla_kernel_pl);
+	ret = cla_op_regwrite(dev, accid, CLA_REG_TSCTRLOWNER, 1, &reg);
+	if (!ret) {
+		reg = FIELD_PREP(CLA_TSCTRL_TS, CLA_TSCTRL_PHYSICAL);
+		ret = cla_op_regwrite(dev, accid, CLA_REG_TSCTRL, 1, &reg);
+		if (ret)
+			return ret;
+	}
+
+	reg = FIELD_PREP(CLA_TSOFFOWNER_PL, cla_kernel_pl);
+	ret = cla_op_regwrite(dev, accid, CLA_REG_TSOFFOWNER, 1, &reg);
+	if (!ret) {
+		reg = 0;
+		ret = cla_op_regwrite(dev, accid, CLA_REG_TSVOFF, 1, &reg);
+		if (ret)
+			return ret;
+		ret = cla_op_regwrite(dev, accid, CLA_REG_TSPOFF, 1, &reg);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+static int cla_reset_pmu(struct cla_dev *dev, unsigned int accid)
+{
+	int ret;
+	u64 reg;
+
+	/* Disable PMU access */
+	reg = FIELD_PREP(CLA_PMUOWNER_PL, cla_kernel_pl);
+	ret = cla_op_regwrite(dev, accid, CLA_REG_PMUOWNER, 1, &reg);
+	if (!ret) {
+		reg = 0;
+		ret = cla_op_regwrite(dev, accid, CLA_REG_PMURESET, 1, &reg);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
+/*
+ * Discover immutable accelerator properties the first time the CPU comes
+ * online. Return: 0 on success, 1 if the accelerator is not usable, or an
+ * error.
+ */
+static int cla_dev_discover_accel(struct cla_dev *dev, unsigned int accid)
+{
+	dev->accelerators |= (1 << accid);
+
+	return 0;
+}
+
+/*
+ * Reset hardware on every online, but discover its properties only once.
+ * Return: 0 on success, 1 if the accelerator is not attached or not usable, or
+ * an error.
+ */
+static int cla_dev_setup_accel(struct cla_dev *dev, unsigned int accid)
+{
+	u64 status;
+	int ret;
+
+	/*
+	 * Reset even accelerators excluded during discovery, so that they cannot
+	 * issue memory transactions when we set up the shared MTC. Only skip
+	 * absent accelerators that were not previously discovered. Fail if a
+	 * higher PL has masked access.
+	 */
+	ret = cla_op_reset(dev, accid);
+	if (ret > 0 && (dev->accelerators & (1 << accid))) {
+		cla_err(dev, "[%u] previously discovered accelerator is absent\n",
+			accid);
+		return -ENODEV;
+	}
+	if (ret)
+		return ret;
+
+	status = cla_reg_read(dev, CLA_REG_STATUS(accid));
+	if ((status & CLA_STATUS_STATE_MASK) != CLA_STATUS_STATE_IDLE) {
+		cla_err(dev, "unexpected status 0x%llx for accelerator %d\n",
+			status, accid);
+		return -EIO;
+	}
+
+	/*
+	 * The following are nice to have, but the accelerator should work
+	 * without them.
+	 */
+	ret = cla_reset_ts(dev, accid);
+	if (ret)
+		cla_err(dev, "[%u] could not reset TS: %d\n", accid, ret);
+
+	ret = cla_reset_pmu(dev, accid);
+	if (ret)
+		cla_err(dev, "[%u] could not reset PMU: %d\n", accid, ret);
+
+	if (!dev->discovered) {
+		ret = cla_dev_discover_accel(dev, accid);
+		if (ret)
+			return ret;
+	} else if (!(dev->accelerators & (1 << accid))) {
+		return 1;
+	}
+
+	return 0;
+}
+
+/* Clean the device before releasing it */
+static void cla_dev_reinit(struct cla_dev *dev)
+{
+	int i;
+
+	if (dev->broken)
+		return;
+
+	if (WARN_ON(cla_op_reset_all(dev))) {
+		dev->broken = true;
+		return;
+	}
+
+	if (is_kernel_in_hyp_mode())
+		cla_reg_write(dev, CLA_REG_PL1CTRL, ~0ULL);
+	cla_reg_write(dev, CLA_REG_PL0CTRL, ~0ULL);
+	for (i = 0; i < CLA_NUM_DATA_REGS; i++)
+		cla_reg_write(dev, CLA_REG_DATA(i), 0);
+	cla_reg_write(dev, CLA_REG_LRESP, 0);
+}
+
 static int cla_dev_setup(unsigned int cpu)
 {
+	int i;
+	int ret;
+	unsigned int accid;
 	struct cla_dev *dev;
+	u64 plxctrl_val = 0;
 
 	dev = cla_lut_cpu[cpu];
-	if (!dev)
+	if (!dev || dev->broken)
 		return 0;
 
 	if (WARN_ON(smp_processor_id() != cpu || dev->cpu != cpu))
 		return -EINVAL;
 
+	if (!dev->discovered) {
+		/* Discard partial results from an earlier, failed discovery. */
+		dev->accelerators = 0;
+	}
+
+	/* Clear DATA and LRESP_DATANZ */
+	for (i = 0; i < CLA_NUM_DATA_REGS; i++)
+		cla_reg_write(dev, CLA_REG_DATA(i), 0);
+
+	/*
+	 * Reset all accelerators. We restrict PLxCTRL to the accelerators that
+	 * are attached and well behaved.
+	 */
+	for (accid = 0; accid < CLA_NUM_ACC; accid++) {
+		ret = cla_dev_setup_accel(dev, accid);
+		if (ret > 0)
+			continue;
+		else if (ret < 0)
+			goto err;
+
+		plxctrl_val |= CLA_PLxCTRL_PREP(accid,
+						FIELD_PREP(CLA_PLxCTRL_AVAIL, 1));
+	}
+
+	if (is_kernel_in_hyp_mode())
+		cla_reg_write(dev, CLA_REG_PL1CTRL, plxctrl_val);
+
+	cla_reg_write(dev, CLA_REG_PL0CTRL, plxctrl_val);
+
+	if (dev->accelerators)
+		cla_info(dev, "available accelerators: 0x%02x\n",
+			 dev->accelerators);
+
+	dev->discovered = true;
 	return 0;
+err:
+	cla_dev_reinit(dev);
+	return ret;
 }
 
 static int cla_dev_teardown(unsigned int cpu)
@@ -44,6 +230,8 @@ static int cla_dev_teardown(unsigned int cpu)
 	if (!dev)
 		return 0;
 
+	cla_dev_reinit(dev);
+
 	return 0;
 }
 
@@ -85,6 +273,7 @@ static struct cla_dev *cla_dev_alloc(struct device *parent, int cpu,
 	dev->cpu = cpu;
 	dev->dev = parent;
 
+
 	/* Attempt to find device domain, or allocate a new one */
 	dev->domain = cla_dev_domain_get(dev);
 	if (IS_ERR(dev->domain))
diff --git a/drivers/misc/arm-cla/cla-ops.c b/drivers/misc/arm-cla/cla-ops.c
index 46026304a057..5d053c6aa1f7 100644
--- a/drivers/misc/arm-cla/cla-ops.c
+++ b/drivers/misc/arm-cla/cla-ops.c
@@ -207,6 +207,29 @@ int cla_op_reset(struct cla_dev *dev, unsigned int accid)
 	return 0;
 }
 
+/**
+ * cla_op_reset_all - Reset all attached accelerators
+ * @dev: CLA device.
+ *
+ * Return: 0 on success, or an error
+ */
+int cla_op_reset_all(struct cla_dev *dev)
+{
+	int ret, err = 0;
+	unsigned int accid;
+
+	cla_for_each_accid(dev, accid) {
+		ret = cla_op_reset(dev, accid);
+		if (ret && !err)
+			err = ret;
+	}
+	/*
+	 * Since all accelerators in this loop are present, cla_op_reset()
+	 * returning 1 is an error.
+	 */
+	return err <= 0 ? err : -ENODEV;
+}
+
 /* regidx is unsigned long here to avoid overflow during calculations */
 static int cla_op_access_reg(struct cla_dev *dev, u8 op,
 			     enum cla_launch_data_mode data_mode,
-- 
2.43.0

