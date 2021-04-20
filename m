Return-Path: <SRS0=sayA=JR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F155EC433B4
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 09:09:49 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 49CC36101E
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 09:09:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49CC36101E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA71D4B37D;
	Tue, 20 Apr 2021 05:09:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0d04zusnSsfo; Tue, 20 Apr 2021 05:09:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D3BDD4B377;
	Tue, 20 Apr 2021 05:09:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 377634B377
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 05:09:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PKPSJ0O-Ap3L for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Apr 2021 05:09:37 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2B3034B319
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 05:09:37 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id CA915611F2;
 Tue, 20 Apr 2021 09:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1618909774;
 bh=TVJDUXhJ6CplL+qBeAb0uQbwAMiGJwKZzeHI/o52vzg=;
 h=From:To:Cc:Subject:Date:From;
 b=WP/6RRsHt1xJ6WubZpF0wiLM/Q+b+naQEzZ9T1AGJ7I0BrkiWYXWhBz4D5la8KdBE
 3tyOyGNKIATejyXsplTnTMyCyjbGuqsDRQtl829ReQkddr0kEaMvfMTFMBM9IwSwpk
 OmOHdm7PwLHL+Z526d1n9TFE5nAWi4VMpSdkFbYMj2qKam5pl60VYuh9eqqyfzVCoT
 hyXIqd2uIG/B7n90ABXMRR6OkADFhavU1Rlbj50ScGK/SJsOEWHkSTkd83uVoC50W2
 Yslw+v/GG2aCgoSGiIMHQYouLKY566vD9Y35qh6bnON6EN5opk/p+7jGlYESv2IgbX
 kEzFt62nV8TLQ==
From: Mike Rapoport <rppt@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v1 0/4] arm64: drop pfn_valid_within() and simplify pfn_valid()
Date: Tue, 20 Apr 2021 12:09:21 +0300
Message-Id: <20210420090925.7457-1-rppt@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, Mike Rapoport <rppt@kernel.org>
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

From: Mike Rapoport <rppt@linux.ibm.com>

Hi,

These patches aim to remove CONFIG_HOLES_IN_ZONE and essentially hardwire
pfn_valid_within() to 1. 

The idea is to mark NOMAP pages as reserved in the memory map and restore
the intended semantics of pfn_valid() to designate availability of struct
page for a pfn.

With this the core mm will be able to cope with the fact that it cannot use
NOMAP pages and the holes created by NOMAP ranges within MAX_ORDER blocks
will be treated correctly even without the need for pfn_valid_within.

The patches are only boot tested on qemu-system-aarch64 so I'd really
appreciate memory stress tests on real hardware.

If this actually works we'll be one step closer to drop custom pfn_valid()
on arm64 altogether.

Changes since RFC
Link: https://lore.kernel.org/lkml/20210407172607.8812-1-rppt@kernel.org

* Add comment about the semantics of pfn_valid() as Anshuman suggested
* Extend comments about MEMBLOCK_NOMAP, per Anshuman
* Use pfn_is_map_memory() name for the exported wrapper for
  memblock_is_map_memory(). It is still local to arch/arm64 in the end
  because of header dependency issues.

Mike Rapoport (4):
  include/linux/mmzone.h: add documentation for pfn_valid()
  memblock: update initialization of reserved pages
  arm64: decouple check whether pfn is in linear map from pfn_valid()
  arm64: drop pfn_valid_within() and simplify pfn_valid()

 arch/arm64/Kconfig              |  3 ---
 arch/arm64/include/asm/memory.h |  2 +-
 arch/arm64/include/asm/page.h   |  1 +
 arch/arm64/kvm/mmu.c            |  2 +-
 arch/arm64/mm/init.c            | 10 ++++++++--
 arch/arm64/mm/ioremap.c         |  4 ++--
 arch/arm64/mm/mmu.c             |  2 +-
 include/linux/memblock.h        |  4 +++-
 include/linux/mmzone.h          | 11 +++++++++++
 mm/memblock.c                   | 28 ++++++++++++++++++++++++++--
 10 files changed, 54 insertions(+), 13 deletions(-)

base-commit: e49d033bddf5b565044e2abe4241353959bc9120
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
