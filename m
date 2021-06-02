Return-Path: <SRS0=fRMP=K4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9757C47092
	for <kvmarm@archiver.kernel.org>; Wed,  2 Jun 2021 09:44:01 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 67E4E613EA
	for <kvmarm@archiver.kernel.org>; Wed,  2 Jun 2021 09:44:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67E4E613EA
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D5F3449F8F;
	Wed,  2 Jun 2021 05:44:00 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Tky3kW9Wfs1B; Wed,  2 Jun 2021 05:43:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E429A49F92;
	Wed,  2 Jun 2021 05:43:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D45AA406E0
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 05:43:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sxM9jo6uqWqu for <kvmarm@lists.cs.columbia.edu>;
 Wed,  2 Jun 2021 05:43:53 -0400 (EDT)
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com
 [209.85.208.74])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0C7F54066E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  2 Jun 2021 05:43:53 -0400 (EDT)
Received: by mail-ed1-f74.google.com with SMTP id
 s18-20020a0564020372b029038febc2d475so1080592edw.3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 02 Jun 2021 02:43:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:message-id:mime-version:subject:from:to:cc;
 bh=PXs9u6dzCmMe63YEsmhUrb93h0mWmoLs1gTxAQd7MEA=;
 b=oPgorK2YXYRV0NwbupNNErxxwaXHhcqOGNqd8VNe+P/7Nj5Uz7T7moZyrqR/KdQp5E
 iUOHFTmYLgjY+7moRvw+AKjjV2DBSZUDC7d+1Zn2fjOJu8WVLJq6Eq0T+m9uNQZE4Qdv
 68oufbungBm2FDwfThF94Fvb51/PTNHpNr0PqVJDP9Fai7qCvEORLB+XK0FZ+6MpTuKx
 w42/J0YFONYdkPPmysoMeWv9wfLLp7FgmZskg3IHlybRnVZD3yizxXzCveGebPdlVIaf
 kDua8A5CGclwlqWaUqvjFXuwm+AlAFlwyuDMET2h9JWGKzOlnh2KLZl9vpYdpX0KKae+
 G4XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
 bh=PXs9u6dzCmMe63YEsmhUrb93h0mWmoLs1gTxAQd7MEA=;
 b=C+tEbAEWjJBpKHm0pB8R6nAEFEf28gLvLRr87+dfLXjxSh7ljgTylH8Vh22cksEeds
 wpDFR4CPVURPaXop5oQ/DVgDZ6izy78USF2er+3mUPu8+aTLU1EjgIgtj1EjI62FZMuR
 gY8VV8oilbnQPlWjhm4MGOptty8P6bG+nM2JFbtJu8U6fbNyJ1+v0tr51oi0cZHkzUDr
 4VPIIvqAMEmJPryT+TDGUnsvK3klBdwDIAiLc0HqqsJRTCqk3IibD5BsNByha5B9H3ve
 RuEHsVeEeOXekBh9TB8GizGhJiofUQIwkl3Dp/64hEiaph46NPU9hT+zWO+yodI0CEF3
 I3HA==
X-Gm-Message-State: AOAM530RLBhMAJVEcZSkyvu9ph3Kc11ZGd+NFkiMnGjlXeqvmrpuPCFQ
 UQWqKOlZ5bZEvvsmq5CHVnSZXHigoind
X-Google-Smtp-Source: ABdhPJwI732qm8er6IebqhgRNDcxCaKLRuDj57CyEYHgzxVlmlFpf/MCKV1O0VnL1RhgrhvYbef7nwiw583Q
X-Received: from r2d2-qp.c.googlers.com
 ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:aa7:d893:: with SMTP id
 u19mr38230483edq.258.1622627031729; Wed, 02 Jun 2021 02:43:51 -0700 (PDT)
Date: Wed,  2 Jun 2021 09:43:40 +0000
Message-Id: <20210602094347.3730846-1-qperret@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
Subject: [PATCH v2 0/7] KVM: arm64: Reduce hyp_vmemmap overhead
From: Quentin Perret <qperret@google.com>
To: maz@kernel.org, will@kernel.org, james.morse@arm.com, 
 alexandru.elisei@arm.com, catalin.marinas@arm.com, suzuki.poulose@arm.com
Cc: kernel-team@android.com, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
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

Hi all,

This is a v2 of the patch series previously posted here:

  https://lore.kernel.org/r/20210527125134.2116404-1-qperret@google.com/

Please refer to the cover letter of v1 for the context and motivation
behind the series.

Changes since v1:
 - Added comment/doc in page_alloc.c explaining the locking expectations;
 - Removed unnecessary casts in the 'page-to-list-node' helpers;
 - A few other cosmetic changes in the allocator.

Thanks,
Quentin

Quentin Perret (7):
  KVM: arm64: Move hyp_pool locking out of refcount helpers
  KVM: arm64: Use refcount at hyp to check page availability
  KVM: arm64: Remove list_head from hyp_page
  KVM: arm64: Unify MMIO and mem host stage-2 pools
  KVM: arm64: Remove hyp_pool pointer from struct hyp_page
  KVM: arm64: Use less bits for hyp_page order
  KVM: arm64: Use less bits for hyp_page refcount

 arch/arm64/kvm/hyp/include/nvhe/gfp.h         |  45 +------
 arch/arm64/kvm/hyp/include/nvhe/mem_protect.h |   2 +-
 arch/arm64/kvm/hyp/include/nvhe/memory.h      |   7 +-
 arch/arm64/kvm/hyp/include/nvhe/mm.h          |  13 +-
 arch/arm64/kvm/hyp/nvhe/mem_protect.c         |  60 +++++-----
 arch/arm64/kvm/hyp/nvhe/page_alloc.c          | 112 +++++++++++++-----
 arch/arm64/kvm/hyp/nvhe/setup.c               |  30 +++--
 arch/arm64/kvm/hyp/reserved_mem.c             |   3 +-
 8 files changed, 145 insertions(+), 127 deletions(-)

-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
