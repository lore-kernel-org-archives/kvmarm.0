Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C8BC55C3A;
	Fri, 12 Apr 2024 08:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712911359; cv=none; b=AEiL4zS7fPS7yrq6jASS7tiV+JwR5M17dJ+ay6cvQhvF6kcPmMqqIxUc58ccyHvlwwc3oa+vpfHupBinXZuN2x6wLGa8iAOFDUzgPjEkYXIRIS1dlT7wBHjxgutBNHm65RnSDU5/KBYXkaoOBdD08nFdsnJD/e/3r+fXjZ/GCac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712911359; c=relaxed/simple;
	bh=agngeU8huUmhG9g9+C9VjdJl0iGtBw5GtJfVp2YcLdU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=AuZJOoSIgdrv1WmyBD5xJFKXQJfxYlxGaEOhBTgQy89CTWXNGNBGb0p08tgXmswkg2QjAgdbPEMt5VKWGuNCMBYtyyYx+I6jdAtJegZxyrExGvHQRLTy4VlJKtmRpYvqjLyCgieri7UZ5HQiMIcpMuU71G3mUsroQW2PfdFey8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 74209339;
	Fri, 12 Apr 2024 01:43:07 -0700 (PDT)
Received: from e112269-lin.cambridge.arm.com (e112269-lin.cambridge.arm.com [10.1.194.51])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1CDD63F6C4;
	Fri, 12 Apr 2024 01:42:36 -0700 (PDT)
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
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
Subject: [PATCH v2 07/14] arm64: Make the PHYS_MASK_SHIFT dynamic
Date: Fri, 12 Apr 2024 09:42:06 +0100
Message-Id: <20240412084213.1733764-8-steven.price@arm.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240412084213.1733764-1-steven.price@arm.com>
References: <20240412084056.1733704-1-steven.price@arm.com>
 <20240412084213.1733764-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Make the PHYS_MASK_SHIFT dynamic for Realms. This is only is required
for masking the PFN from a pte entry. Elsewhere, we could still use the
PA bits configured by the kernel. So, this patch:

 -> renames PHYS_MASK_SHIFT -> MAX_PHYS_SHIFT as supported by the kernel
 -> Makes PHYS_MASK_SHIFT -> Dynamic value of the (I)PA bit width
 -> For a realm: reduces phys_mask_shift if the RMM reports a smaller
    configured size for the guest.

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h       | 2 +-
 arch/arm64/include/asm/pgtable-hwdef.h | 4 ++--
 arch/arm64/include/asm/pgtable.h       | 5 +++++
 arch/arm64/kernel/rsi.c                | 5 +++++
 4 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index e01bb5ca13b7..9944aca348bd 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -398,7 +398,7 @@
  * bits in PAR are res0.
  */
 #define PAR_TO_HPFAR(par)		\
-	(((par) & GENMASK_ULL(52 - 1, 12)) >> 8)
+	(((par) & GENMASK_ULL(MAX_PHYS_MASK_SHIFT - 1, 12)) >> 8)
 
 #define ECN(x) { ESR_ELx_EC_##x, #x }
 
diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index ef207a0d4f0d..90dc292bed5f 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -206,8 +206,8 @@
 /*
  * Highest possible physical address supported.
  */
-#define PHYS_MASK_SHIFT		(CONFIG_ARM64_PA_BITS)
-#define PHYS_MASK		((UL(1) << PHYS_MASK_SHIFT) - 1)
+#define MAX_PHYS_MASK_SHIFT	(CONFIG_ARM64_PA_BITS)
+#define MAX_PHYS_MASK		((UL(1) << PHYS_MASK_SHIFT) - 1)
 
 #define TTBR_CNP_BIT		(UL(1) << 0)
 
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index afdd56d26ad7..f5376bd567a1 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -39,6 +39,11 @@
 #include <linux/sched.h>
 #include <linux/page_table_check.h>
 
+extern unsigned int phys_mask_shift;
+
+#define PHYS_MASK_SHIFT		(phys_mask_shift)
+#define PHYS_MASK		((1UL << PHYS_MASK_SHIFT) - 1)
+
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
 #define __HAVE_ARCH_FLUSH_PMD_TLB_RANGE
 
diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index b93252ed6fc5..159bc428c77b 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -12,6 +12,8 @@ struct realm_config __attribute((aligned(PAGE_SIZE))) config;
 unsigned long prot_ns_shared;
 EXPORT_SYMBOL(prot_ns_shared);
 
+unsigned int phys_mask_shift = CONFIG_ARM64_PA_BITS;
+
 DEFINE_STATIC_KEY_FALSE_RO(rsi_present);
 EXPORT_SYMBOL(rsi_present);
 
@@ -62,5 +64,8 @@ void __init arm64_rsi_init(void)
 		return;
 	prot_ns_shared = BIT(config.ipa_bits - 1);
 
+	if (config.ipa_bits - 1 < phys_mask_shift)
+		phys_mask_shift = config.ipa_bits - 1;
+
 	static_branch_enable(&rsi_present);
 }
-- 
2.34.1

