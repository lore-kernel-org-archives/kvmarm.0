Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 282BF443C39
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 11:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789386170; cv=none; b=In0b5UvU+k7sFL2mbOj2wFaFm9CHUFtQlUNqo7aOEVK4RJM0CDb75X/0KZt64r1OWnkMqBuooIXhpAWTg6ouxYwJq0dmncxpMnqppuGk2f68RWS9PXYpEd5fNdWU1lp5VWa8dn1H5wTRJliKO1ukNNKdxkGE/EGL1NsWmWb24SE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789386170; c=relaxed/simple;
	bh=mGsOePNADDbpufK4bCa5VbquY5MThz4mUhg8oNaFSoU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=YSZu4MrBSVPfqvyFh4AVgcRHejz7y2gmaQa6wpteGJ+z/5jqkIPOjhsX7m/XU8Eo168NFS8SZp74UG+8ddjmuXicoWUmCLTz0e8iuKVqhPi1md/aiRPzQ6uxKaSN7yp3q61YQG5wrcmIqx2hFmQscm64k/0DX5SwzRhD7h8ihhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=Hs7K+FMu; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="Hs7K+FMu"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 68EBfjsA084060
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 14 Sep 2026 20:41:54 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=5X3EgFSRW7eag/s5qAku4PH/bvlj9nBk6IFerUupNxE=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1789386114; v=1;
        b=Hs7K+FMu4NFGiZujTes1rkHZv+mcuYNQR7POrVLA1xLSbRa69VdyJLuPlnuLCNEn
         I8a4qIeY2qSLgmBnIhB8d87Q57+hu7nGiP2boUnmGgaEAp74uE65VfwjeSzRFEMz
         /eP9muybzAPleVn7K+CU22odvtX/2MYLnZNWeOoVAO/+V0VZ6qMf3ztylzDNzmi1
         hSO1BkFuBtmuAZTyLxrS/Z2KvTT0E3UNAs0C5oXR9SuBbFhmjcY3LU6tnZ1OCaEm
         H3kRDzVAIy+RDSGl4oJL/ZWDGITLkhyCgrD3gTM0ukUQ30GPaXWhCpXmOpV5Ncxc
         syohBTzyWo5mwE9Qpd1nig==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 14 Sep 2026 20:40:47 +0900
Subject: [PATCH v10 08/20] KVM: arm64: PMU: Recreate events after MDCR_EL2
 changes
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-hybrid-v10-8-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
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
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
        Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=4914;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=mGsOePNADDbpufK4bCa5VbquY5MThz4mUhg8oNaFSoU=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ9byuwXmnu82hXd0nNoacKjs+N2bHfEiB3MtFH3d3K7cs
 YhPV33TUcrCIMbFICumyJJStJtbI7r2U2FCfAvMHFYmkCEMXJwCMBGe+wz/Q56F13znvheQsD5o
 4aNsj7XH2wqbprjtP6zW5qolkP9zIsMfvgte5zg/lnw3Dml8tGjjWxnZCdIJDA4Tdk/oP76tapM
 mBwA=
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

MDCR_EL2.HPMN changes which counters are reserved for EL2 and thus which
enable control, event filter, and overflow width apply. HPMD changes EL2
filtering, while HLP changes the overflow width and sample period.

The existing guest MDCR_EL2 handling only requests a PMU reload for
HPME. Reloading enables or disables existing perf events, but does not
rebuild events whose attributes have become stale. Generic userspace
writes through KVM_SET_ONE_REG do not request a reload at all.

Use a common helper for guest and userspace writes. Recreate events
after HPMN, HPMD, or HLP changes. This preserves counter values. Defer
event creation to the vCPU thread instead of an arbitrary ioctl thread.

Use a setter-only accessor so register restore gains these side effects
without changing generic reads or rejecting register values.

Fixes: fe827f916662 ("KVM: arm64: nv: Honor MDCR_EL2.HPME")
Fixes: 8a34979030f6 ("KVM: arm64: nv: Apply EL2 event filtering when in hyp context")
Fixes: 16535d55e91f ("KVM: arm64: nv: Honor MDCR_EL2.HLP")
Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/pmu-emul.c | 14 ++++++++++++++
 arch/arm64/kvm/sys_regs.c | 22 ++++++++++++++--------
 include/kvm/arm_pmu.h     |  2 ++
 3 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 8530cc907b56..953255111779 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -612,6 +612,20 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 	}
 }
 
+void kvm_pmu_apply_mdcr(struct kvm_vcpu *vcpu, u64 old, u64 val)
+{
+	u64 changed = old ^ val;
+
+	/*
+	 * HPMN determines which counters HPMD and HLP apply to. Changes to
+	 * these fields require new perf event filters and sample periods.
+	 */
+	if (changed & (MDCR_EL2_HPMN | MDCR_EL2_HPMD | MDCR_EL2_HLP))
+		kvm_pmu_request_recreate(vcpu);
+	else if (changed & MDCR_EL2_HPME)
+		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+}
+
 static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc)
 {
 	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1a57e07cec9a..bae1b69a5ab9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -3114,17 +3114,22 @@ static bool access_mdcr(struct kvm_vcpu *vcpu,
 	}
 
 	__vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
-
-	/*
-	 * Request a reload of the PMU to enable/disable the counters
-	 * affected by HPME.
-	 */
-	if ((old ^ val) & MDCR_EL2_HPME)
-		kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+	kvm_pmu_apply_mdcr(vcpu, old, val);
 
 	return true;
 }
 
+static int set_mdcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *rd,
+		    u64 val)
+{
+	u64 old = __vcpu_sys_reg(vcpu, MDCR_EL2);
+
+	__vcpu_assign_sys_reg(vcpu, MDCR_EL2, val);
+	kvm_pmu_apply_mdcr(vcpu, old, val);
+
+	return 0;
+}
+
 static bool access_ras(struct kvm_vcpu *vcpu,
 		       struct sys_reg_params *p,
 		       const struct sys_reg_desc *r)
@@ -3836,7 +3841,8 @@ static const struct sys_reg_desc sys_reg_descs[] = {
 	EL2_REG_FILTERED(SCTLR2_EL2, access_vm_reg, reset_val, 0,
 			 sctlr2_el2_visibility),
 	EL2_REG_VNCR(HCR_EL2, reset_hcr, 0),
-	EL2_REG(MDCR_EL2, access_mdcr, reset_mdcr, 0),
+	SYS_REG_USER_FILTER(MDCR_EL2, access_mdcr, reset_mdcr, 0,
+			    NULL, set_mdcr, el2_visibility),
 	EL2_REG(CPTR_EL2, access_rw, reset_val, CPTR_NVHE_EL2_RES1),
 	EL2_REG_VNCR(HSTR_EL2, reset_val, 0),
 	EL2_REG_VNCR_FILT(HFGRTR_EL2, fgt_visibility),
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 65cf9b49a0c0..f12c916c04d5 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -58,6 +58,7 @@ bool kvm_pmu_update_run(struct kvm_vcpu *vcpu);
 void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val);
 void kvm_pmu_request_recreate(struct kvm_vcpu *vcpu);
 void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val);
+void kvm_pmu_apply_mdcr(struct kvm_vcpu *vcpu, u64 old, u64 val);
 void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu, u64 data,
 				    u64 select_idx);
 void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu);
@@ -139,6 +140,7 @@ static inline bool kvm_pmu_update_run(struct kvm_vcpu *vcpu) { return false; }
 static inline void kvm_pmu_software_increment(struct kvm_vcpu *vcpu, u64 val) {}
 static inline void kvm_pmu_request_recreate(struct kvm_vcpu *vcpu) {}
 static inline void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val) {}
+static inline void kvm_pmu_apply_mdcr(struct kvm_vcpu *vcpu, u64 old, u64 val) {}
 static inline void kvm_pmu_set_counter_event_type(struct kvm_vcpu *vcpu,
 						  u64 data, u64 select_idx) {}
 static inline int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu,

-- 
2.55.0

