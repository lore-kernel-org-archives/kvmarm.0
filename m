Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.144
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621224;
	b=p8yF4A2YxvGxLyUH2+Z3o/zrmWQ+8mTt0eOjfjhOrUT2bZpO/UGHkmGAMGoako5styEC
	 HBgYUPQxXE68+owMWGpeULOfeDQi4FfIIlprCEMsu96jsqZw/OlunTD7sw24e8Ks3BShd
	 iABveNOvhJgxhSrMkQXZTGruip6g7Ro+Ma+YfLQKq1PLhsZYTJPkSRSZYqi1qqau8PsNA
	 1OISMAq6G1fDI5Sfsuuf7ka3C1/HDyLVL6AFK7Nu8hhHNvjOZYuUomeYSPryA9qbO7A9c
	 Zg4pho6pDZrdLFjonxFgi00T28V6krCVfOWHpC4hiCC6XerLIPaNbS05Fnj6jnS+kbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621224;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=qGdCpnc7tSNkp+/hq+v+wVlfJc/jxdnMsSqXuvQBh+I=;
	b=h1bfxHI5Z8w0L7Vf57cLHB8MWVAwKbIA6MaATtXFUwRRlNolcP8ZjbMbKomHbHO/v0By
	 SwTI2ge93ezhxeL6qPViSAaPlrKANWk0pxi+lZ+CSc1xOc9i+8tQrNSdadPW03QebjUCd
	 SVJuGbUPtQL0ePi6SipwyZSD76aTTbPez8bJNX34yDKYezvy4yZWdexpmOD7mnWFgHjUl
	 HpwkXl7lWbK8frg7UwBJR0yc1xF4/7no+OgbAlictE5BJfqyoKJeSf2UGEM+11bGseXYq
	 WxJMxa6T1+0cbpAY9f4M1Bz1WvHY64bPiYzWtIXPQNOuGIhGWjJk9Uk4CWW5mrnxilw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Oa7ap0at;
	arc=none smtp.remote-ip=95.215.58.144
Received: from mta1.migadu.com (out-144.mta1.migadu.com [95.215.58.144])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D868607DEB8
	for <kvmarm@lists.linux.dev>; Wed, 25 Nov 2026 15:40:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0D868607DEB8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Oa7ap0at
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=lb8BBu6vkMdX5G7iUnn28ZdhIQyxfI2a7cuVlYmS8Uk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795621222; v=1; x=1796226022;
 b=Oa7ap0atxAk/qxJHA+K4rOGaKriUNW8N0gt3k1Sq83bUIu3jQkWe5Anb9AmHJAmqQmEmURJM
 90t7QPOophCmahaguutXTGHKGV2IJXr4jmk2P2TxKvO1z082fcw2et1OBQJEyufbRWDwUTxMx/r
 M4lOBWJV2XYN1AbzFZPodAUM=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id aac5ae651e0d1d96;
	Wed, 25 Nov 2026 15:40:21 +0000
X-Mizu-Trace-ID: aac5ae651e0d1d96
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
Subject: [PATCH v2 12/20] KVM: arm64: Advertise TCR2, SCTLR2, S1PIE and S1POE to protected VMs
Date: Wed, 25 Nov 2026 15:39:03 +0000
Message-ID: <20261125153911.106793-13-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261125153911.106793-1-fuad.tabba@linux.dev>
References: <20261125153911.106793-1-fuad.tabba@linux.dev>
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

Advertise FEAT_TCR2, FEAT_SCTLR2, FEAT_S1PIE and FEAT_S1POE to
protected VMs, with S1POE only when the kernel supports POE, as EL2
doesn't switch the POE registers otherwise. With the fields set,
vcpu_set_hcrx() sets HCRX_EL2.{TCR2En,SCTLR2En} for them, and since
the previous patch their PIE and POE registers don't trap.

Reset the new registers as KVM does for a non-protected vCPU.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_hyp.h   |  1 +
 arch/arm64/kvm/arm.c               |  1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 24 +++++++++++++++++++++++-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 920c1d8d45b1a..ab22b395d0908 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -151,6 +151,7 @@ extern u64 kvm_nvhe_sym(id_aa64isar2_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val);
+extern u64 kvm_nvhe_sym(id_aa64mmfr3_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64smfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64dfr0_el1_sys_val);
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 3b4bc646d894a..71afc5a5c9346 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2840,6 +2840,7 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 	kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
+	kvm_nvhe_sym(id_aa64mmfr3_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR3_EL1);
 	kvm_nvhe_sym(id_aa64smfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64SMFR0_EL1);
 	kvm_nvhe_sym(id_aa64dfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
 	kvm_nvhe_sym(__icache_flags) = __icache_flags;
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 0a536b237a7c9..4f13b100007fa 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -30,6 +30,7 @@ u64 id_aa64isar2_el1_sys_val;
 u64 id_aa64mmfr0_el1_sys_val;
 u64 id_aa64mmfr1_el1_sys_val;
 u64 id_aa64mmfr2_el1_sys_val;
+u64 id_aa64mmfr3_el1_sys_val;
 u64 id_aa64smfr0_el1_sys_val;
 u64 id_aa64dfr0_el1_sys_val;
 
@@ -83,6 +84,11 @@ static bool vm_has_sve(const struct kvm *kvm)
 	return system_supports_sve() && kvm_vcpu_has_feature(kvm, KVM_ARM_VCPU_SVE);
 }
 
+static bool vm_has_s1poe(const struct kvm *kvm)
+{
+	return system_supports_poe();
+}
+
 /*
  * Definitions for features to be allowed or restricted for protected guests.
  *
@@ -176,6 +182,14 @@ static const struct pvm_ftr_bits pvmid_aa64mmfr2[] = {
 	FEAT_END
 };
 
+static const struct pvm_ftr_bits pvmid_aa64mmfr3[] = {
+	MAX_FEAT(ID_AA64MMFR3_EL1, TCRX, IMP),
+	MAX_FEAT(ID_AA64MMFR3_EL1, SCTLRX, IMP),
+	MAX_FEAT(ID_AA64MMFR3_EL1, S1PIE, IMP),
+	MAX_FEAT_FUNC(ID_AA64MMFR3_EL1, S1POE, IMP, vm_has_s1poe),
+	FEAT_END
+};
+
 static const struct pvm_ftr_bits pvmid_aa64isar1[] = {
 	MAX_FEAT(ID_AA64ISAR1_EL1, DPB, DPB2),
 	MAX_FEAT_FUNC(ID_AA64ISAR1_EL1, APA, PAuth, vm_has_ptrauth),
@@ -273,6 +287,8 @@ static u64 pvm_calc_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 		return get_restricted_features(vcpu, id_aa64mmfr1_el1_sys_val, pvmid_aa64mmfr1);
 	case SYS_ID_AA64MMFR2_EL1:
 		return get_restricted_features(vcpu, id_aa64mmfr2_el1_sys_val, pvmid_aa64mmfr2);
+	case SYS_ID_AA64MMFR3_EL1:
+		return get_restricted_features(vcpu, id_aa64mmfr3_el1_sys_val, pvmid_aa64mmfr3);
 	case SYS_ID_AA64DFR0_EL1:
 		return get_restricted_features(vcpu, id_aa64dfr0_el1_sys_val, pvmid_aa64dfr0);
 	case SYS_ID_AA64MMFR4_EL1:
@@ -706,7 +722,7 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	AARCH64(SYS_ID_AA64MMFR0_EL1),
 	AARCH64(SYS_ID_AA64MMFR1_EL1),
 	AARCH64(SYS_ID_AA64MMFR2_EL1),
-	ID_UNALLOCATED(7,3),
+	AARCH64(SYS_ID_AA64MMFR3_EL1),
 	ID_UNALLOCATED(7,4),
 	ID_UNALLOCATED(7,5),
 	ID_UNALLOCATED(7,6),
@@ -792,7 +808,13 @@ static const struct sys_reg_desc_reset pvm_sys_reg_reset_vals[] = {
 	RESET_ZERO(CPACR_EL1),
 	RESET_VAL(CONTEXTIDR_EL1, 0x00000000dbadc0deULL),
 	RESET_VAL(SCTLR_EL1, 0x00C50078ULL),
+	RESET_ZERO(SCTLR2_EL1),
 	RESET_ZERO(TCR_EL1),
+	RESET_ZERO(TCR2_EL1),
+	RESET_UNKNOWN(PIR_EL1),
+	RESET_UNKNOWN(PIRE0_EL1),
+	RESET_UNKNOWN(POR_EL1),
+	RESET_UNKNOWN(POR_EL0),
 	RESET_UNKNOWN(AFSR0_EL1),
 	RESET_UNKNOWN(AFSR1_EL1),
 	RESET_UNKNOWN(ESR_EL1),
-- 
2.47.3

