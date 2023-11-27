Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF9FE19445
	for <kvmarm@lists.linux.dev>; Mon, 27 Nov 2023 11:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EAA1F165C;
	Mon, 27 Nov 2023 03:18:43 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D12A93F73F;
	Mon, 27 Nov 2023 03:17:54 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v6 02/12] arm64/mm: Add lpa2_is_enabled() kvm_lpa2_is_enabled() stubs
Date: Mon, 27 Nov 2023 11:17:27 +0000
Message-Id: <20231127111737.1897081-3-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231127111737.1897081-1-ryan.roberts@arm.com>
References: <20231127111737.1897081-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add stub functions which is initially always return false. These provide
the hooks that we need to update the range-based TLBI routines, whose
operands are encoded differently depending on whether lpa2 is enabled or
not.

The kernel and kvm will enable the use of lpa2 asynchronously in future,
and part of that enablement will involve fleshing out their respective
hook to advertise when it is using lpa2.

Since the kernel's decision to use lpa2 relies on more than just whether
the HW supports the feature, it can't just use the same static key as
kvm. This is another reason to use separate functions. lpa2_is_enabled()
is already implemented as part of Ard's kernel lpa2 series. Since kvm
will make its decision solely based on HW support, kvm_lpa2_is_enabled()
will be defined as system_supports_lpa2() once kvm starts using lpa2.

Reviewed-by: Oliver Upton <oliver.upton@linux.dev>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/include/asm/kvm_pgtable.h  | 2 ++
 arch/arm64/include/asm/pgtable-prot.h | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_pgtable.h b/arch/arm64/include/asm/kvm_pgtable.h
index d3e354bb8351..10068500d601 100644
--- a/arch/arm64/include/asm/kvm_pgtable.h
+++ b/arch/arm64/include/asm/kvm_pgtable.h
@@ -25,6 +25,8 @@
 #define KVM_PGTABLE_MIN_BLOCK_LEVEL	2U
 #endif
 
+#define kvm_lpa2_is_enabled()		false
+
 static inline u64 kvm_get_parange(u64 mmfr0)
 {
 	u64 parange = cpuid_feature_extract_unsigned_field(mmfr0,
diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index e9624f6326dd..483dbfa39c4c 100644
--- a/arch/arm64/include/asm/pgtable-prot.h
+++ b/arch/arm64/include/asm/pgtable-prot.h
@@ -71,6 +71,8 @@ extern bool arm64_use_ng_mappings;
 #define PTE_MAYBE_NG		(arm64_use_ng_mappings ? PTE_NG : 0)
 #define PMD_MAYBE_NG		(arm64_use_ng_mappings ? PMD_SECT_NG : 0)
 
+#define lpa2_is_enabled()	false
+
 /*
  * If we have userspace only BTI we don't want to mark kernel pages
  * guarded even if the system does support BTI.
-- 
2.25.1

