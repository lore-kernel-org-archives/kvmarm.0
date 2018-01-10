From: Punit Agrawal <punit.agrawal@arm.com>
Subject: [RFC 1/4] arm64: Correct type for PUD macros
Date: Wed, 10 Jan 2018 19:07:26 +0000
Message-ID: <20180110190729.18383-2-punit.agrawal@arm.com>
References: <20180110190729.18383-1-punit.agrawal@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C2A549DA2
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jan 2018 14:03:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 4K+VIl8pGVaI for <kvmarm@lists.cs.columbia.edu>;
 Wed, 10 Jan 2018 14:03:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E6EB49D32
 for <kvmarm@lists.cs.columbia.edu>; Wed, 10 Jan 2018 14:03:26 -0500 (EST)
In-Reply-To: <20180110190729.18383-1-punit.agrawal@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Punit Agrawal <punit.agrawal@arm.com>, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

The PUD macros (PUD_TABLE_BIT, PUD_TYPE_MASK, PUD_TYPE_SECT) use the
pgdval_t even when pudval_t is available. Even though the underlying
type for both (u64) is the same it is confusing and may lead to issues
in the future.

Fix this by using pudval_t to define the PUD_* macros.

Fixes: 084bd29810a56 ("ARM64: mm: HugeTLB support.")
Fixes: 206a2a73a62d3 ("arm64: mm: Create gigabyte kernel logical mappings where possible")
Signed-off-by: Punit Agrawal <punit.agrawal@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will.deacon@arm.com>
---
 arch/arm64/include/asm/pgtable-hwdef.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/pgtable-hwdef.h b/arch/arm64/include/asm/pgtable-hwdef.h
index eb0c2bd90de9..40a998cdd399 100644
--- a/arch/arm64/include/asm/pgtable-hwdef.h
+++ b/arch/arm64/include/asm/pgtable-hwdef.h
@@ -116,9 +116,9 @@
  * Level 1 descriptor (PUD).
  */
 #define PUD_TYPE_TABLE		(_AT(pudval_t, 3) << 0)
-#define PUD_TABLE_BIT		(_AT(pgdval_t, 1) << 1)
-#define PUD_TYPE_MASK		(_AT(pgdval_t, 3) << 0)
-#define PUD_TYPE_SECT		(_AT(pgdval_t, 1) << 0)
+#define PUD_TABLE_BIT		(_AT(pudval_t, 1) << 1)
+#define PUD_TYPE_MASK		(_AT(pudval_t, 3) << 0)
+#define PUD_TYPE_SECT		(_AT(pudval_t, 1) << 0)
 
 /*
  * Level 2 descriptor (PMD).
-- 
2.15.1
