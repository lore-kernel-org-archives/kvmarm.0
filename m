Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FC4194C8E;
	Wed, 26 Jun 2024 22:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719441172; cv=none; b=YMYnWqghZNzqc1K5WikGrW3tARIkbSl7smywdogGKHDmD7tnJb3xFZH/CTxQq4Oohgrp0VeXvx/I7VUQtS6SfPjGQ9b2Ijvyz7fU4JgyLdvakLjMAahYIiXBaTjU9U3pO5RKPQpg3wX8QhOwLKpZ1NCRV/fbtV6fWgzImc7whjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719441172; c=relaxed/simple;
	bh=tyMiWNvWYQkimPKJefEkwj8BKVWrUeWAWKDVG4Kh28E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dyA0YsYwoKX75x6AZr115Em/3++djOLxqDLXqDA0o1u8BCQ6lmCQPLT9Ry5DtcBslBPSYG/7pP5DoCK2tX2Iu9BHxibchI3QZVH3Z2XHJJxcBxDPdVIwvIJkKYnOW/ct1IZRIW1KDXvjBI0mPLCDeH1G6VVjHX4qkoDyhBxfT5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=McJYzcYH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="McJYzcYH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1070C116B1;
	Wed, 26 Jun 2024 22:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719441172;
	bh=tyMiWNvWYQkimPKJefEkwj8BKVWrUeWAWKDVG4Kh28E=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=McJYzcYHno8/yujVw3yyS0hJzkucjbYYyDpL6lsFwJX7VBRlQ/ggzBXVivoFGkJNS
	 gtXv+p/KWZs8ydSxA/VOOG7vFac5FW63KFiVEHZ5n1C9BuMcLtJrOnWsFRr3bDrFI2
	 VbAClZmkZAlUhI7xuQRe6i1UE5aAs8AySdOrD1Q83WpNisaZbi6+GomsqofRqPH8Bx
	 rVXQHfA09FQt9v7BPQxPCb3/6LZQfJ4GvCon1ZuOxsj8HBJr8TpPJBjvDS7TTTUZa4
	 CHWHOy/wGY8i4oE/nuCeiT/SaI1Sb+MQ2jW4v0l6m2HaYI5oyd+GXOEIFhjjBq5A/E
	 JGM+J00WHMeXg==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Wed, 26 Jun 2024 16:32:33 -0600
Subject: [PATCH v2 09/12] KVM: arm64: pmu: Use generated define for
 PMSELR_EL0.SEL access
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240626-arm-pmu-3-9-icntr-v2-9-c9784b4f4065@kernel.org>
References: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
In-Reply-To: <20240626-arm-pmu-3-9-icntr-v2-0-c9784b4f4065@kernel.org>
To: Russell King <linux@armlinux.org.uk>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, Will Deacon <will@kernel.org>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 James Clark <james.clark@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
X-Mailer: b4 0.14-dev

ARMV8_PMU_COUNTER_MASK is really a mask for the PMSELR_EL0.SEL register
field. Make that clear by adding a standard sysreg definition for the
register, and using it instead.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 arch/arm64/include/asm/sysreg.h |  1 -
 arch/arm64/kvm/sys_regs.c       | 10 +++++-----
 arch/arm64/tools/sysreg         |  5 +++++
 include/linux/perf/arm_pmuv3.h  |  1 -
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index af3b206fa423..b0d6c33f9ecc 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -403,7 +403,6 @@
 #define SYS_PMCNTENCLR_EL0		sys_reg(3, 3, 9, 12, 2)
 #define SYS_PMOVSCLR_EL0		sys_reg(3, 3, 9, 12, 3)
 #define SYS_PMSWINC_EL0			sys_reg(3, 3, 9, 12, 4)
-#define SYS_PMSELR_EL0			sys_reg(3, 3, 9, 12, 5)
 #define SYS_PMCEID0_EL0			sys_reg(3, 3, 9, 12, 6)
 #define SYS_PMCEID1_EL0			sys_reg(3, 3, 9, 12, 7)
 #define SYS_PMCCNTR_EL0			sys_reg(3, 3, 9, 13, 0)
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 22b45a15d068..f8b5db48ea8a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -880,7 +880,7 @@ static u64 reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 static u64 reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	reset_unknown(vcpu, r);
-	__vcpu_sys_reg(vcpu, r->reg) &= ARMV8_PMU_COUNTER_MASK;
+	__vcpu_sys_reg(vcpu, r->reg) &= PMSELR_EL0_SEL_MASK;
 
 	return __vcpu_sys_reg(vcpu, r->reg);
 }
@@ -972,7 +972,7 @@ static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	else
 		/* return PMSELR.SEL field */
 		p->regval = __vcpu_sys_reg(vcpu, PMSELR_EL0)
-			    & ARMV8_PMU_COUNTER_MASK;
+			    & PMSELR_EL0_SEL_MASK;
 
 	return true;
 }
@@ -1040,8 +1040,8 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 			if (pmu_access_event_counter_el0_disabled(vcpu))
 				return false;
 
-			idx = __vcpu_sys_reg(vcpu, PMSELR_EL0)
-			      & ARMV8_PMU_COUNTER_MASK;
+			idx = SYS_FIELD_GET(PMSELR_EL0, SEL,
+					    __vcpu_sys_reg(vcpu, PMSELR_EL0));
 		} else if (r->Op2 == 0) {
 			/* PMCCNTR_EL0 */
 			if (pmu_access_cycle_counter_el0_disabled(vcpu))
@@ -1091,7 +1091,7 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 	if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 1) {
 		/* PMXEVTYPER_EL0 */
-		idx = __vcpu_sys_reg(vcpu, PMSELR_EL0) & ARMV8_PMU_COUNTER_MASK;
+		idx = SYS_FIELD_GET(PMSELR_EL0, SEL, __vcpu_sys_reg(vcpu, PMSELR_EL0));
 		reg = PMEVTYPER0_EL0 + idx;
 	} else if (r->CRn == 14 && (r->CRm & 12) == 12) {
 		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index a4c1dd4741a4..231817a379b5 100644
--- a/arch/arm64/tools/sysreg
+++ b/arch/arm64/tools/sysreg
@@ -2153,6 +2153,11 @@ Field	4	P
 Field	3:0	ALIGN
 EndSysreg
 
+Sysreg	PMSELR_EL0	3	3	9	12	5
+Res0	63:5
+Field	4:0	SEL
+EndSysreg
+
 SysregFields	CONTEXTIDR_ELx
 Res0	63:32
 Field	31:0	PROCID
diff --git a/include/linux/perf/arm_pmuv3.h b/include/linux/perf/arm_pmuv3.h
index eccbdd8eb98f..792b8e10b72a 100644
--- a/include/linux/perf/arm_pmuv3.h
+++ b/include/linux/perf/arm_pmuv3.h
@@ -8,7 +8,6 @@
 
 #define ARMV8_PMU_MAX_GENERAL_COUNTERS	31
 #define ARMV8_PMU_MAX_COUNTERS	32
-#define ARMV8_PMU_COUNTER_MASK	(ARMV8_PMU_MAX_COUNTERS - 1)
 
 /*
  * Common architectural and microarchitectural event numbers.

-- 
2.43.0

