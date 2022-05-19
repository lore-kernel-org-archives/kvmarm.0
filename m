Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B0B0C433EF
	for <kvmarm@archiver.kernel.org>; Thu, 19 May 2022 13:47:08 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B97564B481;
	Thu, 19 May 2022 09:47:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id oaAyH9xnhJ5k; Thu, 19 May 2022 09:47:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FAE54B46A;
	Thu, 19 May 2022 09:47:06 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92B8C4B475
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:47:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L70n5KFv0sUZ for <kvmarm@lists.cs.columbia.edu>;
 Thu, 19 May 2022 09:47:04 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 498D94B486
 for <kvmarm@lists.cs.columbia.edu>; Thu, 19 May 2022 09:47:04 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 792656179F;
 Thu, 19 May 2022 13:47:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B259C36AE9;
 Thu, 19 May 2022 13:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1652968022;
 bh=PaDvO7OrWACJT+4yuXWM0lxUPvUE9Q+FqN8Dtq8OkYs=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=tsTVC9ijsjxTgVKN4ZxQeljZ4egvZyASLAVQrvNK+vfin5WkChvWM0MZ4vaVc8lUQ
 MA29CgUqKr29/+PkljcpierdXtaBJX5oOr6BOpA3se/asO+cglnCIDcv3OLJuLKP23
 SR4Nof5VZ/pOobQ02GymuIKcskCFnIaCMr8ibihB7O356lPuI8IGTzRI4z+y2fHXsx
 D5KXzW/rCs5CthslpRLqrCQYLYF8f6fQS5WL3c9GOpe+SbtNMpVmjIrdEQeuK58cYS
 4K1jjEA2EV/O6mBBEAmylVFqpYmi48myGiIB6ssoTpfLRzn5Tfiw7oQ0l41QhntPgG
 WYFQRuKnZ3Z6w==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH 70/89] KVM: arm64: Refactor kvm_vcpu_enable_ptrauth() for hyp
 use
Date: Thu, 19 May 2022 14:41:45 +0100
Message-Id: <20220519134204.5379-71-will@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220519134204.5379-1-will@kernel.org>
References: <20220519134204.5379-1-will@kernel.org>
MIME-Version: 1.0
Cc: Marc Zyngier <maz@kernel.org>, kernel-team@android.com, kvm@vger.kernel.org,
 Andy Lutomirski <luto@amacapital.net>, linux-arm-kernel@lists.infradead.org,
 Michael Roth <michael.roth@amd.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Chao Peng <chao.p.peng@linux.intel.com>, Will Deacon <will@kernel.org>
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

From: Fuad Tabba <tabba@google.com>

Move kvm_vcpu_enable_ptrauth() to a shared header to be used by
hyp in protected mode.

No functional change intended.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 16 ++++++++++++++++
 arch/arm64/kvm/reset.c               | 16 ----------------
 2 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index d62405ce3e6d..bb56aff4de95 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -43,6 +43,22 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
 
 void kvm_vcpu_wfi(struct kvm_vcpu *vcpu);
 
+static inline int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * For now make sure that both address/generic pointer authentication
+	 * features are requested by the userspace together and the system
+	 * supports these capabilities.
+	 */
+	if (!test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
+	    !test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features) ||
+	    !system_has_full_ptr_auth())
+		return -EINVAL;
+
+	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_PTRAUTH;
+	return 0;
+}
+
 static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 {
 	return !(vcpu->arch.hcr_el2 & HCR_RW);
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index c07265ea72fd..cc25f540962b 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -165,22 +165,6 @@ static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
 		memset(vcpu->arch.sve_state, 0, vcpu_sve_state_size(vcpu));
 }
 
-static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
-{
-	/*
-	 * For now make sure that both address/generic pointer authentication
-	 * features are requested by the userspace together and the system
-	 * supports these capabilities.
-	 */
-	if (!test_bit(KVM_ARM_VCPU_PTRAUTH_ADDRESS, vcpu->arch.features) ||
-	    !test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, vcpu->arch.features) ||
-	    !system_has_full_ptr_auth())
-		return -EINVAL;
-
-	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_PTRAUTH;
-	return 0;
-}
-
 static bool vcpu_allowed_register_width(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu *tmp;
-- 
2.36.1.124.g0e6072fb45-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
