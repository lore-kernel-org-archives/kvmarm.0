Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.222
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793624544;
	b=jev7FsN2mES87w9Q4I1b5Vc8stBMayzjnhonMMRbjCM+mZV240s7ozGqhuD16VmKxHww
	 T3inzVcxquMYrIltyyFIA6TUKwaSE2BALbHIQi3b3o3lKYr9v296C+nEzG0ekBerVzOFF
	 HHPdaPHj6wRcbGGOfnbGBD5rXcXRmS7eUVFDuWlcnt6OcCOFgQGJj1/Ox5a2Cw+Pce2eB
	 pcntKSWcowHNS30FkJQzmotgeSVrbXXmsBykt43+aB8Qr59/c5XfjtKtgzYB3gf6PCSKo
	 DNUdR64jDpDRRRVgd9CzRm1c9MhUlnmb8S9Ryfdr8v2xJGkPCJkTRCOq2ZxpHHdS+7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793624544;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=CymCqQhnwGQ8ykN04vzZ+QXQ6Cw2EgysGXkjVS3jg14=;
	b=aQig439asg+LVZRJ0x+h7tHt57uuvsys/+n5NHbbT0a+nitNUCiglusjctcsj+7GWwkS
	 4zB4X102n/4w8y+812QEjbesVUD29iRicv/XWlGZ6luj0VVXsBYqZH1hb0UTKaizczTFs
	 3a12eRFuOOxrQsE9uy+v0Fe4FAjfV59m25t+PuAl2aalc8Vl6PxXShmRdoYG/DUbylizq
	 OU+BMjcE9dCC29VqelL+bO4AaKXDrquIfytJC6+lEv6lGo+KZK0ccNTfWwmqc0b5XVNvm
	 Afz5sZoVZT7K3ONaHqvMRMRPx8EmCHuVbpt8J7ePJ6pkv3Ay0Zv3RDW9guQ5Wh+Qg+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=s1M4fIxk;
	arc=none smtp.remote-ip=95.215.58.222
Received: from mta1.migadu.com (out-222.mta1.migadu.com [95.215.58.222])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FC160A261F
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 13:02:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E5FC160A261F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=s1M4fIxk
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=sm9tvxRkEIbUhHsTo0aDSC4gFJooOrCmMFe0SeS+JH0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793624542; v=1; x=1794229342;
 b=s1M4fIxkFohkWjHkpEaCpAp43XHKaIbY/LfVLwcSTOIi9FhVeatcBA2FlWxlDbOIoeBp5edS
 Bl7/RQl24G65F22Sp9uCvIDvkz2aZnYTnyPcMTtmTN0rRH2ZTMJcPw5gzxZqk8xfIjWErGQOvMb
 dHOC2OrDJOLxLAmTzMBzFOZ4=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id ef937f32c8c26a98;
	Mon, 02 Nov 2026 13:02:21 +0000
X-Mizu-Trace-ID: ef937f32c8c26a98
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
Subject: [PATCH v3 08/13] irqchip/gic-v3-its: Add the protected-KVM takeover entry points
Date: Mon,  2 Nov 2026 13:01:28 +0000
Message-ID: <20261102130133.3684226-9-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102130133.3684226-1-fuad.tabba@linux.dev>
References: <20261102130133.3684226-1-fuad.tabba@linux.dev>
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

Under protected KVM the hypervisor takes the memory the ITS reads its
command queue and tables from. From the takeover on, the driver writes
its commands and level-1 device table entries into copies that the
hypervisor checks before the ITS sees them.

Add the driver's side of the takeover KVM runs at deprivilege, in three
steps. its_pkvm_setup_prepare() allocates the copies and the pages the
hypervisor keeps its state in, and lists the devices already mapped,
with their ITTs, as the ITS's own record of them is IMPLEMENTATION
DEFINED. It holds every ITS's dev_alloc_lock, which device creation and
teardown already take, until its_pkvm_setup_finish(), so the list stays
exact.

its_pkvm_setup_commit() runs with every CPU stopped, and switches the
driver to its copies only once the hypervisor has taken every ITS, so a
failure leaves the driver on the hardware queues. If the switch didn't
run, finish frees the copies and the state pages. After a failed commit,
that includes the state of an ITS the hypervisor took, which the host
can still use as no CPU is deprivileged.

its_pkvm_iter_its() gives KVM each ITS's base, to register the control
frames before the hypervisor initialises. Nothing calls these yet.

Signed-off-by: Sebastian Ene <sebastianene@google.com>
Co-developed-by: Bartłomiej Grzesik <bgrzesik@google.com>
Signed-off-by: Bartłomiej Grzesik <bgrzesik@google.com>
Co-developed-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    Changes since v2 (v2 patch 05):
    - Prepare, commit and finish entry points replace the lock pair KVM
      held across on_each_cpu() with IRQs off (sashiko)
    - Prepare does every allocation before stop_machine(), with
      GFP_KERNEL rather than GFP_ATOMIC under raw spinlocks (sashiko)
    - Commit runs in the deprivilege's stop_machine() callback, and the
      driver switches to its copies only once every ITS is taken
      (sashiko)
    - Every ITS's dev_alloc_lock is held from prepare to finish
    - The descriptor names memory only: the state pages, the queue copy
      and the devices already mapped (was register values and its_baser)

 drivers/irqchip/irq-gic-v3-its.c   | 186 +++++++++++++++++++++++++++++
 include/linux/irqchip/arm-gic-v3.h |  31 +++++
 2 files changed, 217 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 3e27c7d58e024..298e4ca1b0759 100644
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
@@ -5243,6 +5245,190 @@ static int __init its_compute_its_list_map(struct its_node *its)
 	return its_number;
 }
 
+/*
+ * Protected KVM: from the takeover on, the driver writes commands into a copy
+ * of the command queue, and the hypervisor checks each before the ITS sees it.
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
+	struct its_pkvm_state *st;
+	struct its_pkvm_desc *desc;
+	struct its_device *dev;
+	u32 nr_devices = 0;
+	struct page *page;
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
+	list_for_each_entry(dev, &its->its_device_list, entry)
+		nr_devices++;
+
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
+ * The protected-KVM takeover: prepare builds each ITS's descriptor and holds
+ * off device creation, commit hands every ITS to the hypervisor with every
+ * other CPU parked in stop_machine(), and finish frees what the driver no
+ * longer uses. Call finish after prepare, whatever either returns.
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
index e0bec40adf2b7..a708e188898ef 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -679,6 +679,37 @@ static inline u64 its_cmd_mask_field(u64 *its_cmd, int word, int shift, int size
 #define its_cmd_get_target_addr(cmd)	its_cmd_mask_field(cmd, 2, 16, 32)
 #define its_cmd_get_validbit(cmd)	its_cmd_mask_field(cmd, 2, 63,  1)
 
+/* A device the driver mapped before the hypervisor took over the ITS. */
+struct its_pkvm_device {
+	u64		itt_pa;
+	u32		device_id;
+	u8		event_bits;
+};
+
+/*
+ * What the host hands the hypervisor at setup: pages for its per-ITS state,
+ * and the memory it cannot discover from the ITS itself. Physical addresses,
+ * page-aligned.
+ */
+struct its_pkvm_desc {
+	u64			priv_pa;
+	u64			priv_pages;
+	u64			cmdq_copy_pa;
+	u32			nr_devices;
+	struct its_pkvm_device	devices[];
+};
+
+/* Called with every CPU parked: no allocation. */
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

