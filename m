Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0875141A510;
	Mon,  3 Aug 2026 13:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785764687; cv=none; b=l6RChCX2Ufp8Dr6yM8kkvgZKhqPnmgQCOCP8OXebtNukmXJ0oEwKHogtlMxbPjUh8FkdKEH7DKPmCGKLq8ADFNaySaguN0C5XIFSe9MAXumSlynwMQd0tModjaypnZ5uhvZBTmkm4guGPLPgnc7XIMcydIh7oCuMqqQQ4Jx4b/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785764687; c=relaxed/simple;
	bh=nPF/ZhgiMk9bT/ySrNjtkfhDkfa90yGsUJUy9W38zhU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j5W84WHSxCEB/GWA39rm+Fx8O6gE6Rt5qeipApD3ptl2wtoCGKs3w7zSXmu1zel0/Uuj9X+htd11Rp0oUzTl3ATrDryHO9hgctyXkqOAe724YWWxdsT7QRfo4tG8BTV5kC3mKbmenIvqK91cBVJvHRVvxCBVm3QLOqp6xtjluys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=kR91DteK; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="kR91DteK"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 868881655;
	Mon,  3 Aug 2026 06:44:41 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8BACD3F66F;
	Mon,  3 Aug 2026 06:44:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785764685; bh=nPF/ZhgiMk9bT/ySrNjtkfhDkfa90yGsUJUy9W38zhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kR91DteKvJS1LNtN2AMmFtMDm+A51cVL/ppCZeYK7/mdjFJv2m+5TobVw1Z9yXwjQ
	 GZbo8CsDIXv7d6zikoia3JH8GOdV3eD+jeGocm1BEBBxQ8GMqv4TMo4qPFprunnUzT
	 yPZK6e1y1RSQnmYc4y8JDF4fo/Oam5hPmpNn9X9Y=
From: Steven Price <steven.price@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	Gavin Shan <gshan@redhat.com>,
	Shanker Donthineni <sdonthineni@nvidia.com>,
	Alper Gun <alpergun@google.com>,
	"Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
	Emi Kisanuki <fj0570is@fujitsu.com>,
	Vishal Annapurve <vannapurve@google.com>,
	WeiLin.Chang@arm.com,
	Lorenzo Pieralisi <lpieralisi@kernel.org>
Subject: [PATCH v16 06/45] firmware: arm_rmm: Ensure the RMM has GPT entries for memory
Date: Mon,  3 Aug 2026 14:43:22 +0100
Message-ID: <20260803134403.80630-7-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260803134403.80630-1-steven.price@arm.com>
References: <20260803134403.80630-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The RMM maintains the state of all the granules in the system to make
sure that the host is abiding by the rules. This state can be maintained
at different granularity, per page (TRACKING_FINE) or per region
(TRACKING_COARSE). The region size depends on the underlying
"RMI_GRANULE_SIZE". For a "coarse" region all pages in the region must
be of the same state, this implies we need to have "fine" tracking for
DRAM, so that we can delegate individual pages.

For now we only support a statically carved out memory for tracking
granules for the "fine" regions. This can be extended in the future to
allow modifying the tracking granularity and remove the need for a
static allocation.

Similarly, the firmware may create L0 GPT entries describing the total
address space. But if we change the "PAS" (Physical Address Space) of a
granule then the firmware may need to create L1 tables to track the PAS
at a finer granularity.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v15:
 * Skip firmware-reserved NOMAP memory in rmi_init_metadata()
 * Handle negative error codes from wrappers.
Changes since v14:
 * Move the implementation into drivers/firmware/arm_rmm.
Changes since v13:
 * Moved out of KVM
---
 drivers/firmware/arm_rmm/rmi.c | 101 +++++++++++++++++++++++++++++++++
 include/linux/arm-rmi-cmds.h   |   2 +
 2 files changed, 103 insertions(+)

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index 51ea661cecf9..bce3304bbc1a 100644
--- a/drivers/firmware/arm_rmm/rmi.c
+++ b/drivers/firmware/arm_rmm/rmi.c
@@ -12,6 +12,8 @@
 #include <asm/memory.h>
 #include <asm/pgtable-hwdef.h>
 
+static bool arm64_rmi_is_available;
+
 /* Currently only the first 2 registers are used by Linux */
 #define RMI_FEAT_REG_COUNT	2
 static __ro_after_init unsigned long rmi_feat_reg_cache[RMI_FEAT_REG_COUNT];
@@ -647,6 +649,98 @@ static int rmi_configure(void)
 	return ret;
 }
 
+/*
+ * Make sure the area is tracked by RMM at FINE granularity.
+ * We do not support changing the tracking yet.
+ */
+static int rmi_verify_memory_tracking(phys_addr_t start, phys_addr_t end)
+{
+	while (start < end) {
+		unsigned long ret, category, state, next;
+
+		ret = rmi_granule_tracking_get(start, end, &category, &state, &next);
+		if (ret != RMI_SUCCESS ||
+		    state != RMI_TRACKING_FINE ||
+		    category != RMI_MEM_CATEGORY_CONVENTIONAL) {
+			/* TODO: Set granule tracking in this case */
+			pr_err("Granule tracking for region isn't fine/conventional: %llx\n",
+			       start);
+			return -ENODEV;
+		}
+		start = next;
+	}
+
+	return 0;
+}
+
+static int rmi_create_gpts(phys_addr_t start, phys_addr_t end)
+{
+	struct rmi_sro_state *sro;
+	unsigned long l0gpt_sz;
+
+	sro = kmalloc_obj(*sro, GFP_KERNEL);
+	if (!sro)
+		return -ENOMEM;
+
+	l0gpt_sz = 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
+					  rmi_feat_reg(1)));
+	start = ALIGN_DOWN(start, l0gpt_sz);
+	end = ALIGN(end, l0gpt_sz);
+
+	while (start < end) {
+		long ret = rmi_gpt_l1_create(start, sro, GFP_KERNEL);
+
+		/*
+		 * Make sure the L1 GPT tables are created for the region.
+		 * RMI_ERROR_GPT indicates the L1 table already exists.
+		 */
+		if (ret < 0) {
+			kfree(sro);
+			return ret;
+		}
+
+		if (ret != RMI_SUCCESS && RMI_RETURN_STATUS(ret) != RMI_ERROR_GPT) {
+			pr_err("GPT Level1 table missing for %llx\n", start);
+			kfree(sro);
+			return -ENOMEM;
+		}
+		start += l0gpt_sz;
+	}
+
+	kfree(sro);
+	return 0;
+}
+
+static int rmi_init_metadata(void)
+{
+	phys_addr_t start, end;
+	struct memblock_region *r;
+
+	for_each_mem_region(r) {
+		int ret;
+
+		/* Firmware-reserved NOMAP regions are not usable system RAM */
+		if (memblock_is_nomap(r))
+			continue;
+
+		start = memblock_region_memory_base_pfn(r) << PAGE_SHIFT;
+		end = memblock_region_memory_end_pfn(r) << PAGE_SHIFT;
+		ret = rmi_verify_memory_tracking(start, end);
+		if (ret)
+			return ret;
+		ret = rmi_create_gpts(start, end);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
+bool is_rmi_available(void)
+{
+	return arm64_rmi_is_available;
+}
+
 static int __init arm64_init_rmi(void)
 {
 	int ret;
@@ -664,6 +758,13 @@ static int __init arm64_init_rmi(void)
 	if (ret)
 		return ret;
 
+	ret = rmi_init_metadata();
+	if (ret)
+		return ret;
+
+	arm64_rmi_is_available = true;
+	pr_info("RMI configured\n");
+
 	return 0;
 }
 
diff --git a/include/linux/arm-rmi-cmds.h b/include/linux/arm-rmi-cmds.h
index 8814708536d6..805a7ed9fc00 100644
--- a/include/linux/arm-rmi-cmds.h
+++ b/include/linux/arm-rmi-cmds.h
@@ -37,6 +37,8 @@ static inline int rmi_undelegate_page(phys_addr_t phys)
 	return rmi_undelegate_range(phys, PAGE_SIZE);
 }
 
+bool is_rmi_available(void);
+
 long rmi_sro_memxfer_execute(struct rmi_sro_state *sro, gfp_t gfp);
 void rmi_sro_free(struct rmi_sro_state *sro);
 long rmi_sro_execute(struct arm_smccc_1_2_regs *regs);
-- 
2.43.0

