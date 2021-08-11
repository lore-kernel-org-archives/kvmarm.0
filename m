Return-Path: <SRS0=13S2=NC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86D22C4338F
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 17:36:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EA8DE60EB5
	for <kvmarm@archiver.kernel.org>; Wed, 11 Aug 2021 17:36:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org EA8DE60EB5
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5517849FE6;
	Wed, 11 Aug 2021 13:36:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, body has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WYlbJL8DwFBe; Wed, 11 Aug 2021 13:36:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 618A44A193;
	Wed, 11 Aug 2021 13:36:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACECC4A003
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 13:36:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Av02YJmgYNL1 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 11 Aug 2021 13:36:42 -0400 (EDT)
Received: from mail-qv1-f74.google.com (mail-qv1-f74.google.com
 [209.85.219.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9826649FE6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 13:36:42 -0400 (EDT)
Received: by mail-qv1-f74.google.com with SMTP id
 r14-20020a0c8d0e0000b02902e82df307f0so1213658qvb.4
 for <kvmarm@lists.cs.columbia.edu>; Wed, 11 Aug 2021 10:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to;
 bh=600BfGro66ckGcCtHLsSTcvyovy+Yar8dj0tkkGK880=;
 b=L+p6M06P/C3C4ui9FQhMOHTPxJm2qikZ+jN5iqIhJgZmcX5ah7c+7XLdhiHBoQrqr5
 AeOGSAdoKCTLhHfpfnfPyRyHtFjiqcizVH+aY3LSl3A/4LQVRjG1aMVmBugLHTJlXKk0
 +g5t3jqDcQMw7giIw6Mb88GJreFp5SdVeQl0RZvMPXB3a4F8AAtLT8YYyM8IQgi3k/Ea
 NEGEmj1CnkvmyNpXuVr6XDvrdqgmFluMY9uhkWp43QnRy8deagM2lKVHMomSadhQQfd+
 svhMqj8K7ffp2UB+w5bU6499e6R4myay6uPMvzAs1JW3WpgezHuWetkNKmHDst3NTgrU
 UcQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to;
 bh=600BfGro66ckGcCtHLsSTcvyovy+Yar8dj0tkkGK880=;
 b=XoWlF3LWKC1VgbZsXZjC0eiKc2fcHkuvuXt8PZ0a1DJB+FwCgRrbICTwhnKWsETcoN
 SvgNTnxMu9uFKHP6gfm9z8vqfsTyfPlP95p8wKNfi/ARE3FS2AVXkkBuQCQi2VeEk6Wv
 4EE4Ka+EDDJjUmV+UxuKXKK8sJ7m7U+wo+SXGJ1aDmmP8U9fz3pIlJthrtslTJI4g/kZ
 TIJ+rmsvrxa/QueRAjwVLGXowQP2cK08CE3XQcXSASQfl0Dntyct7BJcoUa9KjL2iK/1
 7WQSJfGO2CJsjf1Y6ct5iFrX2dlmpBtGCDyaSKxcOSJga2uxPRdl+4rEaUdcW0Q7u2/L
 O4lQ==
X-Gm-Message-State: AOAM531tHlYMCA+DS0ttyp+m/8XQ47v3rsJRk9BUTWPt+z3QGWUh29Cw
 trXAa4pJCzG1c9yvbUT69Oz59lwtiqVD
X-Google-Smtp-Source: ABdhPJwPXKpSpNhuMaTz2hv19f1ZPNoKVo1Bsp9I8bXQZmXjrv7ZMQNSoNx0s8MSeYAAj6++CqBzRXIlgBVK
X-Received: from luke.lon.corp.google.com
 ([2a00:79e0:d:210:43fd:e634:73d9:e10e])
 (user=qperret job=sendgmr) by 2002:ad4:45a8:: with SMTP id
 y8mr20692593qvu.49.1628703402006; Wed, 11 Aug 2021 10:36:42 -0700 (PDT)
Date: Wed, 11 Aug 2021 18:36:25 +0100
Message-Id: <20210811173630.2536721-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.605.g8dce9f2422-goog
Subject: [PATCH] KVM: arm64: Return -EPERM from __pkvm_host_share_hyp()
From: Quentin Perret <qperret@google.com>
To: Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Quentin Perret <qperret@google.com>, Fuad Tabba <tabba@google.com>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, 
 linux-kernel@vger.kernel.org
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

Fix the error code returned by __pkvm_host_share_hyp() when the
host attempts to share with EL2 a page that has already been shared with
another entity.

Reported-by: Will Deacon <will@kernel.org>
Signed-off-by: Quentin Perret <qperret@google.com>
---
This patch fixes a bug introduced in the stage-2 ownership series which
is already queued in kvmarm/next:

https://lore.kernel.org/lkml/20210809152448.1810400-1-qperret@google.com/

I've starred at this code for hours, but that clearly was not enough. Oh
well ...
---
 arch/arm64/kvm/hyp/nvhe/mem_protect.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/mem_protect.c b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
index 8165390d3ec9..6ec695311498 100644
--- a/arch/arm64/kvm/hyp/nvhe/mem_protect.c
+++ b/arch/arm64/kvm/hyp/nvhe/mem_protect.c
@@ -404,7 +404,7 @@ int __pkvm_host_share_hyp(u64 pfn)
 	cur = kvm_pgtable_hyp_pte_prot(pte);
 	prot = pkvm_mkstate(PAGE_HYP, PKVM_PAGE_SHARED_BORROWED);
 	if (!check_prot(cur, prot, ~prot))
-		ret = EPERM;
+		ret = -EPERM;
 	goto unlock;
 
 map_shared:
-- 
2.32.0.605.g8dce9f2422-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
