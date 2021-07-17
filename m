Return-Path: <SRS0=Kzo3=MJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.0 required=3.0 tests=BAYES_00,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40073C636C9
	for <kvmarm@archiver.kernel.org>; Sat, 17 Jul 2021 09:56:17 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C212B613D8
	for <kvmarm@archiver.kernel.org>; Sat, 17 Jul 2021 09:56:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C212B613D8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 73F304B0D5;
	Sat, 17 Jul 2021 05:56:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Th3LhE+0ad6B; Sat, 17 Jul 2021 05:56:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0D0824B0E0;
	Sat, 17 Jul 2021 05:56:14 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DB9BB4B0D9
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Jul 2021 05:56:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vJDQMlJn0UGu for <kvmarm@lists.cs.columbia.edu>;
 Sat, 17 Jul 2021 05:56:11 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D968549D50
 for <kvmarm@lists.cs.columbia.edu>; Sat, 17 Jul 2021 05:56:11 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id D2EE7613D4;
 Sat, 17 Jul 2021 09:56:10 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1m4h3I-00DvkH-QK; Sat, 17 Jul 2021 10:56:08 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org
Subject: [PATCH 0/5] KVM: Remove kvm_is_transparent_hugepage() and friends
Date: Sat, 17 Jul 2021 10:55:36 +0100
Message-Id: <20210717095541.1486210-1-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-mm@kvack.org, seanjc@google.com,
 willy@infradead.org, pbonzini@redhat.com, will@kernel.org, qperret@google.com,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Sean Christopherson <seanjc@google.com>,
 Matthew Wilcox <willy@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>,
 Will Deacon <will@kernel.org>
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

A while ago, Willy and Sean pointed out[1] that arm64 is the last user
of kvm_is_transparent_hugepage(), and that there would actually be
some benefit in looking at the userspace mapping directly instead.

This small series does exactly that, although it doesn't try to
support more than a PMD-sized mapping yet for THPs. We could probably
look into unifying this with the huge PUD code, and there is still
some potential use of the contiguous hint.

As a consequence, it removes kvm_is_transparent_hugepage(),
PageTransCompoundMap() and kvm_get_pfn(), all of which have no user
left after this rework.

This has been lightly tested on an Altra box. Although nothing caught
fire, it requires some careful reviewing on the arm64 side.

[1] https://lore.kernel.org/r/YLpLvFPXrIp8nAK4@google.com

Marc Zyngier (5):
  KVM: arm64: Walk userspace page tables to compute the THP mapping size
  KVM: arm64: Avoid mapping size adjustment on permission fault
  KVM: Remove kvm_is_transparent_hugepage() and PageTransCompoundMap()
  KVM: arm64: Use get_page() instead of kvm_get_pfn()
  KVM: Get rid of kvm_get_pfn()

 arch/arm64/kvm/mmu.c       | 57 +++++++++++++++++++++++++++++++++-----
 include/linux/kvm_host.h   |  1 -
 include/linux/page-flags.h | 37 -------------------------
 virt/kvm/kvm_main.c        | 19 +------------
 4 files changed, 51 insertions(+), 63 deletions(-)

-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
