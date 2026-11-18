Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.63
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015217;
	b=DhiGjUswXqLMRaXzug5fZx4XpeYKwPxoUiGWgvUJizF5TRtXq16EfJSYf/GzktOLK43U
	 Dp22tYDl5bCD0gDBPV2BZwsgWYdMWUr7DwtyfvS/TS5Ha3bB6FproM8XRaUnWn3uFpWU7
	 CcuDu9BitkI6lePLXqEuacdcmc1Kz35EWQt6HV//ylGf3nY/TO2VIU/cTyKHDF9ji8SuV
	 yIfZlCaTa9sbOt6uRjJjQdbG4GRsf6TSrrgfG4BU+PDbSAtSm1Jtl1YoIf5knyg8XiGa2
	 V7DpG9HqlhP0j2OpF+VDYMG2a9Gv89c+7HbvAoUcPBlUtnaOwp0gdaJhubZtIIpnbcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015217;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Itjh7PVyS4MnhuZlB6spo2FIevaOkNAo+PWyYUOolEI=;
	b=SwPacDu/9dMjMatlU807X605xWXXt0/TCItTG9I0pve8T7WVjNQKtlwGEbMDM8qYzDTk
	 SIfIr6d9zwxgu3qIwMdo6TE+vpCp0NkZtoAcWmOQGV309iW4a7yg5Sr68+pLlY8aXrIyq
	 dEexsTkVs0crp0yccGKWLJJLAglcGmZ2JV3U+u5yvaSAVDNq8YdgGKXbx6VMEgl4jrPDe
	 qL5VU0jDUar0oBD2pWHJ7fMlwgcGqsxhyNMpM0/z8845PfYO0kaGwGbSgjPhx8S2jjfcL
	 cGZFUsFIStvGKx0lAMM3FyJBzbvdObP2ufs4awCYwttYrA1ZLvoVJV4drf7n5zCLeWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="hS/edfTq";
	arc=none smtp.remote-ip=95.215.58.63
Received: from mta1.migadu.com (out-63.mta1.migadu.com [95.215.58.63])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC6E6606A31C
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 15:20:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CC6E6606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hS/edfTq
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=YuK9yLvWMFzDq0qy/GDY7XRkOD+HY+MO6XstOh132Dw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795015215; v=1; x=1795620015;
 b=hS/edfTqpxWARJxTJA+ZxVYB/8ow/RyoVinv4JQ2Xo6hSwCP8wP8dbh0lkZHCiH/U9hc+ufi
 XGQqTJYw/RXt/BWhFZI2npAeVIyEgLjeqcCfCMfRezi8qseFbAhXbD7dag3tSAxXld8Jj8GRzrC
 k3otbO1EYN3eb3xet+VKvfuU=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 939c6d14e0bb3540;
	Wed, 18 Nov 2026 15:20:12 +0000
X-Mizu-Trace-ID: 939c6d14e0bb3540
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
Subject: [PATCH v4 11/13] KVM: arm64: Take the ITT of every device the host maps
Date: Wed, 18 Nov 2026 15:19:02 +0000
Message-ID: <20261118151904.4099560-12-fuad.tabba@linux.dev>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On a translation, the ITS indexes the collection and vPE tables with
whatever ICID and vPEID the ITE holds. As "The format of the ITT entries
is IMPLEMENTATION DEFINED" (IHI 0069H.b 5.3.10), the hypervisor can't
check an ITT the host can write.

On a MAPD with V == 1, the hypervisor takes the ITT's pages and zeroes
them before forwarding the command, and rejects the MAPD if the DeviceID
is already mapped, the ITT isn't page-aligned or Size exceeds
GITS_TYPER.ID_bits. It sizes the ITT from the MAPD's Size and
GITS_TYPER.ITT_entry_size, except on QDF2400 rev 1, whose ITS writes
16-byte entries whatever ITT_entry_size holds (erratum 0065). The ITTs
of the devices mapped before the takeover, which the driver lists, are
taken without being zeroed.

A MAPD is UNPREDICTABLE when "There is an existing mapping for the
DeviceID and the mapped ITT contains valid EventID mappings" (5.3.10),
whether V is 0 or 1. If the host unmaps a device without discarding its
events first, the ITS may go on using the ITT. The hypervisor doesn't
track which events a device has mapped, so it never gives an ITT back.
On a MAPD with V == 0 it marks the device retired, and a later MAPD for
that DeviceID reuses the ITT, zeroed, if the command gives the same
address and the ITT is large enough. If the command gives another
address, the hypervisor takes the new ITT and keeps the old one too. The
driver keeps a freed device's ITT as well, for the next device with its
DeviceID, so in protected mode ITT memory doesn't go back to the kernel.

A GITS_CBASER write resets the queue, so it now aborts until the ITS has
consumed every forwarded command, as a dropped MAPD would leave a device
tracked that the ITS never mapped. The hypervisor counts the consumed
commands from GITS_CREADR, which it reads when the host does and before
a GITS_CWRITER or GITS_CTLR write. The driver writes GITS_CBASER only on
resume, after its waits, so a resume aborts only if a wait timed out
before suspend.

The hypervisor tracks a fixed number of DeviceIDs per ITS, about 1300 on
a 4K host, and returns that number from the setup call. Retired ones are
included, so that's a limit on the DeviceIDs mapped since boot.
its_create_device() fails beyond that number rather than queue a MAPD
the hypervisor would reject.

Co-developed-by: Sebastian Ene <sebastianene@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
Co-developed-by: Bartłomiej Grzesik <bgrzesik@google.com>
Signed-off-by: Bartłomiej Grzesik <bgrzesik@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/hyp/nvhe/its_emulate.c | 172 +++++++++++++++++++++++++-
 arch/arm64/kvm/pkvm.c                 |   2 +-
 drivers/irqchip/irq-gic-v3-its.c      |  66 +++++++++-
 include/linux/irqchip/arm-gic-v3.h    |   5 +-
 4 files changed, 231 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
index 145997d54ce72..4a3659f727a94 100644
--- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -29,14 +29,31 @@ struct its_table {
 	bool			indirect;
 };
 
+/* A device the host has mapped. Once unmapped it is retired, and its ITT pages stay hyp-owned. */
+struct its_device_map {
+	phys_addr_t		itt_pa;
+	u32			device_id;
+	u32			nr_pages;
+	u8			event_bits;
+	bool			retired;
+};
+
 /* Per-ITS state, in the pages the host donated at setup. */
 struct its_priv {
 	hyp_spinlock_t		lock;
 	void __iomem		*base;
+	u64			typer;
 	u64			cbaser;
+	u8			id_bits;
+	u8			itt_entry_size;
 	struct its_table	tables[GITS_BASER_NR_REGS];
 	struct its_table	*dev_table;
 
+	/* Sorted by device_id, in the rest of the donated pages. */
+	struct its_device_map	*devices;
+	u32			nr_devices;
+	u32			max_devices;
+
 	/* The hardware queue, which is hyp-owned, and the host's pinned copy of it. */
 	void			*cmdq_hw;
 	void			*cmdq_copy;
@@ -47,6 +64,9 @@ struct its_priv {
 
 	/* The GITS_CREADR offset last read. */
 	u32			hw_creadr;
+	/* Commands forwarded to the ITS, and consumed by it. */
+	u64			seq_submitted;
+	u64			seq_completed;
 };
 
 static int its_pin_host_pages(phys_addr_t pa, u64 nr_pages)
@@ -121,11 +141,103 @@ static bool its_publish_l1(struct its_priv *its, u32 device_id)
 	return true;
 }
 
+/* The index of device_id, or where it would be inserted. */
+static u32 its_dev_search(struct its_priv *its, u32 device_id, bool *found)
+{
+	u32 lo = 0, hi = its->nr_devices;
+
+	while (lo < hi) {
+		u32 mid = lo + (hi - lo) / 2;
+
+		if (its->devices[mid].device_id < device_id)
+			lo = mid + 1;
+		else
+			hi = mid;
+	}
+
+	*found = lo < its->nr_devices && its->devices[lo].device_id == device_id;
+	return lo;
+}
+
+/*
+ * The driver page-aligns ITTs in pKVM. A MAPD on an ITT that isn't all zeros is
+ * UNPREDICTABLE, so @zero is set for a runtime MAPD. A retired device's ITT is
+ * reused if the MAPD gives its address and it is large enough.
+ */
+static int its_take_itt(struct its_priv *its, u32 device_id, u8 event_bits,
+			phys_addr_t itt_pa, bool zero)
+{
+	struct its_device_map *dev;
+	u32 idx, nr_pages;
+	size_t size;
+	bool found;
+	int ret;
+
+	if (event_bits > its->id_bits || !PAGE_ALIGNED(itt_pa))
+		return -EINVAL;
+
+	idx = its_dev_search(its, device_id, &found);
+	dev = &its->devices[idx];
+	if (found && !dev->retired)
+		return -EEXIST;
+	if (!found && its->nr_devices == its->max_devices)
+		return -ENOSPC;
+
+	size = PAGE_ALIGN(BIT_ULL(event_bits) * its->itt_entry_size);
+	nr_pages = size >> PAGE_SHIFT;
+	if (!found || itt_pa != dev->itt_pa || nr_pages > dev->nr_pages) {
+		ret = __pkvm_host_donate_hyp(PHYS_PFN(itt_pa), nr_pages);
+		if (ret)
+			return ret;
+	} else {
+		nr_pages = dev->nr_pages;
+	}
+
+	if (zero) {
+		memset(hyp_phys_to_virt(itt_pa), 0, size);
+		gic_flush_dcache_to_poc(hyp_phys_to_virt(itt_pa), size);
+	}
+
+	if (!found) {
+		memmove(dev + 1, dev, (its->nr_devices - idx) * sizeof(*dev));
+		its->nr_devices++;
+	}
+	*dev = (struct its_device_map) {
+		.itt_pa = itt_pa,
+		.device_id = device_id,
+		.nr_pages = nr_pages,
+		.event_bits = event_bits,
+	};
+	return 0;
+}
+
+/*
+ * A MAPD with V == 0 is UNPREDICTABLE while the ITT holds valid ITEs. The ITS may
+ * then go on using the ITT, so it is never given back to the host.
+ */
+static void its_retire(struct its_priv *its, u32 device_id)
+{
+	bool found;
+	u32 idx;
+
+	idx = its_dev_search(its, device_id, &found);
+	if (found)
+		its->devices[idx].retired = true;
+}
+
 static bool its_mapd(struct its_priv *its, struct its_cmd_block *cmd)
 {
 	u32 device_id = its_cmd_get_deviceid(cmd->raw_cmd);
 
-	return its_publish_l1(its, device_id);
+	if (!its_publish_l1(its, device_id))
+		return false;
+
+	if (its_cmd_get_validbit(cmd->raw_cmd))
+		return !its_take_itt(its, device_id, its_cmd_get_size(cmd->raw_cmd),
+				     its_cmd_get_ittaddr(cmd->raw_cmd), true);
+
+	its_retire(its, device_id);
+	return true;
 }
 
 static bool its_process_cmd(struct its_priv *its, struct its_cmd_block *cmd)
@@ -151,11 +263,19 @@ static bool its_process_cmd(struct its_priv *its, struct its_cmd_block *cmd)
 	}
 }
 
+/* Count the commands consumed since the last read. */
 static u64 its_read_creadr(struct its_priv *its)
 {
 	u64 creadr = readq_relaxed(its->base + GITS_CREADR);
 	u32 offset = creadr & GITS_CREADR_OFFSET;
 
+	/*
+	 * A disabled ITS consumes no commands, so GITS_CREADR moving while it is
+	 * disabled, as after a reset behind the hypervisor, isn't progress.
+	 */
+	if (readl_relaxed(its->base + GITS_CTLR) & GITS_CTLR_ENABLE)
+		its->seq_completed += ((offset + its->cmdq_size - its->hw_creadr) %
+				       its->cmdq_size) / sizeof(struct its_cmd_block);
 	its->hw_creadr = offset;
 
 	return creadr;
@@ -199,6 +319,7 @@ static bool its_cwriter_write(struct its_priv *its, u64 val)
 		 */
 		gic_flush_dcache_to_poc(its->cmdq_hw + its->cmd_offset, sizeof(cmd));
 		its->cmd_offset = (its->cmd_offset + sizeof(cmd)) % its->cmdq_size;
+		its->seq_submitted++;
 	}
 
 	dsb(ishst);
@@ -231,7 +352,11 @@ static bool its_bases_intact(struct its_priv *its)
 
 static bool its_ctlr_write(struct its_priv *its, u64 val)
 {
-	u32 ctlr = readl_relaxed(its->base + GITS_CTLR);
+	u32 ctlr;
+
+	/* Read while still disabled, so a reset GITS_CREADR isn't counted as progress. */
+	its_read_creadr(its);
+	ctlr = readl_relaxed(its->base + GITS_CTLR);
 
 	if ((val & GITS_CTLR_ENABLE) && !(ctlr & GITS_CTLR_ENABLE)) {
 		/*
@@ -258,12 +383,13 @@ static bool its_disabled_quiescent(struct its_priv *its)
 
 static bool its_cbaser_write(struct its_priv *its)
 {
-	if (!its_disabled_quiescent(its))
+	/* The write resets the queue, and the ITS drops any command it hasn't consumed. */
+	if (!its_disabled_quiescent(its) || its->seq_completed != its->seq_submitted)
 		return false;
 
 	writeq_relaxed(its->cbaser, its->base + GITS_CBASER);
 
-	/* The write reset GITS_CREADR to 0, and the ITS drops what was queued before it. */
+	/* The write reset GITS_CREADR to 0. */
 	its->cmd_offset = 0;
 	its->hw_creadr = 0;
 	writeq_relaxed(0, its->base + GITS_CWRITER);
@@ -320,7 +446,10 @@ static bool its_emulate(struct its_priv *its, u64 offset, bool write, u64 *val,
 			return false;
 		break;
 	case GITS_CREADR:
-		break;
+		*val = its_read_creadr(its);
+		if (size == sizeof(u32))
+			*val = lower_32_bits(*val);
+		return true;
 	default:
 		return false;
 	}
@@ -380,6 +509,8 @@ static int its_take_cmdq(struct its_priv *its, phys_addr_t copy_pa)
 	its->cmdq_size = size;
 	its->cmd_offset = cwriter;
 	its->hw_creadr = creadr;
+	/* Commands the host queued before setup are submitted, not yet consumed. */
+	its->seq_submitted = ((cwriter + size - creadr) % size) / sizeof(struct its_cmd_block);
 	return 0;
 }
 
@@ -511,6 +642,22 @@ static int its_take_tables(struct its_priv *its, struct its_pkvm_desc *desc)
 	return 0;
 }
 
+static int its_take_devices(struct its_priv *its, struct its_pkvm_desc *desc)
+{
+	int ret;
+	u32 i;
+
+	for (i = 0; i < desc->nr_devices; i++) {
+		struct its_pkvm_device dev = desc->devices[i];
+
+		ret = its_take_itt(its, dev.device_id, dev.event_bits, dev.itt_pa, false);
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
@@ -546,7 +693,16 @@ int pkvm_its_emulate_setup(phys_addr_t its_base, phys_addr_t desc_pa,
 
 	hyp_spin_lock_init(&its->lock);
 	its->base = region->hyp_va;
+	its->typer = readq_relaxed(its->base + GITS_TYPER);
 	its->cbaser = readq_relaxed(its->base + GITS_CBASER);
+	its->id_bits = FIELD_GET(GITS_TYPER_IDBITS, its->typer) + 1;
+	its->itt_entry_size = FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, its->typer) + 1;
+	its->devices = (void *)(its + 1);
+	its->max_devices = (priv_pages * PAGE_SIZE - sizeof(*its)) / sizeof(*its->devices);
+
+	/* QDF2400 rev 1.x, erratum 0065: the ITS writes 16-byte ITEs where GITS_TYPER says 8. */
+	if (readl_relaxed(its->base + GITS_IIDR) == 0x00001070)
+		its->itt_entry_size = 16;
 
 	ret = its_take_cmdq(its, desc->cmdq_copy_pa);
 	if (ret)
@@ -556,8 +712,12 @@ int pkvm_its_emulate_setup(phys_addr_t its_base, phys_addr_t desc_pa,
 	if (ret)
 		return ret;
 
+	ret = its_take_devices(its, desc);
+	if (ret)
+		return ret;
+
 	WARN_ON(__pkvm_hyp_donate_host(PHYS_PFN(desc_pa), desc_pages));
 	/* Published by stop_machine()'s exit, and no host CPU traps until then. */
 	region->priv = its;
-	return 0;
+	return its->max_devices;
 }
diff --git a/arch/arm64/kvm/pkvm.c b/arch/arm64/kvm/pkvm.c
index ddd797d21d42d..03854cc84a9f9 100644
--- a/arch/arm64/kvm/pkvm.c
+++ b/arch/arm64/kvm/pkvm.c
@@ -85,7 +85,7 @@ static int __init pkvm_init_its_emulation(phys_addr_t its_base,
 	int ret;
 
 	ret = kvm_call_hyp_nvhe(__pkvm_its_emulate_setup, its_base, virt_to_phys(desc), desc_size);
-	if (ret)
+	if (ret < 0)
 		kvm_err("ITS@%pa: emulation setup failed: %d\n", &its_base, ret);
 
 	return ret;
diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index c00178249a04b..1bbe4fa1bf09f 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -49,6 +49,7 @@
 #define ITS_FLAGS_WORKAROUND_CAVIUM_23144	(1ULL << 2)
 #define ITS_FLAGS_FORCE_NON_SHAREABLE		(1ULL << 3)
 #define ITS_FLAGS_WORKAROUND_HISILICON_162100801	(1ULL << 4)
+#define ITS_FLAGS_HYP_OWNED			(1ULL << 5)
 
 #define RD_LOCAL_LPI_ENABLED                    BIT(0)
 #define RD_LOCAL_PENDTABLE_PREALLOCATED         BIT(1)
@@ -128,6 +129,9 @@ struct its_node {
 	u32			pre_its_base; /* for Socionext Synquacer */
 	int			vlpi_redist_offset;
 	struct its_pkvm_state	*pkvm;
+	u32			pkvm_max_devices;
+	/* Freed devices whose ITT the hypervisor keeps. Protected by dev_alloc_lock. */
+	struct list_head	pkvm_retired;
 };
 
 static DEFINE_PER_CPU(struct its_node *, local_4_1_its);
@@ -3344,6 +3348,18 @@ static struct its_device *its_find_device(struct its_node *its, u32 dev_id)
 	return its_dev;
 }
 
+static struct its_device *its_find_retired(struct its_node *its, u32 dev_id)
+{
+	struct its_device *its_dev;
+
+	list_for_each_entry(its_dev, &its->pkvm_retired, entry) {
+		if (its_dev->device_id == dev_id)
+			return its_dev;
+	}
+
+	return NULL;
+}
+
 static struct its_baser *its_get_baser(struct its_node *its, u32 type)
 {
 	int i;
@@ -3457,7 +3473,7 @@ static bool its_alloc_vpe_table(u32 vpe_id)
 static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 					    int nvecs, bool alloc_lpis)
 {
-	struct its_device *dev;
+	struct its_device *dev, *retired;
 	unsigned long *lpi_map = NULL;
 	unsigned long flags;
 	u16 *col_map = NULL;
@@ -3468,6 +3484,14 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 	int id_bits;
 	int sz;
 
+	retired = its_find_retired(its, dev_id);
+
+	/* The hypervisor rejects a MAPD past its device tracker's capacity. */
+	if ((its->flags & ITS_FLAGS_HYP_OWNED) && !retired &&
+	    list_count_nodes(&its->its_device_list) + list_count_nodes(&its->pkvm_retired) >=
+	    its->pkvm_max_devices)
+		return NULL;
+
 	if (!its_alloc_device_table(its, dev_id))
 		return NULL;
 
@@ -3488,7 +3512,15 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 	if (gic_is_protected_kvm())
 		sz = PAGE_ALIGN(sz);
 
-	itt = itt_alloc_pool(its->numa_node, sz);
+	/* The hypervisor zeroes and flushes a retired ITT when its device is mapped again. */
+	if (retired && retired->itt_sz >= sz) {
+		itt = retired->itt;
+		sz = retired->itt_sz;
+	} else {
+		itt = itt_alloc_pool(its->numa_node, sz);
+		if (itt)
+			gic_flush_dcache_to_poc(itt, sz);
+	}
 
 	dev = kzalloc_obj(*dev);
 
@@ -3504,13 +3536,18 @@ static struct its_device *its_create_device(struct its_node *its, u32 dev_id,
 
 	if (!dev || !itt || !col_map || (!lpi_map && alloc_lpis)) {
 		kfree(dev);
-		itt_free_pool(itt, sz);
+		if (!retired || itt != retired->itt)
+			itt_free_pool(itt, sz);
 		bitmap_free(lpi_map);
 		kfree(col_map);
 		return NULL;
 	}
 
-	gic_flush_dcache_to_poc(itt, sz);
+	/* An ITT too small to reuse stays with the hypervisor, so drop its record too. */
+	if (retired) {
+		list_del(&retired->entry);
+		kfree(retired);
+	}
 
 	dev->its = its;
 	dev->itt = itt;
@@ -3542,6 +3579,13 @@ static void its_free_device(struct its_device *its_dev)
 	list_del(&its_dev->entry);
 	raw_spin_unlock_irqrestore(&its_dev->its->lock, flags);
 	kfree(its_dev->event_map.col_map);
+
+	/* The hypervisor keeps the ITT, for the next mapping of this DeviceID. */
+	if (its_dev->its->flags & ITS_FLAGS_HYP_OWNED) {
+		list_add(&its_dev->entry, &its_dev->its->pkvm_retired);
+		return;
+	}
+
 	itt_free_pool(its_dev->itt, its_dev->itt_sz);
 	kfree(its_dev);
 }
@@ -5250,6 +5294,7 @@ static int __init its_compute_its_list_map(struct its_node *its)
  * each one before the ITS sees it.
  */
 struct its_pkvm_state {
+	u32			max_devices;
 	void			*priv;
 	void			*cmdq;
 	struct its_baser	*dev_baser;
@@ -5261,7 +5306,7 @@ struct its_pkvm_state {
 /* Held, with every ITS's dev_alloc_lock, from prepare to finish. */
 static DEFINE_MUTEX(its_pkvm_lock);
 
-/* Pages for the hypervisor's per-ITS state. */
+/* The hypervisor's per-ITS state, its device tracker included. */
 #define ITS_PKVM_PRIV_ORDER	3
 
 static int __init its_pkvm_alloc_copies(struct its_node *its,
@@ -5344,11 +5389,17 @@ static int __init its_pkvm_hand_over(struct its_node *its,
 				     its_pkvm_setup_fn setup)
 {
 	struct its_pkvm_state *st = its->pkvm;
+	int ret;
 
 	if (st->dev_l1)
 		memcpy(st->dev_l1, st->dev_baser->base, PAGE_ORDER_TO_SIZE(st->dev_baser->order));
 
-	return setup(its->phys_base, st->desc, st->desc_size);
+	ret = setup(its->phys_base, st->desc, st->desc_size);
+	if (ret < 0)
+		return ret;
+
+	st->max_devices = ret;
+	return 0;
 }
 
 static void __init its_pkvm_switch(struct its_node *its)
@@ -5357,6 +5408,8 @@ static void __init its_pkvm_switch(struct its_node *its)
 
 	its->cmd_write = (struct its_cmd_block *)st->cmdq + (its->cmd_write - its->cmd_base);
 	its->cmd_base = st->cmdq;
+	its->pkvm_max_devices = st->max_devices;
+	its->flags |= ITS_FLAGS_HYP_OWNED;
 	st->cmdq = NULL;
 	st->priv = NULL;
 
@@ -5747,6 +5800,7 @@ static struct its_node __init *its_node_init(struct resource *res,
 	mutex_init(&its->dev_alloc_lock);
 	INIT_LIST_HEAD(&its->entry);
 	INIT_LIST_HEAD(&its->its_device_list);
+	INIT_LIST_HEAD(&its->pkvm_retired);
 
 	its->typer = gic_read_typer(its_base + GITS_TYPER);
 	its->base = its_base;
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 5fc06ca11a53b..cc6279087678f 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -705,7 +705,10 @@ struct its_pkvm_desc {
 	struct its_pkvm_device	devices[];
 };
 
-/* Called with every CPU stopped, so it must not sleep. */
+/*
+ * Returns < 0 or the number of devices the hypervisor can track on this ITS.
+ * Called with every CPU stopped, so it must not sleep.
+ */
 typedef int (*its_pkvm_setup_fn)(phys_addr_t its_base,
 				 struct its_pkvm_desc *desc, size_t desc_size);
 
-- 
2.47.3

