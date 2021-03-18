Return-Path: <SRS0=/u//=IQ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 680AFC433DB
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 12:53:46 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DD08D64E99
	for <kvmarm@archiver.kernel.org>; Thu, 18 Mar 2021 12:53:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DD08D64E99
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8F2B64B629;
	Thu, 18 Mar 2021 08:53:45 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id BLBWtbbGGZGB; Thu, 18 Mar 2021 08:53:44 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1C1374B62C;
	Thu, 18 Mar 2021 08:53:44 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15C4C4B377
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 08:53:43 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sAaWkvb5bN8M for <kvmarm@lists.cs.columbia.edu>;
 Thu, 18 Mar 2021 08:53:41 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C56D24B37F
 for <kvmarm@lists.cs.columbia.edu>; Thu, 18 Mar 2021 08:53:41 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id EA7C864E28;
 Thu, 18 Mar 2021 12:53:40 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78]
 helo=why.lan) by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94)
 (envelope-from <maz@kernel.org>)
 id 1lMrin-002OZW-8d; Thu, 18 Mar 2021 12:25:49 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
Subject: [PATCH v2 11/11] KVM: arm64: Enable SVE support for nVHE
Date: Thu, 18 Mar 2021 12:25:32 +0000
Message-Id: <20210318122532.505263-12-maz@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210318122532.505263-1-maz@kernel.org>
References: <20210318122532.505263-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, dave.martin@arm.com,
 daniel.kiss@arm.com, will@kernel.org, catalin.marinas@arm.com,
 james.morse@arm.com, julien.thierry.kdev@gmail.com, suzuki.poulose@arm.com,
 broonie@kernel.org, ascull@google.com, qperret@google.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Catalin Marinas <catalin.marinas@arm.com>,
 broonie@kernel.org, Will Deacon <will@kernel.org>, dave.martin@arm.com,
 daniel.kiss@arm.com
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

From: Daniel Kiss <daniel.kiss@arm.com>

Now that KVM is equipped to deal with SVE on nVHE, remove the code
preventing it from being used as well as the bits of documentation
that were mentioning the incompatibility.

Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Daniel Kiss <daniel.kiss@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/Kconfig                |  7 -------
 arch/arm64/include/asm/kvm_host.h | 13 -------------
 arch/arm64/kvm/arm.c              |  5 -----
 arch/arm64/kvm/reset.c            |  4 ----
 4 files changed, 29 deletions(-)

diff --git a/arch/arm64/Kconfig b/arch/arm64/Kconfig
index 1f212b47a48a..2690543799fb 100644
--- a/arch/arm64/Kconfig
+++ b/arch/arm64/Kconfig
@@ -1686,7 +1686,6 @@ endmenu
 config ARM64_SVE
 	bool "ARM Scalable Vector Extension support"
 	default y
-	depends on !KVM || ARM64_VHE
 	help
 	  The Scalable Vector Extension (SVE) is an extension to the AArch64
 	  execution state which complements and extends the SIMD functionality
@@ -1715,12 +1714,6 @@ config ARM64_SVE
 	  booting the kernel.  If unsure and you are not observing these
 	  symptoms, you should assume that it is safe to say Y.
 
-	  CPUs that support SVE are architecturally required to support the
-	  Virtualization Host Extensions (VHE), so the kernel makes no
-	  provision for supporting SVE alongside KVM without VHE enabled.
-	  Thus, you will need to enable CONFIG_ARM64_VHE if you want to support
-	  KVM in the same kernel image.
-
 config ARM64_MODULE_PLTS
 	bool "Use PLTs to allow module memory to spill over into vmalloc area"
 	depends on MODULES
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e59b16008868..08f500b2551a 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -694,19 +694,6 @@ static inline void kvm_init_host_cpu_context(struct kvm_cpu_context *cpu_ctxt)
 	ctxt_sys_reg(cpu_ctxt, MPIDR_EL1) = read_cpuid_mpidr();
 }
 
-static inline bool kvm_arch_requires_vhe(void)
-{
-	/*
-	 * The Arm architecture specifies that implementation of SVE
-	 * requires VHE also to be implemented.  The KVM code for arm64
-	 * relies on this when SVE is present:
-	 */
-	if (system_supports_sve())
-		return true;
-
-	return false;
-}
-
 void kvm_arm_vcpu_ptrauth_trap(struct kvm_vcpu *vcpu);
 
 static inline void kvm_arch_hardware_unsetup(void) {}
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fc4c95dd2d26..ef92b7d32ebd 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1889,11 +1889,6 @@ int kvm_arch_init(void *opaque)
 
 	in_hyp_mode = is_kernel_in_hyp_mode();
 
-	if (!in_hyp_mode && kvm_arch_requires_vhe()) {
-		kvm_pr_unimpl("CPU unsupported in non-VHE mode, not initializing\n");
-		return -ENODEV;
-	}
-
 	if (cpus_have_final_cap(ARM64_WORKAROUND_DEVICE_LOAD_ACQUIRE) ||
 	    cpus_have_final_cap(ARM64_WORKAROUND_1508412))
 		kvm_info("Guests without required CPU erratum workarounds can deadlock system!\n" \
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 47f3f035f3ea..f08b1e7ebf68 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -74,10 +74,6 @@ static int kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
 	if (!system_supports_sve())
 		return -EINVAL;
 
-	/* Verify that KVM startup enforced this when SVE was detected: */
-	if (WARN_ON(!has_vhe()))
-		return -EINVAL;
-
 	vcpu->arch.sve_max_vl = kvm_sve_max_vl;
 
 	/*
-- 
2.29.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
