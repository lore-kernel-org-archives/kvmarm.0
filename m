Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7DF3848D
	for <kvmarm@lists.linux.dev>; Tue,  6 Dec 2022 14:00:17 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 58DE712FC;
	Tue,  6 Dec 2022 06:00:24 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.159])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 002193F73D;
	Tue,  6 Dec 2022 06:00:15 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Ard Biesheuvel <ardb@kernel.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH v1 08/12] KVM: arm64: Insert PS field at TCR_EL2 assembly time
Date: Tue,  6 Dec 2022 13:59:26 +0000
Message-ID: <20221206135930.3277585-9-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221206135930.3277585-1-ryan.roberts@arm.com>
References: <20221206135930.3277585-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221206135926._rdAhuw0AOfi2vsnQwS4yD6WgnWiTLiaxadt2zCzLXU@z>

With the addition of LPA2 support in the hypervisor, the PA size
supported by the HW must be capped with a runtime decision, rather than
simply using a compile-time decision based on PA_BITS.For example, on a
system that advertises 52 bit PA but does not support FEAT_LPA2, A 4KB
or 16KB kernel compiled with LPA2 support must still limit the PA size
to 48 bits.

Therefore, move the insertion of the PS field into TCR_EL2 out of
__kvm_hyp_init assembly code and instead do it in cpu_prepare_hyp_mode()
where the rest of TCR_EL2 is assembled. This allows us to figure out PS
with kvm_get_parange(), which has the appropriate logic to ensure the
above requirement. (and the PS field of VTCR_EL2 is already populated
this way).

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/kvm/arm.c               | 5 ++++-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 4 ----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a234c6252c3c..ac30d849a308 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1522,6 +1522,8 @@ static void cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 {
 	struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
 	unsigned long tcr;
+	bool lpa2_ena = kvm_supports_hyp_lpa2();
+	u64 mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 
 	/*
 	 * Calculate the raw per-cpu offset without a translation from the
@@ -1537,7 +1539,8 @@ static void cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 	tcr = (read_sysreg(tcr_el1) & TCR_EL2_MASK) | TCR_EL2_RES1;
 	tcr &= ~TCR_T0SZ_MASK;
 	tcr |= TCR_T0SZ(hyp_va_bits);
-	if (kvm_supports_hyp_lpa2())
+	tcr |= kvm_get_parange(mmfr0, lpa2_ena) << TCR_EL2_PS_SHIFT;
+	if (lpa2_ena)
 		tcr |= TCR_EL2_DS;
 	params->tcr_el2 = tcr;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index c953fb4b9a13..3cc6dd2ff253 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -108,11 +108,7 @@ alternative_if ARM64_HAS_CNP
 alternative_else_nop_endif
 	msr	ttbr0_el2, x2
 
-	/*
-	 * Set the PS bits in TCR_EL2.
-	 */
 	ldr	x0, [x0, #NVHE_INIT_TCR_EL2]
-	tcr_compute_pa_size x0, #TCR_EL2_PS_SHIFT, x1, x2
 	msr	tcr_el2, x0
 
 	isb
-- 
2.25.1

