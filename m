Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0E31355F57;
	Thu,  3 Sep 2026 23:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788477388; cv=none; b=TEBZmDt+ly6qtq5MWIN7w/Vb9WrmfBe/nT+NvhWl0d++6a51m7hknQe6OkugrfloInIgNgsIeQwYwSYIhaeXgFyn4v0upg9vc10UuGUUxsujBDIFlEHRbaPg5JCwWR+pzgdXs6vyNteue6axq27g7Fl4h55i18bhElqI1O4fm6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788477388; c=relaxed/simple;
	bh=m2xwmDCjNgWapd/DEecgRupRw6i0Ywty5yfM9Aq18Uk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=E0RY9MnJQFMHXKj/pYygOU9PfmxqEpbzIQFro4uoT5lVQ8H1amRowv7PTjat/6PfwrhxbBJJwzf351AmZZ5oQRtBc2p4eP7zypN4Pys9Zpki1Wb5ixqyPRzwt4a4xXVHvHBABqqqxb9EWO0c9VGwMZ91EyuVLe/MR2oCbN/90yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nt6kkVtA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nt6kkVtA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86731F00A3D;
	Thu,  3 Sep 2026 23:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788477387;
	bh=IFXug7lt8O1DzPVNSLJUroR3QNnmHPKu1MT97rRTHaI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Nt6kkVtA9GEBFnhLv5rntBAtwXiFyMBlvFGneZw/deS78alUdT3x0vc84DvuE403a
	 uYiwheisInO80mYHppExAc6Zy7R4U+I/XABcMKLEmvHs5OGKLL9gBAwBcZu9OeY7hY
	 5OCUZHdO3MijyIG/RFROkPbbuIylJVBYpP3D+lERVIeu7jviba4Ey6g11LOwghh8EA
	 EBGPqVCvxYPQiR/J3SUd8YAyoQ7X3cVs9TTl9jAilZA0SP9vDH883zV1pfZgbv00vs
	 vJoYAj6df6fSDfny+y9THzsWSg6IYynIJkv7K68tx5TblDEwoYGMvgngW1CbAvtHpb
	 gIIblV5JlnP8g==
From: Mark Brown <broonie@kernel.org>
Date: Fri, 04 Sep 2026 00:14:41 +0100
Subject: [PATCH 1/2] KVM: arm64: Initialise TCR2_EL2 for nVHE mode
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260904-kvm-arm64-nvhe-pie-v1-1-29d59f245e6c@kernel.org>
References: <20260904-kvm-arm64-nvhe-pie-v1-0-29d59f245e6c@kernel.org>
In-Reply-To: <20260904-kvm-arm64-nvhe-pie-v1-0-29d59f245e6c@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
 Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3946; i=broonie@kernel.org;
 h=from:subject:message-id; bh=m2xwmDCjNgWapd/DEecgRupRw6i0Ywty5yfM9Aq18Uk=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqmf/CUtTD7h0oTf9EXg27od/qlpYCgCmNjCV3J
 HePuiZ+yiWJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCapn/wgAKCRAk1otyXVSH
 0ObDB/9hgGOVRyo/uPUF/+4Mo1doU0+FGEjbCtpUX7IaL8wc2xbegIwVwesJfM2K9Jilr7Lq+xf
 lOWkYaTmbkh8fryhSLXwly8DBfAYcTAs21QXD008RptY5vkdPvKanUdT28OSIWtCVS7FRrOcPiy
 KdOwzQXtgGTK/pSyNVWLsWcUkDfxMAyLTUbFhyykzeTLeYWz7vINz2x8h7CF2+Ge6la3HbrCdN8
 J/YkHzlksjPXWTs+/8DQGEWPdoGTxqYqiTnZBxLonYQRWz21CvGCXhrPZe4B3iiv9jHvZhXuZOC
 f6rSUxNkxOpjZO4I/rwhVu/k1JEPMmOtaaINHUml2bLhomy3
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

We currently only configure TCR2_EL2 in VHE mode, this is done in
__finalise_el2 which only runs for VHE. While all systems with TCR2_EL2
should have VHE support users may wish to run them in nVHE mode, for
example in order to use protected VMs.

Determine the value to load for TCR2_EL2 in C code in a similar manner to
TCR_EL2, further patches will configure some bits in the register. When
resetting back to the hypervisor stub clear all bits in the register in
case something without support for TCR2_EL2 runs later.

The only practical impact should be if we are started with a misconfigured
TCR2_EL2.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/include/asm/kvm_asm.h   |  1 +
 arch/arm64/kernel/asm-offsets.c    |  1 +
 arch/arm64/kvm/arm.c               |  5 ++++-
 arch/arm64/kvm/hyp/nvhe/hyp-init.S | 18 ++++++++++++++++--
 4 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_asm.h b/arch/arm64/include/asm/kvm_asm.h
index e5b92ac09e69..eb796436d6eb 100644
--- a/arch/arm64/include/asm/kvm_asm.h
+++ b/arch/arm64/include/asm/kvm_asm.h
@@ -208,6 +208,7 @@ extern void *__vhe_undefined_symbol;
 struct kvm_nvhe_init_params {
 	unsigned long mair_el2;
 	unsigned long tcr_el2;
+	unsigned long tcr2_el2;
 	unsigned long tpidr_el2;
 	unsigned long stack_hyp_va;
 	unsigned long stack_pa;
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 9c853ed3ceab..baffe58015d6 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -118,6 +118,7 @@ int main(void)
   DEFINE(HOST_DATA_CONTEXT,	offsetof(struct kvm_host_data, host_ctxt));
   DEFINE(NVHE_INIT_MAIR_EL2,	offsetof(struct kvm_nvhe_init_params, mair_el2));
   DEFINE(NVHE_INIT_TCR_EL2,	offsetof(struct kvm_nvhe_init_params, tcr_el2));
+  DEFINE(NVHE_INIT_TCR2_EL2,	offsetof(struct kvm_nvhe_init_params, tcr2_el2));
   DEFINE(NVHE_INIT_TPIDR_EL2,	offsetof(struct kvm_nvhe_init_params, tpidr_el2));
   DEFINE(NVHE_INIT_STACK_HYP_VA,	offsetof(struct kvm_nvhe_init_params, stack_hyp_va));
   DEFINE(NVHE_INIT_PGD_PA,	offsetof(struct kvm_nvhe_init_params, pgd_pa));
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8b080804bc90..88eb0459ad4b 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2158,7 +2158,7 @@ static int kvm_init_vector_slots(void)
 static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 {
 	struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
-	unsigned long tcr;
+	unsigned long tcr, tcr2;
 
 	/*
 	 * Calculate the raw per-cpu offset without a translation from the
@@ -2186,6 +2186,9 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
 	tcr |= TCR_T0SZ(hyp_va_bits);
 	params->tcr_el2 = tcr;
 
+	tcr2 = 0;
+	params->tcr2_el2 = tcr2;
+
 	params->pgd_pa = kvm_mmu_get_httbr();
 	if (is_protected_kvm_enabled())
 		params->hcr_el2 = HCR_HOST_NVHE_PROTECTED_FLAGS;
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
index 0b3e0b28dfc7..a39de9c20d27 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
@@ -137,8 +137,13 @@ alternative_if ARM64_HAS_CNP
 alternative_else_nop_endif
 	msr	ttbr0_el2, x2
 
-	ldr	x0, [x0, #NVHE_INIT_TCR_EL2]
-	msr	tcr_el2, x0
+	ldr	x1, [x0, #NVHE_INIT_TCR_EL2]
+	msr	tcr_el2, x1
+
+alternative_if ARM64_HAS_TCR2
+	ldr	x1, [x0, #NVHE_INIT_TCR2_EL2]
+	msr	REG_TCR2_EL2, x1
+alternative_else_nop_endif
 
 	isb
 
@@ -250,6 +255,15 @@ reset:
 	mov_q	x5, INIT_SCTLR_EL2_MMU_OFF
 	pre_disable_mmu_workaround
 	msr	sctlr_el2, x5
+
+alternative_if ARM64_HAS_TCR2
+	/*
+	 * Disable any features we enabled in case the next user doesn't
+	 * have TCR2_EL2 support.
+	 */
+	msr	REG_TCR2_EL2, xzr
+alternative_else_nop_endif
+
 	isb
 
 	/* Install stub vectors */

-- 
2.47.3

