Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C41837756C
	for <kvmarm@lists.linux.dev>; Thu, 26 Mar 2026 14:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774534348; cv=none; b=dwTegLT0YAV926vLAdORHi03Xbs/NUPKPTfcqMuMC39erD3kSdIbJ7iII5/tATtPR/9z+vby8HqXi2YGlFf5d1TZGV6pocIW9JC2wQ/7bfMQoHeQbB2Oh4K0aVdoi/d0YzLFdjzvigZnRB3aSLuuEDOeNk5ukL8Qv0p9gJKta58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774534348; c=relaxed/simple;
	bh=3fwA/zq/4O8PWihX/7OYdGsB9CyT72+008pe9167Y70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KlIG5pEFlYTsMzmrgQCPzil0Uq7ji23DDWvPkr4DYvS/zggX/5xsaljz4lzES1HPzBovOkoq6cfQRB5Rqfc6j/BDluCVcD6uoQ9igd3iQYIkh9nSumkMC4epKPiylqHM0tKitkrPYap2ol35PC7115pCrhFMRCWYXoKet7M/cjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bR27MqMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bR27MqMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C54C19424;
	Thu, 26 Mar 2026 14:12:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774534347;
	bh=3fwA/zq/4O8PWihX/7OYdGsB9CyT72+008pe9167Y70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bR27MqMNoWNp1NbSgq51QT0tzjz8BuRXnagv8N/uYALJemqp3Zruu4Td3fUn2BKNO
	 KW/hV++4LUSt8zBvxOw6CLokWCHwAoEnwinba8Pe7JhXKLkieCThV8y5OAU5l1i2jY
	 LG5iMlj40gAPxMD6xvMFShnDuWWZjecogdmM0S3lSWhmS2Qimc6Axk8IbwkYzPolIU
	 SJC/vabqOFzXc27dnq8MKDjWXo/v4Gpu82UrWhjEXBz5Pig+EwB8pzyWjnuCcPbbJ9
	 hX/F8jWiK2FuAc46hrV58bJWyJvBo0zCkGZputk38GCXa+WmeE3jJMnJW9oEr8FqMe
	 Kenj7qK/w9suw==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.linux.dev
Cc: mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Fuad Tabba <tabba@google.com>,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Yabin Cui <yabinc@google.com>
Subject: [PATCH v3 2/3] KVM: arm64: Disable SPE Profiling Buffer when running in guest context
Date: Thu, 26 Mar 2026 14:12:12 +0000
Message-ID: <20260326141214.18990-3-will@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260326141214.18990-1-will@kernel.org>
References: <20260326141214.18990-1-will@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The nVHE world-switch code relies on zeroing PMSCR_EL1 to disable
profiling data generation in guest context when SPE is in use by the
host.

Unfortunately, this may leave PMBLIMITR_EL1.E set and consequently we
can end up running in guest/hypervisor context with the Profiling Buffer
enabled. The current "known issues" document for Rev M.a of the Arm ARM
states that this can lead to speculative, out-of-context translations:

  | 2.18 D23136:
  |
  | When the Profiling Buffer is enabled, profiling is not stopped, and
  | Discard mode is not enabled, the Statistical Profiling Unit might
  | cause speculative translations for the owning translation regime,
  | including when the owning translation regime is out-of-context.

In a similar fashion to TRBE, ensure that the Profiling Buffer is
disabled during the nVHE world switch before we start messing with the
stage-2 MMU and trap configuration.

Cc: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>
Cc: James Clark <james.clark@linaro.org>
Cc: Leo Yan <leo.yan@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Fuad Tabba <tabba@google.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>
Reviewed-by: Fuad Tabba <tabba@google.com>
Tested-by: Alexandru Elisei <alexandru.elisei@arm.com>
Tested-by: Fuad Tabba <tabba@google.com>
Fixes: f85279b4bd48 ("arm64: KVM: Save/restore the host SPE state when entering/leaving a VM")
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h  |  1 +
 arch/arm64/kvm/hyp/nvhe/debug-sr.c | 33 ++++++++++++++++++++----------
 arch/arm64/kvm/hyp/nvhe/switch.c   |  2 +-
 3 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index b1335c55dbef..fe588760fe62 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -768,6 +768,7 @@ struct kvm_host_data {
 		struct kvm_guest_debug_arch regs;
 		/* Statistical profiling extension */
 		u64 pmscr_el1;
+		u64 pmblimitr_el1;
 		/* Self-hosted trace */
 		u64 trfcr_el1;
 		u64 trblimitr_el1;
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 0955af771ad1..84bc80f4e36b 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -14,20 +14,20 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
-static void __debug_save_spe(u64 *pmscr_el1)
+static void __debug_save_spe(void)
 {
-	u64 reg;
+	u64 *pmscr_el1, *pmblimitr_el1;
 
-	/* Clear pmscr in case of early return */
-	*pmscr_el1 = 0;
+	pmscr_el1 = host_data_ptr(host_debug_state.pmscr_el1);
+	pmblimitr_el1 = host_data_ptr(host_debug_state.pmblimitr_el1);
 
 	/*
 	 * At this point, we know that this CPU implements
 	 * SPE and is available to the host.
 	 * Check if the host is actually using it ?
 	 */
-	reg = read_sysreg_s(SYS_PMBLIMITR_EL1);
-	if (!(reg & BIT(PMBLIMITR_EL1_E_SHIFT)))
+	*pmblimitr_el1 = read_sysreg_s(SYS_PMBLIMITR_EL1);
+	if (!(*pmblimitr_el1 & BIT(PMBLIMITR_EL1_E_SHIFT)))
 		return;
 
 	/* Yes; save the control register and disable data generation */
@@ -37,18 +37,29 @@ static void __debug_save_spe(u64 *pmscr_el1)
 
 	/* Now drain all buffered data to memory */
 	psb_csync();
+	dsb(nsh);
+
+	/* And disable the profiling buffer */
+	write_sysreg_s(0, SYS_PMBLIMITR_EL1);
+	isb();
 }
 
-static void __debug_restore_spe(u64 pmscr_el1)
+static void __debug_restore_spe(void)
 {
-	if (!pmscr_el1)
+	u64 pmblimitr_el1 = *host_data_ptr(host_debug_state.pmblimitr_el1);
+
+	if (!(pmblimitr_el1 & BIT(PMBLIMITR_EL1_E_SHIFT)))
 		return;
 
 	/* The host page table is installed, but not yet synchronised */
 	isb();
 
+	/* Re-enable the profiling buffer. */
+	write_sysreg_s(pmblimitr_el1, SYS_PMBLIMITR_EL1);
+	isb();
+
 	/* Re-enable data generation */
-	write_sysreg_el1(pmscr_el1, SYS_PMSCR);
+	write_sysreg_el1(*host_data_ptr(host_debug_state.pmscr_el1), SYS_PMSCR);
 }
 
 static void __trace_do_switch(u64 *saved_trfcr, u64 new_trfcr)
@@ -175,7 +186,7 @@ void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
 	/* Disable and flush SPE data generation */
 	if (host_data_test_flag(HAS_SPE))
-		__debug_save_spe(host_data_ptr(host_debug_state.pmscr_el1));
+		__debug_save_spe();
 
 	/* Disable BRBE branch records */
 	if (host_data_test_flag(HAS_BRBE))
@@ -193,7 +204,7 @@ void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
 	if (host_data_test_flag(HAS_SPE))
-		__debug_restore_spe(*host_data_ptr(host_debug_state.pmscr_el1));
+		__debug_restore_spe();
 	if (host_data_test_flag(HAS_BRBE))
 		__debug_restore_brbe(*host_data_ptr(host_debug_state.brbcr_el1));
 	if (__trace_needs_switch())
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index f00688e69d88..9b6e87dac3b9 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -278,7 +278,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * We're about to restore some new MMU state. Make sure
 	 * ongoing page-table walks that have started before we
 	 * trapped to EL2 have completed. This also synchronises the
-	 * above disabling of BRBE and SPE.
+	 * above disabling of BRBE.
 	 *
 	 * See DDI0487I.a D8.1.5 "Out-of-context translation regimes",
 	 * rule R_LFHQG and subsequent information statements.
-- 
2.53.0.1018.g2bb0e51243-goog

