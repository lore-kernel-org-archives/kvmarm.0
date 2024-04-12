Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90E5A53E2B;
	Fri, 12 Apr 2024 10:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918070; cv=none; b=PkqHS1rPGwjpnkyutHS+6pj3OP39A25d5TcUf4K/oilyF5rvHyWZJrudPCnCfC0k8vPd8y1Ed/3EsBWkTxX8pwF3KN/FEnunwk033VbWxwkI7EvhpS0CIAe+xPI8gyrrjOg7sP3RDFQpbNoEyZABjKmOCKjdKkfqxz9DtdEk69w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918070; c=relaxed/simple;
	bh=PBKBUp97P8eoyN/ra1CCrlsEyi837XItbFWwB4E9wGs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=JaxrSpYf7Sg0Asu2W/s6hsBWsJ0HlcUkJAstkGRABYVUlhm1MPtoinxuN/GUtJ83FENXBkII7IHBa+9Ls44mLbKAkZJK91AMZ4evB/EujDZagfuhZCcZapz6dtoLrQdB07uVewKCDn/07z5f+FDaJiMaVnqo1pfOovsD4JLPHy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7BBB4339;
	Fri, 12 Apr 2024 03:34:58 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 85C5B3F64C;
	Fri, 12 Apr 2024 03:34:27 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 05/33] arm64: Introduce NS_SHARED PTE attribute
Date: Fri, 12 Apr 2024 11:33:40 +0100
Message-Id: <20240412103408.2706058-6-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Joey Gouly <joey.gouly@arm.com>

Introduce a new attribute to indicate the mapping is "Shared" with the
host. This will be used by the Realms to share pages with the Host.
For normal VMs, this is always 0.

For realms, this is dynamic, depending on the IPA width. The top bit of the
IPA is "treated" as the "NS_SHARED" attribute, making the VM access the
unprotected alias of the IPA.

By default, apply the NS_SHARED attribute for all I/O.

Signed-off-by: Joey Gouly <joey.gouly@arm.com>
[ Fix arm32 build failure ]
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 lib/arm/asm/pgtable.h   | 2 ++
 lib/arm/mmu.c           | 5 ++++-
 lib/arm64/asm/pgtable.h | 7 +++++++
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/lib/arm/asm/pgtable.h b/lib/arm/asm/pgtable.h
index aa98d9ad..350039ff 100644
--- a/lib/arm/asm/pgtable.h
+++ b/lib/arm/asm/pgtable.h
@@ -42,6 +42,8 @@
 	(((addr) >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1))
 #define pgd_offset(pgtable, addr) ((pgtable) + pgd_index(addr))
 
+#define PTE_NS_SHARED		0
+
 #define pgd_free(pgd) free(pgd)
 static inline pgd_t *pgd_alloc(void)
 {
diff --git a/lib/arm/mmu.c b/lib/arm/mmu.c
index 5bbd6d76..41a8304d 100644
--- a/lib/arm/mmu.c
+++ b/lib/arm/mmu.c
@@ -23,6 +23,8 @@
 
 pgd_t *mmu_idmap;
 
+/* Used by Realms, depends on IPA size */
+unsigned long prot_ns_shared = 0;
 unsigned long phys_mask_shift = 48;
 
 /* CPU 0 starts with disabled MMU */
@@ -243,7 +245,8 @@ void __iomem *__ioremap(phys_addr_t phys_addr, size_t size)
 {
 	phys_addr_t paddr_aligned = phys_addr & PAGE_MASK;
 	phys_addr_t paddr_end = PAGE_ALIGN(phys_addr + size);
-	pgprot_t prot = __pgprot(PTE_UNCACHED | PTE_USER | PTE_UXN | PTE_PXN);
+	pgprot_t prot = __pgprot(PTE_UNCACHED | PTE_USER | PTE_UXN |
+				 PTE_PXN | PTE_NS_SHARED);
 	pgd_t *pgtable;
 
 	assert(sizeof(long) == 8 || !(phys_addr >> 32));
diff --git a/lib/arm64/asm/pgtable.h b/lib/arm64/asm/pgtable.h
index 257fae76..5b9f40b0 100644
--- a/lib/arm64/asm/pgtable.h
+++ b/lib/arm64/asm/pgtable.h
@@ -21,6 +21,13 @@
 
 #include <linux/compiler.h>
 
+extern unsigned long prot_ns_shared;
+/*
+ * The Non-secure shared bit for Realms is actually part of the output
+ * address, however it is modeled as a PTE attribute.
+*/
+#define PTE_NS_SHARED		(prot_ns_shared)
+
 /*
  * Highest possible physical address supported.
  */
-- 
2.34.1

