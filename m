Return-Path: <SRS0=7dZW=56=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 416C7C2BA19
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 15:37:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id EAD3920767
	for <kvmarm@archiver.kernel.org>; Tue, 14 Apr 2020 15:37:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="VU/Llyju"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EAD3920767
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A091C4B0FD;
	Tue, 14 Apr 2020 11:37:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mLhvixzWrjSC; Tue, 14 Apr 2020 11:37:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AA1FF4B1E5;
	Tue, 14 Apr 2020 11:37:19 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63A964B1B9
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 11:37:18 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 8VmeZk6kkINa for <kvmarm@lists.cs.columbia.edu>;
 Tue, 14 Apr 2020 11:37:17 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2E6B94B0CE
 for <kvmarm@lists.cs.columbia.edu>; Tue, 14 Apr 2020 11:37:17 -0400 (EDT)
Received: from aquarius.haifa.ibm.com (nesher1.haifa.il.ibm.com [195.110.40.7])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id DF1522085B;
 Tue, 14 Apr 2020 15:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1586878636;
 bh=y5upl5y5kDKcOZZTB6xnGHWCDtOJ5v9v3QvgjuKGYnA=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=VU/LlyjuZjD2xgCfZA7m8dLQDTyPj28OI08DI540xTc3wP1fJsitV67hiVVil7eVJ
 aSNmRqUVKgNW+oW2T/ecAsUG7/P9Ym38a5dxBUPtF2JQyqCeN7tx/o7OYsA14TDjOD
 JatvJvEQqBS9dHMIx3mUATBkVLOVSm36w2YSGeaE=
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v4 13/14] asm-generic: remove pgtable-nop4d-hack.h
Date: Tue, 14 Apr 2020 18:34:54 +0300
Message-Id: <20200414153455.21744-14-rppt@kernel.org>
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

No architecture defines __ARCH_USE_5LEVEL_HACK and therefore
pgtable-nop4d-hack.h will be never actually included.

Remove it.

Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
---
 include/asm-generic/pgtable-nop4d-hack.h | 64 ------------------------
 include/asm-generic/pgtable-nopud.h      |  4 --
 2 files changed, 68 deletions(-)
 delete mode 100644 include/asm-generic/pgtable-nop4d-hack.h

diff --git a/include/asm-generic/pgtable-nop4d-hack.h b/include/asm-generic/pgtable-nop4d-hack.h
deleted file mode 100644
index 829bdb0d6327..000000000000
--- a/include/asm-generic/pgtable-nop4d-hack.h
+++ /dev/null
@@ -1,64 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#ifndef _PGTABLE_NOP4D_HACK_H
-#define _PGTABLE_NOP4D_HACK_H
-
-#ifndef __ASSEMBLY__
-#include <asm-generic/5level-fixup.h>
-
-#define __PAGETABLE_PUD_FOLDED 1
-
-/*
- * Having the pud type consist of a pgd gets the size right, and allows
- * us to conceptually access the pgd entry that this pud is folded into
- * without casting.
- */
-typedef struct { pgd_t pgd; } pud_t;
-
-#define PUD_SHIFT	PGDIR_SHIFT
-#define PTRS_PER_PUD	1
-#define PUD_SIZE	(1UL << PUD_SHIFT)
-#define PUD_MASK	(~(PUD_SIZE-1))
-
-/*
- * The "pgd_xxx()" functions here are trivial for a folded two-level
- * setup: the pud is never bad, and a pud always exists (as it's folded
- * into the pgd entry)
- */
-static inline int pgd_none(pgd_t pgd)		{ return 0; }
-static inline int pgd_bad(pgd_t pgd)		{ return 0; }
-static inline int pgd_present(pgd_t pgd)	{ return 1; }
-static inline void pgd_clear(pgd_t *pgd)	{ }
-#define pud_ERROR(pud)				(pgd_ERROR((pud).pgd))
-
-#define pgd_populate(mm, pgd, pud)		do { } while (0)
-#define pgd_populate_safe(mm, pgd, pud)		do { } while (0)
-/*
- * (puds are folded into pgds so this doesn't get actually called,
- * but the define is needed for a generic inline function.)
- */
-#define set_pgd(pgdptr, pgdval)	set_pud((pud_t *)(pgdptr), (pud_t) { pgdval })
-
-static inline pud_t *pud_offset(pgd_t *pgd, unsigned long address)
-{
-	return (pud_t *)pgd;
-}
-
-#define pud_val(x)				(pgd_val((x).pgd))
-#define __pud(x)				((pud_t) { __pgd(x) })
-
-#define pgd_page(pgd)				(pud_page((pud_t){ pgd }))
-#define pgd_page_vaddr(pgd)			(pud_page_vaddr((pud_t){ pgd }))
-
-/*
- * allocating and freeing a pud is trivial: the 1-entry pud is
- * inside the pgd, so has no extra memory associated with it.
- */
-#define pud_alloc_one(mm, address)		NULL
-#define pud_free(mm, x)				do { } while (0)
-#define __pud_free_tlb(tlb, x, a)		do { } while (0)
-
-#undef  pud_addr_end
-#define pud_addr_end(addr, end)			(end)
-
-#endif /* __ASSEMBLY__ */
-#endif /* _PGTABLE_NOP4D_HACK_H */
diff --git a/include/asm-generic/pgtable-nopud.h b/include/asm-generic/pgtable-nopud.h
index d3776cb494c0..ad05c1684bfc 100644
--- a/include/asm-generic/pgtable-nopud.h
+++ b/include/asm-generic/pgtable-nopud.h
@@ -4,9 +4,6 @@
 
 #ifndef __ASSEMBLY__
 
-#ifdef __ARCH_USE_5LEVEL_HACK
-#include <asm-generic/pgtable-nop4d-hack.h>
-#else
 #include <asm-generic/pgtable-nop4d.h>
 
 #define __PAGETABLE_PUD_FOLDED 1
@@ -65,5 +62,4 @@ static inline pud_t *pud_offset(p4d_t *p4d, unsigned long address)
 #define pud_addr_end(addr, end)			(end)
 
 #endif /* __ASSEMBLY__ */
-#endif /* !__ARCH_USE_5LEVEL_HACK */
 #endif /* _PGTABLE_NOPUD_H */
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
