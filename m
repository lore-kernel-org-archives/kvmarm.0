Received: from mta1.migadu.com (out-147.mta1.migadu.com [95.215.58.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6477A54DAE2
	for <kvmarm@lists.linux.dev>; Tue,  8 Sep 2026 14:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788879427; cv=none; b=SooEAPF/wlXOg7huOBXYPhNJ4Imf4hIaA3CKJbvrW+Q1NVMZN6svQdaeerr/+6lUNW8wdfU9HfZzc4bF9sLZrObYaXMDTo6Sm57k+GiNeGo16xEjK/dIOxQdBb8r1KaHdFR+Wjuj7fHXRGxjjf/oXMeILq4QI4Q0zcQ6LLiwzoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788879427; c=relaxed/simple;
	bh=59BreB6WDZ8NymSddyrIoizrxnFpCUS1IZh4cVCjkzw=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=juqLqvtVeMcuFp2fd7TgIzxnBOPOJQ9wtlMsyrv5YEMOO3QioEcSXQfvvBYtUou5A3fxeFH7e8u7R1zASUVxiQW01/s4QHLxZyyyKIluFfSjVX4GM3BQrJvOobrpyZAnrFikfd9sfbhqN6JKP82bSix8+x6C+/IqH3Hv+iofvJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=iTiewRnf; arc=none smtp.client-ip=95.215.58.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="iTiewRnf"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=59BreB6WDZ8NymSddyrIoizrxnFpCUS1IZh4cVCjkzw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788879412; v=1; x=1789484212;
 b=iTiewRnfs6WhEPl9L4Ikt5xIDNDE4RYqzzb8xTatOmehzVb1mzeCo6YsfgP0Vp4xk5la3A3Q
 5IB6H7NCWu2NN9hztdn91IPx57MfbSTX2JmhP+7kB6u4D79ou4zGNHoxU7jXhuGBZVMNG6MfXrl
 gQoOyU0vPxel1luFvzUhFWgs=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id f618ec6996b6b0c2;
	Tue, 08 Sep 2026 14:56:52 +0000
X-Mizu-Trace-ID: f618ec6996b6b0c2
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Cc: James Morse <james.morse@arm.com>,
	Ben Horgan <ben.horgan@arm.com>,
	Xi Ruoyao <xry111@xry111.site>,
	Mark Rutland <mark.rutland@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Gavin Shan <gshan@redhat.com>,
	Yuan Yao <yaoyuan@linux.alibaba.com>,
	Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: Trap guest MPAM accesses whenever MPAM is implemented
Date: Tue,  8 Sep 2026 15:56:51 +0100
Message-Id: <20260908145651.2828597-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

finalise_el2_state() clears the EL2 MPAM traps whenever the ID
registers advertise MPAM, while KVM sets them only under ARM64_MPAM,
which also requires MPAMEN. Without EL3 nothing sets that enable, so a
guest reaches the MPAM registers while ID_AA64PFR0_EL1.MPAM reads 0
for it.

Gate the traps on the ID registers alone: MPAMEN isn't a term in any
MPAM accessor, so they take effect without it. The cap tests the
sanitised ID fields, which never exceed a CPU's own, so it's set only
where finalise_el2_state already wrote MPAM2_EL2. MPAM3_EL3.TRAPLOWER
is clear there, and arm64.nompam turns the cap off too.

Fixes: 23b33d1e168c ("arm64: head.S: Initialise MPAM EL2 registers and disable traps")
Reviewed-by: Yuan Yao <yaoyuan@linux.alibaba.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    Changes since v1:
     - Commit message only. The code is unchanged, so Yuan Yao's
       Reviewed-by is carried.
     - Fixes: names the commit that cleared the traps, rather than the
       one that added KVM's trapping.
     - Says why the sanitised ID fields are the safe gate: the cap is set
       only where finalise_el2_state already wrote MPAM2_EL2.
    
    Not covered, and answered on the v1 thread: a machine whose CPUs
    differ on MPAM, raised by Ben and by sashiko.
    
    v1: https://lore.kernel.org/all/20260903160819.831518-1-fuad.tabba@linux.dev/

 arch/arm64/include/asm/cpufeature.h     |  5 +++++
 arch/arm64/kernel/cpufeature.c          | 13 +++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  4 ++--
 arch/arm64/tools/cpucaps                |  1 +
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
index 7404a6e83a930..8863ae99596bc 100644
--- a/arch/arm64/include/asm/cpufeature.h
+++ b/arch/arm64/include/asm/cpufeature.h
@@ -873,6 +873,11 @@ static __always_inline bool system_supports_mpam_hcr(void)
 	return alternative_has_cap_unlikely(ARM64_MPAM_HCR);
 }
 
+static __always_inline bool system_supports_mpam_sysregs(void)
+{
+	return alternative_has_cap_unlikely(ARM64_MPAM_SYSREGS);
+}
+
 static inline bool system_supports_pmuv3(void)
 {
 	return cpus_have_final_cap(ARM64_HAS_PMUV3);
diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
index 17b83a2518a8f..36a27692e5cf7 100644
--- a/arch/arm64/kernel/cpufeature.c
+++ b/arch/arm64/kernel/cpufeature.c
@@ -2501,6 +2501,13 @@ test_has_mpam(const struct arm64_cpu_capabilities *entry, int scope)
 	return (read_sysreg_s(SYS_MPAM1_EL1) & MPAM1_EL1_MPAMEN);
 }
 
+static bool
+test_has_mpam_sysregs(const struct arm64_cpu_capabilities *entry, int __unused)
+{
+	/* The registers exist whether or not firmware enabled MPAM. */
+	return detect_ftr_has_mpam();
+}
+
 static void
 cpu_enable_mpam(const struct arm64_cpu_capabilities *entry)
 {
@@ -3116,6 +3123,12 @@ static const struct arm64_cpu_capabilities arm64_features[] = {
 		.matches = test_has_mpam,
 		.cpu_enable = cpu_enable_mpam,
 	},
+	{
+		.desc = "Memory Partitioning And Monitoring system registers",
+		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
+		.capability = ARM64_MPAM_SYSREGS,
+		.matches = test_has_mpam_sysregs,
+	},
 	{
 		.desc = "Memory Partitioning And Monitoring Virtualisation",
 		.type = ARM64_CPUCAP_SYSTEM_FEATURE,
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 1ce7130e25490..8941335724f6b 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -298,7 +298,7 @@ static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
 	u64 clr = MPAM2_EL2_EnMPAMSM;
 	u64 set = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
 
-	if (!system_supports_mpam())
+	if (!system_supports_mpam_sysregs())
 		return;
 
 	/* trap guest access to MPAMIDR_EL1 */
@@ -317,7 +317,7 @@ static inline void __deactivate_traps_mpam(void)
 	u64 clr = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1 | MPAM2_EL2_TIDR;
 	u64 set = MPAM2_EL2_EnMPAMSM;
 
-	if (!system_supports_mpam())
+	if (!system_supports_mpam_sysregs())
 		return;
 
 	sysreg_clear_set_s(SYS_MPAM2_EL2, clr, set);
diff --git a/arch/arm64/tools/cpucaps b/arch/arm64/tools/cpucaps
index 2775ba3359cfe..aa5be51385f68 100644
--- a/arch/arm64/tools/cpucaps
+++ b/arch/arm64/tools/cpucaps
@@ -78,6 +78,7 @@ KVM_PROTECTED_MODE
 MISMATCHED_CACHE_TYPE
 MPAM
 MPAM_HCR
+MPAM_SYSREGS
 MTE
 MTE_ASYMM
 MTE_FAR
-- 
2.39.5

