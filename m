Return-Path: <SRS0=xlfr=JT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1458C43470
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 06:19:19 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 040FC61435
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 06:19:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 040FC61435
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 756374B4E8;
	Thu, 22 Apr 2021 02:19:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uv6FJSp-EAX9; Thu, 22 Apr 2021 02:19:17 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BD264B4B1;
	Thu, 22 Apr 2021 02:19:17 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E9D04B447
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 02:19:16 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id p2sDwcipLzR3 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Apr 2021 02:19:12 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A19654B252
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 02:19:12 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id E070661437;
 Thu, 22 Apr 2021 06:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1619072351;
 bh=aiNqPvrK3ZBf/RWLu2gvO3kob5vQAnJH+Nma7uJgE88=;
 h=From:To:Cc:Subject:Date:From;
 b=VL9qOvsr2nvFrKZcsGAOxDY7RsbjZfM7fSRRg5XWY0QXE1qOJhi6l/zAJeuHoiNSi
 4n4fKL8s2YnZodz0Gvbb2OIH52szb02HxHgGZtSz7XVskjXqXynuHgA2BhAkjLZa9U
 SU3J7Nog+EbcP/IRKaM7VwUbdr3VVYBK7r+1Y0n+7TnNnBo8SndU9QbBiMCLqGkeaO
 VHwJvQuXnj3tCoBXjga6jvJtwuQ/GV28YpaNXP62Zo1QPeKtDqLSWh72VHivE451yo
 V+EubptW9xFki40ACOz+J06UIJG30vVc2AfikinF6P0FLp6pQ7AqEheYpFsXgnGPj8
 nYuOW8KRCpkgA==
From: Mike Rapoport <rppt@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 0/4] arm64: drop pfn_valid_within() and simplify pfn_valid()
Date: Thu, 22 Apr 2021 09:18:58 +0300
Message-Id: <20210422061902.21614-1-rppt@kernel.org>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Cc: David Hildenbrand <david@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, linux-kernel@vger.kernel.org,
 Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
 kvmarm@lists.cs.columbia.edu, Marc Zyngier <maz@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>,
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

The patches are only boot tested on qemu-system-aarch64 so I'd really
appreciate memory stress tests on real hardware.

If this actually works we'll be one step closer to drop custom pfn_valid()
on arm64 altogether.

v3:
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
 arch/arm64/mm/init.c            | 16 ++++++++++++++--
 arch/arm64/mm/ioremap.c         |  4 ++--
 arch/arm64/mm/mmu.c             |  2 +-
 include/linux/memblock.h        |  4 +++-
 include/linux/mmzone.h          | 11 +++++++++++
 mm/memblock.c                   | 28 ++++++++++++++++++++++++++--
 10 files changed, 61 insertions(+), 14 deletions(-)

base-commit: e49d033bddf5b565044e2abe4241353959bc9120
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
