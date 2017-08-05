From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 06/15] ARM: sleep.S: use PC-relative insn sequence for
 sleep_save_sp/mpidr_hash
Date: Sat,  5 Aug 2017 21:52:13 +0100
Message-ID: <20170805205222.19868-7-ard.biesheuvel@linaro.org>
References: <20170805205222.19868-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CD21049C2B
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:52:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gwSiZqhIX+fg for <kvmarm@lists.cs.columbia.edu>;
 Sat,  5 Aug 2017 16:52:04 -0400 (EDT)
Received: from mail-wm0-f41.google.com (mail-wm0-f41.google.com [74.125.82.41])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ED5DD49C2C
 for <kvmarm@lists.cs.columbia.edu>; Sat,  5 Aug 2017 16:52:03 -0400 (EDT)
Received: by mail-wm0-f41.google.com with SMTP id t201so42447824wmt.1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 05 Aug 2017 13:53:27 -0700 (PDT)
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

Replace the open coded PC relative offset calculations with adr_l and
ldr_l invocations.

Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 arch/arm/kernel/sleep.S | 16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

diff --git a/arch/arm/kernel/sleep.S b/arch/arm/kernel/sleep.S
index 0f6c1000582c..3026b119d3ff 100644
--- a/arch/arm/kernel/sleep.S
+++ b/arch/arm/kernel/sleep.S
@@ -137,9 +137,8 @@ ARM_BE8(setend be)			@ ensure we are in BE mode
 	mov	r1, #0
 	ALT_SMP(mrc p15, 0, r0, c0, c0, 5)
 	ALT_UP_B(1f)
-	adr	r2, mpidr_hash_ptr
-	ldr	r3, [r2]
-	add	r2, r2, r3		@ r2 = struct mpidr_hash phys address
+	adr_l	r2, mpidr_hash		@ r2 = struct mpidr_hash phys address
+
 	/*
 	 * This ldmia relies on the memory layout of the mpidr_hash
 	 * struct mpidr_hash.
@@ -147,10 +146,7 @@ ARM_BE8(setend be)			@ ensure we are in BE mode
 	ldmia	r2, { r3-r6 }	@ r3 = mpidr mask (r4,r5,r6) = l[0,1,2] shifts
 	compute_mpidr_hash	r1, r4, r5, r6, r0, r3
 1:
-	adr	r0, _sleep_save_sp
-	ldr	r2, [r0]
-	add	r0, r0, r2
-	ldr	r0, [r0, #SLEEP_SAVE_SP_PHYS]
+	ldr_l	r0, sleep_save_sp + SLEEP_SAVE_SP_PHYS
 	ldr	r0, [r0, r1, lsl #2]
 
 	@ load phys pgd, stack, resume fn
@@ -164,12 +160,6 @@ ENDPROC(cpu_resume)
 ENDPROC(cpu_resume_arm)
 #endif
 
-	.align 2
-_sleep_save_sp:
-	.long	sleep_save_sp - .
-mpidr_hash_ptr:
-	.long	mpidr_hash - .			@ mpidr_hash struct offset
-
 	.data
 	.type	sleep_save_sp, #object
 ENTRY(sleep_save_sp)
-- 
2.11.0
