Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A75BC432BE
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 10:16:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2C72360FC4
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 10:16:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 2C72360FC4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D456F4B128;
	Fri, 27 Aug 2021 06:16:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HVCJ1ogQ05B0; Fri, 27 Aug 2021 06:16:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 065464B14F;
	Fri, 27 Aug 2021 06:16:32 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0F4E4B10C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 06:16:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cV2+jGbOFehc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Aug 2021 06:16:29 -0400 (EDT)
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com
 [209.85.128.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6AA994B114
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 06:16:25 -0400 (EDT)
Received: by mail-wm1-f74.google.com with SMTP id
 z186-20020a1c7ec30000b02902e6a27a9962so5684337wmc.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 03:16:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=SsrZd6Jo8kMJWJSsMSYjDPdCpx5Fc9MexzuaW/MoFqQ=;
 b=BZjdr5KZHMgOcU8VqWpDgH7zY3wkoT523uqqlrhERo+iSn3xJNI7QA99yOuh3YPeJp
 FyQtyRATL2t1bNZHbVQkHh7wLDV5ccKYZOvazhTUhoy3xlvN3VaVDht8M5E6THT4hM3X
 E5jVaQSFz2QDvtZSibkFM6iDf1WrkKx0RhVXWkaoEEWTEEdaYbZm28tYkUwmaw42TDaN
 bw9MFKL/VF1tMSMZ+oqhfAOEDeTl7WkJUiq1aIoSt1dKRy8L4q/3q4UEDahyjFGKcvfM
 Q1R/qu1ncxIqZRBrq7wurO71aHVhbrQcZpEX4W3A/UaczTEfOaLhqqIscKCgI8sO1Fi+
 4Y7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=SsrZd6Jo8kMJWJSsMSYjDPdCpx5Fc9MexzuaW/MoFqQ=;
 b=YCD/+HO91ELK6CYMGA8wGBTuEiJiH9jompWBdQNgKN1IhSo4Mxf2P9H70da68KmU5s
 wlophObk55no2FxOKwbdhlIrI+iECbIKo/U+QETS18frgGm2AqOo+SS+cSx1azCt1cWX
 fFqwpDFlPcTrx4m3LjnD2EQMCa9cYvhd2fnEF0sDwBsnXAFZPT9Cq/82Ci6gYHElX9tb
 S2hFHG+c4UCmYH4xmz3IP9PZguuQeE09OFmvV9I8Yv30IfhB3ceWDHcE+fPjWTn8ZoIG
 Usu+bAsLPuIrk8zQZvw1BS5By4wQzm1x722Upmh9qGqi4p76Ald8bvHSN8Ofw4m6MV4C
 7x2Q==
X-Gm-Message-State: AOAM532bD0Sm9/cAcibd+VN9aYCtsGBd4P7s0oKZJGeZNGxcqqJbV3Il
 0w1LEumWZD27PMOQl2Ds7YmiLosbejN+Mm8WDrQEugE03t43EEDJAzbRlIZuJYdUICCwQ3RlptZ
 RYuup6DDnloHfIsicmFH1o4u/CiQCFzIZhba4/I0vS71B1zFaDL9a9a9nXLMHCcTBfs0=
X-Google-Smtp-Source: ABdhPJztEz1988L0qtSVWiS7gD05LAwEOXiOtb7SpQw0H3ZxaU+gyIMNUefXyCTKQspH2GaRYyM9Slru3w==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a1c:98d2:: with SMTP id
 a201mr8090262wme.89.1630059384567; 
 Fri, 27 Aug 2021 03:16:24 -0700 (PDT)
Date: Fri, 27 Aug 2021 11:16:07 +0100
In-Reply-To: <20210827101609.2808181-1-tabba@google.com>
Message-Id: <20210827101609.2808181-7-tabba@google.com>
Mime-Version: 1.0
References: <20210827101609.2808181-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH v5 6/8] KVM: arm64: Move sanitized copies of CPU features
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

Move the sanitized copies of the CPU feature registers to the
recently created sys_regs.c. This consolidates all copies in a
more relevant file.

No functional change intended.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 6 ------
 arch/arm64/kvm/hyp/nvhe/sys_regs.c    | 2 ++
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 2a07d63b8498..f6d96e60b323 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -25,12 +25,6 @@ struct host_kvm host_kvm;
 
 static struct hyp_pool host_s2_pool;
 
-/*
- * Copies of the host's CPU features registers holding sanitized values.
- */
-u64 id_aa64mmfr0_el1_sys_val;
-u64 id_aa64mmfr1_el1_sys_val;
-
 const u8 pkvm_hyp_id = 1;
 
 static void *host_s2_zalloc_pages_exact(size_t size)
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index a7e836537154..4a9868ec1f0f 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -23,6 +23,8 @@ u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
 u64 id_aa64isar0_el1_sys_val;
 u64 id_aa64isar1_el1_sys_val;
+u64 id_aa64mmfr0_el1_sys_val;
+u64 id_aa64mmfr1_el1_sys_val;
 u64 id_aa64mmfr2_el1_sys_val;
 
 static inline void inject_undef(struct kvm_vcpu *vcpu)
-- 
2.33.0.259.gc128427fd7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
