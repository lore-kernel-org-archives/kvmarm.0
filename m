Return-Path: <SRS0=3/sM=BJ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC6B9C433DF
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:34:25 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 54B1620838
	for <kvmarm@archiver.kernel.org>; Thu, 30 Jul 2020 15:34:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZH/oQLHd"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54B1620838
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E7A054B481;
	Thu, 30 Jul 2020 11:34:24 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KXsBufU+RYt1; Thu, 30 Jul 2020 11:34:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 647414B47C;
	Thu, 30 Jul 2020 11:34:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F8624B419
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:34:22 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SBjNQm0h2N0L for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jul 2020 11:34:21 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id CFBB14B3BE
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jul 2020 11:34:20 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3B4D320829;
 Thu, 30 Jul 2020 15:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1596123259;
 bh=avvDhmGN5YEENmQWEvu0ifb5DTujfbvPC6cuJ+c5uvE=;
 h=From:To:Cc:Subject:Date:From;
 b=ZH/oQLHdOh5Oev19+BcsO1nIukAVfYxJHRu/9gs1E1JFxjn0sGgyrNEAAYzUNv1/M
 /bRCeEdWe60tJwdLsFppTCl+/xYbQ2MFAF3YCrVouZQ4qOpgkI4r2OdFP9Tex8eVq0
 mkOTq4gBsNPV/EUby+GCl1HB4hFymEIpkyXd/O/Q=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 00/20] KVM: arm64: Rewrite page-table code and fault handling
Date: Thu, 30 Jul 2020 16:33:46 +0100
Message-Id: <20200730153406.25136-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: kernel-team@android.com, Marc Zyngier <maz@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 linux-arm-kernel@lists.infradead.org
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

This fairly hefty series rewrites all of KVM's page-table code on arm64.

You might be wondering why I've done that, and I can ensure you that it
wasn't for fun. No, some of the benefits of rewriting this code are as
follows:

  * The hypervisor stage-1 and guest stage-2 page tables can now be
    configured at runtime, independently of each other and of the host
    kernel's stage-1 configuration. This allows us to remove the extended
    idmap at EL2 entirely and accept large guest IPA sizes without
    worrying about the number of levels in use by the host.

  * The code is smaller. We're losing ~500 lines with this series, and
    that's in spite of a bunch of kerneldoc being added for the new API.

  * It paves the way for managing the stage-2 page-tables at EL2 on nVHE
    systems, which is a crucial part of the Android "Protected KVM" project,
    which aims to isolate guest memory from the host kernel.

  * In some cases, the new walker allows us to reduce the number of walks
    being performed. For example, user_mem_abort() no longer has to walk
    the page-table twice when handling permission faults.

The series is based on kvmarm/next, plus these two series I sent previously:

  - memcache cleanups:
  https://lore.kernel.org/r/20200723110227.16001-1-will@kernel.org

  - Early S2 fault fixes:
  https://lore.kernel.org/r/20200729102821.23392-1-will@kernel.org

It will conflict with Sean's memcache stuff in -next, but that shouldn't
be too hard to sort out.

I've tried to split up the conversion of kvm/mmu.c into reviewable chunks,
mopping up all the leftover code at the end. That means bisection will
warn about unused functions in the middle of the series, but I think it
makes the changes considerably more focussed and easier to review.

In terms of testing, I've done the usual Debian installer type things, but
Quentin has also written targetted guest code [1] which we used to
exercise dirty logging page-table collapse and coalescing. I also wrote a
silly hack where KVM allocated two S2 page-tables for each VM; one using
the old code and one using the new code. At PSCI SYSTEM_OFF, a walker
walked each page-table, using siphash to create a hash of all of the
entries (but masking out the address fields in table entries). After the
walk, the hashes were compared for the two tables and I have so far been
unable to trigger a mismatch. That said, I haven't really kicked the tyres
outside of defconfig.

To make things easier to work with, I've put the whole lot on a branch
here:

  https://android-kvm.googlesource.com/linux/+/refs/heads/topic/pgtable

Cheers,

Will

[1] https://android-kvm.googlesource.com/misc/+/refs/heads/qperret/pgtable-test

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: kernel-team@android.com
Cc: linux-arm-kernel@lists.infradead.org

--->8

Quentin Perret (4):
  KVM: arm64: Add support for stage-2 write-protect in generic
    page-table
  KVM: arm64: Convert write-protect operation to generic page-table API
  KVM: arm64: Add support for stage-2 cache flushing in generic
    page-table
  KVM: arm64: Convert memslot cache-flushing code to generic page-table
    API

Will Deacon (16):
  KVM: arm64: Add stand-alone page-table walker infrastructure
  KVM: arm64: Add support for creating kernel-agnostic stage-1 page
    tables
  KVM: arm64: Use generic allocator for hyp stage-1 page-tables
  KVM: arm64: Add support for creating kernel-agnostic stage-2 page
    tables
  KVM: arm64: Add support for stage-2 map()/unmap() in generic
    page-table
  KVM: arm64: Convert kvm_phys_addr_ioremap() to generic page-table API
  KVM: arm64: Convert kvm_set_spte_hva() to generic page-table API
  KVM: arm64: Convert unmap_stage2_range() to generic page-table API
  KVM: arm64: Add support for stage-2 page-aging in generic page-table
  KVM: arm64: Convert page-aging and access faults to generic page-table
    API
  KVM: arm64: Add support for relaxing stage-2 perms in generic
    page-table code
  KVM: arm64: Convert user_mem_abort() to generic page-table API
  KVM: arm64: Check the cookie instead of the pgd when modifying
    page-table
  KVM: arm64: Remove unused page-table code
  KVM: arm64: Remove unused 'pgd' field from 'struct kvm_s2_mmu'
  KVM: arm64: Don't constrain maximum IPA size based on host
    configuration

 arch/arm64/include/asm/kvm_host.h       |    2 +-
 arch/arm64/include/asm/kvm_mmu.h        |  219 +---
 arch/arm64/include/asm/kvm_pgtable.h    |  269 ++++
 arch/arm64/include/asm/pgtable-hwdef.h  |   23 -
 arch/arm64/include/asm/pgtable-prot.h   |   19 -
 arch/arm64/include/asm/stage2_pgtable.h |  215 ----
 arch/arm64/kvm/Makefile                 |    2 +-
 arch/arm64/kvm/mmu.c                    | 1549 +++--------------------
 arch/arm64/kvm/pgtable.c                |  906 +++++++++++++
 arch/arm64/kvm/reset.c                  |   38 +-
 10 files changed, 1340 insertions(+), 1902 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_pgtable.h
 create mode 100644 arch/arm64/kvm/pgtable.c

-- 
2.28.0.rc0.142.g3c755180ce-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
