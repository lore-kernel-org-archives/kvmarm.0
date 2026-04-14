Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC423E5EF8
	for <kvmarm@lists.linux.dev>; Tue, 14 Apr 2026 16:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776182738; cv=none; b=hgWnT3Ch9lLMd/fdSp2y0i7f2EyqB8nmugiOT0J//ZwSkgqN71NPYkagI+ToYaqj75w4OhYtA9VkyR9zL9Eq5r1/8PMyOLroP25lenK32mh1hwXMz8z1MoAbUTi5SFUB/MthUJ5FQQM1QZJWQ94aoUbrGCGdaa18IObFrLshbcI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776182738; c=relaxed/simple;
	bh=KB+DwxjKOv+7tb2uKyWawrhRV0KiPF8QdOmOtDXaD7U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nVlghnHYt8U7/vHuf34YSvueTgAzu0B/o3eVTxu0b2ILE3fgyUy7qum6xbmjQMBadmPEUM99CthAgSlf/fvj2D1ahpY84vAEzxmApKlJlDA7zLDG6ylXvhlt/XZbuKFbc6+W2MX+yLK0xJdyWRLr5am0ETyHsaqPnjyT3m0fVJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uDWmRt3/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uDWmRt3/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B6DC19425;
	Tue, 14 Apr 2026 16:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776182737;
	bh=KB+DwxjKOv+7tb2uKyWawrhRV0KiPF8QdOmOtDXaD7U=;
	h=From:To:Cc:Subject:Date:From;
	b=uDWmRt3/rsToMdkoLEp7nzIwgfEAmxYDEr8cpSj1K0J78ni6x56t9XNi6VSE2yf9Z
	 c9YQC5Z97isMRxwhBgjkZeggib/XwH+xmlUWptMGZ6JB3xXR69/GOvgDZGIKs9dks0
	 jo/UTKGL29nJ32Z2GAHcBEgmzY9L3Nqg+NUcf5pdC4eL894uOM+nVyW+jKBMlNzX2+
	 ZLYGsTlGPm0Ozkvr93aZS2di1B+lA4nEtyiXn2yvtSmfdfz9aZlCLvWEThSsM1vXZE
	 1S32yvQ1sHY0JLcdUSkEUFLoCY+L2Gbv3mml2S14d3MR5ZBCazE8hBc6T0kT1a/92L
	 YrxFxfQieeFug==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
	by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.98.2)
	(envelope-from <maz@kernel.org>)
	id 1wCgGd-0000000BdFr-2MO3;
	Tue, 14 Apr 2026 16:05:35 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Will Deacon <will@kernel.org>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Oliver Upton <oupton@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>
Subject: [PATCH] KVM: arm64: pkvm: Adopt MARKER() to define host hypercall ranges
Date: Tue, 14 Apr 2026 17:05:28 +0100
Message-ID: <20260414160528.2218858-1-maz@kernel.org>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org, will@kernel.org, vdonnefort@google.com, tabba@google.com, joey.gouly@arm.com, suzuki.poulose@arm.com, oupton@kernel.org, yuzenghui@huawei.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false

The EL2 code defines ranges of host hypercalls that are either
enabled at boot-time only, used by [nh]VHE KVM, or reserved to pKVM.

The way these ranges are delineated is error prone, as the enum symbols
defining the limits are expressed in terms of actual function symbols.
This means that should a new function be added, special care must be
taken to also update the limit symbol.

Improve this by reusing the mechanism introduced for the vcpu_sysreg
enum, which uses a MARKER() macro and some extra trickery to make
the limit symbol standalone. Crucially, the limit symbol has the
same value as the *following* symbol.

The handle_host_hcall() function is then updated to make use of
the new limit definitions and get rid of the brittle default
upper limit. This allows for some more strict checks at build
time, and the removal of an comparison at run time.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h   | 12 ++++++++++--
 arch/arm64/include/asm/kvm_host.h  |  3 ---
 arch/arm64/kvm/hyp/nvhe/hyp-main.c | 10 +++++-----
 3 files changed, 15 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index 37414440cee7f..fa033be6141ad 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -50,6 +50,9 @@
 
 #include <linux/mm.h>
 
+#define MARKER(m)				\
+	m, __after_##m = m - 1
+
 enum __kvm_host_smccc_func {
 	/* Hypercalls that are unavailable once pKVM has finalised. */
 	/* __KVM_HOST_SMCCC_FUNC___kvm_hyp_init */
@@ -59,8 +62,10 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___kvm_enable_ssbs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_init_lrs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_get_gic_config,
+
+	MARKER(__KVM_HOST_SMCCC_FUNC_MIN_PKVM),
+
 	__KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
-	__KVM_HOST_SMCCC_FUNC_MIN_PKVM = __KVM_HOST_SMCCC_FUNC___pkvm_prot_finalize,
 
 	/* Hypercalls that are always available and common to [nh]VHE/pKVM. */
 	__KVM_HOST_SMCCC_FUNC___kvm_adjust_pc,
@@ -76,7 +81,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___vgic_v3_restore_vmcr_aprs,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_save_apr,
 	__KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
-	__KVM_HOST_SMCCC_FUNC_MAX_NO_PKVM = __KVM_HOST_SMCCC_FUNC___vgic_v5_restore_vmcr_apr,
+
+	MARKER(__KVM_HOST_SMCCC_FUNC_PKVM_ONLY),
 
 	/* Hypercalls that are available only when pKVM has finalised. */
 	__KVM_HOST_SMCCC_FUNC___pkvm_host_share_hyp,
@@ -108,6 +114,8 @@ enum __kvm_host_smccc_func {
 	__KVM_HOST_SMCCC_FUNC___tracing_reset,
 	__KVM_HOST_SMCCC_FUNC___tracing_enable_event,
 	__KVM_HOST_SMCCC_FUNC___tracing_write_event,
+
+	MARKER(__KVM_HOST_SMCCC_FUNC_MAX)
 };
 
 #define DECLARE_KVM_VHE_SYM(sym)	extern char sym[]
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 851f6171751c0..44211e86f5ebd 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -450,9 +450,6 @@ struct kvm_vcpu_fault_info {
 	r = __VNCR_START__ + ((VNCR_ ## r) / 8),	\
 	__after_##r = __MAX__(__before_##r - 1, r)
 
-#define MARKER(m)				\
-	m, __after_##m = m - 1
-
 enum vcpu_sysreg {
 	__INVALID_SYSREG__,   /* 0 is reserved as an invalid value */
 	MPIDR_EL1,	/* MultiProcessor Affinity Register */
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index 73f2e0221e703..9e44c05cf780e 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -748,9 +748,11 @@ static const hcall_t host_hcall[] = {
 static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 {
 	DECLARE_REG(unsigned long, id, host_ctxt, 0);
-	unsigned long hcall_min = 0, hcall_max = -1;
+	unsigned long hcall_min = 0, hcall_max = __KVM_HOST_SMCCC_FUNC_MAX;
 	hcall_t hfn;
 
+	BUILD_BUG_ON(ARRAY_SIZE(host_hcall) != __KVM_HOST_SMCCC_FUNC_MAX);
+
 	/*
 	 * If pKVM has been initialised then reject any calls to the
 	 * early "privileged" hypercalls. Note that we cannot reject
@@ -763,16 +765,14 @@ static void handle_host_hcall(struct kvm_cpu_context *host_ctxt)
 	if (static_branch_unlikely(&kvm_protected_mode_initialized)) {
 		hcall_min = __KVM_HOST_SMCCC_FUNC_MIN_PKVM;
 	} else {
-		hcall_max = __KVM_HOST_SMCCC_FUNC_MAX_NO_PKVM;
+		hcall_max = __KVM_HOST_SMCCC_FUNC_PKVM_ONLY;
 	}
 
 	id &= ~ARM_SMCCC_CALL_HINTS;
 	id -= KVM_HOST_SMCCC_ID(0);
 
-	if (unlikely(id < hcall_min || id > hcall_max ||
-		     id >= ARRAY_SIZE(host_hcall))) {
+	if (unlikely(id < hcall_min || id >= hcall_max))
 		goto inval;
-	}
 
 	hfn = host_hcall[id];
 	if (unlikely(!hfn))
-- 
2.47.3

