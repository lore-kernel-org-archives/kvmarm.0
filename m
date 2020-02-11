Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC105C3B187
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 17:53:36 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9F356206D7
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 17:53:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="LmlCJPpc"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9F356206D7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 560744AF34;
	Tue, 11 Feb 2020 12:53:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id mOLHgwPUGlya; Tue, 11 Feb 2020 12:53:35 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3BB2F4AF1C;
	Tue, 11 Feb 2020 12:53:35 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BB534AF12
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 12:53:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BoVQmtXPh9Od for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 12:53:33 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3E69D4AF1F
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 12:53:33 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 71B5D208C3;
 Tue, 11 Feb 2020 17:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1581443612;
 bh=aDjnahK7imY4Wiu3rGFAEkgpWazKaqx4y/1oenhKSNQ=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=LmlCJPpcDwkR6+ZtT/FewyZ66I93MIGbdS5BuzQjlX23EZ7WYd041fS/gY4r12PLw
 dU9dLDxxpxYd30kJ0yml6iqhbcXvl2YAuVYQOLa4Uuok6OKrXXnu3jNZmnVKM0wko6
 5RPoP4afTstyEEp2l3ewBjqR69k3nVXsDtB4MOvI=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j1Zg9-004O7k-F0; Tue, 11 Feb 2020 17:50:33 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 68/94] arm64: KVM: Add a level hint to
 __kvm_tlb_flush_vmid_ipa
Date: Tue, 11 Feb 2020 17:49:12 +0000
Message-Id: <20200211174938.27809-69-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200211174938.27809-1-maz@kernel.org>
References: <20200211174938.27809-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu,
 alexandru.elisei@arm.com, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Andre Przywara <andre.przywara@arm.com>, Dave Martin <Dave.Martin@arm.com>
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

Introduce a level hint to __kvm_tlb_flush_vmid_ipa. No functional
change.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm/include/asm/kvm_asm.h   | 3 ++-
 arch/arm/kvm/hyp/tlb.c           | 7 ++++---
 arch/arm64/include/asm/kvm_asm.h | 3 ++-
 arch/arm64/kvm/hyp/tlb.c         | 5 +++--
 virt/kvm/arm/mmu.c               | 2 +-
 5 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/arm/include/asm/kvm_asm.h b/arch/arm/include/asm/kvm_asm.h
index 4f85323f1290..ee7c0aec4c87 100644
--- a/arch/arm/include/asm/kvm_asm.h
+++ b/arch/arm/include/asm/kvm_asm.h
@@ -55,7 +55,8 @@ extern char __kvm_hyp_init[];
 extern char __kvm_hyp_init_end[];
 
 extern void __kvm_flush_vm_context(void);
-extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa);
+extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
+				     int level);
 extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
 extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
 
diff --git a/arch/arm/kvm/hyp/tlb.c b/arch/arm/kvm/hyp/tlb.c
index 8833e0b0ea97..84b4ea1955b2 100644
--- a/arch/arm/kvm/hyp/tlb.c
+++ b/arch/arm/kvm/hyp/tlb.c
@@ -21,8 +21,8 @@
  * have to use an IPI based mechanism. Until then, we stick to the simple
  * hardware assisted version.
  *
- * As v7 does not support flushing per IPA, just nuke the whole TLB
- * instead, ignoring the ipa value.
+ * As v7 does not support flushing per IPA (let alone any level hint),
+ * just nuke the whole TLB instead, ignoring the ipa value.
  */
 void __hyp_text __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 {
@@ -39,7 +39,8 @@ void __hyp_text __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu)
 	write_sysreg(0, VTTBR);
 }
 
-void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
+void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
+					 phys_addr_t ipa, int level)
 {
 	__kvm_tlb_flush_vmid(mmu);
 }
diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index c43160d2940d..2c001aa1bdd6 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -59,7 +59,8 @@ extern char __kvm_hyp_init_end[];
 extern char __kvm_hyp_vector[];
 
 extern void __kvm_flush_vm_context(void);
-extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa);
+extern void __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa,
+				     int level);
 extern void __kvm_tlb_flush_vmid(struct kvm_s2_mmu *mmu);
 extern void __kvm_tlb_flush_local_vmid(struct kvm_vcpu *vcpu);
 extern void __kvm_tlb_vae2is(struct kvm_s2_mmu *mmu, u64 va, u64 sys_encoding);
diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index aa08300774fa..71e4e86e0981 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -132,7 +132,8 @@ static void __hyp_text __tlb_switch_to_host(struct kvm_s2_mmu *mmu,
 		__tlb_switch_to_host_nvhe(cxt);
 }
 
-void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
+void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu,
+					 phys_addr_t ipa, int level)
 {
 	struct tlb_inv_context cxt;
 
@@ -148,7 +149,7 @@ void __hyp_text __kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa
 	 * whole of Stage-1. Weep...
 	 */
 	ipa >>= 12;
-	__tlbi(ipas2e1is, ipa);
+	__tlbi_level(ipas2e1is, ipa, level);
 
 	/*
 	 * We have to ensure completion of the invalidation at Stage-2,
diff --git a/virt/kvm/arm/mmu.c b/virt/kvm/arm/mmu.c
index eaa86cad2ac8..67752c2a615f 100644
--- a/virt/kvm/arm/mmu.c
+++ b/virt/kvm/arm/mmu.c
@@ -76,7 +76,7 @@ void kvm_flush_remote_tlbs(struct kvm *kvm)
 
 static void kvm_tlb_flush_vmid_ipa(struct kvm_s2_mmu *mmu, phys_addr_t ipa)
 {
-	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ipa);
+	kvm_call_hyp(__kvm_tlb_flush_vmid_ipa, mmu, ipa, 0);
 }
 
 /*
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
