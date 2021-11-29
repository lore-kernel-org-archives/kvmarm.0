Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12AE1C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 29 Nov 2021 20:02:31 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BD2E44B0AC;
	Mon, 29 Nov 2021 15:02:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0Q5BADjJb2VS; Mon, 29 Nov 2021 15:02:29 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A03A4B13A;
	Mon, 29 Nov 2021 15:02:24 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D73DE4B17C
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:02:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id q1MNh7Z0G7WA for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Nov 2021 15:02:20 -0500 (EST)
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D6B494B132
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Nov 2021 15:02:18 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by sin.source.kernel.org (Postfix) with ESMTPS id 62DFDCE140C;
 Mon, 29 Nov 2021 20:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D9AC53FAD;
 Mon, 29 Nov 2021 20:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1638216133;
 bh=r2zyjUbW431vWjGfEyo5zmYNkop2GFGeaSvf8QOmSMo=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=EjYmTQirDu3m4f5lKlxvDLTYNjGSTemd7eeSZYsjZ0VxQd478nYCG5i7aTWeoZo+D
 2yG75h2tKkwJHJGxk2QHkhgGx4z4TpZozGO6DKH5a2Y6mBinhzfQ3mPaHzIG9oj4m0
 JbYB6IryWwoomt5rTBEHZTX34U1jp2Su3Ld88OT1cYWbUCLlMG0c8OtP5j07OPAJNY
 slrFUiSftmudeph1C8l9tYJedNHM9mcJEVMC/3n5n5egLKAawi/3q696wy/vRaoaA0
 vegq+DNslIiL3pKXBT7LvK6t2RA4u1wlKFb8Wc+LHjdVRe4hZL0bsav3R+Baiw7mdk
 iVwZHj4aMHZmQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1mrmqp-008gvR-Lh; Mon, 29 Nov 2021 20:02:11 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v5 08/69] KVM: arm64: nv: Reset VCPU to EL2 registers if VCPU
 nested virt is set
Date: Mon, 29 Nov 2021 20:00:49 +0000
Message-Id: <20211129200150.351436-9-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211129200150.351436-1-maz@kernel.org>
References: <20211129200150.351436-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, jintack@cs.columbia.edu, haibo.xu@linaro.org,
 gankulkarni@os.amperecomputing.com, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Andre Przywara <andre.przywara@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>
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

From: Christoffer Dall <christoffer.dall@arm.com>

Reset the VCPU with PSTATE.M = EL2h when the nested virtualization
feature is enabled on the VCPU.

Signed-off-by: Christoffer Dall <christoffer.dall@arm.com>
[maz: rework register reset not to use empty data structures]
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/reset.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 426bd7fbc3fd..38a7182819fb 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -27,6 +27,7 @@
 #include <asm/kvm_asm.h>
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
+#include <asm/kvm_nested.h>
 #include <asm/virt.h>
 
 /* Maximum phys_shift supported for any VM on this host */
@@ -38,6 +39,9 @@ static u32 kvm_ipa_limit;
 #define VCPU_RESET_PSTATE_EL1	(PSR_MODE_EL1h | PSR_A_BIT | PSR_I_BIT | \
 				 PSR_F_BIT | PSR_D_BIT)
 
+#define VCPU_RESET_PSTATE_EL2	(PSR_MODE_EL2h | PSR_A_BIT | PSR_I_BIT | \
+				 PSR_F_BIT | PSR_D_BIT)
+
 #define VCPU_RESET_PSTATE_SVC	(PSR_AA32_MODE_SVC | PSR_AA32_A_BIT | \
 				 PSR_AA32_I_BIT | PSR_AA32_F_BIT)
 
@@ -176,8 +180,8 @@ static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
 	if (!cpus_have_const_cap(ARM64_HAS_32BIT_EL1) && is32bit)
 		return false;
 
-	/* MTE is incompatible with AArch32 */
-	if (kvm_has_mte(vcpu->kvm) && is32bit)
+	/* MTE and NV are incompatible with AArch32 */
+	if ((kvm_has_mte(vcpu->kvm) || nested_virt_in_use(vcpu)) && is32bit)
 		return false;
 
 	/* Check that the vcpus are either all 32bit or all 64bit */
@@ -255,6 +259,8 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	default:
 		if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features)) {
 			pstate = VCPU_RESET_PSTATE_SVC;
+		} else if (nested_virt_in_use(vcpu)) {
+			pstate = VCPU_RESET_PSTATE_EL2;
 		} else {
 			pstate = VCPU_RESET_PSTATE_EL1;
 		}
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
