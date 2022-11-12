Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A36BC43217
	for <kvmarm@archiver.kernel.org>; Sat, 12 Nov 2022 08:17:24 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D14B74B82E;
	Sat, 12 Nov 2022 03:17:23 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lFYuIkz86-1Z; Sat, 12 Nov 2022 03:17:22 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AB574B824;
	Sat, 12 Nov 2022 03:17:22 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D4F784B7EF
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 03:17:20 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4cdzQ4sWE2MI for <kvmarm@lists.cs.columbia.edu>;
 Sat, 12 Nov 2022 03:17:19 -0500 (EST)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D41884B7B6
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 03:17:19 -0500 (EST)
Received: by mail-yb1-f201.google.com with SMTP id
 4-20020a250104000000b006de5a38d75bso3278416ybb.20
 for <kvmarm@lists.cs.columbia.edu>; Sat, 12 Nov 2022 00:17:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:from:to:cc:subject:date:message-id:reply-to;
 bh=bR8iaUgvP1KhoHZDz60Ag9zfSgL9+5xkoUuLuzW9M/E=;
 b=pIfn545Xg4RILlmoV71GI5wUoqZTMmdLuKi3J1MKvNujIUDEvJocA2w/+4VdHLrydh
 sK0Kz45DrHxyinoIeLQ4cXcCDHNvB/fiegMkUkCZ/jootdi1olpyg74PID7iMbDKYQR3
 oTZOhZlJUcV6lDPT4LQuQKTAkUOdnm8NMJhFxby6atuXio/kFt9Ro18NJkwc66I1I2gD
 WtsbfVbkSfXyC7tjTyG3DVsO9TzFV+X60s4LMAxkSYCQPawuBtmOiZYDkpv12smEP4OZ
 34OKYJg7ZObKGYB0um41oXBgQvIAn4s1YHbR2atKJANaTgagyZ5lL6q2a92cdPP49H8g
 pC2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
 :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
 bh=bR8iaUgvP1KhoHZDz60Ag9zfSgL9+5xkoUuLuzW9M/E=;
 b=Pypb8jV5QuGjYOELFT2DO+qrwemOFvYkpN5ZzjZ39X+cHOjuGCgnqD84SrFn6bmq3A
 JLVbW6Yom1QKjrObXpgyFriFmdOgAs4Np75jgsomXRRlmMrFozbqz9+1Rf0eY+YXmRly
 3DUFEUmmybtT0aj/xKn4OXFTtwDp39i75fztAG8G25/OiDj/JOkksvxEiG4DyLOcMPy3
 J3LzgyqFbzVH9Qcq/alLs1JrsTAMbrDt6sWpc2Sx0vvjxVRD6XM2dF4XUQUIJ0yjX++B
 jG5uG+tOTDapEz/LadTLAhzlRcHsQCfDPJJcuGk8OpMo9J4iP1+Gd4KIO8EnKUr9yGEH
 RC7w==
X-Gm-Message-State: ACrzQf04UeHF9tN7TYCcq7qxEeXbN+OlMk8E1T1Kpvq8DiY2r+sU5a59
 E0XaCNvvvtluFoEIJpxt2FqSSGcezU5qvw==
X-Google-Smtp-Source: AMsMyM4ah6NGC8kmhMxLtTth8Jo+WhdvvMmY7TiDG/C+ZbL8Crz+PCFuUZuBbeleghI7+CU1WJykCKDc7+AiiA==
X-Received: from ricarkol4.c.googlers.com
 ([fda3:e722:ac3:cc00:20:ed76:c0a8:1248])
 (user=ricarkol job=sendgmr) by 2002:a81:6554:0:b0:349:8e3:a882 with SMTP id
 z81-20020a816554000000b0034908e3a882mr65030760ywb.388.1668241038874; Sat, 12
 Nov 2022 00:17:18 -0800 (PST)
Date: Sat, 12 Nov 2022 08:17:03 +0000
In-Reply-To: <20221112081714.2169495-1-ricarkol@google.com>
Mime-Version: 1.0
References: <20221112081714.2169495-1-ricarkol@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221112081714.2169495-2-ricarkol@google.com>
Subject: [RFC PATCH 01/12] KVM: arm64: Relax WARN check in stage2_make_pte()
From: Ricardo Koller <ricarkol@google.com>
To: pbonzini@redhat.com, maz@kernel.org, oupton@google.com, 
 dmatlack@google.com, qperret@google.com, catalin.marinas@arm.com, 
 andrew.jones@linux.dev, seanjc@google.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, eric.auger@redhat.com, gshan@redhat.com, 
 reijiw@google.com, rananta@google.com, bgardon@google.com
Cc: kvmarm@lists.linux.dev, ricarkol@gmail.com, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
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

stage2_make_pte() throws a warning when used in a non-shared walk, as PTEs
are not "locked" when walking non-shared. Add a check so it can be used
non-shared.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index c12462439e70..b16107bf917c 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -733,7 +733,8 @@ static void stage2_make_pte(const struct kvm_pgtable_visit_ctx *ctx, kvm_pte_t n
 {
 	struct kvm_pgtable_mm_ops *mm_ops = ctx->mm_ops;
 
-	WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
+	if (kvm_pgtable_walk_shared(ctx))
+		WARN_ON(!stage2_pte_is_locked(*ctx->ptep));
 
 	if (stage2_pte_is_counted(new))
 		mm_ops->get_page(ctx->ptep);
-- 
2.38.1.431.g37b22c650d-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
