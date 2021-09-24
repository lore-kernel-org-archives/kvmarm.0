Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B343C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id F246A61423
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org F246A61423
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AAC804B17C;
	Fri, 24 Sep 2021 08:54:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id X9rTQnLpEbHI; Fri, 24 Sep 2021 08:54:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 90DB04B191;
	Fri, 24 Sep 2021 08:54:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DA7A74B1F1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id iUyvoPr03Pyo for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:54:48 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B46CE4B1E2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:48 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 s13-20020a5d69cd000000b00159d49442cbso7985233wrw.13
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:54:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=8jEuEzlbcfPCVXhyDainIX5VC+9wUmsaXxH+UUkLWws=;
 b=aCPwNQiwMH+K/jPh8d1XnhlEyPYKLFzJsCHQMTxy9s76o9j/JzRfStpJOLN3cyALso
 71rB9qEsFuW8yLwe3l7ZVNrQHiU4+FZctlLrDGu2EzVLM8uH1Jn6lSMCSPydgx25l1qz
 ZrhgopWhzr0lIfWQEsKBnB8GIwhByYUOd+Fe1L9voSa0eiIszncBKzGRrIX484+G2qy9
 OiCZsLo27TmIn/vHORUiQbNBsOI1I5YdimAckjJQPa5+AZsKiLiwn3N9iCDNw/yoHoiZ
 mWntjHdWNY3zW4wj7uEK3gz6ifIk/kUymefHxkNkIA1EmTjAgmzS222TFyT0yetEQ4aZ
 l3QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=8jEuEzlbcfPCVXhyDainIX5VC+9wUmsaXxH+UUkLWws=;
 b=tCiJPZWHixm5cnVo//HsSPDoscqLVkFG2zHNzt07woY4hpKXMbaxvmrbi8q0gUIz2Z
 iiXB2ok9gTcYcIktnBTLiOPgjZ9I+BbPwCbz596gDhs3hANPqEGh2/qRDbgX1YDS+jOB
 XzciLiK32iGSxeJ7XQ6cheyzxc3Kzt8bWvc7AJj6ajXH0zPjcaqxVxPPl6FVm1TPevJt
 ILYqO3/wwm+yYhvqqYDuh8yrZGSesYYicQQ0T8MCPG/V3+hPht93SlLg9yd3lVFGUVLt
 Lk2zSYx3BtKvuVQUE5t7cXvO1Gv72PvSPS6zYBm1RExH0BiicLxd6KEBXh7zZ+/yv5t5
 xqFg==
X-Gm-Message-State: AOAM531eYt8jwm48FyIAaNFTG3nULPjiMfjp1OJFXSal+7rXy9D3zOH4
 DBmSTVQpCTDeZhdO69R8s2V7wYrWf08QXhAzIkVFCZSjmZ0/km0HZAtHcr+GfNx4t7wo2Zhc5Ki
 g0Br99krX+laJ3PnnAfMVlJAOsr4i05w7/jyaAq5gg0NYBMYiQIvQM5of2nPOCy2rQ+I=
X-Google-Smtp-Source: ABdhPJxUJbh/AE6W9VRAVaudBBE60oECmmozdjammP+VVHJRusaXJiHlbC7xhr44BgjTe/fYyj9xbkoZcQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a7b:c048:: with SMTP id
 u8mr1874492wmc.113.1632488087907; 
 Fri, 24 Sep 2021 05:54:47 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:51 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-23-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 22/30] KVM: arm64: reduce scope of __guest_enter to
 depend only on kvm_cpu_ctxt
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kernel-team@android.com, kvm@vger.kernel.org, maz@kernel.org,
 will@kernel.org, linux-arm-kernel@lists.infradead.org
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

guest_enter doesn't need the vcpu, only the guest's kvm_cpu_ctxt.
Reduce its scope to that.

With this commit, the only state in struct vcpu that the
hypervisor needs to save locally in future patches is guest
context (kvm_cpu_context) and the hypervisor state
(vcpu_hyp_state).

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h |  2 +-
 arch/arm64/kvm/hyp/entry.S       | 10 ++++------
 arch/arm64/kvm/hyp/nvhe/switch.c |  5 ++++-
 arch/arm64/kvm/hyp/vhe/switch.c  |  5 ++++-
 4 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index b379c2b96f33..c5206e958136 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -100,7 +100,7 @@ void activate_traps_vhe_load(struct vcpu_hyp_state *vcpu_hyps);
 void deactivate_traps_vhe_put(void);
 #endif
 
-u64 __guest_enter(struct kvm_vcpu *vcpu);
+u64 __guest_enter(struct kvm_cpu_context *guest_ctxt);
 
 bool kvm_host_psci_handler(struct kvm_cpu_context *host_ctxt);
 
diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index 8e7033aa5770..f553f184e402 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -18,12 +18,12 @@
 	.text
 
 /*
- * u64 __guest_enter(struct kvm_vcpu *vcpu);
+ * u64 __guest_enter(struct kvm_cpu_context *guest_ctxt);
  */
 SYM_FUNC_START(__guest_enter)
-	// x0: vcpu
+	// x0: guest context (input parameter)
 	// x1-x17: clobbered by macros
-	// x29: guest context
+	// x29: guest context (maintained for call duration)
 
 	adr_this_cpu x1, kvm_hyp_ctxt, x2
 
@@ -47,9 +47,7 @@ alternative_else_nop_endif
 	ret
 
 1:
-	set_loaded_vcpu x0, x1, x2
-
-	add	x29, x0, #VCPU_CONTEXT
+	mov	x29, x0
 
 	// Macro ptrauth_switch_to_guest format:
 	// 	ptrauth_switch_to_guest(guest cxt, tmp1, tmp2, tmp3)
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 483df8fe052e..d9a69e66158c 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -228,8 +228,11 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__debug_switch_to_guest(vcpu);
 
 	do {
+		struct kvm_cpu_context *hyp_ctxt = this_cpu_ptr(&kvm_hyp_ctxt);
+		set_hyp_running_vcpu(hyp_ctxt, vcpu);
+
 		/* Jump in the fire! */
-		exit_code = __guest_enter(vcpu);
+		exit_code = __guest_enter(guest_ctxt);
 
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, vgic, &exit_code));
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 64de9f0d7636..5039910a7c80 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -142,8 +142,11 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 	__debug_switch_to_guest(vcpu);
 
 	do {
+		struct kvm_cpu_context *hyp_ctxt = this_cpu_ptr(&kvm_hyp_ctxt);
+		set_hyp_running_vcpu(hyp_ctxt, vcpu);
+
 		/* Jump in the fire! */
-		exit_code = __guest_enter(vcpu);
+		exit_code = __guest_enter(guest_ctxt);
 
 		/* And we're baaack! */
 	} while (fixup_guest_exit(vcpu, vgic, &exit_code));
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
