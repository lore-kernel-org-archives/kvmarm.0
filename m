Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06F79C28CF5
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 17:30:56 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AF70E49EDE;
	Wed, 26 Jan 2022 12:30:55 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id gbC8c2me4n2q; Wed, 26 Jan 2022 12:30:54 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B12424A100;
	Wed, 26 Jan 2022 12:30:54 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 398F94A10E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 12:30:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LnDaJNEVmUq6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 12:30:52 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 4B03449EF0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 12:30:52 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 5E37EB81AC2;
 Wed, 26 Jan 2022 17:30:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7884C340E9;
 Wed, 26 Jan 2022 17:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643218250;
 bh=/28tCtfFancm5CCSx78Aad6xerDDMgMGm3g+HUtCuTI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=OsvhggZGrDPJhvViDZXQc5RW7Ur63e2g4/8sIHPWOeDixuKztRbv4sznJBVyIk41+
 PTRx6lIWRnxuNZByeHNAvkvk6A3tuvRaHH+C3vwp/L8zGrYD+LcBfWNbm9Rzoo+UHJ
 IqcZjpA1SiwKX0avGzI7rbw4dsl3It/o2UkWR1STBeAIZKT8kpgOJUGslhBHDq1J6q
 ZnamH56hdQxfdh7/sL8v8hz3GIeQi9w7RKNEC/izsXjrzMsy8Ex4f/J9aIVcwHc4c6
 butX3VGsAnAvqkK7MDoGimFUobGE850Oyej1Oefw0V2juAXSqNicItg9Pw8BaDiD3M
 2Vif7+oZa849Q==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 11/12] arm64: efi: use set_pte_at() not set_pte() in order
 to pass mm pointer
Date: Wed, 26 Jan 2022 18:30:10 +0100
Message-Id: <20220126173011.3476262-12-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220126173011.3476262-1-ardb@kernel.org>
References: <20220126173011.3476262-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=854; h=from:subject;
 bh=/28tCtfFancm5CCSx78Aad6xerDDMgMGm3g+HUtCuTI=;
 b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh8YUhx47G2Di37HBOTdk1WIh6QmR6R0DIRCPzQe3u
 Y9HyTc6JAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYfGFIQAKCRDDTyI5ktmPJHlUC/
 9fpAGBHh3zml3pjMTEaSbLLUBTmAifHgqXDsTvzBaMFSF0AjLSXGwREtuZo/GjPv8vayjRlRH3qXYs
 wj3UdGjwglVOKGYXyz//a89HyX0yj4wbs6bluZzQ9lP/EGutJDydzRQw1lUBVxwN1GXBJl2JOzN3CE
 TYyEnmvOcFHAOo9SqMbyNaR0JpauoD9NJKPuQ1PdwVfl729t580jb50LS8vl+uVeMHZTme8Kb/IPLQ
 afhYrLIuHqqVqwyMMz8Xfzh1bSOQ2wpytn5fplrqMETqXtgjsPg0V5yWF3htw1lrrNHTf/1SAo5L0F
 EJM5xf/2icjJ15b+zUUYgsq1EnpBN992ztuWtCassP6GIjwGWPwefQgprtrBG3N9bDK29dDxhrohmo
 T09Ubm5WXu6Ve68zXBjeJWSWzdA6rDIyj4hl0ks3E3zZq43KCB3+fdUzipGaiw+k0ZOr+1g3uR8zrn
 z8NsR8XruDSBrpa3LJ+N0zOwDbpaz2B6ViCART/lXHuao=
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

The set_pte() helper does not carry the struct mm pointer, which makes
it difficult for the implementation to reason about the context in which
the set_pte() call is taking place. So switch to set_pte_at() instead.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/kernel/efi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index e1be6c429810..e3e50adfae18 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -92,7 +92,7 @@ static int __init set_permissions(pte_t *ptep, unsigned long addr, void *data)
 		pte = set_pte_bit(pte, __pgprot(PTE_RDONLY));
 	if (md->attribute & EFI_MEMORY_XP)
 		pte = set_pte_bit(pte, __pgprot(PTE_PXN));
-	set_pte(ptep, pte);
+	set_pte_at(&efi_mm, addr, ptep, pte);
 	return 0;
 }
 
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
