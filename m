Return-Path: <SRS0=n2ZT=KJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BD3CC433B4
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 01:49:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8D2EA6142E
	for <kvmarm@archiver.kernel.org>; Fri, 14 May 2021 01:49:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8D2EA6142E
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED7B74B923;
	Thu, 13 May 2021 21:49:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id jFDmakKuFEFp; Thu, 13 May 2021 21:49:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A03D14B8E7;
	Thu, 13 May 2021 21:49:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AFF9A4B8E7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 21:49:15 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3h7srMbVJKKL for <kvmarm@lists.cs.columbia.edu>;
 Thu, 13 May 2021 21:49:10 -0400 (EDT)
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com
 [209.85.215.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A29574B881
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 21:49:10 -0400 (EDT)
Received: by mail-pg1-f202.google.com with SMTP id
 d17-20020a634f110000b029020ff9c39809so18263202pgb.16
 for <kvmarm@lists.cs.columbia.edu>; Thu, 13 May 2021 18:49:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=QeY8+m3KWnutvQnXWbW4ohmSlHmgT5rO46x1+R7ZFH8=;
 b=u4mwT88i2WyKF5YjRwZPM6aodPWwuRccKa+PCaEPNssUzkqqOAocV2i+YdkoTKg2Ek
 YJ64eh+q6btfTgSDuaa+626PyyF7aGsKlcb2VFgeXEewQn9S6K9Gdy7vocRnXaeobiTk
 aNxy33QQZkASBuLUtAzonQQ8vd5yhIzCUumgzStVbcdmM/R35VeElrj1NfLgdk7GFpKO
 XdQsq+KZi2hoBufYhDgIadm6sN85PIDh2/iscRV2zQ8Mtjm3x11qZEtNw4NoaQqfQXIY
 XuaSGeTk5YV3N2U3OeZ3pDg3R3hVCvblhBUp4HPfh89IBQV5b7h8rDr9Ppc0DGQXRpUc
 98uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=QeY8+m3KWnutvQnXWbW4ohmSlHmgT5rO46x1+R7ZFH8=;
 b=uAixl01o1PU9bSOhsiz+3IvJJRkXR5Jwhl9QTybTmPSY+g70O8HyUI3hCem3yZ7SxM
 +6idnCYDWAUGr5dX/xHSvlOvtIvz3LopP+CrgXUKg8+qWJYI7HAr7GGN1diWJ0hiSeJ9
 xJaQT4LLSUmyKg5Xh5IvtxNAcCzAw77Zh64af1lMhfdJeWfjMDjblJJV6RYjazm4DXUL
 gJ7G/ygE4jkjEYfj+XY+nbNIpwCD+yiiUR8MsfSelIuIi/QMmts4v0u7a2vgdqtO5tC4
 yrV9bIU1lCxZHQNntLs30VvYWtrC0r8ZLvdup7j7k1czYdg8231RmKa3OwL+M/82bB9C
 mESw==
X-Gm-Message-State: AOAM530+ivIGE/0/lnEHWJ/8qLCbhvOF59A9zyTPq3+zjn4QD6GOfXmc
 FOf6kXdlJ2zFw7jK2a3gu3Vx3wNH6fhyjahcSIl8JL+Ym29Y6QA2xuTWweUTZHmFE2yx+OPUvVX
 aiSI8FWHWc7+ycv48xe9/01vTm35wEWM6l3ta5P/xt27eQ9l/zHBzMoaqSCVzvKPniEhX9dWowL
 I=
X-Google-Smtp-Source: ABdhPJygmzqfimWcBkdDxlwIxuEldWS9jii32FdtVzJfJsizXYKTC1oalM50Sa7erTToyGoXxQpMorQqUbHmrw==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:10:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:aa7:808d:0:b029:2bf:bf00:c6f6 with SMTP
 id v13-20020aa7808d0000b02902bfbf00c6f6mr23346781pff.64.1620956949386; Thu,
 13 May 2021 18:49:09 -0700 (PDT)
Date: Thu, 13 May 2021 18:49:06 -0700
Message-Id: <20210514014906.392401-1-ricarkol@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.1.751.gd2f1c929bd-goog
Subject: [PATCH] KVM: arm64: Add missing index for trapping debug registers
From: Ricardo Koller <ricarkol@google.com>
To: kvmarm@lists.cs.columbia.edu
Cc: maz@kernel.org, linux-arm-kernel@lists.infradead.org
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

Trapping an access to debug register <n> (like bvr<n>, bcr<n>, wvr<n>,
wcr<n>) results in storing and loading values from the vcpu copy at
index 0 (irrespective of <n>). So, this guest test fails:

  /* traps and wrongly stores 0x123 into vcpu->bvr[0] */
  write_sysreg(dbgbvr1_el1, 0x123);
  /* reads 0 from the real bvr[1] without trapping */
  GUEST_ASSERT(read_sysreg(dbgbvr1_el1) == 0x123); /* check fails */

Fix this by setting the register index in macro DBG_BCR_BVR_WCR_WVR_EL1
to <n>.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/arm64/kvm/sys_regs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 76ea2800c33e..e4ec9edd49fa 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -935,13 +935,13 @@ static bool access_pmuserenr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 /* Silly macro to expand the DBG{BCR,BVR,WVR,WCR}n_EL1 registers in one go */
 #define DBG_BCR_BVR_WCR_WVR_EL1(n)					\
 	{ SYS_DESC(SYS_DBGBVRn_EL1(n)),					\
-	  trap_bvr, reset_bvr, 0, 0, get_bvr, set_bvr },		\
+	  trap_bvr, reset_bvr, n, 0, get_bvr, set_bvr },		\
 	{ SYS_DESC(SYS_DBGBCRn_EL1(n)),					\
-	  trap_bcr, reset_bcr, 0, 0, get_bcr, set_bcr },		\
+	  trap_bcr, reset_bcr, n, 0, get_bcr, set_bcr },		\
 	{ SYS_DESC(SYS_DBGWVRn_EL1(n)),					\
-	  trap_wvr, reset_wvr, 0, 0,  get_wvr, set_wvr },		\
+	  trap_wvr, reset_wvr, n, 0,  get_wvr, set_wvr },		\
 	{ SYS_DESC(SYS_DBGWCRn_EL1(n)),					\
-	  trap_wcr, reset_wcr, 0, 0,  get_wcr, set_wcr }
+	  trap_wcr, reset_wcr, n, 0,  get_wcr, set_wcr }
 
 #define PMU_SYS_REG(r)						\
 	SYS_DESC(r), .reset = reset_unknown, .visibility = pmu_visibility
-- 
2.31.1.751.gd2f1c929bd-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
