Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.194
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794213150;
	b=vU8VlczEiG3Hq7QdENhwQBMDXXnn9jgGXIHTsAkdRE1PfGps/wjVAmCerglV8E+EV8lg
	 18Dkv86ZM5FHaizYdwhSaCS7RgPdzcIwKHwMlqLrLAjIS2SUAueZQzEvePBkNQetgGu2C
	 GGUn/ySqXAW+7oh8ZF2zIVXK4q5ERz7Ih16RmmukrmBlC9sfiVSwNumUf/rmDj3glQpVm
	 EQAWAwUO1F2tSrg9pCQGprjB/rfMC7UtnX4bqSmQULpU1MeweTlzFURr4zftgA19oRqsC
	 ylcTt6WOBpNmBDQLPbkR/yY7DEvG09IxgFtbjQZ2skHDEnam9p+HyORkg3wLxsP58tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794213150;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=k8Xd/+fGnS2qXx5edt8NtESRbuDHSi6WwC92d90oCr8=;
	b=4MZuUk/X/8WfK/bvyDK+kd1Jn+WjPaZ2DPNYIjxj1KP2pC73h9xBvxUjLzrjDmB5Jcqw
	 RVPI7xIlfLHuqtuoAxzp2pKu/Q9pFCGEU6h60XBibYlEyJNMvyaKnU9iWbErt34r4KQvT
	 Rtpy+TcW03YfBGT+72fIFgjCi4ZkPQcqvbSmMyC/ES0xu0Z1mV4TA/uwhOOfjJ0kzv/kk
	 XWi5ePZrJiL0oT+tv7ewpRbwRneidelceLf0zafFIYTsgCs9ggBg2ujgHaNg3lErmudzQ
	 qwYe5fpDo0/oFIDNnj7KxZ/JgCoIzoWXK/i3hzDhTaEmYCtw2KCUnrvQLVyzBxGDdQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HD1555m1;
	arc=none smtp.remote-ip=91.218.175.194
Received: from mta0.migadu.com (out-194.mta0.migadu.com [91.218.175.194])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940D0606D823
	for <kvmarm@lists.linux.dev>; Mon,  9 Nov 2026 08:32:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 940D0606D823
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HD1555m1
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=M0DDDg353f4NM3Zyj4GK6LS1/VFcjYOv36EOnoDnTww=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794213147; v=1; x=1794817947;
 b=HD1555m1zc10kTvWfGj0UgiKmz/6/o/n6GON1oX9mlk0kZc0MU5jLyiQsuOTnKyeP9jWQaXX
 WeBpcfVr7UyQ8Y1mlLqe/0x25DkzNHU1VpCZvUOWy6npUoAILe5PWQXcXq0vbhL2LPbSUu+DmYF
 3ek/istkwh1M15GMITDc2mw8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id b501e4074c3b4662;
	Mon, 09 Nov 2026 08:32:27 +0000
X-Mizu-Trace-ID: b501e4074c3b4662
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
Subject: [PATCH 08/16] KVM: arm64: Advertise TCR2, SCTLR2, S1PIE and S1POE to protected VMs
Date: Mon,  9 Nov 2026 08:31:57 +0000
Message-ID: <20261109083205.806619-9-fuad.tabba@linux.dev>
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
index 2753686982f0b..fe60535e4f358 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -2834,6 +2834,7 @@ static void kvm_hyp_init_symbols(void)
 	kvm_nvhe_sym(id_aa64mmfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
 	kvm_nvhe_sym(id_aa64mmfr1_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR1_EL1);
 	kvm_nvhe_sym(id_aa64mmfr2_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR2_EL1);
+	kvm_nvhe_sym(id_aa64mmfr3_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64MMFR3_EL1);
 	kvm_nvhe_sym(id_aa64smfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64SMFR0_EL1);
 	kvm_nvhe_sym(id_aa64dfr0_el1_sys_val) = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
 	kvm_nvhe_sym(__icache_flags) = __icache_flags;
diff --git a/arch/arm64/kvm/hyp/nvhe/sys_regs.c b/arch/arm64/kvm/hyp/nvhe/sys_regs.c
index 78c25da737591..d186aba6aa09c 100644
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
@@ -177,6 +183,14 @@ static const struct pvm_ftr_bits pvmid_aa64mmfr2[] = {
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
@@ -274,6 +288,8 @@ static u64 pvm_calc_id_reg(const struct kvm_vcpu *vcpu, u32 id)
 		return get_restricted_features(vcpu, id_aa64mmfr1_el1_sys_val, pvmid_aa64mmfr1);
 	case SYS_ID_AA64MMFR2_EL1:
 		return get_restricted_features(vcpu, id_aa64mmfr2_el1_sys_val, pvmid_aa64mmfr2);
+	case SYS_ID_AA64MMFR3_EL1:
+		return get_restricted_features(vcpu, id_aa64mmfr3_el1_sys_val, pvmid_aa64mmfr3);
 	case SYS_ID_AA64DFR0_EL1:
 		return get_restricted_features(vcpu, id_aa64dfr0_el1_sys_val, pvmid_aa64dfr0);
 	case SYS_ID_AA64MMFR4_EL1:
@@ -707,7 +723,7 @@ static const struct sys_reg_desc pvm_sys_reg_descs[] = {
 	AARCH64(SYS_ID_AA64MMFR0_EL1),
 	AARCH64(SYS_ID_AA64MMFR1_EL1),
 	AARCH64(SYS_ID_AA64MMFR2_EL1),
-	ID_UNALLOCATED(7,3),
+	AARCH64(SYS_ID_AA64MMFR3_EL1),
 	ID_UNALLOCATED(7,4),
 	ID_UNALLOCATED(7,5),
 	ID_UNALLOCATED(7,6),
@@ -793,7 +809,13 @@ static const struct sys_reg_desc_reset pvm_sys_reg_reset_vals[] = {
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

