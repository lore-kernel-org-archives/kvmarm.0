From: Julien Grall <julien.grall@arm.com>
Subject: [PATCH RFC 07/14] arm64/mm: Introduce NUM_ASIDS
Date: Thu, 21 Mar 2019 16:36:16 +0000
Message-ID: <20190321163623.20219-8-julien.grall@arm.com>
References: <20190321163623.20219-1-julien.grall@arm.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190321163623.20219-1-julien.grall@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: christoffer.dall@arm.com, james.morse@arm.com, marc.zyngier@arm.com, julien.thierry@arm.com, suzuki.poulose@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, Julien Grall <julien.grall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

At the moment ASID_FIRST_VERSION is used to know the number of ASIDs
supported. As we are going to move the ASID allocator in a separate, it
would be better to use a different name for external users.

This patch adds NUM_ASIDS and implements ASID_FIRST_VERSION using it.

Signed-off-by: Julien Grall <julien.grall@arm.com>
---
 arch/arm64/mm/context.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/context.c b/arch/arm64/mm/context.c
index 5a4c2b1aac71..fb13bc249951 100644
--- a/arch/arm64/mm/context.c
+++ b/arch/arm64/mm/context.c
@@ -48,7 +48,9 @@ static DEFINE_PER_CPU(atomic64_t, active_asids);
 static DEFINE_PER_CPU(u64, reserved_asids);
 
 #define ASID_MASK(info)			(~GENMASK((info)->bits - 1, 0))
-#define ASID_FIRST_VERSION(info)	(1UL << ((info)->bits))
+#define NUM_ASIDS(info)			(1UL << ((info)->bits))
+
+#define ASID_FIRST_VERSION(info)	NUM_ASIDS(info)
 
 #ifdef CONFIG_UNMAP_KERNEL_AT_EL0
 #define ASID_PER_CONTEXT		2
@@ -56,7 +58,7 @@ static DEFINE_PER_CPU(u64, reserved_asids);
 #define ASID_PER_CONTEXT		1
 #endif
 
-#define NUM_CTXT_ASIDS(info)		(ASID_FIRST_VERSION(info) >> (info)->ctxt_shift)
+#define NUM_CTXT_ASIDS(info)		(NUM_ASIDS(info) >> (info)->ctxt_shift)
 #define asid2idx(info, asid)		(((asid) & ~ASID_MASK(info)) >> (info)->ctxt_shift)
 #define idx2asid(info, idx)		(((idx) << (info)->ctxt_shift) & ~ASID_MASK(info))
 
-- 
2.11.0
