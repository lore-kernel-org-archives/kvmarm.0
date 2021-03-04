Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20C1AC433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:29 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A636964F34
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A636964F34
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3CAD44B639;
	Thu,  4 Mar 2021 06:55:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id D-PVH0xSwoXj; Thu,  4 Mar 2021 06:55:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CE1CE4B641;
	Thu,  4 Mar 2021 06:55:26 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 05BE94B354
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:26 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uEj7wNiqCn49 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 06:55:25 -0500 (EST)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 07ED14B639
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:25 -0500 (EST)
Received: by mail-qt1-f202.google.com with SMTP id i2so2980299qtd.4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Mar 2021 03:55:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=wzl1Zrhi4TWPJ4LiWDQYn1IAD9s/pNCF8UOfzEYk+U8=;
 b=SK0kwddIWIKTm4c58QKLSbItdZbwyX2XdhoeRKqcUhC9DoYewRSfDyXbrsNIq4OzrO
 XsVDilmTi8JC40jzotLwhdIhYDzeeKZBThwJ9wEHqAkqAP598V+/ZmNpw4NGGFSSLY3c
 1vTgbQbXqYnWJiOshb+lKqUqRicBRS4CTsarFf98Rvcrt3N23L2NiTdNnNC9bNINlgs+
 +NQJsBT/lIWZbz9kS7LIlcJt7je/m8P42G3+bWHLWqf3Bk5Q85MRFZfKguMbZZJLGh5P
 zflloXU3x6ZHqhlRPyg5b9VhM1GoOmppJ5cAj9xRUO2QNLftc+p+/LOXVqnzwzMhY0eO
 s6ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=wzl1Zrhi4TWPJ4LiWDQYn1IAD9s/pNCF8UOfzEYk+U8=;
 b=Jn/vRrg1c8qsuntpH9jhqZhjtfWQmyLsLsbKz8p3SLEqFw48bm5XUJm83EDJczm3ms
 1FiW7pbPAz34zTowy7ni/DbKqPm+ktxAYaarxTOSkBXXcwz5ZJUePSr4J/xFlzjoPiA4
 h0QvaHl95I0gZhUKTBa+ina7JesUJ4rskfu8FQjXPGni7SmN3zIT0KWHiNFj/N6KRZgh
 MDe1nx/JZ+bfcSe7Nf5CDO8S7+6A4sQa8M8700Sf57YuCG5ipIhp7J/nitTJ7klCAjrE
 p9VXBkNbOc3lokHwzyYe3hHsD8vvRfSVG0oCuAEWREaLROiYeCMq8ficE5iUjW4bAWqm
 SGEA==
X-Gm-Message-State: AOAM530Ef7JHo9Te0MbPFlJL4rXDYpyZB14SQTAtYQYLno3IYYoPAaKf
 QemHtUebe5O3cO1i2POh2Q8eapmYZBh88DsnL/GtXJogGL50dOz7SM1gAP+BfkX5M8BFaQRFlXI
 PXEIvcNcvsS1TpChkyxkkTTB4mYSjC7elx58ZKXsSbU/1I+5CNwHqLg1n3mNzdZ6vUFDfBA==
X-Google-Smtp-Source: ABdhPJzIl2ee2sNuHH8MBDpwKrMfeOrss/1wKxIKxonUz66E5sTRTwJzkZWHvDCkMLK3Cc7Hpgonrcc03IQ=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a0c:b59f:: with SMTP id
 g31mr3546041qve.28.1614858924468; 
 Thu, 04 Mar 2021 03:55:24 -0800 (PST)
Date: Thu,  4 Mar 2021 11:54:49 +0000
In-Reply-To: <20210304115454.3597879-1-ascull@google.com>
Message-Id: <20210304115454.3597879-7-ascull@google.com>
Mime-Version: 1.0
References: <20210304115454.3597879-1-ascull@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 06/10] KVM: arm64: Avoid needlessly reloading guest FP state
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, maz@kernel.org, catalin.marinas@arm.com,
 will@kernel.org, Dave.Martin@arm.com
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

When returning to a user task from a vcpu, keep track of the vcpu state
being in registers so that the state can be reinstated on the next entry
if the registers still contain the vcpu's latest state.

This avoids the need to trap and restore in the case that the vcpu's
registers are still in place. The state must still be saved when
switching away from the vcpu to allow movement to another core or the
task to load its own state.

Signed-off-by: Andrew Scull <ascull@google.com>
Cc: Dave Martin <Dave.Martin@arm.com>
---
 arch/arm64/include/asm/fpsimd.h |  1 +
 arch/arm64/kernel/fpsimd.c      | 11 +++++++++--
 arch/arm64/kvm/fpsimd.c         | 18 ++++++++++++++++--
 3 files changed, 26 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index bec5f14b622a..fc0b932211f0 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -48,6 +48,7 @@ extern void fpsimd_update_current_state(struct user_fpsimd_state const *state);
 extern void fpsimd_bind_task_to_cpu(void);
 extern void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *state,
 				     void *sve_state, unsigned int sve_vl);
+extern bool fpsimd_is_bound_to_cpu(struct user_fpsimd_state *state);
 
 extern void fpsimd_flush_task_state(struct task_struct *target);
 extern void fpsimd_save_and_flush_cpu_state(void);
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 062b21f30f94..683675b5d198 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1009,8 +1009,7 @@ void fpsimd_thread_switch(struct task_struct *next)
 	 * state.  For kernel threads, FPSIMD registers are never loaded
 	 * and wrong_task and wrong_cpu will always be true.
 	 */
-	wrong_task = __this_cpu_read(fpsimd_last_state.st) !=
-					&next->thread.uw.fpsimd_state;
+	wrong_task = !fpsimd_is_bound_to_cpu(&next->thread.uw.fpsimd_state);
 	wrong_cpu = next->thread.fpsimd_cpu != smp_processor_id();
 
 	update_tsk_thread_flag(next, TIF_FOREIGN_FPSTATE,
@@ -1137,6 +1136,14 @@ void fpsimd_bind_state_to_cpu(struct user_fpsimd_state *st, void *sve_state,
 	last->sve_vl = sve_vl;
 }
 
+bool fpsimd_is_bound_to_cpu(struct user_fpsimd_state *st)
+{
+	WARN_ON(!system_supports_fpsimd());
+	WARN_ON(!in_softirq() && !irqs_disabled());
+
+	return __this_cpu_read(fpsimd_last_state.st) == st;
+}
+
 /*
  * Load the userland FPSIMD state of 'current' from memory, but only if the
  * FPSIMD state already held in the registers is /not/ the most recent FPSIMD
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 3e5a02137643..dcc5bfad5408 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -51,6 +51,8 @@ int kvm_arch_vcpu_run_map_fp(struct kvm_vcpu *vcpu)
  */
 void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 {
+	unsigned long flags;
+
 	BUG_ON(!current->mm);
 
 	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
@@ -61,13 +63,25 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 	if (!system_supports_fpsimd())
 		return;
 
-	vcpu->arch.flags |= KVM_ARM64_FP_HOST;
+	local_irq_save(flags);
+
+	if (fpsimd_is_bound_to_cpu(&vcpu->arch.ctxt.fp_regs) &&
+	    vcpu->arch.fpsimd_cpu == smp_processor_id()) {
+		clear_thread_flag(TIF_FOREIGN_FPSTATE);
+		update_thread_flag(TIF_SVE, vcpu_has_sve(vcpu));
+
+		vcpu->arch.flags |= KVM_ARM64_FP_ENABLED;
+	} else {
+		vcpu->arch.flags |= KVM_ARM64_FP_HOST;
+	}
 
 	if (test_thread_flag(TIF_SVE))
 		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_IN_USE;
 
 	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
 		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_ENABLED;
+
+	local_irq_restore(flags);
 }
 
 
@@ -124,7 +138,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 	local_irq_save(flags);
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
-		fpsimd_save_and_flush_cpu_state();
+		fpsimd_thread_switch(current);
 
 		if (guest_has_sve)
 			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_s(SYS_ZCR_EL12);
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
