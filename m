Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89C3B14A098;
	Mon,  1 Jul 2024 09:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719827736; cv=none; b=XnyE5DTfnZb5bsxSYvE/WU1X36A53wc82xnt9M6zLLbhwRwgdJZIRnYCzR0yAr6bI48Fb3eMExxOoXnDEyLR8MOk4BCeUe76sE8pQpPmBNpL0VBOwM7hY8rJ57d3ho0Knfiv8mQA1vOtLb8CZXqBPex0UEop9/g0iUI1wSYh6b4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719827736; c=relaxed/simple;
	bh=kUKXTAeQbkxgHtXF2NzhvFWMftSlRuwr+7oklYke8rU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=POOsMeeoqSoLDdYumsoMMqwQUa6kNJxby7ZnJ9Wsvi4XiN6aszFnpwZY9oibmh5bAPhTcRRnoWnfQPxQ7duvqomOz5Rt2mmVl85BQFh4Q1l1z22aOeV6b6vMt/Fw/2MdX8+kJftsM6oovNxUZlm9sGQcpRKCF4E0rjlR+iYioOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 33A1115A1;
	Mon,  1 Jul 2024 02:56:00 -0700 (PDT)
Received: from e122027.arm.com (unknown [10.57.44.170])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 381333F762;
	Mon,  1 Jul 2024 02:55:32 -0700 (PDT)
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
Subject: [PATCH v4 05/15] arm64: Mark all I/O as non-secure shared
Date: Mon,  1 Jul 2024 10:54:55 +0100
Message-Id: <20240701095505.165383-6-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240701095505.165383-1-steven.price@arm.com>
References: <20240701095505.165383-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

All I/O is by default considered non-secure for realms. As such
mark them as shared with the host.

Co-developed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
Changes since v3:
 * Add PROT_NS_SHARED to FIXMAP_PAGE_IO rather than overriding
   set_fixmap_io() with a custom function.
 * Modify ioreamp_cache() to specify PROT_NS_SHARED too.
---
 arch/arm64/include/asm/fixmap.h | 2 +-
 arch/arm64/include/asm/io.h     | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index 87e307804b99..f2c5e653562e 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -98,7 +98,7 @@ enum fixed_addresses {
 #define FIXADDR_TOT_SIZE	(__end_of_fixed_addresses << PAGE_SHIFT)
 #define FIXADDR_TOT_START	(FIXADDR_TOP - FIXADDR_TOT_SIZE)
 
-#define FIXMAP_PAGE_IO     __pgprot(PROT_DEVICE_nGnRE)
+#define FIXMAP_PAGE_IO     __pgprot(PROT_DEVICE_nGnRE | PROT_NS_SHARED)
 
 void __init early_fixmap_init(void);
 
diff --git a/arch/arm64/include/asm/io.h b/arch/arm64/include/asm/io.h
index 4ff0ae3f6d66..07fc1801c6ad 100644
--- a/arch/arm64/include/asm/io.h
+++ b/arch/arm64/include/asm/io.h
@@ -277,12 +277,12 @@ static inline void __const_iowrite64_copy(void __iomem *to, const void *from,
 
 #define ioremap_prot ioremap_prot
 
-#define _PAGE_IOREMAP PROT_DEVICE_nGnRE
+#define _PAGE_IOREMAP (PROT_DEVICE_nGnRE | PROT_NS_SHARED)
 
 #define ioremap_wc(addr, size)	\
-	ioremap_prot((addr), (size), PROT_NORMAL_NC)
+	ioremap_prot((addr), (size), (PROT_NORMAL_NC | PROT_NS_SHARED))
 #define ioremap_np(addr, size)	\
-	ioremap_prot((addr), (size), PROT_DEVICE_nGnRnE)
+	ioremap_prot((addr), (size), (PROT_DEVICE_nGnRnE | PROT_NS_SHARED))
 
 /*
  * io{read,write}{16,32,64}be() macros
@@ -303,7 +303,7 @@ static inline void __iomem *ioremap_cache(phys_addr_t addr, size_t size)
 	if (pfn_is_map_memory(__phys_to_pfn(addr)))
 		return (void __iomem *)__phys_to_virt(addr);
 
-	return ioremap_prot(addr, size, PROT_NORMAL);
+	return ioremap_prot(addr, size, PROT_NORMAL | PROT_NS_SHARED);
 }
 
 /*
-- 
2.34.1

