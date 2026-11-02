Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.99
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793613425;
	b=QlpNMXlpP65lv3jkqrjrm1oXZ3JdFJM3HRxB5md13EcgeMHK4XWy6GBIUbdck6zg3wRv
	 ZXMJtaAO2FWvAHrq8kCxX0yB02IIiZQL8P8aJnVZZLqG5bYbjZv36VhGId6vXuaT+/03X
	 WpxgtRA03L03+zJQYku6/XXFsBbjLmU9V3OsF/hmVE1DptcktHT/vc5JWBobySecNs54v
	 BWCbplUquUgLl7pHVUdAYiLaNoEnXuVswneU5Xrz7LAcdcYF72Oxpk2pu8kaj4I46t1QJ
	 PwNbyP7CwCbRjBJbolf10wy8VuZqWJJscnXlx1MSKMlm1mBtb3/6LBkooxpy57Xmm9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793613425;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=NF4sUbvPyij751VvJLGiH1sFVHF1zynFqu0g0nQ5mO8=;
	b=KB6lhlcNKJGdSAP8WCg0XgkS1TL433eQu34H2qrY4bpSYhNGz0GsLxYjoWdUEu2y03sZ
	 d5+2krMuNKBtoY4wHwB6xUsCljH7KPyCOCfsjGR/Brq9zaP+JYBNgbSwGaABG8gfpTjsM
	 XW9zOGhg8a4bN4TlrFwbJqcWOu3EJSoBMlnuJ/YUclc3lblH4//DXZFD5R2eNrylfAI2F
	 mady6vywo7Ikj2GMLuZoeAQD1oFxwzJQuyB3tsUMwGWinaZEQL8IAbYw/pGRJ5ButGnDc
	 U6TRxwbRslGDX35VhgJ48lmAVmk4tinSBUFshtDLmKz5av9MQ3UR0PwfrnHQ+xDrQ2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QwDMTVXy;
	arc=none smtp.remote-ip=95.215.58.99
Received: from mta1.migadu.com (out-99.mta1.migadu.com [95.215.58.99])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17414606A324
	for <kvmarm@lists.linux.dev>; Mon,  2 Nov 2026 09:57:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 17414606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QwDMTVXy
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=AHRF3WdW4TVnGF5J3qplS9mbVl+JWJar5CHhjFr/pmc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793613422; v=1; x=1794218222;
 b=QwDMTVXyG4+edckaGs8PJEvZ4txfbLY/qFE+oWo3YQaTIg6B2AzD91ixYwZMsPGj8qKFldYu
 lQYltrp81oMhLR2ED1H44Pp+m4RPU1fl80g+TVTQYBKVMyQ3makPFhQzPrgRtGM+KETUWy1fo7w
 dD/5aJ1ZtrzdDn6fM+T1RI4o=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 484bc338bd20a5e5;
	Mon, 02 Nov 2026 09:57:01 +0000
X-Mizu-Trace-ID: 484bc338bd20a5e5
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
Subject: [PATCH v5] KVM: arm64: Trap guest MPAM accesses whenever MPAM is implemented
Date: Mon,  2 Nov 2026 09:56:56 +0000
Message-ID: <20261102095656.2948964-1-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

finalise_el2_state() clears the EL2 MPAM traps on every CPU whose ID
registers advertise MPAM once the arm64.nompam override is applied.
KVM sets them again on guest entry only when ARM64_MPAM is set, a
capability that also requires MPAM1_EL1.MPAMEN. Without EL3, only
MPAM2_EL2.MPAMEN is writable, and the kernel never sets it, so
ARM64_MPAM stays clear and so do the traps. A guest can then access
MPAM0_EL1, MPAM1_EL1, MPAMSM_EL1 and MPAMIDR_EL1 while its
ID_AA64PFR0_EL1.MPAM reads 0.

Record two per-CPU flags at KVM's CPU init: whether MPAM is
implemented as finalise_el2_state() tests it, and whether
MPAMIDR_EL1.HAS_HCR is set (MPAMHCR_EL2 is UNDEFINED without it).
Read ID_AA64PFR0_EL1, ID_AA64PFR1_EL1 and MPAMIDR_EL1 from cpu_data,
which holds them with the overrides applied since commit 342e62ded77c6
("arm64: cpufeature: Read MPAMIDR_EL1 in __cpuinfo_store_cpu()"). Set
the traps from those flags. MPAMEN isn't part of any MPAM trap
condition, so the traps take effect whether or not it is set.

Fixes: 31ff96c38ea3 ("KVM: arm64: Fix missing traps of guest accesses to the MPAM registers")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---

Notes:
    Changes since v4:
     - Take ID_AA64PFR0_EL1, ID_AA64PFR1_EL1 and MPAMIDR_EL1 from cpu_data
       (was __read_sysreg_by_encoding() and read_sysreg_s()).
     - Commit message tightened, and the TIDR comment no longer
       rewritten.
     - Ben's Reviewed-by dropped, since the probe changed.
     - Rebased on 7.4-rc1.
    
    Based on Linux 7.4-rc1 (6628e7d4c6b25).
    
    v4: https://lore.kernel.org/all/20260924165329.1684155-1-fuad.tabba@linux.dev/
    v3: https://lore.kernel.org/all/20260911104715.307500-1-fuad.tabba@linux.dev/
    v2: https://lore.kernel.org/all/20260908145651.2828597-1-fuad.tabba@linux.dev/
    v1: https://lore.kernel.org/all/20260903160819.831518-1-fuad.tabba@linux.dev/

 arch/arm64/include/asm/kvm_host.h       |  2 ++
 arch/arm64/kvm/arm.c                    | 12 ++++++++++++
 arch/arm64/kvm/hyp/include/hyp/switch.h |  8 ++++----
 3 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 97332ffcb1300..d6b9538cbec36 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -839,6 +839,8 @@ struct kvm_host_data {
 #define KVM_HOST_DATA_FLAG_VCPU_IN_HYP_CONTEXT		4
 #define KVM_HOST_DATA_FLAG_L1_VNCR_MAPPED		5
 #define KVM_HOST_DATA_FLAG_HAS_BRBE			6
+#define KVM_HOST_DATA_FLAG_HAS_MPAM			7
+#define KVM_HOST_DATA_FLAG_HAS_MPAM_HCR			8
 	unsigned long flags;
 
 	struct kvm_cpu_context host_ctxt;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 157bf4b812020..5bab4833c9d33 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -32,6 +32,7 @@
 #include <asm/mman.h>
 #include <asm/tlbflush.h>
 #include <asm/cacheflush.h>
+#include <asm/cpu.h>
 #include <asm/cpufeature.h>
 #include <asm/virt.h>
 #include <asm/kvm_arm.h>
@@ -2496,9 +2497,20 @@ static void cpu_set_hyp_vector(void)
 
 static void cpu_hyp_init_context(void)
 {
+	struct cpuinfo_arm64 *info = this_cpu_ptr(&cpu_data);
+	u64 pfr0 = info->reg_id_aa64pfr0;
+	u64 pfr1 = info->reg_id_aa64pfr1;
+
 	kvm_init_host_cpu_context(host_data_ptr(host_ctxt));
 	kvm_init_host_debug_data();
 
+	/* cpu_data has the overrides applied, as finalise_el2_state() does. */
+	if (id_aa64pfr0_mpam(pfr0) || id_aa64pfr1_mpamfrac(pfr1)) {
+		host_data_set_flag(HAS_MPAM);
+		if (info->reg_mpamidr & MPAMIDR_EL1_HAS_HCR)
+			host_data_set_flag(HAS_MPAM_HCR);
+	}
+
 	if (!is_kernel_in_hyp_mode())
 		cpu_init_hyp_mode();
 }
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e0c55644224cb..f487d3a93fe27 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -298,11 +298,11 @@ static inline void  __activate_traps_mpam(struct kvm_vcpu *vcpu)
 	u64 clr = MPAM2_EL2_EnMPAMSM;
 	u64 set = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1;
 
-	if (!system_supports_mpam())
+	if (!host_data_test_flag(HAS_MPAM))
 		return;
 
 	/* trap guest access to MPAMIDR_EL1 */
-	if (system_supports_mpam_hcr()) {
+	if (host_data_test_flag(HAS_MPAM_HCR)) {
 		write_sysreg_s(MPAMHCR_EL2_TRAP_MPAMIDR_EL1, SYS_MPAMHCR_EL2);
 	} else {
 		/* From v1.1 TIDR can trap MPAMIDR, set it unconditionally */
@@ -317,12 +317,12 @@ static inline void __deactivate_traps_mpam(void)
 	u64 clr = MPAM2_EL2_TRAPMPAM0EL1 | MPAM2_EL2_TRAPMPAM1EL1 | MPAM2_EL2_TIDR;
 	u64 set = MPAM2_EL2_EnMPAMSM;
 
-	if (!system_supports_mpam())
+	if (!host_data_test_flag(HAS_MPAM))
 		return;
 
 	sysreg_clear_set_s(SYS_MPAM2_EL2, clr, set);
 
-	if (system_supports_mpam_hcr())
+	if (host_data_test_flag(HAS_MPAM_HCR))
 		write_sysreg_s(MPAMHCR_HOST_FLAGS, SYS_MPAMHCR_EL2);
 }
 

base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
-- 
2.47.3

