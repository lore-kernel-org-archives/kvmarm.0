Return-Path: <SRS0=nzcv=65=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 412D0C433E0
	for <kvmarm@archiver.kernel.org>; Fri, 15 May 2020 15:26:04 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BBFDD20671
	for <kvmarm@archiver.kernel.org>; Fri, 15 May 2020 15:26:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="WLHC5KfE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BBFDD20671
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 322CA4B4FB;
	Fri, 15 May 2020 11:26:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UmjRPXZ6n7kZ; Fri, 15 May 2020 11:25:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4656D4B500;
	Fri, 15 May 2020 11:25:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 945F04B4F1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 11:25:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Z5NA-3OgCslt for <kvmarm@lists.cs.columbia.edu>;
 Fri, 15 May 2020 11:25:57 -0400 (EDT)
Received: from mail-wm1-f65.google.com (mail-wm1-f65.google.com
 [209.85.128.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 93D6C4B4ED
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 11:25:57 -0400 (EDT)
Received: by mail-wm1-f65.google.com with SMTP id k12so2722389wmj.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 15 May 2020 08:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=4YHxui3Yo0vMHsmaXOJkEoFjwBV06P7bv7E8zziz5hQ=;
 b=WLHC5KfExF6hPKo7XxaA64czaJ7BpoHLU2zJICyp3N6zf6g0Vz7Ph3aIbdNXAiCrOP
 tCbYqwUu4plPR/NdJdRZvUjxei0rh8/YA/1+lG34HUVqWq+9tW7M1/9WoNIlK1ChRmRt
 FtiWhlL+mdGntWnLltUD93FSVO6Q5VQCVMEaissAi0MSH3OWJmd8fovGarXXhoHPA7Cc
 h/zjCz6NPCujmxrfEKJ5IUQzqUhdXa6zLo7R2i4rDhTiUFozm0g/1c4+tZkBvy31sEvf
 unYFk2EIKZ4XRkziKU6DzIwHGm2BA/B5Pw6A4MI3p+wf8Vwq3765fAuEnv3dimZiyAx7
 F03A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
 :content-transfer-encoding;
 bh=4YHxui3Yo0vMHsmaXOJkEoFjwBV06P7bv7E8zziz5hQ=;
 b=GifPDhjtLqH1JujQqOA/Mj5nHWfDFpf4FSlcpCVDI41tA5F+sL+ImUvjuIbW3SvkEl
 eBmtJnfDZUC6Nj7uHBxdQzHHlDy9YOJChA7tTr6NwvKcAUc6XyC93teqTDHp09+Ok1h5
 grfmklGC+oZK19jBPoZ5wX5hj18iCdn0WW59AQZ97ThI72EmealsPNom04rgp8gIGGhP
 loxddMJR/s4Gh/mt3lwlCbZs8bRB0vY6RF3WajtCFJ2txjsQ5Qot6/ySHS2GKnWD03/v
 7nzqWLv+VFTBRhE4C+yjzycooMDgEZD2+vDqiluBCtLG1ta566IzHHF5s0er/M5UNuPx
 lQEg==
X-Gm-Message-State: AOAM533gUsx8pX3xEQUc5CHwBvkvvGj7pMA276cIXF7bPmKfewG9k7Fr
 m65uvgEWUyY0b1DL3H884gPD/A==
X-Google-Smtp-Source: ABdhPJw3mKWVBSJfaO5wBBJqm/u5qU4h/LdI+37noVfSRuxmHsjjAxJo3FbZwUFQLSDIbvqJipPA8A==
X-Received: by 2002:a1c:6042:: with SMTP id u63mr4545603wmb.65.1589556356308; 
 Fri, 15 May 2020 08:25:56 -0700 (PDT)
Received: from localhost ([2a01:4b00:8523:2d03:d11b:f847:8002:7411])
 by smtp.gmail.com with ESMTPSA id y185sm4005761wmy.11.2020.05.15.08.25.55
 (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
 Fri, 15 May 2020 08:25:55 -0700 (PDT)
From: David Brazdil <dbrazdil@google.com>
To: Marc Zyngier <maz@kernel.org>
Subject: [PATCH] arm64: kvm: Fix incorrect comment on kvm_get_hyp_vector()
Date: Fri, 15 May 2020 16:25:50 +0100
Message-Id: <20200515152550.83810-1-dbrazdil@google.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org
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

The comment used to say that kvm_get_hyp_vector is only called on VHE systems.
In fact, it is also called from the nVHE init function cpu_init_hyp_mode().
Fix the comment to stop confusing devs.

Signed-off-by: David Brazdil <dbrazdil@google.com>
---
 arch/arm64/include/asm/kvm_mmu.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_mmu.h b/arch/arm64/include/asm/kvm_mmu.h
index 30b0e8d6b895..796f6a2e794a 100644
--- a/arch/arm64/include/asm/kvm_mmu.h
+++ b/arch/arm64/include/asm/kvm_mmu.h
@@ -473,7 +473,7 @@ static inline int kvm_write_guest_lock(struct kvm *kvm, gpa_t gpa,
 extern void *__kvm_bp_vect_base;
 extern int __kvm_harden_el2_vector_slot;
 
-/*  This is only called on a VHE system */
+/*  This is called on both VHE and !VHE systems */
 static inline void *kvm_get_hyp_vector(void)
 {
 	struct bp_hardening_data *data = arm64_get_bp_hardening_data();
-- 
2.26.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
