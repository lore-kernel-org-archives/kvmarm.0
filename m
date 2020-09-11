Return-Path: <SRS0=CMxQ=CU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21163C433E2
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 13:25:43 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 783EE22224
	for <kvmarm@archiver.kernel.org>; Fri, 11 Sep 2020 13:25:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1NC+k8Xw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 783EE22224
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D9AB24B359;
	Fri, 11 Sep 2020 09:25:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id G+a5cwUOhf0a; Fri, 11 Sep 2020 09:25:39 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A3DFB4B346;
	Fri, 11 Sep 2020 09:25:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0319B4B2BC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 09:25:39 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QUXtR0NicPoI for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 Sep 2020 09:25:37 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B89194B29F
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 Sep 2020 09:25:37 -0400 (EDT)
Received: from localhost.localdomain (236.31.169.217.in-addr.arpa
 [217.169.31.236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id AA515221E7;
 Fri, 11 Sep 2020 13:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1599830736;
 bh=Th8A29FA5bf6LRE4qRi4qUHGGZelP8ofabVVMxsX9GE=;
 h=From:To:Cc:Subject:Date:From;
 b=1NC+k8Xwub06Psg2MXjdJQmTpgd+8QQckeOxptsUPar6hPITt8IYTme+Y0WkbMPDX
 DA1zXC+Lj0kSFFY2tXVsDtff5ZOiA5njs1jpdhG62qeo0gd2O9NRNSjOSG/LK8i45I
 cTrdG+pQVzYQDPtCstPR0BA564FBQYnIRm4hslMQ=
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v5 00/21] KVM: arm64: Rewrite page-table code and fault
 handling
Date: Fri, 11 Sep 2020 14:25:08 +0100
Message-Id: <20200911132529.19844-1-will@kernel.org>
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

It's me again, with version five of the KVM page-table rework previously
seen at:

  v1: https://lore.kernel.org/r/20200730153406.25136-1-will@kernel.org
  v2: https://lore.kernel.org/r/20200818132818.16065-1-will@kernel.org
  v3: https://lore.kernel.org/r/20200825093953.26493-1-will@kernel.org
  v4: https://lore.kernel.org/r/20200907152344.12978-1-will@kernel.org

Changes since v4 include:

  * Add comments to the kerneldoc describing alignment behaviour for
    addresses and size parameters
  * Fix formatting of IPA size messages
  * Fix handling of unaligned addresses in kvm_phys_addr_ioremap()
  * Add DSB after zeroing stage-2 PGD pages
  * Add reviewer tags

Once again, thanks to Alex, Gavin and Andrew for their comments.

Will

Cc: Marc Zyngier <maz@kernel.org>
Cc: Quentin Perret <qperret@google.com>
Cc: James Morse <james.morse@arm.com>
Cc: Suzuki Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Gavin Shan <gshan@redhat.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Andrew Scull <ascull@google.com>
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

Will Deacon (17):
  KVM: arm64: Remove kvm_mmu_free_memory_caches()
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
  KVM: arm64: Check the pgt instead of the pgd when modifying page-table
  KVM: arm64: Remove unused page-table code
  KVM: arm64: Remove unused 'pgd' field from 'struct kvm_s2_mmu'
  KVM: arm64: Don't constrain maximum IPA size based on host
    configuration

 arch/arm64/include/asm/kvm_host.h       |    2 +-
 arch/arm64/include/asm/kvm_mmu.h        |  251 +---
 arch/arm64/include/asm/kvm_pgtable.h    |  309 ++++
 arch/arm64/include/asm/pgtable-hwdef.h  |   24 -
 arch/arm64/include/asm/pgtable-prot.h   |   19 -
 arch/arm64/include/asm/stage2_pgtable.h |  215 ---
 arch/arm64/kvm/arm.c                    |    2 +-
 arch/arm64/kvm/hyp/Makefile             |    2 +-
 arch/arm64/kvm/hyp/pgtable.c            |  883 ++++++++++++
 arch/arm64/kvm/mmu.c                    | 1748 ++++-------------------
 arch/arm64/kvm/reset.c                  |   40 +-
 11 files changed, 1479 insertions(+), 2016 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_pgtable.h
 create mode 100644 arch/arm64/kvm/hyp/pgtable.c

-- 
2.28.0.618.gf4bc123cb7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
