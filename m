Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C6527468
	for <kvmarm@lists.linux.dev>; Mon, 18 Sep 2023 06:58:08 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 336BE1474;
	Sun, 17 Sep 2023 23:58:45 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com [10.1.196.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2F9BF3F5A1;
	Sun, 17 Sep 2023 23:58:06 -0700 (PDT)
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
Subject: [PATCH v3 08/13] KVM: arm64: Insert PS field at TCR_EL2 assembly time
Date: Mon, 18 Sep 2023 07:57:35 +0100
Message-Id: <20230918065740.3670662-9-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230918065740.3670662-1-ryan.roberts@arm.com>
References: <20230918065740.3670662-1-ryan.roberts@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the addition of LPA2 support in the hypervisor, the PA size
supported by the HW must be capped with a runtime decision, rather than
simply using a compile-time decision based on PA_BITS. For example, on a
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
 arch/arm64/kvm/arm.c               | 2 ++
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 4 ----
 2 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 73cc67c2a8a7..fa30522cc935 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1726,6 +1726,7 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 {
 	struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
 	unsigned long tcr;
+	u64 mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 
 	/*
 	 * Calculate the raw per-cpu offset without a translation from the
@@ -1747,6 +1748,7 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 	}
 	tcr &= ~TCR_T0SZ_MASK;
 	tcr |= TCR_T0SZ(hyp_va_bits);
+	tcr |= kvm_get_parange(mmfr0) << TCR_EL2_PS_SHIFT;
 	if (system_supports_lpa2())
 		tcr |= TCR_EL2_DS;
 	params->tcr_el2 = tcr;
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 90fade1b032e..a0d7bc384404 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -121,11 +121,7 @@ alternative_if ARM64_HAS_CNP
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

