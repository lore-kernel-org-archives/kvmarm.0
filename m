Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC342AF1D
	for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 11:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741951119; cv=none; b=a6W6NYzPke0bNfHOtVqp0GqrvEDfUs6uPpOEsI29FJBK1ryf+KygR9nQKjMgqdPGjWKlz5h4Hwtm2SiB0bvO1jNb1DKy1XUItar5euGlnpo4PG2S6vD5pybx+Bf64OFlqTO50s2eIyOSLkTvtz3s7m1S2iIHNYPS/buz/xgdPuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741951119; c=relaxed/simple;
	bh=jGdlOz4dgTUV+PFLASQ1MWgx6/YGxgLarInxpHrbgrI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bLYkqI4eY5aPydNUs/P4dPELkzq8sRZhDBYgBzY7n86CffjkdopGg/8lV8j3MMarcJog+IQHvObsDxx4MCwW0d+7BtMSREJxHFe8weSF89Hh06k63f1ociLojLwU4s5+XqZWX7D2idq1RH+lak3bzRxdxxWz21rn/jDNvKTsqbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BWjQyuz2; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--tabba.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BWjQyuz2"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-43d08915f61so12011365e9.2
        for <kvmarm@lists.linux.dev>; Fri, 14 Mar 2025 04:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1741951116; x=1742555916; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=3IYRjktN0Xe+l0KkZ0Ly6k4G+9WnYnpIs+H0Ux3E9Tw=;
        b=BWjQyuz26pRR//W2q+SQEi7YHq4XJAwR1eGMujFxIWpvLL6ZfRLPzQPUw2lgTcoQvI
         1e5C/lOa7y6RYO0lb/+hzFBOevznLncl7fBQPNUOKwoG+6NqT1j7cBSAv5jojMz9Asl5
         utsEn9Pw4b3iyvqTb4UT2eXEwniW1B80lUOB0Xb/acLdCbnF47RfWsb68DlhON08XyUM
         nB0LPxWGW9pXWNVWswVvrtnzRAQbuBkYMT/Ki5toSPOFjHHttLZzH5rUGuCkiYFM3ynQ
         NNo/jk+Ie28Dvf66nNbcPMy5ytL9QDDeydqyotz3xW+7ZXQuDgt2zQrRr88T24eAcxOb
         Jdfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741951116; x=1742555916;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3IYRjktN0Xe+l0KkZ0Ly6k4G+9WnYnpIs+H0Ux3E9Tw=;
        b=cYzcZOsQ10zI78tNHtpPxcA0tzlZMIjFtD+IoSkLnTYciO1YNt6rX/6zleC94nQ5m5
         sfX1b6E4N+WZteflEsu9FvIhTLuh7bg1oJMHNo684bXFhyqD8g0BUQENw1gCjPuWQD61
         fCXEXVliHVI7ddYoOrSxlliXftn31Gg6h6ONzYShQu+IqAJCagKKBQMWmQNox2J+tDO0
         RS+JKkYaF3d6wmbHYxLhZzuvoPKeb7UFAmMqPse/aHM+qWZx0otE60+55kJH+Q/qQPd0
         xuHGsIkVTt+9ipbO+KiwMqQ8Chg5QX4jGw9y166CZkNNJhfiReXbutlnjkbAWcyn1NL7
         QJTg==
X-Gm-Message-State: AOJu0Yx91Q6N8uA3OYTWrkCpNAA3YZ65t0UkCO47pW+cpxfP06rVqD+Z
	6i8ARrtHzYrPN47fqC4T08JJizOw5+bGduRikUReaBEkK7xtHgwxWib6+NEAxJqIFcp3jRdRRAB
	xv7VzlUZig29ijH5DIrPra4SKSL8dIUAMc/JbkI6UU5/u4En6EeMXinzpLDQd6/jRGL1GV+9nGY
	28roVU0wOGw47xSutO3sot2+sxYR4=
X-Google-Smtp-Source: AGHT+IE6bHiPzyDuSNjh1OdQCzS5lebQOdEcH1nt2Xe9SkNJCG2uKeQglvcRSThYGjxDUfSnU0jOLPC3Hg==
X-Received: from wmbbi13.prod.google.com ([2002:a05:600c:3d8d:b0:43c:ec4d:6037])
 (user=tabba job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:4f56:b0:43c:fd72:f028
 with SMTP id 5b1f17b1804b1-43d1ecd2ddamr26160465e9.29.1741951116586; Fri, 14
 Mar 2025 04:18:36 -0700 (PDT)
Date: Fri, 14 Mar 2025 11:18:29 +0000
In-Reply-To: <20250314111832.4137161-1-tabba@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250314111832.4137161-1-tabba@google.com>
X-Mailer: git-send-email 2.49.0.rc1.451.g8f38331e32-goog
Message-ID: <20250314111832.4137161-2-tabba@google.com>
Subject: [PATCH v3 1/4] KVM: arm64: Factor out setting HCRX_EL2 traps into
 separate function
From: Fuad Tabba <tabba@google.com>
To: kvmarm@lists.linux.dev, linux-arm-kernel@lists.infradead.org
Cc: maz@kernel.org, oliver.upton@linux.dev, mark.rutland@arm.com, 
	will@kernel.org, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, catalin.marinas@arm.com, broonie@kernel.org, 
	qperret@google.com, vdonnefort@google.com, tabba@google.com
Content-Type: text/plain; charset="UTF-8"

Factor out the code for setting a vcpu's HCRX_EL2 traps in to a
separate inline function. This allows us to share the logic with
pKVM when setting the traps in protected mode.

No functional change intended.

Reviewed-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/sys_regs.c            | 20 +-------------------
 2 files changed, 25 insertions(+), 19 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index 78ec1ef2cfe8..31c8497372d0 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -649,4 +649,28 @@ static inline bool guest_hyp_sve_traps_enabled(const struct kvm_vcpu *vcpu)
 {
 	return __guest_hyp_cptr_xen_trap_enabled(vcpu, ZEN);
 }
+
+static inline void vcpu_set_hcrx(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
+		/*
+		 * In general, all HCRX_EL2 bits are gated by a feature.
+		 * The only reason we can set SMPME without checking any
+		 * feature is that its effects are not directly observable
+		 * from the guest.
+		 */
+		vcpu->arch.hcrx_el2 = HCRX_EL2_SMPME;
+
+		if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
+			vcpu->arch.hcrx_el2 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
+
+		if (kvm_has_tcr2(kvm))
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
+
+		if (kvm_has_fpmr(kvm))
+			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnFPM;
+	}
+}
 #endif /* __ARM64_KVM_EMULATE_H__ */
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 82430c1e1dd0..16ce5f584e7c 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -4971,25 +4971,7 @@ void kvm_calculate_traps(struct kvm_vcpu *vcpu)
 	mutex_lock(&kvm->arch.config_lock);
 	vcpu_set_hcr(vcpu);
 	vcpu_set_ich_hcr(vcpu);
-
-	if (cpus_have_final_cap(ARM64_HAS_HCX)) {
-		/*
-		 * In general, all HCRX_EL2 bits are gated by a feature.
-		 * The only reason we can set SMPME without checking any
-		 * feature is that its effects are not directly observable
-		 * from the guest.
-		 */
-		vcpu->arch.hcrx_el2 = HCRX_EL2_SMPME;
-
-		if (kvm_has_feat(kvm, ID_AA64ISAR2_EL1, MOPS, IMP))
-			vcpu->arch.hcrx_el2 |= (HCRX_EL2_MSCEn | HCRX_EL2_MCE2);
-
-		if (kvm_has_tcr2(kvm))
-			vcpu->arch.hcrx_el2 |= HCRX_EL2_TCR2En;
-
-		if (kvm_has_fpmr(kvm))
-			vcpu->arch.hcrx_el2 |= HCRX_EL2_EnFPM;
-	}
+	vcpu_set_hcrx(vcpu);
 
 	if (test_bit(KVM_ARCH_FLAG_FGU_INITIALIZED, &kvm->arch.flags))
 		goto out;
-- 
2.49.0.rc1.451.g8f38331e32-goog

