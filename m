Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18E60C07E9D
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:47:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B0DDF61026
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:47:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B0DDF61026
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 590A74A5A0;
	Mon, 19 Jul 2021 06:47:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id HhjILDF39fWV; Mon, 19 Jul 2021 06:47:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 574AD4B088;
	Mon, 19 Jul 2021 06:47:55 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 033234A3A3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:47:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id DbpkNuOgFMfg for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 06:47:53 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 176884A4C0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:47:53 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 eo14-20020ad4594e0000b02902fc3fd31414so11331016qvb.16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 03:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=9b2DYjQT7/g/R4ArAtIC/jYlBeWl0FTuTlWq0insfwk=;
 b=PqGcmBO2wTNT/PQffInicuYzE+ddpQibVhLtljlpqJEXnf4+QFhSeP67SvzmIU5KQS
 9Y8K7fKXU8Yc2JMPC9ZkvCioxx6Ssjg4gKGnar073enL+Qbu9mfXxey6Dr18AIdn2GyM
 Xcnr9YSul/mEPJCH8qfFwsaTQpnmJsqjqkfMVu5HSANq7OT62XP9gVzuUPOKP0g0bz56
 VQvMF7nmoLyBRZ7zawRL2TtSoSiM5+3X3gxQFB8vZtyLtEjeCydgiiPljiynVaYzAwX/
 lEJosv5Ud8X0u1ZfKviLaU84GaSDjbTS3GbiU1t4IlJ14sXx5GQjYGyJZQu2fpJGo0wu
 QkQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=9b2DYjQT7/g/R4ArAtIC/jYlBeWl0FTuTlWq0insfwk=;
 b=OW1KNpL2eHf/hXMfGKwQyrsQmZlKoRLaaYCYUPvWRhMefovxwDWgcXYKSkEyklbh+X
 LnLGmFMubFrDX4lOOwBpc+w87K0nBWsnTrwfBbkfyBe8ECfcbUpzq1dWyw9VeNmis4JH
 v7Rwglz5m3h/xbFqkTfS54m3mO9jc8c3v+7JtJRVzQ8R5+8ZDrDOqK9E+JOBDmMoJNJ4
 oIQyXzb8As4yItQtjqCoDeD2Ub+jHi7A5Yi2FzJvKCkifTYZTDriTw1fK16dDAguLQsn
 p+V2hZdYmV0kBQpFIETbWKfDYPpAdXVjp4wQ53K572B66HQzrnqewFlr6M1XlMkQCS7s
 lzEA==
X-Gm-Message-State: AOAM533IOlR1TTYNzigMXdWu8r9grihtEke0Gqenn2AB4ymyOhSPWdWP
 Hzvc3T5+ma7NMJe0IEw+GPmbKiDx01FL
X-Google-Smtp-Source: ABdhPJxrGQcU/bELmtAI4DiOZarAZdNIyxfly8cWQksXRDD7AQeTy6wEy0Y1zFBuD/hd8VGZA2WdmEFZdPU1
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1a96:a43f:6c2e:bb5a])
 (user=qperret job=sendgmr) by 2002:a0c:ca0f:: with SMTP id
 c15mr24195317qvk.58.1626691672637; Mon, 19 Jul 2021 03:47:52 -0700 (PDT)
Date: Mon, 19 Jul 2021 11:47:26 +0100
In-Reply-To: <20210719104735.3681732-1-qperret@google.com>
Message-Id: <20210719104735.3681732-6-qperret@google.com>
Mime-Version: 1.0
References: <20210719104735.3681732-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH 05/14] KVM: arm64: Don't overwrite ignored bits with owner id
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, james.morse@arm.com, alexandru.elisei@arm.com, 
 suzuki.poulose@arm.com, catalin.marinas@arm.com, will@kernel.org
Cc: qwandor@google.com, linux-kernel@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kernel-team@android.com
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

The nVHE protected mode uses invalid mappings in the host stage-2
page-table to track the owner of each page in the system. In order to
allow the usage of ignored bits (a.k.a. software bits) in these
mappings, move the owner encoding away from the top bits.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index a60653cbd8e5..a0ac8c2bc174 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -50,7 +50,7 @@
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
-#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(63, 56)
+#define KVM_INVALID_PTE_OWNER_MASK	GENMASK(9, 2)
 #define KVM_MAX_OWNER_ID		1
 
 struct kvm_pgtable_walk_data {
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
