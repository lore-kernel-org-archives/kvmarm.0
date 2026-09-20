Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65A2A3DD87B
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 11:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789903052; cv=none; b=t+2cmnpZdvB9TFiidE1GUjUQB92TBRlMyZxZMmDJg0N3eWgNhyBca3pmkJa1QxPXNfPesL482i/GVAB0stBwdmR4OA6vvkzAMvaHcdQhhLdZ3YDDpN9tqbJOd6r1uuvqzdl7D23ga/ZQdS4VXjG9uCpPyzKgBrlddNDySXAiHrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789903052; c=relaxed/simple;
	bh=ncqwVTRhMLVZJ0R7zoNIvotfazATWustdO6AcQZbKCg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=EuRi43XzbSMxghovZZ0Gcp9ty3Un+Fudh17JId7O7elV9NR7XWG+8B1EYYxII13LgW7xUfXbaFiyE6KE9ogDylcGfAQDWBiuSArFkw7xOjYfFO3Z1KjhT2o/ZX7Dh7enHi8V2SyceJQBGCFbxZN6HuRf0PMeHJ5zFCHwNZL2UlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=ZjUnscj/; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="ZjUnscj/"
Received: from [192.168.10.153] (p865013-ipoe.ipoe.ocn.ne.jp [153.242.222.12])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 68KBG36X088236
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 20 Sep 2026 20:16:12 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=gbW6xk6EhkHfkclCXWn+MtzeM9CYCbrnQ0r77RgNKyg=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1789902973; v=1;
        b=ZjUnscj/nnD3zdjLaeyOQg8b/bOIHSDaebFwWT7bvo2UDMhw689IybNI2I+0S+KG
         eDLCqwUsZt9DdYsOlRcMfJvEvpQwD2Tx7Nt+vnV9zay8f3HWSKHkbZ5JPbQGGUZd
         hCelnIpwnwn16wafszOz/hNZUOFSMs3KkTk/6+QXajMqJ2vjrTafLhNOjcXTxC6S
         Tq7ikEKRNBKrJpertnU7imkVczrKMC/hpIuwU4ex17oWJuCLexwC0kRbat1FJSjr
         fPEdE46mfV+S/R0pXcngbey4veLMJCesU07hX3oBHhq6owoZtns/nukLfPfJ7Rsn
         eamZWISSlF72NfMB5s6ilw==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Sun, 20 Sep 2026 20:15:51 +0900
Subject: [PATCH v11 10/21] KVM: arm64: PMU: Recreate events after PMCR_EL0
 changes
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-hybrid-v11-10-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
References: <20260920-hybrid-v11-0-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260920-hybrid-v11-0-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
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
        Steffen Eiden <seiden@linux.ibm.com>,
        Andrew Jones <andrew.jones@oss.qualcomm.com>,
        Fuad Tabba <fuad.tabba@linux.dev>, Mark Rutland <mark.rutland@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Shannon Zhao <shannon.zhao@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Fuad Tabba <fuad.tabba@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4845;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=ncqwVTRhMLVZJ0R7zoNIvotfazATWustdO6AcQZbKCg=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ9b6A1nbD2+6XGiSMVvgcofTt4mv6hYccT3LvzekQCb4t
 qb3W0nzjlIWBjEuBlkxRZaUot3cGtG1nwoT4ltg5rAygQxh4OIUgInMKmNk2G+/pCIq+bWFV60t
 dwVH1ElrS3+H6V93VL0+nsL7SXbNFUaGZQ57Di/9k/haovnAyep3ultufa1LrnNUjbk338cnryq
 SBwA=
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
index a8449e533070..86a02fd4cfb8 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -591,6 +591,17 @@ void kvm_pmu_request_recreate(struct kvm_vcpu *vcpu)
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
@@ -598,19 +609,18 @@ void kvm_pmu_request_recreate(struct kvm_vcpu *vcpu)
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
index 7dd2cafce247..6786311e9b7d 100644
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
index 2fe73ad50e4e..fca00f7f4c0a 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -58,6 +58,7 @@ bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu);
 bool kvm_pmu_update_run(struct kvm_vcpu *vcpu);
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_request_recreate(struct kvm_vcpu *vcpu);
+void kvm_pmu_apply_pmcr(struct kvm_vcpu *vcpu, u64 old, u64 val, bool force_reload);
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_apply_mdcr(struct kvm_vcpu *vcpu, u64 old, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
@@ -141,6 +142,7 @@ static inline bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu)
 static inline bool kvm_pmu_update_run(struct kvm_vcpu *vcpu) { return false; }
 static inline void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_request_recreate(struct kvm_vcpu *vcpu) {}
+static inline void kvm_pmu_apply_pmcr(struct kvm_vcpu *vcpu, u64 old, u64 val, bool force_reload) {}
 static inline void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_apply_mdcr(struct kvm_vcpu *vcpu, u64 old, u64 val) {}
 static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,

-- 
2.55.0

