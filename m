Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D029A2DE1ED
	for <kvmarm@lists.linux.dev>; Tue, 17 Jun 2025 13:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750167466; cv=none; b=a4jpwtG9ZoSryGtzgb//QKdcpoWTOIjnXg0ItQT6XihP4J3PekaIEpEeu6xsxjvCwqnhEXU0/YtymIHAEBYeVxbsGqPQ2dVKsLj5JOuRx9sp8RABxPoXddDQqyp8b6jUX/P5cXCV4r97xBA9R3pmWriG/v5ucsKRGNYacgYILME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750167466; c=relaxed/simple;
	bh=u652btmsRbrhyKDregRY+g2ctgvEE/SZwaFb8GGTSvc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rrYvrfjOIACyvpcXu6fmlTY3ipVcfhRp9ux9WGgBbREbjb7fCDI7uZeIMnNPXELoFJAsZEohq8/CiYSJN6U4Ma8ILs1uJiE193iCuIWrbjlpXhZDVorvsYilIy4NyEL+eGSCw5VDE1bhXqd4vu00SwwyKUvwSdw7FxeJwfx/nSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7664A1595;
	Tue, 17 Jun 2025 06:37:23 -0700 (PDT)
Received: from lakrids.cambridge.arm.com (usa-sjc-imap-foss1.foss.arm.com [10.121.207.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BD3B83F673;
	Tue, 17 Jun 2025 06:37:42 -0700 (PDT)
From: Mark Rutland <mark.rutland@arm.com>
To: linux-arm-kernel@lists.infradead.org
Cc: broonie@kernel.org,
	catalin.marinas@arm.com,
	kvmarm@lists.linux.dev,
	mark.rutland@arm.com,
	maz@kernel.org,
	oliver.upton@linux.dev,
	stable@vger.kernel.org,
	tabba@google.com,
	will@kernel.org
Subject: [PATCH 6/7] KVM: arm64: Remove cpacr_clear_set()
Date: Tue, 17 Jun 2025 14:37:17 +0100
Message-Id: <20250617133718.4014181-7-mark.rutland@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20250617133718.4014181-1-mark.rutland@arm.com>
References: <20250617133718.4014181-1-mark.rutland@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We no longer use cpacr_clear_set().

Remove cpacr_clear_set() and its helper functions.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Mark Brown <broonie@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_emulate.h | 62 ----------------------------
 1 file changed, 62 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index bd020fc28aa9c..0720898f563e9 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -561,68 +561,6 @@ static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
 		vcpu_set_flag((v), e);					\
 	} while (0)
 
-#define __build_check_all_or_none(r, bits)				\
-	BUILD_BUG_ON(((r) & (bits)) && ((r) & (bits)) != (bits))
-
-#define __cpacr_to_cptr_clr(clr, set)					\
-	({								\
-		u64 cptr = 0;						\
-									\
-		if ((set) & CPACR_EL1_FPEN)				\
-			cptr |= CPTR_EL2_TFP;				\
-		if ((set) & CPACR_EL1_ZEN)				\
-			cptr |= CPTR_EL2_TZ;				\
-		if ((set) & CPACR_EL1_SMEN)				\
-			cptr |= CPTR_EL2_TSM;				\
-		if ((clr) & CPACR_EL1_TTA)				\
-			cptr |= CPTR_EL2_TTA;				\
-		if ((clr) & CPTR_EL2_TAM)				\
-			cptr |= CPTR_EL2_TAM;				\
-		if ((clr) & CPTR_EL2_TCPAC)				\
-			cptr |= CPTR_EL2_TCPAC;				\
-									\
-		cptr;							\
-	})
-
-#define __cpacr_to_cptr_set(clr, set)					\
-	({								\
-		u64 cptr = 0;						\
-									\
-		if ((clr) & CPACR_EL1_FPEN)				\
-			cptr |= CPTR_EL2_TFP;				\
-		if ((clr) & CPACR_EL1_ZEN)				\
-			cptr |= CPTR_EL2_TZ;				\
-		if ((clr) & CPACR_EL1_SMEN)				\
-			cptr |= CPTR_EL2_TSM;				\
-		if ((set) & CPACR_EL1_TTA)				\
-			cptr |= CPTR_EL2_TTA;				\
-		if ((set) & CPTR_EL2_TAM)				\
-			cptr |= CPTR_EL2_TAM;				\
-		if ((set) & CPTR_EL2_TCPAC)				\
-			cptr |= CPTR_EL2_TCPAC;				\
-									\
-		cptr;							\
-	})
-
-#define cpacr_clear_set(clr, set)					\
-	do {								\
-		BUILD_BUG_ON((set) & CPTR_VHE_EL2_RES0);		\
-		BUILD_BUG_ON((clr) & CPACR_EL1_E0POE);			\
-		__build_check_all_or_none((clr), CPACR_EL1_FPEN);	\
-		__build_check_all_or_none((set), CPACR_EL1_FPEN);	\
-		__build_check_all_or_none((clr), CPACR_EL1_ZEN);	\
-		__build_check_all_or_none((set), CPACR_EL1_ZEN);	\
-		__build_check_all_or_none((clr), CPACR_EL1_SMEN);	\
-		__build_check_all_or_none((set), CPACR_EL1_SMEN);	\
-									\
-		if (has_vhe() || has_hvhe())				\
-			sysreg_clear_set(cpacr_el1, clr, set);		\
-		else							\
-			sysreg_clear_set(cptr_el2,			\
-					 __cpacr_to_cptr_clr(clr, set),	\
-					 __cpacr_to_cptr_set(clr, set));\
-	} while (0)
-
 /*
  * Returns a 'sanitised' view of CPTR_EL2, translating from nVHE to the VHE
  * format if E2H isn't set.
-- 
2.30.2

