Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C8EC433FE
	for <kvmarm@archiver.kernel.org>; Tue,  3 May 2022 06:02:25 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D0AB24B292;
	Tue,  3 May 2022 02:02:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id up6PhAmAmyTn; Tue,  3 May 2022 02:02:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 950274B21F;
	Tue,  3 May 2022 02:02:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A73754B21F
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 02:02:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id g-mvgaZlAvqO for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 02:02:20 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 831BF4B23A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 02:02:20 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 j17-20020a62b611000000b004fa6338bd77so9012956pff.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 02 May 2022 23:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=lyIfp9262fAQLqy8qC0Pz4SUM4FAzF4N7A6nbmSHB2c=;
 b=NTvfdy6F18lFgUV8clR+0g6Lw3bcq5UgO40+92jzBn0iZGYe3Xw9MVeBL3+fvWQw5N
 LB3zzRWSU4HLPPJXB/Dyw7ffCQbjT5/AAfQ9WdrD5WumB7wAGc8Ii16bK1GqoyShUxFT
 T3kMr/bzKtBbctXnCXxWSUOFUbNsLWTvcedPoBzLgEc0OoGSRyBn6HFbR1QI6Sxm0ib1
 LETkvqwaLmlU1m3vcCJyPISK9GXof6Kzpm1nbZPFsnyvcGewnf1XII3NShtf5PlhixsL
 o+7dDUpiE1S+Xes0LqAZedN1LJOIxguMZTGVLGJBoZivv+psCSQs/f/P1ED6jOuNtCkh
 UBAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=lyIfp9262fAQLqy8qC0Pz4SUM4FAzF4N7A6nbmSHB2c=;
 b=JERVLSAfWGEOR3hS997T3wvL35e52md66TimQUEChKCZZpZGPMNecWJWrMn9pumGIi
 au18MpZ/K8B5CX5ZRy3lWtcuPyTfkri0PivNBugZIpsoFXQx0aHOWjQNIOriAmnK99a0
 7HV0zSlV6a9bp8H+GH5adlIzwvy/ls7TscQOGWXcn1UFmt22B/8tR/xf3/wsebHa60HO
 4Unzr37Ok16fEQdUkTxl0048Cht6JkUdyrmEv6j+IL9nvMz+T98TlS1ZVX26LRZA4fGl
 6hxknWMHKRzQyOeZdNvr5mLOu6579fD/M9wmYfXlLIHuB5NZauVXq4Z6E6QEJFATERFR
 Qi2g==
X-Gm-Message-State: AOAM531g39VDweAgw2G1RCQkhKP4gSWV4ZisJsOpmxCB7LBuLqCZH2cP
 kGBUXrsqqxTaKYC7Q1cWZgq6eI5EWrUCtOxMDenRCqU8piLPThhZ3hgFSoozhynGEXwNSpdf4nQ
 1H+Yd2ygJFYOSE6XiMHQ1c7lkiAvwO3O3g5xLoScbd2Hc9cZxjS5zggr8rGwf0V63Yc9F6Q==
X-Google-Smtp-Source: ABdhPJySoUR5II5RZFESdkmpRUNaWMWZc4db9m57Xb50n4CBJPr51KRBblc9PtMJAUv+qFnKQOynLlQ7TLQ=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:90b:e89:b0:1dc:18dc:26a0 with SMTP id
 fv9-20020a17090b0e8900b001dc18dc26a0mr2986517pjb.188.1651557739605; Mon, 02
 May 2022 23:02:19 -0700 (PDT)
Date: Tue,  3 May 2022 06:02:05 +0000
In-Reply-To: <20220503060205.2823727-1-oupton@google.com>
Message-Id: <20220503060205.2823727-8-oupton@google.com>
Mime-Version: 1.0
References: <20220503060205.2823727-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v4 7/7] Revert "KVM/arm64: Don't emulate a PMU for 32-bit
 guests if feature not set"
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

This reverts commit 8f6379e207e7d834065a080f407a60d67349d961.

The original change was not problematic but chose nonarchitected PMU
register behavior over a NULL deref as KVM failed to hide the PMU in the
ID_DFR0.

Since KVM now provides a sane value for ID_DFR0 and UNDEFs the guest for
unsupported accesses, drop the unneeded checks in PMU register handlers.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 23 +----------------------
 1 file changed, 1 insertion(+), 22 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 3dc990ac4f44..78fdc443adc7 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -177,9 +177,6 @@ u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	struct kvm_pmc *pmc = &pmu->pmc[select_idx];
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return 0;
-
 	counter = kvm_pmu_get_pair_counter_value(vcpu, pmc);
 
 	if (kvm_pmu_pmc_is_chained(pmc) &&
@@ -201,9 +198,6 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val)
 {
 	u64 reg;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
-
 	reg = (select_idx == ARMV8_PMU_CYCLE_IDX)
 	      ? PMCCNTR_EL0 : PMEVCNTR0_EL0 + select_idx;
 	__vcpu_sys_reg(vcpu, reg) += (s64)val - kvm_pmu_get_counter_value(vcpu, select_idx);
@@ -328,9 +322,6 @@ void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	struct kvm_pmc *pmc;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
-
 	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E) || !val)
 		return;
 
@@ -366,7 +357,7 @@ void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	struct kvm_pmc *pmc;
 
-	if (!kvm_vcpu_has_pmu(vcpu) || !val)
+	if (!val)
 		return;
 
 	for (i = 0; i < ARMV8_PMU_MAX_COUNTERS; i++) {
@@ -536,9 +527,6 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	int i;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
-
 	if (!(__vcpu_sys_reg(vcpu, PMCR_EL0) & ARMV8_PMU_PMCR_E))
 		return;
 
@@ -588,9 +576,6 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 {
 	int i;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
-
 	if (val & ARMV8_PMU_PMCR_E) {
 		kvm_pmu_enable_counter_mask(vcpu,
 		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0));
@@ -754,9 +739,6 @@ void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 {
 	u64 reg, mask;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return;
-
 	mask  =  ARMV8_PMU_EVTYPE_MASK;
 	mask &= ~ARMV8_PMU_EVTYPE_EVENT;
 	mask |= kvm_pmu_event_mask(vcpu->kvm);
@@ -845,9 +827,6 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 	u64 val, mask = 0;
 	int base, i, nr_events;
 
-	if (!kvm_vcpu_has_pmu(vcpu))
-		return 0;
-
 	if (!pmceid1) {
 		val = read_sysreg(pmceid0_el0);
 		base = 0;
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
