Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F394C07E9B
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:04:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D0DBF61482
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 16:04:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0DBF61482
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 830824A4C0;
	Mon, 19 Jul 2021 12:04:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Dfg02CfNHFfS; Mon, 19 Jul 2021 12:04:03 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 340304B0CB;
	Mon, 19 Jul 2021 12:04:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 88B194B0BF
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:04:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Q8KTHBFPYm7T for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 12:04:01 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6808A4B081
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 12:04:01 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 i12-20020adffc0c0000b0290140ab4d8389so9003830wrr.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 09:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=uVNKfeEG4b+Qdmha097ZuRQElAnejEBo7Qe/StGCOZM=;
 b=DB0fOgJNXJ5E70tS+AsuZ/8rTH252TGNNrznMxapYyCfvmyUQVkYIodcjacdGvbshM
 FYS/fHQ/w+3hODQfs8HalbOa4v1gDDGNxZqldxaSHFpGr1H953Dfuv8uRQK35Y2JEb3T
 nKKig4yBHxW3bpl9bP100AW17eSDryRG4ouQrZu7Q28jXu5SVKxEYzYXfJGkYKbeNlzd
 ozfMugLUuEb8ft6Yx9hXwgX0k/qs+yfPjWFhYEcifYEVWW3eHjSUW70RiV/+mx35igxv
 Tvj/IYXKqi/bNEzZZRxE+D6TGsuWbcAx1SrKpm4e2JSRT329y78NahiFAERQkeAC61mQ
 kZAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=uVNKfeEG4b+Qdmha097ZuRQElAnejEBo7Qe/StGCOZM=;
 b=hWtTb+uqkrHqeefj9vfGxqzNYBZWkZdnztM3gTc1CzePlz0IFnPG5LudCkEAS+LVOY
 UTRtiY3ad+4bwQ7wDko67s1RegFGOcXgroWAdEqBgVrwwPUfuvkQ8nY3N3ke1+TNeLHA
 /jY8eyeo567bsOrYszHuh5Dp4/JqdiKahkHB8IlrMJ2WQEWWody6JDzMBicZ2A0ZVuFZ
 wRKTcwewKa8BPJJvQJtGavGw+avJawAka4yIv/dASn0b48depoUmV/CTHY9r9746H4Xv
 Qc9b9zKwhcmX+xqFes+fVBasyOoYHiQAEkUvEhmZIgQbob9EbL2trOpln4A92dVj8UYB
 goGg==
X-Gm-Message-State: AOAM532eTgX99qnHqoEBvqq1OLRLVTrQH0T4txY/LDbM4HgyRv5KZ0AX
 rTeccHDLRC9G8rai4BXR6R+my1RUTmhYDmZpZAAKrNBlhYLBOOVBLZzCZZ8x8pur+LkvcsGBuxl
 LI7Y6cmsj1znLSWk/lPG/ftgVL60f3SN9Cm9CQoDgegKswJ8Vo6otupJU19hQNjm8+0k=
X-Google-Smtp-Source: ABdhPJzXIU8ksmYOLwiK37hqDGGMkNRvl2jPeHRvgKtrSj3QhSyZyJU4Cywip2U8/yLAHnQqc9Ep1pEz1g==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:1c7:: with SMTP id
 190mr26767213wmb.170.1626710640541; 
 Mon, 19 Jul 2021 09:04:00 -0700 (PDT)
Date: Mon, 19 Jul 2021 17:03:37 +0100
In-Reply-To: <20210719160346.609914-1-tabba@google.com>
Message-Id: <20210719160346.609914-7-tabba@google.com>
Mime-Version: 1.0
References: <20210719160346.609914-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH v3 06/15] KVM: arm64: Restore mdcr_el2 from vcpu
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 pbonzini@redhat.com, will@kernel.org, linux-arm-kernel@lists.infradead.org
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

On deactivating traps, restore the value of mdcr_el2 from the
newly created and preserved host value vcpu context, rather than
directly reading the hardware register.

Up until and including this patch the two values are the same,
i.e., the hardware register and the vcpu one. A future patch will
be changing the value of mdcr_el2 on activating traps, and this
ensures that its value will be restored.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_host.h       |  5 ++++-
 arch/arm64/include/asm/kvm_hyp.h        |  2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  6 +++++-
 arch/arm64/kvm/hyp/nvhe/switch.c        | 11 ++---------
 arch/arm64/kvm/hyp/vhe/switch.c         | 12 ++----------
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c      |  2 +-
 6 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 4d2d974c1522..76462c6a91ee 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -287,10 +287,13 @@ struct kvm_vcpu_arch {
 	/* Stage 2 paging state used by the hardware on next switch */
 	struct kvm_s2_mmu *hw_mmu;
 
-	/* HYP configuration */
+	/* Values of trap registers for the guest. */
 	u64 hcr_el2;
 	u64 mdcr_el2;
 
+	/* Values of trap registers for the host before guest entry. */
+	u64 mdcr_el2_host;
+
 	/* Exception Information */
 	struct kvm_vcpu_fault_info fault;
 
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 9d60b3006efc..657d0c94cf82 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -95,7 +95,7 @@ void __sve_restore_state(void *sve_pffr, u32 *fpsr);
 
 #ifndef __KVM_NVHE_HYPERVISOR__
 void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
-void deactivate_traps_vhe_put(void);
+void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu);
 #endif
 
 u64 __guest_enter(struct kvm_vcpu *vcpu);
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e4a2f295a394..a0e78a6027be 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -92,11 +92,15 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 		write_sysreg(0, pmselr_el0);
 		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
 	}
+
+	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 }
 
-static inline void __deactivate_traps_common(void)
+static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 {
+	write_sysreg(vcpu->arch.mdcr_el2_host, mdcr_el2);
+
 	write_sysreg(0, hstr_el2);
 	if (kvm_arm_support_pmu_v3())
 		write_sysreg(0, pmuserenr_el0);
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index f7af9688c1f7..1778593a08a9 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -69,12 +69,10 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 static void __deactivate_traps(struct kvm_vcpu *vcpu)
 {
 	extern char __kvm_hyp_host_vector[];
-	u64 mdcr_el2, cptr;
+	u64 cptr;
 
 	___deactivate_traps(vcpu);
 
-	mdcr_el2 = read_sysreg(mdcr_el2);
-
 	if (cpus_have_final_cap(ARM64_WORKAROUND_SPECULATIVE_AT)) {
 		u64 val;
 
@@ -92,13 +90,8 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 		isb();
 	}
 
-	__deactivate_traps_common();
-
-	mdcr_el2 &= MDCR_EL2_HPMN_MASK;
-	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
-	mdcr_el2 |= MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT;
+	__deactivate_traps_common(vcpu);
 
-	write_sysreg(mdcr_el2, mdcr_el2);
 	write_sysreg(this_cpu_ptr(&kvm_init_params)->hcr_el2, hcr_el2);
 
 	cptr = CPTR_EL2_DEFAULT;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index b3229924d243..0d0c9550fb08 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -91,17 +91,9 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
 	__activate_traps_common(vcpu);
 }
 
-void deactivate_traps_vhe_put(void)
+void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
 {
-	u64 mdcr_el2 = read_sysreg(mdcr_el2);
-
-	mdcr_el2 &= MDCR_EL2_HPMN_MASK |
-		    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
-		    MDCR_EL2_TPMS;
-
-	write_sysreg(mdcr_el2, mdcr_el2);
-
-	__deactivate_traps_common();
+	__deactivate_traps_common(vcpu);
 }
 
 /* Switch to the guest for VHE systems running in EL2 */
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 2a0b8c88d74f..007a12dd4351 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -101,7 +101,7 @@ void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *host_ctxt;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
-	deactivate_traps_vhe_put();
+	deactivate_traps_vhe_put(vcpu);
 
 	__sysreg_save_el1_state(guest_ctxt);
 	__sysreg_save_user_state(guest_ctxt);
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
