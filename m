Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8871213C676
	for <kvmarm@lists.linux.dev>; Thu,  6 Jun 2024 09:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717665990; cv=none; b=tQ2F1o7YTSJTVKDgPRDZpaWyEXawMvUxY4jBS8AKWF+L9Ez7D6CZaRXSB2BVanKdvrSaI94KMTFbISnHrIKg/P9gWrcct2b5KJfdxWnUl8D5v+NwEfZsWA1wo2WCzGvJLu+W/eafvPtmFFqikQpajfGtyK3t6RNAK+9C0JNrEO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717665990; c=relaxed/simple;
	bh=1NPybMBUFXHjin6BuY/vECXanPG9adXIp01Abdo1TTA=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=SmRvMr6Em1HgzewNnZBtwvao33CKjfi4R51qvTjiNIODvqxO2ctCbPCCIu0yadJPpW0/bwcYL9+/P/CNYy7muT4qV6q+co5c0MvZFXrowe0O6+e+XWMpRPLKmZvheUkPh1W8a6s5w4VikQgGXFIYQABO+uj2395U4irBuOiWCGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xoFncveU; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xoFncveU"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4215a38713eso6506175e9.3
        for <kvmarm@lists.linux.dev>; Thu, 06 Jun 2024 02:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1717665987; x=1718270787; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/dYlIW+E/i99Z+Z5Rl4zqNFgXtFgm3WuqL/JYpJB2Vg=;
        b=xoFncveU+9y/2rpdtT2TUwXBMNIFB/lTQVZz8sf/LdrzEXTeSPTWKtthm55oDgZipb
         fKqLhDid6Lx/ObVHdetKGuxUZWGqw+f6StR9LPlHgl1fNfZnlkAHLT/C0h9DTn0+mPWt
         ukWrQ0YZE8xK8nqvtzQwxoEs41/zqNYxY0eAwkBfEoo6I1BaSsa7ZUWx6xQcKC+m+kGN
         2sHLhZd6wa1YqUcES77y/AsY9Rni8IKlFOf7CKPRROf9uBInirwCzwo37QKk8GJGzseb
         FV8LEKuvdn+MlBVE4U7FA0LA0YXlVaRRIrOqpsw3f1ZSyh5vz7MhMt35J0GIHyQH43K6
         Uo4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717665987; x=1718270787;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/dYlIW+E/i99Z+Z5Rl4zqNFgXtFgm3WuqL/JYpJB2Vg=;
        b=t2JbjCprJo+Wz8ILfJvCIYxCtp8QXkhABlL9r/bQ7uXf8LkvBCq9EH5cQIdmkUDCDE
         G6PoWhQe0Bqb/Is/VuSRoN1hSkOltniEKD+pczPDsrr2fpLb8dbhY791w6MrQ6CsDira
         x4SOIGEuBMICl1w4+ET4n42N+YBF3TslYC9bD3BVs/xyx5m0IMkn2Nd81gTncpUaQmKX
         Z76bgTZOVKfYWKo/YU7QqouN3Ukr7q10ZLswhdPa4KA0dvzoxrIkt1rLp1he2xl5al4D
         wGlzG+2CiudNpu60P9N+RtJibduhD75HjFgmiw8SzSYIqGqnU81D2mnZVX0AV9KQqYoE
         QqTQ==
X-Gm-Message-State: AOJu0YzvvMwVvws3hz4NKfL/rTWj/nucykoeq1IpwhUjgsyKQvdX0Vev
	4dhltTztU8pvxlZib9mrIdTswNVFUaVvB7SuTKmgxytjkS4QUv8YGKA+2rOW3HNQUsA+9BTgTQq
	zlKcKv8/Vp534IP+ws2MO7NzzsWIu9YEsbz0/DFZhS6HxtMD3odKr4iYm6L3BB/5G7nopYLzOEQ
	Eot3XqWlijQJx2atLQONmBv0LKSR8=
X-Google-Smtp-Source: AGHT+IGTZsk7QnTA8Zwm9Lo8Koctxa3CRJnXRjXnZPJ5YrG0a/9PJZXRAZssfHhXx6DElBnRJl3ju9ciAg==
X-Received: from fuad.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:1613])
 (user=tabba job=sendgmr) by 2002:a05:600c:444b:b0:420:355f:1bfa with SMTP id
 5b1f17b1804b1-42156259babmr288355e9.0.1717665986049; Thu, 06 Jun 2024
 02:26:26 -0700 (PDT)
Date: Thu,  6 Jun 2024 10:26:23 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.45.1.467.gbab1589fc0-goog
Message-ID: <20240606092623.2236172-1-tabba@google.com>
Subject: [PATCH v2] KVM: arm64: Allocate for maximum vector length for pKVM
 host sve state
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, will@kernel.org, qperret@google.com, tabba@google.com, 
	seanjc@google.com, alexandru.elisei@arm.com, catalin.marinas@arm.com, 
	philmd@linaro.org, james.morse@arm.com, suzuki.poulose@arm.com, 
	oliver.upton@linux.dev, mark.rutland@arm.com, broonie@kernel.org, 
	joey.gouly@arm.com, rananta@google.com, yuzenghui@huawei.com
Content-Type: text/plain; charset="UTF-8"

In a heterogeneous system, a cpu could have an sve/sme vector
length that is larger than the rest. Store the value of the
largest possible vector length in the system. When allocating
memory for the host sve state in pKVM, allocate for the largest
possible sve vector length.

Fixes: 66d5b53e20a6 ("KVM: arm64: Allocate memory mapped at hyp for host sve state in pKVM")
Reported-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
Based on kvmarm/fixes (afb91f5f8ad7)

Changes from v1:
- Rename sve_max_system_vl to sve_max_cpu_vl (Mark)
- Rename kvm_host_sve_max_vl to kvm_sve_max_cpu_vl (Mark)
- Initialize vl_info[ARM64_VEC_SVE].max_cpu_vl to SVE_VL_MIN
---
 arch/arm64/include/asm/fpsimd.h         | 13 +++++++++++++
 arch/arm64/include/asm/kvm_host.h       |  2 +-
 arch/arm64/include/asm/kvm_hyp.h        |  2 +-
 arch/arm64/include/asm/kvm_pkvm.h       |  2 +-
 arch/arm64/kernel/fpsimd.c              |  8 +++++++-
 arch/arm64/kvm/hyp/include/hyp/switch.h |  2 +-
 arch/arm64/kvm/hyp/nvhe/hyp-main.c      |  4 ++--
 arch/arm64/kvm/hyp/nvhe/pkvm.c          |  2 +-
 arch/arm64/kvm/reset.c                  |  6 +++---
 9 files changed, 30 insertions(+), 11 deletions(-)

diff --git a/arch/arm64/include/asm/fpsimd.h b/arch/arm64/include/asm/fpsimd.h
index bc69ac368d73..cc2d6d168862 100644
--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -184,6 +184,9 @@ struct vl_info {
 	int max_vl;
 	int max_virtualisable_vl;
 
+	/* The maximum vl encountered for any cpu in the system. */
+	int max_cpu_vl;
+
 	/*
 	 * Set of available vector lengths,
 	 * where length vq encoded as bit __vq_to_bit(vq):
@@ -274,6 +277,11 @@ static inline int vec_max_virtualisable_vl(enum vec_type type)
 	return vl_info[type].max_virtualisable_vl;
 }
 
+static inline int vec_max_cpu_vl(enum vec_type type)
+{
+	return vl_info[type].max_cpu_vl;
+}
+
 static inline int sve_max_vl(void)
 {
 	return vec_max_vl(ARM64_VEC_SVE);
@@ -284,6 +292,11 @@ static inline int sve_max_virtualisable_vl(void)
 	return vec_max_virtualisable_vl(ARM64_VEC_SVE);
 }
 
+static inline int sve_max_cpu_vl(void)
+{
+	return vec_max_cpu_vl(ARM64_VEC_SVE);
+}
+
 /* Ensure vq >= SVE_VQ_MIN && vq <= SVE_VQ_MAX before calling this function */
 static inline bool vq_available(enum vec_type type, unsigned int vq)
 {
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 36b8e97bf49e..f05ccd4ffd55 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -76,7 +76,7 @@ static inline enum kvm_mode kvm_get_mode(void) { return KVM_MODE_NONE; };
 DECLARE_STATIC_KEY_FALSE(userspace_irqchip_in_use);
 
 extern unsigned int __ro_after_init kvm_sve_max_vl;
-extern unsigned int __ro_after_init kvm_host_sve_max_vl;
+extern unsigned int __ro_after_init kvm_sve_max_cpu_vl;
 int __init kvm_arm_init_sve(void);
 
 u32 __attribute_const__ kvm_target_cpu(void);
diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index b05bceca3385..107af09d4505 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -143,6 +143,6 @@ extern u64 kvm_nvhe_sym(id_aa64smfr0_el1_sys_val);
 
 extern unsigned long kvm_nvhe_sym(__icache_flags);
 extern unsigned int kvm_nvhe_sym(kvm_arm_vmid_bits);
-extern unsigned int kvm_nvhe_sym(kvm_host_sve_max_vl);
+extern unsigned int kvm_nvhe_sym(kvm_sve_max_cpu_vl);
 
 #endif /* __ARM64_KVM_HYP_H__ */
diff --git a/arch/arm64/include/asm/kvm_pkvm.h b/arch/arm64/include/asm/kvm_pkvm.h
index cd56acd9a842..b17904e47a82 100644
--- a/arch/arm64/include/asm/kvm_pkvm.h
+++ b/arch/arm64/include/asm/kvm_pkvm.h
@@ -134,7 +134,7 @@ static inline size_t pkvm_host_sve_state_size(void)
 		return 0;
 
 	return size_add(sizeof(struct cpu_sve_state),
-			SVE_SIG_REGS_SIZE(sve_vq_from_vl(kvm_host_sve_max_vl)));
+			SVE_SIG_REGS_SIZE(sve_vq_from_vl(kvm_sve_max_cpu_vl)));
 }
 
 #endif	/* __ARM64_KVM_PKVM_H__ */
diff --git a/arch/arm64/kernel/fpsimd.c b/arch/arm64/kernel/fpsimd.c
index 82e8a6017382..048423e6756b 100644
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -129,6 +129,7 @@ __ro_after_init struct vl_info vl_info[ARM64_VEC_MAX] = {
 		.min_vl			= SVE_VL_MIN,
 		.max_vl			= SVE_VL_MIN,
 		.max_virtualisable_vl	= SVE_VL_MIN,
+		.max_cpu_vl		= SVE_VL_MIN,
 	},
 #endif
 #ifdef CONFIG_ARM64_SME
@@ -1006,7 +1007,7 @@ int sme_get_current_vl(void)
 static void vec_probe_vqs(struct vl_info *info,
 			  DECLARE_BITMAP(map, SVE_VQ_MAX))
 {
-	unsigned int vq, vl;
+	unsigned int vq, vl, max_vl = 0;
 
 	bitmap_zero(map, SVE_VQ_MAX);
 
@@ -1031,7 +1032,12 @@ static void vec_probe_vqs(struct vl_info *info,
 
 		vq = sve_vq_from_vl(vl); /* skip intervening lengths */
 		set_bit(__vq_to_bit(vq), map);
+
+		if (!max_vl)
+			max_vl = vl;
 	}
+
+	info->max_cpu_vl = max((int) max_vl, info->max_cpu_vl);
 }
 
 /*
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 0c4de44534b7..06b77692fb58 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -327,7 +327,7 @@ static inline void __hyp_sve_save_host(void)
 
 	sve_state->zcr_el1 = read_sysreg_el1(SYS_ZCR);
 	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
-	__sve_save_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
+	__sve_save_state(sve_state->sve_regs + sve_ffr_offset(kvm_sve_max_cpu_vl),
 			 &sve_state->fpsr,
 			 true);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-main.c b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
index f43d845f3c4e..2933c9e1b5e5 100644
--- a/arch/arm64/kvm/hyp/nvhe/hyp-main.c
+++ b/arch/arm64/kvm/hyp/nvhe/hyp-main.c
@@ -49,7 +49,7 @@ static void __hyp_sve_restore_host(void)
 	 * supported by the system (or limited at EL3).
 	 */
 	write_sysreg_s(ZCR_ELx_LEN_MASK, SYS_ZCR_EL2);
-	__sve_restore_state(sve_state->sve_regs + sve_ffr_offset(kvm_host_sve_max_vl),
+	__sve_restore_state(sve_state->sve_regs + sve_ffr_offset(kvm_sve_max_cpu_vl),
 			    &sve_state->fpsr,
 			    true);
 	write_sysreg_el1(sve_state->zcr_el1, SYS_ZCR);
@@ -91,7 +91,7 @@ static void flush_hyp_vcpu(struct pkvm_hyp_vcpu *hyp_vcpu)
 
 	hyp_vcpu->vcpu.arch.sve_state	= kern_hyp_va(host_vcpu->arch.sve_state);
 	/* Limit guest vector length to the maximum supported by the host.  */
-	hyp_vcpu->vcpu.arch.sve_max_vl	= min(host_vcpu->arch.sve_max_vl, kvm_host_sve_max_vl);
+	hyp_vcpu->vcpu.arch.sve_max_vl	= min(host_vcpu->arch.sve_max_vl, kvm_sve_max_cpu_vl);
 
 	hyp_vcpu->vcpu.arch.hw_mmu	= host_vcpu->arch.hw_mmu;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/pkvm.c b/arch/arm64/kvm/hyp/nvhe/pkvm.c
index 95cf18574251..22089f481ccc 100644
--- a/arch/arm64/kvm/hyp/nvhe/pkvm.c
+++ b/arch/arm64/kvm/hyp/nvhe/pkvm.c
@@ -18,7 +18,7 @@ unsigned long __icache_flags;
 /* Used by kvm_get_vttbr(). */
 unsigned int kvm_arm_vmid_bits;
 
-unsigned int kvm_host_sve_max_vl;
+unsigned int kvm_sve_max_cpu_vl;
 
 /*
  * Set trap register values based on features in ID_AA64PFR0.
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index 3fc8ca164dbe..5d7db4918875 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -32,7 +32,7 @@
 
 /* Maximum phys_shift supported for any VM on this host */
 static u32 __ro_after_init kvm_ipa_limit;
-unsigned int __ro_after_init kvm_host_sve_max_vl;
+unsigned int __ro_after_init kvm_sve_max_cpu_vl;
 
 /*
  * ARMv8 Reset Values
@@ -52,8 +52,8 @@ int __init kvm_arm_init_sve(void)
 {
 	if (system_supports_sve()) {
 		kvm_sve_max_vl = sve_max_virtualisable_vl();
-		kvm_host_sve_max_vl = sve_max_vl();
-		kvm_nvhe_sym(kvm_host_sve_max_vl) = kvm_host_sve_max_vl;
+		kvm_sve_max_cpu_vl = sve_max_cpu_vl();
+		kvm_nvhe_sym(kvm_sve_max_cpu_vl) = kvm_sve_max_cpu_vl;
 
 		/*
 		 * The get_sve_reg()/set_sve_reg() ioctl interface will need

base-commit: afb91f5f8ad7af172d993a34fde1947892408f53
-- 
2.45.1.467.gbab1589fc0-goog

