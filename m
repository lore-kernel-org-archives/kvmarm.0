Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4736325FA0E;
	Tue, 20 May 2025 22:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747780093; cv=none; b=oFiM8WwIDvB7XdBk5sFAoU22QS3vy+ur9Ri5BU+z+0N/o4khAV0Y+HEi9AYpKhjKUmTA4vooth0qWwLfGntamMFpMfBJTM/YU651hOO52cj1dDq5PLfuBTYwv4Ew+k5+5ozLWjU+iKZH3dxJ1TzKhTeII0z8KujQOinQFUfO2js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747780093; c=relaxed/simple;
	bh=IiLukT8iB7h3eI5GC7F8axjbYQS9CZFfaQmLnteSiSM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QTNHkzd8+ZIHUcqajJral28tyxDn2Xy72vHzlK9xWZjJ9kTqWC0CrFTlUqWoO3H3H6OGKgiFMDRqY/rzotsgMKO6tVYgZUry/74wfYiSjT5urj7T0ewpG3o9FwyHOLe9aQ8iK67ry1QMyK3TC2lJ/Keh0n2NTXlEsLw8sp2ilp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RFYNy0Ce; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RFYNy0Ce"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99672C4CEF0;
	Tue, 20 May 2025 22:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747780092;
	bh=IiLukT8iB7h3eI5GC7F8axjbYQS9CZFfaQmLnteSiSM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=RFYNy0Ce1Sv7Th1YS4H+ba/iNrlnHQzOH+QKeZT+xgFHB8gz9zmA0k1ukpXbVu3CZ
	 TVRiMbRwusprj+6cCXi9os8Tvc0Mvi9aTy3tn+jEumEWz4sgz03oeYyX/VQZs8Z8JF
	 0QMTV8KwqUF/nfubRoVqqdGRjq/tBZgFzsffoOgObeLfx5twl4UxJJmFjGcxybiJ/W
	 YbGAF/wkntFxFhs6zGeAN0rmhTeemf5POEh4TLxrH3S9sDXd19kJctZ++e3/AMddFp
	 pQNyiKsvUl1FiKv79D9OUigUwQIOwhwV4+8FH/OGueOrnuvi+IxGRHFDPHLnIlZ+Hl
	 fiOB+BhUWE/fQ==
From: "Rob Herring (Arm)" <robh@kernel.org>
Date: Tue, 20 May 2025 17:27:39 -0500
Subject: [PATCH v22 4/5] KVM: arm64: nvhe: Disable branch generation in
 nVHE guests
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250520-arm-brbe-v19-v22-4-c1ddde38e7f8@kernel.org>
References: <20250520-arm-brbe-v19-v22-0-c1ddde38e7f8@kernel.org>
In-Reply-To: <20250520-arm-brbe-v19-v22-0-c1ddde38e7f8@kernel.org>
To: Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Jonathan Corbet <corbet@lwn.net>, 
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, James Clark <james.clark@linaro.org>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, Leo Yan <leo.yan@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-perf-users@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev
X-Mailer: b4 0.15-dev

From: Anshuman Khandual <anshuman.khandual@arm.com>

While BRBE can record branches within guests, the host recording
branches in guests is not supported by perf (though events are).
Support for BRBE in guests will supported by providing direct access
to BRBE within the guests. That is how x86 LBR works for guests.
Therefore, BRBE needs to be disabled on guest entry and restored on
exit.

For nVHE, this requires explicit handling for guests. Before
entering a guest, save the BRBE state and disable the it. When
returning to the host, restore the state.

For VHE, it is not necessary. We initialize
BRBCR_EL1.{E1BRE,E0BRE}=={0,0} at boot time, and HCR_EL2.TGE==1 while
running in the host. We configure BRBCR_EL2.{E2BRE,E0HBRE} to enable
branch recording in the host. When entering the guest, we set
HCR_EL2.TGE==0 which means BRBCR_EL1 is used instead of BRBCR_EL2.
Consequently for VHE, BRBE recording is disabled at EL1 and EL0 when
running a guest.

Should recording in guests (by the host) ever be desired, the perf ABI
will need to be extended to distinguish guest addresses (struct
perf_branch_entry.priv) for starters. BRBE records would also need to be
invalidated on guest entry/exit as guest/host EL1 and EL0 records can't
be distinguished.

Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Co-developed-by: Rob Herring (Arm) <robh@kernel.org>
Tested-by: James Clark <james.clark@linaro.org>
Reviewed-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
---
v20:
 - Reword commit message about no guest recording.
 - Add BRBE to __kvm_vcpu_run() synchronization comment

v19:
 - Rework due to v6.14 debug flag changes
 - Redo commit message
---
 arch/arm64/include/asm/kvm_host.h  |  2 ++
 arch/arm64/kvm/debug.c             |  4 ++++
 arch/arm64/kvm/hyp/nvhe/debug-sr.c | 32 ++++++++++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/switch.c   |  2 +-
 4 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e98cfe7855a6..e3f1e7b5ce52 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -654,6 +654,7 @@ struct kvm_host_data {
 #define KVM_HOST_DATA_FLAG_HAS_TRBE			1
 #define KVM_HOST_DATA_FLAG_TRBE_ENABLED			4
 #define KVM_HOST_DATA_FLAG_EL1_TRACING_CONFIGURED	5
+#define KVM_HOST_DATA_FLAG_HAS_BRBE			6
 	unsigned long flags;
 
 	struct kvm_cpu_context host_ctxt;
@@ -687,6 +688,7 @@ struct kvm_host_data {
 		u64 trfcr_el1;
 		/* Values of trap registers for the host before guest entry. */
 		u64 mdcr_el2;
+		u64 brbcr_el1;
 	} host_debug_state;
 
 	/* Guest trace filter value */
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 0e4c805e7e89..bc6015108a68 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -81,6 +81,10 @@ void kvm_init_host_debug_data(void)
 	    !(read_sysreg_s(SYS_PMBIDR_EL1) & PMBIDR_EL1_P))
 		host_data_set_flag(HAS_SPE);
 
+	/* Check if we have BRBE implemented and available at the host */
+	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_BRBE_SHIFT))
+		host_data_set_flag(HAS_BRBE);
+
 	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_TraceFilt_SHIFT)) {
 		/* Force disable trace in protected mode in case of no TRBE */
 		if (is_protected_kvm_enabled())
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 2f4a4f5036bb..2a1c0f49792b 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -92,12 +92,42 @@ static void __trace_switch_to_host(void)
 			  *host_data_ptr(host_debug_state.trfcr_el1));
 }
 
+static void __debug_save_brbe(u64 *brbcr_el1)
+{
+	*brbcr_el1 = 0;
+
+	/* Check if the BRBE is enabled */
+	if (!(read_sysreg_el1(SYS_BRBCR) & (BRBCR_ELx_E0BRE | BRBCR_ELx_ExBRE)))
+		return;
+
+	/*
+	 * Prohibit branch record generation while we are in guest.
+	 * Since access to BRBCR_EL1 is trapped, the guest can't
+	 * modify the filtering set by the host.
+	 */
+	*brbcr_el1 = read_sysreg_el1(SYS_BRBCR);
+	write_sysreg_el1(0, SYS_BRBCR);
+}
+
+static void __debug_restore_brbe(u64 brbcr_el1)
+{
+	if (!brbcr_el1)
+		return;
+
+	/* Restore BRBE controls */
+	write_sysreg_el1(brbcr_el1, SYS_BRBCR);
+}
+
 void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
 	/* Disable and flush SPE data generation */
 	if (host_data_test_flag(HAS_SPE))
 		__debug_save_spe(host_data_ptr(host_debug_state.pmscr_el1));
 
+	/* Disable BRBE branch records */
+	if (host_data_test_flag(HAS_BRBE))
+		__debug_save_brbe(host_data_ptr(host_debug_state.brbcr_el1));
+
 	if (__trace_needs_switch())
 		__trace_switch_to_guest();
 }
@@ -111,6 +141,8 @@ void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
 	if (host_data_test_flag(HAS_SPE))
 		__debug_restore_spe(*host_data_ptr(host_debug_state.pmscr_el1));
+	if (host_data_test_flag(HAS_BRBE))
+		__debug_restore_brbe(*host_data_ptr(host_debug_state.brbcr_el1));
 	if (__trace_needs_switch())
 		__trace_switch_to_host();
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 7d2ba6ef0261..0d66d3b54800 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -319,7 +319,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 * We're about to restore some new MMU state. Make sure
 	 * ongoing page-table walks that have started before we
 	 * trapped to EL2 have completed. This also synchronises the
-	 * above disabling of SPE and TRBE.
+	 * above disabling of BRBE, SPE and TRBE.
 	 *
 	 * See DDI0487I.a D8.1.5 "Out-of-context translation regimes",
 	 * rule R_LFHQG and subsequent information statements.

-- 
2.47.2

