Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27DADC2BA4C
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 17:30:57 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D596E49EE6;
	Wed, 26 Jan 2022 12:30:56 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2EIMzTajJ-IG; Wed, 26 Jan 2022 12:30:55 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CF74549F3B;
	Wed, 26 Jan 2022 12:30:55 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E18074045D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 12:30:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FKk9f34zw9jE for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 12:30:54 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F04D349EDE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 12:30:53 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 7C97D61B14;
 Wed, 26 Jan 2022 17:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0AECC340E8;
 Wed, 26 Jan 2022 17:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643218252;
 bh=DsaWgn2b5/uiNugxCw2SLmR1/vGVjh0Ss2yA9R9s1LM=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=dGb3RS7OkfD5pyOERSPYQyIB/zbpDxa79Y4qflpJQCQR7cp/gUlVUAWi9OCcLody4
 FuJ0zdG3rgIonSxsChrnLiaTQe+wLI2F7XNoMSp6OZ599qyuwChe/c4cEgC4oPJ53I
 Lh1YxpmYcP42bcZhzyoPSk0WGIVARAV0zgCk1GZKY1IWLQu6GCsSQGeS2kgWinvfjR
 SReLjmfb1GwpDjCE9nm8sWJ82Y7JKiF40e4ZrwYGx5SeNU64ATl0VnqI6sjxZ037uA
 ZoSWcwmLqY+NwhY6GPCiSOTcMBM4J32pAGycDHAJjW6EwBN+WbRtsbNc7hFbOD5lEy
 KiZlcdaQ8wagQ==
From: Ard Biesheuvel <ardb@kernel.org>
To: linux-arm-kernel@lists.infradead.org
Subject: [RFC PATCH 12/12] arm64: hugetlb: use set_pte_at() not set_pte() to
 provide mm pointer
Date: Wed, 26 Jan 2022 18:30:11 +0100
Message-Id: <20220126173011.3476262-13-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220126173011.3476262-1-ardb@kernel.org>
References: <20220126173011.3476262-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=828; h=from:subject;
 bh=DsaWgn2b5/uiNugxCw2SLmR1/vGVjh0Ss2yA9R9s1LM=;
 b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh8YUiX6nCobhdCM2xfJOu55QOHjqiXQBuGJOyXzVu
 UUxMSROJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYfGFIgAKCRDDTyI5ktmPJI1zDA
 CIsdV7m7gTzi2Wdm+kuwbE5P5R5tZ5RUHTok8VsHS0rmypOJ6Xz3Etk0/Fhfbw8fgmLAWy5VQ5nMph
 HvC+702UWf52zA74CQDMx77//bxRlGTt7kXfuxuxhW+4fAxhgFQSt+jv1E0E7J2Hpu9WRc+AAFPJ6c
 qbvLVOHnUTRthZHOzxlB7Bl0e8DVqU4cXbcuOa4TSCgcWxJiVg1BdXL8eThwxGF7fy7GOGz4o3fOpr
 MlTyf8/N6yfluh0Al1EzanO7c/5GZFfBrKjxq85b/jCHCYVwlXs/EXx3aViHmPp8etJ+ndyPyTUDIy
 IpvwoOHqv+yRee0RyqS8Z9dOpa6PpMs8N2pAeSH0NLPu7J6aG5H4oq86nGzlYaT6GNHDY2xIM7+JsC
 mZ6RnecKTD8V1mu/KIHxwA7wO/n3kxzQlpHuWJlpQcj3C17mPw8RpVKBeTmonGsNb6mxsqNIEzHAh+
 h0uQMBh7mPmfAUuujd8OCDIKYE1H1YJCa0LanJ7bkKb60=
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

Switch to set_pte_at() so we can provide the mm pointer to the code that
performs the page table update.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/hugetlbpage.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index ffb9c229610a..099b28b00f4c 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -252,8 +252,8 @@ void set_huge_swap_pte_at(struct mm_struct *mm, unsigned long addr,
 
 	ncontig = num_contig_ptes(sz, &pgsize);
 
-	for (i = 0; i < ncontig; i++, ptep++)
-		set_pte(ptep, pte);
+	for (i = 0; i < ncontig; i++, ptep++, addr += pgsize)
+		set_pte_at(mm, addr, ptep, pte);
 }
 
 pte_t *huge_pte_alloc(struct mm_struct *mm, struct vm_area_struct *vma,
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
