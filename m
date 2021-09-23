Return-Path: <SRS0=m3m7=ON=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EF5DC433EF
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 43ABF61267
	for <kvmarm@archiver.kernel.org>; Thu, 23 Sep 2021 19:16:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 43ABF61267
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EF8204B0E1;
	Thu, 23 Sep 2021 15:16:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7TNILAP9AZ4M; Thu, 23 Sep 2021 15:16:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD9C34B13B;
	Thu, 23 Sep 2021 15:16:25 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4FDE14B110
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jfvEIW+m6t+J for <kvmarm@lists.cs.columbia.edu>;
 Thu, 23 Sep 2021 15:16:23 -0400 (EDT)
Received: from mail-qk1-f201.google.com (mail-qk1-f201.google.com
 [209.85.222.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 26ABF4B119
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 15:16:23 -0400 (EDT)
Received: by mail-qk1-f201.google.com with SMTP id
 bk33-20020a05620a1a2100b00432fff50d40so21536461qkb.22
 for <kvmarm@lists.cs.columbia.edu>; Thu, 23 Sep 2021 12:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=H3vkV6rNI9KUdmftteDleGzJenrkHySSJn/1Y/5guuQ=;
 b=LasEUuDwQp5Zav61DshsF2WqKM9enZgWNq/a3BGwody5/zVv0VJzBCQVeT584d4abS
 P23ZKVqU11j5gQh5rAJzcG5BUueustHitzc4zXp8xcCnCbQGICjDdmE2QB+Y+nTsWjjW
 6pfJbE0FOonXtk5Cxzs0zwy3QWLcSgIO8aV6nxaG9iB5qj15bSsVgXkUfBg7VstRZUlh
 5kNXvs71c2CxAyU/dwGHn9S0DH2/k16jk7a2J+CrvD619D/bkRV6d1CMGzu9ugzbCR4B
 j51hNXAwcMrXhaBtdi8FzL82w6Q2a7P8fgAk5cxM1aEbtZMEHOK4O32iN0avetd+0NJ0
 INwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=H3vkV6rNI9KUdmftteDleGzJenrkHySSJn/1Y/5guuQ=;
 b=sOyUVIOFOG1USRINXZ84fXR5iBvjONxiJZ9Oeud+9QTcBesqwwDGtbqiXON0aw4lwz
 +s+Ew9+wZVqQLycvXkk0V7PqH2QNN4S1aindQ9iGhy3r3mryJQbGJtnqsWFEf4ZbDaM8
 5B+TnUmf+a6Mf7mtQ3aEWkW48xc0yrbTLb6lZYPjv7SdRDo+6b9L7e5itq9VQrHzLT+A
 VaSuF1EeCL1FcbbsQmxE9W8CAxGUw+zSkoW8zukv3P8P7FfLjLOjLKHWhoq6LPcCDSm9
 68Kk3RD1P9gWsBD8eghU78jtkxyoF9dAfioRKCcupE2PSXfGN4MoZMt0nfTkNYXFTWoW
 8oow==
X-Gm-Message-State: AOAM533hn5FDhkqqpng1Kx3WT0JD/RlpnqqpSL83mt3eU2ZwC7davXau
 BvpU7iDjTDR8wzv9BmqXhC3KdOEvNFLju3eWPBMUt7iQXm0tAqibUyo5dWE/1rBJxJl4Fv9sMhi
 iMcJBjVToYFFaft9HEzVRvzvzkdw4T3NyvAhZJ6iaXn5DIEU5FdynxcNi9Kx+NDlc2Ta7Wg==
X-Google-Smtp-Source: ABdhPJwu/QbnVYK8a/ZiJZYOCCOiDf8v/2TBSwHDemfAVDn2FGRxLNaNjB8Ttdmu9oHrHDj4s1NfhAwwAsg=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:ad4:5147:: with SMTP id
 g7mr3186004qvq.29.1632424582642; 
 Thu, 23 Sep 2021 12:16:22 -0700 (PDT)
Date: Thu, 23 Sep 2021 19:16:05 +0000
In-Reply-To: <20210923191610.3814698-1-oupton@google.com>
Message-Id: <20210923191610.3814698-7-oupton@google.com>
Mime-Version: 1.0
References: <20210923191610.3814698-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [PATCH v2 06/11] KVM: arm64: Add support for SYSTEM_SUSPEND PSCI call
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Marc Zyngier <maz@kernel.org>,
 Peter Shier <pshier@google.com>
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
system suspend. Make KVM_MP_STATE_HALTED a valid state on arm64.
Userspace can set this to request an in-kernel emulation of the suspend.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 Documentation/virt/kvm/api.rst    |  6 ++++
 arch/arm64/include/asm/kvm_host.h |  3 ++
 arch/arm64/kvm/arm.c              |  8 +++++
 arch/arm64/kvm/psci.c             | 60 +++++++++++++++++++++++++++++++
 include/uapi/linux/kvm.h          |  2 ++
 5 files changed, 79 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a6729c8cf063..361a57061b8f 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -5656,6 +5656,7 @@ should put the acknowledged interrupt vector into the 'epr' field.
   #define KVM_SYSTEM_EVENT_SHUTDOWN       1
   #define KVM_SYSTEM_EVENT_RESET          2
   #define KVM_SYSTEM_EVENT_CRASH          3
+  #define KVM_SYSTEM_EVENT_SUSPEND        4
 			__u32 type;
 			__u64 flags;
 		} system_event;
@@ -5680,6 +5681,11 @@ Valid values for 'type' are:
    has requested a crash condition maintenance. Userspace can choose
    to ignore the request, or to gather VM memory core dump and/or
    reset/shutdown of the VM.
+ - KVM_SYSTEM_EVENT_SUSPEND -- the guest has requested that the VM
+   suspends. Userspace is not obliged to honor this, and may call KVM_RUN
+   again. Doing so will cause the guest to resume at its requested entry
+   point. For ARM64, userspace can request in-kernel suspend emulation
+   by setting the vCPU's MP state to KVM_MP_STATE_HALTED.
 
 ::
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1beda1189a15..441eb6fa7adc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -137,6 +137,9 @@ struct kvm_arch {
 
 	/* Memory Tagging Extension enabled for the guest */
 	bool mte_enabled;
+
+	/* PSCI SYSTEM_SUSPEND call enabled for the guest */
+	bool suspend_enabled;
 };
 
 struct kvm_vcpu_fault_info {
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index f1a375648e25..d875d3bcf3c5 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -101,6 +101,10 @@ int kvm_vm_ioctl_enable_cap(struct kvm *kvm,
 		}
 		mutex_unlock(&kvm->lock);
 		break;
+	case KVM_CAP_ARM_SYSTEM_SUSPEND:
+		r = 0;
+		kvm->arch.suspend_enabled = true;
+		break;
 	default:
 		r = -EINVAL;
 		break;
@@ -215,6 +219,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_SET_GUEST_DEBUG:
 	case KVM_CAP_VCPU_ATTRIBUTES:
 	case KVM_CAP_PTP_KVM:
+	case KVM_CAP_ARM_SYSTEM_SUSPEND:
 		r = 1;
 		break;
 	case KVM_CAP_SET_GUEST_DEBUG2:
@@ -470,6 +475,9 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 	int ret = 0;
 
 	switch (mp_state->mp_state) {
+	case KVM_MP_STATE_HALTED:
+		kvm_make_request(KVM_REQ_SUSPEND, vcpu);
+		fallthrough;
 	case KVM_MP_STATE_RUNNABLE:
 		vcpu->arch.power_off = false;
 		break;
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index d453666ddb83..cf869f1f8615 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -203,6 +203,46 @@ static void kvm_psci_system_reset(struct kvm_vcpu *vcpu)
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
@@ -223,6 +263,14 @@ static unsigned long kvm_psci_check_allowed_function(struct kvm_vcpu *vcpu, u32
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
 
@@ -316,6 +364,10 @@ static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
 	unsigned long val;
 	int ret = 1;
 
+	val = kvm_psci_check_allowed_function(vcpu, psci_fn);
+	if (val)
+		goto out;
+
 	switch(psci_fn) {
 	case PSCI_0_2_FN_PSCI_VERSION:
 		val = KVM_ARM_PSCI_1_0;
@@ -339,6 +391,8 @@ static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
 		case PSCI_0_2_FN_SYSTEM_OFF:
 		case PSCI_0_2_FN_SYSTEM_RESET:
 		case PSCI_1_0_FN_PSCI_FEATURES:
+		case PSCI_1_0_FN_SYSTEM_SUSPEND:
+		case PSCI_1_0_FN64_SYSTEM_SUSPEND:
 		case ARM_SMCCC_VERSION_FUNC_ID:
 			val = 0;
 			break;
@@ -347,10 +401,16 @@ static int kvm_psci_1_0_call(struct kvm_vcpu *vcpu)
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
index a067410ebea5..052b0e717b08 100644
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
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
