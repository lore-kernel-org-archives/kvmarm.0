Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.64
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793088723;
	b=zVMz6ieLLLjtrTgwknTVxywKJwe9xKb298yGGqz6tIQWw/Cu7U2+qXf8KhoBGatXuWwT
	 DexCefqHl5c5Z09hXdvwj0NxdKHSktTeXtLEbFKfDIuJrngq00qbdLadeVdTVhtkTSEP2
	 3nEJhY0QxZW0xBjygOr7mr8y787fmr6HtiVYcGEH6JRHJGvM/FWYCePDoN5lBLl0QzKti
	 t8D2yyYjOkySG8aVBXnLUcwZ+WqpABvINGVHNwaw0F/v7miT0ROBulI6M2nAM0FIZCD4Z
	 q4dK8aZOoFc4MphB9fPqkuW6gwlLtgxoU/3V6FEyxen1+mNthPxTp5Vf443K0TCdwVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793088723;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=Uyn+E9hPgBq3vgE8nqzAGJ7D8LXdWFW6vaCw5N5eMTY=;
	b=z030cT7OCkro/wLyVqaKu9SAmzOb4y73n1qlI1hRaTKkrHx/YWw01ojyFSH3LOaXMgP6
	 tmHwaVIMwyOPyvH3KsFCIuRbgIHzTexzkZOV/LXPOS69savO7tsI3/DyrFrqNfbhPZUpC
	 JvURjPFo5+Gz+HgYp0/3QkkQWVLgIvoUBahWRtXo+IYShpvddlDvmHWUds0GsuetAt1wL
	 2KdCAMhD+JHczvllmrgw+y4Kwl+afDaesneRDhdUTvo/6es2HqGv0MTxZJ3degErf7kyX
	 lBUoLOTQSReukHFewIwLJ9oe518IlTYcuUfmGW1kePCvtxqf2B6qm7MG+RyIWt7InDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=c8XimVtV;
	arc=none smtp.remote-ip=95.215.58.64
Received: from mta1.migadu.com (out-64.mta1.migadu.com [95.215.58.64])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DEA606A325
	for <kvmarm@lists.linux.dev>; Tue, 27 Oct 2026 08:12:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 03DEA606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=c8XimVtV
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=hqZxpxJ0C4wEalO5Og1g3G+zJaFBGEKypaN+rWrhA5I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793088721; v=1; x=1793693521;
 b=c8XimVtV3h/Ud99ag7hplkIn8hKtih9p62StJv1H74yejjdVXsNpPqL+9hX/jHNyvjwI2Rip
 3bTUCMAr7CZH7pzLVnEN4tno9e3WrbZN5mc6LaTSE18fRNKc7igtjmzQu+Fz+WYiRlP1GbY749I
 CN41XGeaIABI9/PgIEeknwyw=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id b50314872c48fa54;
	Tue, 27 Oct 2026 08:12:00 +0000
X-Mizu-Trace-ID: b50314872c48fa54
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	kernel-team@android.com,
	linux-kernel@vger.kernel.org,
	Oculytic <oculytic@gmail.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH 3/3] KVM: arm64: Disable host PMU counters for protected guests
Date: Tue, 27 Oct 2026 08:11:47 +0000
Message-ID: <20261027081147.498183-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261027081147.498183-1-fuad.tabba@linux.dev>
References: <20261027081147.498183-1-fuad.tabba@linux.dev>
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

A protected guest has no PMU, and EL2 clears MDCR_EL2.HPME for it.
However, HPME has no effect, since __pkvm_vcpu_load() sets HPMN to cover
every event counter, and HPME never covers the cycle or instruction
counter. The counters the host has enabled therefore keep counting the
guest.

Stop them in the world switch while a protected guest runs, reading
PMCNTENSET_EL0 rather than trusting the host-controlled events mask.
Gate this on a new per-CPU HAS_PMUV3 flag, since system_supports_pmuv3()
is false when the CPUs implement different PMU versions.

Side channels are outside pKVM's threat model, so this is hardening
rather than a fix.

Reported-by: Oculytic <oculytic@gmail.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_host.h |  1 +
 arch/arm64/kvm/debug.c            |  4 +++-
 arch/arm64/kvm/hyp/nvhe/switch.c  | 24 ++++++++++++++++++++++++
 3 files changed, 28 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1c6632216e327..7ecb55e5018eb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -834,6 +834,7 @@ struct kvm_host_data {
 #define KVM_HOST_DATA_FLAG_VCPU_IN_HYP_CONTEXT		4
 #define KVM_HOST_DATA_FLAG_L1_VNCR_MAPPED		5
 #define KVM_HOST_DATA_FLAG_HAS_BRBE			6
+#define KVM_HOST_DATA_FLAG_HAS_PMUV3			7
 	unsigned long flags;
 
 	struct kvm_cpu_context host_ctxt;
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index f4d7b12045e8f..3c74b076b5278 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -79,9 +79,11 @@ void kvm_init_host_debug_data(void)
 	unsigned int pmuver = cpuid_feature_extract_unsigned_field(dfr0,
 								   ID_AA64DFR0_EL1_PMUVer_SHIFT);
 
-	if (pmuv3_implemented(pmuver))
+	if (pmuv3_implemented(pmuver)) {
 		*host_data_ptr(nr_event_counters) = FIELD_GET(ARMV8_PMU_PMCR_N,
 							      read_sysreg(pmcr_el0));
+		host_data_set_flag(HAS_PMUV3);
+	}
 
 	*host_data_ptr(debug_brps) = SYS_FIELD_GET(ID_AA64DFR0_EL1, BRPs, dfr0);
 	*host_data_ptr(debug_wrps) = SYS_FIELD_GET(ID_AA64DFR0_EL1, WRPs, dfr0);
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 91e1edf40bcd2..79a6277de4fc1 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -175,6 +175,26 @@ static void __pmu_switch_to_host(struct kvm_vcpu *vcpu)
 #define __pmu_switch_to_host(v)		do {} while (0)
 #endif
 
+static u64 __pmu_stop_host_counters(struct kvm_vcpu *vcpu)
+{
+	u64 pmcnten;
+
+	if (!vcpu_is_protected(vcpu) || !host_data_test_flag(HAS_PMUV3))
+		return 0;
+
+	pmcnten = read_sysreg(pmcntenset_el0);
+	if (pmcnten)
+		write_sysreg(pmcnten, pmcntenclr_el0);
+
+	return pmcnten;
+}
+
+static void __pmu_restore_host_counters(u64 pmcnten)
+{
+	if (pmcnten)
+		write_sysreg(pmcnten, pmcntenset_el0);
+}
+
 /*
  * Handler for protected VM MSR, MRS or System instruction execution in AArch64.
  *
@@ -282,6 +302,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	struct kvm_cpu_context *guest_ctxt;
 	struct kvm_s2_mmu *mmu;
 	bool pmu_switch_needed;
+	u64 host_pmcnten;
 	u64 exit_code;
 
 	/*
@@ -300,6 +321,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	guest_ctxt = &vcpu->arch.ctxt;
 
 	pmu_switch_needed = __pmu_switch_to_guest(vcpu);
+	host_pmcnten = __pmu_stop_host_counters(vcpu);
 
 	__sysreg_save_state_nvhe(host_ctxt);
 	/*
@@ -384,6 +406,8 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	if (pmu_switch_needed)
 		__pmu_switch_to_host(vcpu);
 
+	__pmu_restore_host_counters(host_pmcnten);
+
 	/* Returning to host will clear PSR.I, remask PMR if needed */
 	if (system_uses_irq_prio_masking())
 		gic_write_pmr(GIC_PRIO_IRQOFF);
-- 
2.47.3

