Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com [209.85.128.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B104766BC
	for <kvmarm@lists.linux.dev>; Fri,  7 Aug 2026 16:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786121029; cv=none; b=jRpEe4DLNWMoY0Ohi8KsPnwNmG5kXhJlDQu5vPa/xFoMEsY4lp8PgxFgEiXvxN/S9cfyVtuOaOThK9ZcjP7MrbLDN86Wj2fnBaeRj8Hr8DtwvPOdt/ogdf/sv3T6Vm5c0jv7diXmMxfeiM+lNQh85bsvVFEGqLL9Aftk4gvwVzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786121029; c=relaxed/simple;
	bh=yGBjsaJ9hgV8fJYzvxdhdFeS0ETWRMPWiiqS4nncA1U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=pYCYEUlaMgzd8j1P5PLkMRXmJmsagOMFQ1xTtCY9dJZIB7B2T1BkqJ7fZo6l5MBKO89cLGxSwYTvUc0UMpUAYtZgQpKVcbj3zwCHnV1hCtcHmrc0SDZYn8QMn2957Czv4re7N5p6hknNy3C9AQy4vdeKRG6EqONeCUJm9JeBsZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bOaVKKMe; arc=none smtp.client-ip=209.85.128.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--sebastianene.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bOaVKKMe"
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-49561facb1dso21895455e9.3
        for <kvmarm@lists.linux.dev>; Fri, 07 Aug 2026 09:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786121025; x=1786725825; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=iZntm8VORvDjKObm+3e5kg7isnusBSNzR7FkdFCW7YM=;
        b=bOaVKKMeb+R4GrwYBbRIJS88Polq5ierv4haX3/Gq4KZlAGvHmYzO2K3gYHoFLLPxH
         j3FQ/AkXine2Wuk34XKq533pPsfq6d50OonvEM58bz43jEX7wSRXQan1CRq657A4GcGy
         EXgZwNUmTxazmzJCR8N/ajG8w7cCLeZFHayTHGmGYTv/k/JxTMXFJH2YPUVK+pe9YosZ
         MPa/7nLCzItnz9hnjDJs5zkVIJijX8F9UcFIUrnJESfGWFXLc7VLFOArte7yR6z0fj7H
         Y/V08Z7vtn6TfXmk2e9uEtPLkutHVqjOs3dxS3qRkQCs+Tt59Eic58rP59UUS4VtnC6O
         wwCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786121025; x=1786725825;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iZntm8VORvDjKObm+3e5kg7isnusBSNzR7FkdFCW7YM=;
        b=LzmxksXe+BycISDnPX76fmCKo+p9Y7/fF2QDPmmEisFEshZSK/rMlB+35jp40QG/Mx
         l8bmcJ1zmfaSQRXWc7OSxt+KqmWmLABbLNJ7SKHohQOnyHK6D+lv8ZlSWYX1yFbztEjZ
         5YslwyPPAluLs1tOZjeAHTeCPl/1TMYm6/i7NpI917IlxAUskcSPtEIbwY/3HQZ8F30F
         I7vxVrLje1Pme49XY8tci3m6PJbezmq3+vq7aK0fFq/ipreu0knRB3qZBvpCnYM6eu+t
         13KF3xZwwlZwl9dpaWQaz56ppuIQwN0ZoUWpJCz2X9mCypU7C7MqKYHRMNbesUMu72Sk
         dvPQ==
X-Gm-Message-State: AOJu0YxomQzakXy1Rz71KBs5SE1ktVnB9eHHvpgNA59t0MoU75oICvHA
	lfFJQMgLyktIRs+8y7MBTjqwa4QbKFyG6Yl4rPet9qhN+zi55wvuLH3vyN5nUuu9crhLIrTSoOX
	IYBd6yihEAwgQX0lrIseecjzPglHxyg==
X-Received: from wmsk23-n2.prod.google.com ([2002:a05:600d:8497:20b0:493:c773:ff79])
 (user=sebastianene job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4ed3:b0:493:e983:806e with SMTP id 5b1f17b1804b1-4994e72f795mr337802465e9.3.1786121025032;
 Fri, 07 Aug 2026 09:43:45 -0700 (PDT)
Date: Fri,  7 Aug 2026 16:43:15 +0000
In-Reply-To: <20260807164322.2970811-2-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260807164322.2970811-2-sebastianene@google.com>
X-Mailer: git-send-email 2.55.0.654.g21b8a5bc05-goog
Message-ID: <20260807164322.2970811-7-sebastianene@google.com>
Subject: [PATCH v2 05/13] irqchip/gic-v3-its: Add support for the ITS
 emulation setup
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
Content-Transfer-Encoding: quoted-printable

Introduce two new helper functions to allow locking the ITS and setting
up a copy of the host ITS state that will be given to the pKVM
emulation. The caller of these functions is responsible to implement a
callback which will be used to setup the emulation layer. The calling
flow is expected to do the following:

pkvm_its_emulate_setup(its_phys, host)
	// allocate memory for the priv state of the ITS emulation
	// call the its emulation setup(its_phys, host, priv_state);

pkvm_drop_host_privileges()
	its_emulate_acquire_locks(&flags);
		on_each_cpu(_kvm_host_prot_finalize, &ret, 1);
	its_emulate_release_locks(ret, &flags, pkvm_its_emulate_setup);

Augment the its_baser structure with a new fiels that will hold a
pointer to the base table copy. The gic ITS driver will use the pointer
to the base table copy when emulation is enabled, as this allows us to
hide away the original first level of an indirect table to prevent the
following:

// assumming an indirect Device Table layout
1. malicious host patches an entry in the 1st level table with an
   address that it wants to write to.
2. malicious host issues MAPD to install a DTE in the table pointed by
   the address from (1).

As the driver only manipulates a copy of the table, the emulation is
responsible for looking at the updates from the copy table, sanitizing
them and updating the original table before talking to the hardware.

In a simillar fashion, when emulation is in place we no longer let the
gic ITS driver use the original command queue but we present the driver
a copy of it and we hide away the original command queue from the driver
as this will be used entirely by the emulation layer.

Co-authored-by: Bart=C5=82omiej Grzesik <bgrzesik@google.com>
Signed-off-by: Sebastian Ene <sebastianene@google.com>
---
 drivers/irqchip/irq-gic-v3-its.c   | 157 +++++++++++++++++++++++++++--
 include/linux/irqchip/arm-gic-v3.h |  39 +++++++
 2 files changed, 185 insertions(+), 11 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-=
its.c
index 6f5811aae59c..e74ae9220af5 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -78,17 +78,6 @@ struct its_collection {
 	u16			col_id;
 };
=20
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
=20
 /*
@@ -5226,6 +5215,152 @@ static int __init its_compute_its_list_map(struct i=
ts_node *its)
 	return its_number;
 }
=20
+static void its_free_snapshot(struct its_host_state *snapshot)
+{
+	int i;
+
+	if (snapshot->cmd_host_copy)
+		its_free_pages(snapshot->cmd_host_copy, get_order(ITS_CMD_QUEUE_SZ));
+
+	for (i =3D 0; i < GITS_BASER_NR_REGS; i++) {
+		if (!snapshot->tables[i].base_snapshot)
+			continue;
+
+		its_free_pages(snapshot->tables[i].base_snapshot, snapshot->tables[i].or=
der);
+	}
+
+	its_free_pages(snapshot, 0);
+}
+
+static struct its_host_state *its_snapshot_host_state(struct its_node *its=
)
+{
+	void *page;
+	struct its_host_state *snapshot;
+	int i;
+
+	page =3D its_alloc_pages_node(its->numa_node, GFP_ATOMIC | __GFP_ZERO, 0)=
;
+	if (!page)
+		return NULL;
+
+	snapshot =3D (void *)page_address(page);
+	page =3D its_alloc_pages_node(its->numa_node, GFP_ATOMIC | __GFP_ZERO,
+				    get_order(ITS_CMD_QUEUE_SZ));
+	if (!page)
+		goto err_alloc;
+
+	snapshot->cmd_host_copy	=3D page_address(page);
+	snapshot->cmdq_len	=3D ITS_CMD_QUEUE_SZ;
+	snapshot->cmd_original	=3D its->cmd_base;
+	snapshot->cmd_write	=3D its->cmd_write;
+
+	memcpy(snapshot->tables, its->tables, sizeof(struct its_baser) * GITS_BAS=
ER_NR_REGS);
+
+	for (i =3D 0; i < GITS_BASER_NR_REGS; i++) {
+		if (!(snapshot->tables[i].val & GITS_BASER_VALID))
+			continue;
+
+		if (!(snapshot->tables[i].val & GITS_BASER_INDIRECT))
+			continue;
+
+		page =3D its_alloc_pages_node(its->numa_node,
+					    GFP_ATOMIC | __GFP_ZERO,
+					    snapshot->tables[i].order);
+		if (!page)
+			goto err_alloc;
+
+		snapshot->tables[i].base_snapshot =3D page_address(page);
+
+		memcpy(snapshot->tables[i].base_snapshot, snapshot->tables[i].base,
+		       PAGE_ORDER_TO_SIZE(snapshot->tables[i].order));
+	}
+
+	return snapshot;
+
+err_alloc:
+	its_free_snapshot(snapshot);
+	return NULL;
+}
+
+static int its_emulate_switch_queues_locked(struct its_node *its, its_emul=
ate_setup cb)
+{
+	struct its_host_state *host_snaphsot, host;
+	int i, ret;
+	u64 baser_phys;
+
+	host_snaphsot =3D its_snapshot_host_state(its);
+	if (!host_snaphsot)
+		return -ENOMEM;
+
+	/*
+	 * The snapshot of the ITS state will be given to the emulation, make a c=
opy of it
+	 * so that we don't go in weeds.
+	 */
+	memcpy(&host, host_snaphsot, sizeof(host));
+
+	ret =3D cb(its->phys_base, host_snaphsot);
+	if (ret) {
+		its_free_snapshot(host_snaphsot);
+		return ret;
+	}
+
+	/* Switch the driver command queue to use the host copy and update the wr=
ite index */
+	its->cmd_write =3D (its->cmd_write - its->cmd_base) +
+		(struct its_cmd_block *)host.cmd_host_copy;
+	its->cmd_base =3D host.cmd_host_copy;
+
+	/*
+	 * Replace the first level of the indirect tables with the snapshot table=
 as the
+	 * emulation layer will make it innaccessible to the host.
+	 */
+	for (i =3D 0; i < GITS_BASER_NR_REGS; i++) {
+		if (!(host.tables[i].val & GITS_BASER_INDIRECT))
+			continue;
+
+		baser_phys =3D virt_to_phys(host.tables[i].base_snapshot);
+		if (IS_ENABLED(CONFIG_ARM64_64K_PAGES) && (baser_phys >> 48))
+			baser_phys =3D GITS_BASER_PHYS_52_to_48(baser_phys);
+
+		its->tables[i].val &=3D ~GENMASK(47, 12);
+		its->tables[i].val |=3D baser_phys;
+		its->tables[i].base =3D host.tables[i].base_snapshot;
+	}
+
+	return 0;
+}
+
+void its_emulate_acquire_locks(unsigned long *flags)
+{
+	struct its_node *its;
+
+	if (WARN_ON(!flags))
+		return;
+
+	raw_spin_lock_irqsave(&its_lock, *flags);
+
+	list_for_each_entry(its, &its_nodes, entry)
+		raw_spin_lock(&its->lock);
+}
+
+int its_emulate_release_locks(int ret_pkvm_finalize, unsigned long *flags,=
 its_emulate_setup cb)
+{
+	struct its_node *its;
+	int ret =3D 0;
+
+	if (WARN_ON(!flags || !cb))
+		ret =3D -EINVAL;
+
+	list_for_each_entry(its, &its_nodes, entry) {
+		if (!ret_pkvm_finalize && !ret)
+			ret =3D its_emulate_switch_queues_locked(its, cb);
+
+		raw_spin_unlock(&its->lock);
+	}
+
+	raw_spin_unlock_irqrestore(&its_lock, *flags);
+
+	return ret;
+}
+
 static int __init its_probe_one(struct its_node *its)
 {
 	u64 baser, tmp;
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm=
-gic-v3.h
index ea5fd2374ebe..b75f82cef4bf 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -657,6 +657,45 @@ static inline bool gic_enable_sre(void)
 	return !!(val & ICC_SRE_EL1_SRE);
 }
=20
+/*
+ * The ITS_BASER structure - contains memory information, cached
+ * value of BASER register configuration and ITS page size.
+ */
+struct its_baser {
+	void		*base;
+
+	/*
+	 * The table used when emulation is in place and indirect layout is
+	 * configured.
+	 */
+	void		*base_snapshot;
+	u64		val;
+	u32		order;
+	u32		psz;
+};
+
+struct its_host_state {
+	struct its_baser	tables[GITS_BASER_NR_REGS];
+
+	/* The command queue used after the emulation is in place */
+	void			*cmd_host_copy;
+
+	/* The command queue configured by the ITS driver at boot */
+	void			*cmd_original;
+	void			*cmd_write;
+	size_t			cmdq_len;
+};
+
+/*
+ * Callback used to initialize the emulation. It is expected to allocate m=
emory for the private
+ * state of the emulation and receive as arguments copy of the host ITS dr=
iver state along
+ * with the address of the ITS.
+ */
+typedef int (*its_emulate_setup)(phys_addr_t its_phys_base, struct its_hos=
t_state *host);
+
+void its_emulate_acquire_locks(unsigned long *flags);
+int its_emulate_release_locks(int ret_pkvm_finalize, unsigned long *flags,=
 its_emulate_setup cb);
+
 #endif
=20
 #endif
--=20
2.55.0.654.g21b8a5bc05-goog

