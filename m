Return-Path: <SRS0=xlfr=JT=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E519FC43462
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 06:19:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 67EC8613CE
	for <kvmarm@archiver.kernel.org>; Thu, 22 Apr 2021 06:19:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 67EC8613CE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id ED3A04B4FD;
	Thu, 22 Apr 2021 02:19:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hIpiVup1twoZ; Thu, 22 Apr 2021 02:19:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D987E4B4E8;
	Thu, 22 Apr 2021 02:19:31 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0CC9F4B255
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 02:19:31 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4790RfS1l+A7 for <kvmarm@lists.cs.columbia.edu>;
 Thu, 22 Apr 2021 02:19:30 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 80FED4B396
 for <kvmarm@lists.cs.columbia.edu>; Thu, 22 Apr 2021 02:19:29 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CDF86145A;
 Thu, 22 Apr 2021 06:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1619072367;
 bh=5pv19/zw6k97y2VFoD7tQZ9uQemSm8OSk2DzdouBBz8=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=lRqB+e3jDktyHVncSv2EVQ7vnSkGOi8MCTVL1PoGUfGbpMvYA/EF9yl6xQDYcIM81
 jivV+9fC8+krtFB7qJqeN2qoLwABPCk8lp2L6Ng6FEVG35NPRMkd5yj4rF/Egqwrg4
 Dr84oFWd0BnfPcFD/QQWJaBm7tj3EbMKhpKu/oPfC3CEWX0RJSseTwqkb8XV08pm7T
 NSK/zDggVENJVpjJI0FqoTgHmQh4N/4j6XT9eUzghketH0zek7du2QBJlzoSGMTHDY
 JrLT07j4mPVTO9xZnnDueXjmXuGmP11FZ7RI8uvBILUSmJRGfVahjmRG7dZ6OIWzTo
 VS1h3VMV3f0ww==
From: Mike Rapoport <rppt@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [PATCH v3 4/4] arm64: drop pfn_valid_within() and simplify pfn_valid()
Date: Thu, 22 Apr 2021 09:19:02 +0300
Message-Id: <20210422061902.21614-5-rppt@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210422061902.21614-1-rppt@kernel.org>
References: <20210422061902.21614-1-rppt@kernel.org>
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

The arm64's version of pfn_valid() differs from the generic because of two
reasons:

* Parts of the memory map are freed during boot. This makes it necessary to
  verify that there is actual physical memory that corresponds to a pfn
  which is done by querying memblock.

* There are NOMAP memory regions. These regions are not mapped in the
  linear map and until the previous commit the struct pages representing
  these areas had default values.

As the consequence of absence of the special treatment of NOMAP regions in
the memory map it was necessary to use memblock_is_map_memory() in
pfn_valid() and to have pfn_valid_within() aliased to pfn_valid() so that
generic mm functionality would not treat a NOMAP page as a normal page.

Since the NOMAP regions are now marked as PageReserved(), pfn walkers and
the rest of core mm will treat them as unusable memory and thus
pfn_valid_within() is no longer required at all and can be disabled by
removing CONFIG_HOLES_IN_ZONE on arm64.

pfn_valid() can be slightly simplified by replacing
memblock_is_map_memory() with memblock_is_memory().

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
---
 arch/arm64/Kconfig   | 3 ---
 arch/arm64/mm/init.c | 4 ++--
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index e4e1b6550115..58e439046d05 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1040,9 +1040,6 @@ config NEED_PER_CPU_EMBED_FIRST_CHUNK
 	def_bool y
 	depends on NUMA
 
-config HOLES_IN_ZONE
-	def_bool y
-
 source "kernel/Kconfig.hz"
 
 config ARCH_SPARSEMEM_ENABLE
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 966a7a18d528..f431b38d0837 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -243,7 +243,7 @@ int pfn_valid(unsigned long pfn)
 
 	/*
 	 * ZONE_DEVICE memory does not have the memblock entries.
-	 * memblock_is_map_memory() check for ZONE_DEVICE based
+	 * memblock_is_memory() check for ZONE_DEVICE based
 	 * addresses will always fail. Even the normal hotplugged
 	 * memory will never have MEMBLOCK_NOMAP flag set in their
 	 * memblock entries. Skip memblock search for all non early
@@ -254,7 +254,7 @@ int pfn_valid(unsigned long pfn)
 		return pfn_section_valid(ms, pfn);
 }
 #endif
-	return memblock_is_map_memory(addr);
+	return memblock_is_memory(addr);
 }
 EXPORT_SYMBOL(pfn_valid);
 
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
