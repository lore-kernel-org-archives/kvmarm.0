From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v1 2/3] arm64: add error synchronization barrier in
 kernel_entry/kernel_exit
Date: Thu, 2 Nov 2017 03:14:56 +0800
Message-ID: <1509563697-6359-3-git-send-email-gengdongjiu@huawei.com>
References: <1509563697-6359-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D1D0E49D52
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Nov 2017 07:08:47 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id aY8RV4O-qIRW for <kvmarm@lists.cs.columbia.edu>;
 Wed,  1 Nov 2017 07:08:47 -0400 (EDT)
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2D67F49D2A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  1 Nov 2017 07:08:45 -0400 (EDT)
In-Reply-To: <1509563697-6359-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: catalin.marinas@arm.com, will.deacon@arm.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, james.morse@arm.com, mark.rutland@arm.com, ard.biesheuvel@linaro.org, robin.murphy@arm.com, cov@codeaurora.org, Dave.Martin@arm.com, gengdongjiu@huawei.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

If taking an exception from or return to user space, insert
a Error Synchronization Barrier(ESB) to isolate the error.

If a user space process is pending a SError, when enter to
kernel, the SError will be immediately synchronized in the
handler entry. Otherwise if kernel space is pending a SError,
before return to user space, the SError will be synchronized
in the handler exit.

In order to reduce impact on performance, not check the DISR_EL1
to see whether an SError is consumed by an ESB instruction.
This is because DISR_EL1 is RAZ/WI in firmware-first RAS
solution, if happen SError, it will immediately trap to EL3
firmware.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 arch/arm64/kernel/entry.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/arm64/kernel/entry.S b/arch/arm64/kernel/entry.S
index e147c1d..6dde644 100644
--- a/arch/arm64/kernel/entry.S
+++ b/arch/arm64/kernel/entry.S
@@ -138,6 +138,7 @@
 	stp	x28, x29, [sp, #16 * 14]
 
 	.if	\el == 0
+	error_synchronize
 	mrs	x21, sp_el0
 	ldr_this_cpu	tsk, __entry_task, x20	// Ensure MDSCR_EL1.SS is clear,
 	ldr	x19, [tsk, #TSK_TI_FLAGS]	// since we can unmask debug
@@ -281,6 +282,7 @@ alternative_if ARM64_WORKAROUND_845719
 1:
 alternative_else_nop_endif
 #endif
+	error_synchronize
 	.endif
 
 	msr	elr_el1, x21			// set up the return data
-- 
1.9.1
