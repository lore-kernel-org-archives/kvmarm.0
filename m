Return-Path: <SRS0=3mia=ND=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 719BBC4338F
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 06:59:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C78B761038
	for <kvmarm@archiver.kernel.org>; Thu, 12 Aug 2021 06:59:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C78B761038
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 48EE44A1A5;
	Thu, 12 Aug 2021 02:59:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id uMXrXaaRjnt3; Thu, 12 Aug 2021 02:59:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4DD7C407F4;
	Thu, 12 Aug 2021 02:59:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE3DB407F4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 02:59:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o+DgMeqDhrxa for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Aug 2021 02:59:31 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AE3E8407EF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Aug 2021 02:59:31 -0400 (EDT)
Received: by mail.kernel.org (Postfix) with ESMTPSA id 380286101E;
 Thu, 12 Aug 2021 06:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1628751569;
 bh=ZQav6dV8arUW7JrdFYQDuwE6wrSwrjaeQEiFGD8y5Ow=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=Ub06Kjl0JOvhrwSvBoL2gmy7C5V9LcaLfJX4yihafiq4jwaM9ed18Mqq07gCxmmRc
 dBUACRxsjGNMUuPesEXB4NM6qhtbBc3iff2dr+pWlD3uXacnNjvXrSXOv2GQeEZaQk
 T5EjPvN6qf91Si5gNiyLWnmmqBhSVLnbq0cD1UTlLeu8DwjjPJIufFz/H/4NiX3LdV
 098Di3iHP3zb+sqspU8kt0rfVgMlCmHe6Mbha1VoXncA3Ntyr0cfpysaIXYyiVNUNf
 vyT317LfJl4oR3bkN1wEHq7OrIKJEGS3w+j+XOUsNEphrtv2u0D2L1lGU/XncCVEfF
 bZZ9cTh4OS0cw==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v4 1/2] x86/mm: memory_map_top_down: remove spurious
 reservation of upper 2M
Date: Thu, 12 Aug 2021 09:59:06 +0300
Message-Id: <20210812065907.20046-2-rppt@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20210812065907.20046-1-rppt@kernel.org>
References: <20210812065907.20046-1-rppt@kernel.org>
MIME-Version: 1.0
Cc: Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, linux-mips@vger.kernel.org,
 linux-mm@kvack.org, Will Deacon <will@kernel.org>,
 "H. Peter Anvin" <hpa@zytor.com>, linux-riscv@lists.infradead.org,
 Frank Rowand <frowand.list@gmail.com>, kvmarm@lists.cs.columbia.edu,
 linux-s390@vger.kernel.org, linux-acpi@vger.kernel.org,
 Marc Zyngier <maz@kernel.org>, x86@kernel.org,
 Russell King <linux@armlinux.org.uk>, Mike Rapoport <rppt@linux.ibm.com>,
 Christian Borntraeger <borntraeger@de.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 Guenter Roeck <linux@roeck-us.net>, Len Brown <lenb@kernel.org>,
 devicetree@vger.kernel.org, Albert Ou <aou@eecs.berkeley.edu>,
 Vasily Gorbik <gor@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>,
 Rob Herring <robh+dt@kernel.org>, Borislav Petkov <bp@alien8.de>,
 Andy Lutomirski <luto@kernel.org>, Paul Walmsley <paul.walmsley@sifive.com>,
 "Kirill A. Shutemov" <kirill@shutemov.name>,
 Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-kernel@vger.kernel.org,
 Palmer Dabbelt <palmer@dabbelt.com>, Mike Rapoport <rppt@kernel.org>
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

memory_map_top_down() function skips the upper 2M in the beginning and maps
them in the end because

	"xen has big range in reserved near end of ram, skip it at first"

It appears, though, that the root cause was that there was not enough
memory in the range [min_pfn_mapped, max_pfn_mapped] to allocate page
tables from that range in alloc_low_pages() because min_pfn_mapped didn't
reflect that actual minimal pfn that was already mapped but remained close
to the end of the range being mapped by memory_map_top_down().

This happened because min_pfn_mapped is updated at every iteration of the
loop in memory_map_top_down(), but there is another loop in
init_range_memory_mapping() that maps several regions below the current
min_pfn_mapped without updating this variable.

Move the update of min_pfn_mapped to add_pfn_range_mapped() next to the
update of max_pfn_mapped so that every time a new range is mapped both
limits will be updated accordingly, and remove the spurious "reservation"
of upper 2M.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
 arch/x86/mm/init.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 75ef19aa8903..87150961fdca 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -486,6 +486,7 @@ static void add_pfn_range_mapped(unsigned long start_pfn, unsigned long end_pfn)
 	nr_pfn_mapped = clean_sort_range(pfn_mapped, E820_MAX_ENTRIES);
 
 	max_pfn_mapped = max(max_pfn_mapped, end_pfn);
+	min_pfn_mapped = min(min_pfn_mapped, start_pfn);
 
 	if (start_pfn < (1UL<<(32-PAGE_SHIFT)))
 		max_low_pfn_mapped = max(max_low_pfn_mapped,
@@ -605,20 +606,14 @@ static unsigned long __init get_new_step_size(unsigned long step_size)
 static void __init memory_map_top_down(unsigned long map_start,
 				       unsigned long map_end)
 {
-	unsigned long real_end, last_start;
-	unsigned long step_size;
-	unsigned long addr;
+	unsigned long real_end = ALIGN_DOWN(map_end, PMD_SIZE);
+	unsigned long last_start = real_end;
+	/* step_size need to be small so pgt_buf from BRK could cover it */
+	unsigned long step_size = PMD_SIZE;
 	unsigned long mapped_ram_size = 0;
 
-	/* xen has big range in reserved near end of ram, skip it at first.*/
-	addr = memblock_find_in_range(map_start, map_end, PMD_SIZE, PMD_SIZE);
-	real_end = addr + PMD_SIZE;
-
-	/* step_size need to be small so pgt_buf from BRK could cover it */
-	step_size = PMD_SIZE;
 	max_pfn_mapped = 0; /* will get exact value next */
 	min_pfn_mapped = real_end >> PAGE_SHIFT;
-	last_start = real_end;
 
 	/*
 	 * We start from the top (end of memory) and go to the bottom.
@@ -638,7 +633,6 @@ static void __init memory_map_top_down(unsigned long map_start,
 		mapped_ram_size += init_range_memory_mapping(start,
 							last_start);
 		last_start = start;
-		min_pfn_mapped = last_start >> PAGE_SHIFT;
 		if (mapped_ram_size >= step_size)
 			step_size = get_new_step_size(step_size);
 	}
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
