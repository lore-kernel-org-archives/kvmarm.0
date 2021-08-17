Return-Path: <SRS0=6VsV=NI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 270B8C4338F
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:12:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CEAE460F5E
	for <kvmarm@archiver.kernel.org>; Tue, 17 Aug 2021 08:12:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CEAE460F5E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F0404B156;
	Tue, 17 Aug 2021 04:12:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G+DPOxfbqdr0; Tue, 17 Aug 2021 04:11:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A1FE94B16B;
	Tue, 17 Aug 2021 04:11:52 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BC71D4B140
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:11:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dQ4eCzuOFj48 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 17 Aug 2021 04:11:50 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 51DCB4B142
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 04:11:49 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 iw1-20020a0562140f2100b0035f58985cecso6976987qvb.10
 for <kvmarm@lists.cs.columbia.edu>; Tue, 17 Aug 2021 01:11:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=E4ZEliK5yLKhnD5Jnl33UnkhxCyZJ0hbNeYBdr/5+OY=;
 b=Quct2CliuN/sMre8lsiBcxG4yGDZhWo3ZdDjrRlCyZbre2BtMGMNpxYbH9YsNE0MSs
 xVPSFODA1bObcoRsYUJzyzyYiBcFU2luG85iMLa58O0+trTAq9G7Q+jQSpqKHcTt0G52
 6yuEyZgJKawRiyo2q1a5inrY21QnVB5k/JWfb5LAfut/leqt6Ughp5CD+K2l4U/MSWNX
 ymEX6fUDDwlqhEXNEUA86EFi0HEVOOzP9ZeYPBe8UQvkZdeGzyZ0p7yxLRAnTe3BFnpB
 dcaHv70+Mk1AJGhMaWBtPNLimjjO95LklXfwwMK8aApIhdnqng9C/nJHkGTT/KAJWXsZ
 jqpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=E4ZEliK5yLKhnD5Jnl33UnkhxCyZJ0hbNeYBdr/5+OY=;
 b=NOKctVji1IGbfXkaMXV6itQOvdbX6EUqV9zsv4Wj0EBkwxuPIBZ9y+scypPDm1ZAB9
 P+GWw0Tzo1WGaBi5EGRC48riYYf2V6ub5RynZWHj/PdqRUjszovIZjak4bq8Rvz0gkmP
 cjjo6U9a7JtCA4ESuYOLuU58ZHC6pUAz7PFJL08N/LcTUCHOB+zUOGjgp1muMjoyMg6J
 G0Y0cB/bUH33r65DmKdg8yzCnIVIi4MbtQUYpz9ML+vXKbwjQrzhIys6StHQsrb3xou0
 uHTzwTPGazVZFHzX/9QBpCjFT54MBdO5hVqh0Fib/ql0YfxP8+bLDo2ltrxG3rPuqgP3
 J2rg==
X-Gm-Message-State: AOAM533w21MO2w8KlpWY00gubzWzcjbVBkFh+jhHNyH2DG58jLkg0KbX
 +5E2TunUUky8vEoihNhxaVzCnzfLulOKqcEEelJvkYVvgrAhmtqEUVLHq2L6F5hFuhDEslZg+x0
 j8oyQyJyNoMFmUkcfDEKyUJDMvzWijuYFDomVLBs1VlceILt6SH79Zi9lm0AV/C+JtFg=
X-Google-Smtp-Source: ABdhPJy+q1MijWDNX7bL8A0h7neE7BVvZN2T+6N6zScu9FcCRhZQLeXmI7Y02Wop/JEuauveXsqfRllO7w==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:10c4:: with SMTP id
 r4mr2133977qvs.58.1629187908879; Tue, 17 Aug 2021 01:11:48 -0700 (PDT)
Date: Tue, 17 Aug 2021 09:11:25 +0100
In-Reply-To: <20210817081134.2918285-1-tabba@google.com>
Message-Id: <20210817081134.2918285-7-tabba@google.com>
Mime-Version: 1.0
References: <20210817081134.2918285-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v4 06/15] KVM: arm64: Restore mdcr_el2 from vcpu
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
 arch/arm64/kvm/hyp/nvhe/switch.c        | 13 +++++--------
 arch/arm64/kvm/hyp/vhe/switch.c         | 14 +++++---------
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c      |  2 +-
 6 files changed, 21 insertions(+), 21 deletions(-)

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
index f7af9688c1f7..2ea764a48958 100644
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
 
@@ -92,13 +90,12 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 		isb();
 	}
 
-	__deactivate_traps_common();
+	vcpu->arch.mdcr_el2_host &= MDCR_EL2_HPMN_MASK |
+				    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
+				    MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT;
 
-	mdcr_el2 &= MDCR_EL2_HPMN_MASK;
-	mdcr_el2 |= MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT;
-	mdcr_el2 |= MDCR_EL2_E2TB_MASK << MDCR_EL2_E2TB_SHIFT;
+	__deactivate_traps_common(vcpu);
 
-	write_sysreg(mdcr_el2, mdcr_el2);
 	write_sysreg(this_cpu_ptr(&kvm_init_params)->hcr_el2, hcr_el2);
 
 	cptr = CPTR_EL2_DEFAULT;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index b3229924d243..ec158fa41ae6 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -91,17 +91,13 @@ void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
 	__activate_traps_common(vcpu);
 }
 
-void deactivate_traps_vhe_put(void)
+void deactivate_traps_vhe_put(struct kvm_vcpu *vcpu)
 {
-	u64 mdcr_el2 = read_sysreg(mdcr_el2);
+	vcpu->arch.mdcr_el2_host &= MDCR_EL2_HPMN_MASK |
+				    MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT |
+				    MDCR_EL2_TPMS;
 
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
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
