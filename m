Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4B364499B4
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 11:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789386163; cv=none; b=KqOnkdyx3RBWZCTrYOXHP960djyzxNFY3tGx+2fQcVLpHgwyHO1P2ejI5X60AVDcZbd1/dMer/icjpEmTgEKdfTXzsSsyCTWbYYd5RdMnob7w0amLLOnl95lD6dfbZxb4nNlAYq1rFezarJNoT98DGHIFXi3xT5ZdPUzpbLxg/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789386163; c=relaxed/simple;
	bh=RnIlHEQ78YFuc3wBZZchSy2qrdmbQoQtbF7txqjIHzk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Y0fMuW5I5S2xp7n53ghafsfj8qnzGnu0f5kDevQjiLyawspfKZ73sdHxrNiswsuv/m1lX8+cAc8lD23ci9uwuXLtcrAwgFebLrW9rqzo39dBl6eSYmFrl815s6qmELIbxdkNugQlwAUbrOeKeA2BhSV4a38ZkFHmSoH+hwMFzqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=rqK3sHNs; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="rqK3sHNs"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 68EBfjs9084060
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 14 Sep 2026 20:41:53 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=i8oBDkmopuEvWICyu+it4zT9HqvwhsDfOk7tKzhf8gI=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1789386114; v=1;
        b=rqK3sHNsVr4tnbqUzz+xp6EKGbN1OCtVpUE6ycjbzPLzSTQW1Kr9q5ipc9WZajIu
         pB+4W6BBqzfAR7pdrpzSkkshwfGcz+CJ8CbIEncXPRiKpu7S7hKog/zY4JlJcLes
         abtIjHC81C7ZTadQq8ovnikCwMfgzVqLnm4UhluT5M3WqRiGpfWKOr6gTlk99dv3
         zLuZN79aOacEwLWLjzftjBT8XxxJmuWrbTlg9icw9fOy1uETX4fvLDix8R2mT/WQ
         pB0idm47Nn7kQ8awOWNdRmW2HNOoUWd2dyjA1R1a7HQS8qTE7Uc1hd2kNWXSc/s+
         wn9RLNk1DJ9BS/gxjLuveA==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 14 Sep 2026 20:40:46 +0900
Subject: [PATCH v10 07/20] KVM: arm64: PMU: Recreate events after reset
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-hybrid-v10-7-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=3732;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=RnIlHEQ78YFuc3wBZZchSy2qrdmbQoQtbF7txqjIHzk=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ9byu/lv7s55bTlv+49ZbkKzA7wTuooadrlEPvz/5LZPb
 NsHz/ePO0pZGMS4GGTFFFlSinZza0TXfipMiG+BmcPKBDKEgYtTACayagvD/5I5hg5VXO6zMme+
 1HWOVYu8WCxz7+AZVZetCRkcJiutJjP8sxP5fiR4SZPtS6UjR/h2L33JdGX2lrO8jNJy7GZMYo5
 buAE=
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

kvm_reset_sys_regs() resets PMCR_EL0, PMEVTYPERn_EL0, PMCCFILTR_EL0,
and MDCR_EL2 before requesting a PMU reload. A reload reuses existing
perf events even when their sample periods, event selections, or filters
no longer match the reset system registers.

Add a deferred event-recreation request. It stops existing events on the
vCPU thread before reprogramming counters. Use it during system-register
reset so the next vCPU run rebuilds all backing events from reset state.

Fixes: fe53538069bb ("KVM: arm64: PMU: Reload when resetting")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 arch/arm64/kvm/pmu-emul.c | 15 +++++++++++++++
 arch/arm64/kvm/sys_regs.c |  2 +-
 include/kvm/arm_pmu.h     |  3 +++
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index a5ccb6ae44d5..8530cc907b56 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -571,6 +571,12 @@ void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val)
 	kvm_pmu_counter_increment(vcpu, val, ARMV8_PMUV3_PERFCTR_SW_INCR);
 }
 
+void kvm_pmu_request_recreate(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.pmu.events_need_recreate = true;
+	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+}
+
 /**
  * kvm_pmu_handle_pmcr - handle PMCR register
  * @vcpu: The vcpu pointer
@@ -900,7 +906,16 @@ u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 
 void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
 {
+	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	u64 mask = kvm_pmu_implemented_counter_mask(vcpu);
+	int i;
+
+	if (pmu->events_need_recreate) {
+		for (i = 0; i < KVM_ARMV8_PMU_MAX_COUNTERS; i++)
+			kvm_pmu_stop_counter(kvm_vcpu_idx_to_pmc(vcpu, i));
+
+		pmu->events_need_recreate = false;
+	}
 
 	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, &=, mask);
 	__vcpu_rmw_sys_reg(vcpu, PMINTENSET_EL1, &=, mask);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 42b6705bc21d..1a57e07cec9a 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -5390,7 +5390,7 @@ void kvm_reset_sys_regs(struct kvm_vcpu *vcpu)
 	set_bit(KVM_ARCH_FLAG_ID_REGS_INITIALIZED, &kvm->arch.flags);
 
 	if (kvm_vcpu_has_pmu(vcpu))
-		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+		kvm_pmu_request_recreate(vcpu);
 }
 
 /**
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 6b4a118d17ca..65cf9b49a0c0 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -32,6 +32,7 @@ struct kvm_pmu {
 	struct kvm_pmc pmc[KVM_ARMV8_PMU_MAX_COUNTERS];
 	int irq_num;
 	bool created;
+	bool events_need_recreate;
 };
 
 struct arm_pmu_entry {
@@ -55,6 +56,7 @@ void kvm_pmu_sync_hwstate(struct kvm_vcpu *vcpu);
 bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu);
 bool kvm_pmu_update_run(struct kvm_vcpu *vcpu);
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
+void kvm_pmu_request_recreate(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx);
@@ -135,6 +137,7 @@ static inline bool kvm_pmu_should_notify_user(struct kvm_vcpu *vcpu)
 }
 static inline bool kvm_pmu_update_run(struct kvm_vcpu *vcpu) { return false; }
 static inline void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
+static inline void kvm_pmu_request_recreate(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,
 						  u64 data, u64 select_idx) {}

-- 
2.55.0

