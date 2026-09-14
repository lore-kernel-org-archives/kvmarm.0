Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B968A44AB81
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 11:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789386167; cv=none; b=nfSaDY4enxvTr6iuH26e1+CWyM/FegHlI8EECNksf+W6Lf6gnsN01X1jAjJj1FdflHoflt7UGaKNwlcI/STTNQkVKzodw3rFud+0o2rUfL1mUErpPAGcFR6phQzmllRhP7T8nh7q9Xd4LLr8ZmMs6CgIUaejnSVWcYKlpG5z/UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789386167; c=relaxed/simple;
	bh=MY/jR562APib/H5PnNAQpXfQqVflFL74wRudW4NPKLk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=T5/LQZC5zvxs+EXqoJck8UBw2TDxgZdEeKzSHpX+XUJNUobPCfac2Fl09hUL9/EILYoCgnz2HXAj5Fb0XybK/W+JsQMKqIrKbsVu6q7ewnqzBi5Y17tBxbzegxo8YkFasBeaAWepS2EZM5pcutv7QQN5g+58k/UipuiQarWKMkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=Co7DHrYr; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="Co7DHrYr"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 68EBfjsB084060
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 14 Sep 2026 20:41:54 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=GIXB8eZaOJo3t8CjCsMbAxvcyP47505SGp0Pcswlyqo=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1789386114; v=1;
        b=Co7DHrYrhrWbtAfZ30TcjLIKL2MO2hH8+Ke6piDC33Szq0UpgV+7UWUaBHUlAY2D
         PXHsClSyTUZXcAEM+m1VU2qVhJBNHMpXbmBvviTS/ifb9bvaswPJrZ+8+3q2R2+4
         gf9B+I+G1CHOiHA1fpnEpKDqBgFKMYQE4i1oo2lwZFXB/I2PW+/Aq+CJxQg21kRM
         lu7KdnIKl2y7dYRjAHOg0Jpf3Abuc7iAXz5oGlj95dtxPYnIK4oZxRLnPXlqjP+X
         MTng1AtIpQTqJCIH2PF/yb6U3kwPisSMHRho60Zgtn3ID+fAS/hEj6yH2nlrySBl
         5rP3Qh2/BI23GFXZP6HxVA==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 14 Sep 2026 20:40:48 +0900
Subject: [PATCH v10 09/20] KVM: arm64: PMU: Recreate events after PMCR_EL0
 changes
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-hybrid-v10-9-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
References: <20260914-hybrid-v10-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260914-hybrid-v10-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Eiden <seiden@linux.ibm.com>, Fuad Tabba <tabba@google.com>,
        Shannon Zhao <shannon.zhao@linaro.org>,
        Andrew Jones <drjones@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4845;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=MY/jR562APib/H5PnNAQpXfQqVflFL74wRudW4NPKLk=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ9byuwUmCjkcHxR4lryZnhga8O+pOlfu+xT9dVHFUen1v
 dtX2t3tKGVhEONikBVTZEkp2s2tEV37qTAhvgVmDisTyBAGLk4BmIjSSUaG1++rzOYzvzvGllao
 Ivlzk5ggx77lkUvNg7b224nVrv3/g+GfkVLbmpu/vbj/5k/84qf/Qslh2ba7tznXSySI/5p50sy
 bDQA=
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

PMCR_EL0.LC and PMCR_EL0.LP control whether cycle and event counters
overflow at 32 or 64 bits. They therefore determine the sample period
of each backing perf event.

Guest and userspace writes do not recreate existing events. Changing
either bit after an event has been created leaves its old sample period
in place, resulting in an incorrect overflow point.

Request event recreation when either bit changes. Preserve the existing
reload behavior for PMCR_EL0.E and other userspace writes.

Fixes: c82d28cbf1d4 ("KVM: arm64: PMU: Distinguish between 64bit counter and 64bit overflow")
Fixes: 11af4c37165e ("KVM: arm64: PMU: Implement PMUv3p5 long counter support")
Closes: https://sashiko.dev/#/patchset/20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp?part=6
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 arch/arm64/kvm/pmu-emul.c | 18 ++++++++++++++----
 arch/arm64/kvm/sys_regs.c |  3 ++-
 include/kvm/arm_pmu.h     |  2 ++
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 953255111779..e24ad6c72937 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -577,6 +577,17 @@ void kvm_pmu_request_recreate(struct kvm_vcpu *vcpu)
 	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
 }
 
+void kvm_pmu_apply_pmcr(struct kvm_vcpu *vcpu, u64 old, u64 val, bool force_reload)
+{
+	u64 changed = old ^ val;
+
+	/* Reload the PMU if the write affects the backing perf events. */
+	if (changed & (ARMV8_PMU_PMCR_LC | ARMV8_PMU_PMCR_LP))
+		kvm_pmu_request_recreate(vcpu);
+	else if (force_reload || (changed & ARMV8_PMU_PMCR_E))
+		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+}
+
 /**
  * kvm_pmu_handle_pmcr - handle PMCR register
  * @vcpu: The vcpu pointer
@@ -584,19 +595,18 @@ void kvm_pmu_request_recreate(struct kvm_vcpu *vcpu)
  */
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 {
+	u64 old = __vcpu_sys_reg(vcpu, PMCR_EL0);
 	int i;
 
 	/* Fixup PMCR_EL0 to reconcile the PMU version and the LP bit */
 	if (!kvm_has_feat(vcpu->kvm, ID_AA64DFR0_EL1, PMUVer, V3P5))
 		val &= ~ARMV8_PMU_PMCR_LP;
 
-	/* Request a reload of the PMU to enable/disable affected counters */
-	if ((__vcpu_sys_reg(vcpu, PMCR_EL0) ^ val) & ARMV8_PMU_PMCR_E)
-		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
-
 	/* The reset bits don't indicate any state, and shouldn't be saved. */
 	__vcpu_assign_sys_reg(vcpu, PMCR_EL0, (val & ~(ARMV8_PMU_PMCR_C | ARMV8_PMU_PMCR_P)));
 
+	kvm_pmu_apply_pmcr(vcpu, old, __vcpu_sys_reg(vcpu, PMCR_EL0), false);
+
 	if (val & ARMV8_PMU_PMCR_C)
 		kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index bae1b69a5ab9..2754b743da01 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1517,6 +1517,7 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 {
 	u8 new_n = FIELD_GET(ARMV8_PMU_PMCR_N, val);
 	struct kvm *kvm = vcpu->kvm;
+	u64 old = __vcpu_sys_reg(vcpu, r->reg);
 
 	mutex_lock(&kvm->arch.config_lock);
 
@@ -1549,7 +1550,7 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 		val |= ARMV8_PMU_PMCR_LC;
 
 	__vcpu_assign_sys_reg(vcpu, r->reg, val);
-	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+	kvm_pmu_apply_pmcr(vcpu, old, val, true);
 
 	return 0;
 }
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index f12c916c04d5..29bcc09da93e 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -57,6 +57,7 @@ bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu);
 bool kvm_pmu_update_run(struct kvm_vcpu *vcpu);
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_request_recreate(struct kvm_vcpu *vcpu);
+void kvm_pmu_apply_pmcr(struct kvm_vcpu *vcpu, u64 old, u64 val, bool force_reload);
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_apply_mdcr(struct kvm_vcpu *vcpu, u64 old, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
@@ -139,6 +140,7 @@ static inline bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu)
 static inline bool kvm_pmu_update_run(struct kvm_vcpu *vcpu) { return false; }
 static inline void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_request_recreate(struct kvm_vcpu *vcpu) {}
+static inline void kvm_pmu_apply_pmcr(struct kvm_vcpu *vcpu, u64 old, u64 val, bool force_reload) {}
 static inline void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_apply_mdcr(struct kvm_vcpu *vcpu, u64 old, u64 val) {}
 static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,

-- 
2.55.0

