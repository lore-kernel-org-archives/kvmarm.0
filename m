Return-Path: <SRS0=wQQg=6G=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0F21C5518C
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 12:01:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 594DF20B1F
	for <kvmarm@archiver.kernel.org>; Wed, 22 Apr 2020 12:01:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="BsU3Esqw"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 594DF20B1F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 14ADF4B0B8;
	Wed, 22 Apr 2020 08:01:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id EcRy+eqfzq+Z; Wed, 22 Apr 2020 08:01:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 914104B172;
	Wed, 22 Apr 2020 08:01:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3723A4B0B7
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 08:00:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D5cJczBfMjm6 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 22 Apr 2020 08:00:58 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E98CC4B0B8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 22 Apr 2020 08:00:57 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 21EB520781;
 Wed, 22 Apr 2020 12:00:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1587556857;
 bh=I732TSPQc9bSSFWvXROeC4qjohlGzkEaC6Z5VtQBTwo=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=BsU3EsqwyQFOrnctLzeLHMQxEkwKULRbhE6I1p008aroJY9Ynv1NQnl6yQ0pZ1JBV
 aHpbXsJkoyirFZd46RNf7IiPHH6Pywib299iMU6HmVbU3QwQSE1f8LXMKbGO6+S3Qx
 o3h/0dnp79hM8InLRUTyzmbCBHm9d3FmJCqOvJaw=
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa
 (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256) (Exim 4.92)
 (envelope-from <maz@kernel.org>)
 id 1jRE3j-005UI7-FO; Wed, 22 Apr 2020 13:00:55 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 01/26] KVM: arm64: Check advertised Stage-2 page size
 capability
Date: Wed, 22 Apr 2020 13:00:25 +0100
Message-Id: <20200422120050.3693593-2-maz@kernel.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200422120050.3693593-1-maz@kernel.org>
References: <20200422120050.3693593-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, andre.przywara@arm.com,
 christoffer.dall@arm.com, Dave.Martin@arm.com, jintack@cs.columbia.edu,
 alexandru.elisei@arm.com, gcherian@marvell.com, prime.zeng@hisilicon.com,
 will@kernel.org, catalin.marinas@arm.com, mark.rutland@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: Will Deacon <will@kernel.org>, Andre Przywara <andre.przywara@arm.com>,
 Dave Martin <Dave.Martin@arm.com>, George Cherian <gcherian@marvell.com>,
 "Zengtao \(B\)" <prime.zeng@hisilicon.com>,
 Catalin Marinas <catalin.marinas@arm.com>
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

With ARMv8.5-GTG, the hardware (or more likely a hypervisor) can
advertise the supported Stage-2 page sizes.

Let's check this at boot time.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h |  2 +-
 arch/arm64/include/asm/sysreg.h   |  3 +++
 arch/arm64/kernel/cpufeature.c    |  8 +++++++
 arch/arm64/kvm/reset.c            | 40 ++++++++++++++++++++++++++++---
 virt/kvm/arm/arm.c                |  4 +---
 5 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 32c8a675e5a4a..7dd8fefa6aecd 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -670,7 +670,7 @@ static inline int kvm_arm_have_ssbd(void)
 void kvm_vcpu_load_sysregs(struct kvm_vcpu *vcpu);
 void kvm_vcpu_put_sysregs(struct kvm_vcpu *vcpu);
 
-void kvm_set_ipa_limit(void);
+int kvm_set_ipa_limit(void);
 
 #define __KVM_HAVE_ARCH_VM_ALLOC
 struct kvm *kvm_arch_alloc_vm(void);
diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
index ebc6224328318..5d10c9148e844 100644
--- a/arch/arm64/include/asm/sysreg.h
+++ b/arch/arm64/include/asm/sysreg.h
@@ -686,6 +686,9 @@
 #define ID_AA64ZFR0_SVEVER_SVE2		0x1
 
 /* id_aa64mmfr0 */
+#define ID_AA64MMFR0_TGRAN4_2_SHIFT	40
+#define ID_AA64MMFR0_TGRAN64_2_SHIFT	36
+#define ID_AA64MMFR0_TGRAN16_2_SHIFT	32
 #define ID_AA64MMFR0_TGRAN4_SHIFT	28
 #define ID_AA64MMFR0_TGRAN64_SHIFT	24
 #define ID_AA64MMFR0_TGRAN16_SHIFT	20
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 9fac745aa7bb2..9892a845d06c9 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -208,6 +208,14 @@ static const struct arm64_ftr_bits ftr_id_aa64zfr0[] = {
 };
 
 static const struct arm64_ftr_bits ftr_id_aa64mmfr0[] = {
+	/*
+	 * Page size not being supported at Stage-2 are not fatal. You
+	 * just give up KVM if PAGE_SIZE isn't supported there. Go fix
+	 * your favourite nesting hypervisor.
+	 */
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_AA64MMFR0_TGRAN4_2_SHIFT, 4, 1),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_AA64MMFR0_TGRAN64_2_SHIFT, 4, 1),
+	ARM64_FTR_BITS(FTR_HIDDEN, FTR_NONSTRICT, FTR_EXACT, ID_AA64MMFR0_TGRAN16_2_SHIFT, 4, 1),
 	/*
 	 * We already refuse to boot CPUs that don't support our configured
 	 * page size, so we can only detect mismatches for a page size other
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 30b7ea680f66c..241db35a7ef4f 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -9,6 +9,7 @@
  */
 
 #include <linux/errno.h>
+#include <linux/bitfield.h>
 #include <linux/kernel.h>
 #include <linux/kvm_host.h>
 #include <linux/kvm.h>
@@ -340,11 +341,42 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
-void kvm_set_ipa_limit(void)
+int kvm_set_ipa_limit(void)
 {
-	unsigned int ipa_max, pa_max, va_max, parange;
+	unsigned int ipa_max, pa_max, va_max, parange, tgran_2;
+	u64 mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 
-	parange = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1) & 0x7;
+	/*
+	 * Check with ARMv8.5-GTG that our PAGE_SIZE is supported at
+	 * Stage-2. If not, things will stop very quickly.
+	 */
+	switch (PAGE_SIZE) {
+	default:
+	case SZ_4K:
+		tgran_2 = ID_AA64MMFR0_TGRAN4_2_SHIFT;
+		break;
+	case SZ_16K:
+		tgran_2 = ID_AA64MMFR0_TGRAN16_2_SHIFT;
+		break;
+	case SZ_64K:
+		tgran_2 = ID_AA64MMFR0_TGRAN64_2_SHIFT;
+		break;
+	}
+
+	switch (FIELD_GET(0xFUL << tgran_2, mmfr0)) {
+	default:
+	case 1:
+		kvm_err("PAGE_SIZE not supported at Stage-2, giving up\n");
+		return -EINVAL;
+	case 0:
+		kvm_debug("PAGE_SIZE supported at Stage-2 (default)\n");
+		break;
+	case 2:
+		kvm_debug("PAGE_SIZE supported at Stage-2 (advertised)\n");
+		break;
+	}
+
+	parange = mmfr0 & 0x7;
 	pa_max = id_aa64mmfr0_parange_to_phys_shift(parange);
 
 	/* Clamp the IPA limit to the PA size supported by the kernel */
@@ -378,6 +410,8 @@ void kvm_set_ipa_limit(void)
 	     "KVM IPA limit (%d bit) is smaller than default size\n", ipa_max);
 	kvm_ipa_limit = ipa_max;
 	kvm_info("IPA Size Limit: %dbits\n", kvm_ipa_limit);
+
+	return 0;
 }
 
 /*
diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 48d0ec44ad77e..53b3ba9173ba7 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -1387,9 +1387,7 @@ static inline void hyp_cpu_pm_exit(void)
 
 static int init_common_resources(void)
 {
-	kvm_set_ipa_limit();
-
-	return 0;
+	return kvm_set_ipa_limit();
 }
 
 static int init_subsystems(void)
-- 
2.26.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
