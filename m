Return-Path: <SRS0=/4wP=NK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 012E6C4338F
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 22:37:06 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 99F99610A5
	for <kvmarm@archiver.kernel.org>; Thu, 19 Aug 2021 22:37:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 99F99610A5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C2E44B0D7;
	Thu, 19 Aug 2021 18:37:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o6Bb-dK+gDHL; Thu, 19 Aug 2021 18:37:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 326354B120;
	Thu, 19 Aug 2021 18:36:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 59DEA4B0EA
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 18:36:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1tlLgSL1a56o for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 Aug 2021 18:36:51 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 323114B0E7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 18:36:48 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 e17-20020a0562141511b029034f8146604fso5572561qvy.12
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 Aug 2021 15:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=rzg4aWaMxCZtAeRElslHw81uG1luZUIir4vgArIv1Rk=;
 b=X5V0Q/frltVwjxnhUAYSu7ef0WmyYQx3FBZqJQN+heXrjovHTCUfw9lYl/6KRrId4A
 Ps+lsSQQTppfCOg6iJyQUt28x/eNrLNqAIxU1Eez2KQgUZYbH6psr5pfX2PvKyWC1g+f
 OxYI22/e6AibjghLO0VvZsnm75v80LS/TwKAldxt995vEcqo4h096ITlxehoPPkr5tWT
 UXH7HTu4LWpM3NUK1toxzAQH1MLQYsVQEu5sGHC+ePZ6aJnzoCoEhTx9O1xZ9xLiE+TG
 iWRSka7qjHSo1d24kHi6TDvU5Pxn5sNKtlDpqjjTiVxG88Qv35Aa8TnJdtl4hirQEaLe
 a+Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=rzg4aWaMxCZtAeRElslHw81uG1luZUIir4vgArIv1Rk=;
 b=A3otkbYQs/p+b+bmCKBnMvHiqA8w+osCD9Sp9p2oSQ0r+cUOSq549Nksn/QCIEkvsC
 7V1EfHI/ni+KDnNBmTuK/DuucskY7eCgbU1gPOSfPHHsGj7gaQvs8a6+gxHs2w/9LGaP
 hCX6uCE9gXsIwleG/9oG2ae1KcS3uB3MGeefhAM0wKgvRy/IruOOk6IM6qYnFaDM2rb4
 TwvxrtfPK19z0rlKfre7pjWPzdCcs0DCqAh93CeaGj7ktt8ftPbJ00tGDjotGeGTmn5s
 fqH2hRt9XMotOyo1UbvNKnwf5MPDa84DFVWBZgyHr8OpV35dyuGix1z/wj3Qp1f7R4GJ
 t4oA==
X-Gm-Message-State: AOAM533FXXv5Bar7pxPyB3fkYpTZbUqwJdqU6//PXgsVp0wGPR0GxV9/
 DhaFQOKlZnNRpbvGWNTei+yfeIcFNT0=
X-Google-Smtp-Source: ABdhPJyLKotdPFAI3HZVhOejdbxxgjxtv6obcHVflNcA0vdE775X6LSp9WJU4w8/d1bEHEvwwlVWh9984JY=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:a02:: with SMTP id
 dw2mr16898960qvb.61.1629412607827; Thu, 19 Aug 2021 15:36:47 -0700 (PDT)
Date: Thu, 19 Aug 2021 22:36:38 +0000
In-Reply-To: <20210819223640.3564975-1-oupton@google.com>
Message-Id: <20210819223640.3564975-5-oupton@google.com>
Mime-Version: 1.0
References: <20210819223640.3564975-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc2.250.ged5fa647cd-goog
Subject: [PATCH 4/6] KVM: arm64: Add support for SYSTEM_SUSPEND PSCI call
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Raghavendra Rao Anata <rananta@google.com>
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

ARM DEN0022D 5.19 "SYSTEM_SUSPEND" describes a PSCI call that may be
used to request a system be suspended. This is optional for PSCI v1.0
and to date KVM has elected to not implement the call. However, a
VMM/operator may wish to provide their guests with the ability to
suspend/resume, necessitating this PSCI call.

Implement support for SYSTEM_SUSPEND according to the prescribed
behavior in the specification. Add a new system event exit type,
KVM_SYSTEM_EVENT_SUSPEND, to notify userspace when a VM has requested a
system suspend.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kvm/arm.c              |  5 +++
 arch/arm64/kvm/psci.c             | 60 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  2 ++
 4 files changed, 70 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index bdab1754c71f..b5cc83b938cb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -136,6 +136,9 @@ struct kvm_arch {
 
 	/* Memory Tagging Extension enabled for the guest */
 	bool mte_enabled;
+
+	/* PSCI SYSTEM_SUSPEND call enabled for the guest */
+	bool suspend_enabled;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3496cb0d014e..45890ba897ee 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -97,6 +97,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		r = 0;
 		kvm->arch.mte_enabled = true;
 		break;
+	case KVM_CAP_ARM_SYSTEM_SUSPEND:
+		r = 0;
+		kvm->arch.suspend_enabled = true;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -211,6 +215,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index bb59b692998b..8e30a0fb1c60 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -205,6 +205,46 @@ static void kvm_psci_system_reset(struct kvm_vcpu *vcpu)
 	kvm_prepare_system_event(vcpu, KVM_SYSTEM_EVENT_RESET);
 }
 
+static int kvm_psci_system_suspend(struct kvm_vcpu *vcpu)
+{
+	unsigned long entry_addr, context_id;
+	struct kvm *kvm = vcpu->kvm;
+	unsigned long psci_ret = 0;
+	struct kvm_vcpu *tmp;
+	int ret = 0;
+	int i;
+
+	/*
+	 * The SYSTEM_SUSPEND PSCI call requires that all vCPUs (except the
+	 * calling vCPU) be in an OFF state, as determined by the
+	 * implementation.
+	 *
+	 * See ARM DEN0022D, 5.19 "SYSTEM_SUSPEND" for more details.
+	 */
+	mutex_lock(&kvm->lock);
+	kvm_for_each_vcpu(i, tmp, kvm) {
+		if (tmp != vcpu && !tmp->arch.power_off) {
+			psci_ret = PSCI_RET_DENIED;
+			ret = 1;
+			goto out;
+		}
+	}
+
+	entry_addr = smccc_get_arg1(vcpu);
+	context_id = smccc_get_arg2(vcpu);
+
+	kvm_psci_vcpu_request_reset(vcpu, entry_addr, context_id,
+				    kvm_vcpu_is_be(vcpu));
+
+	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
+	vcpu->run->system_event.type = KVM_SYSTEM_EVENT_SUSPEND;
+	vcpu->run->exit_reason = KVM_EXIT_SYSTEM_EVENT;
+out:
+	mutex_unlock(&kvm->lock);
+	smccc_set_retval(vcpu, psci_ret, 0, 0, 0);
+	return ret;
+}
+
 static void kvm_psci_narrow_to_32bit(struct kvm_vcpu *vcpu)
 {
 	int i;
@@ -225,6 +265,14 @@ static unsigned long kvm_psci_check_allowed_function(struct kvm_vcpu *vcpu, u32
 	if ((fn & PSCI_0_2_64BIT) && vcpu_mode_is_32bit(vcpu))
 		return PSCI_RET_NOT_SUPPORTED;
 
+	switch (fn) {
+	case PSCI_1_0_FN_SYSTEM_SUSPEND:
+	case PSCI_1_0_FN64_SYSTEM_SUSPEND:
+		if (!vcpu->kvm->arch.suspend_enabled)
+			return PSCI_RET_NOT_SUPPORTED;
+		break;
+	}
+
 	return 0;
 }
 
@@ -318,6 +366,10 @@ static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
 	unsigned long val;
 	int ret = 1;
 
+	val = kvm_psci_check_allowed_function(vcpu, psci_fn);
+	if (val)
+		goto out;
+
 	switch(psci_fn) {
 	case PSCI_0_2_FN_PSCI_VERSION:
 		val = KVM_ARM_PSCI_1_0;
@@ -341,6 +393,8 @@ static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
 		case PSCI_0_2_FN_SYSTEM_OFF:
 		case PSCI_0_2_FN_SYSTEM_RESET:
 		case PSCI_1_0_FN_PSCI_FEATURES:
+		case PSCI_1_0_FN_SYSTEM_SUSPEND:
+		case PSCI_1_0_FN64_SYSTEM_SUSPEND:
 		case ARM_SMCCC_VERSION_FUNC_ID:
 			val = 0;
 			break;
@@ -349,10 +403,16 @@ static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
 			break;
 		}
 		break;
+	case PSCI_1_0_FN_SYSTEM_SUSPEND:
+		kvm_psci_narrow_to_32bit(vcpu);
+		fallthrough;
+	case PSCI_1_0_FN64_SYSTEM_SUSPEND:
+		return kvm_psci_system_suspend(vcpu);
 	default:
 		return kvm_psci_0_2_call(vcpu);
 	}
 
+out:
 	smccc_set_retval(vcpu, val, 0, 0, 0);
 	return ret;
 }
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index d9e4aabcb31a..8e97d9c11a1b 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -433,6 +433,7 @@ struct kvm_run {
 #define KVM_SYSTEM_EVENT_SHUTDOWN       1
 #define KVM_SYSTEM_EVENT_RESET          2
 #define KVM_SYSTEM_EVENT_CRASH          3
+#define KVM_SYSTEM_EVENT_SUSPEND        4
 			__u32 type;
 			__u64 flags;
 		} system_event;
@@ -1112,6 +1113,7 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_BINARY_STATS_FD 203
 #define KVM_CAP_EXIT_ON_EMULATION_FAILURE 204
 #define KVM_CAP_ARM_MTE 205
+#define KVM_CAP_ARM_SYSTEM_SUSPEND 206
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
-- 
2.33.0.rc2.250.ged5fa647cd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
