Return-Path: <SRS0=u/VZ=KG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E193C433ED
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 10:06:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F18261937
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 10:06:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F18261937
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E5A94B53B;
	Tue, 11 May 2021 06:06:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 4iLUVQwL4B5D; Tue, 11 May 2021 06:06:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2A4B54B4AF;
	Tue, 11 May 2021 06:06:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C1E664B4AF
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 06:06:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hJGoE5D6oxvy for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 May 2021 06:06:16 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9CC774B39D
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 06:06:16 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id F138E61939;
 Tue, 11 May 2021 10:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1620727575;
 bh=SlugFhiHPFE6544Op5mwYlOkGJajxXxh97whxO6/BpA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=HYDF4IQVMwKctvrPMNf95/Pi4DLD45vn6Bg51bGOwMZencaGiwj43fkKPQm08bIwu
 DW9MDtK5hN9JDa0rWQ4zWqCsuTlu+Wl7qkZwUObbIm+xN9ndU6m3MiOMBDRowd5d6S
 1k/2vv/YoYPPXlm2tyD6M2BU4/wVFX7FOfcb9nU9G4F3berrlBwG0srn9nJ6Wc9AQK
 WZiOsUaUxrSlRrqmQvV2ieZsfBfn5FxYmLPBoAsLStxaRckXJR7h7yUFFU3K28jFWe
 c1+klc10Szz9z2s/c0OcwmBRJkQQKgKUR+dVkXDmqrq2kPmqZKUDXTSNMgnIkcUpjc
 X5xLsM/+3/ZVg==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v4 4/4] arm64: drop pfn_valid_within() and simplify pfn_valid()
Date: Tue, 11 May 2021 13:05:50 +0300
Message-Id: <20210511100550.28178-5-rppt@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210511100550.28178-1-rppt@kernel.org>
References: <20210511100550.28178-1-rppt@kernel.org>
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
 arch/arm64/mm/init.c | 2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 9f1d8566bbf9..d7dc8698cf8e 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1052,9 +1052,6 @@ config NEED_PER_CPU_EMBED_FIRST_CHUNK
 	def_bool y
 	depends on NUMA
 
-config HOLES_IN_ZONE
-	def_bool y
-
 source "kernel/Kconfig.hz"
 
 config ARCH_SPARSEMEM_ENABLE
diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 798f74f501d5..fb07218da2c0 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -251,7 +251,7 @@ int pfn_valid(unsigned long pfn)
 	if (!early_section(ms))
 		return pfn_section_valid(ms, pfn);
 
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
