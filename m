Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6671EC4743D
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 14:11:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 080DE60FE9
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 14:11:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 080DE60FE9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF7384079A;
	Tue,  8 Jun 2021 10:11:49 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0E9Ue94P9b+x; Tue,  8 Jun 2021 10:11:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C170140870;
	Tue,  8 Jun 2021 10:11:48 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B10AA4083E
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 10:11:47 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VIgGwNiFPIcQ for <kvmarm@lists.cs.columbia.edu>;
 Tue,  8 Jun 2021 10:11:46 -0400 (EDT)
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com
 [209.85.128.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 788CC40825
 for <kvmarm@lists.cs.columbia.edu>; Tue,  8 Jun 2021 10:11:46 -0400 (EDT)
Received: by mail-wm1-f73.google.com with SMTP id
 k5-20020a05600c1c85b02901ac8b854c50so806504wms.5
 for <kvmarm@lists.cs.columbia.edu>; Tue, 08 Jun 2021 07:11:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=KfCyzLjYvtfjVAu2B5vrfApkB1qN2fyodQIgINGEiTQ=;
 b=aCRbqylSf2xclCPrzcK21cGpJ42WwdS2xxkiUcDI5rJGyVysXv0RyuECMvmGBOIo9f
 4e843nuXCj6TaO82nhrhkd3ABl3GWsCAeb9R5a0MPfmVnEfdjCuDRVTgTGTBvuxz58y+
 OBSKt642xMNFQxyLqBD+Xahyo4jlFJvg2NHMba+pX8jccHI766dgiwA3XLmfkhfGJHzw
 T4BOf6Ga4pB+IR6V9vih/peEidZ//ysloqxfjGNabwUymu09f4ulvkr67KK54ff/f3l1
 ra80fmWLjpL0lij2kaKuTQJ22e7QjGnXqd78UnIhflR3WVhdwMY/EMtSgUoHiJHhekeK
 07YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=KfCyzLjYvtfjVAu2B5vrfApkB1qN2fyodQIgINGEiTQ=;
 b=tYW35z/pTyUmq0GirPDO5KKV3lHMeqNucxz500VHE3K0e6U7BldqyB72a0D6fDGptN
 Egfw7evks6tStKZu5e2W95OK4a5HjR7NeH+/bi26W9Ad4OgQXb0UyJMathXaunSFWbs0
 ATDbb8mgz013Y0iGPbamxptzR2r29oOx9B/fBzPyuW+DiwbRcukk6c+8DNbjGgZ+14ql
 DgHcQ+du2NO8kjrz3Ldgpy9bVf9czDKIMsHdpv8jhdXKOBLSyLG5UkVbDJ6k4qtCT8ve
 KfDOyovbTtIGJDu5yWJNlgV8sVITrWz5llHoIjI8PLh+M+unVr1N9EhuXURM9wJtdud8
 3mAg==
X-Gm-Message-State: AOAM532qQmMrfGtxamzCHjzqWuIvOyMo0c+UWZIlI/1bPLy6syrEfZjL
 yZp2g8sBHjWNOJ6lhz5T7JJoAYEhih+ZBbjFL8LR3xfsDkkRXAnu2i5bY6lQ0gSgyNiP2B8XGf6
 mI9Tr5ZuZ313r1UzAcLBkJ8p4Tn+BtVTuC+9UINItRcW9T0+Ycwxxa3mcmaE81qQPX3c=
X-Google-Smtp-Source: ABdhPJyRDNGkYEpQKyC8K8EuRMO4oTBOQ99EavtyeC4T4OfyBXHvNt/BP9UvYfKkUFL4MTMUm3itodZJAw==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a5d:4ecf:: with SMTP id
 s15mr22738532wrv.80.1623161505308; 
 Tue, 08 Jun 2021 07:11:45 -0700 (PDT)
Date: Tue,  8 Jun 2021 15:11:29 +0100
In-Reply-To: <20210608141141.997398-1-tabba@google.com>
Message-Id: <20210608141141.997398-2-tabba@google.com>
Mime-Version: 1.0
References: <20210608141141.997398-1-tabba@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v1 01/13] KVM: arm64: Remove trailing whitespace in comments
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

Editing this file later, and my editor always cleans up trailing
whitespace. Removing it earler for clearer future patches.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/sys_regs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1a7968ad078c..15c247fc9f0c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -318,14 +318,14 @@ static bool trap_dbgauthstatus_el1(struct kvm_vcpu *vcpu,
 /*
  * We want to avoid world-switching all the DBG registers all the
  * time:
- * 
+ *
  * - If we've touched any debug register, it is likely that we're
  *   going to touch more of them. It then makes sense to disable the
  *   traps and start doing the save/restore dance
  * - If debug is active (DBG_MDSCR_KDE or DBG_MDSCR_MDE set), it is
  *   then mandatory to save/restore the registers, as the guest
  *   depends on them.
- * 
+ *
  * For this, we use a DIRTY bit, indicating the guest has modified the
  * debug registers, used as follow:
  *
-- 
2.32.0.rc1.229.g3e70b5a671-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
