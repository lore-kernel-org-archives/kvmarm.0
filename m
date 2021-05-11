Return-Path: <SRS0=u/VZ=KG=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 074E1C433B4
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 10:06:08 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6B70B6193D
	for <kvmarm@archiver.kernel.org>; Tue, 11 May 2021 10:06:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6B70B6193D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id F2EB54B4B3;
	Tue, 11 May 2021 06:06:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cROfTHP5qhFz; Tue, 11 May 2021 06:06:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B56AF4B4BA;
	Tue, 11 May 2021 06:06:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DCD264B4B3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 06:06:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fkzsTOb-x2qJ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 May 2021 06:06:04 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E66874B4BA
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 May 2021 06:06:03 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6326C61925;
 Tue, 11 May 2021 10:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1620727563;
 bh=LE00JXn6JpyvcSFw6kRi1i0Orit+XbdWVHE/yEogFnA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=DyQ3OZvSpvBGY8GWhx+paJ4GHTInjnncZyvBdLrzCeKw+tVJD/bre4JHwued/V+XH
 TrQwMGnvKv4QIh1VTrIT2Tui+R1GRR1oW0XGi5NylsraCRFzTSID4lWjqzWgaUKmIb
 pgnutv8LqAga8qZgOwP5UgZPNwT4TkuUMdV2/vsZNoX9x7qzae9FZVULOHeSq4MVJh
 Md+dGyBByx6uf+FfwitOYmGNcjWr//k6PF79Wkn3PglNUW0td2CnHm3N4gnEy0o3DY
 0zLd/vZ+ezusbAInkkIU3sYTQSvObfmfWj+9N9MzhUVstJoyabmNpnl+dPMXOOD43M
 oYcU4Kocv97RA==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v4 1/4] include/linux/mmzone.h: add documentation for
 pfn_valid()
Date: Tue, 11 May 2021 13:05:47 +0300
Message-Id: <20210511100550.28178-2-rppt@kernel.org>
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

Add comment describing the semantics of pfn_valid() that clarifies that
pfn_valid() only checks for availability of a memory map entry (i.e. struct
page) for a PFN rather than availability of usable memory backing that PFN.

The most "generic" version of pfn_valid() used by the configurations with
SPARSEMEM enabled resides in include/linux/mmzone.h so this is the most
suitable place for documentation about semantics of pfn_valid().

Suggested-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
---
 include/linux/mmzone.h | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 0d53eba1c383..e5945ca24df7 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1427,6 +1427,17 @@ static inline int pfn_section_valid(struct mem_section *ms, unsigned long pfn)
 #endif
 
 #ifndef CONFIG_HAVE_ARCH_PFN_VALID
+/**
+ * pfn_valid - check if there is a valid memory map entry for a PFN
+ * @pfn: the page frame number to check
+ *
+ * Check if there is a valid memory map entry aka struct page for the @pfn.
+ * Note, that availability of the memory map entry does not imply that
+ * there is actual usable memory at that @pfn. The struct page may
+ * represent a hole or an unusable page frame.
+ *
+ * Return: 1 for PFNs that have memory map entries and 0 otherwise
+ */
 static inline int pfn_valid(unsigned long pfn)
 {
 	struct mem_section *ms;
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
