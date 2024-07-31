Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4462B1BE22D;
	Wed, 31 Jul 2024 16:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722444707; cv=none; b=dmVV2mbeQca0NeROpLoe0jS47C3yF6E5A38GjbOteTW+s8Ta0wjiOxGg5BOyz/I2jcpE3hbWXPgT9KZX219iraryubA2t4MFDI2a9yF2DcKnksUTL+4q4L9Js0Ej37egv7GoVAkTcXxCh1YdMjGVvmcdW1xInpGWGag7ycnWNMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722444707; c=relaxed/simple;
	bh=fl6QQWJ1TYAEAJGOtc4iiama492lkFfon7m7OEmsRTE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=lOWfzVteDdPrGeCjZG4wh157FTGBLlLDCcuGy3Gm8ie6GR3g0qCOHzJVEsftlDwm3pEyZ79qwy+YylKdFZZXoXq9yaYuLAdomvs/fFgL8+TykZJ54vYBt9ux5arQ+eXcTnVlvbrLf3ca4FJ/8Se8q2P9o0VzLY06kn9dHWAjLwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BQl/z2R3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BQl/z2R3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C53C4AF09;
	Wed, 31 Jul 2024 16:51:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722444706;
	bh=fl6QQWJ1TYAEAJGOtc4iiama492lkFfon7m7OEmsRTE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=BQl/z2R3wRp2KLdXFrNdqljCQahHMSr6UMvVWsCHXkDYvjUQXjDxva1+uIk5T0u2H
	 ELJfPspuIGEidBHjQoHP9KC2c3FjJfz/SmfoN/+Y/vcAx2SrUSrpGgEEAGIW/CCc6I
	 VMGa8acq2JQVSdGLqHbyP9hAJpKfMw4ZUqF+dBQL9qIczZrB+38uz+ERo2+6ya5LDN
	 GPNx+Sr/PDZZrcLeCbkbkURR5SL8Bg30PYq4pUiGwdRWU1cWfEjC1QBWjj2oHLT4Ej
	 r/Hj33IetCE1vrD3Hb1XpowaSZ0r0eSBWS5obbAO++KBjhf0inFqVwUNeWvurntJT3
	 OZ71VuJ1Xeh2A==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Wed, 31 Jul 2024 10:51:21 -0600
Subject: [PATCH v3 4/7] KVM: arm64: pmu: Use generated define for
 PMSELR_EL0.SEL access
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240731-arm-pmu-3-9-icntr-v3-4-280a8d7ff465@kernel.org>
References: <20240731-arm-pmu-3-9-icntr-v3-0-280a8d7ff465@kernel.org>
In-Reply-To: <20240731-arm-pmu-3-9-icntr-v3-0-280a8d7ff465@kernel.org>
To: Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, James Clark <james.clark@linaro.org>, 
 James Morse <james.morse@arm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@kernel.org>, 
 Namhyung Kim <namhyung@kernel.org>, 
 Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
 Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
 Adrian Hunter <adrian.hunter@intel.com>, 
 Oliver Upton <oliver.upton@linux.dev>, Zenghui Yu <yuzenghui@huawei.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
 linux-perf-users@vger.kernel.org, kvmarm@lists.linux.dev
X-Mailer: b4 0.15-dev

ARMV8_PMU_COUNTER_MASK is really a mask for the PMSELR_EL0.SEL register
field. Make that clear by adding a standard sysreg definition for the
register, and using it instead.

Reviewed-by: Mark Rutland <mark.rutland@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
 arch/arm64/include/asm/sysreg.h |  1 -
 arch/arm64/kvm/sys_regs.c       | 10 +++++-----
 arch/arm64/tools/sysreg         |  5 +++++
 include/linux/perf/arm_pmuv3.h  |  1 -
 4 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index 4a9ea103817e..00af1c331c1e 100644
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
index c90324060436..33497db257fb 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -887,7 +887,7 @@ static u64 reset_pmevtyper(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 static u64 reset_pmselr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 {
 	reset_unknown(vcpu, r);
-	__vcpu_sys_reg(vcpu, r->reg) &= ARMV8_PMU_COUNTER_MASK;
+	__vcpu_sys_reg(vcpu, r->reg) &= PMSELR_EL0_SEL_MASK;
 
 	return __vcpu_sys_reg(vcpu, r->reg);
 }
@@ -979,7 +979,7 @@ static bool access_pmselr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 	else
 		/* return PMSELR.SEL field */
 		p->regval = __vcpu_sys_reg(vcpu, PMSELR_EL0)
-			    & ARMV8_PMU_COUNTER_MASK;
+			    & PMSELR_EL0_SEL_MASK;
 
 	return true;
 }
@@ -1047,8 +1047,8 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 			if (pmu_access_event_counter_el0_disabled(vcpu))
 				return false;
 
-			idx = __vcpu_sys_reg(vcpu, PMSELR_EL0)
-			      & ARMV8_PMU_COUNTER_MASK;
+			idx = SYS_FIELD_GET(PMSELR_EL0, SEL,
+					    __vcpu_sys_reg(vcpu, PMSELR_EL0));
 		} else if (r->Op2 == 0) {
 			/* PMCCNTR_EL0 */
 			if (pmu_access_cycle_counter_el0_disabled(vcpu))
@@ -1098,7 +1098,7 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 	if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 1) {
 		/* PMXEVTYPER_EL0 */
-		idx = __vcpu_sys_reg(vcpu, PMSELR_EL0) & ARMV8_PMU_COUNTER_MASK;
+		idx = SYS_FIELD_GET(PMSELR_EL0, SEL, __vcpu_sys_reg(vcpu, PMSELR_EL0));
 		reg = PMEVTYPER0_EL0 + idx;
 	} else if (r->CRn == 14 && (r->CRm & 12) == 12) {
 		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
diff --git a/arch/arm64/tools/sysreg b/arch/arm64/tools/sysreg
index 7ceaa1e0b4bc..37aa7eaad07b 100644
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

