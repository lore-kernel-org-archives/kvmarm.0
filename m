Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0154C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:41:11 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AEA840C23;
	Fri, 11 Mar 2022 12:41:11 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vFjAn-0C75IA; Fri, 11 Mar 2022 12:41:10 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F47E49EBA;
	Fri, 11 Mar 2022 12:41:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C40740D01
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YKmOoXZQuRrs for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:41:07 -0500 (EST)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E9FEC40BEE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:05 -0500 (EST)
Received: by mail-il1-f201.google.com with SMTP id
 a1-20020a927f01000000b002c76f4191c5so2942676ild.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 09:41:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=WkuuwGfi14coE8ixYDYlznYyITLCUK6RL9rnjxo/EMQ=;
 b=ifcI2iccrckyoj5u9oTr/pf9a3mM4OBwnO9VJ+IR6Ko80mV6SEi6/JDQnehd2z+mll
 qVL/vQGjAC0wcAVLHyDNpWYCybE0dUBSXAbsnGRGIHoUBj4DODFXFSaSDAYSDB9L6E/2
 zA8ZP7giNob46Z4mmaHsxqQ+atFSX/Y8hlmuDcjWdV8kOgx2ty5ne0imY2jlvXkDNLEw
 DFJo+k59FcI5DjvVwhJkZLNlevW1ElkHLZFHzK0N9htgU94rDohu0aMvE562OBmi+OKU
 uUDC9JLaw0a+FMZ9zOWVTyOT8erKXKdSNOSdpf3jRxYrineA6GdrUL/6Wbj5Ir+WwoVe
 HOaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=WkuuwGfi14coE8ixYDYlznYyITLCUK6RL9rnjxo/EMQ=;
 b=str1sxrIjC5wJ4kQ3xPZH8arUQrXjWxqBf614GVZtV5PkmrJQcipLGK+NIqdGthsDr
 GJFUs1WmG24mm6/ovcBNKy0ubPmYY3EZv/zwfe34TlExaSw3n72TEUO6OYoxsmbxvM7j
 8KnPTTMYJDU7+TPEKZpTYsV4Kkh/GTks+7qTRtGtJOW7R7RnvXAEWSW9hbTmw0RYSkPM
 QFreAUyVD5u2a28mgsfouEytNgM677BSiT7Omt+hwf0UEVvfhJ3XmZj9BpNl0TVhigLK
 dX5GvrSnkJw0x1IEdCkfg2q179ln55oQQMieRUh50BX3MJF4Rnf3rturdceDvRSPmzFO
 mdDw==
X-Gm-Message-State: AOAM533wTsmauW3AXLL17XUzZRUJor59UgCYKQnLw2CQGwiKjRbHR0Iy
 lF47R0N2CTIiDgDMP7ZZPosf13LMcKWj+TsIOjR1mgLKvTHGcfVMXUtaoT/Ecg8X63CIksaKmln
 EFoi/Qm+dsmipnHKMbGbwo1icYULkiDybCQFmfgCyMpdQ2Wk2GhTC+rtUA7bhkgdPeav9FQ==
X-Google-Smtp-Source: ABdhPJxGWatXCqCoiKhIiZky04qigEDGVCFcOMZBHSLW1DHnTi8cxj4H94EdjPxP2GR9SIoaEqsx1XYL/70=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6602:45b:b0:645:bdc2:fe13
 with SMTP id
 e27-20020a056602045b00b00645bdc2fe13mr8682643iov.114.1647020465380; Fri, 11
 Mar 2022 09:41:05 -0800 (PST)
Date: Fri, 11 Mar 2022 17:39:50 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-5-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 04/15] KVM: arm64: Dedupe vCPU power off helpers
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, wanpengli@tencent.com, kvm@vger.kernel.org, joro@8bytes.org,
 pshier@google.com, kvm-riscv@lists.infradead.org, atishp@atishpatra.org,
 pbonzini@redhat.com, vkuznets@redhat.com, jmattson@google.com
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

vcpu_power_off() and kvm_psci_vcpu_off() are equivalent; rename the
former and replace all callsites to the latter.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              |  6 +++---
 arch/arm64/kvm/psci.c             | 11 ++---------
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 0e96087885fe..a2e00129cf4b 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -826,4 +826,6 @@ void __init kvm_hyp_reserve(void);
 static inline void kvm_hyp_reserve(void) { }
 #endif
 
+void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 17021bc8ee2c..0b71c0a27a20 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -432,7 +432,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	vcpu->cpu = -1;
 }
 
-static void vcpu_power_off(struct kvm_vcpu *vcpu)
+void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.power_off = true;
 	kvm_make_request(KVM_REQ_SLEEP, vcpu);
@@ -460,7 +460,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 		vcpu->arch.power_off = false;
 		break;
 	case KVM_MP_STATE_STOPPED:
-		vcpu_power_off(vcpu);
+		kvm_arm_vcpu_power_off(vcpu);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1124,7 +1124,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	 * Handle the "start in power-off" case.
 	 */
 	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
-		vcpu_power_off(vcpu);
+		kvm_arm_vcpu_power_off(vcpu);
 	else
 		vcpu->arch.power_off = false;
 
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 2a228744d0c4..f5c865485f09 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -52,13 +52,6 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
 	return PSCI_RET_SUCCESS;
 }
 
-static void kvm_psci_vcpu_off(struct kvm_vcpu *vcpu)
-{
-	vcpu->arch.power_off = true;
-	kvm_make_request(KVM_REQ_SLEEP, vcpu);
-	kvm_vcpu_kick(vcpu);
-}
-
 static inline bool kvm_psci_valid_affinity(struct kvm_vcpu *vcpu,
 					   unsigned long affinity)
 {
@@ -249,7 +242,7 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 		val = kvm_psci_vcpu_suspend(vcpu);
 		break;
 	case PSCI_0_2_FN_CPU_OFF:
-		kvm_psci_vcpu_off(vcpu);
+		kvm_arm_vcpu_power_off(vcpu);
 		val = PSCI_RET_SUCCESS;
 		break;
 	case PSCI_0_2_FN_CPU_ON:
@@ -387,7 +380,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 
 	switch (psci_fn) {
 	case KVM_PSCI_FN_CPU_OFF:
-		kvm_psci_vcpu_off(vcpu);
+		kvm_arm_vcpu_power_off(vcpu);
 		val = PSCI_RET_SUCCESS;
 		break;
 	case KVM_PSCI_FN_CPU_ON:
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
