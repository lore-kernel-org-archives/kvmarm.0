Return-Path: <SRS0=n474=OM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1729C4332F
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 12:47:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 48718611B0
	for <kvmarm@archiver.kernel.org>; Wed, 22 Sep 2021 12:47:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 48718611B0
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E839B4B0F1;
	Wed, 22 Sep 2021 08:47:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xos2rkiIUUPP; Wed, 22 Sep 2021 08:47:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC45A4B08D;
	Wed, 22 Sep 2021 08:47:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0E68B4B0C5
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 08:47:25 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B3vavj2gkxJS for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Sep 2021 08:47:24 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED25C4B0E7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 08:47:21 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id
 70-20020aed20cc000000b002a69b3ea30aso8645824qtb.15
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Sep 2021 05:47:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=+XjKwBEU8XHurAeXBX8jHTz51rXfXyCyxwuOVOoJtgE=;
 b=SQICd5Wi/tLS6YqYvGCfeYH/8a8o9qHXUQfDX5jpZ6xU3Ui3cJZI06CCo3qkYEc570
 ezYzwjPC1hKUa+yCn/ZSvCVtDqXm/CqhhcXfUBUHW2eJL6tL+UHdAoC5GuSpzRCljUbQ
 3/Panm01VDkkZHLP+KnFqGrfwdNVErXheqH4d+7Be4IoQ8Qg0f/vdKT4ZkHt4jyy1cSD
 RYkW1dQRn4Rzex3jGkjc3Wf6CTuagfM/l71/QQ2flL2/ZKCLJTRApg8/iE05YQv6X0LE
 eyUOqv9lBoQPUCovDo7CRclsfjB69SfaQXT22JzhQUEI0wiX0mWhnzEcfL2FVgG9fPUj
 SRxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=+XjKwBEU8XHurAeXBX8jHTz51rXfXyCyxwuOVOoJtgE=;
 b=pNtQ5F/+nq/q7biI+2lN3hisUjzmAhff1Zr9/4h9aEuKPpinanGCk9EzC9Dhiy/E3p
 T6y60sAjL+ogOWJ/FxmShjR0Pt4fP9OaI6fYEaFhcF7brXrH8q0zgviaHTelokQnO1sP
 +girq8D2u9RNRi8vBEPrp8Eh8wbebcBvA6kuFBD+SgkswUdXJRs1zfjHbsV83Vi1vLKA
 rfZj6//9XA66U1i130PZsc2WKWQCa4u3ZdxrsnuyoBbcGOnbk0FuyUhIiK626Bp4dND0
 kfCni4REamO6oxR8nKgyH54Lfmq5+0pzFWvAHpMRdF+kZP0fuvAshY7QDFwumSZisRen
 ZSyQ==
X-Gm-Message-State: AOAM5331oZDFgw3k3EJLCpqs39D9Gk9Dj8tEYUKfbcqZyn8VjW1UMEfu
 RYnUS7iLQjYJNlyceR6j3NqrJAYLVTEVF5+bcn6WGi6j6CLKK06kevvu3YyZHeox2ANyj/QH5N9
 BhvKbGuMpI5115IwRhzAdwDj7JMe+CgL12IY7D2LN2u/uOa7BteSiZ43I11kwRE8q6cY=
X-Google-Smtp-Source: ABdhPJy8aSobofh0Qai9hz2nCfb+UCZ9fXyZoPgAPtLb/DlaFbORkM5gtPL+Ayu+m1LXY6nESzHqO+khOw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:f10b:: with SMTP id
 i11mr36186303qvl.67.1632314841458; 
 Wed, 22 Sep 2021 05:47:21 -0700 (PDT)
Date: Wed, 22 Sep 2021 13:46:59 +0100
In-Reply-To: <20210922124704.600087-1-tabba@google.com>
Message-Id: <20210922124704.600087-8-tabba@google.com>
Mime-Version: 1.0
References: <20210922124704.600087-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.464.g1972c5931b-goog
Subject: [PATCH v6 07/12] KVM: arm64: Simplify masking out MTE in feature id
 reg
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
Reviewed-by: Andrew Jones <drjones@redhat.com>
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
2.33.0.464.g1972c5931b-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
