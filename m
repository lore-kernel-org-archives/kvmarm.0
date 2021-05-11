Return-Path: <SRS0=u/VZ=KG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D26DC433ED
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 10:06:05 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 51A2161936
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 10:06:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 51A2161936
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C053F4B39D;
	Tue, 11 May 2021 06:06:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2H6nzcyAsG8s; Tue, 11 May 2021 06:06:02 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FE924B4B3;
	Tue, 11 May 2021 06:06:02 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 68C6B4B4AF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 06:06:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id vZSY2OwjlZ7Q for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 May 2021 06:06:00 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3A9AD4B39D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 06:06:00 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F60861360;
 Tue, 11 May 2021 10:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1620727558;
 bh=RlNaQugaThbhHxZD0Bx4H5Pc9CrWxAqv0CUHIawYkSk=;
 h=From:To:Cc:Subject:Date:From;
 b=GmY0r1IkW3ZeGuFPesJIUk10G0bmFN6ceybj46DtgYlzYIMqRRPbswUKdNL2jBhnW
 l/ZvckzitBi4O5D1xMtId10RQRWtXmuPJLUMCooqUixyjZ+ggFmUWAhjBsNaCElc9T
 8wGcvvublT2SaDT1c2KzMw4yGHJjHtzf0/joh0h/IYIYiAZXdKtEjzbQlET6xexDL2
 o7etoJtcP0gOwdCLxDTBw00jI+Plg4iKtTu7BUlIIKrx87a1VRUXOjiwz8C0FoMU2E
 Ld0dMkYL/WSB7Z03xxLA93T3VBfMtc6LT4gd27sv43Kgy32Oz/AIIeG+V3yk7vWNyV
 ERDgF+e43XDbg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v4 0/4] arm64: drop pfn_valid_within() and simplify pfn_valid()
Date: Tue, 11 May 2021 13:05:46 +0300
Message-Id: <20210511100550.28178-1-rppt@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
 Mike Rapoport <rppt@kernel.org>
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

The patches are boot tested on qemu-system-aarch64.

I beleive it would be best to route these via mmotm tree.

v4:
* rebase on v5.13-rc1

v3: Link: https://lore.kernel.org/lkml/20210422061902.21614-1-rppt@kernel.org
* Fix minor issues found by Anshuman
* Freshen up the declaration of pfn_valid() to make it consistent with
  pfn_is_map_memory()
* Add more Acked-by and Reviewed-by tags, thanks Anshuman and David

v2: Link: https://lore.kernel.org/lkml/20210421065108.1987-1-rppt@kernel.org
* Add check for PFN overflow in pfn_is_map_memory()
* Add Acked-by and Reviewed-by tags, thanks David.

v1: Link: https://lore.kernel.org/lkml/20210420090925.7457-1-rppt@kernel.org
* Add comment about the semantics of pfn_valid() as Anshuman suggested
* Extend comments about MEMBLOCK_NOMAP, per Anshuman
* Use pfn_is_map_memory() name for the exported wrapper for
  memblock_is_map_memory(). It is still local to arch/arm64 in the end
  because of header dependency issues.

rfc: Link: https://lore.kernel.org/lkml/20210407172607.8812-1-rppt@kernel.org

Mike Rapoport (4):
  include/linux/mmzone.h: add documentation for pfn_valid()
  memblock: update initialization of reserved pages
  arm64: decouple check whether pfn is in linear map from pfn_valid()
  arm64: drop pfn_valid_within() and simplify pfn_valid()

 arch/arm64/Kconfig              |  3 ---
 arch/arm64/include/asm/memory.h |  2 +-
 arch/arm64/include/asm/page.h   |  3 ++-
 arch/arm64/kvm/mmu.c            |  2 +-
 arch/arm64/mm/init.c            | 14 +++++++++++++-
 arch/arm64/mm/ioremap.c         |  4 ++--
 arch/arm64/mm/mmu.c             |  2 +-
 include/linux/memblock.h        |  4 +++-
 include/linux/mmzone.h          | 11 +++++++++++
 mm/memblock.c                   | 28 ++++++++++++++++++++++++++--
 10 files changed, 60 insertions(+), 13 deletions(-)


base-commit: 6efb943b8616ec53a5e444193dccf1af9ad627b5
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
