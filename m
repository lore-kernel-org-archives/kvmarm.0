Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F5B8C433F5
	for <kvmarm@archiver.kernel.org>; Sun,  3 Apr 2022 15:39:53 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B9B564B172;
	Sun,  3 Apr 2022 11:39:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mV7YVLIqz9su; Sun,  3 Apr 2022 11:39:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B0ED4B187;
	Sun,  3 Apr 2022 11:39:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EDB2E4B120
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 11:39:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1u1LDt6-kwwL for <kvmarm@lists.cs.columbia.edu>;
 Sun,  3 Apr 2022 11:39:48 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 20E724B1AB
 for <kvmarm@lists.cs.columbia.edu>; Sun,  3 Apr 2022 11:39:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1649000387;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=cWJkoe1+u98Pk+LiA9di3eKUADBQWAkzqmXjJpmymwk=;
 b=Mt4XOqeKSJPXOhArQgcFUI2BidIB/cvIkdaOmiPxkmY03bLnGCA7qrd1ciMYl8wtK4KNvW
 SO4rMvvRJbfSXYYj/mVuJ1MRNkK6tWcs3CKjyzuWuvUQTW4kzeG9fR9/uJ9rkS9aHvUbnG
 GcLVHbXMiZ2oRoYWhDTffQU2pQVZCkI=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-342-OKwWB7BEOnaoI-Ec3NL1xQ-1; Sun, 03 Apr 2022 11:39:46 -0400
X-MC-Unique: OKwWB7BEOnaoI-Ec3NL1xQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DC7B1C04B54;
 Sun,  3 Apr 2022 15:39:46 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-82.pek2.redhat.com [10.72.12.82])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AF745463DF4;
 Sun,  3 Apr 2022 15:39:39 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v6 02/18] KVM: arm64: Route hypercalls based on their owner
Date: Sun,  3 Apr 2022 23:38:55 +0800
Message-Id: <20220403153911.12332-3-gshan@redhat.com>
In-Reply-To: <20220403153911.12332-1-gshan@redhat.com>
References: <20220403153911.12332-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.10
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, eauger@redhat.com,
 shan.gavin@gmail.com, Jonathan.Cameron@huawei.com, pbonzini@redhat.com,
 vkuznets@redhat.com, will@kernel.org
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

kvm_hvc_call_handler() directly handles the incoming hypercall, or
and routes it based on its (function) ID. kvm_psci_call() becomes
the gate keeper to handle the hypercall that can't be handled by
any one else. It makes kvm_hvc_call_handler() a bit messy.

This reorgnizes the code to route the hypercall to the corresponding
handler based on its owner. The hypercall may be handled directly
in the handler or routed further to the corresponding functionality.
The (function) ID is always verified before it's routed to the
corresponding functionality. By the way, @func_id is repalced by
@func, to be consistent with by smccc_get_function().

PSCI is the only exception, those hypercalls defined by 0.2 or
beyond are routed to the handler for Standard Secure Service, but
those defined in 0.1 are routed to the handler for Standard
Hypervisor Service.

Suggested-by: Oliver Upton <oupton@google.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/hypercalls.c | 199 +++++++++++++++++++++++-------------
 1 file changed, 127 insertions(+), 72 deletions(-)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 8438fd79e3f0..b659387d8919 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -9,65 +9,14 @@
 #include <kvm/arm_hypercalls.h>
 #include <kvm/arm_psci.h>
 
-static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
-{
-	struct system_time_snapshot systime_snapshot;
-	u64 cycles = ~0UL;
-	u32 feature;
-
-	/*
-	 * system time and counter value must captured at the same
-	 * time to keep consistency and precision.
-	 */
-	ktime_get_snapshot(&systime_snapshot);
-
-	/*
-	 * This is only valid if the current clocksource is the
-	 * architected counter, as this is the only one the guest
-	 * can see.
-	 */
-	if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
-		return;
-
-	/*
-	 * The guest selects one of the two reference counters
-	 * (virtual or physical) with the first argument of the SMCCC
-	 * call. In case the identifier is not supported, error out.
-	 */
-	feature = smccc_get_arg(vcpu, 1);
-	switch (feature) {
-	case KVM_PTP_VIRT_COUNTER:
-		cycles = systime_snapshot.cycles - vcpu_read_sys_reg(vcpu, CNTVOFF_EL2);
-		break;
-	case KVM_PTP_PHYS_COUNTER:
-		cycles = systime_snapshot.cycles;
-		break;
-	default:
-		return;
-	}
-
-	/*
-	 * This relies on the top bit of val[0] never being set for
-	 * valid values of system time, because that is *really* far
-	 * in the future (about 292 years from 1970, and at that stage
-	 * nobody will give a damn about it).
-	 */
-	val[0] = upper_32_bits(systime_snapshot.real);
-	val[1] = lower_32_bits(systime_snapshot.real);
-	val[2] = upper_32_bits(cycles);
-	val[3] = lower_32_bits(cycles);
-}
-
-int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
+static int kvm_hvc_arch(struct kvm_vcpu *vcpu, u32 func)
 {
-	u32 func_id = smccc_get_function(vcpu);
-	u64 val[4] = {SMCCC_RET_NOT_SUPPORTED};
+	u64 val = SMCCC_RET_NOT_SUPPORTED;
 	u32 feature;
-	gpa_t gpa;
 
-	switch (func_id) {
+	switch (func) {
 	case ARM_SMCCC_VERSION_FUNC_ID:
-		val[0] = ARM_SMCCC_VERSION_1_1;
+		val = ARM_SMCCC_VERSION_1_1;
 		break;
 	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
 		feature = smccc_get_arg(vcpu, 1);
@@ -77,10 +26,10 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 			case SPECTRE_VULNERABLE:
 				break;
 			case SPECTRE_MITIGATED:
-				val[0] = SMCCC_RET_SUCCESS;
+				val = SMCCC_RET_SUCCESS;
 				break;
 			case SPECTRE_UNAFFECTED:
-				val[0] = SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED;
+				val = SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED;
 				break;
 			}
 			break;
@@ -103,7 +52,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 					break;
 				fallthrough;
 			case SPECTRE_UNAFFECTED:
-				val[0] = SMCCC_RET_NOT_REQUIRED;
+				val = SMCCC_RET_NOT_REQUIRED;
 				break;
 			}
 			break;
@@ -112,26 +61,120 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 			case SPECTRE_VULNERABLE:
 				break;
 			case SPECTRE_MITIGATED:
-				val[0] = SMCCC_RET_SUCCESS;
+				val = SMCCC_RET_SUCCESS;
 				break;
 			case SPECTRE_UNAFFECTED:
-				val[0] = SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED;
+				val = SMCCC_ARCH_WORKAROUND_RET_UNAFFECTED;
 				break;
 			}
 			break;
 		case ARM_SMCCC_HV_PV_TIME_FEATURES:
-			val[0] = SMCCC_RET_SUCCESS;
+			val = SMCCC_RET_SUCCESS;
 			break;
 		}
-		break;
+	}
+
+	smccc_set_retval(vcpu, val, 0, 0, 0);
+	return 1;
+}
+
+static int kvm_hvc_standard(struct kvm_vcpu *vcpu, u32 func)
+{
+	u64 val = SMCCC_RET_NOT_SUPPORTED;
+
+	switch (func) {
+	case ARM_SMCCC_TRNG_VERSION ... ARM_SMCCC_TRNG_RND32:
+	case ARM_SMCCC_TRNG_RND64:
+		return kvm_trng_call(vcpu);
+	case PSCI_0_2_FN_PSCI_VERSION ... PSCI_0_2_FN_SYSTEM_RESET:
+	case PSCI_0_2_FN64_CPU_SUSPEND ... PSCI_0_2_FN64_MIGRATE_INFO_UP_CPU:
+	case PSCI_1_0_FN_PSCI_FEATURES ... PSCI_1_0_FN_SET_SUSPEND_MODE:
+	case PSCI_1_0_FN64_SYSTEM_SUSPEND:
+	case PSCI_1_1_FN_SYSTEM_RESET2:
+	case PSCI_1_1_FN64_SYSTEM_RESET2:
+		return kvm_psci_call(vcpu);
+	}
+
+	smccc_set_retval(vcpu, val, 0, 0, 0);
+	return 1;
+}
+
+static int kvm_hvc_standard_hyp(struct kvm_vcpu *vcpu, u32 func)
+{
+	u64 val = SMCCC_RET_NOT_SUPPORTED;
+	gpa_t gpa;
+
+	switch (func) {
 	case ARM_SMCCC_HV_PV_TIME_FEATURES:
-		val[0] = kvm_hypercall_pv_features(vcpu);
+		val = kvm_hypercall_pv_features(vcpu);
 		break;
 	case ARM_SMCCC_HV_PV_TIME_ST:
 		gpa = kvm_init_stolen_time(vcpu);
 		if (gpa != GPA_INVALID)
-			val[0] = gpa;
+			val = gpa;
 		break;
+	case KVM_PSCI_FN_CPU_SUSPEND ... KVM_PSCI_FN_MIGRATE:
+		return kvm_psci_call(vcpu);
+	}
+
+	smccc_set_retval(vcpu, val, 0, 0, 0);
+	return 1;
+}
+
+static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
+{
+	struct system_time_snapshot systime_snapshot;
+	u64 cycles = ~0UL;
+	u32 feature;
+
+	/*
+	 * system time and counter value must captured at the same
+	 * time to keep consistency and precision.
+	 */
+	ktime_get_snapshot(&systime_snapshot);
+
+	/*
+	 * This is only valid if the current clocksource is the
+	 * architected counter, as this is the only one the guest
+	 * can see.
+	 */
+	if (systime_snapshot.cs_id != CSID_ARM_ARCH_COUNTER)
+		return;
+
+	/*
+	 * The guest selects one of the two reference counters
+	 * (virtual or physical) with the first argument of the SMCCC
+	 * call. In case the identifier is not supported, error out.
+	 */
+	feature = smccc_get_arg(vcpu, 1);
+	switch (feature) {
+	case KVM_PTP_VIRT_COUNTER:
+		cycles = systime_snapshot.cycles - vcpu_read_sys_reg(vcpu, CNTVOFF_EL2);
+		break;
+	case KVM_PTP_PHYS_COUNTER:
+		cycles = systime_snapshot.cycles;
+		break;
+	default:
+		return;
+	}
+
+	/*
+	 * This relies on the top bit of val[0] never being set for
+	 * valid values of system time, because that is *really* far
+	 * in the future (about 292 years from 1970, and at that stage
+	 * nobody will give a damn about it).
+	 */
+	val[0] = upper_32_bits(systime_snapshot.real);
+	val[1] = lower_32_bits(systime_snapshot.real);
+	val[2] = upper_32_bits(cycles);
+	val[3] = lower_32_bits(cycles);
+}
+
+static int kvm_hvc_vendor_hyp(struct kvm_vcpu *vcpu, u32 func)
+{
+	u64 val[4] = { SMCCC_RET_NOT_SUPPORTED };
+
+	switch (func) {
 	case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
 		val[0] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0;
 		val[1] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1;
@@ -145,16 +188,28 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 	case ARM_SMCCC_VENDOR_HYP_KVM_PTP_FUNC_ID:
 		kvm_ptp_get_time(vcpu, val);
 		break;
-	case ARM_SMCCC_TRNG_VERSION:
-	case ARM_SMCCC_TRNG_FEATURES:
-	case ARM_SMCCC_TRNG_GET_UUID:
-	case ARM_SMCCC_TRNG_RND32:
-	case ARM_SMCCC_TRNG_RND64:
-		return kvm_trng_call(vcpu);
-	default:
-		return kvm_psci_call(vcpu);
 	}
 
 	smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
 	return 1;
 }
+
+int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
+{
+	u32 func = smccc_get_function(vcpu);
+	u64 val = SMCCC_RET_NOT_SUPPORTED;
+
+	switch (ARM_SMCCC_OWNER_NUM(func)) {
+	case ARM_SMCCC_OWNER_ARCH:
+		return kvm_hvc_arch(vcpu, func);
+	case ARM_SMCCC_OWNER_STANDARD:
+		return kvm_hvc_standard(vcpu, func);
+	case ARM_SMCCC_OWNER_STANDARD_HYP:
+		return kvm_hvc_standard_hyp(vcpu, func);
+	case ARM_SMCCC_OWNER_VENDOR_HYP:
+		return kvm_hvc_vendor_hyp(vcpu, func);
+	}
+
+	smccc_set_retval(vcpu, val, 0, 0, 0);
+	return 1;
+}
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
