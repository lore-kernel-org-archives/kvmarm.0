Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E257C2BB41
	for <kvmarm@archiver.kernel.org>; Tue, 16 Aug 2022 19:26:14 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C4D0B4D419;
	Tue, 16 Aug 2022 15:26:13 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@linux.dev
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id bvmFlKzuwAEJ; Tue, 16 Aug 2022 15:26:12 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7492A4D44B;
	Tue, 16 Aug 2022 15:26:12 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D81CC4D3F0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2022 15:26:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yObtoTxONi9d for <kvmarm@lists.cs.columbia.edu>;
 Tue, 16 Aug 2022 15:26:10 -0400 (EDT)
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61CBE4D3F8
 for <kvmarm@lists.cs.columbia.edu>; Tue, 16 Aug 2022 15:26:10 -0400 (EDT)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and
 include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
 t=1660677969;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=QCCaUkqGTfSOC9Q7jycETJL5i/VHIINjDkTfwGnQnIE=;
 b=wFvE44s/1zjD8BxtwFuYMS01bGyTRQJ+XIqx/lctvnjMxLrFvFE6CcY1055RYbE2wXdwk2
 DmjV75mcLMOOcqo03Sd1mWud6JOmCXehWH0BI1bQNH6bnDorKfWKZAyD+WUs3Lr+bNv1rU
 Pdkyrc51m5gzNVnBQtQ1XJqiek9UTk8=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 1/2] KVM: arm64: Treat PMCR_EL1.LC as RES1 on asymmetric
 systems
Date: Tue, 16 Aug 2022 19:25:53 +0000
Message-Id: <20220816192554.1455559-2-oliver.upton@linux.dev>
In-Reply-To: <20220816192554.1455559-1-oliver.upton@linux.dev>
References: <20220816192554.1455559-1-oliver.upton@linux.dev>
MIME-Version: 1.0
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Cc: kvm@vger.kernel.org, maz@kernel.org, will@kernel.org,
 linux-arm-kernel@lists.infradead.org
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

KVM does not support AArch32 on asymmetric systems. To that end, enforce
AArch64-only behavior on PMCR_EL1.LC when on an asymmetric system.

Fixes: 2122a833316f ("arm64: Allow mismatched 32-bit EL0 support")
Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h | 4 ++++
 arch/arm64/kvm/arm.c              | 3 +--
 arch/arm64/kvm/sys_regs.c         | 4 ++--
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index f38ef299f13b..e9c9388ccc02 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -929,6 +929,10 @@ bool kvm_arm_vcpu_is_finalized(struct kvm_vcpu *vcpu);
 	(system_supports_mte() &&				\
 	 test_bit(KVM_ARCH_FLAG_MTE_ENABLED, &(kvm)->arch.flags))
 
+#define kvm_supports_32bit_el0()				\
+	(system_supports_32bit_el0() &&				\
+	 !static_branch_unlikely(&arm64_mismatched_32bit_el0))
+
 int kvm_trng_call(struct kvm_vcpu *vcpu);
 #ifdef CONFIG_KVM
 extern phys_addr_t hyp_mem_base;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 986cee6fbc7f..2ff0ef62abad 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -757,8 +757,7 @@ static bool vcpu_mode_is_bad_32bit(struct kvm_vcpu *vcpu)
 	if (likely(!vcpu_mode_is_32bit(vcpu)))
 		return false;
 
-	return !system_supports_32bit_el0() ||
-		static_branch_unlikely(&arm64_mismatched_32bit_el0);
+	return !kvm_supports_32bit_el0();
 }
 
 /**
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index c059b259aea6..3234f50b8c4b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -652,7 +652,7 @@ static void reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 	 */
 	val = ((pmcr & ~ARMV8_PMU_PMCR_MASK)
 	       | (ARMV8_PMU_PMCR_MASK & 0xdecafbad)) & (~ARMV8_PMU_PMCR_E);
-	if (!system_supports_32bit_el0())
+	if (!kvm_supports_32bit_el0())
 		val |= ARMV8_PMU_PMCR_LC;
 	__vcpu_sys_reg(vcpu, r->reg) = val;
 }
@@ -701,7 +701,7 @@ static bool access_pmcr(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 		val = __vcpu_sys_reg(vcpu, PMCR_EL0);
 		val &= ~ARMV8_PMU_PMCR_MASK;
 		val |= p->regval & ARMV8_PMU_PMCR_MASK;
-		if (!system_supports_32bit_el0())
+		if (!kvm_supports_32bit_el0())
 			val |= ARMV8_PMU_PMCR_LC;
 		__vcpu_sys_reg(vcpu, PMCR_EL0) = val;
 		kvm_pmu_handle_pmcr(vcpu, val);
-- 
2.37.1.595.g718a3a8f04-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
