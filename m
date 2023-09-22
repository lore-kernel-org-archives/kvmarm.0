Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 790B31F186
	for <kvmarm@lists.linux.dev>; Fri, 22 Sep 2023 11:26:09 +0000 (UTC)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 01020143D;
	Fri, 22 Sep 2023 04:26:46 -0700 (PDT)
Received: from e126864.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 325133F5A1;
	Fri, 22 Sep 2023 04:26:06 -0700 (PDT)
From: Kristina Martsenko <kristina.martsenko@arm.com>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Vladimir Murzin <vladimir.murzin@arm.com>,
	Colton Lewis <coltonlewis@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] KVM: arm64: Expose MOPS instructions to guests
Date: Fri, 22 Sep 2023 12:25:08 +0100
Message-Id: <20230922112508.1774352-3-kristina.martsenko@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230922112508.1774352-1-kristina.martsenko@arm.com>
References: <20230922112508.1774352-1-kristina.martsenko@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Expose the Armv8.8 FEAT_MOPS feature to guests in the ID register and
allow the MOPS instructions to be run in a guest. Only expose MOPS if
the whole system supports it.

Note, it is expected that guests do not use these instructions on MMIO,
similarly to other instructions where ESR_EL2.ISV==0 such as LDP/STP.

Signed-off-by: Kristina Martsenko <kristina.martsenko@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h               | 4 +++-
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h | 3 ++-
 arch/arm64/kvm/sys_regs.c                      | 1 -
 3 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 5882b2415596..2186927b1d21 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -102,7 +102,9 @@
 #define HCR_HOST_NVHE_PROTECTED_FLAGS (HCR_HOST_NVHE_FLAGS | HCR_TSC)
 #define HCR_HOST_VHE_FLAGS (HCR_RW | HCR_TGE | HCR_E2H)
 
-#define HCRX_GUEST_FLAGS (HCRX_EL2_SMPME | HCRX_EL2_TCR2En)
+#define HCRX_GUEST_FLAGS \
+	(HCRX_EL2_SMPME | HCRX_EL2_TCR2En | \
+	 (cpus_have_final_cap(ARM64_HAS_MOPS) ? (HCRX_EL2_MSCEn | HCRX_EL2_MCE2) : 0))
 #define HCRX_HOST_FLAGS (HCRX_EL2_MSCEn | HCRX_EL2_TCR2En)
 
 /* TCR_EL2 Registers bits */
diff --git a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
index 37440e1dda93..e91922daa8ca 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
@@ -197,7 +197,8 @@
 
 #define PVM_ID_AA64ISAR2_ALLOW (\
 	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_GPA3) | \
-	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_APA3) \
+	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_APA3) | \
+	ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_MOPS) \
 	)
 
 u64 pvm_read_id_reg(const struct kvm_vcpu *vcpu, u32 id);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index e92ec810d449..153baf2f72cb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1338,7 +1338,6 @@ static u64 __kvm_read_sanitised_id_reg(const struct kvm_vcpu *vcpu,
 				 ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_GPA3));
 		if (!cpus_have_final_cap(ARM64_HAS_WFXT))
 			val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_WFxT);
-		val &= ~ARM64_FEATURE_MASK(ID_AA64ISAR2_EL1_MOPS);
 		break;
 	case SYS_ID_AA64MMFR2_EL1:
 		val &= ~ID_AA64MMFR2_EL1_CCIDX_MASK;
-- 
2.25.1

