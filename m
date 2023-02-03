Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FA4F10E6
	for <kvmarm@lists.linux.dev>; Fri,  3 Feb 2023 04:23:28 +0000 (UTC)
Received: by mail-pl1-f201.google.com with SMTP id s5-20020a170903214500b00195e3b26848so1938900ple.7
        for <kvmarm@lists.linux.dev>; Thu, 02 Feb 2023 20:23:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xpEXHfZvLbpfaKhqxhiDfUYZgyXkf2aFSNA+vKwneRY=;
        b=CU20XaZTa84GhtBhLVM8cHDsTfRVWu4SeFehyh9NtswcjAvNgffGKt3di3DbSi7VAe
         eKj9fkwDnkXLIPB+veEf4siptUwbGFLPfGqnALD6xThehUT8jFHOFFwYgXQ4z1hFsTFt
         zqsn8A4HBczz68w25URq3WBkWLi5DR9WuO/7AFJ2IKsKJDPQ1PrheVLqulPEZHUXLQmg
         otch6vhX54gs5STs2gr2WwWBGGMA7KuG8e86/2UjQtBJ9DPZuDrJP8vA9MqaqzlsrKRa
         zGCPrl8k5lZp9mZ0WG55FX/JmkIZShK4zbca2yxFxbWUbRy4210F5mz4pKpL5wdRk43n
         6P/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xpEXHfZvLbpfaKhqxhiDfUYZgyXkf2aFSNA+vKwneRY=;
        b=zjsFi/ZpN4UwdzSWPQqlA7z6syZdRfAJO8yenHE6dyGrEovu6/AI/m1Q+lILaBx/cr
         Q/eFPiijshUMEoE3eANjkQXst9I3Q2iYWOnKQh6/ULB1ZKgK5BICFHhUGvMpTceezf62
         mPK/nLYqLS5exdRguWlz8V3N2ihGfMU9xJbPxCaVjKVtnqt4DQTBnlfOG10nVX1qEHdB
         mc8o7eSweaW1ygbbZLhymCAl8ixf/zMr9uj3ddGDhsLx0kVu+VXsVo++ILYNbYuw6abK
         9XeQbtGE2lPrD+QCMrTg17Jo8oN89tPYbUCBfcKQrGGVmJazuSrdjNN7ej4femgTfaZB
         MHGQ==
X-Gm-Message-State: AO0yUKVGYL9OYlfALiWFUXZXACRCV3IYLfpTnpph2iT1GEHZdcKWUKhx
	Gxsh/QxhViIJNR0d1iTEPtS6k4bjyqU=
X-Google-Smtp-Source: AK7set/0mGNoOdEuR0rgdSC8ryLt9r67mzIzERGJmYbc/256SmGadiMn1crQB06HpA2fBqvDNM3pX7bJq7E=
X-Received: from reijiw-west4.c.googlers.com ([fda3:e722:ac3:cc00:20:ed76:c0a8:aa1])
 (user=reijiw job=sendgmr) by 2002:a63:1c1e:0:b0:4df:c991:3a74 with SMTP id
 c30-20020a631c1e000000b004dfc9913a74mr1414141pgc.94.1675398207662; Thu, 02
 Feb 2023 20:23:27 -0800 (PST)
Date: Thu,  2 Feb 2023 20:20:49 -0800
In-Reply-To: <20230203042056.1794649-1-reijiw@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20230203042056.1794649-1-reijiw@google.com>
X-Mailer: git-send-email 2.39.1.519.gcb327c4b5f-goog
Message-ID: <20230203042056.1794649-6-reijiw@google.com>
Subject: [PATCH v3 07/14] KVM: arm64: PMU: Simplify extracting PMCR_EL0.N
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	James Morse <james.morse@arm.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Ricardo Koller <ricarkol@google.com>, 
	Oliver Upton <oliver.upton@linux.dev>, Jing Zhang <jingzhangos@google.com>, 
	Raghavendra Rao Anata <rananta@google.com>, Shaoqin Huang <shahuang@redhat.com>, 
	Reiji Watanabe <reijiw@google.com>
Content-Type: text/plain; charset="UTF-8"

Some code extracts PMCR_EL0.N using ARMV8_PMU_PMCR_N_SHIFT and
ARMV8_PMU_PMCR_N_MASK. Define ARMV8_PMU_PMCR_N (0x1f << 11),
and simplify those codes using FIELD_GET() and/or ARMV8_PMU_PMCR_N.
The following patches will also use these macros to extract PMCR_EL0.N.

No functional change intended.

Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/perf_event.h | 2 +-
 arch/arm64/kernel/perf_event.c      | 3 +--
 arch/arm64/kvm/pmu-emul.c           | 3 +--
 arch/arm64/kvm/sys_regs.c           | 7 +++----
 4 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/perf_event.h b/arch/arm64/include/asm/perf_event.h
index 3eaf462f5752..eeef8d56d9c8 100644
--- a/arch/arm64/include/asm/perf_event.h
+++ b/arch/arm64/include/asm/perf_event.h
@@ -219,7 +219,7 @@
 #define ARMV8_PMU_PMCR_LC	(1 << 6) /* Overflow on 64 bit cycle counter */
 #define ARMV8_PMU_PMCR_LP	(1 << 7) /* Long event counter enable */
 #define	ARMV8_PMU_PMCR_N_SHIFT	11	 /* Number of counters supported */
-#define	ARMV8_PMU_PMCR_N_MASK	0x1f
+#define	ARMV8_PMU_PMCR_N	(0x1f << ARMV8_PMU_PMCR_N_SHIFT)
 #define	ARMV8_PMU_PMCR_MASK	0xff	 /* Mask for writable bits */
 
 /*
diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index a5193f2146a6..1775d89a9144 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -1158,8 +1158,7 @@ static void __armv8pmu_probe_pmu(void *info)
 	probe->present = true;
 
 	/* Read the nb of CNTx counters supported from PMNC */
-	cpu_pmu->num_events = (armv8pmu_pmcr_read() >> ARMV8_PMU_PMCR_N_SHIFT)
-		& ARMV8_PMU_PMCR_N_MASK;
+	cpu_pmu->num_events = FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr_read());
 
 	/* Add the CPU cycles counter */
 	cpu_pmu->num_events += 1;
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 701728ad78d6..9dbf532e264e 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -246,9 +246,8 @@ void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 {
-	u64 val = __vcpu_sys_reg(vcpu, PMCR_EL0) >> ARMV8_PMU_PMCR_N_SHIFT;
+	u64 val = FIELD_GET(ARMV8_PMU_PMCR_N, __vcpu_sys_reg(vcpu, PMCR_EL0));
 
-	val &= ARMV8_PMU_PMCR_N_MASK;
 	if (val == 0)
 		return BIT(ARMV8_PMU_CYCLE_IDX);
 	else
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 790f028a1686..9b410a2ea20c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -629,7 +629,7 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 		return;
 
 	/* Only preserve PMCR_EL0.N, and reset the rest to 0 */
-	pmcr = read_sysreg(pmcr_el0) & (ARMV8_PMU_PMCR_N_MASK << ARMV8_PMU_PMCR_N_SHIFT);
+	pmcr = read_sysreg(pmcr_el0) & ARMV8_PMU_PMCR_N;
 	if (!kvm_supports_32bit_el0())
 		pmcr |= ARMV8_PMU_PMCR_LC;
 
@@ -736,10 +736,9 @@ static bool access_pmceid(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 static bool pmu_counter_idx_valid(struct kvm_vcpu *vcpu, u64 idx)
 {
-	u64 pmcr, val;
+	u64 val;
 
-	pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
-	val = (pmcr >> ARMV8_PMU_PMCR_N_SHIFT) & ARMV8_PMU_PMCR_N_MASK;
+	val = FIELD_GET(ARMV8_PMU_PMCR_N, __vcpu_sys_reg(vcpu, PMCR_EL0));
 	if (idx >= val && idx != ARMV8_PMU_CYCLE_IDX) {
 		kvm_inject_undefined(vcpu);
 		return false;
-- 
2.39.1.519.gcb327c4b5f-goog

