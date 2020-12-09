Return-Path: <SRS0=3Een=FN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E6CCC433FE
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 06:10:38 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F397E23B7E
	for <kvmarm@archiver.kernel.org>; Wed,  9 Dec 2020 06:10:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F397E23B7E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 99F224B2A8;
	Wed,  9 Dec 2020 01:10:37 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Zey0nmJBE+rY; Wed,  9 Dec 2020 01:10:36 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 749634B29E;
	Wed,  9 Dec 2020 01:10:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA30D4B2A4
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 01:10:35 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x14dwE+oDioV for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Dec 2020 01:10:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 73AC34B29E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Dec 2020 01:10:34 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2D1D9152B;
 Tue,  8 Dec 2020 22:10:34 -0800 (PST)
Received: from entos-thunderx2-desktop.shanghai.arm.com
 (entos-thunderx2-desktop.shanghai.arm.com [10.169.212.215])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 044D53F66B;
 Tue,  8 Dec 2020 22:10:27 -0800 (PST)
From: Jianyong Wu <jianyong.wu@arm.com>
To: netdev@vger.kernel.org, yangbo.lu@nxp.com, john.stultz@linaro.org,
 tglx@linutronix.de, pbonzini@redhat.com, sean.j.christopherson@intel.com,
 maz@kernel.org, richardcochran@gmail.com, Mark.Rutland@arm.com,
 will@kernel.org, suzuki.poulose@arm.com, Andre.Przywara@arm.com,
 steven.price@arm.com
Subject: [PATCH v16 6/9] arm64/kvm: Add hypercall service for kvm ptp.
Date: Wed,  9 Dec 2020 14:09:29 +0800
Message-Id: <20201209060932.212364-7-jianyong.wu@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201209060932.212364-1-jianyong.wu@arm.com>
References: <20201209060932.212364-1-jianyong.wu@arm.com>
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

ptp_kvm will get this service through SMCC call.
The service offers wall time and cycle count of host to guest.
The caller must specify whether they want the host cycle count
or the difference between host cycle count and cntvoff.

Signed-off-by: Jianyong Wu <jianyong.wu@arm.com>
---
 arch/arm64/kvm/hypercalls.c | 59 +++++++++++++++++++++++++++++++++++++
 include/linux/arm-smccc.h   | 16 ++++++++++
 2 files changed, 75 insertions(+)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index b9d8607083eb..9a4834502388 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -9,6 +9,49 @@
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_psci.h>
 
+static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
+{
+	struct system_time_snapshot systime_snapshot;
+	u64 cycles = ~0UL;
+	u32 feature;
+
+	/*
+	 * system time and counter value must captured in the same
+	 * time to keep consistency and precision.
+	 */
+	ktime_get_snapshot(&systime_snapshot);
+
+	// binding ptp_kvm clocksource to arm_arch_counter
+	if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
+		return;
+
+	val[0] = upper_32_bits(systime_snapshot.real);
+	val[1] = lower_32_bits(systime_snapshot.real);
+
+	/*
+	 * which of virtual counter or physical counter being
+	 * asked for is decided by the r1 value of SMCCC
+	 * call. If no invalid r1 value offered, default cycle
+	 * value(-1) will be returned.
+	 * Note: keep in mind that feature is u32 and smccc_get_arg1
+	 * will return u64, so need auto cast here.
+	 */
+	feature = smccc_get_arg1(vcpu);
+	switch (feature) {
+	case ARM_PTP_VIRT_COUNTER:
+		cycles = systime_snapshot.cycles - vcpu_read_sys_reg(vcpu, CNTVOFF_EL2);
+		break;
+	case ARM_PTP_PHY_COUNTER:
+		cycles = systime_snapshot.cycles;
+		break;
+	default:
+		val[0] = SMCCC_RET_NOT_SUPPORTED;
+		break;
+	}
+	val[2] = upper_32_bits(cycles);
+	val[3] = lower_32_bits(cycles);
+}
+
 int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 {
 	u32 func_id = smccc_get_function(vcpu);
@@ -79,6 +122,22 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 		break;
 	case ARM_SMCCC_VENDOR_HYP_KVM_FEATURES_FUNC_ID:
 		val[0] = BIT(ARM_SMCCC_KVM_FUNC_FEATURES);
+		val[0] |= BIT(ARM_SMCCC_KVM_FUNC_PTP);
+		break;
+	/*
+	 * This serves virtual kvm_ptp.
+	 * Four values will be passed back.
+	 * reg0 stores high 32-bits of host ktime;
+	 * reg1 stores low 32-bits of host ktime;
+	 * For ARM_PTP_VIRT_COUNTER:
+	 * reg2 stores high 32-bits of difference of host cycles and cntvoff;
+	 * reg3 stores low 32-bits of difference of host cycles and cntvoff.
+	 * For ARM_PTP_PHY_COUNTER:
+	 * reg2 stores the high 32-bits of host cycles;
+	 * reg3 stores the low 32-bits of host cycles.
+	 */
+	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
+		kvm_ptp_get_time(vcpu, val);
 		break;
 	default:
 		return kvm_psci_call(vcpu);
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index d75408141137..7924069f8f0a 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -103,6 +103,7 @@
 
 /* KVM "vendor specific" services */
 #define ARM_SMCCC_KVM_FUNC_FEATURES		0
+#define ARM_SMCCC_KVM_FUNC_PTP			1
 #define ARM_SMCCC_KVM_FUNC_FEATURES_2		127
 #define ARM_SMCCC_KVM_NUM_FUNCS			128
 
@@ -114,6 +115,21 @@
 
 #define SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED	1
 
+/*
+ * ptp_kvm is a feature used for time sync between vm and host.
+ * ptp_kvm module in guest kernel will get service from host using
+ * this hypercall ID.
+ */
+#define ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID				\
+	ARM_SMCCC_CALL_VAL(ARM_SMCCC_FAST_CALL,				\
+			   ARM_SMCCC_SMC_32,				\
+			   ARM_SMCCC_OWNER_VENDOR_HYP,			\
+			   ARM_SMCCC_KVM_FUNC_PTP)
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
