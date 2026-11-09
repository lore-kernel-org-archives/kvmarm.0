Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.191
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794213149;
	b=ZK4Ke0Be7WtFay6bs2LTlWjONeThYR7xOwdyNHR/slx9M1osnnNwGnsbOSOSlLqu6oTp
	 sdBNRxa9JedECK7Qt2FLiYPBx82ObekwcI4qGnizNu4gR8lgz6KCfkrZpduFZwZk0kwwo
	 In9ozurt1JUd5e2F9Dh0ZsRjg0dMQ0KXuI1KcFaVZ5+pnXe6WbQlcy7VidtX5lj+b65Dd
	 JlV1tTQJYyMxMUoOa2NsUKp8bC33w/qcTchQlCMTqB0RRfzCJzy2uPSbETYfPyQsEnF7b
	 FPytEEZQ8sOfNIRj0B8ysy2d1gEuGMGwHCRDobqgII77DjCs5QoWq9C0fQ10O4rLv4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794213149;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=hftCpCAdlJ74ejU7FOFHBms3FRju+VPXbTEzSLCodYg=;
	b=glaqBnkFFT8v/Z/kwgHD0C9WDMZwo0de5r2SXbdGAz1Uz0AlmR3ask/jvBq06MsAPZFF
	 e/NET/1B58eSnvGRTbdGABc8UU6+a3yuwrT06aE/AOAfxSMe4hKczjh4IMp9O+bxVamU5
	 FoGkFtod0/+WLrCg5hzu0dh+USNlXpANdmqGL5D+B0mKiO4BEcqWFOOEiu/hpdKntZcHI
	 LjJkD8xgJQm/fEMbpU8jLEZ0l+Mj8XggPLn1Qb/rayvuwtBGRVtBaG8OvtfURSPvPnMFc
	 yYQvO6/jVzIjUypMudKmokKp4l1wLcULsNovOQFZtBMaBed9XaUXs2pAi19zkTlaSCQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jHloTWne;
	arc=none smtp.remote-ip=95.215.58.191
Received: from mta1.migadu.com (out-191.mta1.migadu.com [95.215.58.191])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFB01606D804
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:32:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CFB01606D804
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=jHloTWne
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=QsSbmCD+3/uBmYWuVNria8OBeV9bpscEqdiAWZ9SMbk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794213147; v=1; x=1794817947;
 b=jHloTWneoYNsBuPXagmsLZ/TU+l7ejcVfdHJQrCjT3p5B4sxX2k5vqaLwb0gv62abilMhoGS
 lRBkT/6S9mlpU9oG1SwmmSGlzTFcAW+6MXdvOPH3bIP/4gAQNsWrIaKkymMzo+idKD1Da6YAAWa
 LgoEA3C8gGxW2VyXcP3hWy1Q=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id e594ab08fa32c2ea;
	Mon, 09 Nov 2026 08:32:27 +0000
X-Mizu-Trace-ID: e594ab08fa32c2ea
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 07/16] KVM: arm64: Compute a protected vCPU's fine-grained traps at EL2
Date: Mon,  9 Nov 2026 08:31:56 +0000
Message-ID: <20261109083205.806619-8-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261109083205.806619-1-fuad.tabba@linux.dev>
References: <20261109083205.806619-1-fuad.tabba@linux.dev>
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

pKVM sets a protected vCPU's HCR_EL2, MDCR_EL2 and HCRX_EL2 at EL2 from
the VM's ID registers, but never computes its fine-grained traps, which
stay 0. That traps every register with a negative-polarity trap bit, so
a feature such as S1PIE can't be advertised to a protected VM: EL2
would inject an UNDEF for the guest's accesses to PIR_EL1.

Link config.c into the nVHE hyp and compute the VM's FGU masks and the
vCPU's fine-grained traps there, under vm_table_lock, once the ID
registers are set. The init-time check of the feature maps stays out of
the hyp, since it prints and the host runs it anyway.

A protected vCPU then traps the registers of the features it doesn't
support, as a non-protected vCPU does. Its TCR_EL1 writes also get the
AmpereOne AC03_CPU_38 masking again, which protected vCPUs lost when the
erratum's trap moved into the per-vCPU fine-grained traps.

Fixes: fb10ddf35c1cc ("KVM: arm64: Compute per-vCPU FGTs at vcpu_load()")
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/kvm/config.c          | 12 +++++++-----
 arch/arm64/kvm/hyp/nvhe/Makefile |  1 +
 arch/arm64/kvm/hyp/nvhe/pkvm.c   |  2 ++
 3 files changed, 10 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/kvm/config.c b/arch/arm64/kvm/config.c
index c65cf1dd27330..27ee8188fd76d 100644
--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -1395,6 +1395,12 @@ static const struct reg_bits_to_feat_map ich_hfgitr_feat_map[] = {
 static const DECLARE_FEAT_MAP_FGT(ich_hfgitr_desc, ich_hfgitr_masks,
 				  ich_hfgitr_feat_map, FEAT_GCIE);
 
+static u64 reg_feat_map_bits(const struct reg_bits_to_feat_map *map)
+{
+	return map->flags & MASKS_POINTER ? (map->masks->mask | map->masks->nmask) : map->bits;
+}
+
+#ifndef __KVM_NVHE_HYPERVISOR__
 static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
 				  int map_size, u64 resx, const char *str)
 {
@@ -1414,11 +1420,6 @@ static void __init check_feat_map(const struct reg_bits_to_feat_map *map,
 			str, mask ^ ~resx);
 }
 
-static u64 reg_feat_map_bits(const struct reg_bits_to_feat_map *map)
-{
-	return map->flags & MASKS_POINTER ? (map->masks->mask | map->masks->nmask) : map->bits;
-}
-
 static void __init check_reg_desc(const struct reg_feat_map_desc *r)
 {
 	check_feat_map(r->bit_feat_map, r->bit_feat_map_sz,
@@ -1451,6 +1452,7 @@ void __init check_feature_map(void)
 	check_reg_desc(&ich_hfgwtr_desc);
 	check_reg_desc(&ich_hfgitr_desc);
 }
+#endif
 
 static const struct reg_feat_map_desc *idreg_feat_maps[] = {
 	&id_aa64mmfr3_el1_desc,
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 56a7e2c05f73a..06d7d8618d89f 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -27,6 +27,7 @@ hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
 	 ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o
+hyp-obj-y += ../../config.o
 hyp-obj-y += ../../../kernel/smccc-call.o
 hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
 hyp-obj-$(CONFIG_NVHE_EL2_TRACING) += clock.o trace.o events.o
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index fba8dfe6389d6..465d963d6ff57 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -206,6 +206,8 @@ static int pkvm_vcpu_init_traps(struct pkvm_hyp_vcpu *hyp_vcpu)
 	pvm_init_traps_hcr(vcpu);
 	pvm_init_traps_mdcr(vcpu);
 	vcpu_set_hcrx(vcpu);
+	kvm_init_fgu(vcpu->kvm);
+	kvm_vcpu_load_fgt(vcpu);
 
 	return 0;
 }
-- 
2.47.3

