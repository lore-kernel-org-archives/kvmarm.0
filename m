Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64AB62139A8
	for <kvmarm@lists.linux.dev>; Fri, 14 Feb 2025 13:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739540249; cv=none; b=qD/jUFjrLx7ejQOGId0eUHsHTxvsDv2jtJqFTNhUm2yrWLOSGI+izeeehf7+L6Gf+9fujDVdANV/B/mbB29IbZY35z/Q++MzWv2bXM2FTqw+oP/Dgwji5XVjYYuqceqG4gfEyzcbzHwACkEAjvZVysnarbtT8eZOUQeFK6ziXV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739540249; c=relaxed/simple;
	bh=U4x9WKqLXQ5Tvglt8O1CbvzqfZ5+NYMLWfEWNektUw4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=GZTarPehAl3tEyi10ijbI93JTHftYuCPi5v81TVOiie8/3U4k6jD9dlvEELjKxdH5YCUl4qaolnYWo8oezrnDwqVFl2NJEqSlaUniBmfQyfioe83inSic80Z9KadC2qzohUCg3sDEAAllI929gpoOQ6W0GvedOeCgTTkhaVYZvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ht4VykWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ht4VykWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0E11C4CED1;
	Fri, 14 Feb 2025 13:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739540248;
	bh=U4x9WKqLXQ5Tvglt8O1CbvzqfZ5+NYMLWfEWNektUw4=;
	h=From:To:Cc:Subject:Date:From;
	b=Ht4VykWzrJodsCc4bsbSXg1NuO7BmD5Fu0H3zQeXRfwnF8k2cy7ALXwv7SOPr9grA
	 o1IBr3oVRpLRTPPHEfxkTgbyLV4Tj20zQcmdSQ1ml/q6At12fAycJWcIwwv5hoMnsx
	 QFLvNqXB+mUkFa6Zv8jo4wGn7byIzvmrHJgWYIS1F9ECyWgA52A7e6DnFgYZLunlLZ
	 V5NQFlDoWflp9pDULqwiJCk4cZX8Ox8AgoWSREvQ8t98yAHe1wD3YLTSRJTPylEGzN
	 7HOXN6rVTHEImnshiZA1bIXRg4TtkkVJ0kx613TDgk7tokHEfvY1ISZS9TjQ9/Pvmg
	 7Cn3iu+6L/qTQ==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH] KVM: arm64: Fix tcr_el2 initialisation in hVHE mode
Date: Fri, 14 Feb 2025 13:37:24 +0000
Message-Id: <20250214133724.13179-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When not running in VHE mode, cpu_prepare_hyp_mode() computes the value
of TCR_EL2 using the host's TCR_EL1 settings as a starting point. For
nVHE, this amounts to masking out everything apart from the TG0, SH0,
ORGN0, IRGN0 and T0SZ fields before setting the RES1 bits, shifting the
IPS field down to the PS field and setting DS if LPA2 is enabled.

Unfortunately, for hVHE, things go slightly wonky: EPD1 is correctly set
to disable walks via TTBR1_EL2 but then the T1SZ and IPS fields are
corrupted when we mistakenly attempt to initialise the PS and DS fields
in their E2H=0 positions. Furthermore, many fields are retained from
TCR_EL1 which should not be propagated to TCR_EL2. Notably, this means
we can end up with A1 set despite not initialising TTBR1_EL2 at all.
This has been shown to cause unexpected translation faults at EL2 with
pKVM due to TLB invalidation not taking effect when running with a
non-zero ASID.

Fix the TCR_EL2 initialisation code to set PS and DS only when E2H=0,
masking out HD, HA and A1 when E2H=1.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oliver.upton@linux.dev>
Fixes: ad744e8cb346 ("arm64: Allow arm64_sw.hvhe on command line")
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_arm.h |  2 +-
 arch/arm64/kvm/arm.c             | 15 +++++++--------
 2 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 8d94a6c0ed5c..c2417a424b98 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -119,7 +119,7 @@
 #define TCR_EL2_IRGN0_MASK	TCR_IRGN0_MASK
 #define TCR_EL2_T0SZ_MASK	0x3f
 #define TCR_EL2_MASK	(TCR_EL2_TG0_MASK | TCR_EL2_SH0_MASK | \
-			 TCR_EL2_ORGN0_MASK | TCR_EL2_IRGN0_MASK | TCR_EL2_T0SZ_MASK)
+			 TCR_EL2_ORGN0_MASK | TCR_EL2_IRGN0_MASK)
 
 /* VTCR_EL2 Registers bits */
 #define VTCR_EL2_DS		TCR_EL2_DS
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 646e806c6ca6..d498edf88f05 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1980,7 +1980,7 @@ static int kvm_init_vector_slots(void)
 static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 {
 	struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
-	unsigned long tcr, ips;
+	unsigned long tcr;
 
 	/*
 	 * Calculate the raw per-cpu offset without a translation from the
@@ -1994,19 +1994,18 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 	params->mair_el2 = read_sysreg(mair_el1);
 
 	tcr = read_sysreg(tcr_el1);
-	ips = FIELD_GET(TCR_IPS_MASK, tcr);
 	if (cpus_have_final_cap(ARM64_KVM_HVHE)) {
+		tcr &= ~(TCR_HD | TCR_HA | TCR_A1 | TCR_T0SZ_MASK);
 		tcr |= TCR_EPD1_MASK;
 	} else {
+		unsigned long ips = FIELD_GET(TCR_IPS_MASK, tcr);
+
 		tcr &= TCR_EL2_MASK;
-		tcr |= TCR_EL2_RES1;
+		tcr |= TCR_EL2_RES1 | FIELD_PREP(TCR_EL2_PS_MASK, ips);
+		if (lpa2_is_enabled())
+			tcr |= TCR_EL2_DS;
 	}
-	tcr &= ~TCR_T0SZ_MASK;
 	tcr |= TCR_T0SZ(hyp_va_bits);
-	tcr &= ~TCR_EL2_PS_MASK;
-	tcr |= FIELD_PREP(TCR_EL2_PS_MASK, ips);
-	if (lpa2_is_enabled())
-		tcr |= TCR_EL2_DS;
 	params->tcr_el2 = tcr;
 
 	params->pgd_pa = kvm_mmu_get_httbr();
-- 
2.48.1.601.g30ceb7b040-goog

