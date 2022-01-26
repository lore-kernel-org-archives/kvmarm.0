Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6D20C28CF5
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 17:30:51 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8A5E449F22;
	Wed, 26 Jan 2022 12:30:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id dm6WU5UnJ2C8; Wed, 26 Jan 2022 12:30:50 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 694A54A10E;
	Wed, 26 Jan 2022 12:30:50 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C8C149EE6
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 12:30:49 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id SQCPVaR0JDrk for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 12:30:48 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5267649EDE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 12:30:47 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 10B62B81F85;
 Wed, 26 Jan 2022 17:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E391C340EB;
 Wed, 26 Jan 2022 17:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643218244;
 bh=nNUKFaczAxtIriN5XdrdIMGNmdjEdmxkFpYB7GnKfAY=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=ESboqctVJ6fUNu/W3ZIYUZgJ9wGqik6M6Eo1rmE+hVJg9E8QTjAVpfSR8UOAMQfCd
 HZIfbCeaMo7aiVFoNAHJn2trgnUPPrnSe+cjzHIAkSkR6X+AZyvqxmxEyo5ycZD4iN
 d2BtfVnK0PVm5LVhdPSJzyu1L8WGB3K/GlM3S7H6oOgf8glIxpvwNTFPn+LaKPk9wj
 7HeYnW0pEyihrwNaZEu0O7SqEaEJa9TlAhE/3SWAGUsdaAs5ePAjAdvTP4n7hpDRRr
 8XojudOw962IkzapnU4oVNh4S5snRh1/dMYs+Kp3QJiwg/5Lh8NVQXIiOxk1xxM+6k
 v7uuVeLlFgMeg==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 09/12] arm64: mm: remap kernel page tables read-only at
 end of init
Date: Wed, 26 Jan 2022 18:30:08 +0100
Message-Id: <20220126173011.3476262-10-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220126173011.3476262-1-ardb@kernel.org>
References: <20220126173011.3476262-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1493; h=from:subject;
 bh=nNUKFaczAxtIriN5XdrdIMGNmdjEdmxkFpYB7GnKfAY=;
 b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh8YUd3PSNoIjo2Lk2qkayY+V0cNJVcBz93RhLFO54
 S91VXeqJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYfGFHQAKCRDDTyI5ktmPJDZbC/
 4hxlW60C4EKcfnGoyieUkDa0wi750/b0JWQEi27+LiiYQFbscSI7QyHBnHm8t0CAMNlsgoKI9KnxvJ
 Bs3bRbFCQl4Xv+Tp0u5dTwAMRK1JX5DsckA2kt6Z7mH5E4TLFWKXlCmLI4KipsLuPwdKNk0bBvruOG
 HJ2SNNglSzyCFOT3Htlaz6dBtUKrzSjurgJUaz7aGJ2IneMteYMdFCkNJEra7rGbc601+sgR2KrN8i
 xESU/AiQ/pV+2iuxWg4q2eGQHC9YIsNE90n/dXzrHLX55ktf904CTaddoWiUr3nn8YVa2KzAIcluXP
 hR0Wi+oi9VLkZUxE/Fl2ifvLMYfLaXkzldmrBno8uSw9pA/xaV5TARkqpxd8NEYFO0EXXWls628mas
 Rl4M6W8FsYrCDR5xUvYEgjQYuLlfrzLA8gLASlLp8FSzQT2/FfbGjFXBtC3dD4mXCU7A1HXaRX91d8
 cPZZXud7+ELGlphhMR8UTj2ewOHgGp8Lcsg/XqbBDZ7jc=
X-Developer-Key: i=ardb@kernel.org; a=openpgp;
 fpr=F43D03328115A198C90016883D200E9CA6329909
Cc: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-hardening@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>
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

Now that all the handling is in place to deal with read-only page tables
at runtime, do a pass over the kernel page tables at boot to remap all
the page table pages read-only that were allocated early.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/mmu.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 971501535757..b1212f6d48f2 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -559,8 +559,23 @@ static void __init map_mem(pgd_t *pgdp)
 	memblock_clear_nomap(kernel_start, kernel_end - kernel_start);
 }
 
+static void mark_pgtables_ro(const pmd_t *pmdp, int level, int num_entries)
+{
+	while (num_entries--) {
+		if (pmd_valid(*pmdp) && pmd_table(*pmdp)) {
+			pmd_t *next = __va(__pmd_to_phys(*pmdp));
+
+			if (level < 2)
+				mark_pgtables_ro(next, level + 1, PTRS_PER_PMD);
+			set_pgtable_ro(next);
+		}
+		pmdp++;
+	}
+}
+
 void mark_rodata_ro(void)
 {
+	int pgd_level = 4 - CONFIG_PGTABLE_LEVELS;
 	unsigned long section_size;
 
 	/*
@@ -571,6 +586,11 @@ void mark_rodata_ro(void)
 	update_mapping_prot(__pa_symbol(__start_rodata), (unsigned long)__start_rodata,
 			    section_size, PAGE_KERNEL_RO);
 
+#ifdef CONFIG_UNMAP_KERNEL_AT_EL0
+	mark_pgtables_ro((pmd_t *)&tramp_pg_dir, pgd_level, PTRS_PER_PGD);
+#endif
+	mark_pgtables_ro((pmd_t *)&swapper_pg_dir, pgd_level, PTRS_PER_PGD);
+
 	debug_checkwx();
 }
 
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
