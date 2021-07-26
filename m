Return-Path: <SRS0=fiTO=MS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CBE0C432BE
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 3EFB160F52
	for <kvmarm@archiver.kernel.org>; Mon, 26 Jul 2021 09:29:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 3EFB160F52
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E6F9D49F5D;
	Mon, 26 Jul 2021 05:29:27 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id qnyzg7k6mCqa; Mon, 26 Jul 2021 05:29:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 092524A4CD;
	Mon, 26 Jul 2021 05:29:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 36D604A319
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CFC5hKdR27p1 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 26 Jul 2021 05:29:25 -0400 (EDT)
Received: from mail-wr1-f73.google.com (mail-wr1-f73.google.com
 [209.85.221.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0DD074A483
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 05:29:23 -0400 (EDT)
Received: by mail-wr1-f73.google.com with SMTP id
 v18-20020adfe2920000b029013bbfb19640so4463363wri.17
 for <kvmarm@lists.cs.columbia.edu>; Mon, 26 Jul 2021 02:29:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=xLHFWhuaosj6mgx+BXw5wN11Ic3FuxfIig998pTjIIc=;
 b=L9NlMkGjnx/9vx5Zya428co80U3Z2zbDCQLn8xzTXUsTLyQSWWGmcSo3KOQsDM9tun
 gkbXLLdNGv/H8zmepyiFOjmTJqSPwxzvWiQDZNMPxesdKwZv63J00lJ050+AyLJd7prc
 LCNMi7oofPMTRj12y9X8R1JJKUERjyj7lY2e1qtZZoW7qVzrFyBgCRtzYMz46yZKycjG
 HDlP7DcejUKaphuW7w1QCXKWochGfRtFuNGEH3poHzXLjIKnBbNe3p1nQ5KItcuF8gub
 YwRPeAdiLvNHz/owaoGbrv/kYiCdNGXorjPhq74Rczi8BB7POlnwIJyUdI33/SvPcmUF
 8ihA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=xLHFWhuaosj6mgx+BXw5wN11Ic3FuxfIig998pTjIIc=;
 b=CUG5abKAyjAHgeuPWb3Rka6+M8cV67DFZikiP6jJeT2gR/k8hCyk+F1M0NJUMkUZ+d
 ZWEQLAaRvC/AB2ysY40fVdv5PQ6u6NX7+pKXDwmqnQJnd1gv5K/MlyrwHWfPsOo9GjZc
 7EBAmtSNXxtJfWjMttW0tsSDwyVlpY0lLyzBz9qqKtNgXJbmIDbofxlJNLtvSpGZpm39
 1ehlSx/UyUi1uH9+ZzKPO0LA/Fq2m0fESDuABdziypK5t0YyqpLBTWEwaBLU1AMDSUfE
 a5McTPTmxcPDs8DM1y6qIYRF+RU8ChZbD3c415f7A2y01n6b4yPWT/c/9tR4IhUUn2ZZ
 uicQ==
X-Gm-Message-State: AOAM530AR4fqa9KvODvqeOGoGEn9LhuBtgRG/sME5l8WUA0KuGZu7Yhe
 eqoqn5PfJYRceP1UBWUnTrUJBMxC42Gg
X-Google-Smtp-Source: ABdhPJxgHTVLPDvaEjvcrmQ9zRhiX1DsEcG3LQTts/yU9YAi0Km3deA725PoMri/xgk5EjXL/D8h91KlNlZc
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:23a0:2f14:433:e6cb])
 (user=qperret job=sendgmr) by 2002:a05:6000:2a1:: with SMTP id
 l1mr17703329wry.128.1627291762209; Mon, 26 Jul 2021 02:29:22 -0700 (PDT)
Date: Mon, 26 Jul 2021 10:28:54 +0100
In-Reply-To: <20210726092905.2198501-1-qperret@google.com>
Message-Id: <20210726092905.2198501-6-qperret@google.com>
Mime-Version: 1.0
References: <20210726092905.2198501-1-qperret@google.com>
X-Mailer: git-send-email 2.32.0.432.gabb21c7263-goog
Subject: [PATCH v2 05/16] KVM: arm64: Rename KVM_PTE_LEAF_ATTR_S2_IGNORED
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
index 55199e579863..516c1b8ce6b8 100644
--- a/arch/arm64/kvm/hyp/pgtable.c
+++ b/arch/arm64/kvm/hyp/pgtable.c
@@ -39,6 +39,8 @@
 
 #define KVM_PTE_LEAF_ATTR_HI		GENMASK(63, 51)
 
+#define KVM_PTE_LEAF_ATTR_HI_SW		GENMASK(58, 55)
+
 #define KVM_PTE_LEAF_ATTR_HI_S1_XN	BIT(54)
 
 #define KVM_PTE_LEAF_ATTR_HI_S2_XN	BIT(54)
@@ -47,8 +49,6 @@
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
