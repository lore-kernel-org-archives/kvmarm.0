Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BBBC6FDD
	for <kvmarm@lists.linux.dev>; Mon,  6 Mar 2023 19:55:08 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 914D01C25;
	Mon,  6 Mar 2023 11:55:51 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D888B3F71A;
	Mon,  6 Mar 2023 11:55:06 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH v2 06/12] KVM: arm64: Use LPA2 page-tables for hyp stage1 if HW supports it
Date: Mon,  6 Mar 2023 19:54:32 +0000
Message-Id: <20230306195438.1557851-7-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230306195438.1557851-1-ryan.roberts@arm.com>
References: <20230306195438.1557851-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement a simple policy whereby if the HW supports FEAT_LPA2 for the
page size we are using, always use LPA2-style page-tables for hyp stage
1, regardless of the IPA or PA size requirements. When in use we can now
support up to 52-bit IPA and PA sizes.

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/kvm/arm.c         | 2 ++
 arch/arm64/kvm/hyp/pgtable.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3bd732eaf087..bef73c484162 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1548,6 +1548,8 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 	tcr = (read_sysreg(tcr_el1) & TCR_EL2_MASK) | TCR_EL2_RES1;
 	tcr &= ~TCR_T0SZ_MASK;
 	tcr |= TCR_T0SZ(hyp_va_bits);
+	if (system_supports_lpa2())
+		tcr |= TCR_EL2_DS;
 	params->tcr_el2 = tcr;
 
 	params->pgd_pa = kvm_mmu_get_httbr();
diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 414a5dbf233d..bb481d6c7f2d 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -379,7 +379,8 @@ static int hyp_set_prot_attr(enum kvm_pgtable_prot prot, kvm_pte_t *ptep)
 	}
 
 	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_AP, ap);
-	attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
+	if (!system_supports_lpa2())
+		attr |= FIELD_PREP(KVM_PTE_LEAF_ATTR_LO_S1_SH, sh);
 	attr |= KVM_PTE_LEAF_ATTR_LO_S1_AF;
 	attr |= prot & KVM_PTE_LEAF_ATTR_HI_SW;
 	*ptep = attr;
-- 
2.25.1

