Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5AAFD313542
	for <kvmarm@lists.linux.dev>; Wed, 12 Nov 2025 10:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762943375; cv=none; b=u16KrNb3lT0klgmbt+S8JD6JnxMb1BbFgWRZlhZn0DNHXfCq/7cWFv95ovOSqLfrNKHJGmQwUVyImnCa2qDacZmGdbpYpjpIqFcZ52Hn6DItiB0u1BzO9KhdE/figT+hsJD86AEALBMo44yDDLP8Zlxu0S6rLdQgpUJxqKTh/c0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762943375; c=relaxed/simple;
	bh=NelOy/iaPfnwH4A8Hrxn5iUTCKwvGdLVBrLxLzTnviw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=kFnDhl4Nzymc5U16UIB7mMk9MKxPwF+YiN+wDXPr/3bnNbSRrMDOUxey0+4mWOmKLKgjSqhwo299SxV8So7hEmBXOlYZWrQ1QQinLBC1oQBiOTtQaqXlXPBvwSjSvnNC+neRVce5vJvKCLZZ0AfOh7nEMwwd1KkrZ7pz5SHCZPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF93C1515;
	Wed, 12 Nov 2025 02:29:23 -0800 (PST)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6A1DD3F5A1;
	Wed, 12 Nov 2025 02:29:30 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: maz@kernel.org,
	oliver.upton@linux.dev,
	joey.gouly@arm.com,
	suzuki.poulose@arm.com,
	yuzenghui@huawei.com,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev
Subject: [PATCH] KVM: arm64: VHE: Compute fgt traps before activating them
Date: Wed, 12 Nov 2025 10:28:53 +0000
Message-ID: <20251112102853.47759-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.51.2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On VHE, the Fine Grain Traps registers are written to hardware in
kvm_arch_vcpu_load()->..->__activate_traps_hfgxtr(), but the fgt array is
computed later, in kvm_vcpu_load_fgt(). This can lead to zero being written
to the FGT registers the first time a VCPU is loaded. Also, any changes to
the fgt array will be visible only after the VCPU is scheduled out, and
then back in, which is not the intended behaviour.

Fix it by computing the fgt array just before the fgt traps are written
to hardware.

Fixes: fb10ddf35c1c ("KVM: arm64: Compute per-vCPU FGTs at vcpu_load()")
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---

Stumbled upon this when running a Linux guest on FVP with FEAT_S1PIE
enabled.  Linux touches PIRE0_EL1 very early during boot, in __cpu_setup().
HFGWTR_EL2 was 0 the first time the VCPU was run, KVM would then trap
the access to PIR0_EL1 (PIRE0_EL1 is an inverted trap) and trigger the
BUG_ON(!r->access) from perform_access().

I hacked __activate_traps_hfgxtr() to print the register value for
HFGWTR_EL2. Before this patch, during the first vcpu_load(),
HFGWTR_EL2 is 0, then it has the correct value. After this patch, it
always has the correct value.

If I were to venture a shot in the dark, it might be that the name is a bit
misleading - it's kvm_vpcu_load_fgt(), but it doesn't load anything onto
hardware, it just computes values. Might be worth renaming to avoid
similar ordering issues in the future.

 arch/arm64/kvm/arm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 870953b4a8a7..052bf0d4d0b0 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -624,6 +624,7 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 	kvm_timer_vcpu_load(vcpu);
 	kvm_vgic_load(vcpu);
 	kvm_vcpu_load_debug(vcpu);
+	kvm_vcpu_load_fgt(vcpu);
 	if (has_vhe())
 		kvm_vcpu_load_vhe(vcpu);
 	kvm_arch_vcpu_load_fp(vcpu);
@@ -642,7 +643,6 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		vcpu->arch.hcr_el2 |= HCR_TWI;
 
 	vcpu_set_pauth_traps(vcpu);
-	kvm_vcpu_load_fgt(vcpu);
 
 	if (is_protected_kvm_enabled()) {
 		kvm_call_hyp_nvhe(__pkvm_vcpu_load,

base-commit: e9a6fb0bcdd7609be6969112f3fbfcce3b1d4a7c
-- 
2.51.2

