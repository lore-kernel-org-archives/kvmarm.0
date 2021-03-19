Return-Path: <SRS0=Zs50=IS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0953C433E0
	for <kvmarm@archiver.kernel.org>; Sat, 20 Mar 2021 13:28:57 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 46B3461966
	for <kvmarm@archiver.kernel.org>; Sat, 20 Mar 2021 13:28:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46B3461966
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D6E0C4B43E;
	Sat, 20 Mar 2021 09:28:56 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id yR0WWf3ZhOWK; Sat, 20 Mar 2021 09:28:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5E2D84B286;
	Sat, 20 Mar 2021 09:28:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 015454B606
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 12:18:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5ISm2BQ5o3ET for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 12:17:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C52264B5E6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 12:17:58 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F35EA31B;
 Fri, 19 Mar 2021 09:17:57 -0700 (PDT)
Received: from yoan-MS-7758.Home (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id A17803F718;
 Fri, 19 Mar 2021 09:17:56 -0700 (PDT)
From: Yoan Picchi <yoan.picchi@arm.com>
To: maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH 0/7] KVM: arm64: add more event counters for kvm_stat
Date: Fri, 19 Mar 2021 16:17:04 +0000
Message-Id: <20210319161711.24972-1-yoan.picchi@arm.com>
X-Mailer: git-send-email 2.17.1
X-Mailman-Approved-At: Sat, 20 Mar 2021 09:28:53 -0400
Cc: catalin.marinas@arm.com, Yoan Picchi <yoan.picchi@arm.com>, will@kernel.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Hi all,

As mentioned in the KVM forum talk from 2019 
(https://kvmforum2019.sched.com/event/Tmwf/kvmstat-and-beyond-past-present-and-future-of-performance-monitoring-christian-borntrager-ibm page 10),
there is few event counters for kvm_stat in the arm64 version of kvm when
you compare it to something like the x86 version.
Those counters are used in kvm_stat by kernel/driver developers to
have a rough idea of the impact of their patches on the general performance.
An example would be to make sure a patch don't increase to much the amount
of interruptions. Those patches aim to add more counters to make the use of
kvm_stat more relevant when measuring performance impact.

I am new in working on kernel-related things and I am learning kvm as I go.
Some of the counter I added early (memory_slot_unmaped, stage2_unmap_vm)
no longer seems relevant because while they do interesting things, they
happens in very specific scenarios. Instead of just deleting them, I prefer
to ask weither a little-used counter or no counter is the best.
I can also use some suggestion on how to test those counters as some like 
remote_tlb_flush which mostly happen when fixing up a race condition; or
what uncovered event could be worth adding in a future patch set.

Yoan Picchi (7):
  KVM: arm64: Add two page mapping counters for kvm_stat
  KVM: arm64: Add remote_tlb_flush counter for kvm_stat
  KVM: arm64: Add cached_page_invalidated counter for kvm_stat
  KVM: arm64: Add flush_all_cache_lines counter for kvm_stat
  KVM: arm64: Add memory_slot_unmaped counter for kvm_stat
  KVM: arm64: Add stage2_unmap_vm counter for kvm_stat
  KVM: arm64: Add irq_inject counter for kvm_stat

 arch/arm64/include/asm/kvm_host.h |  8 ++++++++
 arch/arm64/kvm/arm.c              |  2 ++
 arch/arm64/kvm/guest.c            |  9 +++++++++
 arch/arm64/kvm/mmu.c              | 27 ++++++++++++++++++++++++++-
 arch/arm64/kvm/vgic/vgic.c        |  2 ++
 5 files changed, 47 insertions(+), 1 deletion(-)

-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
