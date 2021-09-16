Return-Path: <SRS0=sbHD=OG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3648C433FE
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:15:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 817E2611CA
	for <kvmarm@archiver.kernel.org>; Thu, 16 Sep 2021 18:15:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 817E2611CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 33C6C4B09C;
	Thu, 16 Sep 2021 14:15:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EutAezN3eu7F; Thu, 16 Sep 2021 14:15:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 27DCD4B16F;
	Thu, 16 Sep 2021 14:15:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B5EA04B161
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:15:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id EXWs4X1g1MLs for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Sep 2021 14:15:33 -0400 (EDT)
Received: from mail-il1-f201.google.com (mail-il1-f201.google.com
 [209.85.166.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7BCCF4B13B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 14:15:31 -0400 (EDT)
Received: by mail-il1-f201.google.com with SMTP id
 j14-20020a92200e000000b0023ab41fcec9so14922037ile.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Sep 2021 11:15:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=BVbFEb6A6+ovQK9ZEoIX753R5coZv2LaotY72yo0M9w=;
 b=Duaxw6Wdi+yt/FlgC80aDKbBVPAXpMQF8KpI6OQKf2suNWjt8X9L6kgb8q0LvcmszK
 u8MOMNwfq8+JhPlY5+TlV755nb8F/R6K0kkrOZNPQVJJGYQEpwyrC6QfwfsLVidVJcYH
 DIrhMhUnd0i2HV8uj2zqmBanyssDy57he+G5BSHT77y+HCxH6ESkSxo8HH4UybBf6bdf
 8rbY16XYfxL+06vdlWIBQu3txdt9JVh+uuExVJfG+y0OvyBphM1K1dA9n/+M3JQv4mat
 2ShobZszJNFipL0q8XFcwa/pym5HY0EzsrDsa71fSNB+ohJ5YAB+rvxBKxDIWgyyVj7+
 n7ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=BVbFEb6A6+ovQK9ZEoIX753R5coZv2LaotY72yo0M9w=;
 b=OQPBPVuBHYan5Wb2yAfbnzzkWXEfytAzkZN2OflpyeFxnqicjrgsyjC+XqTfu8QypT
 ON3OVM/S647zuuZ71aMrRYP4vbbfvtEnI5wziIzPkqL0d4j/0t4K6Tm4MPaA5DBhK709
 PAkwFls8hhYIJX36yZ82AmYc/HhHMLzzXmn5ayRXTGI30OXHdcsgUmHiPeBR+/S3jwxF
 XL/ufnRSiYraca2s3XNvFnyiVIDMuDcSxBwABni2GLpCGS7YHOvJRZAABMPBZ7c59V/6
 936ZXu7zHw3WVpuGW5pPGhV0gbm6J7lsiiDUnCr4YAppbftlVL21NNck1oa7+i9Q+ELN
 Sr2g==
X-Gm-Message-State: AOAM531iw98CqoKnCoeACryx40h/DlHL57R+vV+UTJuL93qLZcUm6mkO
 EHfYqRYKdtTF1NSArygwB6Nb77xvJtU=
X-Google-Smtp-Source: ABdhPJyNg0qALAw81ZPQoxY23q7Z3u2HDpDm1FTp2Br+FAAFtSr5K2bD/9X8TXlFZ8y1kQxeb0TfJQ01Wvk=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a6b:e917:: with SMTP id
 u23mr5504852iof.19.1631816131056; 
 Thu, 16 Sep 2021 11:15:31 -0700 (PDT)
Date: Thu, 16 Sep 2021 18:15:09 +0000
In-Reply-To: <20210916181510.963449-1-oupton@google.com>
Message-Id: <20210916181510.963449-8-oupton@google.com>
Mime-Version: 1.0
References: <20210916181510.963449-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v8 7/8] KVM: arm64: Configure timer traps in vcpu_load() for
 VHE
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Peter Shier <pshier@google.com>,
 Sean Christopherson <seanjc@google.com>, David Matlack <dmatlack@google.com>,
 Paolo Bonzini <pbonzini@redhat.com>, linux-arm-kernel@lists.infradead.org,
 Jim Mattson <jmattson@google.com>
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

In preparation for emulated physical counter-timer offsetting, configure
traps on every vcpu_load() for VHE systems. As before, these trap
settings do not affect host userspace, and are only active for the
guest.

Suggested-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Oliver Upton <oupton@google.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/arch_timer.c  | 10 +++++++---
 arch/arm64/kvm/arm.c         |  4 +---
 include/kvm/arm_arch_timer.h |  2 --
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 4bba149d140c..68fb5ddb9e7a 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -51,6 +51,7 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
 static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 			      struct arch_timer_context *timer,
 			      enum kvm_arch_timer_regs treg);
+static void kvm_timer_enable_traps_vhe(void);
 
 u32 timer_get_ctl(struct arch_timer_context *ctxt)
 {
@@ -663,6 +664,9 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 
 	if (map.emul_ptimer)
 		timer_emulate(map.emul_ptimer);
+
+	if (has_vhe())
+		kvm_timer_enable_traps_vhe();
 }
 
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
@@ -1355,12 +1359,12 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
 }
 
 /*
- * On VHE system, we only need to configure the EL2 timer trap register once,
- * not for every world switch.
+ * On VHE system, we only need to configure the EL2 timer trap register on
+ * vcpu_load(), but not every world switch into the guest.
  * The host kernel runs at EL2 with HCR_EL2.TGE == 1,
  * and this makes those bits have no effect for the host kernel execution.
  */
-void kvm_timer_init_vhe(void)
+static void kvm_timer_enable_traps_vhe(void)
 {
 	/* When HCR_EL2.E2H ==1, EL1PCEN and EL1PCTEN are shifted by 10 */
 	u32 cnthctl_shift = 10;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index a562b36f28e2..086c9672c8ac 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1590,9 +1590,7 @@ static void cpu_hyp_reinit(void)
 
 	cpu_hyp_reset();
 
-	if (is_kernel_in_hyp_mode())
-		kvm_timer_init_vhe();
-	else
+	if (!is_kernel_in_hyp_mode())
 		cpu_init_hyp_mode();
 
 	cpu_set_hyp_vector();
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index aa666373f603..d06294aa356e 100644
--- a/include/kvm/arm_arch_timer.h
+++ b/include/kvm/arm_arch_timer.h
@@ -87,8 +87,6 @@ u64 kvm_phys_timer_read(void);
 void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu);
 void kvm_timer_vcpu_put(struct kvm_vcpu *vcpu);
 
-void kvm_timer_init_vhe(void);
-
 bool kvm_arch_timer_get_input_level(int vintid);
 
 #define vcpu_timer(v)	(&(v)->arch.timer_cpu)
-- 
2.33.0.309.g3052b89438-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
