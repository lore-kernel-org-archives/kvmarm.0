Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793883923;
	b=W3ntQHyC5J+h29TK40SfT/+1ssUYSgsFCSJEj2DgcI2WSLg9bymFnFoJG7sh7hA8re96
	 iP/dBByZXWQ4A2OKC/dNQGWeyvybrffo/x13OVz/vc9dQQazYPWg6hJDospjdarVMrzvF
	 eFMa5hbrlbqy9I7XK2TbmPLCQZhyHlVkVHdRR+UMnlZsuWJxmBYuNLSM/sh+A2QMp/Edm
	 qUQSSXfK3yPvqoPhlXDBy9/AMm0q2WYvPG/mCBlSS/7+f+H3F6yrzddpjy47iq8Jmm1lj
	 8Y13j+ZmVtaodu7hx0rPSSfnP0I1fcRIy0iGi2P8cyD+2P8SCzPeeC90TEYcHzPyo5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793883923;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=9k9K8nTEYmyXFaOgzj1P2GDgV/Rf++l8doHLxGAc6VA=;
	b=0Gxz+ejpjWVIXlktOgPEPKY8/Msi9IhAsh6qHed6epSlbUQxT6z74BPbfBYFg2poX5p0
	 +SCRxUE5ugok+Hzea27q6mCD4mP2lDAySBGzoo60kexXqZGyKLFAOFrzX9tfU2tLfEkVb
	 wWQg+7rj9bbFP5oplb745sn0snKAyVUP2fciArONo1Lc3Spwj3yYL3gikiYE9MegKpTHa
	 kq/kz/NyInfWE2Dhxk+YQ/jUEhLgzwRcWBSgZjcPK0Wf5M8Vhs/vA89hBlAzpP0cVPya9
	 v+UgdHta2i2CZI+mZYznN/JTcC2u6CtD7YvSRzYA9U/vE8mEGcGrzJXLxizJZj7LJKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="SEdt/Lrl";
	arc=none smtp.remote-ip=91.218.175.198
Received: from mta0.migadu.com (out-198.mta0.migadu.com [91.218.175.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BD05606A329
	for <kvmarm@lists.linux.dev>; Thu,  5 Nov 2026 13:05:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7BD05606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SEdt/Lrl
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=l8jzR9UTrR8//YSZuL9grlpdOXVS3eekgMJRG6e6qXQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793883920; v=1; x=1794488720;
 b=SEdt/LrlB5h35iT9kuCWbNkjMMxrmNBxtHihTus7n9Z1mYRxiaIAltL3M0X5pxnsYpeSr1DU
 iGEvtQZ5kFGH2M2dw4WDD7HeGI78qnTvIqKe+2SIEOgO9iPLla5uhTmUTRTzRk9n+fx6v3gvk0e
 J+rCcKqJRuP44jTYpEmDkDuk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 4942c736930b283a;
	Thu, 05 Nov 2026 13:05:19 +0000
X-Mizu-Trace-ID: 4942c736930b283a
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
Subject: [PATCH 3/4] KVM: arm64: Advertise ID_AA64ZFR0_EL1 to protected VMs
Date: Thu,  5 Nov 2026 13:04:55 +0000
Message-ID: <20261105130456.1617185-4-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261105130456.1617185-1-fuad.tabba@linux.dev>
References: <20261105130456.1617185-1-fuad.tabba@linux.dev>
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

EL2 builds a protected guest's ID registers from the host's sanitised
values, most of them capped per field. It has no case for
ID_AA64ZFR0_EL1, so the register reads as 0, and a protected guest with
SVE wouldn't see any of the SVE extensions the CPUs implement.

Keep a copy of the host's sanitised ID_AA64ZFR0_EL1 at EL2, and
advertise it when the guest has SVE, as KVM does for a non-protected
guest. Cap each field at the highest value the sysreg file defines.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_hyp.h   |  1 +
 arch/arm64/kvm/arm.c               |  1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 19 +++++++++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 8cf42f87526dd..b9455ff8d7bdb 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -144,6 +144,7 @@ void __noreturn __host_enter(struct kvm_cpu_context *host_ctxt);
 extern u64 kvm_nvhe_sym(id_aa64pfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64pfr1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64pfr2_el1_sys_val);
+extern u64 kvm_nvhe_sym(id_aa64zfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar2_el1_sys_val);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 157bf4b812020..be5127ce388a8 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2827,6 +2827,7 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(id_aa64pfr0_el1_sys_val) = get_hyp_id_aa64pfr0_el1();
 	kvm_nvhe_sym(id_aa64pfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
 	kvm_nvhe_sym(id_aa64pfr2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR2_EL1);
+	kvm_nvhe_sym(id_aa64zfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64ZFR0_EL1);
 	kvm_nvhe_sym(id_aa64isar0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64ISAR0_EL1);
 	kvm_nvhe_sym(id_aa64isar1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64ISAR1_EL1);
 	kvm_nvhe_sym(id_aa64isar2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64ISAR2_EL1);
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 06ea91415ad8b..e6bbc897cd7b1 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -21,6 +21,7 @@
 u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
 u64 id_aa64pfr2_el1_sys_val;
+u64 id_aa64zfr0_el1_sys_val;
 u64 id_aa64isar0_el1_sys_val;
 u64 id_aa64isar1_el1_sys_val;
 u64 id_aa64isar2_el1_sys_val;
@@ -114,6 +115,22 @@ static const struct pvm_ftr_bits pvmid_aa64pfr2[] = {
 	FEAT_END
 };
 
+static const struct pvm_ftr_bits pvmid_aa64zfr0[] = {
+	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, SVEver, SVE2p3, vm_has_sve),
+	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, AES, AES2, vm_has_sve),
+	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, EltPerm, IMP, vm_has_sve),
+	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, BitPerm, IMP, vm_has_sve),
+	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, BF16, EBF16, vm_has_sve),
+	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, B16B16, B16MM, vm_has_sve),
+	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, SHA3, IMP, vm_has_sve),
+	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, SM4, IMP, vm_has_sve),
+	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, I8MM, IMP, vm_has_sve),
+	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, F16MM, IMP, vm_has_sve),
+	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, F32MM, IMP, vm_has_sve),
+	MAX_FEAT_FUNC(ID_AA64ZFR0_EL1, F64MM, IMP, vm_has_sve),
+	FEAT_END
+};
+
 static const struct pvm_ftr_bits pvmid_aa64mmfr0[] = {
 	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, PARANGE, 40),
 	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, ASIDBITS, 16),
@@ -232,6 +249,8 @@ static u64 pvm_calc_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 		return get_restricted_features(vcpu, id_aa64pfr1_el1_sys_val, pvmid_aa64pfr1);
 	case SYS_ID_AA64PFR2_EL1:
 		return get_restricted_features(vcpu, id_aa64pfr2_el1_sys_val, pvmid_aa64pfr2);
+	case SYS_ID_AA64ZFR0_EL1:
+		return get_restricted_features(vcpu, id_aa64zfr0_el1_sys_val, pvmid_aa64zfr0);
 	case SYS_ID_AA64ISAR0_EL1:
 		return id_aa64isar0_el1_sys_val;
 	case SYS_ID_AA64ISAR1_EL1:
-- 
2.47.3

