Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.146
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794213132;
	b=00e35XLOdBVZXrMzDyVhGaDFBIa57wd1H5x36yPaqPcScOUNVLmnQ3hARTTM0yWEPnXD
	 uAogj7wi/8bPDqYcvbaiQgwnjk+oVV0Jq+rKfmDHKkePdaucs7sdlPVPoF3uQcPhcevtK
	 KeP5Dt0Nys4jnGs7gCHUt7I7pPZOooyDYOSav57ZJyKiZi9xSDVSh3Ft2hvB3P7Yl/JBG
	 xfY5v3COAQDu4EcPgoydDg3ledGI65p1yO1KHhWOdpcFRTkMtyXBV25TmeZAzbxSCjocj
	 wjEeKyJ1mFUeDRkTRXyzSCav0aHtFsRxgkxi68PcvqibvoJXZr2ZCDCVg7lJ9FqwrMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794213132;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=tp8Sq65lQy4n53kB120thiuvZdFv1/XatvTeKeD3ITY=;
	b=v2Vvbgmc6Mse8/qw+qmewSll60ZYAEu0cy6hDUORJT0rC0+aoEqLWnKKpqor82K77qlE
	 3JJEmb83rGvxei7YrgJGcYja769m+C7lV0/bBKZaxDd8jv8mGnR8YhNhJeVc3hvTF8XWm
	 SjdjHIPWZWZZwQ9hY4CFldTl9NDoLJh6tDnPqnAGcvYvL7B5NHAlHHCufG6wqpQZwrAcz
	 plhk/QUxYboBRIlgi7bRBpaPlto/WEOMF79KJBqzRw4plPynyewC73/FaCg7uyv/JXali
	 PBa1t8w+WL7Heeaejx2+OXHZqkvQrSy2fLkI9bpTYuc4CkIHGZNEMII21KdQlhY1+/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=m+q3r23Z;
	arc=none smtp.remote-ip=95.215.58.146
Received: from mta1.migadu.com (out-146.mta1.migadu.com [95.215.58.146])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078BA606D802
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:32:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 078BA606D802
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=m+q3r23Z
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=KMB0x3fjUA27PqmYAjvVUwJPxblEBWvc8qSTZOm4ABo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794213130; v=1; x=1794817930;
 b=m+q3r23ZuJjIy3hL7OtVLmOCXQqZB/E7+e+hf7lwLkQ33ypd212oVb+UUCVtYCRFJ12nFmmb
 s6XQMOjQ3GEWNeShkBXUUfJBEnj/jnV52KpXfwp8+PECDYoyKb0ysY1szmD5ivBOceGtgnLYfH1
 tDOngyCBryXqDSbbCEC7D60I=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 08a1187800b712d4;
	Mon, 09 Nov 2026 08:32:10 +0000
X-Mizu-Trace-ID: 08a1187800b712d4
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
Subject: [PATCH 04/16] KVM: arm64: Advertise ID_AA64ZFR0_EL1 to protected VMs
Date: Mon,  9 Nov 2026 08:31:53 +0000
Message-ID: <20261109083205.806619-5-fuad.tabba@linux.dev>
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

EL2 builds a protected guest's ID registers from the host's sanitised
values, most of them capped per field. It has no case for
ID_AA64ZFR0_EL1, so the register reads as 0, and a protected guest with
SVE wouldn't see any of the SVE extensions the CPUs implement.

Keep a copy of the host's sanitised ID_AA64ZFR0_EL1 at EL2, and
advertise it when the guest has SVE, as KVM does for a non-protected
guest. Cap each field at the highest value the sysreg file defines.

Tested-by: Vincent Donnefort <vdonnefort@google.com>
Reviewed-by: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 arch/arm64/include/asm/kvm_hyp.h   |  1 +
 arch/arm64/kvm/arm.c               |  1 +
 arch/arm64/kvm/hyp/nvhe/sys_regs.c | 19 +++++++++++++++++++
 3 files changed, 21 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 22601a4e36f4e..920c1d8d45b1a 100644
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
index ec90a580e82a4..2753686982f0b 100644
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
index 7a0aed1d8b0b3..8456bb44edd52 100644
--- a/arch/arm64/kvm/hyp/nvhe/sys_regs.c
+++ b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
@@ -23,6 +23,7 @@
 u64 id_aa64pfr0_el1_sys_val;
 u64 id_aa64pfr1_el1_sys_val;
 u64 id_aa64pfr2_el1_sys_val;
+u64 id_aa64zfr0_el1_sys_val;
 u64 id_aa64isar0_el1_sys_val;
 u64 id_aa64isar1_el1_sys_val;
 u64 id_aa64isar2_el1_sys_val;
@@ -124,6 +125,22 @@ static const struct pvm_ftr_bits pvmid_aa64pfr2[] = {
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
@@ -243,6 +260,8 @@ static u64 pvm_calc_id_reg(const struct kvm_vcpu *vcpu, u32 id)
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

