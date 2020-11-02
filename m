Return-Path: <SRS0=lygO=EI=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C95C2D0A3
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 19:16:22 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C66F12225E
	for <kvmarm@archiver.kernel.org>; Mon,  2 Nov 2020 19:16:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="aTalKTQO"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C66F12225E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3B3E64B5C8;
	Mon,  2 Nov 2020 14:16:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UgPLVvTm3et1; Mon,  2 Nov 2020 14:16:19 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D59C84B589;
	Mon,  2 Nov 2020 14:16:18 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CAA64B4E0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 14:16:18 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UjGSzn7nBo1u for <kvmarm@lists.cs.columbia.edu>;
 Mon,  2 Nov 2020 14:16:17 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 1E71F4B4E1
 for <kvmarm@lists.cs.columbia.edu>; Mon,  2 Nov 2020 14:16:17 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 9C5642225E;
 Mon,  2 Nov 2020 19:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1604344575;
 bh=ArWFBoK0fRQku7Ixro39jAGqWAPrMQvy0PpraNIOiA0=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=aTalKTQOzsoIcqJTNcdFWelDURIMQRP2hAwYF5ArRJ22GTesagAqw/3Kocidf0mhv
 eLhC745L7k0MGSpIflzdaY3KuAwcoo+9U94/qEug+/Ig5e6G13qwrkxJnnxm8K5vtq
 BwmIkKpNbsDkmdlfFc6IDS26QgppZHZeca+j8rNk=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1kZfJN-006nxn-Ls; Mon, 02 Nov 2020 19:16:13 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH 1/8] KVM: arm64: Move AArch32 exceptions over to AArch64
 sysregs
Date: Mon,  2 Nov 2020 19:16:02 +0000
Message-Id: <20201102191609.265711-2-maz@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201102191609.265711-1-maz@kernel.org>
References: <20201102191609.265711-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com
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

The use of the AArch32-specific accessors have always been a bit
annoying on 64bit, and it is time for a change.

Let's move the AArch32 exception injection over to the AArch64 encoding,
which requires us to split the two halves of FAR_EL1 into DFAR and IFAR.
This enables us to drop the preempt_disable() games on VHE, and to kill
the last user of the vcpu_cp15() macro.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  1 -
 arch/arm64/kvm/inject_fault.c     | 62 ++++++++++---------------------
 2 files changed, 20 insertions(+), 43 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7a1faf917f3c..a6778c39157d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -561,7 +561,6 @@ static inline bool __vcpu_write_sys_reg_to_cpu(u64 val, int reg)
 #define CPx_BIAS		IS_ENABLED(CONFIG_CPU_BIG_ENDIAN)
 
 #define vcpu_cp14(v,r)		((v)->arch.ctxt.copro[(r) ^ CPx_BIAS])
-#define vcpu_cp15(v,r)		((v)->arch.ctxt.copro[(r) ^ CPx_BIAS])
 
 struct kvm_vm_stat {
 	ulong remote_tlb_flush;
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index e2a2e48ca371..975f65ba6a8b 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -69,26 +69,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 #define DFSR_FSC_EXTABT_LPAE	0x10
 #define DFSR_FSC_EXTABT_nLPAE	0x08
 #define DFSR_LPAE		BIT(9)
-
-static bool pre_fault_synchronize(struct kvm_vcpu *vcpu)
-{
-	preempt_disable();
-	if (vcpu->arch.sysregs_loaded_on_cpu) {
-		kvm_arch_vcpu_put(vcpu);
-		return true;
-	}
-
-	preempt_enable();
-	return false;
-}
-
-static void post_fault_synchronize(struct kvm_vcpu *vcpu, bool loaded)
-{
-	if (loaded) {
-		kvm_arch_vcpu_load(vcpu, smp_processor_id());
-		preempt_enable();
-	}
-}
+#define TTBCR_EAE		BIT(31)
 
 static void inject_undef32(struct kvm_vcpu *vcpu)
 {
@@ -100,39 +81,36 @@ static void inject_undef32(struct kvm_vcpu *vcpu)
  * Modelled after TakeDataAbortException() and TakePrefetchAbortException
  * pseudocode.
  */
-static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt,
-			 unsigned long addr)
+static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt, u32 addr)
 {
-	u32 *far, *fsr;
-	bool is_lpae;
-	bool loaded;
+	u64 far;
+	u32 fsr;
+
+	/* Give the guest an IMPLEMENTATION DEFINED exception */
+	if (__vcpu_sys_reg(vcpu, TCR_EL1) & TTBCR_EAE) {
+		fsr = DFSR_LPAE | DFSR_FSC_EXTABT_LPAE;
+	} else {
+		/* no need to shuffle FS[4] into DFSR[10] as its 0 */
+		fsr = DFSR_FSC_EXTABT_nLPAE;
+	}
 
-	loaded = pre_fault_synchronize(vcpu);
+	far = vcpu_read_sys_reg(vcpu, FAR_EL1);
 
 	if (is_pabt) {
 		vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA32_IABT |
 				     KVM_ARM64_PENDING_EXCEPTION);
-		far = &vcpu_cp15(vcpu, c6_IFAR);
-		fsr = &vcpu_cp15(vcpu, c5_IFSR);
+		far &= GENMASK(31, 0);
+		far |= (u64)addr << 32;
+		vcpu_write_sys_reg(vcpu, fsr, IFSR32_EL2);
 	} else { /* !iabt */
 		vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA32_DABT |
 				     KVM_ARM64_PENDING_EXCEPTION);
-		far = &vcpu_cp15(vcpu, c6_DFAR);
-		fsr = &vcpu_cp15(vcpu, c5_DFSR);
-	}
-
-	*far = addr;
-
-	/* Give the guest an IMPLEMENTATION DEFINED exception */
-	is_lpae = (vcpu_cp15(vcpu, c2_TTBCR) >> 31);
-	if (is_lpae) {
-		*fsr = DFSR_LPAE | DFSR_FSC_EXTABT_LPAE;
-	} else {
-		/* no need to shuffle FS[4] into DFSR[10] as its 0 */
-		*fsr = DFSR_FSC_EXTABT_nLPAE;
+		far &= GENMASK(63, 32);
+		far |= addr;
+		vcpu_write_sys_reg(vcpu, fsr, ESR_EL1);
 	}
 
-	post_fault_synchronize(vcpu, loaded);
+	vcpu_write_sys_reg(vcpu, far, FAR_EL1);
 }
 
 /**
-- 
2.28.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
