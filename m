Return-Path: <SRS0=7dZW=56=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 142EAC2BA19
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 15:36:14 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id BE4E52075E
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 15:36:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="g8tX7R1x"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BE4E52075E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 580874B170;
	Tue, 14 Apr 2020 11:36:12 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id L1k4zUwXeLEc; Tue, 14 Apr 2020 11:36:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7EDD54B1B9;
	Tue, 14 Apr 2020 11:36:10 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7578E4B170
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 11:36:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id h0ElNuluGC+C for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2020 11:36:08 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 34B354B11A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 11:36:08 -0400 (EDT)
Received: from aquarius.haifa.ibm.com (nesher1.haifa.il.ibm.com [195.110.40.7])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 4BB9220678;
 Tue, 14 Apr 2020 15:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586878567;
 bh=OkUMHeV6ia5DXa6r7XqF0EcDiCxeMDiKyETeOhmHuVk=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=g8tX7R1x8U/ypmylK2W4LDnRW6MuKA4OEuE/rqzE6DaYywwga3vLXpHEF3UVeO4Va
 FFCv5+sxV8WYkmXLLTJJ/Itrpb3pR20BFzXeYTGuZyIz7BkhLayzoPUZnRYGhPBI+/
 9dW/K6VSA3NvaHSUOdrqvqcGgofvXYqm4FLQQriE=
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v4 06/14] nios2: add support for folded p4d page tables
Date: Tue, 14 Apr 2020 18:34:47 +0300
Message-Id: <20200414153455.21744-7-rppt@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200414153455.21744-1-rppt@kernel.org>
References: <20200414153455.21744-1-rppt@kernel.org>
MIME-Version: 1.0
Cc: Rich Felker <dalias@libc.org>, linux-ia64@vger.kernel.org,
 Geert Uytterhoeven <geert+renesas@glider.be>, linux-sh@vger.kernel.org,
 Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux-mm@kvack.org,
 Paul Mackerras <paulus@samba.org>, linux-hexagon@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 Jonas Bonn <jonas@southpole.se>, linux-arch@vger.kernel.org,
 Brian Cain <bcain@codeaurora.org>, Marc Zyngier <maz@kernel.org>,
 Russell King <linux@armlinux.org.uk>, Ley Foon Tan <ley.foon.tan@intel.com>,
 Mike Rapoport <rppt@linux.ibm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 uclinux-h8-devel@lists.sourceforge.jp, Fenghua Yu <fenghua.yu@intel.com>,
 Arnd Bergmann <arnd@arndb.de>, kvm-ppc@vger.kernel.org,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 openrisc@lists.librecores.org, Stafford Horne <shorne@gmail.com>,
 Guan Xuetao <gxt@pku.edu.cn>, linux-arm-kernel@lists.infradead.org,
 Christophe Leroy <christophe.leroy@c-s.fr>, Tony Luck <tony.luck@intel.com>,
 Yoshinori Sato <ysato@users.sourceforge.jp>, linux-kernel@vger.kernel.org,
 Michael Ellerman <mpe@ellerman.id.au>, nios2-dev@lists.rocketboards.org,
 linuxppc-dev@lists.ozlabs.org, Mike Rapoport <rppt@kernel.org>
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

Implement primitives necessary for the 4th level folding, add walks of p4d
level where appropriate and remove usage of __ARCH_USE_5LEVEL_HACK.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
 arch/nios2/include/asm/pgtable.h | 3 +--
 arch/nios2/mm/fault.c            | 9 +++++++--
 arch/nios2/mm/ioremap.c          | 6 +++++-
 3 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/arch/nios2/include/asm/pgtable.h b/arch/nios2/include/asm/pgtable.h
index f98b7f4519ba..47a1a3ea5734 100644
--- a/arch/nios2/include/asm/pgtable.h
+++ b/arch/nios2/include/asm/pgtable.h
@@ -22,7 +22,6 @@
 #include <asm/tlbflush.h>
 
 #include <asm/pgtable-bits.h>
-#define __ARCH_USE_5LEVEL_HACK
 #include <asm-generic/pgtable-nopmd.h>
 
 #define FIRST_USER_ADDRESS	0UL
@@ -100,7 +99,7 @@ extern pte_t invalid_pte_table[PAGE_SIZE/sizeof(pte_t)];
  */
 static inline void set_pmd(pmd_t *pmdptr, pmd_t pmdval)
 {
-	pmdptr->pud.pgd.pgd = pmdval.pud.pgd.pgd;
+	*pmdptr = pmdval;
 }
 
 /* to find an entry in a page-table-directory */
diff --git a/arch/nios2/mm/fault.c b/arch/nios2/mm/fault.c
index ec9d8a9c426f..964eac1a21d0 100644
--- a/arch/nios2/mm/fault.c
+++ b/arch/nios2/mm/fault.c
@@ -242,6 +242,7 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long cause,
 		 */
 		int offset = pgd_index(address);
 		pgd_t *pgd, *pgd_k;
+		p4d_t *p4d, *p4d_k;
 		pud_t *pud, *pud_k;
 		pmd_t *pmd, *pmd_k;
 		pte_t *pte_k;
@@ -253,8 +254,12 @@ asmlinkage void do_page_fault(struct pt_regs *regs, unsigned long cause,
 			goto no_context;
 		set_pgd(pgd, *pgd_k);
 
-		pud = pud_offset(pgd, address);
-		pud_k = pud_offset(pgd_k, address);
+		p4d = p4d_offset(pgd, address);
+		p4d_k = p4d_offset(pgd_k, address);
+		if (!p4d_present(*p4d_k))
+			goto no_context;
+		pud = pud_offset(p4d, address);
+		pud_k = pud_offset(p4d_k, address);
 		if (!pud_present(*pud_k))
 			goto no_context;
 		pmd = pmd_offset(pud, address);
diff --git a/arch/nios2/mm/ioremap.c b/arch/nios2/mm/ioremap.c
index 819bdfcc2e71..fe821efb9a99 100644
--- a/arch/nios2/mm/ioremap.c
+++ b/arch/nios2/mm/ioremap.c
@@ -86,11 +86,15 @@ static int remap_area_pages(unsigned long address, unsigned long phys_addr,
 	if (address >= end)
 		BUG();
 	do {
+		p4d_t *p4d;
 		pud_t *pud;
 		pmd_t *pmd;
 
 		error = -ENOMEM;
-		pud = pud_alloc(&init_mm, dir, address);
+		p4d = p4d_alloc(&init_mm, dir, address);
+		if (!p4d)
+			break;
+		pud = pud_alloc(&init_mm, p4d, address);
 		if (!pud)
 			break;
 		pmd = pmd_alloc(&init_mm, pud, address);
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
