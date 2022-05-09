Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E09EEC433F5
	for <kvmarm@archiver.kernel.org>; Mon,  9 May 2022 16:26:21 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 814814B303;
	Mon,  9 May 2022 12:26:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RVjpXR01uZAa; Mon,  9 May 2022 12:26:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3EF494B304;
	Mon,  9 May 2022 12:26:20 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C0544B318
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 12:26:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QDCejSGbJPs5 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 May 2022 12:26:18 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5832C4B302
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 May 2022 12:26:17 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id
 x79-20020a25ce52000000b006497f075e7dso12457201ybe.15
 for <kvmarm@lists.cs.columbia.edu>; Mon, 09 May 2022 09:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=xGoqp6X+CPpEHo725m8Wu+g1erF1chW9bMEShQucuQI=;
 b=N0Zb4Gxa4HC1uAASPa5PNvN6IZjx7J7GkqJJxcHMPKOV18yjIl3pcEmceZOJesdcnG
 QyYuP15OLQgQAzxZvOx9T/u4IcSod9jZabxpWQQRxegBDjAddti9A+I5FItlHEwguaJN
 TpTsFWnpbz8e2DrUL88byAshOTHwqCzr3yK86hOE/LVy9b/KYkpySe/p+6GKXer9+ZsT
 AJn8WeUun7zv6Aus63gh3Xr1mdIhrS9YxFDp64pMHUMFpR3ooGR2iVg+ijhT2AzXWlvC
 0smRDvmncy7dBiwIBRAlq8Ds4xGlgiZR/k0QeJkvUFeyICFF+QBvChLD1FP9jVkilG9n
 6zEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=xGoqp6X+CPpEHo725m8Wu+g1erF1chW9bMEShQucuQI=;
 b=glIDsSrL5x9+NOcKj1PaFXqGITjJugC9wUlS6rE/UE8Pt4fY/7iVKw5OSGRTBbrHGC
 6F02OD8MJ6sW7h/QlL2lL4U37q5JCO30zA3LHHGq03vCvsQKTox6JikbvY73uCo7d5Wi
 aH8RXVP2AiI9Itqj2dKbvBY72TpUd8tjp2MT4IDvUBl6f69ogKflKLAy76p12oEp8Ma1
 JX3O48NMujlKmK+ZvooQEY16J/mHogxkDBTTGrwdNFnD4EpNof5wgch3U8TXIIdHSZLZ
 0B9IeTSP4UeiriqN4RYadRxh9nAR7j8XUacb3sQoSpc/ZN3UrJGc/I7KtuKtwlFWpDLq
 Z+7w==
X-Gm-Message-State: AOAM530NuT+St6pDGiaL9v9VADFSy/Wf78YDp+jHA7JiPXZBKhChJR//
 uD06GR0ckgtMdegmfhktLHD+Y6cLMhuKL74OIFTg9JogT0VeUAHhFEAiq7ze3Z1VF2t1Xp5XHeD
 kS5m2+YU0wChSPD53TrDgesCv87FUdVaRfs/yBwPLYnUs3u8pgvSFqcEX72dxWjoQZupNXw==
X-Google-Smtp-Source: ABdhPJwbEmmNk02jHZlxW+mCJH3BMBXB3kvXc9tx+Zc+AF6gVkBuuuHex37mMcuOHpy47pgj2Z6U4qDyQ2M=
X-Received: from oupton3.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:21eb])
 (user=oupton job=sendgmr) by 2002:a25:3157:0:b0:649:b216:bb4e with SMTP id
 x84-20020a253157000000b00649b216bb4emr14278182ybx.387.1652113576747; Mon, 09
 May 2022 09:26:16 -0700 (PDT)
Date: Mon,  9 May 2022 16:25:59 +0000
In-Reply-To: <20220509162559.2387784-1-oupton@google.com>
Message-Id: <20220509162559.2387784-3-oupton@google.com>
Mime-Version: 1.0
References: <20220509162559.2387784-1-oupton@google.com>
X-Mailer: git-send-email 2.36.0.512.ge40c2bad7a-goog
Subject: [PATCH 2/2] KVM: arm64: pkvm: Don't mask already zeroed FEAT_SVE
From: Oliver Upton <oupton@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, maz@kernel.org, linux-kernel@vger.kernel.org,
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

FEAT_SVE is already masked by the fixed configuration for
ID_AA64PFR0_EL1; don't try and mask it at runtime.

No functional change intended.

Signed-off-by: Oliver Upton <oupton@google.com>
---
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 33f5181af330..3f5d7bd171c5 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -90,9 +90,6 @@ static u64 get_pvm_id_aa64pfr0(const struct kvm_vcpu *vcpu)
 	u64 set_mask = 0;
 	u64 allow_mask = PVM_ID_AA64PFR0_ALLOW;
 
-	if (!vcpu_has_sve(vcpu))
-		allow_mask &= ~ARM64_FEATURE_MASK(ID_AA64PFR0_SVE);
-
 	set_mask |= get_restricted_features_unsigned(id_aa64pfr0_el1_sys_val,
 		PVM_ID_AA64PFR0_RESTRICT_UNSIGNED);
 
-- 
2.36.0.512.ge40c2bad7a-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
