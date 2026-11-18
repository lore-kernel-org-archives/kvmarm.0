Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015210;
	b=mN4otWfrTY+t545bhR4tvHz7YtMHjW7DVzOx6u9oo2ftgkkymSzocQI3sMYC2f0Bd8Cz
	 fE6BUjq6BVd9TQzQnfxhewiObSNxh1yuaUYIdRc1t3cRhX6YW2NBIqRDekCSBMR87fPYs
	 dFEKW1xxoGrs78gHhm0GVYXEmpa3xlmr7q0oc+6oKXbjIqsSkOPNbeKkEC5lO/ON2i3t0
	 Kc1ElIBxSkUPTLKtmGMQv7JFvDcXldSWysjmQ223PuLrvsjJYkEO199GmLQ58vEyQe14d
	 HW7PAsagezhPnuy+yaWRD5wgtoaN8aJA/65VONqjOL9KAX7uCOUYwrTOXGS0ip5528g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015210;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=D6c2np+7XJR2/0M8luEvk7jxxCqT6MGkLrQimWo7JCw=;
	b=kp355fW6g1Tk2Z9ojGbgxsjtVdpGWVkitlj4efYyLHm7rF91CksyuREMGxyhAdb88XBv
	 ekTSXOPcnoIXkGv4Zd4eFmqEpkvP92HsLromETzWhPnCx0pZ0SEU1yeSvD1UFePtNU6pZ
	 dt0oUk5UPXb18XCHYnS20A/PPUrJ02FsuIeTVTSEX+OO9kQwv/C4oyrpY+3bZ/HSEyBLx
	 KFNt6KgNdnQVbkYgg4uWu0iNrcj6iAh5VfS1bz+gr8rEMmraAvSoxDziyWynocLTPlC7L
	 hkoUdQ4+73WRsQxwhbdk1VE0Q8FlAxnxFVySWUDu9K1XQgnE0HdfT6cVvmcay5u3XXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HiamsQWf;
	arc=none smtp.remote-ip=95.215.58.47
Received: from mta1.migadu.com (out-47.mta1.migadu.com [95.215.58.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E96B606A337
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 15:20:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5E96B606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HiamsQWf
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=g5xTEIlaMETxJ41YtgF1H3rZhxRy4dhLjjAkhFiuZ5w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795015207; v=1; x=1795620007;
 b=HiamsQWfelgsiQP+3+ZN4YQWkBbtLzcblD0AfjzwZbWCETuOEDM8h2xXah6P+oLTpZHx9vlp
 3sDO4PQ36Y/nkdTGRTkYTfInS206BXm29xakRKQwPLicKcoXMJL04pkS5PgWx4gG8h0du+1SxlK
 wL/xo91OEpPWma3ILI/Iu3Ms=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 3c11f406c939197c;
	Wed, 18 Nov 2026 15:20:05 +0000
X-Mizu-Trace-ID: 3c11f406c939197c
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Sascha Bischoff <Sascha.Bischoff@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Sebastian Ene <sebastianene@google.com>,
	=?UTF-8?q?Bart=C5=82omiej=20Grzesik?= <bgrzesik@google.com>,
	Mostafa Saleh <smostafa@google.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Radu Rendec <radu@rendec.net>,
	Fuad Tabba <tabba@google.com>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v4 10/13] KVM: arm64: Take the ITS tables and restrict GITS_BASER<n>
Date: Wed, 18 Nov 2026 15:19:01 +0000
Message-ID: <20261118151904.4099560-11-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261118151904.4099560-1-fuad.tabba@linux.dev>
References: <20261118151904.4099560-1-fuad.tabba@linux.dev>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The ITS writes device and collection entries into the tables
GITS_BASER<n> points to. At setup the hypervisor takes every such table
and every level-2 page an indirect device table already points to. That
includes the vPE table, which the driver allocates whether or not GICv4
is in use. With GICv4 off for the host, only the device table gains
level-2 pages after setup.

From the takeover on, the driver writes new level-1 entries into a copy
of the device table, which the hypervisor pins. On the first MAPD that
needs a new entry, the hypervisor publishes the copy's entry if the
entry holds only Valid and the address of an aligned level-2 page, and
takes and zeroes that page. A MAPD whose entry stays invalid is
rejected, and so is a MAPD past the end of a flat device table.

A GITS_BASER<n> write is now accepted only with the ITS disabled and
quiescent, and only for a register that pointed to a table at setup. The
hypervisor then writes the value it read at setup in place of the
host's, and an enable aborts unless every such register still holds it.

Co-developed-by: Sebastian Ene <sebastianene@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/its_emulate.c | 252 +++++++++++++++++++++++++-
 drivers/irqchip/irq-gic-v3-its.c      |  30 ++-
 include/linux/irqchip/arm-gic-v3.h    |   7 +-
 3 files changed, 280 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
index dd077abb1b24b..145997d54ce72 100644
--- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -17,11 +17,25 @@
 #include <nvhe/memory.h>
 #include <nvhe/spinlock.h>
 
+/* A GITS_BASER<n> table, as the register described it at setup. */
+struct its_table {
+	/* The hardware table, which is hyp-owned, and the host's pinned copy of its level 1. */
+	void			*hw;
+	void			*l1_copy;
+	u64			baser;
+	size_t			size;
+	u32			psz;
+	u8			esz;
+	bool			indirect;
+};
+
 /* Per-ITS state, in the pages the host donated at setup. */
 struct its_priv {
 	hyp_spinlock_t		lock;
 	void __iomem		*base;
 	u64			cbaser;
+	struct its_table	tables[GITS_BASER_NR_REGS];
+	struct its_table	*dev_table;
 
 	/* The hardware queue, which is hyp-owned, and the host's pinned copy of it. */
 	void			*cmdq_hw;
@@ -50,10 +64,75 @@ static int its_pin_host_pages(phys_addr_t pa, u64 nr_pages)
 	return hyp_pin_shared_mem(va, va + (nr_pages << PAGE_SHIFT));
 }
 
+static size_t its_l2_size(struct its_table *t)
+{
+	return PAGE_ALIGN(t->psz);
+}
+
+/*
+ * The ITS discards a device table write through an invalid level-1 entry, so
+ * make the entry for device_id valid from the host's copy. A hardware entry
+ * only ever goes from invalid to valid.
+ */
+static bool its_publish_l1(struct its_priv *its, u32 device_id)
+{
+	struct its_table *t = its->dev_table;
+	size_t l2_size;
+	u64 idx, entry;
+	phys_addr_t pa;
+	__le64 *hw;
+
+	/* Without a device table in memory there is no level-1 entry to publish. */
+	if (!t)
+		return true;
+
+	if (!t->indirect)
+		return device_id < t->size / t->esz;
+
+	idx = device_id / (t->psz / t->esz);
+	if (idx >= t->size / GITS_LVL1_ENTRY_SIZE)
+		return false;
+
+	hw = t->hw;
+	if (le64_to_cpu(hw[idx]) & GITS_BASER_VALID)
+		return true;
+
+	/* Read the entry once, as the host can change its copy. */
+	entry = le64_to_cpu(READ_ONCE(((__le64 *)t->l1_copy)[idx]));
+
+	l2_size = its_l2_size(t);
+	pa = GITS_LVL1_ADDRESS(entry);
+	if (entry != (pa | GITS_BASER_VALID) || !IS_ALIGNED(pa, l2_size))
+		return false;
+	if (__pkvm_host_donate_hyp(PHYS_PFN(pa), l2_size >> PAGE_SHIFT))
+		return false;
+
+	/* Using a new level-2 table that isn't all zeros is UNPREDICTABLE. */
+	memset(hyp_phys_to_virt(pa), 0, l2_size);
+	if (!(t->baser & GITS_BASER_SHAREABILITY_MASK))
+		gic_flush_dcache_to_poc(hyp_phys_to_virt(pa), l2_size);
+	/* The ITS can walk a valid entry at any time, so order the zeroing before it. */
+	dma_wmb();
+	hw[idx] = cpu_to_le64(entry);
+	if (!(t->baser & GITS_BASER_SHAREABILITY_MASK))
+		gic_flush_dcache_to_poc(&hw[idx], sizeof(*hw));
+	/* Make the entry visible to the ITS before the command that relies on it is queued. */
+	dsb(sy);
+	return true;
+}
+
+static bool its_mapd(struct its_priv *its, struct its_cmd_block *cmd)
+{
+	u32 device_id = its_cmd_get_deviceid(cmd->raw_cmd);
+
+	return its_publish_l1(its, device_id);
+}
+
 static bool its_process_cmd(struct its_priv *its, struct its_cmd_block *cmd)
 {
 	switch (its_cmd_get_command(cmd->raw_cmd)) {
 	case GITS_CMD_MAPD:
+		return its_mapd(its, cmd);
 	case GITS_CMD_MAPC:
 	case GITS_CMD_MAPTI:
 	case GITS_CMD_MAPI:
@@ -128,10 +207,26 @@ static bool its_cwriter_write(struct its_priv *its, u64 val)
 	return !rejected;
 }
 
-/* A reset clears GITS_CBASER.Valid, and an enable with it clear is UNPREDICTABLE. */
+/*
+ * A reset clears the Valid bits of GITS_CBASER and GITS_BASER<n>, and enabling the
+ * ITS with the Valid bit of GITS_CBASER or of the device table clear is UNPREDICTABLE.
+ */
 static bool its_bases_intact(struct its_priv *its)
 {
-	return readq_relaxed(its->base + GITS_CBASER) == its->cbaser;
+	unsigned int n;
+
+	if (readq_relaxed(its->base + GITS_CBASER) != its->cbaser)
+		return false;
+
+	for (n = 0; n < GITS_BASER_NR_REGS; n++) {
+		u64 baser = its->tables[n].baser;
+
+		if ((baser & GITS_BASER_VALID) &&
+		    readq_relaxed(its->base + GITS_BASER + n * sizeof(u64)) != baser)
+			return false;
+	}
+
+	return true;
 }
 
 static bool its_ctlr_write(struct its_priv *its, u64 val)
@@ -175,6 +270,21 @@ static bool its_cbaser_write(struct its_priv *its)
 	return true;
 }
 
+static bool its_baser_write(struct its_priv *its, unsigned int index)
+{
+	u64 baser = its->tables[index].baser;
+
+	if (!its_disabled_quiescent(its))
+		return false;
+
+	/* Refuse a table the hypervisor didn't take, as the driver never restores one. */
+	if (!(baser & GITS_BASER_VALID))
+		return false;
+
+	writeq_relaxed(baser, its->base + GITS_BASER + index * sizeof(u64));
+	return true;
+}
+
 static bool its_emulate(struct its_priv *its, u64 offset, bool write, u64 *val, u8 size)
 {
 	if (write) {
@@ -187,10 +297,8 @@ static bool its_emulate(struct its_priv *its, u64 offset, bool write, u64 *val,
 			/* The driver writes the low word, and the high word is RES0. */
 			return its_cwriter_write(its, *val);
 		case GITS_BASER ... GITS_BASER + (GITS_BASER_NR_REGS - 1) * sizeof(u64):
-			if (size != sizeof(u64))
-				return false;
-			writeq_relaxed(*val, its->base + offset);
-			return true;
+			return size == sizeof(u64) &&
+			       its_baser_write(its, (offset - GITS_BASER) / sizeof(u64));
 		default:
 			return false;
 		}
@@ -275,6 +383,134 @@ static int its_take_cmdq(struct its_priv *its, phys_addr_t copy_pa)
 	return 0;
 }
 
+static u32 its_baser_psz(u64 baser)
+{
+	switch (FIELD_GET(GITS_BASER_PAGE_SIZE_MASK, baser)) {
+	case GIC_PAGE_SIZE_4K:
+		return SZ_4K;
+	case GIC_PAGE_SIZE_16K:
+		return SZ_16K;
+	default:
+		/* 0b11 is reserved and treated as 64K. */
+		return SZ_64K;
+	}
+}
+
+static phys_addr_t its_baser_pa(u64 baser, u32 psz)
+{
+	/* With 64K pages, bits [15:12] of the register hold PA[51:48]. */
+	if (psz == SZ_64K)
+		return GITS_BASER_ADDR_48_to_52(baser);
+
+	return baser & GENMASK_ULL(47, 12);
+}
+
+static int its_take_level2(struct its_table *t)
+{
+	u64 nr_entries = t->size / GITS_LVL1_ENTRY_SIZE;
+	u64 l2_pages = its_l2_size(t) >> PAGE_SHIFT;
+	__le64 *table = t->hw;
+	u64 i, entry;
+	int ret;
+
+	for (i = 0; i < nr_entries; i++) {
+		entry = le64_to_cpu(table[i]);
+		if (!(entry & GITS_BASER_VALID))
+			continue;
+
+		ret = __pkvm_host_donate_hyp(PHYS_PFN(GITS_LVL1_ADDRESS(entry)), l2_pages);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+static int its_take_table(struct its_table *t, phys_addr_t copy_pa)
+{
+	u64 baser = t->baser, nr_pages;
+	phys_addr_t pa;
+	int ret;
+
+	t->psz = its_baser_psz(baser);
+	t->esz = GITS_BASER_ENTRY_SIZE(baser);
+	t->size = GITS_BASER_NR_PAGES(baser) * t->psz;
+	t->indirect = baser & GITS_BASER_INDIRECT;
+	pa = its_baser_pa(baser, t->psz);
+	nr_pages = DIV_ROUND_UP(t->size, PAGE_SIZE);
+
+	ret = __pkvm_host_donate_hyp(PHYS_PFN(pa), nr_pages);
+	if (ret)
+		return ret;
+	t->hw = hyp_phys_to_virt(pa);
+
+	if (!t->indirect)
+		return 0;
+
+	if (copy_pa) {
+		ret = its_pin_host_pages(copy_pa, nr_pages);
+		if (ret)
+			return ret;
+		t->l1_copy = hyp_phys_to_virt(copy_pa);
+	}
+
+	return its_take_level2(t);
+}
+
+/* GICv4.1 ITSes with a common affinity share one vPE table (GITS_TYPER.SVPET). */
+static bool its_vpe_table_taken(u64 baser)
+{
+	unsigned int i, n;
+
+	for (i = 0; i < num_protected_reg; i++) {
+		struct its_priv *its = pkvm_protected_regs[i].priv;
+
+		if (!its)
+			continue;
+
+		for (n = 0; n < GITS_BASER_NR_REGS; n++) {
+			if (its->tables[n].hw && its->tables[n].baser == baser)
+				return true;
+		}
+	}
+
+	return false;
+}
+
+static int its_take_tables(struct its_priv *its, struct its_pkvm_desc *desc)
+{
+	unsigned int n;
+	int ret;
+
+	for (n = 0; n < GITS_BASER_NR_REGS; n++) {
+		struct its_table *t = &its->tables[n];
+		phys_addr_t copy_pa = 0;
+
+		t->baser = readq_relaxed(its->base + GITS_BASER + n * sizeof(u64));
+		if (!(t->baser & GITS_BASER_VALID))
+			continue;
+
+		switch (GITS_BASER_TYPE(t->baser)) {
+		case GITS_BASER_TYPE_DEVICE:
+			/* The driver publishes level-1 entries through its copy. */
+			copy_pa = desc->dev_l1_copy_pa;
+			its->dev_table = t;
+			break;
+		case GITS_BASER_TYPE_VCPU:
+			/* Writing it while the ITS is enabled is UNPREDICTABLE, so take it. */
+			if (its_vpe_table_taken(t->baser))
+				continue;
+			break;
+		}
+
+		ret = its_take_table(t, copy_pa);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 int pkvm_its_emulate_setup(phys_addr_t its_base, phys_addr_t desc_pa,
 			   size_t desc_size)
 {
@@ -316,6 +552,10 @@ int pkvm_its_emulate_setup(phys_addr_t its_base, phys_addr_t desc_pa,
 	if (ret)
 		return ret;
 
+	ret = its_take_tables(its, desc);
+	if (ret)
+		return ret;
+
 	WARN_ON(__pkvm_hyp_donate_host(PHYS_PFN(desc_pa), desc_pages));
 	/* Published by stop_machine()'s exit, and no host CPU traps until then. */
 	region->priv = its;
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index d98e05557a296..c00178249a04b 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -5245,12 +5245,15 @@ static int __init its_compute_its_list_map(struct its_node *its)
 }
 
 /*
- * In pKVM, the driver writes its commands into a copy of the command queue,
- * and the hypervisor checks each one before the ITS sees it.
+ * In pKVM, the driver writes its commands into a copy of the command queue and
+ * its level-1 entries into a copy of the device table. The hypervisor checks
+ * each one before the ITS sees it.
  */
 struct its_pkvm_state {
 	void			*priv;
 	void			*cmdq;
+	struct its_baser	*dev_baser;
+	void			*dev_l1;
 	struct its_pkvm_desc	*desc;
 	size_t			desc_size;
 };
@@ -5264,6 +5267,7 @@ static DEFINE_MUTEX(its_pkvm_lock);
 static int __init its_pkvm_alloc_copies(struct its_node *its,
 					struct its_pkvm_state *st)
 {
+	struct its_baser *baser = its_get_baser(its, GITS_BASER_TYPE_DEVICE);
 	struct page *page;
 
 	page = its_alloc_pages_node(its->numa_node, GFP_KERNEL, ITS_PKVM_PRIV_ORDER);
@@ -5277,6 +5281,15 @@ static int __init its_pkvm_alloc_copies(struct its_node *its,
 		return -ENOMEM;
 	st->cmdq = page_address(page);
 
+	if (!baser || !(baser->val & GITS_BASER_INDIRECT))
+		return 0;
+
+	page = its_alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO, baser->order);
+	if (!page)
+		return -ENOMEM;
+	st->dev_baser = baser;
+	st->dev_l1 = page_address(page);
+
 	return 0;
 }
 
@@ -5312,6 +5325,8 @@ static int __init its_pkvm_prepare_one(struct its_node *its)
 	desc->priv_pa = virt_to_phys(st->priv);
 	desc->priv_pages = 1 << ITS_PKVM_PRIV_ORDER;
 	desc->cmdq_copy_pa = virt_to_phys(st->cmdq);
+	if (st->dev_l1)
+		desc->dev_l1_copy_pa = virt_to_phys(st->dev_l1);
 
 	i = 0;
 	list_for_each_entry(dev, &its->its_device_list, entry) {
@@ -5330,6 +5345,9 @@ static int __init its_pkvm_hand_over(struct its_node *its,
 {
 	struct its_pkvm_state *st = its->pkvm;
 
+	if (st->dev_l1)
+		memcpy(st->dev_l1, st->dev_baser->base, PAGE_ORDER_TO_SIZE(st->dev_baser->order));
+
 	return setup(its->phys_base, st->desc, st->desc_size);
 }
 
@@ -5341,6 +5359,12 @@ static void __init its_pkvm_switch(struct its_node *its)
 	its->cmd_base = st->cmdq;
 	st->cmdq = NULL;
 	st->priv = NULL;
+
+	/* val still holds the address of the hardware table, which the hypervisor now owns. */
+	if (st->dev_l1) {
+		st->dev_baser->base = st->dev_l1;
+		st->dev_l1 = NULL;
+	}
 }
 
 static void __init its_pkvm_finish_one(struct its_node *its)
@@ -5351,6 +5375,8 @@ static void __init its_pkvm_finish_one(struct its_node *its)
 		its_free_pages(st->priv, ITS_PKVM_PRIV_ORDER);
 	if (st->cmdq)
 		its_free_pages(st->cmdq, get_order(ITS_CMD_QUEUE_SZ));
+	if (st->dev_l1)
+		its_free_pages(st->dev_l1, st->dev_baser->order);
 
 	if (st->desc)
 		its_free_pages(st->desc, get_order(st->desc_size));
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 01110162914f7..5fc06ca11a53b 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -498,6 +498,7 @@
 #define GITS_BASER_TYPE_RESERVED7	7
 
 #define GITS_LVL1_ENTRY_SIZE           (8UL)
+#define GITS_LVL1_ADDRESS(entry)	((entry) & GENMASK_ULL(51, 12))
 
 /*
  * ITS commands
@@ -691,11 +692,15 @@ struct its_pkvm_device {
 	u8		event_bits;
 };
 
-/* Passed to the hypervisor at setup. Every address is physical and page-aligned. */
+/*
+ * Passed to the hypervisor at setup. Every address is physical and page-aligned,
+ * and dev_l1_copy_pa is 0 unless the device table is indirect.
+ */
 struct its_pkvm_desc {
 	phys_addr_t		priv_pa;
 	u64			priv_pages;
 	phys_addr_t		cmdq_copy_pa;
+	phys_addr_t		dev_l1_copy_pa;
 	u32			nr_devices;
 	struct its_pkvm_device	devices[];
 };
-- 
2.47.3

