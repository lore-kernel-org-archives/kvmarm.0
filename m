Return-Path: <SRS0=jshR=CN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E35C43461
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 09:29:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3525420770
	for <kvmarm@archiver.kernel.org>; Fri,  4 Sep 2020 09:29:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3525420770
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D4E604B0A0;
	Fri,  4 Sep 2020 05:29:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UChCb48Csp3y; Fri,  4 Sep 2020 05:29:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DA544B37A;
	Fri,  4 Sep 2020 05:29:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24A2D4B0A0
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 05:29:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yUswWYlkb2Qr for <kvmarm@lists.cs.columbia.edu>;
 Fri,  4 Sep 2020 05:29:42 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE78B4B144
 for <kvmarm@lists.cs.columbia.edu>; Fri,  4 Sep 2020 05:29:41 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B07514BF;
 Fri,  4 Sep 2020 02:29:41 -0700 (PDT)
Received: from localhost.localdomain (entos-thunderx2-desktop.shanghai.arm.com
 [10.169.212.215])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id E85AA3F66F;
 Fri,  4 Sep 2020 02:29:35 -0700 (PDT)
From: Jianyong Wu <jianyong.wu@arm.com>
To: netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
 tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com,
 maz@kernel.org, richardcochran@gmail.com, Mark.Rutland@arm.com,
 will@kernel.org, suzuki.poulose@arm.com, steven.price@arm.com
Subject: [PATCH v14 07/10] arm64/kvm: Add hypercall service for kvm ptp.
Date: Fri,  4 Sep 2020 17:27:41 +0800
Message-Id: <20200904092744.167655-8-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200904092744.167655-1-jianyong.wu@arm.com>
References: <20200904092744.167655-1-jianyong.wu@arm.com>
Cc: justin.he@arm.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
 nd@arm.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

ptp_kvm will get this service through smccc call.
The service offers wall time and counter cycle of host for guest.
caller must explicitly determines which cycle of virtual counter or
physical counter to return if it needs counter cycle.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 arch/arm64/kvm/Kconfig       |  6 +++++
 arch/arm64/kvm/arch_timer.c  |  2 +-
 arch/arm64/kvm/hypercalls.c  | 49 ++++++++++++++++++++++++++++++++++++
 include/kvm/arm_arch_timer.h |  1 +
 include/linux/arm-smccc.h    | 16 ++++++++++++
 5 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index 318c8f2df245..bbdfacec4813 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -60,6 +60,12 @@ config KVM_ARM_PMU
 config KVM_INDIRECT_VECTORS
 	def_bool HARDEN_BRANCH_PREDICTOR || RANDOMIZE_BASE
 
+config ARM64_KVM_PTP_HOST
+	bool "KVM PTP clock host service for arm64"
+	default y
+	help
+	  virtual kvm ptp clock hypercall service for arm64
+
 endif # KVM
 
 endif # VIRTUALIZATION
diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 32ba6fbc3814..eb85f6701845 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -81,7 +81,7 @@ u64 timer_get_cval(struct arch_timer_context *ctxt)
 	}
 }
 
-static u64 timer_get_offset(struct arch_timer_context *ctxt)
+u64 timer_get_offset(struct arch_timer_context *ctxt)
 {
 	struct kvm_vcpu *vcpu = ctxt->vcpu;
 
diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 901c60f119c2..2628ddc13abd 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -3,6 +3,7 @@
 
 #include <linux/arm-smccc.h>
 #include <linux/kvm_host.h>
+#include <linux/clocksource_ids.h>
 
 #include <asm/kvm_emulate.h>
 
@@ -11,6 +12,10 @@
 
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
+#ifdef CONFIG_ARM64_KVM_PTP_HOST
+	struct system_time_snapshot systime_snapshot;
+	u64 cycles = -1;
+#endif
 	u32 func_id = smccc_get_function(vcpu);
 	u64 val[4] = {SMCCC_RET_NOT_SUPPORTED};
 	u32 feature;
@@ -21,6 +26,10 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		val[0] = ARM_SMCCC_VERSION_1_1;
 		break;
 	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
+		/*
+		 * Note: keep in mind that feature is u32 and smccc_get_arg1
+		 * will return u64, so need auto cast here.
+		 */
 		feature = smccc_get_arg1(vcpu);
 		switch (feature) {
 		case ARM_SMCCC_ARCH_WORKAROUND_1:
@@ -70,7 +79,47 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
 		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
+#ifdef CONFIG_ARM64_KVM_PTP_HOST
+		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_KVM_PTP);
+#endif
 		break;
+#ifdef CONFIG_ARM64_KVM_PTP_HOST
+	/*
+	 * This serves virtual kvm_ptp.
+	 * Four values will be passed back.
+	 * reg0 stores high 32-bit host ktime;
+	 * reg1 stores low 32-bit host ktime;
+	 * reg2 stores high 32-bit difference of host cycles and cntvoff;
+	 * reg3 stores low 32-bit difference of host cycles and cntvoff.
+	 */
+	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
+		/*
+		 * system time and counter value must captured in the same
+		 * time to keep consistency and precision.
+		 */
+		ktime_get_snapshot(&systime_snapshot);
+		if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
+			break;
+		val[0] = systime_snapshot.real;
+		/*
+		 * which of virtual counter or physical counter being
+		 * asked for is decided by the r1 value of smccc
+		 * call. If no invalid r1 value offered, default cycle
+		 * value(-1) will return.
+		 */
+		feature = smccc_get_arg1(vcpu);
+		switch (feature) {
+		case ARM_PTP_VIRT_COUNTER:
+			cycles = systime_snapshot.cycles -
+				 vcpu_read_sys_reg(vcpu, CNTVOFF_EL2);
+			break;
+		case ARM_PTP_PHY_COUNTER:
+			cycles = systime_snapshot.cycles;
+			break;
+		}
+		val[1] = cycles;
+		break;
+#endif
 	default:
 		return kvm_psci_call(vcpu);
 	}
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 51c19381108c..5a2b6da9be7a 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -105,5 +105,6 @@ void kvm_arm_timer_write_sysreg(struct kvm_vcpu *vcpu,
 /* Needed for tracing */
 u32 timer_get_ctl(struct arch_timer_context *ctxt);
 u64 timer_get_cval(struct arch_timer_context *ctxt);
+u64 timer_get_offset(struct arch_timer_context *ctxt);
 
 #endif
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index f7b5dd7dbf9f..0724840eb5f7 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -103,6 +103,7 @@
 
 /* KVM "vendor specific" services */
 #define ARM_SMCCC_KVM_FUNC_FEATURES		0
+#define ARM_SMCCC_KVM_FUNC_KVM_PTP		1
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -112,6 +113,21 @@
 			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
 			   ARM_SMCCC_KVM_FUNC_FEATURES)
 
+/*
+ * ptp_kvm is a feature used for time sync between vm and host.
+ * ptp_kvm module in guest kernel will get service from host using
+ * this hypercall ID.
+ */
+#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID                           \
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,                         \
+			   ARM_SMCCC_SMC_32,                            \
+			   ARM_SMCCC_OWNER_VENDOR_HYP,                  \
+			   ARM_SMCCC_KVM_FUNC_KVM_PTP)
+
+/* ptp_kvm counter type ID */
+#define ARM_PTP_VIRT_COUNTER			0
+#define ARM_PTP_PHY_COUNTER			1
+
 /* Paravirtualised time calls (defined by ARM DEN0057A) */
 #define ARM_SMCCC_HV_PV_TIME_FEATURES				\
 	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,			\
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
