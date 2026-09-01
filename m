Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A98BB49C4CA;
	Tue,  1 Sep 2026 18:28:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788287314; cv=none; b=U5LXazn5hC6LS0kXYCGVNjU4H17L1OF4gGMf+es70lmJdcZ65Xj2x1MNiRC4Bjfh2JEvSWJv+iNee0s3YPnQrFBVdGk3xrMZPBOB09tsglJHgng8qpdChqz74y1/hNgFCEfLDnNPEF8ntszeHE0aUhI9nm+FUYxw+ER19Fl2oMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788287314; c=relaxed/simple;
	bh=lBDxSzgyNBSf8JDYIm3Kwcw85vQzobAaLaAXySGMcRA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=F0qV9eJvJGJmoSdTOlBradHsiGle3lPZl2wvWmDCWlobR9IlinCGcoAK5+SwZN/LUs6zGfET8czRo2CiWiQiDFJjK2ZForl7thIldBzrSJnywcYud2cJAzJq6Hun3Q/VokVPGeaAekNB9WzJXt7E2ymD60J/+yeM5TIM6E18nBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HSHCTQ9Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HSHCTQ9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BAB71F00A3D;
	Tue,  1 Sep 2026 18:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788287312;
	bh=tRITfiIcOD/weR9OjHr1O6kc2H9qVZ2hVpmVh+DuonY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HSHCTQ9YirZKIhZKCfbIHzk/2DA68efNtDFUGo5QA14/999gVZLCVHIWXNfp2VC51
	 hoGeqv+4S+ULch4v56UdoVTXSCKP3I7iLOQZWC3isOpuRJJLiJRUD5Cvcp3RELAfZC
	 Vlr4kr4g4JK2aw4A8gxPskxDB3SUXUcLnAW0gnpV4ALwpMgzj3SAfT4giLWhk2dnyG
	 O8WudXN+5F0nvSKIXMJ0t9RlmLfSGYNL0rHPimAjt3MIZlQ2VHuXepFrrkds8jbbOg
	 mjuGBTqVZw5nLyTkl1po7vrmkDKwt3rtCe5iCQkSP68Y/DO5K1IvIyIi5sjnvfRzv3
	 +fUOZaOi968gg==
From: Mark Brown <broonie@kernel.org>
Date: Tue, 01 Sep 2026 19:18:48 +0100
Subject: [PATCH v3 1/3] KVM: arm64: Finalize guest-wide sysregs prior to
 per-vCPU sysregs
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260901-kvm-arm64-idreg-final-v3-1-a0ffa06fa872@kernel.org>
References: <20260901-kvm-arm64-idreg-final-v3-0-a0ffa06fa872@kernel.org>
In-Reply-To: <20260901-kvm-arm64-idreg-final-v3-0-a0ffa06fa872@kernel.org>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
 Joey Gouly <joey.gouly@arm.com>, Steffen Eiden <seiden@linux.ibm.com>, 
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Zenghui Yu <yuzenghui@huawei.com>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
Cc: Peter Maydell <peter.maydell@linaro.org>, 
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
 linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>, 
 Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3857; i=broonie@kernel.org;
 h=from:subject:message-id; bh=lBDxSzgyNBSf8JDYIm3Kwcw85vQzobAaLaAXySGMcRA=;
 b=owEBbQGS/pANAwAKASTWi3JdVIfQAcsmYgBqlxlGEEVCWWwM0CFszn1oeaFietGTruv77Y90/
 BE6mboR7UuJATMEAAEKAB0WIQSt5miqZ1cYtZ/in+ok1otyXVSH0AUCapcZRgAKCRAk1otyXVSH
 0LkvB/0SBV7AyykDoulPmrd0SSpo/FspMzjH5YUZHHUYi8v2LptqZXoh1tTrLhm3ByebbwWS8Ww
 Jt/R5+4w9lQvVwCw2WrulkQQJwDgDEQijBLm08VIjHGyHuGDs32lPARtKe3fk5J/W+S3C3j4sqU
 /LnRzAWVDdHvhWTOHgA4s4eGXgTZb9vI6aMEoj3JfsOywyJ+x3Rxz8xCNUJCCbmTyUbSd5VW3cu
 CiZyk9a221EA2xdbGGbMteVhhSfHEQBW3ODCszzLXoogf8+o5wnbIb5rrR2Aw5QG9I+gsKUeliI
 IJQ5On3r//dZsLCgT3rLxlQHuMRkido0kLiKBZhtDqoFL1OC
X-Developer-Key: i=broonie@kernel.org; a=openpgp;
 fpr=3F2568AAC26998F9E813A1C5C3F436CA30F5D8EB

In commit d82d09d5ba4b ("KVM: arm64: Don't skip per-vcpu NV
initialisation") the NV register sanitisation was moved earlier in
kvm_finalize_sys_regs() so that it runs for each vCPU rather than only
once per guest. This means that for the first vCPU it runs prior to vGIC
finalization, but the vGIC finalization updates the ID registers which
the NV initialization uses so we may end up with a mismatch. For
example, HFGRTR_EL2.ICC_IGRPENn_EL1 depends on GICv3 being enabled in
ID_AA64PFR0_EL1.GIC so may be mistakenly marked or not marked as RES0.

Split the initialization which runs once per guest into a separate
function and run that before the per-vCPU initialisation for NV,
renaming the per-vCPU function to make it clear that it does per-vCPU
setup.

Fixes: d82d09d5ba4b ("KVM: arm64: Don't skip per-vcpu NV initialisation")
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
Tested-by: Fuad Tabba <fuad.tabba@linux.dev>
Signed-off-by: Mark Brown <broonie@kernel.org>
---
 arch/arm64/kvm/arm.c      |  2 +-
 arch/arm64/kvm/sys_regs.c | 40 ++++++++++++++++++++++++++--------------
 arch/arm64/kvm/sys_regs.h |  2 +-
 3 files changed, 28 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 8b080804bc90..4f044280dec0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -949,7 +949,7 @@ int kvm_arch_vcpu_run_pid_change(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
-	ret = kvm_finalize_sys_regs(vcpu);
+	ret = kvm_vcpu_finalize_sys_regs(vcpu);
 	if (ret)
 		return ret;
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 44aae52c473d..880f84248427 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5861,25 +5861,14 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 }
 
 /*
- * Perform last adjustments to the ID registers that are implied by the
+ * Do system register finalization that is shared by the whole guest. This
+ * includes last adjustments to the ID registers that are implied by the
  * configuration outside of the ID regs themselves, as well as any
  * initialisation that directly depend on these ID registers (such as
  * RES0/RES1 behaviours). This is not the place to configure traps though.
- *
- * Because this can be called once per CPU, changes must be idempotent.
  */
-int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
+static int kvm_vm_finalize_sys_regs(struct kvm *kvm)
 {
-	struct kvm *kvm = vcpu->kvm;
-
-	guard(mutex)(&kvm->arch.config_lock);
-
-	if (vcpu_has_nv(vcpu)) {
-		int ret = kvm_init_nv_sysregs(vcpu);
-		if (ret)
-			return ret;
-	}
-
 	if (kvm_vm_has_ran_once(kvm))
 		return 0;
 
@@ -5931,6 +5920,29 @@ int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+/*
+ * Because this can be called once per CPU, changes must be idempotent.
+ */
+int kvm_vcpu_finalize_sys_regs(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+	int ret;
+
+	guard(mutex)(&kvm->arch.config_lock);
+
+	ret = kvm_vm_finalize_sys_regs(kvm);
+	if (ret)
+		return ret;
+
+	if (vcpu_has_nv(vcpu)) {
+		ret = kvm_init_nv_sysregs(vcpu);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
+}
+
 int __init kvm_sys_reg_table_init(void)
 {
 	const struct sys_reg_desc *gicv3_regs;
diff --git a/arch/arm64/kvm/sys_regs.h b/arch/arm64/kvm/sys_regs.h
index bd56a45abbf9..a3cccad2766f 100644
--- a/arch/arm64/kvm/sys_regs.h
+++ b/arch/arm64/kvm/sys_regs.h
@@ -254,7 +254,7 @@ int kvm_sys_reg_set_user(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg,
 
 bool triage_sysreg_trap(struct kvm_vcpu *vcpu, int *sr_index);
 
-int kvm_finalize_sys_regs(struct kvm_vcpu *vcpu);
+int kvm_vcpu_finalize_sys_regs(struct kvm_vcpu *vcpu);
 
 #define AA32(_x)	.aarch32_map = AA32_##_x
 #define Op0(_x) 	.Op0 = _x

-- 
2.47.3

