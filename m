Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 812B43016F7;
	Wed, 13 May 2026 13:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778678347; cv=none; b=bCOmXBJ+VkRLQB4Drr0KWpSyQIBWj2jL1Sc1rUhqnTGnzVjnmqCFsOgGTNIXadtQ1qPHiuKjME5MalMgKu/Ql7RECA3B4zhgM2433Zn2PhhMjsTQ3ib5F9Auv3SBKVtx8eMlcY9+pZqL5flqQ+lcmLj69HW3Itd2zHblk5wwRdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778678347; c=relaxed/simple;
	bh=trQyw0PdE9XkuPVCbvJDXHI7TLzpH6OvqtkqRmWtuNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aVNpR70ZXHKlLLscx8xoOTS9E/k8Bcfottn7gVo/L7P9cz3DFi5Zf1kVZZxVh7n+8zztIW3QEihSgrgi1O/vQpZPMEMHrfrYl8PlkuGWhYnzAbs1qnAEd1wA0p/ysxDCzO4BjAII8tJrWUuqj5mWe5fHz/Bk+SkoOaozYRHNfdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=JK2MuG02; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="JK2MuG02"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6F30D1E2F;
	Wed, 13 May 2026 06:18:59 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.68.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8540E3F836;
	Wed, 13 May 2026 06:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778678344; bh=trQyw0PdE9XkuPVCbvJDXHI7TLzpH6OvqtkqRmWtuNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JK2MuG02A5/pCxixbZqR2Q+tgRaP08jFg7bifneRiZhGeYNkH4IjSuwxMjqRPVBuX
	 4b7ieEey5F5hlkRFRIFWxeB7YCRJvq+RG2yIqZ7YPWeraH65bM0W0vZG4pzbDGvlDD
	 R86z9pCfnyg9UFKJMibHS7tp5i2fxaz/2nVsgF6k=
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
	Lorenzo.Pieralisi2@arm.com
Subject: [PATCH v14 08/44] arm64: RMI: Ensure that the RMM has GPT entries for memory
Date: Wed, 13 May 2026 14:17:16 +0100
Message-ID: <20260513131757.116630-9-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260513131757.116630-1-steven.price@arm.com>
References: <20260513131757.116630-1-steven.price@arm.com>
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
DRAM, so that we can delegated individual pages.

For now we only support a statically carved out memory for tracking
granules for the "fine" regions. This can be extended in the future to
allow modifying the tracking granularity and remove the need for a
static allocation.

Similarly, the firmware may create L0 GPT entries describing the total
address space. But if we change the "PAS" (Physical Address Space) of a
granule then the firmware may need to create L1 tables to track the PAS
at a finer granularity.

Note: support is currently missing for SROs which means that if the RMM
needs memory donating this will fail (and render CCA unusable in Linux).
This effectively means that the L1 GPT tables must be created before
Linux starts.

Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v13:
 * Moved out of KVM
---
 arch/arm64/include/asm/rmi_cmds.h |   2 +
 arch/arm64/kernel/rmi.c           | 103 ++++++++++++++++++++++++++++++
 2 files changed, 105 insertions(+)

diff --git a/arch/arm64/include/asm/rmi_cmds.h b/arch/arm64/include/asm/rmi_cmds.h
index 9179934925c5..9078a2920a7c 100644
--- a/arch/arm64/include/asm/rmi_cmds.h
+++ b/arch/arm64/include/asm/rmi_cmds.h
@@ -33,6 +33,8 @@ struct rmi_sro_state {
 } while (RMI_RETURN_STATUS(res.a0) == RMI_BUSY ||			\
 	 RMI_RETURN_STATUS(res.a0) == RMI_BLOCKED)
 
+bool rmi_is_available(void);
+
 unsigned long rmi_sro_execute(struct rmi_sro_state *sro, gfp_t gfp);
 void rmi_sro_free(struct rmi_sro_state *sro);
 
diff --git a/arch/arm64/kernel/rmi.c b/arch/arm64/kernel/rmi.c
index a14ead5dedda..52a415e99500 100644
--- a/arch/arm64/kernel/rmi.c
+++ b/arch/arm64/kernel/rmi.c
@@ -7,6 +7,8 @@
 
 #include <asm/rmi_cmds.h>
 
+static bool arm64_rmi_is_available;
+
 unsigned long rmm_feat_reg0;
 unsigned long rmm_feat_reg1;
 
@@ -88,6 +90,102 @@ static int rmi_configure(void)
 	return 0;
 }
 
+/*
+ * For now we set the tracking_region_size to 0 for RMI_RMM_CONFIG_SET().
+ * TODO: Support other tracking sizes (via Kconfig option).
+ */
+#ifdef CONFIG_PAGE_SIZE_4KB
+#define RMM_GRANULE_TRACKING_SIZE	SZ_1G
+#elif defined(CONFIG_PAGE_SIZE_16KB)
+#define RMM_GRANULE_TRACKING_SIZE	SZ_32M
+#elif defined(CONFIG_PAGE_SIZE_64KB)
+#define RMM_GRANULE_TRACKING_SIZE	SZ_512M
+#endif
+
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
+			pr_err("Granule tracking for region isn't fine/conventional: %llx",
+			       start);
+			return -ENODEV;
+		}
+		start = next;
+	}
+
+	return 0;
+}
+
+static unsigned long rmi_l0gpt_size(void)
+{
+	return 1UL << (30 + FIELD_GET(RMI_FEATURE_REGISTER_1_L0GPTSZ,
+				      rmm_feat_reg1));
+}
+
+static int rmi_create_gpts(phys_addr_t start, phys_addr_t end)
+{
+	unsigned long l0gpt_sz = rmi_l0gpt_size();
+
+	start = ALIGN_DOWN(start, l0gpt_sz);
+	end = ALIGN(end, l0gpt_sz);
+
+	while (start < end) {
+		int ret = rmi_gpt_l1_create(start);
+
+		/*
+		 * Make sure the L1 GPT tables are created for the region.
+		 * RMI_ERROR_GPT indicates the L1 table already exists.
+		 */
+		if (ret && ret != RMI_ERROR_GPT) {
+			/*
+			 * FIXME: Handle SRO so that memory can be donated for
+			 * the tables.
+			 */
+			pr_err("GPT Level1 table missing for %llx\n", start);
+			return -ENOMEM;
+		}
+		start += l0gpt_sz;
+	}
+
+	return 0;
+}
+
+static int rmi_init_metadata(void)
+{
+	phys_addr_t start, end;
+	const struct memblock_region *r;
+
+	for_each_mem_region(r) {
+		int ret;
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
+bool rmi_is_available(void)
+{
+	return arm64_rmi_is_available;
+}
+
 static int __init arm64_init_rmi(void)
 {
 	/* Continue without realm support if we can't agree on a version */
@@ -101,6 +199,11 @@ static int __init arm64_init_rmi(void)
 
 	if (rmi_configure())
 		return 0;
+	if (rmi_init_metadata())
+		return 0;
+
+	arm64_rmi_is_available = true;
+	pr_info("RMI configured");
 
 	return 0;
 }
-- 
2.43.0

