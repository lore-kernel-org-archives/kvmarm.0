From: Dongjiu Geng <gengdongjiu@huawei.com>
Subject: [PATCH v1 1/3] arm64: add a macro for SError synchronization
Date: Thu, 2 Nov 2017 03:14:55 +0800
Message-ID: <1509563697-6359-2-git-send-email-gengdongjiu@huawei.com>
References: <1509563697-6359-1-git-send-email-gengdongjiu@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1509563697-6359-1-git-send-email-gengdongjiu@huawei.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: catalin.marinas@arm.com, will.deacon@arm.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, james.morse@arm.com, mark.rutland@arm.com, ard.biesheuvel@linaro.org, robin.murphy@arm.com, cov@codeaurora.org, Dave.Martin@arm.com, gengdongjiu@huawei.com, suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

ARMv8.2 adds a control bit to each SCTLR_ELx to insert implicit
Error Synchronization Barrier(IESB) operations at exception handler entry
and exit. But not all hardware platform which support RAS Extension
can support IESB. So for this case, software needs to manually insert
Error Synchronization Barrier(ESB) operations.

In this macros, if system supports RAS Extensdddon instead of IESB,
it will insert an ESB instruction.

Signed-off-by: Dongjiu Geng <gengdongjiu@huawei.com>
---
 arch/arm64/include/asm/assembler.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/include/asm/assembler.h b/arch/arm64/include/asm/assembler.h
index d4c0adf..e6c79c4 100644
--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -517,4 +517,13 @@
 #endif
 	.endm
 
+	.macro	error_synchronize
+alternative_if ARM64_HAS_IESB
+	b	1f
+alternative_else_nop_endif
+alternative_if ARM64_HAS_RAS_EXTN
+	esb
+alternative_else_nop_endif
+1:
+	.endm
 #endif	/* __ASM_ASSEMBLER_H */
-- 
1.9.1
