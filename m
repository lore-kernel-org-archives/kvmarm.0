Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E90B374178;
	Mon,  3 Aug 2026 23:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785798841; cv=none; b=ij1AqZW6wbYYRMD3r9o+6JwCG+lhaXITEtLKEV9I9UsroLqRs6EYSGPNQSP7+7R4Gk3L6yEUCHwdGqnUJ+6jdBkMOBPJ5RqYI/Krtda0AAf9lZpuSlMzqBYyg+x/oLfKQCGg54otBhDLJPerRbFQA5h6rs+bDtQ+U4XdUTzLINc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785798841; c=relaxed/simple;
	bh=bEpjQNbOqRXEgxmuuFHddb+wqn5p6+xc/jGJ7dQCByg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Dwen+14R0jjmVD1PWMVp+EADf9kmTwBQE14BNO/r6GyPTdxqN1TauZ5GyheYNebDBHA6ZTFcT93Ga7JB0aXsK/ySC7+mLMaHey2Y7tZBGex3Pmsu987Yp45P/LzFqEvg8zQkcPHVg8Hd7zVkzHBQ5yZmsjt39LBoI8UOYHOuVoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PqFyFBEX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PqFyFBEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E54921F00ACA;
	Mon,  3 Aug 2026 23:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785798837;
	bh=PurQYqXf08AEX6gtFWKWTzYSPvMtTxS5SqC4IO0OrWI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=PqFyFBEXOtA9ykVatWA7QWgJvfFoCflpRnJCx3zRbm2r+K4GHkvkYSbYke9XHENYP
	 LtlVK3eHuW/9p4/SR2atP0seGGwkT9dihH7Jy7/6Sj2Z4He2aKUFON67t14QLh5/S2
	 UB2PsHUMBcnuBDwoVmG6sZWd2HMD1Ms1twvSTx28hPDgXeAtols2S+ffhaVWO03mku
	 t8kAKK+XRsW1y9cCfl3epCnnCWoXWI/KZRG9M1r9AKlNOKmzaWcYG2ektoZWBIbKhk
	 Hhu2Y/qL4ieSx800MT50dgwzKpMhPpfIAcrkSNShCVfZMzL6UIg7ZUt5dO/AQ5s3Xi
	 uLjL+LGfmmxcA==
From: Mark Brown <broonie@kernel.org>
Date: Mon, 03 Aug 2026 23:56:49 +0100
Subject: [PATCH v18 04/14] KVM: arm64: Ensure GCS memory effects are
 visible
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260803-arm64-gcs-v18-4-fd8c40f5ad88@kernel.org>
References: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
In-Reply-To: <20260803-arm64-gcs-v18-0-fd8c40f5ad88@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Shuah Khan <shuah@kernel.org>, Fuad Tabba <tabba@google.com>, 
 Oliver Upton <oupton@kernel.org>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org, 
 kvmarm@lists.linux.dev, linux-kselftest@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2294; i=broonie@kernel.org;
 h=from:subject:message-id; bh=bEpjQNbOqRXEgxmuuFHddb+wqn5p6+xc/jGJ7dQCByg=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqcSCcvNjLB4tkEjb/xUFQG1hdPElFCuRE4NDXo
 PbihH5N34mJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCanEgnAAKCRAk1otyXVSH
 0OFhB/94zXmoRtkIdaIqQ0+NWyxasfo5LNxSjiS4EmEjobzqgEto+1z7mMO7w7Yguq02tALAYLQ
 EWuUu6sp+mRa89RJ8KMkWoLzKu6dz5Eyshc3g2V/0yUQOX9WnhU8pwqCaINqdXsdO4xwfMmj1IY
 AvVVrmIxkQuyu9tC2Od4syd6HG8EdRBosoW7ACdTnsOrgk8SDfusTdlGMqqZuY36YlJ2P7ajeEE
 Nan/zyd70GGaIBg3yRyK6v4Usc0HmO2y/8miRxbWQEzLvwcYdldXZuLrvokAPvuzht1zgDsl+QZ
 myqmBEvVh/O9XWzy9fiNfHgIMwm3BLR0AMK7I+Hfdt0cy9Sb
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In order to allow efficient implementation of GCS implementations are
permitted to do GCS specific caching, with barriers implicit in stack
switch operations and GCSB DSYNC as an explicit barrier.  Since we do
not use GCS in the hypervisor or host kernel the hypervisor cannot rely
on any barriers being present in vCPU context switches other than those
it explicitly inserts.  Add explicit barriers when loading and saving
vCPU state.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/switch.c   | 13 +++++++++++++
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c | 14 ++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 7318e3e6a5f3..fe8727bf2833 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -301,6 +301,12 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	dsb(nsh);
 
+	/*
+	 * Ensure any GCS memory effects are visible to this CPU.
+	 */
+	if (ctxt_has_gcs(guest_ctxt))
+		gcsb_dsync();
+
 	__kvm_adjust_pc(vcpu);
 
 	/*
@@ -345,6 +351,13 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	 */
 	dsb(nsh);
 
+	/*
+	 * Ensure any GCS memory effects from the outgoing vCPU are
+	 * visible elsewhere.
+	 */
+	if (ctxt_has_gcs(guest_ctxt))
+		gcsb_dsync();
+
 	__deactivate_traps(vcpu);
 	__load_host_stage2();
 
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 2431c18f5792..4594992b008c 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -239,6 +239,13 @@ void __vcpu_load_switch_sysregs(struct kvm_vcpu *vcpu)
 	if (vcpu_has_nv(vcpu))
 		dsb(nsh);
 
+	/*
+	 * Ensure any GCS memory effects are visible to the incoming
+	 * vCPU.
+	 */
+	if (ctxt_has_gcs(guest_ctxt))
+		gcsb_dsync();
+
 	/*
 	 * Load guest EL1 and user state
 	 *
@@ -299,5 +306,12 @@ void __vcpu_put_switch_sysregs(struct kvm_vcpu *vcpu)
 	/* Restore host user state */
 	__sysreg_restore_user_state(host_ctxt);
 
+	/*
+	 * Ensure any GCS memory effects from the outgoing vCPU are
+	 * visible elsewhere.
+	 */
+	if (ctxt_has_gcs(guest_ctxt))
+		gcsb_dsync();
+
 	vcpu_clear_flag(vcpu, SYSREGS_ON_CPU);
 }

-- 
2.47.3

