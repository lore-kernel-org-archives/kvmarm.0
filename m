From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 21/25] arm/arm64: KVM: Use HVC_RESET_VECTORS to reinit HYP
 mode
Date: Mon,  6 Mar 2017 14:24:54 +0000
Message-ID: <20170306142458.8875-22-marc.zyngier@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 584C940C4E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:25:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 6HxDjF23UsL3 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Mar 2017 09:25:30 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B49C640C4B
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:25:30 -0500 (EST)
In-Reply-To: <20170306142458.8875-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, cdall@linaro.org, james.morse@arm.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Instead of trying to compare the value given by __hyp_get_vectors(),
which doesn't offer any real guarantee to be the stub's address, use
HVC_RESET_VECTORS to make sure we're in a sane state to reinstall
KVM across PM events.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/arm.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index c07284044b1e..2c192634a27d 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -53,7 +53,6 @@ __asm__(".arch_extension	virt");
 
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 static kvm_cpu_context_t __percpu *kvm_host_cpu_state;
-static unsigned long hyp_default_vectors;
 
 /* Per-CPU variable containing the currently running vcpu. */
 static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_arm_running_vcpu);
@@ -1109,8 +1108,16 @@ static void cpu_init_hyp_mode(void *dummy)
 	kvm_arm_init_debug();
 }
 
+static void cpu_hyp_reset(void)
+{
+	if (!is_kernel_in_hyp_mode())
+		__hyp_reset_vectors();
+}
+
 static void cpu_hyp_reinit(void)
 {
+	cpu_hyp_reset();
+
 	if (is_kernel_in_hyp_mode()) {
 		/*
 		 * __cpu_init_stage2() is safe to call even if the PM
@@ -1118,17 +1125,10 @@ static void cpu_hyp_reinit(void)
 		 */
 		__cpu_init_stage2();
 	} else {
-		if (__hyp_get_vectors() == hyp_default_vectors)
-			cpu_init_hyp_mode(NULL);
+		cpu_init_hyp_mode(NULL);
 	}
 }
 
-static void cpu_hyp_reset(void)
-{
-	if (!is_kernel_in_hyp_mode())
-		__hyp_reset_vectors();
-}
-
 static void _kvm_arch_hardware_enable(void *discard)
 {
 	if (!__this_cpu_read(kvm_arm_hardware_enabled)) {
@@ -1312,12 +1312,6 @@ static int init_hyp_mode(void)
 		goto out_err;
 
 	/*
-	 * It is probably enough to obtain the default on one
-	 * CPU. It's unlikely to be different on the others.
-	 */
-	hyp_default_vectors = __hyp_get_vectors();
-
-	/*
 	 * Allocate stack pages for Hypervisor-mode
 	 */
 	for_each_possible_cpu(cpu) {
-- 
2.11.0
