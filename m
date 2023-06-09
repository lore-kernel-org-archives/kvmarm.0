Received: from out-62.mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5012F23403
	for <kvmarm@lists.linux.dev>; Fri,  9 Jun 2023 22:01:19 +0000 (UTC)
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1686348077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8SOi5VCAin6HldWFUktSDwe2OpwbwNaVyrsykxzBvEs=;
	b=aTHf7U4UVHkcKupDh/G/3lfftXXE6rS6ePXByG6JK4viOd9X9YLrH8EoS5moKqbGUF1GQ1
	IAJ9zLJQZzuL1poZJlpGkyry8h1AeOeb7BMk9P0XxD7IesFs0lc41MPpcpOJdgZli6PGO3
	sAA8IpE3Mvm9mVnwe+Y/N03sL2yXgMg=
From: Oliver Upton <oliver.upton@linux.dev>
To: kvmarm@lists.linux.dev
Cc: Marc Zyngier <maz@kernel.org>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Will Deacon <will@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	Darren Hart <darren@os.amperecomputing.com>,
	D Scott Phillips <scott@os.amperecomputing.com>,
	Oliver Upton <oliver.upton@linux.dev>
Subject: [PATCH 2/3] KVM: arm64: Refactor HFGxTR configuration into separate helpers
Date: Fri,  9 Jun 2023 22:01:03 +0000
Message-ID: <20230609220104.1836988-3-oliver.upton@linux.dev>
In-Reply-To: <20230609220104.1836988-1-oliver.upton@linux.dev>
References: <20230609220104.1836988-1-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

A subsequent change will need to flip more trap bits in HFGWTR_EL2. Make
room for this by factoring out the programming of the HFGxTR registers
into helpers and using locals to build the set/clear masks.

Signed-off-by: Oliver Upton <oliver.upton@linux.dev>
---
 arch/arm64/kvm/hyp/include/hyp/switch.h | 60 +++++++++++++++++--------
 1 file changed, 42 insertions(+), 18 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index c41166f1a1dd..e5702c27a8b2 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -70,6 +70,44 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 	}
 }
 
+static inline bool __hfgxtr_traps_required(void)
+{
+	if (cpus_have_final_cap(ARM64_SME))
+		return true;
+
+	return false;
+}
+
+static inline void __activate_traps_hfgxtr(void)
+{
+	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0, tmp;
+
+	if (cpus_have_final_cap(ARM64_SME)) {
+		tmp = HFGxTR_EL2_nSMPRI_EL1_MASK | HFGxTR_EL2_nTPIDR2_EL0_MASK;
+
+		r_clr |= tmp;
+		w_clr |= tmp;
+	}
+
+	sysreg_clear_set_s(SYS_HFGRTR_EL2, r_clr, r_set);
+	sysreg_clear_set_s(SYS_HFGWTR_EL2, w_clr, w_set);
+}
+
+static inline void __deactivate_traps_hfgxtr(void)
+{
+	u64 r_clr = 0, w_clr = 0, r_set = 0, w_set = 0, tmp;
+
+	if (cpus_have_final_cap(ARM64_SME)) {
+		tmp = HFGxTR_EL2_nSMPRI_EL1_MASK | HFGxTR_EL2_nTPIDR2_EL0_MASK;
+
+		r_set |= tmp;
+		w_set |= tmp;
+	}
+
+	sysreg_clear_set_s(SYS_HFGRTR_EL2, r_clr, r_set);
+	sysreg_clear_set_s(SYS_HFGWTR_EL2, w_clr, w_set);
+}
+
 static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 {
 	/* Trap on AArch32 cp15 c15 (impdef sysregs) accesses (EL1 or EL0) */
@@ -89,16 +127,8 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 	vcpu->arch.mdcr_el2_host = read_sysreg(mdcr_el2);
 	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
 
-	if (cpus_have_final_cap(ARM64_SME)) {
-		sysreg_clear_set_s(SYS_HFGRTR_EL2,
-				   HFGxTR_EL2_nSMPRI_EL1_MASK |
-				   HFGxTR_EL2_nTPIDR2_EL0_MASK,
-				   0);
-		sysreg_clear_set_s(SYS_HFGWTR_EL2,
-				   HFGxTR_EL2_nSMPRI_EL1_MASK |
-				   HFGxTR_EL2_nTPIDR2_EL0_MASK,
-				   0);
-	}
+	if (__hfgxtr_traps_required())
+		__activate_traps_hfgxtr();
 }
 
 static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
@@ -109,14 +139,8 @@ static inline void __deactivate_traps_common(struct kvm_vcpu *vcpu)
 	if (kvm_arm_support_pmu_v3())
 		write_sysreg(0, pmuserenr_el0);
 
-	if (cpus_have_final_cap(ARM64_SME)) {
-		sysreg_clear_set_s(SYS_HFGRTR_EL2, 0,
-				   HFGxTR_EL2_nSMPRI_EL1_MASK |
-				   HFGxTR_EL2_nTPIDR2_EL0_MASK);
-		sysreg_clear_set_s(SYS_HFGWTR_EL2, 0,
-				   HFGxTR_EL2_nSMPRI_EL1_MASK |
-				   HFGxTR_EL2_nTPIDR2_EL0_MASK);
-	}
+	if (__hfgxtr_traps_required())
+		__deactivate_traps_hfgxtr();
 }
 
 static inline void ___activate_traps(struct kvm_vcpu *vcpu)
-- 
2.41.0.162.gfafddb0af9-goog

