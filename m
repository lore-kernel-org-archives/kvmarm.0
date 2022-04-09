Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D253BC4332F
	for <kvmarm@archiver.kernel.org>; Sat,  9 Apr 2022 18:46:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6E40A4B18F;
	Sat,  9 Apr 2022 14:46:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rrkCvhIoOKcg; Sat,  9 Apr 2022 14:46:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 582E84B16F;
	Sat,  9 Apr 2022 14:46:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 361314B0ED
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ViSWWzAinmtw for <kvmarm@lists.cs.columbia.edu>;
 Sat,  9 Apr 2022 14:46:02 -0400 (EDT)
Received: from mail-il1-f202.google.com (mail-il1-f202.google.com
 [209.85.166.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 16CAB4B132
 for <kvmarm@lists.cs.columbia.edu>; Sat,  9 Apr 2022 14:46:02 -0400 (EDT)
Received: by mail-il1-f202.google.com with SMTP id
 h13-20020a056e021d8d00b002c7fb1ec601so7637610ila.6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 09 Apr 2022 11:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=GrTuEsowgjSLSh5SPFZtOIzYck4sIL1A+AsuQBdb1R4=;
 b=ZEKDnqh1E68l3QyvAwE5py+QjZMcctkJAsooLeFVX+b3t24hnB1aJN+oIh6gCVrXml
 cRpXGP3e2CkDJugK+ETgdNu5r/nuHLmgDAvgQxtuc0CY57lba5ChcNaAGtYqB8qBnNeU
 elaRjDfxj+EW1CVaH0QZnJI+T+xmw69neU3WhJU2JbtPNbrcKPybZgzDRQRwqBd40HU4
 o82y67LH/WWG77pZSLlcykW607i6/EZYZmXjitv2C1BbjNYLGR0AC+he0cLCSKCebrsv
 KtroytYnfn8t/GA8eLiIEoV3EHLcGjNsoUPxnge+zp4QQLP0NSYqtAhpZQ3ItwBsCduO
 56+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=GrTuEsowgjSLSh5SPFZtOIzYck4sIL1A+AsuQBdb1R4=;
 b=rs0Fh5E3fJn4vf4EGeWKzOkbQP2nDGeNApjPrSdsXhpLE3d89Da5ztqb7S9mEx4Djz
 T3uR7Q/DiK2idJpdISM5pA3LcuKSLJSHufDjs+vtuivK5uw2+evYNw8yXiwk5sUQ68/0
 3YCT1KM8kqLid/rgp6Cjx3WRNevsmUebgx7dBFyyPD7Sk4y2r7RG19C9xRBU2bx8PHI5
 Euq9WelFVyMLCEA2d3v4iAjHtlKUIgFsLSwBRvLEA6O/HFOzv2AJ7YXj8IawF494LC+S
 0HleD5YHE4kh7ZjYJ6gjJyLSMrAh1qFVVhmE2AEmlXObX9cdNECwSOZOnxH1zfgDigfK
 ugrQ==
X-Gm-Message-State: AOAM532GycQ9jINQOVlyolgquLo5PTSGXZSZ69sMbTbGHmNNkRXGCfSN
 gDPwXIPul9vfH4nGZLo6r/hF1ULHOTh+t6+oTjZafwC/gzf4F4hoYhhYUQ0NA6xo+PZEOaOxdsX
 i0eWheYOEqcqa8eJiHjISSmLyND5yPIJVBmFyO2ntwn/PzRUb77W3Wkg+Vn1CIQK3oSiyvg==
X-Google-Smtp-Source: ABdhPJwE27yromTM7IHeD35r5yOQuHh5y0AoUWsUzU99gkjTTiS0e8E0ysBofkG6VXxzu+eSD3Fqgn3yTIA=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6e02:174e:b0:2ca:1fda:85b
 with SMTP id
 y14-20020a056e02174e00b002ca1fda085bmr11371943ill.85.1649529961465; Sat, 09
 Apr 2022 11:46:01 -0700 (PDT)
Date: Sat,  9 Apr 2022 18:45:38 +0000
In-Reply-To: <20220409184549.1681189-1-oupton@google.com>
Message-Id: <20220409184549.1681189-3-oupton@google.com>
Mime-Version: 1.0
References: <20220409184549.1681189-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.1178.g4f1659d476-goog
Subject: [PATCH v5 02/13] KVM: arm64: Dedupe vCPU power off helpers
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
index 94a27a7520f4..490cd7f3a905 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -841,4 +841,6 @@ void __init kvm_hyp_reserve(void);
 static inline void kvm_hyp_reserve(void) { }
 #endif
 
+void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 523bc934fe2f..28c83c6ddbae 100644
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
index 3d43350ffb07..cdc0609c1135 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -51,13 +51,6 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
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
@@ -244,7 +237,7 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 		val = kvm_psci_vcpu_suspend(vcpu);
 		break;
 	case PSCI_0_2_FN_CPU_OFF:
-		kvm_psci_vcpu_off(vcpu);
+		kvm_arm_vcpu_power_off(vcpu);
 		val = PSCI_RET_SUCCESS;
 		break;
 	case PSCI_0_2_FN_CPU_ON:
@@ -378,7 +371,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 
 	switch (psci_fn) {
 	case KVM_PSCI_FN_CPU_OFF:
-		kvm_psci_vcpu_off(vcpu);
+		kvm_arm_vcpu_power_off(vcpu);
 		val = PSCI_RET_SUCCESS;
 		break;
 	case KVM_PSCI_FN_CPU_ON:
-- 
2.35.1.1178.g4f1659d476-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
