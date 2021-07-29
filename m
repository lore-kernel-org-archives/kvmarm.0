Return-Path: <SRS0=9/XU=MV=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5FBAC4320E
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:42 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 93DB760F4B
	for <kvmarm@archiver.kernel.org>; Thu, 29 Jul 2021 13:28:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 93DB760F4B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4823A4B0E4;
	Thu, 29 Jul 2021 09:28:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bTbDtvfC1UQf; Thu, 29 Jul 2021 09:28:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 585D74B0F6;
	Thu, 29 Jul 2021 09:28:41 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B8B664B0B6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id XDwSp35ptCFq for <kvmarm@lists.cs.columbia.edu>;
 Thu, 29 Jul 2021 09:28:39 -0400 (EDT)
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com
 [209.85.208.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C7A2F4B0DC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 09:28:39 -0400 (EDT)
Received: by mail-ed1-f73.google.com with SMTP id
 i89-20020a50b0620000b02903b8906e05b4so2917529edd.19
 for <kvmarm@lists.cs.columbia.edu>; Thu, 29 Jul 2021 06:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=rFkRNcfpvB1Ju4IVqteFXhSiHej5m8ER5DA8p5t0LAM=;
 b=adgE5oH5ZzQyJ5my+MCD24NaPHWhLe66wtzcPFxdI/5uGtUKivh3E2sLcxhhUi1oUH
 kO7wflN08UcEigT8OK5o3G9pnCptziZAF+CPeYXNsUPhGWRx9thRs8VvjUsj0wnVgVd9
 FsDGXrEqaK5mNzuNKveKDQw9yNnZPbE3IwF3Nyp5jGLc24vZ6pC16gO1goRrmc6p4QeG
 1pl2RVMEOAGPak5/N4DWB4EdeaFsM/1BqnR1Y+4My1F0edR0G+W0cHFgkk/nQylpkCT7
 wfl1k5OCIXaC4iXp8zFS7ADwIDEW7L7ZdpJPW5wBQMrYF0zfhDiqkNWELGt0tzVlNpX3
 W7MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=rFkRNcfpvB1Ju4IVqteFXhSiHej5m8ER5DA8p5t0LAM=;
 b=OCS28DqTX1j3/SFIr4IS2Uz60Gze75Sfg10NzyNdOgYILRE3o1oGzmTtN3FD2J7O7r
 lwT91ZeXEGQVgv2z7piLa3/NYWbcgQRh2Xfo6eoVsk1x8B4CVr2cWVdiLZvVZr/rjpxZ
 +MMG5bKSfwwcLllU+F/ukJl61GbYrPV3CGHmimbhF07ECc2ZnqQcoKASK3xzz8fpbbTx
 pwN2BuG+S149ayf5ysxntyS1DxIbs2yW3y2/FiowBMgXtZnY04xFl5+0XxhkNbkqHNsQ
 5PTi3oD7wn13pHlFNukvMSXKaCXjSSSgMdsCVkEZKtTM24kJ9RlT3IuHHO648Z5Y7unj
 so2A==
X-Gm-Message-State: AOAM530jiHadTGS+7Xp3K8XnygeBXc1v6goEwIHtZyfzfhnokVQgKf46
 TUIOED3d7ZYXa7PNIR6AwCzgGpqrGdaF
X-Google-Smtp-Source: ABdhPJycW7HuuY9Gim/mXG1ILhZq0/6nWfqymTtbWe0EQGgl+pPQmTGRPV48lVOvv5Y7iUj6rD/h42ZYLODf
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:293a:bc89:7514:5218])
 (user=qperret job=sendgmr) by 2002:aa7:dbc3:: with SMTP id
 v3mr6100538edt.63.1627565318816; Thu, 29 Jul 2021 06:28:38 -0700 (PDT)
Date: Thu, 29 Jul 2021 14:28:04 +0100
In-Reply-To: <20210729132818.4091769-1-qperret@google.com>
Message-Id: <20210729132818.4091769-8-qperret@google.com>
Mime-Version: 1.0
References: <20210729132818.4091769-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v3 07/21] KVM: arm64: Rename KVM_PTE_LEAF_ATTR_S2_IGNORED
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
make it applicable to both. And while at it, since these bits are more
commonly known as 'software' bits, rename accordingly.

Signed-off-by: Quentin Perret <qperret@google.com>
---
 arch/arm64/kvm/hyp/pgtable.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/pgtable.c b/arch/arm64/kvm/hyp/pgtable.c
index 4dff2ad39ee4..59a394d82de3 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -36,6 +36,8 @@
 
 #define KVM_PTE_LEAF_ATTR_HI		GENMASK(63, 51)
 
+#define KVM_PTE_LEAF_ATTR_HI_SW		GENMASK(58, 55)
+
 #define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
 
 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
@@ -44,8 +46,6 @@
 					 KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W | \
 					 KVM_PTE_LEAF_ATTR_HI_S2_XN)
 
-#define KVM_PTE_LEAF_ATTR_S2_IGNORED	GENMASK(58, 55)
-
 #define KVM_INVALID_PTE_OWNER_MASK	GENMASK(63, 56)
 #define KVM_MAX_OWNER_ID		1
 
-- 
2.32.0.432.gabb21c7263-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
