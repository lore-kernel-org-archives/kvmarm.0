Return-Path: <SRS0=FmU0=ML=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A84FC07E9D
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:47:55 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C416460FF4
	for <kvmarm@archiver.kernel.org>; Mon, 19 Jul 2021 10:47:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C416460FF4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7626649FB7;
	Mon, 19 Jul 2021 06:47:54 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aTpYkTzQlIam; Mon, 19 Jul 2021 06:47:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 280914B081;
	Mon, 19 Jul 2021 06:47:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AE35D4AC78
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:47:51 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IyxQ4jNHnQFB for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Jul 2021 06:47:50 -0400 (EDT)
Received: from mail-qk1-f202.google.com (mail-qk1-f202.google.com
 [209.85.222.202])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6BCB4A4C0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 06:47:50 -0400 (EDT)
Received: by mail-qk1-f202.google.com with SMTP id
 t144-20020a3746960000b02903ad9c5e94baso14261799qka.16
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Jul 2021 03:47:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=hF3abQWZBVX3OcEZC1+muydZc+hxmzmuOXsHVIQGXQY=;
 b=bKDVheVY1IoxMnY0wSKdcwzVYL3+9RUBExVTBuQLvOyjLLO3PPt0/L9UEBmEHL+1Dx
 4GCQT5nMdj7k5BCms5Cp4cMXS2yqRf69jgSSFeaoSz1jZ8avNGOl6b181XVKQ4cCFaUh
 2EXb6bfTh+tcgwI2a383qfuwgtr2+1sZO2XBFsp8DH6NTZhuD0ICB8n4FNcbW7Hlzrda
 YHTa8rkvihWr9onnhlMHiBLIYzudPGEcwL/Mb87H+EpZpOzDbgM0KKrePPGhBHLoHkMU
 i2BYhTw5ZbitjRvVXlW5OqXmbQ5tYM1XNWQVTNkVnIgSDNNNia7XPNcXQe/0SlM0ppTf
 GepA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=hF3abQWZBVX3OcEZC1+muydZc+hxmzmuOXsHVIQGXQY=;
 b=KfqepijM5okmWypJ2zy0gCbf/xBnbOEw1TXAPmN1bAsnXYcX1nugYztaLwhIBm7Bn4
 iU2DaLsmHdm/dQRYqhlwus6+pmSllsKreQgLmQfA6aTj1IVn4elDEXBGe6Iu2mt16sSb
 7lPpo5XPDLOCQslRRsKdDB29XdrrIULLzB0JaWCXv7qfeOxERU4hacZQ7dEyJwas/RJ6
 hfgq4jVVVSNc4R+qww/Kr9Nr/00WHExtmNOCm1WrqMo2zXhyltireatKDLKU9XQASPyG
 lsFfRIHBDmj0j49x/1G70fvrlEbtJlXFBrTa+E3Lox8Cm/uh7uMvXt6EBFW3SDQ/7kyE
 XvoQ==
X-Gm-Message-State: AOAM532qx+C9OvuTPHjCDrR4gSo2W0Udhy66+DyTh8YQorkjoBm+W8qn
 39bgaOKjxHWxctkUC52kcjWo/LC3kk2m
X-Google-Smtp-Source: ABdhPJywsBug5lNdL9XgQmCske7yV74xcWDxC3HLTB31TuI7A3Ec/12WOGGcTHohteYdwrcfEA0JudPZ10me
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:1a96:a43f:6c2e:bb5a])
 (user=qperret job=sendgmr) by 2002:a05:6214:1021:: with SMTP id
 k1mr24356756qvr.4.1626691670169; Mon, 19 Jul 2021 03:47:50 -0700 (PDT)
Date: Mon, 19 Jul 2021 11:47:25 +0100
In-Reply-To: <20210719104735.3681732-1-qperret@google.com>
Message-Id: <20210719104735.3681732-5-qperret@google.com>
Mime-Version: 1.0
References: <20210719104735.3681732-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.402.g57bb445576-goog
Subject: [PATCH 04/14] KVM: arm64: Rename KVM_PTE_LEAF_ATTR_S2_IGNORED
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

The ignored bits for both stage-1 and stage-2 page and block
descriptors are in [55:58], so rename KVM_PTE_LEAF_ATTR_S2_IGNORED to
make it applicable to both.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index bb73c5331b7c..a60653cbd8e5 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -40,6 +40,8 @@
 
 #define KVM_PTE_LEAF_ATTR_HI		GENMASK(63, 51)
 
+#define KVM_PTE_LEAF_ATTR_IGNORED	GENMASK(58, 55)
+
 #define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
 
 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
@@ -48,8 +50,6 @@
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
-#define KVM_PTE_LEAF_ATTR_S2_IGNORED	GENMASK(58, 55)
-
 #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(63, 56)
 #define KVM_MAX_OWNER_ID		1
 
-- 
2.32.0.402.g57bb445576-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
