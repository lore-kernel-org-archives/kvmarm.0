Return-Path: <SRS0=nct1=JE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABA7EC433B4
	for <kvmarm@archiver.kernel.org>; Wed,  7 Apr 2021 17:26:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 1F1F96128D
	for <kvmarm@archiver.kernel.org>; Wed,  7 Apr 2021 17:26:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1F1F96128D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A196E4B942;
	Wed,  7 Apr 2021 13:26:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id wInoB3H6it4b; Wed,  7 Apr 2021 13:26:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D8F84B944;
	Wed,  7 Apr 2021 13:26:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CCA6D4B942
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Apr 2021 13:26:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id jzn-vsV7Gfzz for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Apr 2021 13:26:42 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DFBE94B93C
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Apr 2021 13:26:41 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1CB761245;
 Wed,  7 Apr 2021 17:26:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1617816400;
 bh=X0TznhRQ1rNxYkaGVTvSVgcMdtW1s20eY3i7PGc1DyI=;
 h=From:To:Cc:Subject:Date:From;
 b=kIKMCnKJHZUhcF0j7TRm268bp2eLc+q8uBA03fX/4M51X2fyLiGbYbJgsb9Uo6I21
 HPBaSbHjaY8Mt3/O+jXaBNnl3BEfPKofjxGs0J75TytOzfeyrX0HvfdhsOZPqUkttf
 Fgy+TmPa8WFe0YIEAphXWes1GOYabuwCcpMq7ZNwXyik97KHKI+djm/2MmvE77Rvdh
 vj6VilT6ua5X/fbpSGuFEuS+maCIfhyV4iKeBsfNa1No+2Z3MtRYTEBE9SkwsE9EnL
 nz6LnCgVALJzCe0wx0D5RN8cd6PH273SeFkyj0yLGbNbbzxsOCgrxMG6SjEeW5+yE8
 ka5t4bs9ftKMg==
From: Mike Rapoport <rppt@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [RFC/RFT PATCH 0/3] arm64: drop pfn_valid_within() and simplify
 pfn_valid()
Date: Wed,  7 Apr 2021 20:26:04 +0300
Message-Id: <20210407172607.8812-1-rppt@kernel.org>
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

Mike Rapoport (3):
  memblock: update initialization of reserved pages
  arm64: decouple check whether pfn is normal memory from pfn_valid()
  arm64: drop pfn_valid_within() and simplify pfn_valid()

 arch/arm64/Kconfig              |  3 ---
 arch/arm64/include/asm/memory.h |  2 +-
 arch/arm64/include/asm/page.h   |  1 +
 arch/arm64/kvm/mmu.c            |  2 +-
 arch/arm64/mm/init.c            | 10 ++++++++--
 arch/arm64/mm/ioremap.c         |  4 ++--
 arch/arm64/mm/mmu.c             |  2 +-
 mm/memblock.c                   | 23 +++++++++++++++++++++--
 8 files changed, 35 insertions(+), 12 deletions(-)


base-commit: e49d033bddf5b565044e2abe4241353959bc9120
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
