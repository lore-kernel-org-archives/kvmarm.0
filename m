Return-Path: <SRS0=Fj5y=6B=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_ADSP_CUSTOM_MED,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84DF6C2D0EF
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 13:58:15 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 2B11121D6C
	for <kvmarm@archiver.kernel.org>; Fri, 17 Apr 2020 13:58:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="IT/qiqgA"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2B11121D6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D79144B256;
	Fri, 17 Apr 2020 09:58:14 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2bvt-UuyurPE; Fri, 17 Apr 2020 09:58:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D194F4B284;
	Fri, 17 Apr 2020 09:58:13 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E7224B283
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 09:58:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DiY5HwqYYos4 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Apr 2020 09:58:11 -0400 (EDT)
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com
 [209.85.221.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8237B4B177
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 09:58:11 -0400 (EDT)
Received: by mail-wr1-f74.google.com with SMTP id 11so1048652wrc.3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Apr 2020 06:58:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=OTQ/2felfIPImt6ZXxs6cTfp703cxZJXPRQW+LdgZqQ=;
 b=IT/qiqgAAlAfJjuNe/GEK2Y63zw8oGNr3m4imfx24NbycGpyBqy4XvWGW/qTPQGIaB
 bD1OWiYBqxkXx5GM/4qAd/IuLCSVVPz1w9ycyLIJM85jhyodNqZwB5VzEudSUbyVmm9X
 5K2+e0jbatQWx3zMaCBz/nOFWDSNSwKzNc9TmKsLKpD/lJl5mCADkUi8hq5salVEGihM
 IDbXLCQ8fqqm35i4w2HJnuuVxzDkduG7M6blLPLWKv7POZ9IA8PNhuWJN2dg4liu5u9X
 m1uvlvkIfiUVodbKnc8PW+F9MF4XPiM1cLWQYAnABINzcjAQC344TIoIAZus9teuUl0f
 NZVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=OTQ/2felfIPImt6ZXxs6cTfp703cxZJXPRQW+LdgZqQ=;
 b=hs2XQWjHFuvDFsmYh7qxksN92zf2C6EwL4d7d1ErhApl4cPCvbGocxoMmVAG66weLt
 FPKU06Qy4ysYHA931vH/s5uTEFT4CcwWp9ko7HmKgRFnig69T9b/SfMgDR1n0bbTo2C8
 A3AwwZYvzJcOI8hE6wFp/8ccZHcdFix0W8HOdB0HYEiRkQPYgcllWiXMy1Rv6YVrTyVf
 kmLQ8Zwb67N+MTjAHCK4cbfk6eq2kKKAL0m26iOeLbBuV2Kc8vszKYLozMRYuFxeNDf/
 LFzHrcxFX/a1AwArRtsqu9UwClXzbiwviKGGpCnH7VxOqQmoqEaf8eRtLBgdRw+C/hB6
 /jaw==
X-Gm-Message-State: AGi0PuZrTuWTQfrK4gx++X8uHixuYnwEPD7O6HHdBHZtCHJ3qe7jcX2s
 o1VEzyEpnNq/CyiNNod5IC4JGQ+SXw==
X-Google-Smtp-Source: APiQypKJ9mvdwZh+LqwObHOFyxOhVbqdOSMT7HTntnvE2qTd97zk8L3w1Z9B+Mvl0mrpsXkomHOmgBnE9Q==
X-Received: by 2002:adf:b344:: with SMTP id k4mr3954907wrd.76.1587131890644;
 Fri, 17 Apr 2020 06:58:10 -0700 (PDT)
Date: Fri, 17 Apr 2020 14:57:59 +0100
In-Reply-To: <20200417135801.82871-1-tabba@google.com>
Message-Id: <20200417135801.82871-3-tabba@google.com>
Mime-Version: 1.0
References: <20200417135801.82871-1-tabba@google.com>
X-Mailer: git-send-email 2.26.1.301.g55bc3eb7cb9-goog
Subject: [PATCH v2 2/4] KVM: arm64: Update help text
From: Fuad Tabba <tabba@google.com>
To: catalin.marinas@arm.com, maz@kernel.org, julien.thierry.kdev@gmail.com, 
 suzuki.poulose@arm.com, kvmarm@lists.cs.columbia.edu
Cc: will@kernel.org
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

From: Will Deacon <will@kernel.org>

arm64 KVM supports 16k pages since commit 02e0b7600f83
("arm64: kvm: Add support for 16K pages"), so update the Kconfig help
text accordingly.

Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/kvm/Kconfig b/arch/arm64/kvm/Kconfig
index ce724e526689..d2cf4f099454 100644
--- a/arch/arm64/kvm/Kconfig
+++ b/arch/arm64/kvm/Kconfig
@@ -44,8 +44,6 @@ config KVM
 	select TASK_DELAY_ACCT
 	---help---
 	  Support hosting virtualized guest machines.
-	  We don't support KVM with 16K page tables yet, due to the multiple
-	  levels of fake page tables.
 
 	  If unsure, say N.
 
-- 
2.26.1.301.g55bc3eb7cb9-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
