Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DA1DC433F5
	for <kvmarm@archiver.kernel.org>; Wed,  4 May 2022 03:25:06 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 271484B1FA;
	Tue,  3 May 2022 23:25:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7bU6MdI1BINj; Tue,  3 May 2022 23:25:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C89D54B1A9;
	Tue,  3 May 2022 23:25:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EA3294B132
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:25:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 99CqYHAOyC4d for <kvmarm@lists.cs.columbia.edu>;
 Tue,  3 May 2022 23:25:01 -0400 (EDT)
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com
 [209.85.210.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id BB7C34B0DE
 for <kvmarm@lists.cs.columbia.edu>; Tue,  3 May 2022 23:24:59 -0400 (EDT)
Received: by mail-pf1-f202.google.com with SMTP id
 i127-20020a625485000000b0050d3d1cab5fso27635pfb.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 03 May 2022 20:24:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=EIziyV713c9Gy7N8pI1PaC9upsDWwJjlqgfEvo9nqeE=;
 b=ZPKEu8L2nh3LgddlnvnOclfE8A4DcgXiW2eTUjHjxVu1MnOPBfQTkjUFcz3kUDLmbE
 IDEhi43K3RPvBdOnJ+brA+wlxUHtrapRfayJzLb/iMRul23LGEBxJ5F7M+AbRCP3Zs+4
 cJax+mXxqETi5oIUa0d6sAyEM/AO5QqR+tiYUWf8uH6mZj/VLJ3Lzp6YIxNs3ci5dhT0
 YMs3Gx2ruYx5nFjrJ18fdKUG8mDvRehcIzXibBAc1iA+hWFhVe45WNdijVsogBmyL1Qk
 D3VE3Gg0BTVa0ZVLU+kidwm2WsZfciyke7b+Dl9JyFXY7INMIIesAXKAXJGxCoiuXC0P
 lwig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=EIziyV713c9Gy7N8pI1PaC9upsDWwJjlqgfEvo9nqeE=;
 b=SeSJAC+4Oev+G8qq7888X07LzhCQxkC6d0sT8YKohQDXHpA89fvCciLPbl95u/RCw2
 dIt7zpwO80XldwSm7+jKy+shXwPkyOxatkQ5aml3uzul7ZVluwI7s6uq7pGZOzlQgP+3
 Kh48LEnOBegnbxHqdKr29zKNumR+RX2GGa/OGSaxzA6A8FKfJ59EzyfwN93Yhgn581Jn
 HYi1XGHRBv8Gg7vEdSVtOn+PpXLsrD2aAbHWpXYPGfFlgm9dH4XvospBXG/B3JAnEdeq
 2p00Nw9Ot/Nu6xJ0hDAdmlcTIUoSmZnTRcoC/GoxPQKXfsgjRXt7XMSx8zLc7UMnPiB5
 +QmA==
X-Gm-Message-State: AOAM530NBz5ZSogjfYKDUztN2n6Aik+pJyy98wKVyvN7ihFHBPDTxXuK
 KEf60hcemNjKB7nPhJU+FrCyyjpItS9F6bnuoA212CJFYkJj2rfjHiam+6rmjiA9tkNKNBlsyUN
 bLu/JDjeKKBXKklzNVXpG0qlQ0h8Z0c8Z5FumgDcxJMMeN4k4u42AuK6AmiurWEQOAF6PAA==
X-Google-Smtp-Source: ABdhPJxI0BTdhjgimjAkiuzVocoWP2C0Axd2vDhxllpUDEld/gAcfN5MTikLaK6SDPL3cM2XOBrF84TBSXk=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a17:902:b698:b0:158:faee:442f with SMTP id
 c24-20020a170902b69800b00158faee442fmr20205719pls.75.1651634698846; Tue, 03
 May 2022 20:24:58 -0700 (PDT)
Date: Wed,  4 May 2022 03:24:37 +0000
In-Reply-To: <20220504032446.4133305-1-oupton@google.com>
Message-Id: <20220504032446.4133305-4-oupton@google.com>
Mime-Version: 1.0
References: <20220504032446.4133305-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
Subject: [PATCH v6 03/12] KVM: arm64: Track vCPU power state using MP state
 values
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

A subsequent change to KVM will add support for additional power states.
Store the MP state by value rather than keeping track of it as a
boolean.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Reiji Watanabe <reijiw@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  5 +++--
 arch/arm64/kvm/arm.c              | 22 ++++++++++++----------
 arch/arm64/kvm/psci.c             | 12 ++++++------
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 490cd7f3a905..f3f93d48e21a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -365,8 +365,8 @@ struct kvm_vcpu_arch {
 		u32	mdscr_el1;
 	} guest_debug_preserved;
 
-	/* vcpu power-off state */
-	bool power_off;
+	/* vcpu power state */
+	struct kvm_mp_state mp_state;
 
 	/* Don't run the guest (internal implementation need) */
 	bool pause;
@@ -842,5 +842,6 @@ static inline void kvm_hyp_reserve(void) { }
 #endif
 
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
+bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 28c83c6ddbae..29e107457c4d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -434,18 +434,20 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.power_off = true;
+	vcpu->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
 	kvm_make_request(KVM_REQ_SLEEP, vcpu);
 	kvm_vcpu_kick(vcpu);
 }
 
+bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu)
+{
+	return vcpu->arch.mp_state.mp_state == KVM_MP_STATE_STOPPED;
+}
+
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	if (vcpu->arch.power_off)
-		mp_state->mp_state = KVM_MP_STATE_STOPPED;
-	else
-		mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
+	*mp_state = vcpu->arch.mp_state;
 
 	return 0;
 }
@@ -457,7 +459,7 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 
 	switch (mp_state->mp_state) {
 	case KVM_MP_STATE_RUNNABLE:
-		vcpu->arch.power_off = false;
+		vcpu->arch.mp_state = *mp_state;
 		break;
 	case KVM_MP_STATE_STOPPED:
 		kvm_arm_vcpu_power_off(vcpu);
@@ -480,7 +482,7 @@ int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
 	bool irq_lines = *vcpu_hcr(v) & (HCR_VI | HCR_VF);
 	return ((irq_lines || kvm_vgic_vcpu_pending_irq(v))
-		&& !v->arch.power_off && !v->arch.pause);
+		&& !kvm_arm_vcpu_stopped(v) && !v->arch.pause);
 }
 
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
@@ -597,10 +599,10 @@ static void vcpu_req_sleep(struct kvm_vcpu *vcpu)
 	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
 
 	rcuwait_wait_event(wait,
-			   (!vcpu->arch.power_off) &&(!vcpu->arch.pause),
+			   (!kvm_arm_vcpu_stopped(vcpu)) && (!vcpu->arch.pause),
 			   TASK_INTERRUPTIBLE);
 
-	if (vcpu->arch.power_off || vcpu->arch.pause) {
+	if (kvm_arm_vcpu_stopped(vcpu) || vcpu->arch.pause) {
 		/* Awaken to handle a signal, request we sleep again later. */
 		kvm_make_request(KVM_REQ_SLEEP, vcpu);
 	}
@@ -1126,7 +1128,7 @@ static int kvm_arch_vcpu_ioctl_vcpu_init(struct kvm_vcpu *vcpu,
 	if (test_bit(KVM_ARM_VCPU_POWER_OFF, vcpu->arch.features))
 		kvm_arm_vcpu_power_off(vcpu);
 	else
-		vcpu->arch.power_off = false;
+		vcpu->arch.mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
 
 	return 0;
 }
diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index 9b1f3acae155..2e6f060214a7 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -76,7 +76,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 */
 	if (!vcpu)
 		return PSCI_RET_INVALID_PARAMS;
-	if (!vcpu->arch.power_off) {
+	if (!kvm_arm_vcpu_stopped(vcpu)) {
 		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
 			return PSCI_RET_ALREADY_ON;
 		else
@@ -100,12 +100,12 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	kvm_make_request(KVM_REQ_VCPU_RESET, vcpu);
 
 	/*
-	 * Make sure the reset request is observed if the change to
-	 * power_off is observed.
+	 * Make sure the reset request is observed if the RUNNABLE mp_state is
+	 * observed.
 	 */
 	smp_wmb();
 
-	vcpu->arch.power_off = false;
+	vcpu->arch.mp_state.mp_state = KVM_MP_STATE_RUNNABLE;
 	kvm_vcpu_wake_up(vcpu);
 
 	return PSCI_RET_SUCCESS;
@@ -143,7 +143,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 		mpidr = kvm_vcpu_get_mpidr_aff(tmp);
 		if ((mpidr & target_affinity_mask) == target_affinity) {
 			matching_cpus++;
-			if (!tmp->arch.power_off)
+			if (!kvm_arm_vcpu_stopped(tmp))
 				return PSCI_0_2_AFFINITY_LEVEL_ON;
 		}
 	}
@@ -169,7 +169,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
 	 * re-initialized.
 	 */
 	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
-		tmp->arch.power_off = true;
+		tmp->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
 	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
-- 
2.36.0.464.gb9c8b46e94-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
