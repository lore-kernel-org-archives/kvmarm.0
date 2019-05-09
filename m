Return-Path: <SRS0=QEDf=TJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7532AC04AB1
	for <kvmarm@archiver.kernel.org>; Thu,  9 May 2019 15:32:26 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 317D62084E
	for <kvmarm@archiver.kernel.org>; Thu,  9 May 2019 15:32:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 317D62084E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE64C4A4AB;
	Thu,  9 May 2019 11:32:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Dz0ikV82bkhO; Thu,  9 May 2019 11:32:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7A7A84A4CB;
	Thu,  9 May 2019 11:32:24 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3F2F14A49C
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 May 2019 11:32:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GVD5swjXOqr9 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 May 2019 11:32:21 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BB9F34A47A
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 May 2019 11:32:21 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 288F115AD;
 Thu,  9 May 2019 08:32:21 -0700 (PDT)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8C83D3F6C4;
 Thu,  9 May 2019 08:32:19 -0700 (PDT)
From: Andrew Murray <andrew.murray@arm.com>
To: Christoffer Dall <christoffer.dall@arm.com>,
 Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v6 1/5] KVM: arm/arm64: rename
 kvm_pmu_{enable/disable}_counter functions
Date: Thu,  9 May 2019 16:32:08 +0100
Message-Id: <20190509153212.24187-2-andrew.murray@arm.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190509153212.24187-1-andrew.murray@arm.com>
References: <20190509153212.24187-1-andrew.murray@arm.com>
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

The kvm_pmu_{enable/disable}_counter functions can enabled/disable
multiple counters at once as they operate on a bitmask. Let's
make this clearer by renaming the function.

Suggested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Andrew Murray <andrew.murray@arm.com>
Reviewed-by: Julien Thierry <julien.thierry@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arch/arm64/kvm/sys_regs.c |  4 ++--
 include/kvm/arm_pmu.h     |  8 ++++----
 virt/kvm/arm/pmu.c        | 12 ++++++------
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 9d02643bc601..8e98fb173ed3 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -876,12 +876,12 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		if (r->Op2 & 0x1) {
 			/* accessing PMCNTENSET_EL0 */
 			__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) |= val;
-			kvm_pmu_enable_counter(vcpu, val);
+			kvm_pmu_enable_counter_mask(vcpu, val);
 			kvm_vcpu_pmu_restore_guest(vcpu);
 		} else {
 			/* accessing PMCNTENCLR_EL0 */
 			__vcpu_sys_reg(vcpu, PMCNTENSET_EL0) &= ~val;
-			kvm_pmu_disable_counter(vcpu, val);
+			kvm_pmu_disable_counter_mask(vcpu, val);
 		}
 	} else {
 		p->regval = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index f87fe20fcb05..b73f31baca52 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -46,8 +46,8 @@ void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
 u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu);
 void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu);
 void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu);
-void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val);
-void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val);
+void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val);
+void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu);
 void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu);
 bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu);
@@ -83,8 +83,8 @@ static inline u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 }
 static inline void kvm_pmu_vcpu_reset(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_vcpu_destroy(struct kvm_vcpu *vcpu) {}
-static inline void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val) {}
-static inline void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val) {}
+static inline void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val) {}
+static inline void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_flush_hwstate(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu) {}
 static inline bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu)
diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index 1c5b76c46e26..c5a722ad283f 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -135,13 +135,13 @@ u64 kvm_pmu_valid_counter_mask(struct kvm_vcpu *vcpu)
 }
 
 /**
- * kvm_pmu_enable_counter - enable selected PMU counter
+ * kvm_pmu_enable_counter_mask - enable selected PMU counters
  * @vcpu: The vcpu pointer
  * @val: the value guest writes to PMCNTENSET register
  *
  * Call perf_event_enable to start counting the perf event
  */
-void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val)
+void kvm_pmu_enable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 {
 	int i;
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
@@ -164,13 +164,13 @@ void kvm_pmu_enable_counter(struct kvm_vcpu *vcpu, u64 val)
 }
 
 /**
- * kvm_pmu_disable_counter - disable selected PMU counter
+ * kvm_pmu_disable_counter_mask - disable selected PMU counters
  * @vcpu: The vcpu pointer
  * @val: the value guest writes to PMCNTENCLR register
  *
  * Call perf_event_disable to stop counting the perf event
  */
-void kvm_pmu_disable_counter(struct kvm_vcpu *vcpu, u64 val)
+void kvm_pmu_disable_counter_mask(struct kvm_vcpu *vcpu, u64 val)
 {
 	int i;
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
@@ -347,10 +347,10 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 
 	mask = kvm_pmu_valid_counter_mask(vcpu);
 	if (val & ARMV8_PMU_PMCR_E) {
-		kvm_pmu_enable_counter(vcpu,
+		kvm_pmu_enable_counter_mask(vcpu,
 		       __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask);
 	} else {
-		kvm_pmu_disable_counter(vcpu, mask);
+		kvm_pmu_disable_counter_mask(vcpu, mask);
 	}
 
 	if (val & ARMV8_PMU_PMCR_C)
-- 
2.21.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
