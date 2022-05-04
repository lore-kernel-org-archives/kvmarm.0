Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0EF2C433FE
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 03:25:02 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 306404B211;
	Tue,  3 May 2022 23:25:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id b2uNitzjItwX; Tue,  3 May 2022 23:25:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A8D094B208;
	Tue,  3 May 2022 23:25:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0C76849F38
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:24:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YFt1WF8iKGvb for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 23:24:57 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CDA6549EE3
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:24:57 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 b33-20020a25aea1000000b0064588c45fbaso182374ybj.16
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2022 20:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=KpwL4QzbPyZbm+YVQpL9URPH0DGdCbuS02mP/hlbKlg=;
 b=jeKwpzihPzBI5DFNNTg8f9KTEk3wvyGcOz8iRa574qHehsCy7bxP2Oma0wA9aFy25r
 h1STXWOMy4gsGxF8l4TfrGR0UoxrcCdOZyJi60Hd0Tf85XzKVIozH/fzsrQB1lqhO0qm
 gP5B1DhbRhcQ+jUpsnqXllGbYtq8rNc8m8C1Z+2LJ/m1rOBq7GfL0x5p0OvqJ1UoW96U
 vYUO6uSQvES/r/ouEzcivg2/UGs+Tyj1a2VMJRSrJlNcXS187IX2utVRIRKPlmHW5Tlh
 BZdli+17//PdmR1+gjXpAR4odhnvuH2pEvKa3KED3ScCcX9zlBvBR/PNgK4+YvE5lsws
 wWRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=KpwL4QzbPyZbm+YVQpL9URPH0DGdCbuS02mP/hlbKlg=;
 b=q6tFs/98cI6TXXBx87lCR0Igx2VYse5JbpzrdEdPESBrA1r9/BmrUh44Qicl8hora/
 R9Ct6OpEYhLIiCDKSKO+EB2kYEMa/amKlBgFkQg0tOqYGKvLTKIEpA2DnlSkimZW24b2
 N0kQcp+GoG5QKCHqw70XlKMC3rh0Km3BVRog3/hwhpf/wFL37QyMMiZ8FZDdc6XHgCIZ
 1lxSuuCrMheRTwisCt5Rs5SRh3g/D9BiUxa/u/bUzgKn2OmZZ+nGFgcIAVJCWDcPq5oK
 zEO5OrEv+KgDkdZHKBFoLCezj/b+rVx1u3CUYnSDyps9M0zY7YlbpMvmqmTIzLsIsdIh
 Hy3g==
X-Gm-Message-State: AOAM5316ClvYTYTskZ/V76gQazYdrCx9Q3WLmPLgI/pnpdlLfg55kvB5
 bwiG8U9ycKlWeq96djiT06Ox8DjO4+4Iu26wYh0G2EDOxe6eHdIi0gQ9haoKfONgJFPHPLlr08n
 l3wVq18ad8gDj+HhQ1BGqsWn1lVpwrhpw3mQI75vEAsS0lNr46c9gNCSVeHds3zuF7iYsIA==
X-Google-Smtp-Source: ABdhPJzZQ3AfNj3AGGTywFxgbadz+UrA7rVq5R/AGOh6+/FRVPv53w9pNiynRMxviJd1G3noU3oC08UvNJQ=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a25:bfca:0:b0:648:6d10:99ac with SMTP id
 q10-20020a25bfca000000b006486d1099acmr15486439ybm.176.1651634697177; Tue, 03
 May 2022 20:24:57 -0700 (PDT)
Date: Wed,  4 May 2022 03:24:36 +0000
In-Reply-To: <20220504032446.4133305-1-oupton@google.com>
Message-Id: <20220504032446.4133305-3-oupton@google.com>
Mime-Version: 1.0
References: <20220504032446.4133305-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 02/12] KVM: arm64: Dedupe vCPU power off helpers
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
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
index 67fbd6ef022c..9b1f3acae155 100644
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
@@ -245,7 +238,7 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 		val = kvm_psci_vcpu_suspend(vcpu);
 		break;
 	case PSCI_0_2_FN_CPU_OFF:
-		kvm_psci_vcpu_off(vcpu);
+		kvm_arm_vcpu_power_off(vcpu);
 		val = PSCI_RET_SUCCESS;
 		break;
 	case PSCI_0_2_FN_CPU_ON:
@@ -379,7 +372,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 
 	switch (psci_fn) {
 	case KVM_PSCI_FN_CPU_OFF:
-		kvm_psci_vcpu_off(vcpu);
+		kvm_arm_vcpu_power_off(vcpu);
 		val = PSCI_RET_SUCCESS;
 		break;
 	case KVM_PSCI_FN_CPU_ON:
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
