Return-Path: <SRS0=9WlX=NH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9820AC4338F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:12:52 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 38FF96138F
	for <kvmarm@archiver.kernel.org>; Mon, 16 Aug 2021 00:12:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 38FF96138F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF9A14B0EC;
	Sun, 15 Aug 2021 20:12:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bKDtYnAyOnpH; Sun, 15 Aug 2021 20:12:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D34FB4B118;
	Sun, 15 Aug 2021 20:12:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 909064B0FF
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:12:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Oifp8VES5Rg9 for <kvmarm@lists.cs.columbia.edu>;
 Sun, 15 Aug 2021 20:12:35 -0400 (EDT)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D0A5F4B109
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 20:12:27 -0400 (EDT)
Received: by mail-qv1-f73.google.com with SMTP id
 l16-20020a0cc2100000b029035a3d6757b3so10757363qvh.14
 for <kvmarm@lists.cs.columbia.edu>; Sun, 15 Aug 2021 17:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=IzZpuEsgwV0AULnFn0VDAkOlC3SkP0x8cjQf8LHfPG8=;
 b=Z6KJIWUoRZm4gv1SxUSGM1H6/YnrARuwOEm5BdLr/NIw2XcC76fYJA/umAxe1eKVRy
 roA/HxRxx9DEMfnoH0VYW9Dq7WKsVqbZsfl1UXp5C/+7nEOY8tPdtSNnp4an2z/fhNP/
 /hSJ1Yvy7h7zW7dQBoz3hSL9+ruqcYlSuE/QwBGN4ED8WT9ee1x0wY5zXsU7K4Wilody
 ju6OQD7sBLOx6tKwDvk16FD6QRCIOyUPis0cP8sn5jutVX57b7PmSIos9ixZ9RnXzIZA
 G4LmfbIOdX/Jzm+JanelRb5nJzx8rt9LZLR+Ox5DuoF1uojBAVpWBWsEZP0xlBp886dY
 UhXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=IzZpuEsgwV0AULnFn0VDAkOlC3SkP0x8cjQf8LHfPG8=;
 b=F4tm7jERHb0UQUGZT+nEkVU+Rw7iN2XgK+6zXgqIVuju/M3m1IO3Ky01UQy02bx7Ty
 pu3kx1d4GLI6gQPtt5t2tnGttWVMqal6UlFljfq4NxhCIxjm44OhGh7ZS4tGRkwXqh19
 MDBfEhnQ64lM0yTgV8dA2Aa7H38omq/ZTr2pp0SV/NfK83DCLWbFtbzoUCmqNYLNqFzm
 acs5+SsKNs9CuBP51c5CgX7zurzxd+BhHukCGDq9hF8TQJzC8ZoxzWYyfuSoIeX5Zlpi
 gFVQKiA76na1l1HnWOUisJsLefDiVSYSDqMtJlLYHSqoUHoNz7Jpf9FJmWHWNOJPW1bb
 6MZA==
X-Gm-Message-State: AOAM531gKtwvqWsaSOfF8Loj5syxV2YpMqSYabkbVavdF1TMIe2k7q05
 5trE+A0cIjfYv16Zxzln7yYKExLVHcs=
X-Google-Smtp-Source: ABdhPJyq1E1IRX+IFCz2UT4Lu7i7B0G3RsUFCvBiLDi44WCVFhrddU+e2oHM6bxVIVMm1WK477KidWJeex0=
X-Received: from oupton.c.googlers.com ([fda3:e722:ac3:cc00:2b:ff92:c0a8:404])
 (user=oupton job=sendgmr) by 2002:a05:6214:10c4:: with SMTP id
 r4mr13783414qvs.58.1629072747465; Sun, 15 Aug 2021 17:12:27 -0700 (PDT)
Date: Mon, 16 Aug 2021 00:12:16 +0000
In-Reply-To: <20210816001217.3063400-1-oupton@google.com>
Message-Id: <20210816001217.3063400-7-oupton@google.com>
Mime-Version: 1.0
References: <20210816001217.3063400-1-oupton@google.com>
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH v7 6/7] KVM: arm64: Configure timer traps in vcpu_load() for
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
Reviewed-by: Andrew Jones <drjones@redhat.com>
---
 arch/arm64/kvm/arch_timer.c  | 10 +++++++---
 arch/arm64/kvm/arm.c         |  4 +---
 include/kvm/arm_arch_timer.h |  2 --
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 46380c389683..1689c2e20cd3 100644
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
index 0de4b41c3706..f882a7fb3a1b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1559,9 +1559,7 @@ static void cpu_hyp_reinit(void)
 
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
2.33.0.rc1.237.g0d66db33f3-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
