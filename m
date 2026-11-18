Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015186;
	b=wQfkT9c9yKnZlOHgNjNSwkcOLPIzRWrYE+XRWjEJTkOYcRo0PygZVK6TW0lmFXol6fV5
	 VlJnrKQrYIEsAslayFyfXXhKmBd60t6D2LAlA3/nC2Lqdm3JosaOl9t+cJRXzJQHYizV4
	 dvqkVJxdxQ7z4MWOkx9S5MlgdsalHXvANAU1b71G8gJCKxh6qMa2Ovvgancn9jZpjyh4b
	 UBmqjmqHd9KSTaWzeKwa9Kk4N79aHgDTFuox6icaOSuPGwb28otH44GCABzJIdshQz6dr
	 J3IPMC5T1M9Zab0v2xnXHFCJ2mgC4/TgmR6Vrn/TiIhWPNpyYqcHcx5jHPJa/2DlMqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015186;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=Am2G4Ec3/lCwx/EtzJWVjgHe9ZeFgXdPk5Ye+c56A/o=;
	b=01t8E+D8WVvKQgKdVqbJ4dAwrRfH/Za6Q6LQ7Oh4A5YZix2egRMOn2vuTVNJslAqVGIa
	 QuJV01vEEk1OPA5sLQqGrh11gKLDyASaprR+Tc/PGCzfhkSIqXonPKJvncFKe2cMzkBW+
	 9zTSda9pft25Llsso2WuFEWtlGyO16wHaeT9i2/04SZUX+4MhQWALmLyNsFX2azpI6qW9
	 sv/plq2+bsELMD9zNaJZ9SeoZtLTWlfx/qro+pAWjCFzs56SAA4wojkRVJQ4dB2YMbIYr
	 y3G+XgJdOgTnBWiFXvaXwQBoRK63ewtWwjkqAeJhFEydant4oo+1/ITLKlFyIFsa+JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mxpXzTRD;
	arc=none smtp.remote-ip=95.215.58.12
Received: from mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A8EF606A32F
	for <kvmarm@lists.linux.dev>; Wed, 18 Nov 2026 15:19:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A8EF606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=mxpXzTRD
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=xgOACI7hDb+NWm7heyjcaJa40m5EkI5n+6xLOzvOq1E=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795015184; v=1; x=1795619984;
 b=mxpXzTRD9uIr0C/15XnTpW5g1YHPSlNPFjvtFkLBuG4sl4qws8BnMfnANs9o5sKm8CbGJblC
 tSx1m0OuRex26GVBoWr7hz075srSCqr6RJtsZznUrOkWgGz76BNIYGXRvP7dkAiUnrs1OSJGA6m
 G82KwImpcDf5sFic882JWA+M=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 45885d4dee9c3a2b;
	Wed, 18 Nov 2026 15:19:44 +0000
X-Mizu-Trace-ID: 45885d4dee9c3a2b
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
Subject: [PATCH v4 08/13] irqchip/gic-v3-its: Add the pKVM takeover entry points
Date: Wed, 18 Nov 2026 15:18:59 +0000
Message-ID: <20261118151904.4099560-9-fuad.tabba@linux.dev>
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

From: Sebastian Ene <sebastianene@google.com>

In a subsequent patch the pKVM hypervisor takes the ITS command queue
from the host. From then on, the driver writes its commands into a copy
that the hypervisor checks before the ITS sees them.

Add the driver's side of the takeover, which KVM runs in three steps
when it deprivileges the host. its_pkvm_setup_prepare() allocates the
copy and the pages the hypervisor keeps its state in, and lists the
devices already mapped, with their ITTs, as the ITS's own record of them
is IMPLEMENTATION DEFINED. It holds every ITS's dev_alloc_lock until
its_pkvm_setup_finish(), so the list stays exact.

its_pkvm_setup_commit() runs with every CPU stopped, and switches the
driver to its copies only once the hypervisor has taken every ITS, so a
failure leaves the driver on the hardware queues. If the commit fails,
no CPU is deprivileged, and its_pkvm_setup_finish() frees everything
prepare allocated, including the pages the hypervisor had taken.

its_pkvm_iter_its() gives KVM each ITS's base, so that KVM can register
the control frames before the hypervisor initialises. These functions
don't have a caller yet.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Co-developed-by: Bartłomiej Grzesik <bgrzesik@google.com>
Signed-off-by: Bartłomiej Grzesik <bgrzesik@google.com>
Co-developed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 drivers/irqchip/irq-gic-v3-its.c   | 183 +++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v3.h |  27 +++++
 2 files changed, 210 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index df6d7b2fc8611..d98e05557a296 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -92,6 +92,7 @@ struct its_baser {
 };
 
 struct its_device;
+struct its_pkvm_state;
 
 /*
  * The ITS structure - contains most of the infrastructure, with the
@@ -126,6 +127,7 @@ struct its_node {
 	unsigned int		msi_domain_flags;
 	u32			pre_its_base; /* for Socionext Synquacer */
 	int			vlpi_redist_offset;
+	struct its_pkvm_state	*pkvm;
 };
 
 static DEFINE_PER_CPU(struct its_node *, local_4_1_its);
@@ -5242,6 +5244,187 @@ static int __init its_compute_its_list_map(struct its_node *its)
 	return its_number;
 }
 
+/*
+ * In pKVM, the driver writes its commands into a copy of the command queue,
+ * and the hypervisor checks each one before the ITS sees it.
+ */
+struct its_pkvm_state {
+	void			*priv;
+	void			*cmdq;
+	struct its_pkvm_desc	*desc;
+	size_t			desc_size;
+};
+
+/* Held, with every ITS's dev_alloc_lock, from prepare to finish. */
+static DEFINE_MUTEX(its_pkvm_lock);
+
+/* Pages for the hypervisor's per-ITS state. */
+#define ITS_PKVM_PRIV_ORDER	3
+
+static int __init its_pkvm_alloc_copies(struct its_node *its,
+					struct its_pkvm_state *st)
+{
+	struct page *page;
+
+	page = its_alloc_pages_node(its->numa_node, GFP_KERNEL, ITS_PKVM_PRIV_ORDER);
+	if (!page)
+		return -ENOMEM;
+	st->priv = page_address(page);
+
+	page = its_alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO,
+				    get_order(ITS_CMD_QUEUE_SZ));
+	if (!page)
+		return -ENOMEM;
+	st->cmdq = page_address(page);
+
+	return 0;
+}
+
+static int __init its_pkvm_prepare_one(struct its_node *its)
+{
+	struct its_pkvm_desc *desc;
+	struct its_pkvm_state *st;
+	struct its_device *dev;
+	struct page *page;
+	u32 nr_devices;
+	int i, ret;
+
+	st = kzalloc_obj(*st);
+	if (!st)
+		return -ENOMEM;
+	its->pkvm = st;
+
+	mutex_lock_nest_lock(&its->dev_alloc_lock, &its_pkvm_lock);
+
+	ret = its_pkvm_alloc_copies(its, st);
+	if (ret)
+		return ret;
+
+	nr_devices = list_count_nodes(&its->its_device_list);
+	st->desc_size = PAGE_ALIGN(struct_size(desc, devices, nr_devices));
+	page = its_alloc_pages_node(its->numa_node, GFP_KERNEL | __GFP_ZERO,
+				    get_order(st->desc_size));
+	if (!page)
+		return -ENOMEM;
+	desc = page_address(page);
+	st->desc = desc;
+
+	desc->priv_pa = virt_to_phys(st->priv);
+	desc->priv_pages = 1 << ITS_PKVM_PRIV_ORDER;
+	desc->cmdq_copy_pa = virt_to_phys(st->cmdq);
+
+	i = 0;
+	list_for_each_entry(dev, &its->its_device_list, entry) {
+		desc->devices[i].itt_pa = virt_to_phys(dev->itt);
+		desc->devices[i].device_id = dev->device_id;
+		desc->devices[i].event_bits = ilog2(dev->nr_ites);
+		i++;
+	}
+	desc->nr_devices = nr_devices;
+
+	return 0;
+}
+
+static int __init its_pkvm_hand_over(struct its_node *its,
+				     its_pkvm_setup_fn setup)
+{
+	struct its_pkvm_state *st = its->pkvm;
+
+	return setup(its->phys_base, st->desc, st->desc_size);
+}
+
+static void __init its_pkvm_switch(struct its_node *its)
+{
+	struct its_pkvm_state *st = its->pkvm;
+
+	its->cmd_write = (struct its_cmd_block *)st->cmdq + (its->cmd_write - its->cmd_base);
+	its->cmd_base = st->cmdq;
+	st->cmdq = NULL;
+	st->priv = NULL;
+}
+
+static void __init its_pkvm_finish_one(struct its_node *its)
+{
+	struct its_pkvm_state *st = its->pkvm;
+
+	if (st->priv)
+		its_free_pages(st->priv, ITS_PKVM_PRIV_ORDER);
+	if (st->cmdq)
+		its_free_pages(st->cmdq, get_order(ITS_CMD_QUEUE_SZ));
+
+	if (st->desc)
+		its_free_pages(st->desc, get_order(st->desc_size));
+
+	mutex_unlock(&its->dev_alloc_lock);
+	kfree(st);
+	its->pkvm = NULL;
+}
+
+/*
+ * KVM calls prepare, commit and finish, in that order, to hand every ITS to the
+ * hypervisor. Commit runs with the other CPUs stopped. Finish must follow
+ * prepare, whatever prepare or commit returned.
+ */
+int __init its_pkvm_setup_prepare(void)
+{
+	struct its_node *its;
+	int ret;
+
+	mutex_lock(&its_pkvm_lock);
+
+	list_for_each_entry(its, &its_nodes, entry) {
+		ret = its_pkvm_prepare_one(its);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+int __init its_pkvm_setup_commit(its_pkvm_setup_fn setup)
+{
+	struct its_node *its;
+	int ret;
+
+	/* The driver switches to its copies only once every ITS is taken. */
+	list_for_each_entry(its, &its_nodes, entry) {
+		ret = its_pkvm_hand_over(its, setup);
+		if (ret)
+			return ret;
+	}
+
+	list_for_each_entry(its, &its_nodes, entry)
+		its_pkvm_switch(its);
+
+	return 0;
+}
+
+void __init its_pkvm_setup_finish(void)
+{
+	struct its_node *its;
+
+	list_for_each_entry(its, &its_nodes, entry) {
+		if (its->pkvm)
+			its_pkvm_finish_one(its);
+	}
+
+	mutex_unlock(&its_pkvm_lock);
+}
+
+int __init its_pkvm_iter_its(its_pkvm_its_fn fn)
+{
+	struct its_node *its;
+	int ret;
+
+	list_for_each_entry(its, &its_nodes, entry) {
+		ret = fn(its->phys_base);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int __init its_probe_one(struct its_node *its)
 {
 	u64 baser, tmp;
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index e0bec40adf2b7..1d31d5a72e009 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -679,6 +679,33 @@ static inline u64 its_cmd_mask_field(u64 *its_cmd, int word, int shift, int size
 #define its_cmd_get_target_addr(cmd)	its_cmd_mask_field(cmd, 2, 16, 32)
 #define its_cmd_get_validbit(cmd)	its_cmd_mask_field(cmd, 2, 63,  1)
 
+/* A device the driver mapped before the hypervisor took over the ITS. */
+struct its_pkvm_device {
+	phys_addr_t	itt_pa;
+	u32		device_id;
+	u8		event_bits;
+};
+
+/* Passed to the hypervisor at setup. Every address is physical and page-aligned. */
+struct its_pkvm_desc {
+	phys_addr_t		priv_pa;
+	u64			priv_pages;
+	phys_addr_t		cmdq_copy_pa;
+	u32			nr_devices;
+	struct its_pkvm_device	devices[];
+};
+
+/* Called with every CPU stopped, so it must not sleep. */
+typedef int (*its_pkvm_setup_fn)(phys_addr_t its_base,
+				 struct its_pkvm_desc *desc, size_t desc_size);
+
+typedef int (*its_pkvm_its_fn)(phys_addr_t its_base);
+
+int its_pkvm_setup_prepare(void);
+int its_pkvm_setup_commit(its_pkvm_setup_fn setup);
+void its_pkvm_setup_finish(void);
+int its_pkvm_iter_its(its_pkvm_its_fn fn);
+
 #endif
 
 #endif
-- 
2.47.3

