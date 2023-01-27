Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CCAC28E8;
	Fri, 27 Jan 2023 11:28:30 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D99D51650;
	Fri, 27 Jan 2023 03:29:11 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id B39DE3F64C;
	Fri, 27 Jan 2023 03:28:27 -0800 (PST)
From: Steven Price <steven.price@arm.com>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Steven Price <steven.price@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Will Deacon <will@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Zenghui Yu <yuzenghui@huawei.com>,
	linux-kernel@vger.kernel.org,
	Joey Gouly <joey.gouly@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Christoffer Dall <christoffer.dall@arm.com>,
	Fuad Tabba <tabba@google.com>,
	linux-coco@lists.linux.dev
Subject: [RFC PATCH 07/14] arm64: Override set_fixmap_io
Date: Fri, 27 Jan 2023 11:27:51 +0000
Message-Id: <20230127112758.37891-8-steven.price@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230127112758.37891-1-steven.price@arm.com>
References: <20230127112248.136810-1-suzuki.poulose@arm.com>
 <20230127112758.37891-1-steven.price@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Suzuki K Poulose <suzuki.poulose@arm.com>

Override the set_fixmap_io to set shared permission for the host
in case of a CC guest. For now we mark it shared unconditionally.
Future changes could filter the physical address and make the
decision accordingly.

Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/fixmap.h |  2 ++
 arch/arm64/mm/mmu.c             | 13 +++++++++++++
 2 files changed, 15 insertions(+)

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index 09ba9fe3b02c..1acafc1c7fae 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -107,6 +107,8 @@ void __init early_fixmap_init(void);
 #define __late_set_fixmap __set_fixmap
 #define __late_clear_fixmap(idx) __set_fixmap((idx), 0, FIXMAP_PAGE_CLEAR)
 
+#define set_fixmap_io set_fixmap_io
+void set_fixmap_io(enum fixed_addresses idx, phys_addr_t phys);
 void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot);
 
 #include <asm-generic/fixmap.h>
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 14c87e8d69d8..33fda73c669b 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -1279,6 +1279,19 @@ void __set_fixmap(enum fixed_addresses idx,
 	}
 }
 
+void set_fixmap_io(enum fixed_addresses idx, phys_addr_t phys)
+{
+	pgprot_t prot = FIXMAP_PAGE_IO;
+
+	/*
+	 * For now we consider all I/O as non-secure. For future
+	 * filter the I/O base for setting appropriate permissions.
+	 */
+	prot = __pgprot(pgprot_val(prot) | PROT_NS_SHARED);
+
+	return __set_fixmap(idx, phys, prot);
+}
+
 void *__init fixmap_remap_fdt(phys_addr_t dt_phys, int *size, pgprot_t prot)
 {
 	const u64 dt_virt_base = __fix_to_virt(FIX_FDT);
-- 
2.34.1

