Return-Path: <SRS0=nOLV=77=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D17C433E0
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jun 2020 09:36:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D82AD21548
	for <kvmarm@archiver.kernel.org>; Thu, 18 Jun 2020 09:36:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="BQ3Dy5ut"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D82AD21548
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4EF604B15C;
	Thu, 18 Jun 2020 05:36:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id sMwuAOuoJzEx; Thu, 18 Jun 2020 05:36:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 455184B14B;
	Thu, 18 Jun 2020 05:36:38 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAC984B147
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 05:36:36 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rMA1H4aNn6mp for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Jun 2020 05:36:35 -0400 (EDT)
Received: from mail-yb1-f202.google.com (mail-yb1-f202.google.com
 [209.85.219.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D707D4B101
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 05:36:35 -0400 (EDT)
Received: by mail-yb1-f202.google.com with SMTP id 186so5703149yby.19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Jun 2020 02:36:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=zDr3aCVxtdmioyXdBcPjaJWp8Jhtb88eX2k26wuLCxg=;
 b=BQ3Dy5utYb3ha6yzuem0emrHsdPKvrAZsiNqwFLXxBaUWGlZc2Cu0YsjohruOquojq
 KrAsNbALnSbE4lkUxEuRvqh5LZItexYgUasw/vNME6BDDK/btopnZaKye/atNLF1SOCk
 wR8oIK3W8TL1U8/mSUzqIDX5+ThxAN8y8JEl12BCcdDrcOhZxcramqztfwOWNc+DPKsr
 S2lyIx7zSO8qsPjlilUzsMRIGl8DSyL+vjKH0FJzVqZgIWaKVOoO5iLLgyMF4uOqy1kF
 uC/vnj90Mpj0SOGBE42ZDLzoTytUPzyeVM76ycjJ+Cc+9OP1Yr6FWjmbEimTWRDiYgYW
 e1uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=zDr3aCVxtdmioyXdBcPjaJWp8Jhtb88eX2k26wuLCxg=;
 b=sLanMbWsyJM0Ng0keAX4wy4G6RvtsX2LuTKAAg30nSRfVHlJ1tGMiX1qaA6Cx6NTfd
 O+CmdfWQQVTWhWjSaG8frwMOghedy8cQ3eKlou8W4iDsk3Relo1O8QXiLW6Vj8TLnCG8
 o39H+Dv5hVCsce0nErC7jA8wTM1cVTd65S5RkTKRozTLM689j2oa8o0+de1Lq0dTgE/5
 MI8t5Zrn4iWZdeIrpSyXu9BiP5WYcbADnuo6KXUQxApvg1c91rG4FJraFuPu21wE3dTd
 hZ9/O6/CRB6II2GOvnOldOAOHIacrJyTYgjYT0kLmWp6pT+u0CWmeYmXNcH7lejku43k
 ooBw==
X-Gm-Message-State: AOAM530j3Mm5CCe6awanLboDzTPXQa6KT/h3brxSnD6EJPYZ2mtFeOHi
 C/kMsVis6TaGSDIvawhEFoJMcVEbYRndj6BsHTpEpd0Hhims6Gk9Ho9Z6rTiXM46MDeJV4JwvSS
 9sIteyhwJoAI60iG2k4FQn7/U4UTnefBdjnN17dp9w8WdDlP3sUSGoUA1i19A+b9Bkl95lA==
X-Google-Smtp-Source: ABdhPJwpAMFuDsQIctZL+k62SxpCYWHbTkzBBx+C95ZQy37DQq6prZ5Byy3xpI3BFJTPPx3wysEJqNII0cA=
X-Received: by 2002:a25:8b0c:: with SMTP id i12mr4813441ybl.499.1592472995089; 
 Thu, 18 Jun 2020 02:36:35 -0700 (PDT)
Date: Thu, 18 Jun 2020 10:36:16 +0100
Message-Id: <20200618093616.164413-1-ascull@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.290.gba653c62da-goog
Subject: [PATCH] arm64: kvm: Remove kern_hyp_va from get_vcpu_ptr
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

get_vcpu_ptr is an assembly accessor for the percpu value
kvm_host_data->host_ctxt.__hyp_running_vcpu. kern_hyp_va only applies to
nVHE however __hyp_running_vcpu is always assigned a pointer that has
already had kern_hyp_va applied in __kvm_vcpu_run_nvhe.

kern_hyp_va is currently idempotent as it just masks and inserts the
tag, but this could change in future and the second application is
unnecessary.

Signed-off-by: Andrew Scull <ascull@google.com>
---
Built with ARM64_HARDEN_EL2_VECTORS=y and tested on qemu A72 with
kvm-unit-tests and booting a VM with kvmtool.
---
 arch/arm64/include/asm/kvm_asm.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 352aaebf4198..ac71d0939f2e 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -143,7 +143,6 @@ extern char __smccc_workaround_1_smc[__SMCCC_WORKAROUND_1_SMC_SZ];
 .macro get_vcpu_ptr vcpu, ctxt
 	get_host_ctxt \ctxt, \vcpu
 	ldr	\vcpu, [\ctxt, #HOST_CONTEXT_VCPU]
-	kern_hyp_va	\vcpu
 .endm
 
 #endif
-- 
2.27.0.290.gba653c62da-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
