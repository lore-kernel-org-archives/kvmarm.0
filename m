Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794213186;
	b=Nl7u8a1ExfVLSaqFfRlXVFAfXq4x6/JUuNQc9GZPSPrRhkRgS1hzwvSR5Yd0BqSsCbry
	 /ChhGqiX5i3cK+PzO9o4h+V+xCr3jq8oaoKexMnt04DqFFnwxARjCanI8GNYVEcu1n75t
	 7W4evbRk2A9xbeMHZ2nL1njDOaHzoUlcJ4M/6MGkJcF4eJ9JyWH0m2JaQaYb0qGllJ8zS
	 9cEDXVifuG/UMqCl4u8d7PicKlc4wjzrARWlnHrqA7vX/9tLNE+r+83QXzJnZlrfY7Fg7
	 2bhuv05fNOiYc60ppiB4r/N83Zcu6gtQJhiLUCa3Oz3+cq5mcsRAnuejFbZIXxuZpBg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794213186;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=dUshNCC1JpzRp/bHnMx4//j1DzIGCNgstnma7Jcay74=;
	b=nTOCyuPEELS3pQuX3kgeVvgYDaOpyaeuKFYK9TbZfNNiph9YU8zN1mfPOT179GpBeV7C
	 ACtGE7RLDAdQaRjv5Kw/Xz+pN9rZvBCILmXWEFjZBqdnaZ486tHTup/SHAOKpPxtWB/54
	 1VPjB6L7rIZNUHKQwdXn15jAMl/xgmV6tRl+NcQPmRSOvCrq0E32u9GMevG2t/ygHz6su
	 9bA1rLooUJvz31t2c4V4butqdNhOEDrayYicSXd6m3Ks1P9GCM2+/u0ym8GnEPzaOKBf/
	 xdn5XPMm54nu/VPCJsOgzPqN2E9e6SeFlApWOV0NKkM5sq3K9ZI7Dtyib9GySrX8xZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lU8HrHlO;
	arc=none smtp.remote-ip=95.215.58.18
Received: from mta1.migadu.com (out-18.mta1.migadu.com [95.215.58.18])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67118606EEA4
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:33:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67118606EEA4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lU8HrHlO
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=VfxGGfCvnSJWTEWHhVoSP0xCUW7jRYSfiBO+2ILhPRs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794213183; v=1; x=1794817983;
 b=lU8HrHlOVzEs/aT3L0NjhZPC43vy51Peza1nXg3QeovsDXrYjYI55fztyfrgDlP18ukW7tno
 zCEbJrUD7DUq55RglriO7HrV6YehNxAkLtlpjz7p5let4yXcezXkodbQKreqrkuZUnNfOoaBd1x
 ZQyAas5f7NdUTExsG8RmAAX8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 27c8a42749aada3d;
	Mon, 09 Nov 2026 08:33:03 +0000
X-Mizu-Trace-ID: 27c8a42749aada3d
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
Subject: [PATCH 15/16] KVM: arm64: Advertise FP8 and F16MM to protected VMs
Date: Mon,  9 Nov 2026 08:32:04 +0000
Message-ID: <20261109083205.806619-16-fuad.tabba@linux.dev>
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

Advertise the FP8 features and FEAT_F16MM to protected VMs, the
ID_AA64FPFR0_EL1 fields a non-protected VM sees. Their instructions
only use the SIMD&FP registers and FPMR, which EL2 already switches.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_hyp.h   |  1 +
 arch/arm64/kvm/arm.c               |  1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 18 +++++++++++++++++-
 3 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index fa9a99cae32a7..09b19f2c3c090 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -145,6 +145,7 @@ extern u64 kvm_nvhe_sym(id_aa64pfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64pfr1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64pfr2_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64zfr0_el1_sys_val);
+extern u64 kvm_nvhe_sym(id_aa64fpfr0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar0_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar1_el1_sys_val);
 extern u64 kvm_nvhe_sym(id_aa64isar2_el1_sys_val);
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 1981646df42ce..6cc65ee4c6f2a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2828,6 +2828,7 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(id_aa64pfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR1_EL1);
 	kvm_nvhe_sym(id_aa64pfr2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64PFR2_EL1);
 	kvm_nvhe_sym(id_aa64zfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64ZFR0_EL1);
+	kvm_nvhe_sym(id_aa64fpfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64FPFR0_EL1);
 	kvm_nvhe_sym(id_aa64isar0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64ISAR0_EL1);
 	kvm_nvhe_sym(id_aa64isar1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64ISAR1_EL1);
 	kvm_nvhe_sym(id_aa64isar2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64ISAR2_EL1);
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 8e9283dae3484..a0f6737ff8f16 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -24,6 +24,7 @@ u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
 u64 id_aa64pfr2_el1_sys_val;
 u64 id_aa64zfr0_el1_sys_val;
+u64 id_aa64fpfr0_el1_sys_val;
 u64 id_aa64isar0_el1_sys_val;
 u64 id_aa64isar1_el1_sys_val;
 u64 id_aa64isar2_el1_sys_val;
@@ -149,6 +150,19 @@ static const struct pvm_ftr_bits pvmid_aa64zfr0[] = {
 	FEAT_END
 };
 
+static const struct pvm_ftr_bits pvmid_aa64fpfr0[] = {
+	MAX_FEAT(ID_AA64FPFR0_EL1, F8E5M2, IMP),
+	MAX_FEAT(ID_AA64FPFR0_EL1, F8E4M3, IMP),
+	MAX_FEAT(ID_AA64FPFR0_EL1, F16MM2, IMP),
+	MAX_FEAT(ID_AA64FPFR0_EL1, F8MM4, IMP),
+	MAX_FEAT(ID_AA64FPFR0_EL1, F8MM8, IMP),
+	MAX_FEAT(ID_AA64FPFR0_EL1, F8DP2, IMP),
+	MAX_FEAT(ID_AA64FPFR0_EL1, F8DP4, IMP),
+	MAX_FEAT(ID_AA64FPFR0_EL1, F8FMA, IMP),
+	MAX_FEAT(ID_AA64FPFR0_EL1, F8CVT, IMP),
+	FEAT_END
+};
+
 static const struct pvm_ftr_bits pvmid_aa64mmfr0[] = {
 	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, PARANGE, 40),
 	MAX_FEAT_ENUM(ID_AA64MMFR0_EL1, ASIDBITS, 16),
@@ -298,6 +312,8 @@ static u64 pvm_calc_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 		return get_restricted_features(vcpu, id_aa64pfr2_el1_sys_val, pvmid_aa64pfr2);
 	case SYS_ID_AA64ZFR0_EL1:
 		return get_restricted_features(vcpu, id_aa64zfr0_el1_sys_val, pvmid_aa64zfr0);
+	case SYS_ID_AA64FPFR0_EL1:
+		return get_restricted_features(vcpu, id_aa64fpfr0_el1_sys_val, pvmid_aa64fpfr0);
 	case SYS_ID_AA64ISAR0_EL1:
 		return id_aa64isar0_el1_sys_val;
 	case SYS_ID_AA64ISAR1_EL1:
@@ -727,7 +743,7 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	AARCH64(SYS_ID_AA64ZFR0_EL1),
 	ID_UNALLOCATED(4,5),
 	ID_UNALLOCATED(4,6),
-	ID_UNALLOCATED(4,7),
+	AARCH64(SYS_ID_AA64FPFR0_EL1),
 	AARCH64(SYS_ID_AA64DFR0_EL1),
 	AARCH64(SYS_ID_AA64DFR1_EL1),
 	ID_UNALLOCATED(5,2),
-- 
2.47.3

