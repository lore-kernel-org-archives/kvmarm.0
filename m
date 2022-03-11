Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9DCFC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 11 Mar 2022 17:41:13 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A42A340C1B;
	Fri, 11 Mar 2022 12:41:13 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qOLhIVrlGxTY; Fri, 11 Mar 2022 12:41:12 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4024449EE1;
	Fri, 11 Mar 2022 12:41:10 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EC40B40BD3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:08 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GM-DDdZKB5to for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Mar 2022 12:41:07 -0500 (EST)
Received: from mail-io1-f74.google.com (mail-io1-f74.google.com
 [209.85.166.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E73CA49E1A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 12:41:06 -0500 (EST)
Received: by mail-io1-f74.google.com with SMTP id
 h14-20020a05660208ce00b00645c339411bso6757733ioz.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Mar 2022 09:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=0m6A5PPOCVg09Pxf2RbRPcM9r3W2FFgrGrefirCG0dw=;
 b=fbVhFEnRC0EJPcOif4yxOG+vX5ff+3YEmZwaviTIYAHDXLbxiZ7Zo8BLsfLuOBjSdP
 DJ6FmCWIJ1fHqZij7wk4TnaYX2amMeAqIxi5LXKh66ycjGDLUEY9sZoXWUVd34tAegQu
 r9Zp4d1mv73ckFVqO0oQLkmJHIruMrHD32EO3Zj0DnyVQZvX3zb5R05EPBxZY1bk1Buv
 tVFCcDiWJUQ8q23UelSfmdcwp45bECQ0uTyvwfot1322EPqUCHY8D5B+G5drMDP98iOg
 5RggRtDBZxVeCgnlrZw1yXVAAXuDBtvYr57fNQYX3vVHf05Bl2p32LEAViPl+HtPGtm7
 NXXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=0m6A5PPOCVg09Pxf2RbRPcM9r3W2FFgrGrefirCG0dw=;
 b=1oSFI1k1u7eKE0X6vNuKFLgzprDWY0c3KUBZUKruIXV8MdlOj6vxyVf2gNyMcCDG3Q
 M7Tv2o5mAWWHwdve7aaxTMpSr5vfig6B/jp2MF+e9dU9ROCS7DQGqB+5BzXrYP22lfYV
 731cBvrejkFjnpRQ8GVtGFgnQrBPmAbzkiUyM5Rsdw5LaTiiYu9zwiijeM2rTIPc5JaZ
 xWIydcZvLLaRgUTGQodWGro3VVTsgmNw3QZ1CyM67tJUjCYu+SjnXw/0fD1OdvwWELvJ
 Hf5/ZXCFSovydsTiF/YGPH/cjt/kqUtkyPr4rg3vA021n3cAAKcPqyY7fnQWtZY6PuiW
 1H/Q==
X-Gm-Message-State: AOAM533B+lP6+yui9tDWjF7RJCsESRb7J8uL3FVbjEeDCsRMvyQvbwyv
 Hp2TvbdO7Bk1wFYI/1a8WhwDu5RyXWJEs6yPcnITqrOSO1NdrHqaS7u02q4MYc+3iBVojUUdkpg
 b/CVKXOMMNU8ZhzoS9BfH1Hqq2QDrrUcpNJCiHkTZ/FS9S7sRSyp5FzDrqpG1LHjK+bIrog==
X-Google-Smtp-Source: ABdhPJw3zPOyvK81rSTzo3SeazHpGkvLlivP1gVUMcVrJfawtucSdssR21NPEIR4SffXhQo1QgfyQitzJL8=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a5d:89d8:0:b0:645:d853:66f0 with
 SMTP id
 a24-20020a5d89d8000000b00645d85366f0mr8552754iot.30.1647020466288; Fri, 11
 Mar 2022 09:41:06 -0800 (PST)
Date: Fri, 11 Mar 2022 17:39:51 +0000
In-Reply-To: <20220311174001.605719-1-oupton@google.com>
Message-Id: <20220311174001.605719-6-oupton@google.com>
Mime-Version: 1.0
References: <20220311174001.605719-1-oupton@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 05/15] KVM: arm64: Track vCPU power state using MP state
 values
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

A subsequent change to KVM will add support for additional power states.
Store the MP state by value rather than keeping track of it as a
boolean.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  5 +++--
 arch/arm64/kvm/arm.c              | 22 ++++++++++++----------
 arch/arm64/kvm/psci.c             | 12 ++++++------
 3 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index a2e00129cf4b..da58eb96d2a8 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -355,8 +355,8 @@ struct kvm_vcpu_arch {
 		u32	mdscr_el1;
 	} guest_debug_preserved;
 
-	/* vcpu power-off state */
-	bool power_off;
+	/* vcpu power state */
+	struct kvm_mp_state mp_state;
 
 	/* Don't run the guest (internal implementation need) */
 	bool pause;
@@ -827,5 +827,6 @@ static inline void kvm_hyp_reserve(void) { }
 #endif
 
 void kvm_arm_vcpu_power_off(struct kvm_vcpu *vcpu);
+bool kvm_arm_vcpu_stopped(struct kvm_vcpu *vcpu);
 
 #endif /* __ARM64_KVM_HOST_H__ */
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 0b71c0a27a20..3918d078fc4d 100644
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
index f5c865485f09..efd4428fda1c 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -77,7 +77,7 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
 	 */
 	if (!vcpu)
 		return PSCI_RET_INVALID_PARAMS;
-	if (!vcpu->arch.power_off) {
+	if (!kvm_arm_vcpu_stopped(vcpu)) {
 		if (kvm_psci_version(source_vcpu) != KVM_ARM_PSCI_0_1)
 			return PSCI_RET_ALREADY_ON;
 		else
@@ -101,12 +101,12 @@ static unsigned long kvm_psci_vcpu_on(struct kvm_vcpu *source_vcpu)
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
@@ -144,7 +144,7 @@ static unsigned long kvm_psci_vcpu_affinity_info(struct kvm_vcpu *vcpu)
 		mpidr = kvm_vcpu_get_mpidr_aff(tmp);
 		if ((mpidr & target_affinity_mask) == target_affinity) {
 			matching_cpus++;
-			if (!tmp->arch.power_off)
+			if (!kvm_arm_vcpu_stopped(tmp))
 				return PSCI_0_2_AFFINITY_LEVEL_ON;
 		}
 	}
@@ -170,7 +170,7 @@ static void kvm_prepare_system_event(struct kvm_vcpu *vcpu, u32 type, u64 flags)
 	 * re-initialized.
 	 */
 	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
-		tmp->arch.power_off = true;
+		tmp->arch.mp_state.mp_state = KVM_MP_STATE_STOPPED;
 	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
 
 	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
