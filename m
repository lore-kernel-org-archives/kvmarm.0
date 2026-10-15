Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1B0E545DAD
	for <kvmarm@lists.linux.dev>; Thu, 15 Oct 2026 14:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792074422; cv=none; b=UWZHUh+RWFR2I1ZWiInBZawVKndWSefrMcj+OBSCjl47CfWElisHXiovt3ouIDtirKIYj9cAaP9aG8W2IpbI3pMO/WQcDMuvJKChumeE0WEPcbAAGnJicfAr34eka2wIQMe8MKdTvu/vn7+mHQSEpsIxuapvx0lLTUaXnLbQ28E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792074422; c=relaxed/simple;
	bh=jyAlkcz7Hoy/h8rp4Ip9aKsq+EFAowP7eD9yk4nKG2k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kzlwMpW00brC5S5arZqIgmBFnPAVjGhtDr+KivHXme00Qibh6InvSD1EuOVBjk+rYCukyVlh9srvoLThSEHh6FIadZgqUgv9y/WXd9vpfbkd8esMdnoldRyBk4tX2yiSlI+Yvk6elTO1JZnIHB+RuZcCDyU10CAmT6Ntw8zC4rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Zvj/A6se; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Zvj/A6se"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C097715A1;
	Thu, 15 Oct 2026 07:26:45 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.2.198.107])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2279D3F871;
	Thu, 15 Oct 2026 07:26:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792074409; bh=jyAlkcz7Hoy/h8rp4Ip9aKsq+EFAowP7eD9yk4nKG2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zvj/A6sepRFkrCBF8+4yVWabSavnINC5Ma5PBsa1FxdMgI6IuFCwFwWy8JnNw36qP
	 OSbxlg+xOmdx3OZ8srnzRg9L32tNPecyffqpKmykRPQU7swibDLPnx0fgiqJFagkCV
	 amf11KGTTHE1xcWBqKxFGpMEFkxVA5iwvhfdKOBY=
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
Subject: [RFC PATCH v2 13/15] misc/arm-cla: Add stage-2 MTC and VM context switch
Date: Thu, 15 Oct 2026 15:25:47 +0100
Message-ID: <20261015142552.4128028-14-ryan.roberts@arm.com>
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

Add functions to switch the guest MTC. Reset the accelerators and CLA
registers on switch. No save/restore of accelerators at the moment, we
only restore the kernel's PL0CTL.

Signed-off-by: Jean-Philippe Brucker <jpb@kernel.org>
---
 drivers/misc/arm-cla/arm-cla-regs.h |  12 ++
 drivers/misc/arm-cla/arm-cla.h      |  41 ++++++-
 drivers/misc/arm-cla/cla-ctx.c      |  55 +++++++++-
 drivers/misc/arm-cla/cla-mtc.c      | 163 +++++++++++++++++++++++++---
 drivers/misc/arm-cla/cla-regs.c     |  63 ++++++++++-
 drivers/misc/arm-cla/cla-sched.c    |   5 +-
 6 files changed, 308 insertions(+), 31 deletions(-)

diff --git a/drivers/misc/arm-cla/arm-cla-regs.h b/drivers/misc/arm-cla/arm-cla-regs.h
index 167e9ab64051..a7fc19f67893 100644
--- a/drivers/misc/arm-cla/arm-cla-regs.h
+++ b/drivers/misc/arm-cla/arm-cla-regs.h
@@ -37,6 +37,18 @@
 #define CLA_PLxCTRL_DBGPERM		GENMASK(3, 1)
 #define CLA_PLxCTRL_PREP(accid, v)	((u64)(v) << (8 * (accid)))
 
+/* Valid bits of PLxCTRL. Other bits are RAZ/WI */
+#define _CLA_PLxCTRL_MASK (CLA_PLxCTRL_AVAIL | CLA_PLxCTRL_DBGPERM)
+#define CLA_PLxCTRL_MASK  \
+	(CLA_PLxCTRL_PREP(0, _CLA_PLxCTRL_MASK) | \
+	 CLA_PLxCTRL_PREP(1, _CLA_PLxCTRL_MASK) | \
+	 CLA_PLxCTRL_PREP(2, _CLA_PLxCTRL_MASK) | \
+	 CLA_PLxCTRL_PREP(3, _CLA_PLxCTRL_MASK) | \
+	 CLA_PLxCTRL_PREP(4, _CLA_PLxCTRL_MASK) | \
+	 CLA_PLxCTRL_PREP(5, _CLA_PLxCTRL_MASK) | \
+	 CLA_PLxCTRL_PREP(6, _CLA_PLxCTRL_MASK) | \
+	 CLA_PLxCTRL_PREP(7, _CLA_PLxCTRL_MASK))
+
 #define CLA_STATUS_AVAIL		BIT(0)
 #define CLA_STATUS_DMB			BIT(1)
 #define CLA_STATUS_EABORT		BIT(2)
diff --git a/drivers/misc/arm-cla/arm-cla.h b/drivers/misc/arm-cla/arm-cla.h
index e047094dd49c..c9ecab5ab6bf 100644
--- a/drivers/misc/arm-cla/arm-cla.h
+++ b/drivers/misc/arm-cla/arm-cla.h
@@ -31,6 +31,9 @@
 /* Quantum of CLA assignment */
 #define CLA_SLICE_MS		100
 
+struct kvm;
+struct kvm_arch_guest_mmu;
+
 struct cla_domain;
 
 struct cla_call_on_cpu {
@@ -141,18 +144,43 @@ struct cla_regs_pl0 {
 	u64 regstate[];
 };
 
+/**
+ * struct cla_regs_pl1 - Saved CLA register state (PL1)
+ * @pl0ctrl: Host PL0 control register
+ *
+ * Most registers are simply reset when transitionning to and from VMs, since we
+ * don't support shared assignment.
+ */
+struct cla_regs_pl1 {
+	u64 pl0ctrl;
+};
+
+enum cla_ctx_type {
+	CLA_CTX_PL0,
+	CLA_CTX_PL1,
+};
+
 /**
  * struct cla_ctx_key - Unique context identifier
+ * @type: Context type, PL0 or PL1
  * @mm: For PL0 contexts, the mm.
  * @file: for PL0 contexts, the file.
+ * @kvm: For PL1 contexts, the virtual machine.
  */
 struct cla_ctx_key {
-	struct mm_struct *mm;
-	struct file *file;
+	enum cla_ctx_type type;
+	union {
+		struct {
+			struct mm_struct *mm;
+			struct file *file;
+		};
+		struct kvm *kvm;
+	};
 };
 
 #define CLA_CTX_KEY_PL0(_mm, _file)		\
 	{					\
+		.type = CLA_CTX_PL0,		\
 		.mm = (_mm),			\
 		.file = (_file),		\
 	}
@@ -180,6 +208,7 @@ struct cla_ctx_key {
  * Mutable, written by domain reassignment, device work, and CPU hotplug:
  * @regs:		State for each device in domain.
  * @asid:		Pinned ASID of live context.
+ * @guest_mmu:		Stage 2 translation configuration.
  */
 struct cla_ctx {
 	struct kref refcnt;
@@ -191,7 +220,10 @@ struct cla_ctx {
 	refcount_t users;
 	struct list_head queue_node;
 	void **regs;
-	unsigned int asid;
+	union {
+		unsigned int asid;
+		struct kvm_arch_guest_mmu *guest_mmu;
+	};
 	wait_queue_head_t waitq;
 };
 
@@ -268,6 +300,9 @@ static inline bool cla_ctx_is_dying(struct cla_ctx *ctx)
 	return refcount_read(&ctx->users) == 0;
 }
 
+#define cla_ctx_is_pl0(ctx) ((ctx)->key.type == CLA_CTX_PL0)
+#define cla_ctx_is_pl1(ctx) ((ctx)->key.type == CLA_CTX_PL1)
+
 void cla_dev_switch_ctx_work(struct kthread_work *work);
 int cla_dev_switch_ctx(struct cla_dev *dev, struct cla_ctx *prev_ctx,
 		       struct cla_ctx *next_ctx);
diff --git a/drivers/misc/arm-cla/cla-ctx.c b/drivers/misc/arm-cla/cla-ctx.c
index 6a9c95769724..0489bf7a103f 100644
--- a/drivers/misc/arm-cla/cla-ctx.c
+++ b/drivers/misc/arm-cla/cla-ctx.c
@@ -3,11 +3,42 @@
 #include <linux/err.h>
 #include <linux/file.h>
 #include <linux/gfp.h>
+#include <linux/kvm_host.h>
 #include <linux/sched/mm.h>
 #include <linux/slab.h>
 
 #include "arm-cla.h"
 
+#if IS_ENABLED(CONFIG_KVM)
+/*
+ * We must hold a reference to KVM at least as long as the PL1 context is
+ * assigned. We hold it until the ctx is freed.
+ */
+static inline bool cla_ctx_get_pl1(struct cla_ctx *ctx)
+{
+	return kvm_get_kvm_safe((ctx)->key.kvm);
+}
+
+static inline void cla_ctx_put_pl1(struct cla_ctx *ctx)
+{
+	kvm_put_kvm((ctx)->key.kvm);
+}
+#else
+/*
+ * If KVM isn't enabled, the driver doesn't provide a user interface to create a
+ * PL1 context, so these are never called.
+ */
+static inline bool cla_ctx_get_pl1(struct cla_ctx *ctx)
+{
+	return false;
+}
+
+static inline void cla_ctx_put_pl1(struct cla_ctx *ctx)
+{
+	WARN_ON(1);
+}
+#endif
+
 /**
  * cla_ctx_create - Create a context or increase its user count
  * @domain: CLA domain
@@ -48,8 +79,12 @@ struct cla_ctx *cla_ctx_create(struct cla_domain *domain,
 	INIT_LIST_HEAD(&ctx->queue_node);
 	init_waitqueue_head(&ctx->waitq);
 
-	mmgrab(key->mm);
-	get_file(key->file);
+	if (cla_ctx_is_pl0(ctx)) {
+		mmgrab(key->mm);
+		get_file(key->file);
+	} else {
+		WARN_ON(!cla_ctx_get_pl1(ctx));
+	}
 
 	/*
 	 * Test if the mm or kvm is compatible. If cla_mtc_get_ctx() fails
@@ -74,8 +109,12 @@ struct cla_ctx *cla_ctx_create(struct cla_domain *domain,
 err_free_regs:
 	cla_ctx_free_regs(domain, ctx);
 err_free:
-	mmdrop(key->mm);
-	fput(key->file);
+	if (cla_ctx_is_pl0(ctx)) {
+		mmdrop(key->mm);
+		fput(key->file);
+	} else {
+		cla_ctx_put_pl1(ctx);
+	}
 	kfree(ctx);
 err_unlock:
 	mutex_unlock(&domain->lock);
@@ -139,8 +178,12 @@ void cla_ctx_free(struct kref *ref)
 	struct cla_ctx *ctx = container_of(ref, struct cla_ctx, refcnt);
 
 	WARN_ON(!cla_ctx_is_dying(ctx));
-	mmdrop(ctx->key.mm);
-	fput(ctx->key.file);
+	if (cla_ctx_is_pl0(ctx)) {
+		mmdrop(ctx->key.mm);
+		fput(ctx->key.file);
+	} else {
+		cla_ctx_put_pl1(ctx);
+	}
 	cla_ctx_free_regs(ctx->domain, ctx);
 	kfree(ctx);
 }
diff --git a/drivers/misc/arm-cla/cla-mtc.c b/drivers/misc/arm-cla/cla-mtc.c
index 9ab25085dfdf..fc2cacb09c4a 100644
--- a/drivers/misc/arm-cla/cla-mtc.c
+++ b/drivers/misc/arm-cla/cla-mtc.c
@@ -7,12 +7,64 @@
 
 #include <asm/kvm_arm.h>
 #include <linux/mmu_context.h>
+#include <linux/kvm_host.h>
 
 #include "arm-cla.h"
 
 #define cla_kernel_mtc \
 	(cla_kernel_pl == 2 ? CLA_MTC_REGIDX_PL2 : CLA_MTC_REGIDX_PL1)
 
+/**
+ * struct cla_mtc_s2 - Stage 2 MTC configuration for the host or a VM.
+ * @hcr: HCR_EL2 register value.
+ * @vttbr: VTTBR_EL2 register value.
+ * @vtcr: VTCR_EL2 register value.
+ */
+struct cla_mtc_s2 {
+	u64 hcr;
+	u64 vttbr;
+	u64 vtcr;
+};
+
+#if IS_ENABLED(CONFIG_KVM)
+static void cla_mtc_prep_s2(struct cla_mtc_s2 *s2, struct cla_ctx *ctx)
+{
+	/* See comment in cla_mtc_setup() about MTC register definitions. */
+	s2->hcr = ctx->guest_mmu->hcr;
+	s2->vtcr = ctx->guest_mmu->vtcr;
+	s2->vttbr = ctx->guest_mmu->vttbr;
+}
+
+static int cla_mtc_get_s2_ctx(struct cla_ctx *ctx)
+{
+	struct kvm_arch_guest_mmu *mmu = kvm_arch_get_guest_mmu(ctx->key.kvm);
+
+	if (IS_ERR(mmu))
+		return PTR_ERR(mmu);
+	ctx->guest_mmu = mmu;
+
+	return 0;
+}
+
+static void cla_mtc_put_s2_ctx(struct cla_ctx *ctx)
+{
+	kvm_arch_put_guest_mmu(ctx->key.kvm, ctx->guest_mmu);
+}
+
+static void cla_mtc_leak_s2_ctx(struct cla_ctx *ctx)
+{
+	kvm_get_kvm(ctx->key.kvm);
+}
+#else
+static void cla_mtc_prep_s2(struct cla_mtc_s2 *s2, struct cla_ctx *ctx) {}
+static int cla_mtc_get_s2_ctx(struct cla_ctx *ctx)
+{
+	return -EOPNOTSUPP;
+}
+static void cla_mtc_put_s2_ctx(struct cla_ctx *ctx) {}
+static void cla_mtc_leak_s2_ctx(struct cla_ctx *ctx) {}
+#endif
+
 /**
  * cla_mtc_setup - initialize the memory translation context
  * @dev: CLA device
@@ -85,22 +137,21 @@ int cla_mtc_setup(struct cla_dev *dev)
 	return 0;
 }
 
-/**
- * cla_mtc_clear - clear the memory translation context
- * @dev: CLA device
- *
- * Return: 0 on success, or a negative error code.
- */
-int cla_mtc_clear(struct cla_dev *dev)
+static int __cla_mtc_clear(struct cla_dev *dev, bool include_s2)
 {
 	/* Don't set the RES1 bit in VTCR_EL2 because in MTC they are RAZ/WI. */
 	u64 regs[2 * CLA_MTC_PL_SIZE] = {};
-	size_t regs_size = cla_kernel_pl * CLA_MTC_PL_SIZE;
+	size_t regs_size;
 
 	/* SETCTX fails if there is no ACCID */
 	if (!dev->accelerators)
 		return 0;
 
+	if (include_s2)
+		regs_size = cla_kernel_pl * CLA_MTC_PL_SIZE;
+	else
+		regs_size = CLA_MTC_PL_SIZE;
+
 	/*
 	 * All accelerators are idle, meaning there can't be any memory
 	 * transactions happening. So it is safe to clear the MTC in any order.
@@ -109,6 +160,23 @@ int cla_mtc_clear(struct cla_dev *dev)
 	return cla_op_setctx(dev, CLA_MTC_REGIDX_PL1, regs_size, regs);
 }
 
+/**
+ * cla_mtc_clear - clear the whole memory translation context
+ * @dev: CLA device
+ *
+ * Return: 0 on success, or a negative error code.
+ */
+int cla_mtc_clear(struct cla_dev *dev)
+{
+	return __cla_mtc_clear(dev, true);
+}
+
+/* Clear the EL1&0 stage 1 MTC config */
+static int cla_mtc_clear_s1(struct cla_dev *dev)
+{
+	return __cla_mtc_clear(dev, false);
+}
+
 static int cla_mtc_install_s1(struct cla_dev *dev, struct cla_ctx *ctx)
 {
 	u64 ttbr0;
@@ -137,6 +205,49 @@ static int cla_mtc_uninstall_s1(struct cla_dev *dev)
 	return cla_op_setctx(dev, cla_kernel_mtc + CLA_MTC_TTBR0, 1, &ttbr0);
 }
 
+static int cla_mtc_install_s2(struct cla_dev *dev, struct cla_ctx *ctx)
+{
+	struct cla_mtc_s2 s2 = {};
+	const size_t num_regs = sizeof(s2) / sizeof(u64);
+
+	if (WARN_ON(cla_kernel_pl != 2))
+		return -EINVAL;
+
+	/* GETCTX/SETCTX fail if there is no ACCID */
+	if (!dev->accelerators)
+		return 0;
+
+	cla_mtc_prep_s2(&s2, ctx);
+
+	return cla_op_setctx(dev, CLA_MTC_HCR_EL2, num_regs, (u64 *)&s2);
+}
+
+static int cla_mtc_uninstall_s2(struct cla_dev *dev)
+{
+	struct cla_mtc_s2 s2 = {
+		.hcr = HCR_HOST_VHE_FLAGS,
+	};
+	const size_t num_regs = sizeof(s2) / sizeof(u64);
+	int ret;
+
+	if (WARN_ON(cla_kernel_pl != 2))
+		return -EINVAL;
+
+	/* GETCTX/SETCTX fail if there is no ACCID */
+	if (!dev->accelerators)
+		return 0;
+
+	/*
+	 * The accelerators are idle and there is no pending memory transaction,
+	 * so we can change the MTC config in any order.
+	 */
+	ret = cla_mtc_clear_s1(dev);
+	if (ret)
+		return ret;
+
+	return cla_op_setctx(dev, CLA_MTC_HCR_EL2, num_regs, (u64 *)&s2);
+}
+
 /**
  * cla_mtc_install - enable a translation context
  * @dev: CLA device
@@ -146,7 +257,8 @@ static int cla_mtc_uninstall_s1(struct cla_dev *dev)
  */
 int cla_mtc_install(struct cla_dev *dev, struct cla_ctx *ctx)
 {
-	return cla_mtc_install_s1(dev, ctx);
+	return cla_ctx_is_pl0(ctx) ?
+		cla_mtc_install_s1(dev, ctx) : cla_mtc_install_s2(dev, ctx);
 }
 
 /**
@@ -158,7 +270,8 @@ int cla_mtc_install(struct cla_dev *dev, struct cla_ctx *ctx)
  */
 int cla_mtc_uninstall(struct cla_dev *dev, struct cla_ctx *ctx)
 {
-	return cla_mtc_uninstall_s1(dev);
+	return cla_ctx_is_pl0(ctx) ?
+		cla_mtc_uninstall_s1(dev) : cla_mtc_uninstall_s2(dev);
 }
 
 /**
@@ -166,15 +279,23 @@ int cla_mtc_uninstall(struct cla_dev *dev, struct cla_ctx *ctx)
  * @ctx: context to get
  *
  * Grab the information needed for installing this context.
- * For stage 1 MTC, pin the ASID.
+ * For stage 1 MTC, pin the ASID. For stage 2 MTC, pin the VMID and get the
+ * translation configuration registers.
  *
  * Return: 0 on success, or a negative error code.
  */
 int cla_mtc_get_ctx(struct cla_ctx *ctx)
 {
-	ctx->asid = arm64_mm_context_get(ctx->key.mm);
-	if (ctx->asid == 0)
-		return -ENOSPC;
+	if (cla_ctx_is_pl0(ctx)) {
+		ctx->asid = arm64_mm_context_get(ctx->key.mm);
+		if (ctx->asid == 0)
+			return -ENOSPC;
+	} else {
+		int ret = cla_mtc_get_s2_ctx(ctx);
+
+		if (ret)
+			return ret;
+	}
 
 	return 0;
 }
@@ -187,7 +308,10 @@ int cla_mtc_get_ctx(struct cla_ctx *ctx)
  */
 void cla_mtc_put_ctx(struct cla_ctx *ctx)
 {
-	arm64_mm_context_put(ctx->key.mm);
+	if (cla_ctx_is_pl0(ctx))
+		arm64_mm_context_put(ctx->key.mm);
+	else
+		cla_mtc_put_s2_ctx(ctx);
 }
 
 /**
@@ -201,6 +325,11 @@ void cla_mtc_put_ctx(struct cla_ctx *ctx)
  */
 void cla_mtc_leak_ctx(struct cla_ctx *ctx)
 {
-	WARN(1, "leaking PL0 context\n");
-	mmgrab(ctx->key.mm);
+	if (cla_ctx_is_pl0(ctx)) {
+		WARN(1, "leaking PL0 context\n");
+		mmgrab(ctx->key.mm);
+	} else {
+		WARN(1, "leaking PL1 context\n");
+		cla_mtc_leak_s2_ctx(ctx);
+	}
 }
diff --git a/drivers/misc/arm-cla/cla-regs.c b/drivers/misc/arm-cla/cla-regs.c
index d48311d0ef92..5be5d1d4f4e4 100644
--- a/drivers/misc/arm-cla/cla-regs.c
+++ b/drivers/misc/arm-cla/cla-regs.c
@@ -205,6 +205,55 @@ static int cla_regs_install_pl0(struct cla_dev *dev, struct cla_ctx *ctx,
 	return 0;
 }
 
+static int cla_regs_uninstall_pl1(struct cla_dev *dev, struct cla_ctx *ctx,
+				  unsigned int ctx_id)
+{
+	int ret;
+	u64 lresp;
+	struct cla_regs_pl1 *regs = ctx->regs[ctx_id];
+
+	/* VM may have been killed while it was launching ops */
+	ret = cla_op_wait_lresp(dev, &lresp);
+	if (ret)
+		return ret;
+
+	/*
+	 * TODO: PL1 context save/restore is not supported. Reset the VM state
+	 * even when the context remains live across CPU hotplug or a VFIO
+	 * reset.
+	 */
+	ret = cla_op_reset_all(dev);
+	if (ret)
+		return ret;
+
+	/* Restore kernel PL0CTRL */
+	cla_reg_write(dev, CLA_REG_PL0CTRL, regs->pl0ctrl);
+
+	return 0;
+}
+
+static int cla_regs_install_pl1(struct cla_dev *dev, struct cla_ctx *ctx,
+				unsigned int ctx_id)
+{
+	int i;
+	unsigned int accid;
+	struct cla_regs_pl1 *regs = ctx->regs[ctx_id];
+
+	/* Save PL0CTRL and initialize it as all-enabled */
+	regs->pl0ctrl = cla_reg_read(dev, CLA_REG_PL0CTRL);
+	cla_reg_write(dev, CLA_REG_PL0CTRL, CLA_PLxCTRL_MASK);
+
+	/* Clear EVENT by reading STATUS, to provide a pristine context */
+	cla_for_each_accid(dev, accid)
+		cla_reg_read(dev, CLA_REG_STATUS(accid));
+
+	for (i = 0; i < CLA_NUM_DATA_REGS; i++)
+		cla_reg_write(dev, CLA_REG_DATA(i), 0);
+	cla_reg_write(dev, CLA_REG_LRESP, 0);
+
+	return 0;
+}
+
 /**
  * cla_regs_install - Install and/or restore CLA context
  * @dev: CLA device
@@ -215,6 +264,7 @@ static int cla_regs_install_pl0(struct cla_dev *dev, struct cla_ctx *ctx,
  *
  * PL0 context: Restore the DATA and LRESP registers, and accelerator state if
  * one has been saved.
+ * PL1 context: Save host kernel registers. Reset all PL1 and PL0 state.
  *
  * This function is called with all accelerators idle and no trace of previous
  * work.
@@ -224,7 +274,9 @@ static int cla_regs_install_pl0(struct cla_dev *dev, struct cla_ctx *ctx,
 int cla_regs_install(struct cla_dev *dev, struct cla_ctx *ctx,
 		     unsigned int ctx_id)
 {
-	return cla_regs_install_pl0(dev, ctx, ctx_id);
+	return cla_ctx_is_pl0(ctx) ?
+		cla_regs_install_pl0(dev, ctx, ctx_id) :
+		cla_regs_install_pl1(dev, ctx, ctx_id);
 }
 
 /**
@@ -237,6 +289,7 @@ int cla_regs_install(struct cla_dev *dev, struct cla_ctx *ctx,
  *
  * PL0 context: Save the DATA registers and accelerator state unless
  * cla_ctx_is_dying() is true, since a dying context will not be restored.
+ * PL1 context: Restore host kernel registers.
  *
  * When this completes, all accelerators are idle. If this fails, some
  * accelerators may still be running.
@@ -246,7 +299,9 @@ int cla_regs_install(struct cla_dev *dev, struct cla_ctx *ctx,
 int cla_regs_uninstall(struct cla_dev *dev, struct cla_ctx *ctx,
 		       unsigned int ctx_id)
 {
-	return cla_regs_uninstall_pl0(dev, ctx, ctx_id);
+	return cla_ctx_is_pl0(ctx) ?
+		cla_regs_uninstall_pl0(dev, ctx, ctx_id) :
+		cla_regs_uninstall_pl1(dev, ctx, ctx_id);
 }
 
 /**
@@ -279,7 +334,9 @@ int cla_ctx_alloc_regs(struct cla_domain *domain, struct cla_ctx *ctx)
 		 * The regs structures are only ever accessed from the CLA
 		 * device's CPU, so try to allocate them on the right NUMA node
 		 */
-		size = struct_size_t(struct cla_regs_pl0, regstate, nr_regstate);
+		size = cla_ctx_is_pl0(ctx) ?
+			struct_size_t(struct cla_regs_pl0, regstate, nr_regstate) :
+			sizeof(struct cla_regs_pl1);
 		regs = kvzalloc_node(size, GFP_KERNEL_ACCOUNT,
 				     cpu_to_node(dev->cpu));
 		if (!regs)
diff --git a/drivers/misc/arm-cla/cla-sched.c b/drivers/misc/arm-cla/cla-sched.c
index 6b5b782ac33e..dc0584d681af 100644
--- a/drivers/misc/arm-cla/cla-sched.c
+++ b/drivers/misc/arm-cla/cla-sched.c
@@ -196,9 +196,10 @@ static void cla_domain_zap(struct cla_domain *domain, struct cla_ctx *ctx)
 
 	/*
 	 * If the context is dying it has already been unmapped, no need to zap
-	 * it here.
+	 * it here. PL1 contexts are not bound to a specific mm, but since
+	 * deassigning them requires unmapping them first, they must be dying.
 	 */
-	if (!ctx || cla_ctx_is_dying(ctx))
+	if (!ctx || cla_ctx_is_dying(ctx) || WARN_ON(!cla_ctx_is_pl0(ctx)))
 		return;
 
 	if (!mmget_not_zero(ctx->key.mm))
-- 
2.43.0

