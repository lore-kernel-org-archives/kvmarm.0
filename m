Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6BE023BB47
	for <kvmarm@lists.linux.dev>; Thu, 18 Apr 2024 05:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713418705; cv=none; b=PynZYKwEZWA6n1ALM2Q1/ACzJTzsbSX8ZMw0dIIeMlQsS9kWTmbEGC7XLvwygQdMNHZ6wJ4Zb/SetJsf4vmxfSKIz41q54/xn64IgUZgFIsRNVVZ8fojNVBOum5iN2B6CA65zfz2BRNs+H0c/gazVzvLjKk8gWsOx+ZlU4xTO5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713418705; c=relaxed/simple;
	bh=p4ZBSPDbE2nW6K1Ts3TieiUCROkQrl5qpQuS3vATpi0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BPxYSjJV3oAHfYJboJ2y2qLvNqif87X6IBO5piY10HkPDKFwCfs5zpsMVFN8NxzZ/WAYWiS9/cSErsIVI8BYSiDQ+jthdbsoruTxKlYMfiEEbYnqb4bX23ulShcxvhdNLbUs5X/kNNTjupVRHWRux0BamEWNTmN8MJu25rDzrRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 57E18DA7;
	Wed, 17 Apr 2024 22:38:51 -0700 (PDT)
Received: from a077893.arm.com (unknown [10.163.60.115])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 69B543F792;
	Wed, 17 Apr 2024 22:38:19 -0700 (PDT)
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com
Cc: Anshuman Khandual <anshuman.khandual@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Will Deacon <will@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] KVM: arm64: Replace custom macros with fields from ID_AA64PFR0_EL1
Date: Thu, 18 Apr 2024 11:08:03 +0530
Message-Id: <20240418053804.2573071-2-anshuman.khandual@arm.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20240418053804.2573071-1-anshuman.khandual@arm.com>
References: <20240418053804.2573071-1-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This replaces custom macros usage (i.e ID_AA64PFR0_EL1_ELx_64BIT_ONLY and
ID_AA64PFR0_EL1_ELx_32BIT_64BIT) and instead directly uses register fields
from ID_AA64PFR0_EL1 sysreg definition.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: kvmarm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 arch/arm64/kvm/hyp/include/nvhe/fixed_config.h | 8 ++++----
 arch/arm64/kvm/hyp/nvhe/pkvm.c                 | 4 ++--
 arch/arm64/kvm/hyp/nvhe/sys_regs.c             | 2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
index 51f043649146..0034bfffced6 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/fixed_config.h
@@ -52,10 +52,10 @@
  *	Supported by KVM
  */
 #define PVM_ID_AA64PFR0_RESTRICT_UNSIGNED (\
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL1), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL2), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
-	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL3), ID_AA64PFR0_EL1_ELx_64BIT_ONLY) | \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0), ID_AA64PFR0_EL1_EL0_IMP) | \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL1), ID_AA64PFR0_EL1_EL1_IMP) | \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL2), ID_AA64PFR0_EL1_EL2_IMP) | \
+	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL3), ID_AA64PFR0_EL1_EL3_IMP) | \
 	FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_RAS), ID_AA64PFR0_EL1_RAS_IMP) \
 	)
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 26dd9a20ad6e..58da2fec89b2 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -31,9 +31,9 @@ static void pvm_init_traps_aa64pfr0(struct kvm_vcpu *vcpu)
 
 	/* Protected KVM does not support AArch32 guests. */
 	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL0),
-		PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) != ID_AA64PFR0_EL1_ELx_64BIT_ONLY);
+		PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) != ID_AA64PFR0_EL1_EL0_IMP);
 	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL1),
-		PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) != ID_AA64PFR0_EL1_ELx_64BIT_ONLY);
+		PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) != ID_AA64PFR0_EL1_EL1_IMP);
 
 	/*
 	 * Linux guests assume support for floating-point and Advanced SIMD. Do
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index edd969a1f36b..2860548d4250 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -276,7 +276,7 @@ static bool pvm_access_id_aarch32(struct kvm_vcpu *vcpu,
 	 * of AArch32 feature id registers.
 	 */
 	BUILD_BUG_ON(FIELD_GET(ARM64_FEATURE_MASK(ID_AA64PFR0_EL1_EL1),
-		     PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) > ID_AA64PFR0_EL1_ELx_64BIT_ONLY);
+		     PVM_ID_AA64PFR0_RESTRICT_UNSIGNED) > ID_AA64PFR0_EL1_EL1_IMP);
 
 	return pvm_access_raz_wi(vcpu, p, r);
 }
-- 
2.25.1

