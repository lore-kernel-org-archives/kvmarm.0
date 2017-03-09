From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH v5 08/10] arm64/mmu: add contiguous bit to sanity bug check
Date: Thu,  9 Mar 2017 09:25:10 +0100
Message-ID: <1489047912-642-9-git-send-email-ard.biesheuvel@linaro.org>
References: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E8CB40C4E
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 03:24:12 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5AmD2YgcAh70 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  9 Mar 2017 03:24:11 -0500 (EST)
Received: from mail-wm0-f49.google.com (mail-wm0-f49.google.com [74.125.82.49])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 670AA40C5B
 for <kvmarm@lists.cs.columbia.edu>; Thu,  9 Mar 2017 03:24:10 -0500 (EST)
Received: by mail-wm0-f49.google.com with SMTP id n11so133326218wma.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 09 Mar 2017 00:25:35 -0800 (PST)
In-Reply-To: <1489047912-642-1-git-send-email-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, mark.rutland@arm.com, keescook@chromium.org, labbott@fedoraproject.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, marc.zyngier@arm.com, catalin.marinas@arm.com, kernel-hardening@lists.openwall.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

A mapping with the contiguous bit cannot be safely manipulated while
live, regardless of whether the bit changes between the old and new
mapping. So take this into account when deciding whether the change
is safe.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm64/mm/mmu.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index d3fecd20a136..a6d7a86dd2b8 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -103,7 +103,15 @@ static bool pgattr_change_is_safe(u64 old, u64 new)
 	 */
 	static const pteval_t mask = PTE_PXN | PTE_RDONLY | PTE_WRITE;
 
-	return old  == 0 || new  == 0 || ((old ^ new) & ~mask) == 0;
+	/* creating or taking down mappings is always safe */
+	if (old == 0 || new == 0)
+		return true;
+
+	/* live contiguous mappings may not be manipulated at all */
+	if ((old | new) & PTE_CONT)
+		return false;
+
+	return ((old ^ new) & ~mask) == 0;
 }
 
 static void alloc_init_pte(pmd_t *pmd, unsigned long addr,
-- 
2.7.4
