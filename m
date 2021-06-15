Return-Path: <SRS0=xhzu=LJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE936C48BE5
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 919916147F
	for <kvmarm@archiver.kernel.org>; Tue, 15 Jun 2021 13:40:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 919916147F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B7784B0E5;
	Tue, 15 Jun 2021 09:40:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KQDJcHfZprom; Tue, 15 Jun 2021 09:40:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F256E4B0FF;
	Tue, 15 Jun 2021 09:40:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BDAEB4B0CD
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:40:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X4tvPzQX-opW for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Jun 2021 09:40:18 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7CB074B0EB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 09:40:17 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 n4-20020a5d42040000b0290119fef97609so8609900wrq.18
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Jun 2021 06:40:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=1Wmriyk1OkyHf916HajtQUN47VqCEGbBdy7CNNzscrg=;
 b=VtUZSKOkS6UceI4ijJW5thWf/ti2OPA7C+U6i15zx8x/Z+StMWl3IPpd2r2fOJIY1S
 niVVeQhWHr5sV679EKMmrYl9Pj/L8RVD4e5a6h3h/zKVovgAsJ2Rw9WueQOx6FYvGj+/
 g3G96uIWJdUsLQo6teDqIFa5DUhleMOdTclhJNEiLj2BmimTMemJiKDmxsjuUr7omDjZ
 0j4p0EzSXU2HEEqDezF0cauDDf8uFtRY47FODIJrKB953j2Y8xExq2nSxZeq1BZWETzE
 nLetUYm5DjlNGRQq9BPckAwcVdbXSBj9radl0jWTIXO4IdyOcznDOit/XczTLNTJJ5uF
 P2iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=1Wmriyk1OkyHf916HajtQUN47VqCEGbBdy7CNNzscrg=;
 b=babsKLKstfulLZSi6iDyyFP5oudSY9sYYfHq0VyRFtpzH/1l/egGClqZ23D0thXtJ6
 g/BqzXAT4IUgy/GL8yI/JoXCGp/XRAlNrI2xA1lRFLxSfclOJZIHOfEGnUznloSzx0ww
 tQscx5PDAA8VE1uDIeGxFzA6soeLfae3fVqj9TOOLrYNgZ4OWncLCBQV7gHBsB8TCLmX
 bfou9pKeWe0e41UXmKUYTxxWFiGlT1og4YM6CRmOV07SoFJXozxlp9WuTqEHMZ1HvMR4
 UxTgMHsWJ8Y8JyKeiIxGGASUhzMXTDJOMGa42adWKtQiQ3A6WvhzktNqYIJ477AmmDmJ
 Y+Fg==
X-Gm-Message-State: AOAM533wWc2ZOOjp+wD9dVfKZuSKfmn8eg00PSa3VISF/HwOjxdqu72k
 5CoQhjwCQcHU4mQQvVZHuWS/5Xf7cKNA/edgjx5c5TsdR4Z4wpSBqp7vHD2ruy3ssepSZaQAU/Q
 MXwJpQJ81a7/+KXLMRsDO6Yb5mGTmq772jEhdX0o+LKdUJHmPVBhKIw1USYBhI9AJ4RE=
X-Google-Smtp-Source: ABdhPJyL7cf8gf/wcPCRTQSqMyiGgh+Xc29p0vNyyZJEys+nrM2vy/ugPT03TxgbqQVLGdCJlmJiCH9gsQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a7b:c24a:: with SMTP id
 b10mr11398wmj.1.1623764416097; 
 Tue, 15 Jun 2021 06:40:16 -0700 (PDT)
Date: Tue, 15 Jun 2021 14:39:48 +0100
In-Reply-To: <20210615133950.693489-1-tabba@google.com>
Message-Id: <20210615133950.693489-12-tabba@google.com>
Mime-Version: 1.0
References: <20210615133950.693489-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.272.g935e593368-goog
Subject: [PATCH v2 11/13] KVM: arm64: Trap access to pVM restricted features
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

Trap accesses to restricted features for VMs running in protected
mode.

Access to feature registers are emulated, and only supported
features are exposed to protected VMs.

Accesses to restricted registers as well as restricted
instructions are trapped, and an undefined exception is injected
into the protected guest.

Only affects the functionality of protected VMs. Otherwise,
should not affect non-protected VMs when KVM is running in
protected mode.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h |   3 +
 arch/arm64/kvm/hyp/nvhe/switch.c        | 116 +++++++++++++++++++++---
 2 files changed, 105 insertions(+), 14 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index f5d3d1da0aec..d9f087ed6e02 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -33,6 +33,9 @@
 extern struct exception_table_entry __start___kvm_ex_table;
 extern struct exception_table_entry __stop___kvm_ex_table;
 
+int kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu);
+int kvm_handle_pvm_restricted(struct kvm_vcpu *vcpu);
+
 /* Check whether the FP regs were dirtied while in the host-side run loop: */
 static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
 {
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 967a3ad74fbd..8505201e1cfb 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -34,12 +34,74 @@ DEFINE_PER_CPU(struct kvm_host_data, kvm_host_data);
 DEFINE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
+/*
+ * Set EL2 configuration registers to trap restricted register accesses and
+ * instructions for protected VMs.
+ *
+ * Should be called right before vcpu entry to restrict its impact only to the
+ * protected guest.
+ */
+static void __activate_traps_pvm(struct kvm_vcpu *vcpu)
+{
+	u64 hcr;
+	u64 mdcr;
+	u64 cptr;
+
+	if (!kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)))
+		return;
+
+	hcr = read_sysreg(hcr_el2);
+	mdcr = read_sysreg(mdcr_el2);
+	cptr = read_sysreg(cptr_el2);
+
+	hcr |= HCR_TID3 |			/* Feature Registers */
+	       HCR_TLOR |			/* LOR */
+	       HCR_RW |	HCR_TID0 |		/* AArch64 EL1 only */
+	       HCR_TERR |			/* RAS */
+	       HCR_TID5 |			/* Memory Tagging */
+	       HCR_TACR | HCR_TIDCP | HCR_TID1; /* Implementation defined */
+
+	hcr &= ~(HCR_DCT | HCR_ATA |	/* Memory Tagging */
+		 HCR_FIEN |		/* RAS */
+		 HCR_AMVOFFEN);		/* Disable AMU register virtualization */
+
+
+	/* Debug and Trace */
+	mdcr |= MDCR_EL2_TDRA | MDCR_EL2_TDA | MDCR_EL2_TDE |
+		MDCR_EL2_TDOSA | MDCR_EL2_TDCC | MDCR_EL2_TTRF |
+		MDCR_EL2_TPM | MDCR_EL2_TPMCR |
+		MDCR_EL2_TPMS; /* SPE */
+
+	mdcr &= ~(MDCR_EL2_HPME | MDCR_EL2_MTPME |		/* PMU */
+		  (MDCR_EL2_E2PB_MASK << MDCR_EL2_E2PB_SHIFT));	/* SPE */
+
+	cptr |= CPTR_EL2_TTA |	/* Trace */
+		CPTR_EL2_TAM |	/* AMU */
+		CPTR_EL2_TZ;	/* SVE */
+
+	/*
+	 * Clear res0 bits and set res1 bits to trap potential new features.
+	 * It's not guaranteed, but new features are typically added with the
+	 * trapping value being the inverse of the reserved one.
+	 */
+	hcr &= ~HCR_RES0;
+	mdcr &= ~MDCR_EL2_RES0;
+	cptr &= ~CPTR_NVHE_EL2_RES0;
+	cptr |= CPTR_NVHE_EL2_RES1;
+
+	/*  __deactivate_traps() restores these registers. */
+	write_sysreg(hcr, hcr_el2);
+	write_sysreg(mdcr, mdcr_el2);
+	write_sysreg(cptr, cptr_el2);
+}
+
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	u64 val;
 
 	___activate_traps(vcpu);
 	__activate_traps_common(vcpu);
+	__activate_traps_pvm(vcpu);
 
 	val = CPTR_EL2_DEFAULT;
 	val |= CPTR_EL2_TTA | CPTR_EL2_TAM;
@@ -165,30 +227,56 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 		write_sysreg(pmu->events_host, pmcntenset_el0);
 }
 
+/**
+ * Handle system register accesses for protected VMs.
+ *
+ * Return 1 if handled, or 0 if not.
+ */
+static int handle_pvm_sys64(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)))
+		return kvm_handle_pvm_sys64(vcpu);
+	else
+		return 0;
+}
+
+/**
+ * Handle restricted feature accesses for protected VMs.
+ *
+ * Return 1 if handled, or 0 if not.
+ */
+static int handle_pvm_restricted(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vm_is_protected(kern_hyp_va(vcpu->kvm)))
+		return kvm_handle_pvm_restricted(vcpu);
+	else
+		return 0;
+}
+
 typedef int (*exit_handle_fn)(struct kvm_vcpu *);
 
 static exit_handle_fn hyp_exit_handlers[] = {
-	[0 ... ESR_ELx_EC_MAX]		= NULL,
+	[0 ... ESR_ELx_EC_MAX]		= handle_pvm_restricted,
 	[ESR_ELx_EC_WFx]		= NULL,
-	[ESR_ELx_EC_CP15_32]		= NULL,
-	[ESR_ELx_EC_CP15_64]		= NULL,
-	[ESR_ELx_EC_CP14_MR]		= NULL,
-	[ESR_ELx_EC_CP14_LS]		= NULL,
-	[ESR_ELx_EC_CP14_64]		= NULL,
+	[ESR_ELx_EC_CP15_32]		= handle_pvm_restricted,
+	[ESR_ELx_EC_CP15_64]		= handle_pvm_restricted,
+	[ESR_ELx_EC_CP14_MR]		= handle_pvm_restricted,
+	[ESR_ELx_EC_CP14_LS]		= handle_pvm_restricted,
+	[ESR_ELx_EC_CP14_64]		= handle_pvm_restricted,
 	[ESR_ELx_EC_HVC32]		= NULL,
 	[ESR_ELx_EC_SMC32]		= NULL,
 	[ESR_ELx_EC_HVC64]		= NULL,
 	[ESR_ELx_EC_SMC64]		= NULL,
-	[ESR_ELx_EC_SYS64]		= NULL,
-	[ESR_ELx_EC_SVE]		= NULL,
+	[ESR_ELx_EC_SYS64]		= handle_pvm_sys64,
+	[ESR_ELx_EC_SVE]		= handle_pvm_restricted,
 	[ESR_ELx_EC_IABT_LOW]		= NULL,
 	[ESR_ELx_EC_DABT_LOW]		= NULL,
-	[ESR_ELx_EC_SOFTSTP_LOW]	= NULL,
-	[ESR_ELx_EC_WATCHPT_LOW]	= NULL,
-	[ESR_ELx_EC_BREAKPT_LOW]	= NULL,
-	[ESR_ELx_EC_BKPT32]		= NULL,
-	[ESR_ELx_EC_BRK64]		= NULL,
-	[ESR_ELx_EC_FP_ASIMD]		= NULL,
+	[ESR_ELx_EC_SOFTSTP_LOW]	= handle_pvm_restricted,
+	[ESR_ELx_EC_WATCHPT_LOW]	= handle_pvm_restricted,
+	[ESR_ELx_EC_BREAKPT_LOW]	= handle_pvm_restricted,
+	[ESR_ELx_EC_BKPT32]		= handle_pvm_restricted,
+	[ESR_ELx_EC_BRK64]		= handle_pvm_restricted,
+	[ESR_ELx_EC_FP_ASIMD]		= handle_pvm_restricted,
 	[ESR_ELx_EC_PAC]		= NULL,
 };
 
-- 
2.32.0.272.g935e593368-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
