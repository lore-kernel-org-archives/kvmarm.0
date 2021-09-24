Return-Path: <SRS0=7V6P=OO=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2B63C43217
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ACB6F61555
	for <kvmarm@archiver.kernel.org>; Fri, 24 Sep 2021 12:54:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org ACB6F61555
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 632354B1FD;
	Fri, 24 Sep 2021 08:54:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TT7LrQn9GZJz; Fri, 24 Sep 2021 08:54:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0B9544B1B5;
	Fri, 24 Sep 2021 08:54:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A4534A7FD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id G0GVKNXwtU0E for <kvmarm@lists.cs.columbia.edu>;
 Fri, 24 Sep 2021 08:54:41 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3B9FB40191
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 08:54:40 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 r18-20020a056214069200b0037a291a6081so30130477qvz.18
 for <kvmarm@lists.cs.columbia.edu>; Fri, 24 Sep 2021 05:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=i7uodwfDnDtJuiTS9rXdXYViFWYsjMsbxF8IoeW8/W4=;
 b=qF3Vw4AceYdu1L0PZ66LcU5WQ4Q0vt8paDyr76neaIiU7PKYTbrZLZonVtIrIyRczb
 DU5SbrytlGhkBB1E+t5EqBtBbVrDhV4CyzU/EB8ANPxuMebR0qF/QjT8hLecRLcdlZgw
 A3lfSu8T99yQYr4bozntQ9WdVOsOPmEACfCRd0tfsFq6yXyqa5QjOxnbUZyAZx0Kx8ue
 PsVAFTS6kdE4EA4R/FbZWcnFQc+koZXhZ9EpQ3BLPMpc8IFYdDeyrGBI8gHWC3W4GLB6
 P23Dlf8ES+p3OPOy3TiDL1x4KbFHLYAOvn+XGfAEiu3h6LwChGcFLWCRFl12kwRSLS+3
 ctBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=i7uodwfDnDtJuiTS9rXdXYViFWYsjMsbxF8IoeW8/W4=;
 b=oYAhvZopPvUj6DSH8EgKIas+r3JVWT58cjfIn3z7TCxaQdYTqjF+T5+Fxv4MH2VXor
 O1dJ55O4SbEXqBVtL62absVmQJKH3KPovhHDLeZXegUKJ4WuXhumb0h2zJM/NrDkn3wv
 dhZ983Ef7mpyP4hoZx2G+rQNs47VGiEBKMmtPiCV85l8oaw8rMYiU2R2PWiWSbuO/y3k
 c42NMY2/wPDpoIY82yXm4aDz4TH1+NRNlZNcVHjfbQNQqgOVI2iw8JNJ2GogVxc3Ll/O
 kLZHgjPLI4p35ZF4GF3hYiOKBWvGQbW71Pof/tUUwjvstXF5xOqCpCqvPRKqD3MOH2D4
 7K4Q==
X-Gm-Message-State: AOAM530ehTiWO7iAJ7nnf4IcBusi8XBVZSFHLb4ohD6J+SG7jn/ZsPX+
 vqrWZdUTU+bzhGIkmOqv0KOo2opAVhMcTK5V+UBd8EmUAET3HzAy2GQVEzcQcD5hSFIPw5IFoCh
 Q4p0SVBfQzb8k5Zt+YO6WkZ9MliiuZwsAiGQd85JcIGcnINadg/qeyz7tzljB0+PMcig=
X-Google-Smtp-Source: ABdhPJyK06uYrGrDSvLnw7I0yxv76y3TWXx+xyK98z+cTJ0e/eyHwuj1vePAtlEsCveTt5zBbE9Rk8ddCA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:ad4:47a3:: with SMTP id
 a3mr9927375qvz.31.1632488079831; 
 Fri, 24 Sep 2021 05:54:39 -0700 (PDT)
Date: Fri, 24 Sep 2021 13:53:47 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-19-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 18/30] KVM: arm64: reduce scope of __guest_exit to only
 depend on kvm_cpu_context
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

__guest_exit only needs kvm_cpu_context (via the offset
VCPU_CONTEXT). Only pass that to it, and fix it to ensure that it
only refers to kvm_cpu_context rather than vcpu.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/entry.S     | 7 ++-----
 arch/arm64/kvm/hyp/hyp-entry.S | 8 ++++----
 2 files changed, 6 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/kvm/hyp/entry.S b/arch/arm64/kvm/hyp/entry.S
index e831d3dfd50d..996bdc9555da 100644
--- a/arch/arm64/kvm/hyp/entry.S
+++ b/arch/arm64/kvm/hyp/entry.S
@@ -99,15 +99,12 @@ SYM_INNER_LABEL(__guest_exit_panic, SYM_L_GLOBAL)
 	adr_l	x1, hyp_panic
 	str	x1, [x0, #CPU_XREG_OFFSET(30)]
 
-	get_vcpu_ptr	x1, x0
+	get_vcpu_ctxt_ptr	x1, x0
 
 SYM_INNER_LABEL(__guest_exit, SYM_L_GLOBAL)
 	// x0: return code
-	// x1: vcpu
+	// x1: ctxt
 	// x2-x29,lr: vcpu regs
-	// vcpu x0-x1 on the stack
-
-	add	x1, x1, #VCPU_CONTEXT
 
 	ALTERNATIVE(nop, SET_PSTATE_PAN(1), ARM64_HAS_PAN, CONFIG_ARM64_PAN)
 
diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 5f49df4ffdd8..704b3388c86a 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -71,17 +71,17 @@ wa_epilogue:
 	sb
 
 el1_trap:
-	get_vcpu_ptr	x1, x0
+	get_vcpu_ctxt_ptr	x1, x0
 	mov	x0, #ARM_EXCEPTION_TRAP
 	b	__guest_exit
 
 el1_irq:
-	get_vcpu_ptr	x1, x0
+	get_vcpu_ctxt_ptr	x1, x0
 	mov	x0, #ARM_EXCEPTION_IRQ
 	b	__guest_exit
 
 el1_error:
-	get_vcpu_ptr	x1, x0
+	get_vcpu_ctxt_ptr	x1, x0
 	mov	x0, #ARM_EXCEPTION_EL1_SERROR
 	b	__guest_exit
 
@@ -100,7 +100,7 @@ el2_sync:
 
 1:
 	/* Let's attempt a recovery from the illegal exception return */
-	get_vcpu_ptr	x1, x0
+	get_vcpu_ctxt_ptr	x1, x0
 	mov	x0, #ARM_EXCEPTION_IL
 	b	__guest_exit
 
-- 
2.33.0.685.g46640cef36-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
