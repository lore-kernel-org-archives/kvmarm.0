Return-Path: <SRS0=9u6M=GK=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CEC3C433E6
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 11:21:30 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C07FB23343
	for <kvmarm@archiver.kernel.org>; Thu,  7 Jan 2021 11:21:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C07FB23343
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6796A4B3BC;
	Thu,  7 Jan 2021 06:21:29 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xtYdgwDA9guE; Thu,  7 Jan 2021 06:21:28 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 963674B3D8;
	Thu,  7 Jan 2021 06:21:25 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 98F0E4B3E1
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2021 06:21:24 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Kx75th1bSCd6 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Jan 2021 06:21:23 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id F18094B3CE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Jan 2021 06:21:22 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 14B5E2333D;
 Thu,  7 Jan 2021 11:21:22 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kxTM0-005p1o-8l; Thu, 07 Jan 2021 11:21:20 +0000
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 05/18] KVM: arm64: Minor cleanup of hyp variables used in host
Date: Thu,  7 Jan 2021 11:20:48 +0000
Message-Id: <20210107112101.2297944-6-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210107112101.2297944-1-maz@kernel.org>
References: <20210107112101.2297944-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: pbonzini@redhat.com, alexandru.elisei@arm.com,
 catalin.marinas@arm.com, dbrazdil@google.com, eric.auger@redhat.com,
 mark.rutland@arm.com, natechancellor@gmail.com, qcai@redhat.com,
 shannon.zhao@linux.alibaba.com, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, kvm@vger.kernel.org, Qian Cai <qcai@redhat.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Shannon Zhao <shannon.zhao@linux.alibaba.com>,
 linux-arm-kernel@lists.infradead.org,
 Nathan Chancellor <natechancellor@gmail.com>, kvmarm@lists.cs.columbia.edu
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

From: David Brazdil <dbrazdil@google.com>

Small cleanup moving declarations of hyp-exported variables to
kvm_host.h and using macros to avoid having to refer to them with
kvm_nvhe_sym() in host.

No functional change intended.

Signed-off-by: David Brazdil <dbrazdil@google.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20201208142452.87237-5-dbrazdil@google.com
---
 arch/arm64/include/asm/kvm_host.h | 6 ++++++
 arch/arm64/kvm/arm.c              | 4 +---
 arch/arm64/kvm/hyp/nvhe/hyp-smp.c | 6 +++---
 arch/arm64/kvm/va_layout.c        | 5 ++---
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 828d50d40dc2..bce2452b305c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -260,6 +260,12 @@ struct kvm_host_psci_config {
 extern struct kvm_host_psci_config kvm_nvhe_sym(kvm_host_psci_config);
 #define kvm_host_psci_config CHOOSE_NVHE_SYM(kvm_host_psci_config)
 
+extern s64 kvm_nvhe_sym(hyp_physvirt_offset);
+#define hyp_physvirt_offset CHOOSE_NVHE_SYM(hyp_physvirt_offset)
+
+extern u64 kvm_nvhe_sym(hyp_cpu_logical_map)[NR_CPUS];
+#define hyp_cpu_logical_map CHOOSE_NVHE_SYM(hyp_cpu_logical_map)
+
 struct vcpu_reset_state {
 	unsigned long	pc;
 	unsigned long	r0;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 6a2f4e01b04f..836ca763b91d 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -65,8 +65,6 @@ static bool vgic_present;
 static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
 DEFINE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
-extern u64 kvm_nvhe_sym(__cpu_logical_map)[NR_CPUS];
-
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
@@ -1602,7 +1600,7 @@ static void init_cpu_logical_map(void)
 	 * allow any other CPUs from the `possible` set to boot.
 	 */
 	for_each_online_cpu(cpu)
-		kvm_nvhe_sym(__cpu_logical_map)[cpu] = cpu_logical_map(cpu);
+		hyp_cpu_logical_map[cpu] = cpu_logical_map(cpu);
 }
 
 static bool init_psci_relay(void)
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
index cbab0c6246e2..2997aa156d8e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-smp.c
@@ -14,14 +14,14 @@
  * Other CPUs should not be allowed to boot because their features were
  * not checked against the finalized system capabilities.
  */
-u64 __ro_after_init __cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID_HWID };
+u64 __ro_after_init hyp_cpu_logical_map[NR_CPUS] = { [0 ... NR_CPUS-1] = INVALID_HWID };
 
 u64 cpu_logical_map(unsigned int cpu)
 {
-	if (cpu >= ARRAY_SIZE(__cpu_logical_map))
+	if (cpu >= ARRAY_SIZE(hyp_cpu_logical_map))
 		hyp_panic();
 
-	return __cpu_logical_map[cpu];
+	return hyp_cpu_logical_map[cpu];
 }
 
 unsigned long __hyp_per_cpu_offset(unsigned int cpu)
diff --git a/arch/arm64/kvm/va_layout.c b/arch/arm64/kvm/va_layout.c
index 914732b88c69..70fcd6a12fe1 100644
--- a/arch/arm64/kvm/va_layout.c
+++ b/arch/arm64/kvm/va_layout.c
@@ -34,17 +34,16 @@ static u64 __early_kern_hyp_va(u64 addr)
 }
 
 /*
- * Store a hyp VA <-> PA offset into a hyp-owned variable.
+ * Store a hyp VA <-> PA offset into a EL2-owned variable.
  */
 static void init_hyp_physvirt_offset(void)
 {
-	extern s64 kvm_nvhe_sym(hyp_physvirt_offset);
 	u64 kern_va, hyp_va;
 
 	/* Compute the offset from the hyp VA and PA of a random symbol. */
 	kern_va = (u64)lm_alias(__hyp_text_start);
 	hyp_va = __early_kern_hyp_va(kern_va);
-	CHOOSE_NVHE_SYM(hyp_physvirt_offset) = (s64)__pa(kern_va) - (s64)hyp_va;
+	hyp_physvirt_offset = (s64)__pa(kern_va) - (s64)hyp_va;
 }
 
 /*
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
