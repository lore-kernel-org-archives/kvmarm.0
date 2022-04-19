Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31B66C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 19 Apr 2022 11:25:20 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E0EB24B1C0;
	Tue, 19 Apr 2022 07:25:19 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id LWSvMkOV0QxE; Tue, 19 Apr 2022 07:25:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C4AD4B218;
	Tue, 19 Apr 2022 07:25:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C6BA149E08
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 07:25:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 1UXLI5ieElhb for <kvmarm@lists.cs.columbia.edu>;
 Tue, 19 Apr 2022 07:25:15 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2893C40FF0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 19 Apr 2022 07:25:15 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id B44E0612B9;
 Tue, 19 Apr 2022 11:25:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E96EC385AA;
 Tue, 19 Apr 2022 11:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1650367514;
 bh=ViGq+zF6izj/CNFirw1Nz+T6V2thMBCW7ReQKJIV4Zc=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=f/wC3LTBLl7na7R7saDeaqiMUTLLmlytjsT6KnjLcIu7T8n5hECNMlcVplrzya0hR
 7qWLpGTeW4yTH5oiw18qaJHyHhwS+HlSWRXIXp7ublAjiFn8RkUeWKENKrf7YmDTnO
 MJLJTqOZfZmJfd17SwqWirKy439yvZrdWm1k1vsLqbbfkS674fu5SlHslT4Gh6OlnZ
 8DqeDZrRebtVHEcfjVeSda2ISROdX4WJWTfKgxigQPVkUBc9KqKJJZ9IxewTWtKgFe
 UotNRKGfbOb2SzWj4bRX3Ik+8u78/cagwGlsrh0YaNPGGjXCf3xewrDWViEbkQiIpb
 5vn6SWSdI0azQ==
From: Mark Brown <broonie@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
 Shuah Khan <shuah@kernel.org>
Subject: [PATCH v14 26/39] KVM: arm64: Handle SME host state when running
 guests
Date: Tue, 19 Apr 2022 12:22:34 +0100
Message-Id: <20220419112247.711548-27-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220419112247.711548-1-broonie@kernel.org>
References: <20220419112247.711548-1-broonie@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4067; h=from:subject;
 bh=ViGq+zF6izj/CNFirw1Nz+T6V2thMBCW7ReQKJIV4Zc=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBiXpt885Enj0B0Fr4fwtQnKM008QGdciEJBgy4YdZq
 AkRBR+yJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCYl6bfAAKCRAk1otyXVSH0MrgB/
 9layyxgo06k0jUEdp3vgihKnQD4a5vhH62DPhKLkpAv8f2BVVWXJ1ivGjpV/585X64xyS6X9vSLSW0
 mioiww209s7UC8SOKoot3e/V6fH12eEqAsi8HQiRgaQ5wzL+EESrBkVqWb6HXz76329w5hQ+GjpcPH
 kUoAMDzymAJ7I3IezfVris4adMaec91uVJoRT6Ma0WJvD4uXRnNaeXz1+AaDOmCnJPwbIo6JV9SHpG
 YsHqvJJMkEmkPamLyCEbfX4kdQfB6mAfpSuhZ98xsIc96YbkfrdzksQbm/y+wa8SxXGO0JPS418IQ7
 0TWTvVsthkOhm17lPbAmJQW6/UXhpH
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB
Cc: Basant Kumar Dwivedi <Basant.KumarDwivedi@arm.com>,
 Luis Machado <luis.machado@arm.com>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Mark Brown <broonie@kernel.org>, linux-arm-kernel@lists.infradead.org,
 linux-kselftest@vger.kernel.org, Alan Hayward <alan.hayward@arm.com>,
 kvmarm@lists.cs.columbia.edu, Salil Akerkar <Salil.Akerkar@arm.com>,
 Luca Salabrino <luca.scalabrino@arm.com>
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

While we don't currently support SME in guests we do currently support it
for the host system so we need to take care of SME's impact, including
the floating point register state, when running guests. Simiarly to SVE
we need to manage the traps in CPACR_RL1, what is new is the handling of
streaming mode and ZA.

Normally we defer any handling of the floating point register state until
the guest first uses it however if the system is in streaming mode FPSIMD
and SVE operations may generate SME traps which we would need to distinguish
from actual attempts by the guest to use SME. Rather than do this for the
time being if we are in streaming mode when entering the guest we force
the floating point state to be saved immediately and exit streaming mode,
meaning that the guest won't generate SME traps for supported operations.

We could handle ZA in the access trap similarly to the FPSIMD/SVE state
without the disruption caused by streaming mode but for simplicity
handle it the same way as streaming mode for now.

This will be revisited when we support SME for guests (hopefully before SME
hardware becomes available), for now it will only incur additional cost on
systems with SME and even there only if streaming mode or ZA are enabled.

Signed-off-by: Mark Brown <broonie@kernel.org>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/fpsimd.c           | 36 +++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8a7c442d5b57..f8f0d30dd1a2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -454,6 +454,7 @@ struct kvm_vcpu_arch {
 #define KVM_ARM64_DEBUG_STATE_SAVE_TRBE	(1 << 13) /* Save TRBE context if active  */
 #define KVM_ARM64_FP_FOREIGN_FPSTATE	(1 << 14)
 #define KVM_ARM64_ON_UNSUPPORTED_CPU	(1 << 15) /* Physical CPU not in supported_cpus */
+#define KVM_ARM64_HOST_SME_ENABLED	(1 << 16) /* SME enabled for EL0 */
 
 #define KVM_GUESTDBG_VALID_MASK (KVM_GUESTDBG_ENABLE | \
 				 KVM_GUESTDBG_USE_SW_BP | \
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 57d7ac3cfa0c..441edb9c398c 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -82,6 +82,26 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 
 	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
 		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_ENABLED;
+
+	/*
+	 * We don't currently support SME guests but if we leave
+	 * things in streaming mode then when the guest starts running
+	 * FPSIMD or SVE code it may generate SME traps so as a
+	 * special case if we are in streaming mode we force the host
+	 * state to be saved now and exit streaming mode so that we
+	 * don't have to handle any SME traps for valid guest
+	 * operations. Do this for ZA as well for now for simplicity.
+	 */
+	if (system_supports_sme()) {
+		if (read_sysreg(cpacr_el1) & CPACR_EL1_SMEN_EL0EN)
+			vcpu->arch.flags |= KVM_ARM64_HOST_SME_ENABLED;
+
+		if (read_sysreg_s(SYS_SVCR_EL0) &
+		    (SYS_SVCR_EL0_SM_MASK | SYS_SVCR_EL0_ZA_MASK)) {
+			vcpu->arch.flags &= ~KVM_ARM64_FP_HOST;
+			fpsimd_save_and_flush_cpu_state();
+		}
+	}
 }
 
 /*
@@ -135,6 +155,22 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 
 	local_irq_save(flags);
 
+	/*
+	 * If we have VHE then the Hyp code will reset CPACR_EL1 to
+	 * CPACR_EL1_DEFAULT and we need to reenable SME.
+	 */
+	if (has_vhe() && system_supports_sme()) {
+		/* Also restore EL0 state seen on entry */
+		if (vcpu->arch.flags & KVM_ARM64_HOST_SME_ENABLED)
+			sysreg_clear_set(CPACR_EL1, 0,
+					 CPACR_EL1_SMEN_EL0EN |
+					 CPACR_EL1_SMEN_EL1EN);
+		else
+			sysreg_clear_set(CPACR_EL1,
+					 CPACR_EL1_SMEN_EL0EN,
+					 CPACR_EL1_SMEN_EL1EN);
+	}
+
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
 		if (vcpu_has_sve(vcpu)) {
 			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
