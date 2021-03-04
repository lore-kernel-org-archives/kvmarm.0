Return-Path: <SRS0=dAAB=IC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41909C433DB
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:35 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CC35164F36
	for <kvmarm@archiver.kernel.org>; Thu,  4 Mar 2021 11:55:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CC35164F36
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 705C94B265;
	Thu,  4 Mar 2021 06:55:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id o-aG2-0Ki3MT; Thu,  4 Mar 2021 06:55:33 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 17BBF4B63F;
	Thu,  4 Mar 2021 06:55:33 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5EFF84B1FD
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:31 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ImUZn63C9Ma4 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  4 Mar 2021 06:55:30 -0500 (EST)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 438F64B3B4
 for <kvmarm@lists.cs.columbia.edu>; Thu,  4 Mar 2021 06:55:29 -0500 (EST)
Received: by mail-wr1-f74.google.com with SMTP id g2so7417712wrx.20
 for <kvmarm@lists.cs.columbia.edu>; Thu, 04 Mar 2021 03:55:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=Ha6235LVGOpsrXJ6DIkpbeVmu+A6TXQUbK1vj86gkEw=;
 b=sjieROa9X26PPDaTjRsYn6P4wKf2isbHz4i5Fx/kMw0jz3dPpQUXWUZa74dJtFVcBq
 7DUvgHdDZQgBlrssCql7bwEiuKtKw1a8PfnFGv2F/6MeI7AqDzR6eDzaOxTDwEGrTlw1
 4xRiUCfK/Ll2PVH2qxrXZVCEmOxib3KyfqqrZTPohCov/8Bt/OyXPFXZWQqQIxtKeefS
 Lh4kw9lgO03hN4ysuVsGmY1lgeT8V+pBIS5ZxK2Ph+5Sebw0XYyP3g9/6l/Y/F24Yccn
 yccKQaSN/LegkYjBNy1a/FXnGmWDk9ozffPe6Rh+tglmL2ZUiei8UM1ztkAkPJiherF9
 6YQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Ha6235LVGOpsrXJ6DIkpbeVmu+A6TXQUbK1vj86gkEw=;
 b=RmmquJL8aMOBY+u3bIfilsNP0F01+J6yt+Z65hB62LjRzsbuu4eCrzRDooY87hrsg5
 29uPhee0Pdo64nB8WhpvKlTTs6HsVrL2QakdKQJ8JCvXbIRKEaZkdLV6SakSDakQ7laM
 EBdc97N8SzOI5bMjzlyrByUzkhTvsiK35Ez2pnf+x9YFFD+ACfCLe6VFfW06AU9mPJmN
 qwrI4TtPtr1uyWeYuLqilMGcZU64QbsHiYqjapWTeKn8rSGc0MpjMrCOIc7ZdvmLKOhZ
 uqL4E9N04qOloptGMtVtX8rDGH3xR5cUEQQehzO3U+sU0PGtqpXDeDMaumqwqLcE+VmF
 4rCg==
X-Gm-Message-State: AOAM530qHXlXpaCKltvuSOjHLuZ0gtfEagO5xLjvjuvCI6cwerrekEcj
 C6PFSXQMw7RF0d8MPKdKaP8bIkG9ulwAHbJtKQ0AoeS2q1lp60snZCjAu1AH6s1QtZaszZns0AH
 MeiFNdZVeaZ488kixTggaOArkz8XgmwEcFo7Ts2Z2XpBWw1UtidJmEOHeG8lQxceem6H4AQ==
X-Google-Smtp-Source: ABdhPJynlR4ymNdnraD3D3zWwyvGokSETwvH4cJ8yXP8ahzEMlWjKM2fzfwsOpV2piobOd7oGMJdHlScSLU=
X-Received: from ascull.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1510])
 (user=ascull job=sendgmr) by 2002:a1c:df46:: with SMTP id
 w67mr3590007wmg.176.1614858928419; 
 Thu, 04 Mar 2021 03:55:28 -0800 (PST)
Date: Thu,  4 Mar 2021 11:54:51 +0000
In-Reply-To: <20210304115454.3597879-1-ascull@google.com>
Message-Id: <20210304115454.3597879-9-ascull@google.com>
Mime-Version: 1.0
References: <20210304115454.3597879-1-ascull@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [PATCH 08/10] KVM: arm64: Pass the arch run struct explicitly
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

Rather than accessing struct kvm_vcpu_arch_run via the vcpu, pass it
explicitly as an argument where needed. This will allow a hyp-private
copy of the struct to be swapped in when running in protected mode.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 15 +++++++++------
 arch/arm64/kvm/hyp/nvhe/switch.c        |  8 ++++----
 arch/arm64/kvm/hyp/vhe/switch.c         |  2 +-
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 3f299c7d42cd..53120cccd2a5 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -178,7 +178,8 @@ static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
 }
 
 /* Check for an FPSIMD/SVE trap and handle as appropriate */
-static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
+static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu,
+				       struct kvm_vcpu_arch_run *run)
 {
 	bool vhe, sve_guest, sve_host;
 	u8 esr_ec;
@@ -227,7 +228,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 
 	isb();
 
-	if (vcpu->arch.run.flags & KVM_ARM64_RUN_FP_HOST) {
+	if (run->flags & KVM_ARM64_RUN_FP_HOST) {
 		/*
 		 * In the SVE case, VHE is assumed: it is enforced by
 		 * Kconfig and kvm_arch_init().
@@ -243,7 +244,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 			__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
 		}
 
-		vcpu->arch.run.flags &= ~KVM_ARM64_RUN_FP_HOST;
+		run->flags &= ~KVM_ARM64_RUN_FP_HOST;
 	}
 
 	if (sve_guest) {
@@ -261,7 +262,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.fpsimd_cpu = smp_processor_id();
 
-	vcpu->arch.run.flags |= KVM_ARM64_RUN_FP_ENABLED;
+	run->flags |= KVM_ARM64_RUN_FP_ENABLED;
 
 	return true;
 }
@@ -389,7 +390,9 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
  * the guest, false when we should restore the host state and return to the
  * main run loop.
  */
-static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
+static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu,
+				    struct kvm_vcpu_arch_run *run,
+				    u64 *exit_code)
 {
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
@@ -430,7 +433,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	 * undefined instruction exception to the guest.
 	 * Similarly for trapped SVE accesses.
 	 */
-	if (__hyp_handle_fpsimd(vcpu))
+	if (__hyp_handle_fpsimd(vcpu, run))
 		goto guest;
 
 	if (__hyp_handle_ptrauth(vcpu))
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index f0a32c993ac4..076c2200324f 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -32,7 +32,7 @@ DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
-static void __activate_traps(struct kvm_vcpu *vcpu)
+static void __activate_traps(struct kvm_vcpu *vcpu, struct kvm_vcpu_arch_run *run)
 {
 	u64 val;
 
@@ -41,7 +41,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 	val = CPTR_EL2_DEFAULT;
 	val |= CPTR_EL2_TTA | CPTR_EL2_TZ | CPTR_EL2_TAM;
-	if (!(vcpu->arch.run.flags & KVM_ARM64_RUN_FP_ENABLED)) {
+	if (!(run->flags & KVM_ARM64_RUN_FP_ENABLED)) {
 		val |= CPTR_EL2_TFP;
 		__activate_traps_fpsimd32(vcpu);
 	}
@@ -206,7 +206,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__sysreg_restore_state_nvhe(guest_ctxt);
 
 	__load_guest_stage2(kern_hyp_va(vcpu->arch.hw_mmu));
-	__activate_traps(vcpu);
+	__activate_traps(vcpu, &vcpu->arch.run);
 
 	__hyp_vgic_restore_state(vcpu);
 	__timer_enable_traps(vcpu);
@@ -218,7 +218,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 		exit_code = __guest_enter(vcpu);
 
 		/* And we're baaack! */
-	} while (fixup_guest_exit(vcpu, &exit_code));
+	} while (fixup_guest_exit(vcpu, &vcpu->arch.run, &exit_code));
 
 	__sysreg_save_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 5bb6a2cf574d..ff3ce150d636 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -143,7 +143,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 		exit_code = __guest_enter(vcpu);
 
 		/* And we're baaack! */
-	} while (fixup_guest_exit(vcpu, &exit_code));
+	} while (fixup_guest_exit(vcpu, &vcpu->arch.run, &exit_code));
 
 	sysreg_save_guest_state_vhe(guest_ctxt);
 
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
