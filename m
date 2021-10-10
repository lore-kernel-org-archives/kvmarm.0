Return-Path: <SRS0=9Ttc=O6=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268B8C433EF
	for <kvmarm@archiver.kernel.org>; Sun, 10 Oct 2021 14:56:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B66DA60F5B
	for <kvmarm@archiver.kernel.org>; Sun, 10 Oct 2021 14:56:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B66DA60F5B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6A29A4B091;
	Sun, 10 Oct 2021 10:56:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0AKj1zYEUaA0; Sun, 10 Oct 2021 10:56:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07DF44B0C5;
	Sun, 10 Oct 2021 10:56:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 23A1D4B0E6
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 10:56:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dU7syodV8mKv for <kvmarm@lists.cs.columbia.edu>;
 Sun, 10 Oct 2021 10:56:49 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D2F924B0C3
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 10:56:47 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 k2-20020adfc702000000b0016006b2da9bso11160431wrg.1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 10 Oct 2021 07:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=25eLjj7S096UhlQv84j+y5ZsIz1F9KN7hX8cPXIiaYA=;
 b=ffsMRCP9vJs7rknTgWabfjPMV08OT9mRSBP86r3Nfa8tm/IyT58sfpzda2NEQVhdTF
 r8wPA9ToE8b+TaBpLVZXrHcoHPLaDBq4j5j3B7QfsUbLvt9kPGWnwS5gU3YuLQEykWtS
 t4uM7W24nzW3/am8UfEG4mRSb70lrIZFTlzcGd05aCvyohQb6jc3qzdTb62hR5GdblHF
 hz8E8wHC+K20q7MDDR7z1tZYXWMmQPLB4n3UUoBwULWhxyPRFGNL1Vn9Qpqu89oMv12V
 o4M/8cAy+tb9FvvhaxlgdF6RBIYQ0VSniVx60zlLwxHPO4b6f23GRKj2s6B+7YIT7zk3
 Plyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=25eLjj7S096UhlQv84j+y5ZsIz1F9KN7hX8cPXIiaYA=;
 b=ZfghGYcCkNU2xAK9HFqCnNa8fTOS2p+lUs5ENQ4RtcoEaqcSArB3meWg4Or2EVpWtU
 j5C+ERRW2DMRMcmOKXoWHKbe77s8Acnyc2o/Nwp1mD7PGanRFCri93V2FWCmxgFw3HoD
 gk6CO04pwSxlqe4sOXKtQgMjqJddVjJtnqrnv6jfaEHz/8fNsjGuSDurrNic/Sqc2gYq
 00Yr5BJHSqrXdMGP7Ye+6Dp6TrlSuacAQw5gBLTappkkJO3NMVsYnPfPJsj5jXTYjlXl
 LPs5xagHGfGG5GRbOByW2Tp+Tvwfgy5EIXfG/dHsN2LTA1k7ALLStvgp5/EVyLlD7ub7
 l2DA==
X-Gm-Message-State: AOAM531NW5f7eW0kIPtlMph4gm60MD1jotNI+zQ0QBpEQndH7jMr+2JY
 WKYK99tMlqdS1RMtyhsUxHUGyV36ge8aUETk5lmZC2x0KYNrIk9GXgH/K9HoJO+uIRA7Jl2rA51
 bGloqx3Se4JrfK34LYYZbMcVzCsSgcJKClK/1ceY0bmjRTx++jpjj/6ZdcBqq43CQZRw=
X-Google-Smtp-Source: ABdhPJzI0uhdxK/iRI1Zi5E5n9hvogQCkcTFqBsFmKPxfwOCY5UebQ3rx53GN7HiYXKS8VbWpKtlYtouIA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:4484:: with SMTP id
 r126mr15596115wma.150.1633877807007; 
 Sun, 10 Oct 2021 07:56:47 -0700 (PDT)
Date: Sun, 10 Oct 2021 15:56:29 +0100
In-Reply-To: <20211010145636.1950948-1-tabba@google.com>
Message-Id: <20211010145636.1950948-5-tabba@google.com>
Mime-Version: 1.0
References: <20211010145636.1950948-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v8 04/11] KVM: arm64: Pass struct kvm to per-EC handlers
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

We need struct kvm to check for protected VMs to be able to pick
the right handlers for them in subsequent patches.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 4 ++--
 arch/arm64/kvm/hyp/nvhe/switch.c        | 2 +-
 arch/arm64/kvm/hyp/vhe/switch.c         | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 1e4177322be7..481399bf9b94 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -403,7 +403,7 @@ static bool kvm_hyp_handle_dabt_low(struct kvm_vcpu *vcpu, u64 *exit_code)
 
 typedef bool (*exit_handler_fn)(struct kvm_vcpu *, u64 *);
 
-static const exit_handler_fn *kvm_get_exit_handler_array(void);
+static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm);
 
 /*
  * Allow the hypervisor to handle the exit with an exit handler if it has one.
@@ -413,7 +413,7 @@ static const exit_handler_fn *kvm_get_exit_handler_array(void);
  */
 static inline bool kvm_hyp_handle_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	const exit_handler_fn *handlers = kvm_get_exit_handler_array();
+	const exit_handler_fn *handlers = kvm_get_exit_handler_array(kern_hyp_va(vcpu->kvm));
 	exit_handler_fn fn;
 
 	fn = handlers[kvm_vcpu_trap_get_class(vcpu)];
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 4f3992a1aabd..8c9a0464be00 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -169,7 +169,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
-static const exit_handler_fn *kvm_get_exit_handler_array(void)
+static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 {
 	return hyp_exit_handlers;
 }
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 9aedc8afc8b9..f6fb97accf65 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -107,7 +107,7 @@ static const exit_handler_fn hyp_exit_handlers[] = {
 	[ESR_ELx_EC_PAC]		= kvm_hyp_handle_ptrauth,
 };
 
-static const exit_handler_fn *kvm_get_exit_handler_array(void)
+static const exit_handler_fn *kvm_get_exit_handler_array(struct kvm *kvm)
 {
 	return hyp_exit_handlers;
 }
-- 
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
