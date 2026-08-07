Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com [209.85.221.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42CB947AF4D
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 16:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121037; cv=none; b=nIOGLm2FIampSRggpxQ7MCaEgfXkRXN8OJUI+uSFM4y280bt2uSyNSJoopceo7Peb6IrVpOFe48JsgLYuDAsDBYwKd+5BdS3aqgVddZIwPfQCGBZUt1TWWtnBqKr1rbYGMGWyEI0125BCGHh/s4uMqPWkRN45fmHc3MCD6aKgDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121037; c=relaxed/simple;
	bh=UTsxHC2ek2DT6ev0qCKTp9h2imFI+9o8uIR5wbfwqR4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gvBvVrPCd4aBvNZtSfdGR91xCfJtA/4X37ShpKKBQlN20IexIbdNjV2vrWdipMsn5fKL351U9D5i3eK9KYpf/iGOxvUttdhfPbmb41pWIn8OeMhzubxY6XmIJuaUBtNNXvpImdHpyiq69PYDZ4B0O/V3X0MiOCp1mVUqtMu2cZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=spkOwsfS; arc=none smtp.client-ip=209.85.221.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="spkOwsfS"
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-47f83450a8eso2984786f8f.0
        for <kvmarm@lists.linux.dev>; Fri, 07 Aug 2026 09:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786121030; x=1786725830; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DGF2g3bOrwS0bBAJ3Ttr3oRulWgqFoQx+8Dbjow6I58=;
        b=spkOwsfSCY44BOcLDYLm/aRU/Btk9X12/0wXViLqzexkG7o05prCNHiOIF8+gpd3QY
         HQ5oZGiZX9fp1w0NcoM298S6XZQYxFp7ZXf7j53pGd9E3lQ/FQ+xR8A6AzRvFC/ZoMEo
         U3bbPh9ErL17JgVDnm2B2iP/+krXP1TqWxaeabrNVOuzcdlgOxNuBTw8TdJnZVkqOzvj
         /g/vbmFVSKKT5TzQifSaVDUtQKO8Q2lgKnXpplAZZzKmHmu7W4/p4i1ZiPepMYVZ9y9e
         GpHTp+7lb4XPXliKQrSsSc83T9oDNHcCbocV5qSHFDyhVNHKh2DzTQc8prAzjkoToXl0
         kibQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121030; x=1786725830;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DGF2g3bOrwS0bBAJ3Ttr3oRulWgqFoQx+8Dbjow6I58=;
        b=DrKirMm3USRmVrN9wGA/IYZDXwEph/i98d2RQ6eu4WPzi3WbGvrmpNilB2CKHkj+aV
         TDZw3iLXVfC4s28bwCdJ1HsCOnu1V5i55PCWcSsc4V3Y3dsqe061R3T2YsgR6iDEf3gz
         qS75asTGF4/A+7qRUnULYgBhbrvrgz+dU5SpYG91wQd6ipSxL4RMGCaoJTUYxu+ORdSf
         5uQj5bv9hXV4ycZZgXHKCS21xs8C+vjJA1Uqr3WAUvPsYZf5xI94KPhSWlGx6Zfio3mU
         54rFCyH1JAF8UqkFD5L7wVFJeSDiiElRo2GCUj4CCoAk2GHdn2kX2gw2UddBP7IWAIwT
         4ZIA==
X-Gm-Message-State: AOJu0YwQS37mr7a2I9qL/KH6MjI8NIaMZWiluKr4DDzD+TwtLSX/b/3q
	Ilrcshde51XmbnuD0bvUzswIIZVp0mOVAFiofEyfXT4vibXKduEW2qD05zhCPL8D5GSpi7byq5Z
	ukRCYUY5tRsjUvrioNaeiBrmHPWDpLQ==
X-Received: from wrsn11.prod.google.com ([2002:a5d:484b:0:b0:46f:b032:2830])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2501:b0:47f:6bdf:b13a with SMTP id ffacd0b85a97d-47fec523c73mr37443105f8f.18.1786121029869;
 Fri, 07 Aug 2026 09:43:49 -0700 (PDT)
Date: Fri,  7 Aug 2026 16:43:18 +0000
In-Reply-To: <20260807164322.2970811-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260807164322.2970811-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260807164322.2970811-10-sebastianene@google.com>
Subject: [PATCH v2 08/13] KVM: arm64: Trap & emulate the ITS MAPD command
From: Sebastian Ene <sebastianene@google.com>
To: catalin.marinas@arm.com, fuad.tabba@linux.dev, joey.gouly@arm.com, 
	mark.rutland@arm.com, maz@kernel.org, oupton@kernel.org, rananta@google.com, 
	Sascha.Bischoff@arm.com, suzuki.poulose@arm.com, will@kernel.org
Cc: kvmarm@lists.linux.dev, android-kvm@google.com, bgrzesik@google.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	nathan@kernel.org, perlarsen@google.com, sebastianene@google.com, 
	seiden@linux.ibm.com, smostafa@google.com, tglx@kernel.org, 
	vdonnefort@google.com, vladimir.murzin@arm.com, yuzenghui@huawei.com, 
	zenghui.yu@linux.dev
Content-Type: text/plain; charset="UTF-8"

Parse the MAPD command and extract the ITT address to sanitize it. When
the command has the valid bit set, share and pin the memory that holds
the ITT table with the hypervisor to prevent it from being given to
someone else (eg. a VM). Use the pinning as a mechanism to get a grip
to the page and to prevent other users of the pKVM API from sharing or
donating the page for something else.
This is to prevent a a situation where a page is given to someone else
and then a MAPTI command is used to create an ITE entry in that page.

Implement shadow table updates for the first level of the indirect
tables when a MAPD command is issued. Compare the host view of the table
for the entry identified by the deviceId with the original table at the
same index and check if the valid bit is changed. If it didn't change,
don't update the original table. If it changed, verify if the new entry
has the valid bit set and donate the level2 table from the host to the
hypervisor (with the address of the table used from the new entry).
If the new entry has the valid bit cleared, donate the level2 table
from the hypervisor to the host with the address of the table extracted
from the original table managed by the hypervisor.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 arch/arm64/kvm/hyp/nvhe/its_emulate.c | 240 +++++++++++++++++++++++++-
 1 file changed, 238 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/its_emulate.c b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
index 1ce2f9d8fcf9..071a08d3602d 100644
--- a/arch/arm64/kvm/hyp/nvhe/its_emulate.c
+++ b/arch/arm64/kvm/hyp/nvhe/its_emulate.c
@@ -54,6 +54,11 @@ struct its_handler {
 	.read = (read_cb),				\
 }
 
+struct dte_entry {
+	u32	device_id;
+	u64	itt_pfn;
+};
+
 struct its_priv_state {
 	/* The location of the ITS in the hypervisor VA */
 	void __iomem	*base;
@@ -66,6 +71,9 @@ struct its_priv_state {
 	hyp_spinlock_t	its_lock;
 
 	struct its_host_state	*host_state;
+	u16			empty_entry;
+	u16			num_tracked_entries;
+	struct dte_entry	tracked_entries[];
 };
 
 #define GITS_CWRITER_RETRY	BIT_ULL(0)
@@ -110,11 +118,236 @@ static int submit_single_cmd(struct its_priv_state *its, bool retry)
 	return 0;
 }
 
+static int get_num_itt_pages(struct its_priv_state *its, u8 num_bits)
+{
+	u64 gits_typer, nr_ites;
+	size_t sz;
+
+	gits_typer = readq_relaxed(its->base + GITS_TYPER);
+	if (num_bits > FIELD_GET(GITS_TYPER_IDBITS, gits_typer))
+		return -EINVAL;
+
+	nr_ites = BIT_ULL(num_bits + 1);
+	sz = nr_ites * (FIELD_GET(GITS_TYPER_ITT_ENTRY_SIZE, gits_typer) + 1);
+	sz = max(sz, ITS_ITT_ALIGN) + ITS_ITT_ALIGN - 1;
+
+	return PAGE_ALIGN(sz) >> PAGE_SHIFT;
+}
+
+static struct its_baser *get_table_from_snapshot(struct its_host_state *host, u64 baser_type)
+{
+	int i;
+
+	for (i = 0; i < GITS_BASER_NR_REGS; i++) {
+		if (GITS_BASER_TYPE(host->tables[i].val) == baser_type)
+			return &host->tables[i];
+	}
+
+	return NULL;
+}
+
+static int check_table_update(struct its_priv_state *its, u32 device_id, u64 type, bool rollback)
+{
+	struct its_baser *table = get_table_from_snapshot(its->host_state, type);
+	size_t lvl2_entry_sz, lvl1_table_sz, num_lvl2_entries, num_lvl1_entries;
+	u64 *snapshot_table, *original_table;
+	u64 prev_entry, new_entry;
+	u32 new_entry_index;
+	int ret;
+
+	if (!table)
+		return -EINVAL;
+
+	/* We only do shadow udates for the first level of indirect tables */
+	if (!(table->val & GITS_BASER_INDIRECT))
+		return 0;
+
+	lvl2_entry_sz = GITS_BASER_ENTRY_SIZE(table->val);
+	num_lvl2_entries = table->psz / lvl2_entry_sz;
+
+	lvl1_table_sz = (1 << table->order) << PAGE_SHIFT;
+	num_lvl1_entries = lvl1_table_sz / sizeof(u64);
+
+	new_entry_index = device_id / num_lvl2_entries;
+	if (new_entry_index >= num_lvl1_entries)
+		return -ENOSPC;
+
+	snapshot_table = kern_hyp_va(table->base_snapshot);
+	original_table = kern_hyp_va(table->base);
+
+	/*
+	 * Look at the host table copy and if the entry hasn't changed the valid
+	 * bit compared to the original table used by the hardwre, don't update anything.
+	 */
+	new_entry = snapshot_table[new_entry_index];
+	prev_entry = original_table[new_entry_index];
+	if (!((new_entry ^ prev_entry) & GITS_BASER_VALID))
+		return 0;
+
+	/*
+	 * The host can play nasty tricks with read-modify-write after a
+	 * rollback is triggered but we still hold on to the original tables
+	 * which are hyp managed and we don't give back any other page to the
+	 * host.
+	 */
+	if (rollback)
+		new_entry = new_entry ^ GITS_BASER_VALID;
+
+	if (new_entry & GITS_BASER_VALID)
+		ret = __pkvm_host_donate_hyp(hyp_phys_to_pfn(new_entry & PHYS_MASK),
+					     table->psz >> PAGE_SHIFT);
+	else
+		ret = __pkvm_hyp_donate_host(hyp_phys_to_pfn(prev_entry & PHYS_MASK),
+					     table->psz >> PAGE_SHIFT);
+	if (ret)
+		return ret;
+
+	original_table[new_entry_index] = new_entry;
+	return 0;
+}
+
+static int track_pfn_add(struct its_priv_state *its, u32 device_id, u64 pfn)
+{
+	void *virt = hyp_phys_to_virt(hyp_pfn_to_phys(pfn));
+	struct dte_entry *entries = &its->tracked_entries[0];
+	bool pfn_shared = false;
+	int ret;
+	int i;
+
+	for (i = 0; i < its->num_tracked_entries; i++) {
+		if (entries[i].itt_pfn == pfn) {
+			if (entries[i].device_id != device_id) {
+				pfn_shared = true;
+				break;
+			} else {
+				return hyp_pin_shared_mem(virt, virt + PAGE_SIZE);
+			}
+		}
+	}
+
+	if (its->empty_entry >= its->num_tracked_entries)
+		return -ENOSPC;
+
+	if (!pfn_shared) {
+		ret = __pkvm_host_share_hyp(pfn);
+		if (ret)
+			return ret;
+	}
+
+	ret = hyp_pin_shared_mem(virt, virt + PAGE_SIZE);
+	if (ret) {
+		__pkvm_host_unshare_hyp(pfn);
+		return ret;
+	}
+
+	entries[its->empty_entry].itt_pfn = pfn;
+	entries[its->empty_entry].device_id = device_id;
+
+	for (i = 0; i < its->num_tracked_entries; i++) {
+		if (!entries[i].itt_pfn && !entries[i].device_id)
+			break;
+	}
+	its->empty_entry = i;
+	return 0;
+}
+
+static int track_pfn_remove(struct its_priv_state *its, u32 device_id, u64 pfn)
+{
+	void *virt = hyp_phys_to_virt(hyp_pfn_to_phys(pfn));
+	struct dte_entry *entries = &its->tracked_entries[0];
+	int ret;
+	int i;
+
+	for (i = 0; i < its->num_tracked_entries; i++) {
+		if (entries[i].itt_pfn != pfn || entries[i].device_id != device_id)
+			continue;
+
+		/* To decrement the refcount, first try to unshare it */
+		ret = __pkvm_host_unshare_hyp(pfn);
+		if (ret == -EBUSY) {
+			hyp_unpin_shared_mem(virt, virt + PAGE_SIZE);
+			ret = __pkvm_host_unshare_hyp(pfn);
+			if (ret == -EBUSY)
+				return 0;
+
+			WARN_ON(ret);
+		}
+
+		memset(&entries[i], 0, sizeof(struct dte_entry));
+		its->empty_entry = i;
+		return 0;
+	}
+
+	return -EINVAL;
+}
+
+static int track_pfn(struct its_priv_state *its, u32 device_id, u64 pfn, int num_pages,
+		     bool remove)
+{
+	int ret;
+	int i;
+
+	for (i = 0; i < num_pages; i++) {
+		if (remove)
+			ret = track_pfn_remove(its, device_id, pfn + i);
+		else
+			ret = track_pfn_add(its, device_id, pfn + i);
+
+		if (ret)
+			goto err_track_pfn;
+	}
+
+	return 0;
+err_track_pfn:
+	for (i = i - 1; i >= 0; i--) {
+		if (remove)
+			WARN_ON(track_pfn_add(its, device_id, pfn + i));
+		else
+			WARN_ON(track_pfn_remove(its, device_id, pfn + i));
+	}
+	return ret;
+}
+
+static int process_its_mapd(struct its_priv_state *its, struct its_cmd_block *cmd, bool rollback)
+{
+	phys_addr_t itt_addr = cmd->raw_cmd[2] & GENMASK(51, 8);
+	bool remove = !(cmd->raw_cmd[2] & BIT(63));
+	u8 size = cmd->raw_cmd[1] & GENMASK(4, 0);
+	u32 device_id = cmd->raw_cmd[0] >> 32;
+	int num_pages, ret;
+	u64 itt_pfn;
+
+	if (rollback)
+		remove = !remove;
+
+	itt_pfn = hyp_phys_to_pfn(itt_addr);
+	num_pages = get_num_itt_pages(its, size);
+	if (num_pages < 0)
+		return num_pages;
+
+	ret = check_table_update(its, device_id, GITS_BASER_TYPE_DEVICE, rollback);
+	if (ret)
+		return ret;
+
+	return track_pfn(its, device_id, itt_pfn, num_pages, remove);
+}
+
 static int process_cmd(struct its_priv_state *its, struct its_cmd_block *cmd,
 		       bool rollback)
 {
-	/* Passthrough everything for now */
-	return 0;
+	u8 req_type = cmd->raw_cmd[0] & GENMASK_ULL(7, 0);
+	int ret = 0;
+
+	switch (req_type) {
+	case GITS_CMD_MAPD:
+		ret = process_its_mapd(its, cmd, rollback);
+		break;
+	default:
+		/* Passthrough everything for now */
+		break;
+	}
+
+	return ret;
 }
 
 static void cwriter_write(struct pkvm_protected_reg *region, u64 offset, u64 value)
@@ -459,6 +692,9 @@ int pkvm_its_emulate_setup(phys_addr_t dev_addr, struct its_host_state *host_sta
 	priv_state->base = (void __iomem *)__hyp_va(dev_addr);
 	priv_state->cmd_original = host_state->cmd_original;
 	priv_state->cmd_host_copy = host_state->cmd_host_copy;
+	priv_state->empty_entry = 0;
+	priv_state->num_tracked_entries = ((priv_num_pages << PAGE_SHIFT) -
+		offsetof(struct its_priv_state, tracked_entries)) / sizeof(struct dte_entry);
 
 	priv_state->cmd_offset = readq_relaxed(priv_state->base + GITS_CREADR) &
 		GITS_CREADR_OFFSET;
-- 
2.55.0.654.g21b8a5bc05-goog

