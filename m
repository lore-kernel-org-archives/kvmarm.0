Return-Path: <SRS0=XaYj=37=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B98DDC3F68F
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 17:51:44 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 76E1320661
	for <kvmarm@archiver.kernel.org>; Tue, 11 Feb 2020 17:51:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="1NNVhjng"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 76E1320661
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D84EB4AECF;
	Tue, 11 Feb 2020 12:51:43 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id nOD0SHQr0iVl; Tue, 11 Feb 2020 12:51:42 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8210C4AE9E;
	Tue, 11 Feb 2020 12:51:42 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 996604AEC1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 12:51:40 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D5HLAQUkGnWz for <kvmarm@lists.cs.columbia.edu>;
 Tue, 11 Feb 2020 12:51:39 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5269C4AEE3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 11 Feb 2020 12:51:38 -0500 (EST)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 84ACA20661;
 Tue, 11 Feb 2020 17:51:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1581443497;
 bh=c5I/DnWBHK7CF1Hug7c8EUPZyhvhzoIsYWcfsfMzPEo=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=1NNVhjng+8MtN6zoASSmNHt5TCZkZPglFujZ+pmQ1HsXWEDqvuxwzYXoM7NRAuYd+
 PdGvtwsFIRccT+3waMwUvPNFQbebRWD12fTMZjWfiatJ7WseUp48snhPHHiXjreg1z
 54JTpTcmoQK7v2Uvo+PqTYX+//AHEHzlP59VlY1g=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1j1ZgL-004O7k-ET; Tue, 11 Feb 2020 17:50:45 +0000
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH v2 88/94] KVM: arm64: Add ARMv8.4 Enhanced Nested Virt
 cpufeature
Date: Tue, 11 Feb 2020 17:49:32 +0000
Message-Id: <20200211174938.27809-89-maz@kernel.org>
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

Add the detection code for the ARMv8.4-NV feature.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm/include/asm/kvm_nested.h   |  1 +
 arch/arm64/include/asm/cpucaps.h    |  3 ++-
 arch/arm64/include/asm/kvm_nested.h |  6 ++++++
 arch/arm64/kernel/cpufeature.c      | 10 ++++++++++
 4 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/kvm_nested.h b/arch/arm/include/asm/kvm_nested.h
index 2b89e6fa7323..1b97863ae811 100644
--- a/arch/arm/include/asm/kvm_nested.h
+++ b/arch/arm/include/asm/kvm_nested.h
@@ -5,6 +5,7 @@
 #include <linux/kvm_host.h>
 
 static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu) { return false; }
+static inline bool enhanced_nested_virt_in_use(const struct kvm_vcpu *vcpu) { return false; }
 static inline void check_nested_vcpu_requests(struct kvm_vcpu *vcpu) {}
 
 #endif /* __ARM_KVM_NESTED_H */
diff --git a/arch/arm64/include/asm/cpucaps.h b/arch/arm64/include/asm/cpucaps.h
index 5736650cd0fb..565e4878e301 100644
--- a/arch/arm64/include/asm/cpucaps.h
+++ b/arch/arm64/include/asm/cpucaps.h
@@ -60,7 +60,8 @@
 #define ARM64_HAS_RNG				50
 #define ARM64_HAS_NESTED_VIRT			51
 #define ARM64_HAS_ARMv8_4_TTL			52
+#define ARM64_HAS_ENHANCED_NESTED_VIRT		53
 
-#define ARM64_NCAPS				53
+#define ARM64_NCAPS				54
 
 #endif /* __ASM_CPUCAPS_H */
diff --git a/arch/arm64/include/asm/kvm_nested.h b/arch/arm64/include/asm/kvm_nested.h
index 3e3778d3cec6..284c794a10ac 100644
--- a/arch/arm64/include/asm/kvm_nested.h
+++ b/arch/arm64/include/asm/kvm_nested.h
@@ -11,6 +11,12 @@ static inline bool nested_virt_in_use(const struct kvm_vcpu *vcpu)
 		test_bit(KVM_ARM_VCPU_HAS_EL2, vcpu->arch.features);
 }
 
+static inline bool enhanced_nested_virt_in_use(const struct kvm_vcpu *vcpu)
+{
+	return cpus_have_const_cap(ARM64_HAS_ENHANCED_NESTED_VIRT) &&
+		nested_virt_in_use(vcpu);
+}
+
 extern void kvm_init_nested(struct kvm *kvm);
 extern int kvm_vcpu_init_nested(struct kvm_vcpu *vcpu);
 extern void kvm_init_nested_s2_mmu(struct kvm_s2_mmu *mmu);
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index aada8c3eff1e..546aceb70c3f 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -1454,6 +1454,16 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.field_pos = ID_AA64MMFR2_NV_SHIFT,
 		.min_field_value = 1,
 	},
+	{
+		.desc = "Enhanced Nested Virtualization Support",
+		.capability = ARM64_HAS_ENHANCED_NESTED_VIRT,
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.matches = has_nested_virt_support,
+		.sys_reg = SYS_ID_AA64MMFR2_EL1,
+		.sign = FTR_UNSIGNED,
+		.field_pos = ID_AA64MMFR2_NV_SHIFT,
+		.min_field_value = 2,
+	},
 #endif	/* CONFIG_ARM64_VHE */
 	{
 		.desc = "32-bit EL0 Support",
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
