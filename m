Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A6F842E42B;
	Mon,  5 Oct 2026 09:08:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791191312; cv=none; b=u9qQ579Nj5l3RN6wrs0BMDgAE133ZQPPZS2bjyGWEpvSx5NcTiu2QqqQX/qbYdMUBrYAtuOltGzbttLsxII27sdcqqFwrHGmdwDraVS6XDh+l5YXxm8KUJwF7TAzCwfKPXOnYFq79tVTcwOmYNTbQJbgDIPXEI9ZOBp+2Y81Oxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791191312; c=relaxed/simple;
	bh=BicQ2agMF8WddKiPdc29R77aPK6mes59v7ybLPMSnVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ncX/qd9KqhxQK5o6HiW6ZUf5To5dLuLh89BMBu0pJ66YdCDKxeajkptlWjtycq7AYwJ9ImXuqCJ85+e3b+o0hYCDnshlpSwIwQm4xgH2NgjJorCk7tLquUU4e/Gng8/BEn4Y9gF/NZPmlTRTz0fyUOfLKZF3ePSh4lLPGzK7l8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=F9SOcFFN; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="F9SOcFFN"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7AC911576;
	Mon,  5 Oct 2026 02:08:26 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id D82D03F66F;
	Mon,  5 Oct 2026 02:08:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791191309; bh=BicQ2agMF8WddKiPdc29R77aPK6mes59v7ybLPMSnVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9SOcFFNPe4pmGdULc6Y8UGDBXiLKb4yFq8EHGQbnwE1Z1h6dSJdIfh+RXesBgw1L
	 21c8sPmHCgdvjUO+SgCUBj5oyzsQjAIjrMGyketMcWNX0sir+p2e5EEuUbAtYF1WBa
	 nqvUNtoxcJQEihXr5RJp4i2MmkBCGXFFfNBGd3/I=
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.linux.dev
Cc: maz@kernel.org,
	will@kernel.org,
	catalin.marinas@arm.com,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	steven.price@arm.com,
	aneesh.kumar@kernel.org,
	oupton@kernel.org,
	gshan@redhat.com,
	joey.gouly@arm.com,
	tabba@google.com,
	yuzenghui@huawei.com,
	linux-coco@lists.linux.dev,
	gankulkarni@os.amperecomputing.com,
	sdonthineni@nvidia.com,
	alpergun@google.com,
	fj0570is@fujitsu.com,
	WeiLin.Chang@arm.com,
	lpieralisi@kernel.org,
	enju.kohei@fujitsu.com,
	sudeep.holla@arm.com,
	jonathan.cameron@oss.qualcomm.com,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH v22 07/23] KVM: arm64: Refactor the vcpu_load to allow for VM specific callbacks
Date: Mon,  5 Oct 2026 10:07:38 +0100
Message-ID: <20261005090754.2140522-8-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261005090754.2140522-1-suzuki.poulose@arm.com>
References: <20261005090754.2140522-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To keep the VCPU load/put handling cleaner with the different kinds of VM
types, we are about to introduce VM specific callbacks to do just the right
thing. In preparation for that, make some refactoring to add the change
easier by mainly feature specific configurations to individual wrappers,
so that different callbacks could reuse the helpers.

Adds vcpu_prepare_mmu()/vcpu_put_mmu() wrappers to load/put MMU related
configurations for !pKVM guests. Additionally makes it explicit that
kvm_arm_vmid_clear_active() is not required for pKVM host.

Add vcpu_load_pvtime(), vcpu_set_wfx_traps() wrappers for handling the
corresponding configurations.

While at it, also make it clear that the timer loading constraints only
apply for the VHE.

No functional changes intended. Based on a work by Marc Zyngier.

Reviewed-by: Gavin Shan <gshan@redhat.com>
Tested-by: Gavin Shan <gshan@redhat.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
Changes since v19:
 - Add vcpu_put_mmu() to pair with the vcpu_prepare_mmu() and make the
   call conditional on !is_protected_kvm_enabled(). Preparing the path
   for per-flavor callbacks
 - Update the timer load constraints comment to reflect that it only applies
   for VHE
 - Wrap kvm_arm_vmid_clear_active() to vcpu_put_mmu() to compliement
   with the vcpu_prepare_mmu(). Also only clear the VMID for non-pKVM
   guests
---
 arch/arm64/kvm/arm.c | 59 ++++++++++++++++++++++++++++++--------------
 1 file changed, 40 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 50b84065ead1a..24800809b4a96 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -684,14 +684,11 @@ static bool kvm_vcpu_should_clear_twe(struct kvm_vcpu *vcpu)
 	return single_task_running();
 }
 
-void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+static void vcpu_prepare_mmu(struct kvm_vcpu *vcpu)
 {
 	struct kvm_s2_mmu *mmu;
 	int *last_ran;
 
-	if (is_protected_kvm_enabled())
-		goto nommu;
-
 	if (vcpu_has_nv(vcpu))
 		kvm_vcpu_load_hw_mmu(vcpu);
 
@@ -721,34 +718,56 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 		kvm_call_hyp(__kvm_flush_cpu_context, mmu);
 		*last_ran = vcpu->vcpu_idx;
 	}
+}
 
-nommu:
+static void vcpu_put_mmu(struct kvm_vcpu *vcpu)
+{
+	kvm_arm_vmid_clear_active();
+}
+
+static void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vcpu_should_clear_twe(vcpu))
+		vcpu->arch.hcr_el2 &= ~HCR_TWE;
+	else
+		vcpu->arch.hcr_el2 |= HCR_TWE;
+
+	if (kvm_vcpu_should_clear_twi(vcpu))
+		vcpu->arch.hcr_el2 &= ~HCR_TWI;
+	else
+		vcpu->arch.hcr_el2 |= HCR_TWI;
+}
+
+static void vcpu_load_pvtime(struct kvm_vcpu *vcpu)
+{
+	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
+		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
+}
+
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
 	vcpu->cpu = cpu;
 
+	if (!is_protected_kvm_enabled())
+		vcpu_prepare_mmu(vcpu);
 	/*
-	 * The timer must be loaded before the vgic to correctly set up physical
-	 * interrupt deactivation in nested state (e.g. timer interrupt).
+	 * For VHE, the timer must be loaded before the vgic to correctly
+	 * set up physical interrupt deactivation in nested state (e.g. timer
+	 * interrupt).
 	 */
 	kvm_timer_vcpu_load(vcpu);
 	kvm_vgic_load(vcpu);
 	kvm_vcpu_load_debug(vcpu);
 	kvm_vcpu_load_fgt(vcpu);
+
 	if (has_vhe())
 		kvm_vcpu_load_vhe(vcpu);
+
 	kvm_arch_vcpu_load_fp(vcpu);
 	kvm_vcpu_pmu_restore_guest(vcpu);
-	if (kvm_arm_is_pvtime_enabled(&vcpu->arch))
-		kvm_make_request(KVM_REQ_RECORD_STEAL, vcpu);
 
-	if (kvm_vcpu_should_clear_twe(vcpu))
-		vcpu->arch.hcr_el2 &= ~HCR_TWE;
-	else
-		vcpu->arch.hcr_el2 |= HCR_TWE;
-
-	if (kvm_vcpu_should_clear_twi(vcpu))
-		vcpu->arch.hcr_el2 &= ~HCR_TWI;
-	else
-		vcpu->arch.hcr_el2 |= HCR_TWI;
+	vcpu_load_pvtime(vcpu);
+	vcpu_set_wfx_traps(vcpu);
 
 	if (!is_protected_kvm_enabled())
 		vcpu_set_pauth_traps(vcpu);
@@ -787,7 +806,9 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 	kvm_vcpu_pmu_restore_host(vcpu);
 	if (vcpu_has_nv(vcpu))
 		kvm_vcpu_put_hw_mmu(vcpu);
-	kvm_arm_vmid_clear_active();
+
+	if (!is_protected_kvm_enabled())
+		vcpu_put_mmu(vcpu);
 
 	vcpu_clear_on_unsupported_cpu(vcpu);
 	vcpu->cpu = -1;
-- 
2.43.0

