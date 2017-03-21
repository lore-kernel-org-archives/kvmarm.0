From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 24/28] arm/arm64: KVM: Use HVC_RESET_VECTORS to reinit HYP
 mode
Date: Tue, 21 Mar 2017 19:20:54 +0000
Message-ID: <20170321192058.9300-25-marc.zyngier@arm.com>
References: <20170321192058.9300-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 63BAE40A14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 15:20:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 60Q-MvN-U9US for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 15:20:47 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6675040CA1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 15:20:47 -0400 (EDT)
In-Reply-To: <20170321192058.9300-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Keerthy <j-keerthy@ti.com>
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
index 57dd48d61796..cbd3a3150090 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -53,7 +53,6 @@ __asm__(".arch_extension	virt");
 
 static DEFINE_PER_CPU(unsigned long, kvm_arm_hyp_stack_page);
 static kvm_cpu_context_t __percpu *kvm_host_cpu_state;
-static unsigned long hyp_default_vectors;
 
 /* Per-CPU variable containing the currently running vcpu. */
 static DEFINE_PER_CPU(struct kvm_vcpu *, kvm_arm_running_vcpu);
@@ -1112,8 +1111,16 @@ static void cpu_init_hyp_mode(void *dummy)
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
@@ -1121,17 +1128,10 @@ static void cpu_hyp_reinit(void)
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
@@ -1315,12 +1315,6 @@ static int init_hyp_mode(void)
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
