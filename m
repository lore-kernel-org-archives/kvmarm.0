Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EA6E7B;
	Fri, 27 Jan 2023 11:28:14 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DFBAF1570;
	Fri, 27 Jan 2023 03:28:55 -0800 (PST)
Received: from e122027.cambridge.arm.com (e122027.cambridge.arm.com [10.1.35.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9AA8A3F64C;
	Fri, 27 Jan 2023 03:28:11 -0800 (PST)
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
Subject: [RFC PATCH 01/14] arm64: remove redundant 'extern'
Date: Fri, 27 Jan 2023 11:27:45 +0000
Message-Id: <20230127112758.37891-2-steven.price@arm.com>
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

It isn't necessary to mark function definitions extern and goes against
the kernel coding style. Remove the redundant extern keyword.

Signed-off-by: Steven Price <steven.price@arm.com>
---
 arch/arm64/include/asm/fixmap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/fixmap.h b/arch/arm64/include/asm/fixmap.h
index 71ed5fdf718b..09ba9fe3b02c 100644
--- a/arch/arm64/include/asm/fixmap.h
+++ b/arch/arm64/include/asm/fixmap.h
@@ -107,7 +107,7 @@ void __init early_fixmap_init(void);
 #define __late_set_fixmap __set_fixmap
 #define __late_clear_fixmap(idx) __set_fixmap((idx), 0, FIXMAP_PAGE_CLEAR)
 
-extern void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot);
+void __set_fixmap(enum fixed_addresses idx, phys_addr_t phys, pgprot_t prot);
 
 #include <asm-generic/fixmap.h>
 
-- 
2.34.1

