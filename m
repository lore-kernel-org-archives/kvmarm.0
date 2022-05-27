Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F0F8C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 27 May 2022 08:04:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2EDC44B2A7;
	Fri, 27 May 2022 04:04:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bjtmyuf-s+7U; Fri, 27 May 2022 04:04:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BD894B358;
	Fri, 27 May 2022 04:04:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCD1D4B272
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:04:08 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dbhVaORmkzM3 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 May 2022 04:04:04 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.133.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 155BA4B26D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:04:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1653638643;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=X2EjlOHg/Gg2exhClHLrFxLFWlJoGviO0As2qeORgCM=;
 b=WG+XXE/b6twM+6i1mq3OvgUni5vzr4Vr02Thes9TdyvfuT+ViJPsu/LbtxGHh7TPGT6J2L
 htEGV3pro58iPNomlozSApY+ZYKJ3WNHRyD8Q+6N98sJEmSUkIt1TaFuS4tnuigpya5xtH
 M0GK/cwJ+5tu2Iq4koShSwPsXxyGZ8Y=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-106-Sp3k1RAaOLm6GTK6n8vYIQ-1; Fri, 27 May 2022 04:04:00 -0400
X-MC-Unique: Sp3k1RAaOLm6GTK6n8vYIQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C43D8858EFE;
 Fri, 27 May 2022 08:03:59 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-91.pek2.redhat.com [10.72.12.91])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9A6B72026D64;
 Fri, 27 May 2022 08:03:52 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v7 02/22] KVM: arm64: Route hypercalls based on their owner
Date: Fri, 27 May 2022 16:02:33 +0800
Message-Id: <20220527080253.1562538-3-gshan@redhat.com>
In-Reply-To: <20220527080253.1562538-1-gshan@redhat.com>
References: <20220527080253.1562538-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Cc: maz@kernel.org, shijie@amperemail.onmicrosoft.com,
 linux-kernel@vger.kernel.org, eauger@redhat.com, shan.gavin@gmail.com,
 Jonathan.Cameron@huawei.com, pbonzini@redhat.com, vkuznets@redhat.com,
 will@kernel.org
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

kvm_hvc_call_handler() directly handles the incoming hypercall,
or routes it based on its (function) ID. kvm_psci_call() becomes
the gate keeper to handle the hypercall that can't be handled by
any one else. It makes kvm_hvc_call_handler() a bit messy.

This reorgnizes the code to route hypercalls to the corresponding
handler based on their owners. A hypercall may be handled directly
inside the owner's handler or routed to the associated functionality
for further handling. By the way, @func_id is renamed to @func,
consistent with smccc_get_function().

The only exception is 0.1 PSCI hypercalls. Their owners aren't
Standard Secure Service and can't be routed by their owners. So
those 0.1 PSCI hypercalls are filtered and routed to kvm_psci_call()
in kvm_hvc_call_handler().

Suggested-by: Oliver Upton <oupton@google.com>
Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 arch/arm64/kvm/hypercalls.c | 116 ++++++++++++++++++++++++++----------
 include/linux/arm-smccc.h   |   5 ++
 2 files changed, 88 insertions(+), 33 deletions(-)

diff --git a/arch/arm64/kvm/hypercalls.c b/arch/arm64/kvm/hypercalls.c
index 69f437f0d7c7..d66f464e0eb5 100644
--- a/arch/arm64/kvm/hypercalls.c
+++ b/arch/arm64/kvm/hypercalls.c
@@ -65,9 +65,9 @@ static void kvm_ptp_get_time(struct kvm_vcpu *vcpu, u64 *val)
 	val[3] = lower_32_bits(cycles);
 }
 
-static bool kvm_hvc_call_default_allowed(u32 func_id)
+static bool kvm_hvc_call_default_allowed(u32 func)
 {
-	switch (func_id) {
+	switch (func) {
 	/*
 	 * List of function-ids that are not gated with the bitmapped
 	 * feature firmware registers, and are to be allowed for
@@ -78,26 +78,26 @@ static bool kvm_hvc_call_default_allowed(u32 func_id)
 		return true;
 	default:
 		/* PSCI 0.2 and up is in the 0:0x1f range */
-		if (ARM_SMCCC_OWNER_NUM(func_id) == ARM_SMCCC_OWNER_STANDARD &&
-		    ARM_SMCCC_FUNC_NUM(func_id) <= 0x1f)
+		if (ARM_SMCCC_OWNER_NUM(func) == ARM_SMCCC_OWNER_STANDARD &&
+		    ARM_SMCCC_FUNC_NUM(func) <= 0x1f)
 			return true;
 
 		/*
 		 * KVM's PSCI 0.1 doesn't comply with SMCCC, and has
 		 * its own function-id base and range
 		 */
-		if (func_id >= KVM_PSCI_FN(0) && func_id <= KVM_PSCI_FN(3))
+		if (func >= KVM_PSCI_FN(0) && func <= KVM_PSCI_FN(3))
 			return true;
 
 		return false;
 	}
 }
 
-static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
+static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func)
 {
 	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
 
-	switch (func_id) {
+	switch (func) {
 	case ARM_SMCCC_TRNG_VERSION:
 	case ARM_SMCCC_TRNG_FEATURES:
 	case ARM_SMCCC_TRNG_GET_UUID:
@@ -117,24 +117,19 @@ static bool kvm_hvc_call_allowed(struct kvm_vcpu *vcpu, u32 func_id)
 		return test_bit(KVM_REG_ARM_VENDOR_HYP_BIT_PTP,
 				&smccc_feat->vendor_hyp_bmap);
 	default:
-		return kvm_hvc_call_default_allowed(func_id);
+		return kvm_hvc_call_default_allowed(func);
 	}
 }
 
-int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
+static int kvm_hvc_arch(struct kvm_vcpu *vcpu, u32 func)
 {
 	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
-	u32 func_id = smccc_get_function(vcpu);
-	u64 val[4] = {SMCCC_RET_NOT_SUPPORTED};
+	u64 val = SMCCC_RET_NOT_SUPPORTED;
 	u32 feature;
-	gpa_t gpa;
-
-	if (!kvm_hvc_call_allowed(vcpu, func_id))
-		goto out;
 
-	switch (func_id) {
+	switch (func) {
 	case ARM_SMCCC_VERSION_FUNC_ID:
-		val[0] = ARM_SMCCC_VERSION_1_1;
+		val = ARM_SMCCC_VERSION_1_1;
 		break;
 	case ARM_SMCCC_ARCH_FEATURES_FUNC_ID:
 		feature = smccc_get_arg(vcpu, 1);
@@ -144,10 +139,10 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
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
@@ -170,7 +165,7 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
 					break;
 				fallthrough;
 			case SPECTRE_UNAFFECTED:
-				val[0] = SMCCC_RET_NOT_REQUIRED;
+				val = SMCCC_RET_NOT_REQUIRED;
 				break;
 			}
 			break;
@@ -179,28 +174,65 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
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
 			if (test_bit(KVM_REG_ARM_STD_HYP_BIT_PV_TIME,
 				     &smccc_feat->std_hyp_bmap))
-				val[0] = SMCCC_RET_SUCCESS;
+				val = SMCCC_RET_SUCCESS;
 			break;
 		}
 		break;
+	}
+
+	smccc_set_retval(vcpu, val, 0, 0, 0);
+	return 1;
+}
+
+static int kvm_hvc_standard(struct kvm_vcpu *vcpu, u32 func)
+{
+	switch (ARM_SMCCC_FUNC_NUM(func)) {
+	case ARM_SMCCC_STANDARD_PSCI_START ... ARM_SMCCC_STANDARD_PSCI_END:
+		return kvm_psci_call(vcpu);
+	case ARM_SMCCC_STANDARD_TRNG_START ... ARM_SMCCC_STANDARD_TRNG_END:
+		return kvm_trng_call(vcpu);
+	}
+
+	smccc_set_retval(vcpu, SMCCC_RET_NOT_SUPPORTED, 0, 0, 0);
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
+	}
+
+	smccc_set_retval(vcpu, val, 0, 0, 0);
+	return 1;
+}
+
+static int kvm_hvc_vendor_hyp(struct kvm_vcpu *vcpu, u32 func)
+{
+	struct kvm_smccc_features *smccc_feat = &vcpu->kvm->arch.smccc_feat;
+	u64 val[4] = { SMCCC_RET_NOT_SUPPORTED };
+
+	switch (func) {
 	case ARM_SMCCC_VENDOR_HYP_CALL_UID_FUNC_ID:
 		val[0] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_0;
 		val[1] = ARM_SMCCC_VENDOR_HYP_UID_KVM_REG_1;
@@ -213,18 +245,36 @@ int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
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
+	}
+
+	smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
+	return 1;
+}
+
+int kvm_hvc_call_handler(struct kvm_vcpu *vcpu)
+{
+	u32 func = smccc_get_function(vcpu);
+
+	if (!kvm_hvc_call_allowed(vcpu, func))
+		goto out;
+
+	/* Filter these calls that aren't documented in the specification */
+	if (func >= KVM_PSCI_FN_CPU_SUSPEND && func <= KVM_PSCI_FN_MIGRATE)
 		return kvm_psci_call(vcpu);
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
 	}
 
 out:
-	smccc_set_retval(vcpu, val[0], val[1], val[2], val[3]);
+	smccc_set_retval(vcpu, SMCCC_RET_NOT_SUPPORTED, 0, 0, 0);
 	return 1;
 }
 
diff --git a/include/linux/arm-smccc.h b/include/linux/arm-smccc.h
index 220c8c60e021..834fb963a689 100644
--- a/include/linux/arm-smccc.h
+++ b/include/linux/arm-smccc.h
@@ -55,6 +55,11 @@
 #define ARM_SMCCC_OWNER_TRUSTED_OS	50
 #define ARM_SMCCC_OWNER_TRUSTED_OS_END	63
 
+#define ARM_SMCCC_STANDARD_PSCI_START	0x0000
+#define ARM_SMCCC_STANDARD_PSCI_END	0x001f
+#define ARM_SMCCC_STANDARD_TRNG_START	0x0050
+#define ARM_SMCCC_STANDARD_TRNG_END	0x005f
+
 #define ARM_SMCCC_FUNC_QUERY_CALL_UID  0xff01
 
 #define ARM_SMCCC_QUIRK_NONE		0
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
