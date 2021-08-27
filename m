Return-Path: <SRS0=jphx=NS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DB03C432BE
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 10:16:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0FC5C60F45
	for <kvmarm@archiver.kernel.org>; Fri, 27 Aug 2021 10:16:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 0FC5C60F45
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A94B94B11C;
	Fri, 27 Aug 2021 06:16:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Zp26pnrdeSgn; Fri, 27 Aug 2021 06:16:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BE6D44B129;
	Fri, 27 Aug 2021 06:16:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ABEEA4B126
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 06:16:30 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VJyDjqPt5Xmi for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Aug 2021 06:16:29 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2877D4B118
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 06:16:19 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id
 h1-20020a05600c350100b002e751bf6733so1584441wmq.8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Aug 2021 03:16:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=Ndy6VNY2Oh4Ysf845vj9tsZMixjR9xf1QOuntbi4ZaI=;
 b=WcIs2d0aQaKoHbdUo0nizodc0raiIVSlXaKetGAFfV+XmVSaJE+nHQ2SfGN4k2/W2k
 VsbJM8mRc5oD6ZxO/nC521ZYvX2bHcKDdzW8LESNXxmwNb2SGKpFegBdw3Iu9sR+xAY6
 N0R44zAnaiz3IdkiRCbmxX7S60aAlB8Q6ONoHSbxAs+WqDFkurR+Yy7aPUxD6xcbm+90
 hNcz5tI90qZpMmPHddT7TemzywJ4IeQQ4At+YUVDdRPMB4/lpZorFQsC/2g6Km9boLx1
 skWXlfxvpM9vI5p8belx+BHqXvqL+YXgihEUCJcu1ZpqzPQCgS+8lH5fOL2KGw2YkjJC
 ivYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=Ndy6VNY2Oh4Ysf845vj9tsZMixjR9xf1QOuntbi4ZaI=;
 b=eaiV2Gk2eNEdd+TySYw0VQ3oYFAQa11GZrOVIBoO38q4V0rmqkEZA+esoBgU5n9Waw
 uKQtCGqRHr0lEgPxYuw9k9FBzrKa82WnQt8scxQ2FYButyovy1i4ZEE9ecy9Y4XqTpD3
 sm2OGoCiMYA/zYGNC4mqIPk7iriLsnTEF9z5PULizpyUVBxW42rJki53063sRBHKIP6p
 SOPcaXw5PZ00M9OpoVA3vB4BGvso9Qt4EOQlifr+zaCGJ9yec+HQjOcGXzJDSyr7PEOR
 CRP+Kdygn5hPORVnm4182HIImU+q/lf2G6duBPdCagT6WHrWbPoXOWstT+Jueb5ugTEa
 Fhpg==
X-Gm-Message-State: AOAM531SSZ5UbYDWhCO5hSP8zCq5llNYv+QAMs+c1xy1KvAGEwg2kGOI
 6pKKpyqRWW37wlJl2PYI59VJkbfFWnpe6NZ4iUC+mQgBWPq01Zbkwl4YQBHCeFvNtY8LZrCJjlQ
 0rtvkG7uWTArLWs9/K6666g13VQso7nY07tEhZeR3xrkqvZIGDHVBqdU2GnrsljrBz+M=
X-Google-Smtp-Source: ABdhPJyKPDcykD+jZqtrY7F6z2+IYUsvk6Ld/uleTUzz1jiOs7fYD1kJ+7VGHzCekPCIlgM/IBedXZxLDA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:adf:e788:: with SMTP id
 n8mr9277808wrm.214.1630059377746; 
 Fri, 27 Aug 2021 03:16:17 -0700 (PDT)
Date: Fri, 27 Aug 2021 11:16:04 +0100
In-Reply-To: <20210827101609.2808181-1-tabba@google.com>
Message-Id: <20210827101609.2808181-4-tabba@google.com>
Mime-Version: 1.0
References: <20210827101609.2808181-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.259.gc128427fd7-goog
Subject: [PATCH v5 3/8] KVM: arm64: Simplify masking out MTE in feature id reg
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

Simplify code for hiding MTE support in feature id register when
MTE is not enabled/supported by KVM.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/sys_regs.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1d46e185f31e..447acce9ca84 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1077,14 +1077,8 @@ static u64 read_id_reg(const struct kvm_vcpu *vcpu,
 		val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR0_CSV3), (u64)vcpu->kvm->arch.pfr0_csv3);
 		break;
 	case SYS_ID_AA64PFR1_EL1:
-		val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
-		if (kvm_has_mte(vcpu->kvm)) {
-			u64 pfr, mte;
-
-			pfr = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
-			mte = cpuid_feature_extract_unsigned_field(pfr, ID_AA64PFR1_MTE_SHIFT);
-			val |= FIELD_PREP(ARM64_FEATURE_MASK(ID_AA64PFR1_MTE), mte);
-		}
+		if (!kvm_has_mte(vcpu->kvm))
+			val &= ~ARM64_FEATURE_MASK(ID_AA64PFR1_MTE);
 		break;
 	case SYS_ID_AA64ISAR1_EL1:
 		if (!vcpu_has_ptrauth(vcpu))
-- 
2.33.0.259.gc128427fd7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
