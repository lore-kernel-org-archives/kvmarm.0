Received: from mail-oo1-f74.google.com (mail-oo1-f74.google.com [209.85.161.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F93931A55F
	for <kvmarm@lists.linux.dev>; Mon,  9 Feb 2026 22:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770676856; cv=none; b=aoFrgjIwxgdmvoFzCkqCjqJwAqIAzXYnFAffUsYS+tG88BFoaR2tFFKgi8sU1BxY7eDJTlWvxhYzKP0JMTFkWP01GOK+sGXOzMCk3VprmmVM06iDUoxUwF0n2CbqZJU9rQh0MYnqjnNxU3NbhUV+tm3nEIv1FOonsrH5LAXuTCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770676856; c=relaxed/simple;
	bh=B9HZV/XvGCtJKEIzSCyXAxqSnw0EEFic83RP1XipC3Y=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Ri179eBtk91rMIgYwso4F1fnV2mI8fJioSDznrgZv8MCyaT47fCCrTT+eugDkzIj1bnWjmzunxizWW3t9HAGqIswpTOkiL/K3I8TNDKdtbd+x8IccBeQ4selLV55k478Dyu4u0oRDd8UfnfjWsR7AP1IOCoLo6hvI2ldhwoEzz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TEE+FdC/; arc=none smtp.client-ip=209.85.161.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TEE+FdC/"
Received: by mail-oo1-f74.google.com with SMTP id 006d021491bc7-663005f0997so10281592eaf.0
        for <kvmarm@lists.linux.dev>; Mon, 09 Feb 2026 14:40:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770676852; x=1771281652; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nily0rEh3mmY4uvAeTjqDVW7kEcYRK1QYtsSJT+aPhk=;
        b=TEE+FdC/eMuo6KZzIkh0T9uMBvc6MYZG41JOqyNFfNbcuMhl6TvM1qcH+REuqjY5+M
         ReOrZc3obUzqjiwkOH2xJcAE6e/qh/ULLJXNGMfPtIB2tkmfivQ578Djq15xU+kC+v4l
         eEKAFWrDSlOC0TV838xQsGeB01CK6VfipAn0meICZis0ldVPognJLK+BrYFkJPJ2UmOQ
         WlfxScnuXZ3GkiuhsvN7d7fqiNWdfqnISABhrIu5RNUpyPK9TaduOy5c75b5PNG6jBkT
         NmvRqk8H6qwyQhhJKoaAa7szuGM5hxUmtZ6KsCl31utkmyxMLnMRgaIR5uGhJZhnKD7q
         D3XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770676852; x=1771281652;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nily0rEh3mmY4uvAeTjqDVW7kEcYRK1QYtsSJT+aPhk=;
        b=HbVBii+WUhCKilUWJHoRA+jBEUgItYwukp+d8E5dPhxZk1E9zedSPcbdUAI0yPhcne
         bPQ13mKE/MjaZntoAMw8I2M4pAYfWWTadl6rsgRJr01KuZ8ft61q+DIhkzaJzYrEXxf7
         7DsK1aVLjEe7SlAz/WGpbh6H+DtGGlC8l079+5to04rVcLxkZLsvYO9Kt8sI8wiNWTZH
         8Xn5Na9NJNfmmqSoNxbQ4E8kUPJuzeykVSdC64V7cZgUzxBr57fCKyMTvJFIcIKBKcE/
         5Fb3J+tVAjTLAeh1y54qFloCV6hh3eyAzWNwPf19NrVD213xj1k1LF3wJSAQ/S3YW/h2
         UgEA==
X-Forwarded-Encrypted: i=1; AJvYcCXGulp0qAabW/QcWzzcqCpSNJZU13BGDpCDNwj6FWRctlXo+pSvfgEgg69WaZQpgoUeSEKB+As=@lists.linux.dev
X-Gm-Message-State: AOJu0YxvCkE/QFOdUQX1rd75C8+eyaZicEkqhu5NaQhEZ24O17lrSkR0
	Ws1XElpQdBKCnuDWYVk2QwlQzpmtVBVqRDoX4UkfuYndEpUCHsWFlRoWnIsx+M0EfCLbD8oshdK
	s3Q+K2Zff3k+Z/ztuqAcXhkrawQ==
X-Received: from iobbx7.prod.google.com ([2002:a05:6602:4187:b0:957:50e1:3858])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a4a:e902:0:b0:66f:6d5e:76c3 with SMTP id 006d021491bc7-672fff0af95mr60439eaf.42.1770676852384;
 Mon, 09 Feb 2026 14:40:52 -0800 (PST)
Date: Mon,  9 Feb 2026 22:14:03 +0000
In-Reply-To: <20260209221414.2169465-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260209221414.2169465-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209221414.2169465-9-coltonlewis@google.com>
Subject: [PATCH v6 08/19] KVM: arm64: Define access helpers for PMUSERENR and PMSELR
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

In order to ensure register permission checks will have consistent
results whether or not the PMU is partitioned, define some access
helpers for PMUSERENR and PMSELR that always return the canonical
value for those registers, whether it lives in a physical or virtual
register.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu.c      | 16 ++++++++++++++++
 arch/arm64/kvm/sys_regs.c |  6 +++---
 include/kvm/arm_pmu.h     | 12 ++++++++++++
 3 files changed, 31 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 74a5d35edb244..344ed9d8329a6 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -885,3 +885,19 @@ u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 
 	return u64_replace_bits(pmcr, n, ARMV8_PMU_PMCR_N);
 }
+
+u64 kvm_vcpu_read_pmselr(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vcpu_pmu_is_partitioned(vcpu))
+		return read_sysreg(pmselr_el0);
+	else
+		return __vcpu_sys_reg(vcpu, PMSELR_EL0);
+}
+
+u64 kvm_vcpu_read_pmuserenr(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vcpu_pmu_is_partitioned(vcpu))
+		return read_sysreg(pmuserenr_el0);
+	else
+		return __vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+}
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index a460e93b1ad0a..9e893859a41c9 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -987,7 +987,7 @@ static u64 reset_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r)
 
 static bool check_pmu_access_disabled(struct kvm_vcpu *vcpu, u64 flags)
 {
-	u64 reg = __vcpu_sys_reg(vcpu, PMUSERENR_EL0);
+	u64 reg = kvm_vcpu_read_pmuserenr(vcpu);
 	bool enabled = (reg & flags) || vcpu_mode_priv(vcpu);
 
 	if (!enabled)
@@ -1141,7 +1141,7 @@ static bool access_pmu_evcntr(struct kvm_vcpu *vcpu,
 				return false;
 
 			idx = SYS_FIELD_GET(PMSELR_EL0, SEL,
-					    __vcpu_sys_reg(vcpu, PMSELR_EL0));
+					    kvm_vcpu_read_pmselr(vcpu));
 		} else if (r->Op2 == 0) {
 			/* PMCCNTR_EL0 */
 			if (pmu_access_cycle_counter_el0_disabled(vcpu))
@@ -1191,7 +1191,7 @@ static bool access_pmu_evtyper(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 	if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 1) {
 		/* PMXEVTYPER_EL0 */
-		idx = SYS_FIELD_GET(PMSELR_EL0, SEL, __vcpu_sys_reg(vcpu, PMSELR_EL0));
+		idx = SYS_FIELD_GET(PMSELR_EL0, SEL, kvm_vcpu_read_pmselr(vcpu));
 		reg = PMEVTYPER0_EL0 + idx;
 	} else if (r->CRn == 14 && (r->CRm & 12) == 12) {
 		idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 50983cdbec045..f21439000129b 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -130,6 +130,8 @@ int kvm_arm_set_default_pmu(struct kvm *kvm);
 u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm);
 
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu);
+u64 kvm_vcpu_read_pmselr(struct kvm_vcpu *vcpu);
+u64 kvm_vcpu_read_pmuserenr(struct kvm_vcpu *vcpu);
 bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx);
 void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu);
 #else
@@ -250,6 +252,16 @@ static inline u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+static inline u64 kvm_vcpu_read_pmselr(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
+static u64 kvm_vcpu_read_pmuserenr(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
 static inline bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	return false;
-- 
2.53.0.rc2.204.g2597b5adb4-goog

