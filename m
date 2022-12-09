Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4820863C7
	for <kvmarm@lists.linux.dev>; Fri,  9 Dec 2022 16:45:14 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68027D6E;
	Fri,  9 Dec 2022 08:45:20 -0800 (PST)
Received: from e126815.warwick.arm.com (e126815.arm.com [10.32.32.26])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E3C1A3F73D;
	Fri,  9 Dec 2022 08:45:11 -0800 (PST)
From: James Clark <james.clark@arm.com>
To: kvmarm@lists.linux.dev
Cc: James Clark <james.clark@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] KVM: arm64: PMU: Fix PMCR_EL0 reset value
Date: Fri,  9 Dec 2022 16:44:46 +0000
Message-ID: <20221209164446.1972014-2-james.clark@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221209164446.1972014-1-james.clark@arm.com>
References: <20221209164446.1972014-1-james.clark@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Message-ID: <20221209164446.v6fDYl7tVH5m6Ctfcc2Fa8KV81GXwKxXXwUiiR2OcHQ@z>

ARMV8_PMU_PMCR_N_MASK is an unshifted value which results in the wrong
reset value for PMCR_EL0, so shift it to fix it.

This fixes the following error when running qemu:

  $ qemu-system-aarch64 -cpu host -machine type=virt,accel=kvm -kernel ...

  target/arm/helper.c:1813: pmevcntr_rawwrite: Assertion `counter < pmu_num_counters(env)' failed.

Fixes: 292e8f149476 ("KVM: arm64: PMU: Simplify PMCR_EL0 reset handling")
Signed-off-by: James Clark <james.clark@arm.com>
---
 arch/arm64/kvm/sys_regs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index d5ee52d6bf73..c6cbfe6b854b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -646,7 +646,7 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 		return;
 
 	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
-	pmcr = read_sysreg(pmcr_el0) & ARMV8_PMU_PMCR_N_MASK;
+	pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
 	if (!kvm_supports_32bit_el0())
 		pmcr |= ARMV8_PMU_PMCR_LC;
 
-- 
2.25.1

