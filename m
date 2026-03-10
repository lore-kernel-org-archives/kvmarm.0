Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com [209.85.221.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E0743A542B
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 12:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773146991; cv=none; b=gt8bjb4IynsbSCcy9dKodLNwrLvYkZJXeZYX5f1T6075b/c4pYMfqON8b0jV+cdKGkcoJK3gb/WiLCl0EabGC4WLbUq+lJeaJtvctlNJ++IZ7S0sU1ZxvNzcvcG4qn0ASdPTJBUd+sni0vAtzSy7G/oG20iol6xTn6qJWZ7oQys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773146991; c=relaxed/simple;
	bh=FR2M+E90Y1v5dC4HO5pEPtueuObDehuxAUbp0SHmBiQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=AF6/qgJVz6DqGevwdOuOjSLtKK45lC/1A9a9eqLS4klCkqAwvlyA0tzdZP9sQsiUVOro2mDC9kcdcgnrgPemc6xJ5OxPOOuQ5EqqYWR484LD9FyAcB7BaATkehO46GwWZpCE1H5wKXwoPCNavue8bTjLXf9tx77s1efy5I+7LFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B+LzAZ7i; arc=none smtp.client-ip=209.85.221.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B+LzAZ7i"
Received: by mail-wr1-f73.google.com with SMTP id ffacd0b85a97d-439ca4b3d0bso5189231f8f.3
        for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 05:49:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773146988; x=1773751788; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=IBw8//o/FKk+iSUCDuIRcFnfCH+1hN6m93POT/Oa1kE=;
        b=B+LzAZ7ipsjlcah73XZuDi8OWF/YdAPzl53ODx5W0l0mraAlt6JjAIRuq3zucQqOSh
         rUNx721xp3Qs/xkU2jA9X5Qx9OsBh6zj4MlzRVeyeZix1/38sFCsp8yAj+otSYA63g3d
         mEtKDWjIWJb0YHbM0c3issVWII1CaFXsvbnpz56CZJ7K8FT4JeQ3ep8wo9HSI38VnuFY
         rcDYtCYN9CgxSVsODB6s2ejzRkAg4Fi6am5S/HjXChzJmKMdi/qZVsYNxU8xERUv8VXW
         dep0N9+sGmkPhxvWy2eSOZIyVEZQcSsG6yF7VGpb3G1oj/FtfjwDqO61yHzNilCE415T
         hYQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773146988; x=1773751788;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IBw8//o/FKk+iSUCDuIRcFnfCH+1hN6m93POT/Oa1kE=;
        b=YjelSDYt+GG0bMjsXfm05gp2eM++pIAkzwbkUKqelG+20AV95Ox34Gzpno+YX7ngos
         RRpUuw6AadcYrLrM0kV36Pe2xhebW845ewaw2XlJ8CWMj6FHZYFRIvWeJ9i15nsMFaKu
         snCAYjUJWTISlZyFfQrNVL2cSCwCj0IgM/mJiMnDWtwCztyJ4XgTIi/YNMr2/0It07IU
         ZTq1ARzo2PZDFlHruBVIqfsLBwdJNa6QM7NlEDXBbCxXWliDgvdMjSSCrbgHnwjW+U5u
         jokyaSKt/vC6xJsoicCo8CXZVvTLiaJ28+uvoMDuvfHOvaV71fosmDZ5vCNTKt9sfS0g
         APag==
X-Forwarded-Encrypted: i=1; AJvYcCUWWeyRPXnOh4q+fTnQyAu2iR8oi32Q7miljsyqByAYXliVKIp4hTrXtfdKWUR9u925f2dwrLc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwT0gHxSIE/1udUxTUKB9FyrcQciMkApibGhNDq4ob0a6dteh+/
	hTjSXFQQGzCqEggQue756WRQJDtCMltJWbO3hXFY0FtG/1aEj5Hz4QX7upH25EwnlNT6aIKTq27
	ZbesKyyI14Wk5Offoiluwm687vO1NAQ==
X-Received: from wmoo8-n1.prod.google.com ([2002:a05:600d:108:10b0:485:4553:1a97])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e4f:b0:485:3f72:323f with SMTP id 5b1f17b1804b1-4853f7233b2mr80282675e9.11.1773146987881;
 Tue, 10 Mar 2026 05:49:47 -0700 (PDT)
Date: Tue, 10 Mar 2026 12:49:24 +0000
In-Reply-To: <20260310124933.830025-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260310124933.830025-6-sebastianene@google.com>
Subject: [PATCH 05/14] irqchip/gic-v3-its: Prepare shadow structures for KVM
 host deprivilege
From: Sebastian Ene <sebastianene@google.com>
To: alexandru.elisei@arm.com, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	android-kvm@google.com
Cc: catalin.marinas@arm.com, dbrazdil@google.com, joey.gouly@arm.com, 
	kees@kernel.org, mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, 
	perlarsen@google.com, qperret@google.com, rananta@google.com, 
	sebastianene@google.com, smostafa@google.com, suzuki.poulose@arm.com, 
	tabba@google.com, tglx@kernel.org, vdonnefort@google.com, bgrzesik@google.com, 
	will@kernel.org, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

Expose two helper functions to support emulated ITS in the hypervisor.
These allow the KVM layer to notify the driver when hypervisor
initialization is complete.
The caller is expected to use the functions as follows:
1. its_start_deprivilege(): Acquire the ITS locks.
2. on_each_cpu(_kvm_host_prot_finalize, ...): Finalizes pKVM init
3. its_end_deprivilege(): Shadow the ITS structures, invoke the KVM
   callback, and release locks.
Specifically, this shadows the ITS command queue and the 1st level
indirect tables. These shadow buffers will be used by the driver after
host deprivilege, while the hypervisor unmaps and takes ownership of the
original structures.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 drivers/irqchip/irq-gic-v3-its.c   | 165 +++++++++++++++++++++++++++--
 include/linux/irqchip/arm-gic-v3.h |  24 +++++
 2 files changed, 178 insertions(+), 11 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 291d7668cc8d..278dbc56f962 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -78,17 +78,6 @@ struct its_collection {
 	u16			col_id;
 };
 
-/*
- * The ITS_BASER structure - contains memory information, cached
- * value of BASER register configuration and ITS page size.
- */
-struct its_baser {
-	void		*base;
-	u64		val;
-	u32		order;
-	u32		psz;
-};
-
 struct its_device;
 
 /*
@@ -5232,6 +5221,160 @@ static int __init its_compute_its_list_map(struct its_node *its)
 	return its_number;
 }
 
+static void its_free_shadow_tables(struct its_shadow_tables *shadow)
+{
+	int i;
+
+	if (shadow->cmd_shadow)
+		its_free_pages(shadow->cmd_shadow, get_order(ITS_CMD_QUEUE_SZ));
+
+	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
+		if (!shadow->tables[i].shadow)
+			continue;
+
+		its_free_pages(shadow->tables[i].shadow, 0);
+	}
+
+	its_free_pages(shadow, 0);
+}
+
+static struct its_shadow_tables *its_get_shadow_tables(struct its_node *its)
+{
+	void *page;
+	struct its_shadow_tables *shadow;
+	int i;
+
+	page = its_alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO, 0);
+	if (!page)
+		return NULL;
+
+	shadow = (void *)page_address(page);
+	page = its_alloc_pages_node(its->numa_node,
+				    GFP_KERNEL | __GFP_ZERO,
+				    get_order(ITS_CMD_QUEUE_SZ));
+	if (!page)
+		goto err_alloc_shadow;
+
+	shadow->cmd_shadow = page_address(page);
+	shadow->cmdq_len = ITS_CMD_QUEUE_SZ;
+	shadow->cmd_original = its->cmd_base;
+
+	memcpy(shadow->tables, its->tables, sizeof(struct its_baser) * GITS_BASER_NR_REGS);
+
+	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
+		if (!(shadow->tables[i].val & GITS_BASER_VALID))
+			continue;
+
+		if (!(shadow->tables[i].val & GITS_BASER_INDIRECT))
+			continue;
+
+		page = its_alloc_pages_node(its->numa_node,
+					    GFP_KERNEL | __GFP_ZERO,
+					    shadow->tables[i].order);
+		if (!page)
+			goto err_alloc_shadow;
+
+		shadow->tables[i].shadow = page_address(page);
+
+		memcpy(shadow->tables[i].shadow, shadow->tables[i].base,
+		       PAGE_ORDER_TO_SIZE(shadow->tables[i].order));
+	}
+
+	return shadow;
+
+err_alloc_shadow:
+	its_free_shadow_tables(shadow);
+	return NULL;
+}
+
+void *its_start_depriviledge(void)
+{
+	struct its_node *its;
+	int num_nodes = 0, i = 0;
+	unsigned long *flags;
+
+	raw_spin_lock(&its_lock);
+	list_for_each_entry(its, &its_nodes, entry) {
+		num_nodes++;
+	}
+
+	flags = kzalloc(num_nodes * sizeof(unsigned long), GFP_KERNEL_ACCOUNT);
+	if (!flags) {
+		raw_spin_unlock(&its_lock);
+		return NULL;
+	}
+
+	list_for_each_entry(its, &its_nodes, entry) {
+		raw_spin_lock_irqsave(&its->lock, flags[i++]);
+	}
+
+	return flags;
+}
+EXPORT_SYMBOL_GPL(its_start_depriviledge);
+
+static int its_switch_to_shadow_locked(struct its_node *its, its_init_emulate init_emulate_cb)
+{
+	struct its_shadow_tables *hyp_shadow, shadow;
+	int i, ret;
+	u64 baser, baser_phys;
+
+	hyp_shadow = its_get_shadow_tables(its);
+	if (!hyp_shadow)
+		return -ENOMEM;
+
+	memcpy(&shadow, hyp_shadow, sizeof(shadow));
+	ret = init_emulate_cb(its->phys_base, hyp_shadow);
+	if (ret) {
+		its_free_shadow_tables(hyp_shadow);
+		return ret;
+	}
+
+	/* Switch the driver command queue to use the shadow and save the original */
+	its->cmd_write = (its->cmd_write - its->cmd_base) +
+		(struct its_cmd_block *)shadow.cmd_shadow;
+	its->cmd_base = shadow.cmd_shadow;
+
+	/* Shadow the first level of the indirect tables */
+	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
+		baser = shadow.tables[i].val;
+
+		if (!shadow.tables[i].shadow)
+			continue;
+
+		baser_phys = virt_to_phys(shadow.tables[i].shadow);
+		if (IS_ENABLED(CONFIG_ARM64_64K_PAGES) && (baser_phys >> 48))
+			baser_phys = GITS_BASER_PHYS_52_to_48(baser_phys);
+
+		its->tables[i].val &= ~GENMASK(47, 12);
+		its->tables[i].val |= baser_phys;
+		its->tables[i].base = shadow.tables[i].shadow;
+	}
+
+	return 0;
+}
+
+int its_end_depriviledge(int ret_pkvm_finalize, unsigned long *flags, its_init_emulate cb)
+{
+	struct its_node *its;
+	int i = 0, ret = 0;
+
+	if (!flags || !cb)
+		return -EINVAL;
+
+	list_for_each_entry(its, &its_nodes, entry) {
+		if (!ret_pkvm_finalize && !ret)
+			ret = its_switch_to_shadow_locked(its, cb);
+
+		raw_spin_unlock_irqrestore(&its->lock, flags[i++]);
+	}
+
+	kfree(flags);
+	raw_spin_unlock(&its_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(its_end_depriviledge);
+
 static int __init its_probe_one(struct its_node *its)
 {
 	u64 baser, tmp;
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 0225121f3013..40457a4375d4 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -657,6 +657,30 @@ static inline bool gic_enable_sre(void)
 	return !!(val & ICC_SRE_EL1_SRE);
 }
 
+/*
+ * The ITS_BASER structure - contains memory information, cached
+ * value of BASER register configuration and ITS page size.
+ */
+struct its_baser {
+	void		*base;
+	void		*shadow;
+	u64		val;
+	u32		order;
+	u32		psz;
+};
+
+struct its_shadow_tables {
+	struct its_baser	tables[GITS_BASER_NR_REGS];
+	void			*cmd_shadow;
+	void			*cmd_original;
+	size_t			cmdq_len;
+};
+
+typedef int (*its_init_emulate)(phys_addr_t its_phys_base, struct its_shadow_tables *shadow);
+
+void *its_start_depriviledge(void);
+int its_end_depriviledge(int ret, unsigned long *flags, its_init_emulate cb);
+
 #endif
 
 #endif
-- 
2.53.0.473.g4a7958ca14-goog

