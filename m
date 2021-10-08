Return-Path: <SRS0=WrEh=O4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1033BC433F5
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 15:58:53 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B7B7D6101A
	for <kvmarm@archiver.kernel.org>; Fri,  8 Oct 2021 15:58:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org B7B7D6101A
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DE924B15D;
	Fri,  8 Oct 2021 11:58:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aTPpk24CsLgb; Fri,  8 Oct 2021 11:58:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7DB804B106;
	Fri,  8 Oct 2021 11:58:51 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C11A4B10B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 11:58:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id dPM57Z-sFCDb for <kvmarm@lists.cs.columbia.edu>;
 Fri,  8 Oct 2021 11:58:49 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7D6C24B11C
 for <kvmarm@lists.cs.columbia.edu>; Fri,  8 Oct 2021 11:58:48 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id
 h11-20020adfa4cb000000b00160c791a550so7482728wrb.6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 08 Oct 2021 08:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=VhuTEAoXz/dF/jFcm1SrjIjX6UWTaTkDztAyYYvfOi8=;
 b=YY62UZxzS49MsZTZDt7m5bixF5e4/e56Js7FNy8P/5WB6wDKNIpJ03vT0NjcVy2pcO
 k4S9nE42zrsnb47cjDZ89XxxQmuF9Jvle7QR4o7Fw1pLDAVywodrNs4jr4QV9K8+j9AV
 p4yqmNUbDQ793eHOGgBcAsgD36WOo27/9FMSYUB1T+YaiiNgPRAG1LvnsZqjShKTx8Ub
 tDDUieO72w0VRTTvEfgOiBi2oeUUntZmEc1dxx6lTnL/NMyUhWin7P26egfGZC9RNTmC
 m1voxEvf4FvgSnSnAYsz4zkuTlUwyn4zcUc5i7dqdZ3/4vOlybThZbC1BHjhYEoMADMs
 J7KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=VhuTEAoXz/dF/jFcm1SrjIjX6UWTaTkDztAyYYvfOi8=;
 b=hFdAoLtWIDv3fo+xYOU+xqGPbTP5Vp7SoksIzf3tOQVAlPB95Y4+xn+S3n+BrkR/cC
 cbhQncXy+ZH8i6nHrn0vkFwiIH//8te+sm6Y2/WE8OzpVr3nkjeMIJkGLVggudRE5BBM
 dFLpAQtLUivG+NDs25zOJB1a6Af0KNlqCFyYSPIti49SbPfbP5ZF5EBaPGLSjJd37dlT
 ZACBrnR+GoALuUqvtXA4yyrAa9izLSSKBF6p6SjiLOpXf9+OcSQ5c9Xk7KFyAbWG89Nw
 JD9aUY+LFfPR7m968hdCBVVyKFnxPKFlfxJCiPIZ7SOCj9u1cNx6K6qZIZOyt2bOcNb/
 MQGQ==
X-Gm-Message-State: AOAM530ojlD3LPBmQ2tpBn2Z1CSVZ46G8elruQSiK5bAXZzn6iZQxi/H
 tX2g0ldm0rZWzK6c2yjUcBHzhrSSq0RPLnKKWw4RrwE36tYIt+HU9VtZ4Zd1+Wyl0rne0+P1fr9
 YEM7A6otSDqL++sTM92Y5QFj8/o1EYkAGBdQMOTeRIugmaJWwX2vM4hZjt/1Vike/rDQ=
X-Google-Smtp-Source: ABdhPJyK9TfYAioqZj/6q2+tGeZz6Ky7JDG6jIcXRQ+nU98pxDyYEfO4P6pHAn09YmYjpoCemTRkwnkldQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a7b:c3cc:: with SMTP id
 t12mr4352516wmj.34.1633708727501; 
 Fri, 08 Oct 2021 08:58:47 -0700 (PDT)
Date: Fri,  8 Oct 2021 16:58:27 +0100
In-Reply-To: <20211008155832.1415010-1-tabba@google.com>
Message-Id: <20211008155832.1415010-7-tabba@google.com>
Mime-Version: 1.0
References: <20211008155832.1415010-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.882.g93a45727a2-goog
Subject: [PATCH v7 06/11] KVM: arm64: Simplify masking out MTE in feature id
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
2.33.0.882.g93a45727a2-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
