Return-Path: <SRS0=pwNx=IP=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5144AC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 14:17:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 99DB564F38
	for <kvmarm@archiver.kernel.org>; Wed, 17 Mar 2021 14:17:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 99DB564F38
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E3B084B65D;
	Wed, 17 Mar 2021 10:17:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id vgoM3LnGmsfQ; Wed, 17 Mar 2021 10:17:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E060B4B654;
	Wed, 17 Mar 2021 10:17:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F7D04B652
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 10:17:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3aqIikk6U3ty for <kvmarm@lists.cs.columbia.edu>;
 Wed, 17 Mar 2021 10:17:18 -0400 (EDT)
Received: from mail-qt1-f201.google.com (mail-qt1-f201.google.com
 [209.85.160.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7B63B4B5FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 10:17:18 -0400 (EDT)
Received: by mail-qt1-f201.google.com with SMTP id s14so5076746qtw.20
 for <kvmarm@lists.cs.columbia.edu>; Wed, 17 Mar 2021 07:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=KrfxD88Ict/v6ngLTLvsT+oMLpFGTSrf7Eslq0SGM14=;
 b=a+nv8X7pyir1+SV83VwUJ4vj+AHhzDv9PQ9WnWuQqlWQwiB8a746kscytqy4ej1iuw
 eyas/id66NAzXCPbs1TSyWUPg0J1tAfqygJ563ZEyLL86DAMxCXR1eoiH5rVUm6wwKsN
 crGLP6vZayX2cQNy4hcQz8SC03UJwBdpmg407s9BSCKHMY6GoXRntodV5QOCc7JdoIdV
 zhW+OWR5QMi/4VcTh3g3DTA6Q8Q2/Z/aXggxBg1pEDZVGOiCxDLIZZoC5Se7sXzaEtjn
 pr0I3chBsy50GvwK9oKIj76iUUqJwg6uv+nTrysi6egixhFVdjdZQzkMPVQ/2bWl5qLl
 Dfqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=KrfxD88Ict/v6ngLTLvsT+oMLpFGTSrf7Eslq0SGM14=;
 b=BITwGO8NWdGbO7K5XZT4HaWrn6PBTZ9wA+1k+xGZpsxYNYyDstYnOlzH1pj1wXACjj
 IeZO3CExUvf+9VjuOtwidPS7nbeT2pPxGwMQXBhOHNlhfgDjcYFr0kY+tfIVvXCeQxHC
 EBVyFsT8m2/tRqCdetWMeNaxELavuwuoZqUbIaRas5ckNNnRIV5CVe/K6mab4B8Y+GNf
 wIRz2TIYFHRplfNosFc3pMcDWiQ1CtJv+7gqq6U3hepHQeKhMn20zJZjkiwOWJ1afFr2
 I2qIK51chIdiUw+QaU2qGdjL4sPsTF4w019qkIWm7chH0kUxAEu7hkF0V5ZNMezF2nce
 MrbA==
X-Gm-Message-State: AOAM530eif6ji69VNeerrvN4yXXos7cx1pnIC8M/w6V+RnLGe1One6B1
 fsamterbueanfFqDYSaO0+z0pa90HCJf
X-Google-Smtp-Source: ABdhPJzkVS1O87T4WUzd78oVRcatodCw8tdcjCnylMKpUhZ05gMFuwQ7e3RhsN9PT90TU72c/bE143W9PeYp
X-Received: from r2d2-qp.c.googlers.com ([fda3:e722:ac3:10:28:9cb1:c0a8:1652])
 (user=qperret job=sendgmr) by 2002:ad4:472d:: with SMTP id
 l13mr5273536qvz.17.1615990637862; Wed, 17 Mar 2021 07:17:17 -0700 (PDT)
Date: Wed, 17 Mar 2021 14:17:12 +0000
In-Reply-To: <20210315143536.214621-34-qperret@google.com>
Message-Id: <20210317141714.383046-1-qperret@google.com>
Mime-Version: 1.0
References: <20210315143536.214621-34-qperret@google.com>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
Subject: [PATCH 0/2] Fixes for FWB
From: Quentin Perret <qperret@google.com>
To: qperret@google.com
Cc: kernel-team@android.com, android-kvm@google.com, catalin.marinas@arm.com,
 mate.toth-pal@arm.com, seanjc@google.com, tabba@google.com,
 linux-kernel@vger.kernel.org, robh+dt@kernel.org,
 linux-arm-kernel@lists.infradead.org, maz@kernel.org, will@kernel.org,
 kvmarm@lists.cs.columbia.edu
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

Hi folks,

This is an alternative solution to the KVM_PGTABLE_PROT_S2_NOFWB patch I
shared earlier (and which is a bit of a hack).

With this series we basically force FWB off for the host stage-2, even
when the CPUs support it. This is done by passing flags to the pgtable
init function, and propagating it down where needed. It's a bit more
intrusive, but cleaner conceptually.

Thoughts?

Thanks,
Quentin

Quentin Perret (2):
  KVM: arm64: Introduce KVM_PGTABLE_S2_NOFWB Stage-2 flag
  KVM: arm64: Disable FWB in host stage-2

 arch/arm64/include/asm/kvm_pgtable.h  | 19 +++++++++--
 arch/arm64/include/asm/pgtable-prot.h |  4 +--
 arch/arm64/kvm/hyp/nvhe/mem_protect.c |  6 ++--
 arch/arm64/kvm/hyp/pgtable.c          | 49 +++++++++++++++++----------
 4 files changed, 52 insertions(+), 26 deletions(-)

-- 
2.31.0.rc2.261.g7f71774620-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
