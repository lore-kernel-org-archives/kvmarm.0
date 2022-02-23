Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC56BC433EF
	for <kvmarm@archiver.kernel.org>; Wed, 23 Feb 2022 04:19:18 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 829604C39C;
	Tue, 22 Feb 2022 23:19:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id K-KlZjWvm2Q6; Tue, 22 Feb 2022 23:19:17 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D00E4C3E3;
	Tue, 22 Feb 2022 23:19:17 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 43A544C369
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:15 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eZUe74VA0gzG for <kvmarm@lists.cs.columbia.edu>;
 Tue, 22 Feb 2022 23:19:14 -0500 (EST)
Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com
 [209.85.161.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 33B264C36A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 23:19:13 -0500 (EST)
Received: by mail-oo1-f74.google.com with SMTP id
 x130-20020a4a4188000000b0031b2e31acc7so8702361ooa.21
 for <kvmarm@lists.cs.columbia.edu>; Tue, 22 Feb 2022 20:19:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=V5qsHM9PPCNHYHtsk7xXfFwoohxSHTAZ/oFj3pAWz30=;
 b=d+BWzznlqCeXnt3CV4ZxwZKy0cQlouKMrCwBYrMN8WxZ4HE6kYGfy+alWWZcj0ITf+
 hRfD7wnAvFYjcAOlBGnsk8bNgy+jL8L57ZbKJFsax/Cy0PgtgxV6DbzZNpSxSQFiHPB2
 rtdm/gbYe3g+CrerxOpjuMmKqJhf/LEC7VdFwY+Vui9oNp3XutwkY7jnHrNAKjQvdSN7
 UHifXytuzFfXAMKnRG0hgx6sFl2llURt6HmHWO9PrPwIw4lw8rSqGU+JB+ucpnzwWXvq
 XVWurRbwxK6RJfONJnUTxjF2wjopFKJFizmshuK/VP6lhzV/tFUQtwTbQjFbz0Geo+8x
 z5dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=V5qsHM9PPCNHYHtsk7xXfFwoohxSHTAZ/oFj3pAWz30=;
 b=4S3gSOGu6FaplcEMkiXdiPtbTrxqjNnSe44Eib/VgcGJG7/nUEENcbV5PURZUCtogG
 g5XYVU4ossfVYTAS5CcOOc+zI04W0er9/CZeYaGSStXgZrEz1WhfDzqsigAk1wu7PRrJ
 d4kslYFGUfJqPULEJEaXKfpJ9Gjd73kwcQlo1qHkby+j+oHWg4os50b/4AcGK/uhowJB
 8A6Mo+kQAZ3/jzCatbBEmfhYgdrOMDvOEyqetrgLqIf5PL1A/bwSiXHJqoHOabLUnO8H
 4xj7+nZiavIqiwQfInK4ft7bQ6NfMoihwx4B7LZxdCoq5CA1TWr/W1ul25ykoaNmr7cN
 4yuQ==
X-Gm-Message-State: AOAM530PihDE7mhkDZ7gouAPqyKmRm0WEvQIXqqZI7zCAlBC3nl9wtb9
 TBKfiKtF3R4eJziDBXJG3EV4rD1ID4mliM2Qy5TQIKBUyQubcM/fykS238AsQBWcHEn9V0h5ugd
 BXidAH83MtgEy48sD7oFPGZ16hWh1kmnSOF5dOScia47n/r7/NBN/CxoYvNxhDjKUFOHsbQ==
X-Google-Smtp-Source: ABdhPJz2r87HmEpYMAnjO/m9fLbMPEZ1tg4GBYqYnr72VGiUpcnn5x9nctQ9aGq3W7L2fok9q633fRYVs7Y=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6870:4692:b0:d3:f39:92e1
 with SMTP id
 a18-20020a056870469200b000d30f3992e1mr3257927oap.69.1645589952479; Tue, 22
 Feb 2022 20:19:12 -0800 (PST)
Date: Wed, 23 Feb 2022 04:18:30 +0000
In-Reply-To: <20220223041844.3984439-1-oupton@google.com>
Message-Id: <20220223041844.3984439-6-oupton@google.com>
Mime-Version: 1.0
References: <20220223041844.3984439-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.473.g83b2b277ed-goog
Subject: [PATCH v3 05/19] KVM: arm64: Dedupe vCPU power off helpers
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: Wanpeng Li <wanpengli@tencent.com>, kvm@vger.kernel.org,
 Joerg Roedel <joro@8bytes.org>, Atish Patra <atishp@atishpatra.org>,
 Peter Shier <pshier@google.com>, kvm-riscv@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>
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
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/kvm/arm.c              |  6 +++---
 arch/arm64/kvm/psci.c             | 11 ++---------
 3 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 5bc01e62c08a..cacc9efd2e70 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -799,4 +799,6 @@ void __init kvm_hyp_reserve(void);
 static inline void kvm_hyp_reserve(void) { }
 #endif
 
+void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
+
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index ecc5958e27fe..07c6a176cdcc 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -426,7 +426,7 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	vcpu->cpu = -1;
 }
 
-static void vcpu_power_off(struct kvm_vcpu *vcpu)
+void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
 {
 	vcpu->arch.power_off = true;
 	kvm_make_request(KVM_REQ_SLEEP, vcpu);
@@ -454,7 +454,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 		vcpu->arch.power_off = false;
 		break;
 	case KVM_MP_STATE_STOPPED:
-		vcpu_power_off(vcpu);
+		kvm_arm_vcpu_power_off(vcpu);
 		break;
 	default:
 		ret = -EINVAL;
@@ -1179,7 +1179,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	 * Handle the "start in power-off" case.
 	 */
 	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
-		vcpu_power_off(vcpu);
+		kvm_arm_vcpu_power_off(vcpu);
 	else
 		vcpu->arch.power_off = false;
 
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 4335cd5193b8..e3f93b7f8d38 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -53,13 +53,6 @@ static unsigned long kvm_psci_vcpu_suspend(struct kvm_vcpu *vcpu)
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
@@ -262,7 +255,7 @@ static int kvm_psci_0_2_call(struct kvm_vcpu *vcpu)
 		val = kvm_psci_vcpu_suspend(vcpu);
 		break;
 	case PSCI_0_2_FN_CPU_OFF:
-		kvm_psci_vcpu_off(vcpu);
+		kvm_arm_vcpu_power_off(vcpu);
 		val = PSCI_RET_SUCCESS;
 		break;
 	case PSCI_0_2_FN_CPU_ON:
@@ -375,7 +368,7 @@ static int kvm_psci_0_1_call(struct kvm_vcpu *vcpu)
 
 	switch (psci_fn) {
 	case KVM_PSCI_FN_CPU_OFF:
-		kvm_psci_vcpu_off(vcpu);
+		kvm_arm_vcpu_power_off(vcpu);
 		val = PSCI_RET_SUCCESS;
 		break;
 	case KVM_PSCI_FN_CPU_ON:
-- 
2.35.1.473.g83b2b277ed-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
