Return-Path: <SRS0=rr56=M3=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07142C4338F
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:59:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id AEFB160F6F
	for <kvmarm@archiver.kernel.org>; Wed,  4 Aug 2021 08:59:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org AEFB160F6F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 641D64B09A;
	Wed,  4 Aug 2021 04:59:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id XCtia5Omtwo5; Wed,  4 Aug 2021 04:59:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5FC654B08A;
	Wed,  4 Aug 2021 04:59:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 14FA14A483
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id mDwKb4Ule-Mg for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Aug 2021 04:58:58 -0400 (EDT)
Received: from mail-qt1-f202.google.com (mail-qt1-f202.google.com
 [209.85.160.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 027884A7FD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Aug 2021 04:58:55 -0400 (EDT)
Received: by mail-qt1-f202.google.com with SMTP id
 e16-20020ac867100000b0290257b7db4a28so747730qtp.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Aug 2021 01:58:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=xEsi9T4OqglNe742KkivPaDxPwp3ZoFaFAtWROXbBVo=;
 b=ChSZQBwkJB66ulFJ3pUxF49mjFQq4MBi3vZvx3rv+9LE+Wi7bTs1eRJQzexlr+JRSY
 n8GGWqtHE6Gj0UzXp8u7OVcee5UjmtXgNekWCLLa5kYlfHloNwdxCdc+Ct0rKHZ9H5MS
 Lkfrmt/805DmNFA9xjBhD6iryqm8HFC8yEIAfGsd6QT62XFkkQdbUnqv+KeQRQQcaoKc
 ooADx9GQgfZmou14MKEHG/t4rhEESUtzhs6w4fmnvAlQZTc1x6TOFShLv0Ltd4CyQ4mp
 W5tQu0tDthrEE4M9igHoxYjuLR+gA4eHJ/5/Iob0qnQunOUx/bJFNJrWm1phkPrntUr2
 kgbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=xEsi9T4OqglNe742KkivPaDxPwp3ZoFaFAtWROXbBVo=;
 b=pX5xgtEt3SmOz3FxsJkGXE24nPLOYhOdqNjRhIoErdkT+tWLnuT7oYv9aauLaQTUaH
 di7TVos7ywQwjMr931gOp5su4/3JL6Q61+0+LpXlDzaWOdnbQ99uDFLqj/N+YqLe5YHv
 qgDyn/GAB8WU0UpBDSmy/xvLZ48RsynkSqphO2PIXN05BTcoeTMS+2veRiCaM1gNKq3i
 RdkDgd1OzJO2FtKfSWW2kq2dDZBQzkUfZUj/L8km3nnoBKMGrKFz/ZLVp1vFt+Ge5/h1
 z/4XxdWPaaswt13qNmDrrogUc1qqxWo6MLKZ2XEOwlukTs5pBqbWV4M3JhFZAMAQKFK+
 u5Fg==
X-Gm-Message-State: AOAM530jkpyEQieMlceWCmxPWVTwoXhOSlBGikRVphi9yUMRq+klfJGy
 a+QiF6yUh0cS5RAtwvaFEQW5Dn2PtTw=
X-Google-Smtp-Source: ABdhPJw4uOQBnarbZ8Pq5S9gvLmcNwTMIjaIMpvh+qw/OSoRZsXJkePXii8fJVoN7ZA8FRpp8uLdyyoJ81g=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:104b:: with SMTP id
 l11mr25726502qvr.40.1628067534598; Wed, 04 Aug 2021 01:58:54 -0700 (PDT)
Date: Wed,  4 Aug 2021 08:58:16 +0000
In-Reply-To: <20210804085819.846610-1-oupton@google.com>
Message-Id: <20210804085819.846610-19-oupton@google.com>
Mime-Version: 1.0
References: <20210804085819.846610-1-oupton@google.com>
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH v6 18/21] KVM: arm64: Configure timer traps in vcpu_load() for
 VHE
From: Oliver Upton <oupton@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Raghavendra Rao Anata <rananta@google.com>,
 Peter Shier <pshier@google.com>, Sean Christopherson <seanjc@google.com>,
 David Matlack <dmatlack@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-arm-kernel@lists.infradead.org, Jim Mattson <jmattson@google.com>
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
---
 arch/arm64/kvm/arch_timer.c  | 10 +++++++---
 arch/arm64/kvm/arm.c         |  4 +---
 include/kvm/arm_arch_timer.h |  2 --
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index f15058612994..9ead94aa867d 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -51,6 +51,7 @@ static void kvm_arm_timer_write(struct kvm_vcpu *vcpu,
 static u64 kvm_arm_timer_read(struct kvm_vcpu *vcpu,
 			      struct arch_timer_context *timer,
 			      enum kvm_arch_timer_regs treg);
+static void kvm_timer_enable_traps_vhe(void);
 
 u32 timer_get_ctl(struct arch_timer_context *ctxt)
 {
@@ -668,6 +669,9 @@ void kvm_timer_vcpu_load(struct kvm_vcpu *vcpu)
 
 	if (map.emul_ptimer)
 		timer_emulate(map.emul_ptimer);
+
+	if (has_vhe())
+		kvm_timer_enable_traps_vhe();
 }
 
 bool kvm_timer_should_notify_user(struct kvm_vcpu *vcpu)
@@ -1383,12 +1387,12 @@ int kvm_timer_enable(struct kvm_vcpu *vcpu)
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
index e9a2b8f27792..47ea1e1ba80b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1558,9 +1558,7 @@ static void cpu_hyp_reinit(void)
 
 	cpu_hyp_reset();
 
-	if (is_kernel_in_hyp_mode())
-		kvm_timer_init_vhe();
-	else
+	if (!is_kernel_in_hyp_mode())
 		cpu_init_hyp_mode();
 
 	cpu_set_hyp_vector();
diff --git a/include/kvm/arm_arch_timer.h b/include/kvm/arm_arch_timer.h
index 615f9314f6a5..254653b42da0 100644
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
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
