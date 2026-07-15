Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A85C38757A;
	Wed, 15 Jul 2026 14:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784125707; cv=none; b=leqVLOUSI6pbkxmmsMprfbHHZHO3BviraQOpGknD9CvUMdhxjF2FcupzzuQyRWl5QAnYLltIIgRko9OK4M4pTL2q91xPmn0Uw1X8LEgYIFGxySpeM5S0gPdL5S8o317FbmnoUsPdsV1KxqTOU4zAMg41K7PsS3HGKKtl36xJrYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784125707; c=relaxed/simple;
	bh=KZgZh+TlRITfiUhnLxGy5a8BYgDYUWfooEUpxGbDDgQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dRydVUfgfNXfRvVQ/upNXC79mvZOOBpMVUHjBD9vvH8mF3OZYdVDbmwqBqGArYabOthIhHTrnSpl/Zbx+Bkx1BunTqrDZRTOacgQN0c6XAEdHctJn8jYpJnHqfbDsp+atpD89O/z65jFeH87aKmdhCTgYCs6d7e3G9URgGTS0+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=Zk/uGkjK; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="Zk/uGkjK"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 833EC153B;
	Wed, 15 Jul 2026 07:28:20 -0700 (PDT)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.25.27])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4CEFD3F7B4;
	Wed, 15 Jul 2026 07:28:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784125704; bh=KZgZh+TlRITfiUhnLxGy5a8BYgDYUWfooEUpxGbDDgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zk/uGkjKFeQvrYAghMIb5a6cRiqHAfeUIh0RH/1zSkWsz8wxvNrRaGsUY2GLWYtdE
	 YM9ZbeWn0ObkWjIlbRN+MCyIXOONeP1gRivHiO8WHumQ/LRFdkdij/KLDqQiI/dX3/
	 TmBOBBltC2n6bgKRAl1gErIzRBaOWvkYuoDuU8p4=
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
Subject: [PATCH 6/6] firmware: arm_rmm: Ensure the RMM has GPT entries for memory
Date: Wed, 15 Jul 2026 15:27:37 +0100
Message-ID: <20260715142739.80398-7-steven.price@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260715142739.80398-1-steven.price@arm.com>
References: <20260715142739.80398-1-steven.price@arm.com>
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
Changes since v14:
 * Move the implementation into drivers/firmware/arm_rmm.
Changes since v13:
 * Moved out of KVM
---
 drivers/firmware/arm_rmm/rmi.c | 92 ++++++++++++++++++++++++++++++++++
 1 file changed, 92 insertions(+)

diff --git a/drivers/firmware/arm_rmm/rmi.c b/drivers/firmware/arm_rmm/rmi.c
index 6a9f61760fd7..d0c083bdf251 100644
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
@@ -604,6 +606,89 @@ static int rmi_configure(void)
 	return 0;
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
+		int ret = rmi_gpt_l1_create(start, sro, GFP_KERNEL);
+
+		/*
+		 * Make sure the L1 GPT tables are created for the region.
+		 * RMI_ERROR_GPT indicates the L1 table already exists.
+		 */
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
+bool is_rmi_available(void)
+{
+	return arm64_rmi_is_available;
+}
+
 static int __init arm64_init_rmi(void)
 {
 	int ret;
@@ -621,6 +706,13 @@ static int __init arm64_init_rmi(void)
 	if (ret)
 		return ret;
 
+	ret = rmi_init_metadata();
+	if (ret)
+		return ret;
+
+	arm64_rmi_is_available = true;
+	pr_info("RMI configured");
+
 	return 0;
 }
 
-- 
2.43.0

