Return-Path: <SRS0=T00w=A2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 051CFC43445
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 864752065F
	for <kvmarm@archiver.kernel.org>; Wed, 15 Jul 2020 18:45:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="v0qirvgx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 864752065F
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 181504B3CA;
	Wed, 15 Jul 2020 14:45:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ccj046sXhlKI; Wed, 15 Jul 2020 14:45:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A0BB4B3F5;
	Wed, 15 Jul 2020 14:45:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D401C4B3CA
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 12OqXhNXU0Xw for <kvmarm@lists.cs.columbia.edu>;
 Wed, 15 Jul 2020 14:45:52 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 137F94B406
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 14:45:51 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id p22so3947965ybg.21
 for <kvmarm@lists.cs.columbia.edu>; Wed, 15 Jul 2020 11:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=T1t00zM7hyCieChzZjSK0bp1aA1KMHGsMnh9IMeNcxM=;
 b=v0qirvgxyj/z+Dgmk0Ev9OtkNvvSprfxZHoUCEI/EOSB4kPWPbKyvEu6jRhAwhvJYs
 S8QBgbZuQywc31nsSYN/7oqtsUrsjGNAaT/rYjvCVD0wvkQMkIcYHdMDrm/sWTQd01Wy
 z2Q+ApNxijjcRL8yZHoo6fgvVFvbOYPczJKwvvDe0dUPHqGQ7TdmE64cAhpQ2bJ1LKcj
 OhoKWThz6LRDjr48efwZAtzcJTkIhg9dBC5smcUxAHlxxxsDE5g3iAqJtOnUtHi44OTu
 0+q9pNbq4IsEqzyDSbdvNfJjg+P5YvV6ULdE24zTvw9VFfKM4qp931e7P6a7aCx37CWp
 PqFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=T1t00zM7hyCieChzZjSK0bp1aA1KMHGsMnh9IMeNcxM=;
 b=qY2AN6i/y9DtKTJ1nCq35RZyFfqAfU6eoaSq+S7OPSeutOQMH6EOVD5p2MuqCRGyOA
 3rDF4yuh6qOfncmsc3NlQD+q+lbq2u2xKGU20AIMVGcp471HyxHSNx2BZcGspTtvAqv5
 eZejXSH+f0V9Yhx0b+JJcMG/zjVrFhZQpKX4OmhuJf/eig5pyvUXTSYF3OvtNH8V7xT5
 hyme1snT7pbbCgJrk72T4Ki7HgMFvQcPglqB2uatHi9d3yYW5u2EhNDxTEGXXhKZSDMg
 dZlhxTdkfen4YM0w95aEQzV/rS/7kVHwdcW81awzi3eyenhTttWi9G6s8g8a2hBWePZi
 i4SA==
X-Gm-Message-State: AOAM531iz1WW1p/YzWCrmcETEEtaUGSYkUCVgj10SIOrPDqKlI61Pfol
 vb5UqqciBO21qKA1yfMFZ2RiaweFf1EklBdVVRCHiFxqJrZfr1DnjoNbEjpm2ox+7EMibQYFOPO
 fsGQGF95C3s1zzaDdyL+BdFTi+vKS9ZFphZgZ0YI0uLN7FNSf5bBQog3UkED2McobGpVrXg==
X-Google-Smtp-Source: ABdhPJwP/JE0zMXJYJbo5JMkUZrId171oXVutasji9YR+sTCyIitf+uTBci1U67u9R/CNQ/KOgHrj2ZMOaM=
X-Received: by 2002:a25:2558:: with SMTP id l85mr482652ybl.307.1594838750570; 
 Wed, 15 Jul 2020 11:45:50 -0700 (PDT)
Date: Wed, 15 Jul 2020 19:44:29 +0100
In-Reply-To: <20200715184438.1390996-1-ascull@google.com>
Message-Id: <20200715184438.1390996-29-ascull@google.com>
Mime-Version: 1.0
References: <20200715184438.1390996-1-ascull@google.com>
X-Mailer: git-send-email 2.27.0.389.gc38d7665816-goog
Subject: [PATCH 28/37] KVM: arm64: nVHE: Unify fpexc32 saving paths
From: Andrew Scull <ascull@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, kernel-team@android.com
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

The host vcpu is not 32-bit so this will be skipped but 32-bit guests
will save this state.

Signed-off-by: Andrew Scull <ascull@google.com>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 3 +++
 arch/arm64/kvm/hyp/nvhe/switch.c        | 5 ++---
 arch/arm64/kvm/hyp/vhe/switch.c         | 3 +--
 3 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 4b1e51b8bb82..18a8ecc2e3a6 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -52,6 +52,9 @@ static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
 /* Save the 32-bit only FPSIMD system register state */
 static inline void __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
 {
+	if (!(vcpu->arch.flags & KVM_ARM64_FP_ENABLED))
+		return;
+
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index eb10579174f2..7fdf1a9ab47e 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -192,9 +192,6 @@ static void __kvm_vcpu_switch_to_host(struct kvm_vcpu *host_vcpu,
 
 	__sysreg_restore_state_nvhe(&host_vcpu->arch.ctxt);
 
-	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
-		__fpsimd_save_fpexc32(vcpu);
-
 	/*
 	 * This must come after restoring the host sysregs, since a non-VHE
 	 * system may enable SPE here and make use of the TTBRs.
@@ -213,6 +210,8 @@ static void __vcpu_save_state(struct kvm_vcpu *vcpu)
 	__sysreg_save_state_nvhe(&vcpu->arch.ctxt);
 	__sysreg32_save_state(vcpu);
 	__hyp_vgic_save_state(vcpu);
+
+	__fpsimd_save_fpexc32(vcpu);
 }
 
 static void __vcpu_restore_state(struct kvm_vcpu *vcpu)
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index daf40004e93d..3c475cc83a2d 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -148,8 +148,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	sysreg_restore_host_state_vhe(host_ctxt);
 
-	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
-		__fpsimd_save_fpexc32(vcpu);
+	__fpsimd_save_fpexc32(vcpu);
 
 	__debug_switch_to_host(vcpu);
 
-- 
2.27.0.389.gc38d7665816-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
