Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E95AC433F5
	for <kvmarm@archiver.kernel.org>; Thu, 27 Jan 2022 16:18:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E7804B0C0;
	Thu, 27 Jan 2022 11:18:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2H3Up6AVnNWH; Thu, 27 Jan 2022 11:18:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ABA9D4B0B6;
	Thu, 27 Jan 2022 11:18:09 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4D7554B0D7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 11:18:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I3zbtAstpe0d for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Jan 2022 11:18:07 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E99644A11C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Jan 2022 11:18:05 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7D87612FC;
 Thu, 27 Jan 2022 08:18:05 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 331993F766;
 Thu, 27 Jan 2022 08:18:03 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 will@kernel.org, mark.rutland@arm.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Subject: [PATCH v4 3/6] KVM: arm64: Keep a per-VM pointer to the default PMU
Date: Thu, 27 Jan 2022 16:17:56 +0000
Message-Id: <20220127161759.53553-4-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220127161759.53553-1-alexandru.elisei@arm.com>
References: <20220127161759.53553-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: tglx@linutronix.de, mingo@redhat.com
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

From: Marc Zyngier <maz@kernel.org>

As we are about to allow selection of the PMU exposed to a guest, start by
keeping track of the default one instead of only the PMU version.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/kvm/pmu-emul.c         | 42 +++++++++++++++++++------------
 2 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 2869259e10c0..57141a3a3740 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -129,7 +129,7 @@ struct kvm_arch {
 	 * up to 2^10 events (ARMv8.0) or 2^16 events (ARMv8.1+).
 	 */
 	unsigned long *pmu_filter;
-	unsigned int pmuver;
+	struct arm_pmu *arm_pmu;
 
 	u8 pfr0_csv2;
 	u8 pfr0_csv3;
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index bc771bc1a041..b238b3d5515c 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -24,7 +24,11 @@ static void kvm_pmu_stop_counter(struct kvm_vcpu *vcpu, struct kvm_pmc *pmc);
 
 static u32 kvm_pmu_event_mask(struct kvm *kvm)
 {
-	switch (kvm->arch.pmuver) {
+	unsigned int pmuver;
+
+	pmuver = kvm->arch.arm_pmu->pmuver;
+
+	switch (pmuver) {
 	case ID_AA64DFR0_PMUVER_8_0:
 		return GENMASK(9, 0);
 	case ID_AA64DFR0_PMUVER_8_1:
@@ -33,7 +37,7 @@ static u32 kvm_pmu_event_mask(struct kvm *kvm)
 	case ID_AA64DFR0_PMUVER_8_7:
 		return GENMASK(15, 0);
 	default:		/* Shouldn't be here, just for sanity */
-		WARN_ONCE(1, "Unknown PMU version %d\n", kvm->arch.pmuver);
+		WARN_ONCE(1, "Unknown PMU version %d\n", pmuver);
 		return 0;
 	}
 }
@@ -600,6 +604,7 @@ static bool kvm_pmu_counter_is_enabled(struct kvm_vcpu *vcpu, u64 select_idx)
  */
 static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 {
+	struct arm_pmu *arm_pmu = vcpu->kvm->arch.arm_pmu;
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	struct kvm_pmc *pmc;
 	struct perf_event *event;
@@ -636,7 +641,7 @@ static void kvm_pmu_create_perf_event(struct kvm_vcpu *vcpu, u64 select_idx)
 		return;
 
 	memset(&attr, 0, sizeof(struct perf_event_attr));
-	attr.type = PERF_TYPE_RAW;
+	attr.type = arm_pmu->pmu.type;
 	attr.size = sizeof(attr);
 	attr.pinned = 1;
 	attr.disabled = !kvm_pmu_counter_is_enabled(vcpu, pmc->idx);
@@ -750,12 +755,11 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 		static_branch_enable(&kvm_arm_pmu_available);
 }
 
-static int kvm_pmu_probe_pmuver(void)
+static struct arm_pmu *kvm_pmu_probe_armpmu(void)
 {
 	struct perf_event_attr attr = { };
 	struct perf_event *event;
-	struct arm_pmu *pmu;
-	int pmuver = ID_AA64DFR0_PMUVER_IMP_DEF;
+	struct arm_pmu *pmu = NULL;
 
 	/*
 	 * Create a dummy event that only counts user cycles. As we'll never
@@ -780,19 +784,20 @@ static int kvm_pmu_probe_pmuver(void)
 	if (IS_ERR(event)) {
 		pr_err_once("kvm: pmu event creation failed %ld\n",
 			    PTR_ERR(event));
-		return ID_AA64DFR0_PMUVER_IMP_DEF;
+		return NULL;
 	}
 
 	if (event->pmu) {
 		pmu = to_arm_pmu(event->pmu);
-		if (pmu->pmuver)
-			pmuver = pmu->pmuver;
+		if (pmu->pmuver == 0 ||
+		    pmu->pmuver == ID_AA64DFR0_PMUVER_IMP_DEF)
+			pmu = NULL;
 	}
 
 	perf_event_disable(event);
 	perf_event_release_kernel(event);
 
-	return pmuver;
+	return pmu;
 }
 
 u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
@@ -810,7 +815,7 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 		 * Don't advertise STALL_SLOT, as PMMIR_EL0 is handled
 		 * as RAZ
 		 */
-		if (vcpu->kvm->arch.pmuver >= ID_AA64DFR0_PMUVER_8_4)
+		if (vcpu->kvm->arch.arm_pmu->pmuver >= ID_AA64DFR0_PMUVER_8_4)
 			val &= ~BIT_ULL(ARMV8_PMUV3_PERFCTR_STALL_SLOT - 32);
 		base = 32;
 	}
@@ -932,11 +937,16 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	if (vcpu->arch.pmu.created)
 		return -EBUSY;
 
-	if (!vcpu->kvm->arch.pmuver)
-		vcpu->kvm->arch.pmuver = kvm_pmu_probe_pmuver();
-
-	if (vcpu->kvm->arch.pmuver == ID_AA64DFR0_PMUVER_IMP_DEF)
-		return -ENODEV;
+	mutex_lock(&kvm->lock);
+	if (!kvm->arch.arm_pmu) {
+		/* No PMU set, get the default one */
+		kvm->arch.arm_pmu = kvm_pmu_probe_armpmu();
+		if (!kvm->arch.arm_pmu) {
+			mutex_unlock(&kvm->lock);
+			return -ENODEV;
+		}
+	}
+	mutex_unlock(&kvm->lock);
 
 	switch (attr->attr) {
 	case KVM_ARM_VCPU_PMU_V3_IRQ: {
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
