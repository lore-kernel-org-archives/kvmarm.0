Return-Path: <SRS0=e8ws=CY=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56093C2D0E0
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:46:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DAB6C20B1F
	for <kvmarm@archiver.kernel.org>; Tue, 15 Sep 2020 10:46:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="VjCyUk6Q"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DAB6C20B1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8C8994B36A;
	Tue, 15 Sep 2020 06:46:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UyB3+cS-TbUD; Tue, 15 Sep 2020 06:46:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6EDE04B328;
	Tue, 15 Sep 2020 06:46:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A8704B35C
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:46:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id X9WhkPJCT1lJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 15 Sep 2020 06:46:54 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D6544B321
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 06:46:54 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id a12so1069568wrg.13
 for <kvmarm@lists.cs.columbia.edu>; Tue, 15 Sep 2020 03:46:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=sender:date:in-reply-to:message-id:mime-version:references:subject
 :from:to:cc; bh=JcNUi9YaZBJYRLbfVfYdx1mX0s/yCoVPqvlb82ChyXg=;
 b=VjCyUk6QXf+fia/teqFtpl+z5BgMEODEGBoDZpVuBui2V0vrM8oQIIzTSii8myh/u/
 h+iY6kxHk+NW8aWq0a4+N4uu7Cg0A7isj8rceY5lU0+AQw31YtCsvE36amvnd/9QKHQG
 b95qjyNC+ifaoDcE4Jng147kXK7JAYwfcEaCyIQN6jvGSiZFfug5ebM+sY92IRW6LLV9
 i738zePk+dqhcwlFmVdY2c7JFHaTGama7HnHAKqPkWGT1aBtr+T2CA6VZMavZMUkoWbX
 aSTPNUKDjsfXcER8SmnbBKkXB8aWHg8QafyVkqbH/1tVyPprOj8xuivRENsS0jDkmGqu
 sFZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=JcNUi9YaZBJYRLbfVfYdx1mX0s/yCoVPqvlb82ChyXg=;
 b=Tz/p4K1cGPI9ACOaFUQabu+c/eiiK4pbPPBq94UQ3Ym5egtzaghx5+1aS5Xvml3YD4
 /SLIO5fCK52TykcI/n74TRmPhlEq2zgbvXA98Fj7f0KZk9s9eFa78k0bSW8Bk5etUiwO
 TUZ2E5PT8TVjUVbWlU9n5lqFggJwE9cea2fH33jejDhetkxPbp7mkhGGqmfT9V1mbzQX
 Gnug2XabCvFEic9J6+VYdeEtPwZPk+hiJxOQL5ZcRqYsOKT3nZjNBLJc4iXmUoXp6f5t
 S2thodH+6OPcqRkJoK//p3EmNZpZ+/Lblf0cJ5dx1IeMQlFisJ3LsrFmelpKb7+F+VCY
 rE5w==
X-Gm-Message-State: AOAM532+IbIpSkZyyjTCSTlPs8zmbofPGmkd+Uu3dJwF/CiareikJEP7
 +6r2/Hu7j4zOLQObR61dk9XmgZS++VfVP2CFsZwWxhC7lu+soWWVVJrk9dJQJpXX9kZ67DoQPGP
 teRjfVe/JaGbJS57+jblBAYxRk9BB+0YSDIKfXlWSEhUMkvYe1Ce/ay2IN/SaW7lO/1gPyw==
X-Google-Smtp-Source: ABdhPJwXVr9nTTWxIwUFEGEnSqkOULHGIzPz81W+RLjUyvcpL+7TbmiaelJ7qaLPXFDhdkBYi7tb1p0ef40=
X-Received: from ascull.lon.corp.google.com
 ([2a00:79e0:d:109:4a0f:cfff:fe4a:6363])
 (user=ascull job=sendgmr) by 2002:a05:600c:4142:: with SMTP id
 h2mr4017798wmm.128.1600166812873; Tue, 15 Sep 2020 03:46:52 -0700 (PDT)
Date: Tue, 15 Sep 2020 11:46:26 +0100
In-Reply-To: <20200915104643.2543892-1-ascull@google.com>
Message-Id: <20200915104643.2543892-3-ascull@google.com>
Mime-Version: 1.0
References: <20200915104643.2543892-1-ascull@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH v4 02/19] KVM: arm64: Remove hyp_panic arguments
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
 maz@kernel.org, Sudeep Holla <sudeep.holla@arm.com>, catalin.marinas@arm.com,
 will@kernel.org
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

hyp_panic is able to find all the context it needs from within itself so
remove the argument. The __hyp_panic wrapper becomes redundant so is
also removed.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h        |  2 +-
 arch/arm64/kvm/hyp/hyp-entry.S          |  7 +------
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 +---
 arch/arm64/kvm/hyp/nvhe/switch.c        |  8 ++++++--
 arch/arm64/kvm/hyp/vhe/switch.c         | 10 ++++++----
 5 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 46689e7db46c..3de99b323061 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -89,7 +89,7 @@ void deactivate_traps_vhe_put(void);
 
 u64 __guest_enter(struct kvm_vcpu *vcpu, struct kvm_cpu_context *host_ctxt);
 
-void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt);
+void __noreturn hyp_panic(void);
 #ifdef __KVM_NVHE_HYPERVISOR__
 void __noreturn __hyp_do_panic(unsigned long, ...);
 #endif
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 46b4dab933d0..9cb3fbca5d79 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -210,12 +210,7 @@ SYM_FUNC_START(__hyp_do_panic)
 SYM_FUNC_END(__hyp_do_panic)
 #endif
 
-SYM_CODE_START(__hyp_panic)
-	get_host_ctxt x0, x1
-	b	hyp_panic
-SYM_CODE_END(__hyp_panic)
-
-.macro invalid_vector	label, target = __hyp_panic
+.macro invalid_vector	label, target = hyp_panic
 	.align	2
 SYM_CODE_START(\label)
 	b \target
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 0864f88bc840..96ea3fdd0c20 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -510,13 +510,11 @@ static inline void __set_host_arch_workaround_state(struct kvm_vcpu *vcpu)
 static inline void __kvm_unexpected_el2_exception(void)
 {
 	unsigned long addr, fixup;
-	struct kvm_cpu_context *host_ctxt;
 	struct exception_table_entry *entry, *end;
 	unsigned long elr_el2 = read_sysreg(elr_el2);
 
 	entry = hyp_symbol_addr(__start___kvm_ex_table);
 	end = hyp_symbol_addr(__stop___kvm_ex_table);
-	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 
 	while (entry < end) {
 		addr = (unsigned long)&entry->insn + entry->insn;
@@ -531,7 +529,7 @@ static inline void __kvm_unexpected_el2_exception(void)
 		return;
 	}
 
-	hyp_panic(host_ctxt);
+	hyp_panic();
 }
 
 #endif /* __ARM64_KVM_HYP_SWITCH_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 3c9c065b3264..26d6fd4b6f4d 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -242,14 +242,18 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return exit_code;
 }
 
-void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
+void __noreturn hyp_panic(void)
 {
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg(par_el1);
-	struct kvm_vcpu *vcpu = host_ctxt->__hyp_running_vcpu;
+	struct kvm_cpu_context *host_ctxt;
+	struct kvm_vcpu *vcpu;
 	unsigned long str_va;
 
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
+	vcpu = host_ctxt->__hyp_running_vcpu;
+
 	if (read_sysreg(vttbr_el2)) {
 		__timer_disable_traps(vcpu);
 		__deactivate_traps(vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 6636522a8529..c1fd47557713 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -192,10 +192,12 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-static void __hyp_call_panic(u64 spsr, u64 elr, u64 par,
-			     struct kvm_cpu_context *host_ctxt)
+static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 {
+	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
+
+	host_ctxt = &__hyp_this_cpu_ptr(kvm_host_data)->host_ctxt;
 	vcpu = host_ctxt->__hyp_running_vcpu;
 
 	__deactivate_traps(vcpu);
@@ -208,13 +210,13 @@ static void __hyp_call_panic(u64 spsr, u64 elr, u64 par,
 }
 NOKPROBE_SYMBOL(__hyp_call_panic);
 
-void __noreturn hyp_panic(struct kvm_cpu_context *host_ctxt)
+void __noreturn hyp_panic(void)
 {
 	u64 spsr = read_sysreg_el2(SYS_SPSR);
 	u64 elr = read_sysreg_el2(SYS_ELR);
 	u64 par = read_sysreg(par_el1);
 
-	__hyp_call_panic(spsr, elr, par, host_ctxt);
+	__hyp_call_panic(spsr, elr, par);
 	unreachable();
 }
 
-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
