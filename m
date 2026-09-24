Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E95A47427E;
	Thu, 24 Sep 2026 10:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790244602; cv=none; b=TZ27mzRHrm5Sw4jtmbn3FH/3gimD80/a4OfPZMKL6+XPSnO/6sG8T1absytrT0W0knmDZl3K7pVx5hiR4nhIeUK7p363j57e31+Wn74kKnvalyQSd53Hec4aoVTN9e2upPeS0XnrWnm2tyOCLx2Iu439jsTVTA46A3bRxwbkRuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790244602; c=relaxed/simple;
	bh=a5wZVDxozWcGbA+/SuJ6Ip5ryygvsJtEYlgQ+RR1o0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZfbWfPeHGvJC/4nSOP2eHVteIG7Rc8+LvHf0kwpvGRlmR07tLEroHnCtJe2jFQQ50Wl/EpVhiaSBMCddHZeyjlGR5qtIHzKTZb3OWd2zssdP8SbHnFFRxj2ilmx9hV/6SGGJGFXLJxxlTODEh02SO8xYuxJxsRhDpSbqRrRZr8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hn9hv8eW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hn9hv8eW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EA21F00893;
	Thu, 24 Sep 2026 10:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790244586;
	bh=dwj3iE+AENM1wdyeAW0ucsrV1xoTqhkmjLwoH3q3QAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hn9hv8eWpaJ0p+isry01mjUR+t12CaIbyEhnYYrvyrYgoLrjQYYfgPDJQdaSjfaPh
	 50aE3RW/t7UTODmesgPWy0ykAx61CbS4D8dbfsypnco6ojqRMUwF5OtdYDnTstc9Iz
	 8k6nZlY00DBlv3G/7lbhrvb9n8+bCjYSXakBrGqK4DtvHWl2lG8/1uIwzhqKepwQqd
	 DHbK/opblE1OlSJEblhsQ8zPACxiJ3fuzRt6fdYGbBz++jf6Za8pckAUtcXcqECLqB
	 AVrLitP9+Im6vOn8+550xQCIMvJHFC3d7TSv1eybV24j9U20ScblwOD7FdGj1Kf6sc
	 NRGOq4IPnJXrQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org,
	linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v8 14/14] irqchip/gic-v3-its: Preallocate VPE L1 tables
Date: Thu, 24 Sep 2026 15:35:29 +0530
Message-ID: <20260924100529.1398790-15-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
References: <20260924100529.1398790-1-aneesh.kumar@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

VPE L1 tables are allocated from the CPU-starting callback, where sleeping is
not allowed.  Remove the page allocation from this atomic path.

Use a blocking allocation for the boot CPU and record the resulting table
order.  Allocate a page of that order from the sleepable CPU hotplug prepare
stage for each secondary CPU.  Consume the preallocated page only when the CPU
cannot inherit an existing redistributor or ITS table.

Reclaim unused preallocations after the CPU reaches the online state, and from
the prepare-state teardown when CPU bring-up aborts.

Assisted-by: Codex:gpt-5
Cc: Marc Zyngier <maz@kernel.org>
Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Radu Rendec <radu@rendec.net>
Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c   | 110 +++++++++++++++++++++++++++--
 drivers/irqchip/irq-gic-v3.c       |   4 +-
 include/linux/irqchip/arm-gic-v3.h |   3 +-
 3 files changed, 108 insertions(+), 9 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 4814161df02e..a8f37fb97845 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -195,6 +195,7 @@ static DEFINE_PER_CPU(struct cpu_lpi_count, cpu_lpi_count);
 static LIST_HEAD(its_nodes);
 static DEFINE_RAW_SPINLOCK(its_lock);
 static struct rdists *gic_rdists;
+static unsigned int vpe_l1_prealloc_order = UINT_MAX;
 static struct irq_domain *its_parent;
 
 static unsigned long its_list_map;
@@ -2884,12 +2885,35 @@ static bool allocate_vpe_l2_table(int cpu, u32 id)
 	return true;
 }
 
-static int allocate_vpe_l1_table(void)
+static unsigned int vpe_l1_table_order(u64 val)
+{
+	unsigned int psz;
+	u64 npg;
+
+	switch (FIELD_GET(GICR_VPROPBASER_4_1_PAGE_SIZE, val)) {
+	default:
+	case GIC_PAGE_SIZE_4K:
+		psz = SZ_4K;
+		break;
+	case GIC_PAGE_SIZE_16K:
+		psz = SZ_16K;
+		break;
+	case GIC_PAGE_SIZE_64K:
+		psz = SZ_64K;
+		break;
+	}
+
+	npg = FIELD_GET(GICR_VPROPBASER_4_1_SIZE, val) + 1;
+	return get_order(npg * psz);
+}
+
+static int allocate_vpe_l1_table(bool use_prealloc)
 {
 	void __iomem *vlpi_base = gic_data_rdist_vlpi_base();
 	u64 val, gpsz, npg, pa;
 	unsigned int psz = SZ_64K;
 	unsigned int np, epp, esz;
+	unsigned int order;
 	struct page *page;
 
 	if (!gic_rdists->has_rvpeid)
@@ -2982,7 +3006,16 @@ static int allocate_vpe_l1_table(void)
 
 	pr_debug("np = %d, npg = %lld, psz = %d, epp = %d, esz = %d\n",
 		 np, npg, psz, epp, esz);
-	page = its_alloc_pages(GFP_ATOMIC | __GFP_ZERO, get_order(np * PAGE_SIZE));
+	order = get_order(np * PAGE_SIZE);
+	if (use_prealloc) {
+		if (WARN_ON_ONCE(order != vpe_l1_prealloc_order))
+			return -EINVAL;
+
+		page = gic_data_rdist()->vpe_l1_prealloc;
+		gic_data_rdist()->vpe_l1_prealloc = NULL;
+	} else {
+		page = its_alloc_pages(GFP_KERNEL | __GFP_ZERO, order);
+	}
 	if (!page)
 		return -ENOMEM;
 
@@ -2999,6 +3032,9 @@ static int allocate_vpe_l1_table(void)
 	val |= GICR_VPROPBASER_4_1_VALID;
 
 out:
+	if (!use_prealloc)
+		vpe_l1_prealloc_order = vpe_l1_table_order(val);
+
 	gicr_write_vpropbaser(val, vlpi_base + GICR_VPROPBASER);
 	cpumask_set_cpu(smp_processor_id(), gic_data_rdist()->vpe_table_mask);
 
@@ -3138,7 +3174,7 @@ static u64 its_clear_vpend_valid(void __iomem *vlpi_base, u64 clr, u64 set)
 	return val;
 }
 
-static void its_cpu_init_lpis(void)
+static void its_cpu_init_lpis(bool use_prealloc)
 {
 	void __iomem *rbase = gic_data_rdist_rd_base();
 	struct page *pend_page;
@@ -3251,7 +3287,7 @@ static void its_cpu_init_lpis(void)
 		val = its_clear_vpend_valid(vlpi_base, 0, 0);
 	}
 
-	if (allocate_vpe_l1_table()) {
+	if (allocate_vpe_l1_table(use_prealloc)) {
 		/*
 		 * If the allocation has failed, we're in massive trouble.
 		 * Disable direct injection, and pray that no VM was
@@ -5422,7 +5458,7 @@ static int redist_disable_lpis(void)
 	return 0;
 }
 
-int its_cpu_init(void)
+int its_cpu_init(bool use_prealloc)
 {
 	if (!list_empty(&its_nodes)) {
 		int ret;
@@ -5431,13 +5467,66 @@ int its_cpu_init(void)
 		if (ret)
 			return ret;
 
-		its_cpu_init_lpis();
+		its_cpu_init_lpis(use_prealloc);
 		its_cpu_init_collections();
 	}
 
 	return 0;
 }
 
+static int its_vpe_l1_prepare(unsigned int cpu)
+{
+	struct page **prealloc;
+
+	if (!gic_rdists->has_rvpeid ||
+	    vpe_l1_prealloc_order == UINT_MAX ||
+	    (gic_data_rdist_cpu(cpu)->flags & RD_LOCAL_LPI_ENABLED))
+		return 0;
+
+	prealloc = &gic_data_rdist_cpu(cpu)->vpe_l1_prealloc;
+	if (*prealloc)
+		return 0;
+
+	*prealloc = its_alloc_pages_node(cpu_to_node(cpu),
+					 GFP_KERNEL | __GFP_ZERO,
+					 vpe_l1_prealloc_order);
+	return *prealloc ? 0 : -ENOMEM;
+}
+
+static int its_vpe_l1_cleanup(unsigned int cpu)
+{
+	struct page *page;
+
+	page = xchg(&gic_data_rdist_cpu(cpu)->vpe_l1_prealloc, NULL);
+	if (page)
+		its_free_pages(page_address(page), vpe_l1_prealloc_order);
+
+	return 0;
+}
+
+static int __init its_vpe_l1_cpuhp_init(void)
+{
+	int prepare_state, state;
+
+	state = cpuhp_setup_state_nocalls(CPUHP_BP_PREPARE_DYN,
+					  "irqchip/arm/gicv3-vpe:prepare",
+					  its_vpe_l1_prepare,
+					  its_vpe_l1_cleanup);
+	if (state < 0)
+		return state;
+	prepare_state = state;
+
+	state = cpuhp_setup_state_nocalls(CPUHP_AP_ONLINE_DYN,
+					  "irqchip/arm/gicv3-vpe:online",
+					  its_vpe_l1_cleanup, NULL);
+	if (state < 0) {
+		cpuhp_remove_state_nocalls(prepare_state);
+		return state;
+	}
+
+	return 0;
+}
+
 static void rdist_memreserve_cpuhp_cleanup_workfn(struct work_struct *work)
 {
 	cpuhp_remove_state_nocalls(gic_rdists->cpuhp_memreserve_state);
@@ -5862,6 +5951,15 @@ int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
 	if (WARN_ON(!has_v4_1 && rdists->has_rvpeid))
 		rdists->has_rvpeid = false;
 
+	if (rdists->has_rvpeid) {
+		err = its_vpe_l1_cpuhp_init();
+		if (err) {
+			rdists->has_rvpeid = false;
+			rdists->has_vlpis = false;
+			pr_err("ITS: Failed to prepare VPE tables, disabling GICv4 support\n");
+		}
+	}
+
 	if (has_v4 & rdists->has_vlpis) {
 		const struct irq_domain_ops *sgi_ops;
 
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 6e1fa5b247fc..e2e00372dcfb 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1320,7 +1320,7 @@ static int gic_starting_cpu(unsigned int cpu)
 	gic_cpu_init();
 
 	if (gic_dist_supports_lpis())
-		its_cpu_init();
+		its_cpu_init(true);
 
 	return 0;
 }
@@ -2053,7 +2053,7 @@ static int __init gic_init_bases(phys_addr_t dist_phys_base,
 
 	if (gic_dist_supports_lpis()) {
 		its_init(handle, &gic_data.rdists, gic_data.domain, dist_prio_irq);
-		its_cpu_init();
+		its_cpu_init(false);
 		its_lpi_memreserve_init();
 	} else {
 		if (IS_ENABLED(CONFIG_ARM_GIC_V2M))
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index ea5fd2374ebe..a5565a745100 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -621,6 +621,7 @@ struct rdists {
 		u64             flags;
 		cpumask_t	*vpe_table_mask;
 		void		*vpe_l1_base;
+		struct page	*vpe_l1_prealloc;
 	} __percpu		*rdist;
 	phys_addr_t		prop_table_pa;
 	void			*prop_table_va;
@@ -637,7 +638,7 @@ struct rdists {
 struct irq_domain;
 struct fwnode_handle;
 int __init its_lpi_memreserve_init(void);
-int its_cpu_init(void);
+int its_cpu_init(bool use_prealloc);
 int its_init(struct fwnode_handle *handle, struct rdists *rdists,
 	     struct irq_domain *domain, u8 irq_prio);
 int mbi_init(struct fwnode_handle *fwnode, struct irq_domain *parent);
-- 
2.43.0

