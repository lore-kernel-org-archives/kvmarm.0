From: Dave Martin <Dave.Martin@arm.com>
Subject: [PATCH v5 19/30] arm64/sve: Preserve SVE registers around kernel-mode NEON use
Date: Tue, 31 Oct 2017 15:51:11 +0000
Message-ID: <1509465082-30427-20-git-send-email-Dave.Martin@arm.com>
References: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1509465082-30427-1-git-send-email-Dave.Martin@arm.com>
Sender: linux-arch-owner@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>, Okamoto Takayuki <tokamoto@jp.fujitsu.com>, kvmarm@lists.cs.columbia.edu, libc-alpha@sourceware.org, linux-arch@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Kernel-mode NEON will corrupt the SVE vector registers, due to the
way they alias the FPSIMD vector registers in the hardware.

This patch ensures that any live SVE register content for the task
is saved by kernel_neon_begin().  The data will be restored in the
usual way on return to userspace.

Signed-off-by: Dave Martin <Dave.Martin@arm.com>
Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Reviewed-by: Alex Bennée <alex.bennee@linaro.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/kernel/fpsimd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index c112972..ae10ddb 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -885,8 +885,10 @@ void kernel_neon_begin(void)
 	__this_cpu_write(kernel_neon_busy, true);
 
 	/* Save unsaved task fpsimd state, if any: */
-	if (current->mm && !test_and_set_thread_flag(TIF_FOREIGN_FPSTATE))
-		fpsimd_save_state(&current->thread.fpsimd_state);
+	if (current->mm) {
+		task_fpsimd_save();
+		set_thread_flag(TIF_FOREIGN_FPSTATE);
+	}
 
 	/* Invalidate any task state remaining in the fpsimd regs: */
 	__this_cpu_write(fpsimd_last_state, NULL);
-- 
2.1.4
