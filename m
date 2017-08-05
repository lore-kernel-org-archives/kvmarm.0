From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 03/15] ARM: head-common.S: use PC-relative insn sequence for
 __turn_mmu_on
Date: Sat,  5 Aug 2017 21:52:10 +0100
Message-ID: <20170805205222.19868-4-ard.biesheuvel@linaro.org>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E237E49C2F
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:51:54 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id z7+ixEMl1GUZ for <kvmarm@lists.cs.columbia.edu>;
 Sat,  5 Aug 2017 16:51:54 -0400 (EDT)
Received: from mail-wr0-f178.google.com (mail-wr0-f178.google.com
 [209.85.128.178])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7E33E49C51
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:51:53 -0400 (EDT)
Received: by mail-wr0-f178.google.com with SMTP id 33so27138899wrz.4
 for <kvmarm@lists.cs.columbia.edu>; Sat, 05 Aug 2017 13:53:17 -0700 (PDT)
In-Reply-To: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, linux-renesas-soc@vger.kernel.org, linux@armlinux.org.uk, linux-omap@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, krzk@kernel.org, jason@lakedaemon.net, arm@kernel.org, andrew@lunn.ch, gregory.clement@free-electrons.com, sebastian.hesselbarth@gmail.com, tony@atomide.com, baohua@kernel.org, horms@verge.net.au, magnus.damm@gmail.com, vireshk@kernel.org, shiraz.linux.kernel@gmail.com, patrice.chotard@st.com, nico@linaro.org, dave.martin@arm.com, marc.zyngier@arm.com
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

Replace the open coded PC relative offset calculations with a pair
of adr_l invocations.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/kernel/head.S | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 04286fd9e09c..0a98aec0e39d 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -227,11 +227,8 @@ __create_page_tables:
 	 * Create identity mapping to cater for __enable_mmu.
 	 * This identity mapping will be removed by paging_init().
 	 */
-	adr	r0, __turn_mmu_on_loc
-	ldmia	r0, {r3, r5, r6}
-	sub	r0, r0, r3			@ virt->phys offset
-	add	r5, r5, r0			@ phys __turn_mmu_on
-	add	r6, r6, r0			@ phys __turn_mmu_on_end
+	adr_l	r5, __turn_mmu_on		@ _pa(__turn_mmu_on)
+	adr_l	r6, __turn_mmu_on_end		@ _pa(__turn_mmu_on_end)
 	mov	r5, r5, lsr #SECTION_SHIFT
 	mov	r6, r6, lsr #SECTION_SHIFT
 
@@ -354,11 +351,6 @@ __create_page_tables:
 	ret	lr
 ENDPROC(__create_page_tables)
 	.ltorg
-	.align
-__turn_mmu_on_loc:
-	.long	.
-	.long	__turn_mmu_on
-	.long	__turn_mmu_on_end
 
 #if defined(CONFIG_SMP)
 	.text
-- 
2.11.0
