Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43AEC3BD22C
	for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 12:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773146996; cv=none; b=qLXeyhoDPYL01RqWKqKfNIx7XP67YwMmI4CX2JsvoOQjim6qSz0dZ42G90ypZ2UiftwYWfaGk+5e8HGR6MakA+Fbm3ijttw1ORoC8pY0P5NsiBePIYTd45xvRz1eyAQOlcRlz0oIIPxvtPiLaB3LE+Awr6UhrcKQTI4H3+X/wJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773146996; c=relaxed/simple;
	bh=4hJY1N4A2wDueWDi3/QPvsP5ocJDuxsbkmdbVMi1coQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=iZWngbjF9bo0457rP6TCJZVejdYaHZoatyDV8PmFqfd4Pg3Ig5ZnYux+V+AjCU5oHlcz/DJYoWkGhSdB24H/5ljFOuJ67p+TJ80XlrQGPPGULLT9xWlw0Nwh2qsO4nrQ7mRU2VZwqd8f/EsYCmE5lTttoRJWcqwzbaKjavp6bAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OfPI2Ic7; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OfPI2Ic7"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-485355493aeso12553525e9.1
        for <kvmarm@lists.linux.dev>; Tue, 10 Mar 2026 05:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773146992; x=1773751792; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5FSgXLogofjILU2kyW220LfxF0CifNUwYoLSBdGFOwA=;
        b=OfPI2Ic7aFP8y6QWAhV/7JJs67BGRyNoynpCbb9DYjKHHMACWTSwoejzGrqiIYC2Jq
         PcEZibghuasAQbjdDc9kaY/I0TQW5ozT4CZJub+ZIRMAUkEY5l07bEzsXqcBlE9Agb87
         2Kcu0hWRGWLCQ+XoQ8z43X8wRgMJHwvumvSDVcxHwD3/+2mbUg+jr+eWB/Rffc7lJNym
         cuxePAzei+MUaNe8j2Q2PLC6+KMR6ZFPR1plRc6HpPDDXW6kQlb3YKuey52AlmFAomjh
         Ept3R+rYTLFuplFNprc3Jgk5kvpu5IBAvRi/pog1PaSTyOisgFCfVrUn0wo2IDUArXAg
         UZ7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773146992; x=1773751792;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5FSgXLogofjILU2kyW220LfxF0CifNUwYoLSBdGFOwA=;
        b=RVy8oojd27iXow0Ennofr2PLndUsgeEKGWtRG+0Abw+mXIgsD7ygX8+xCll6qX7kmw
         78qvHbhe2bdgvG3sKVdjY/QqmqpthSXn9aAlkfqIC7JuA1ROvKhSyow/3w4pdt2xS0G3
         uB6xo+aXhZe2lj4EdOa5Irycdvuqa/Yxl/2c0XlaQOyDTblYW6JZEhZXm5fHa6v32cs0
         dp7zOih2JsaaOF6LgnWNoEVmOf71CS5wOiTUmw+LhDAJ+R8xQsVy2h4LTQTFyxP4TTkP
         /B4jfsf7r/dKSATWTigelg2tIw8j6Fwl1M+oW6inXfW03UGYbeAXFpu5Nty1zLgVJ2oj
         yqKw==
X-Forwarded-Encrypted: i=1; AJvYcCU4+MYbj+pG0mn5ydn0lJjCJwr8I5jUB/k5u84reQYMoSFCNAR9ftEzQJIroMu7VQViDyjofcU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyy9ckH1HOsnW8P5T55LpjrJktp1EbO8xknjAFlO5JYcY4y1mZ1
	ibunAPTuroYjh0ZQ44X2ZfP63CGj7yX9iDMc8c9AJCCZIRUgAvPUMPgsNAXuSW7/Pxcr1H7HjLy
	Y9WYowAXqmUugw1nU/XIkVGw+eRj63A==
X-Received: from wmk23.prod.google.com ([2002:a05:600c:297:b0:485:3c21:d5f0])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4fc4:b0:485:40c6:f51a with SMTP id 5b1f17b1804b1-48540c6f65bmr68470135e9.31.1773146991570;
 Tue, 10 Mar 2026 05:49:51 -0700 (PDT)
Date: Tue, 10 Mar 2026 12:49:27 +0000
In-Reply-To: <20260310124933.830025-1-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260310124933.830025-1-sebastianene@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260310124933.830025-9-sebastianene@google.com>
Subject: [PATCH 08/14] KVM: arm64: Trap & emulate the ITS MAPD command
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

Parse the MAPD command and extract the ITT address to
sanitize it. When the command has the valid bit set,
share the memory that holds the ITT table
with the hypervisor to prevent it from being used
by someone else and track the pages in an array.
When the valid bit is cleared, check if the pages
are tracked and then remove the sharing with the
hypervisor.
Check if we need to do any shadow table updates
in case the device table is configured with an
indirect layout.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/its_emulate.c | 182 ++++++++++++++++++++++++++
 drivers/irqchip/irq-gic-v3-its.c      |  12 --
 include/linux/irqchip/arm-gic-v3.h    |  12 ++
 3 files changed, 194 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
index 865a5d6353ed..722fe80dc2e5 100644
--- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -12,8 +12,13 @@ struct its_priv_state {
 	void *cmd_host_cwriter;
 	struct its_shadow_tables *shadow;
 	hyp_spinlock_t its_lock;
+	u16 empty_idx;
+	u64 tracked_pfns[];
 };
 
+#define MAX_TRACKED_PFNS	((PAGE_SIZE - offsetof(struct its_priv_state, \
+				  tracked_pfns)) / sizeof(u64))
+
 struct its_handler {
 	u64 offset;
 	u8 access_size;
@@ -23,6 +28,178 @@ struct its_handler {
 
 DEFINE_HYP_SPINLOCK(its_setup_lock);
 
+static int track_pfn_add(struct its_priv_state *its, u64 pfn)
+{
+	int ret, i;
+
+	if (its->empty_idx + 1 >= MAX_TRACKED_PFNS)
+		return -ENOSPC;
+
+	ret = __pkvm_host_share_hyp(pfn);
+	if (ret)
+		return ret;
+
+	its->tracked_pfns[its->empty_idx] = pfn;
+	for (i = 0; i < MAX_TRACKED_PFNS; i++) {
+		if (!its->tracked_pfns[i])
+			break;
+	}
+
+	its->empty_idx = i;
+	return 0;
+}
+
+static int track_pfn_remove(struct its_priv_state *its, u64 pfn)
+{
+	int i, ret;
+
+	for (i = 0; i < MAX_TRACKED_PFNS; i++) {
+		if (its->tracked_pfns[i] != pfn)
+			continue;
+
+		ret = __pkvm_host_unshare_hyp(pfn);
+		if (ret)
+			return ret;
+
+		its->tracked_pfns[i] = 0;
+		its->empty_idx = i;
+	}
+
+	return 0;
+}
+
+static int get_num_itt_pages(struct its_priv_state *its, u8 num_bits)
+{
+	int nr_ites = 1 << (num_bits + 1);
+	u64 size, gits_typer = readq_relaxed(its->base + GITS_TYPER);
+
+	size = nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, gits_typer) + 1);
+	size = max(size, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
+
+	return PAGE_ALIGN(size) >> PAGE_SHIFT;
+}
+
+static int track_pfn(struct its_priv_state *its, u64 start_pfn, int num_pages, bool remove)
+{
+	int i, ret;
+
+	for (i = 0; i < num_pages; i++) {
+		if (remove)
+			ret = track_pfn_remove(its, start_pfn + i);
+		else
+			ret = track_pfn_add(its, start_pfn + i);
+
+		if (ret)
+			goto err_track;
+	}
+
+	return 0;
+err_track:
+	for (i = i - 1; i >= 0; i--) {
+		if (remove)
+			track_pfn_add(its, start_pfn + i);
+		else
+			track_pfn_remove(its, start_pfn + i);
+	}
+
+	return ret;
+}
+
+static struct its_baser *get_table(struct its_priv_state *its, u64 type)
+{
+	int i;
+	struct its_shadow_tables *shadow = its->shadow;
+
+	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
+		if (GITS_BASER_TYPE(shadow->tables[i].val) == type)
+			return &shadow->tables[i];
+	}
+
+	return NULL;
+}
+
+static int check_table_update(struct its_priv_state *its, u32 id, u64 type)
+{
+	u32 lvl1_idx;
+	u64 esz, *host_table, *hyp_table, new_entry, update;
+	struct its_baser *table = get_table(its, type);
+	int ret;
+	phys_addr_t new_lvl2_table, lvl2_table;
+
+	if (!table)
+		return -EINVAL;
+
+	if (!(table->val & GITS_BASER_INDIRECT))
+		return 0;
+
+	esz = GITS_BASER_ENTRY_SIZE(table->val);
+	lvl1_idx = id / (table->psz / esz);
+
+	host_table = kern_hyp_va(table->shadow);
+	hyp_table = kern_hyp_va(table->base);
+
+	new_entry = host_table[id];
+	update = new_entry ^ hyp_table[id];
+	if (!update || !(update & GITS_BASER_VALID))
+		return 0;
+
+	new_lvl2_table = hyp_phys_to_pfn(new_entry & PHYS_MASK_SHIFT);
+	lvl2_table = hyp_phys_to_pfn(hyp_table[id] & PHYS_MASK_SHIFT);
+	if (new_entry & GITS_BASER_VALID)
+		ret = __pkvm_host_donate_hyp(new_lvl2_table, table->psz >> PAGE_SHIFT);
+	else
+		ret = __pkvm_hyp_donate_host(lvl2_table, table->psz >> PAGE_SHIFT);
+	if (ret)
+		return ret;
+
+	hyp_table[id] = new_entry;
+	return 0;
+}
+
+static int process_its_mapd(struct its_priv_state *its, struct its_cmd_block *cmd)
+{
+	phys_addr_t itt_addr = cmd->raw_cmd[2] & GENMASK(51, 8);
+	u8 size = cmd->raw_cmd[1] & GENMASK(4, 0);
+	bool remove = !(cmd->raw_cmd[2] & BIT(63));
+	u32 device_id = cmd->raw_cmd[0] >> 32;
+	int num_pages, ret;
+	u64 base_pfn;
+
+	if (PAGE_ALIGNED(itt_addr))
+		return -EINVAL;
+
+	base_pfn = hyp_phys_to_pfn(itt_addr);
+	num_pages = get_num_itt_pages(its, size);
+
+	ret = check_table_update(its, device_id, GITS_BASER_TYPE_DEVICE);
+	if (ret)
+		return ret;
+
+	return track_pfn(its, base_pfn, num_pages, remove);
+}
+
+static int parse_its_cmdq(struct its_priv_state *its, int offset, ssize_t len)
+{
+	struct its_cmd_block *cmd = its->cmd_hyp_base + offset;
+	u8 req_type;
+	int ret = 0;
+
+	while (len > 0 && !ret) {
+		req_type = cmd->raw_cmd[0] & GENMASK(7, 0);
+
+		switch (req_type) {
+		case GITS_CMD_MAPD:
+			ret = process_its_mapd(its, cmd);
+			break;
+		}
+
+		cmd++;
+		len -= sizeof(struct its_cmd_block);
+	}
+
+	return ret;
+}
+
 static void cwriter_write(struct its_priv_state *its, u64 offset, u64 value)
 {
 	u64 cwriter_offset = value & GENMASK(19, 5);
@@ -41,11 +218,15 @@ static void cwriter_write(struct its_priv_state *its, u64 offset, u64 value)
 		return;
 
 	memcpy(its->cmd_hyp_base + cmd_offset, its->cmd_host_cwriter, cmd_len);
+	if (parse_its_cmdq(its, cmd_offset, cmd_len))
+		return;
 
 	its->cmd_host_cwriter = its->cmd_host_base +
 		(cmd_offset + cmd_len) % cmdq_sz;
 	if (its->cmd_host_cwriter == its->cmd_host_base) {
 		memcpy(its->cmd_hyp_base, its->cmd_host_base, cwriter_offset);
+		if (parse_its_cmdq(its, cmd_offset, cmd_len))
+			return;
 
 		its->cmd_host_cwriter = its->cmd_host_base + cwriter_offset;
 	}
@@ -357,6 +538,7 @@ int pkvm_init_gic_its_emulation(phys_addr_t dev_addr, void *host_priv_state,
 	priv_state->cmd_hyp_base = kern_hyp_va(shadow->cmd_original);
 	priv_state->cmd_host_base = kern_hyp_va(shadow->cmd_shadow);
 	priv_state->cmd_host_cwriter = priv_state->cmd_host_base;
+	priv_state->empty_idx = 0;
 
 	hyp_spin_unlock(&its_setup_lock);
 
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 278dbc56f962..be78f7dccb9f 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -121,8 +121,6 @@ static DEFINE_PER_CPU(struct its_node *, local_4_1_its);
 #define is_v4_1(its)		(!!((its)->typer & GITS_TYPER_VMAPP))
 #define device_ids(its)		(FIELD_GET(GITS_TYPER_DEVBITS, (its)->typer) + 1)
 
-#define ITS_ITT_ALIGN		SZ_256
-
 /* The maximum number of VPEID bits supported by VLPI commands */
 #define ITS_MAX_VPEID_BITS						\
 	({								\
@@ -515,16 +513,6 @@ struct its_cmd_desc {
 	};
 };
 
-/*
- * The ITS command block, which is what the ITS actually parses.
- */
-struct its_cmd_block {
-	union {
-		u64	raw_cmd[4];
-		__le64	raw_cmd_le[4];
-	};
-};
-
 #define ITS_CMD_QUEUE_SZ		SZ_64K
 #define ITS_CMD_QUEUE_NR_ENTRIES	(ITS_CMD_QUEUE_SZ / sizeof(struct its_cmd_block))
 
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 40457a4375d4..4f7d47f3d970 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -612,6 +612,8 @@
  */
 #define GIC_IRQ_TYPE_LPI		0xa110c8ed
 
+#define ITS_ITT_ALIGN			SZ_256
+
 struct rdists {
 	struct {
 		raw_spinlock_t	rd_lock;
@@ -634,6 +636,16 @@ struct rdists {
 	bool			has_vpend_valid_dirty;
 };
 
+/*
+ * The ITS command block, which is what the ITS actually parses.
+ */
+struct its_cmd_block {
+	union {
+		u64	raw_cmd[4];
+		__le64	raw_cmd_le[4];
+	};
+};
+
 struct irq_domain;
 struct fwnode_handle;
 int __init its_lpi_memreserve_init(void);
-- 
2.53.0.473.g4a7958ca14-goog

