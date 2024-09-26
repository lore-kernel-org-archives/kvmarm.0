Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD0921741C6
	for <kvmarm@lists.linux.dev>; Thu, 26 Sep 2024 03:23:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727320999; cv=none; b=hp/gkStj8KEG7J3Xp/mSBPQgXuazG0l0FE86Gn8AdgbhM1eNwC1/6nwpUvCvQzyqbIY5rXot4xnzXBsFr+8JTqnVhCusQGIg+7pqHVfWpbO3zFXMaduL/4W//MJzp6os93aaqGTFjvnXJ6TO//JMIH43dUC5UfurN66T6eTe5Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727320999; c=relaxed/simple;
	bh=hoBmpJX/k+/y8Mvi9dseWa6KwUJolOVVIYw5Z72BIaY=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=IiAvFaT2DuXWSm/6Y6JWzmOjxl0D5G4h6DUd1siZtgbSSafQkqTFTYo5a8m94qZ+FvcobocKf0wk81H5PIjBxZpRq9XKdDBoF2Ue8TwKRma9ZqRoe20sBWNXPQxGtxBdynctNM7vdLwpe7Kn+sA+4/JjcSv65KtwSQpwUS22pAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ABrLzieY; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ABrLzieY"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727320996;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=J7+hyoxMPs/6YsZ4hAk6EhlN0QJa+uQdbWMbmUd1Kbw=;
	b=ABrLzieY5to9BV0x9T3VEJ1Q/cTf3J1ED9MfWGNhQzB/AukXzdC8OONmM8cBpuB8rE2ebW
	bS8zB/4zfxjckox5ToanEqbipLZY4T5Bjl4OhrnYfD+vh9KzLEz9k+em554GFnKVOZAWzK
	0zql47F+vdaRWu+uTjaBuSiWE27kFfg=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-27-xppY4uQsN_OCBX0c_obmhw-1; Wed,
 25 Sep 2024 23:23:13 -0400
X-MC-Unique: xppY4uQsN_OCBX0c_obmhw-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (unknown [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 717E819772DE;
	Thu, 26 Sep 2024 03:23:11 +0000 (UTC)
Received: from virt-mtcollins-01.lab.eng.rdu2.redhat.com (unknown [10.8.1.196])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 1CA1D19560A3;
	Thu, 26 Sep 2024 03:23:09 +0000 (UTC)
From: Shaoqin Huang <shahuang@redhat.com>
To: Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>,
	kvmarm@lists.linux.dev
Cc: Eric Auger <eauger@redhat.com>,
	Sebastian Ott <sebott@redhat.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Fuad Tabba <tabba@google.com>,
	Mark Brown <broonie@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kristina Martsenko <kristina.martsenko@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 1/2] KVM: arm64: Use kvm_has_feat() to check if FEAT_RAS is advertised to the guest
Date: Wed, 25 Sep 2024 23:22:39 -0400
Message-Id: <20240926032244.3666579-2-shahuang@redhat.com>
In-Reply-To: <20240926032244.3666579-1-shahuang@redhat.com>
References: <20240926032244.3666579-1-shahuang@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

Use kvm_has_feat() to check if FEAT_RAS is advertised to the guest, this
is useful when FEAT_RAS is writable.

Signed-off-by: Shaoqin Huang <shahuang@redhat.com>
---
 arch/arm64/kvm/guest.c                     | 4 ++--
 arch/arm64/kvm/handle_exit.c               | 2 +-
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 2 +-
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 7 +++++--
 arch/arm64/kvm/sys_regs.c                  | 2 +-
 5 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 11098eb7eb44..938e3cd05d1e 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -819,7 +819,7 @@ int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events)
 {
 	events->exception.serror_pending = !!(vcpu->arch.hcr_el2 & HCR_VSE);
-	events->exception.serror_has_esr = cpus_have_final_cap(ARM64_HAS_RAS_EXTN);
+	events->exception.serror_has_esr = kvm_has_feat(vcpu->kvm, ID_AA64PFR0_EL1, RAS, IMP);
 
 	if (events->exception.serror_pending && events->exception.serror_has_esr)
 		events->exception.serror_esr = vcpu_get_vsesr(vcpu);
@@ -841,7 +841,7 @@ int __kvm_arm_vcpu_set_events(struct kvm_vcpu *vcpu,
 	bool ext_dabt_pending = events->exception.ext_dabt_pending;
 
 	if (serror_pending && has_esr) {
-		if (!cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
+		if (!kvm_has_feat(vcpu->kvm, ID_AA64PFR0_EL1, RAS, IMP))
 			return -EINVAL;
 
 		if (!((events->exception.serror_esr) & ~ESR_ELx_ISS_MASK))
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index d7c2990e7c9e..99f256629ead 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -405,7 +405,7 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 void handle_exit_early(struct kvm_vcpu *vcpu, int exception_index)
 {
 	if (ARM_SERROR_PENDING(exception_index)) {
-		if (this_cpu_has_cap(ARM64_HAS_RAS_EXTN)) {
+		if (kvm_has_feat(vcpu->kvm, ID_AA64PFR0_EL1, RAS, IMP)) {
 			u64 disr = kvm_vcpu_get_disr(vcpu);
 
 			kvm_handle_guest_serror(vcpu, disr_to_esr(disr));
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 37ff87d782b6..bf176a3cc594 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -272,7 +272,7 @@ static inline void ___activate_traps(struct kvm_vcpu *vcpu, u64 hcr)
 
 	write_sysreg(hcr, hcr_el2);
 
-	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
+	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR0_EL1, RAS, IMP) && (hcr & HCR_VSE))
 		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
 }
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 4c0fdabaf8ae..98526556d4e5 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -105,6 +105,8 @@ static inline void __sysreg_save_el1_state(struct kvm_cpu_context *ctxt)
 
 static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 {
+	struct kvm_vcpu *vcpu = ctxt_to_vcpu(ctxt);
+
 	ctxt->regs.pc			= read_sysreg_el2(SYS_ELR);
 	/*
 	 * Guest PSTATE gets saved at guest fixup time in all
@@ -113,7 +115,7 @@ static inline void __sysreg_save_el2_return_state(struct kvm_cpu_context *ctxt)
 	if (!has_vhe() && ctxt->__hyp_running_vcpu)
 		ctxt->regs.pstate	= read_sysreg_el2(SYS_SPSR);
 
-	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
+	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR0_EL1, RAS, IMP))
 		ctxt_sys_reg(ctxt, DISR_EL1) = read_sysreg_s(SYS_VDISR_EL2);
 }
 
@@ -220,6 +222,7 @@ static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctx
 {
 	u64 pstate = to_hw_pstate(ctxt);
 	u64 mode = pstate & PSR_AA32_MODE_MASK;
+	struct kvm_vcpu *vcpu = ctxt_to_vcpu(ctxt);
 
 	/*
 	 * Safety check to ensure we're setting the CPU up to enter the guest
@@ -238,7 +241,7 @@ static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctx
 	write_sysreg_el2(ctxt->regs.pc,			SYS_ELR);
 	write_sysreg_el2(pstate,			SYS_SPSR);
 
-	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN))
+	if (kvm_has_feat(vcpu->kvm, ID_AA64PFR0_EL1, RAS, IMP))
 		write_sysreg_s(ctxt_sys_reg(ctxt, DISR_EL1), SYS_VDISR_EL2);
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 31e49da867ff..b09f8ba3525b 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4513,7 +4513,7 @@ static void vcpu_set_hcr(struct kvm_vcpu *vcpu)
 
 	if (has_vhe() || has_hvhe())
 		vcpu->arch.hcr_el2 |= HCR_E2H;
-	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN)) {
+	if (kvm_has_feat(kvm, ID_AA64PFR0_EL1, RAS, IMP)) {
 		/* route synchronous external abort exceptions to EL2 */
 		vcpu->arch.hcr_el2 |= HCR_TEA;
 		/* trap error record accesses */
-- 
2.40.1

