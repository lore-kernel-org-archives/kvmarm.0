Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 026F617732
	for <kvmarm@lists.linux.dev>; Fri, 27 Oct 2023 11:56:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C8B75153B;
	Fri, 27 Oct 2023 04:57:29 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 415853F738;
	Fri, 27 Oct 2023 04:56:46 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Ard Biesheuvel <ardb@google.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mark Rutland <mark.rutland@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Kees Cook <keescook@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	James Morse <james.morse@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [RFC PATCH v1 2/3] arm64/mm: Add lpa2_is_enabled() kvm_lpa2_is_enabled() stubs
Date: Fri, 27 Oct 2023 12:56:33 +0100
Message-Id: <20231027115634.1432154-3-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20231027115634.1432154-1-ryan.roberts@arm.com>
References: <20231027115634.1432154-1-ryan.roberts@arm.com>
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

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/include/asm/kvm_mmu.h      | 3 +++
 arch/arm64/include/asm/pgtable-prot.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 96a80e8f6226..57d5c2866174 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -314,5 +314,8 @@ static inline struct kvm *kvm_s2_mmu_to_kvm(struct kvm_s2_mmu *mmu)
 {
 	return container_of(mmu->arch, struct kvm, arch);
 }
+
+#define kvm_lpa2_is_enabled()		false
+
 #endif /* __ASSEMBLY__ */
 #endif /* __ARM64_KVM_MMU_H__ */
diff --git a/arch/arm64/include/asm/pgtable-prot.h b/arch/arm64/include/asm/pgtable-prot.h
index eed814b00a38..b4b2b8623769 100644
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

