Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 848A517838D;
	Mon, 19 Aug 2024 13:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724073629; cv=none; b=Zes8X0aBFR6lUj026+WaiksdRM7+S3PHIXgV/4rc2ddyrEfl0r0X2ckweAf8I4hx1uT0NWyLUTg/K+2XCvSdu1ODcppSRLukuYFUExF3zWoDZ+ykyPClarHP2RhSqhs9KKTqLd0Q1c8JMLn2+dbx6OnfOO+0wfXaSc2BaHu+GXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724073629; c=relaxed/simple;
	bh=Q9AA0bsOlUx9dNmprQGHuNvhKFPzaftwoNqmHHPLeVQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KQZ5DAixZZNVsnzivJAbuste9NecEws2P+WPXdKW5ZdfbkDW6RRYManE+n1+ziup+MxT3P2WMB9oLSj3hGbNBhDhBpBUlapbCXVRDOPqdZi9LCFN7fwQYR0qET/+lHL0W6ppO8N8yOxUPrfiB7Gn4563Pwss6PYv4bUV9k0a1AQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 344AE1063;
	Mon, 19 Aug 2024 06:20:54 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.85.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6999C3F73B;
	Mon, 19 Aug 2024 06:20:24 -0700 (PDT)
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
	Alper Gun <alpergun@google.com>
Subject: [PATCH v5 11/19] arm64: rsi: Map unprotected MMIO as decrypted
Date: Mon, 19 Aug 2024 14:19:16 +0100
Message-Id: <20240819131924.372366-12-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240819131924.372366-1-steven.price@arm.com>
References: <20240819131924.372366-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Instead of marking every MMIO as shared, check if the given region is
"Protected" and apply the permissions accordingly.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
New patch for v5
---
 arch/arm64/kernel/rsi.c | 15 +++++++++++++++
 arch/arm64/mm/mmu.c     |  2 +-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/rsi.c b/arch/arm64/kernel/rsi.c
index 381a5b9a5333..672dd6862298 100644
--- a/arch/arm64/kernel/rsi.c
+++ b/arch/arm64/kernel/rsi.c
@@ -6,6 +6,8 @@
 #include <linux/jump_label.h>
 #include <linux/memblock.h>
 #include <linux/psci.h>
+
+#include <asm/io.h>
 #include <asm/rsi.h>
 
 struct realm_config config;
@@ -93,6 +95,16 @@ bool arm64_rsi_is_protected_mmio(phys_addr_t base, size_t size)
 }
 EXPORT_SYMBOL(arm64_rsi_is_protected_mmio);
 
+static int realm_ioremap_hook(phys_addr_t phys, size_t size, pgprot_t *prot)
+{
+	if (arm64_rsi_is_protected_mmio(phys, size))
+		*prot = pgprot_encrypted(*prot);
+	else
+		*prot = pgprot_decrypted(*prot);
+
+	return 0;
+}
+
 void __init arm64_rsi_init(void)
 {
 	/*
@@ -107,6 +119,9 @@ void __init arm64_rsi_init(void)
 		return;
 	prot_ns_shared = BIT(config.ipa_bits - 1);
 
+	if (arm64_ioremap_prot_hook_register(realm_ioremap_hook))
+		return;
+
 	static_branch_enable(&rsi_present);
 }
 
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 06b66c23c124..0c2fa35beca0 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1207,7 +1207,7 @@ void set_fixmap_io(enum fixed_addresses idx, phys_addr_t phys)
 	else
 		prot = pgprot_encrypted(prot);
 
-	__set_fixmap(idx, phys, prot);
+	__set_fixmap(idx, phys & PAGE_MASK, prot);
 }
 
 int pud_set_huge(pud_t *pudp, phys_addr_t phys, pgprot_t prot)
-- 
2.34.1

