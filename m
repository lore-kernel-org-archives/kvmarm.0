From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v2 02/18] arm64: KVM: Always reference __hyp_panic_string via
 its kernel VA
Date: Thu, 30 Jun 2016 18:40:35 +0100
Message-ID: <1467308451-13365-3-git-send-email-marc.zyngier@arm.com>
References: <1467308451-13365-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1EE6D49B54
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 13:35:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kJWC1iVESMTT for <kvmarm@lists.cs.columbia.edu>;
 Thu, 30 Jun 2016 13:35:44 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2DD8549B56
 for <kvmarm@lists.cs.columbia.edu>; Thu, 30 Jun 2016 13:35:44 -0400 (EDT)
In-Reply-To: <1467308451-13365-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

__hyp_panic_string is passed via the HYP panic code to the panic
function, and is being "upgraded" to a kernel address, as it is
referenced by the HYP code (in a PC-relative way).

This is a bit silly, and we'd be better off obtaining the kernel
address and not mess with it at all. This patch implements this
with a tiny bit of asm glue, by forcing the string pointer to be
read from the literal pool.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kvm/hyp/switch.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 437cfad..81f21a2 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -299,9 +299,16 @@ static const char __hyp_panic_string[] = "HYP panic:\nPS:%08llx PC:%016llx ESR:%
 
 static void __hyp_text __hyp_call_panic_nvhe(u64 spsr, u64 elr, u64 par)
 {
-	unsigned long str_va = (unsigned long)__hyp_panic_string;
+	unsigned long str_va;
 
-	__hyp_do_panic(hyp_kern_va(str_va),
+	/*
+	 * Force the panic string to be loaded from the literal pool,
+	 * making sure it is a kernel address and not a PC-relative
+	 * reference.
+	 */
+	asm volatile("ldr %0, =__hyp_panic_string" : "=r" (str_va));
+
+	__hyp_do_panic(str_va,
 		       spsr,  elr,
 		       read_sysreg(esr_el2),   read_sysreg_el2(far),
 		       read_sysreg(hpfar_el2), par,
-- 
2.1.4
