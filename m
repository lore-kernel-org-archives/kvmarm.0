Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 715002F2C78
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 20:06:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750968371; cv=none; b=UkTDfJ/0R8CS7z5KLTc0S8MRlzUtIvm/XrY955OYy6nx/6XqBytWF/1Ur9jul8o3diw0kICg7zBrr/WV/9YkE5zJkK7MIPtLo7aRiNN64aabx37VA4MRANvRL0L0gAIiRONV8h3XtIktKhED5Pij+xJ5vQt0ezQGaYHavp5kDYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750968371; c=relaxed/simple;
	bh=IWaFMzxpfIdgN+yIYTWB9IxNShtWfAOHfgOed50zY4s=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=NKUP7rzAowvA3+ZrLBkAzTJWlHw5o5DeWUh/WcPqCfL9tstJUWqvLogzlGdmPqP9j+hEJT5G0O7YfO0nbW4f1xTHYq4tdCqzTlsX1MBnsyDJQ+cO4XRqweJk/lj1tAxhoC5JHxScluYuIy+CJKPfc8WQg5+QCdqtJv/xxWULpUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=zOgZs6th; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="zOgZs6th"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3ddbd339f3dso13946205ab.0
        for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 13:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750968367; x=1751573167; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QA3UW6Y8rAxAny6iU/eRmOq8dPrpECd+SpYd5oHTFx0=;
        b=zOgZs6thyMthqbkW3FvgCTMot7FESS64jglGpBIz/h/jUEu6xx5rZmWTxuBS2p3rnn
         lQt2pGRLHSJCd5Xe7uIQqWtuosmkcHCsJc2YhjZ/M66uqn9LVoRrf7b+4+xUz4/Y160m
         fvstR6fc/wWnjaAFIYw/yaxpUzWXb1dULGoGaHv5ZhzhuyKFE6CsOC0ZCNiNaLOwRywf
         NDHvAlvteX5fu/0hMcftaRH0XdpwjlWPReVqITh+mhPfFZl+414KtKobPP7cIDFkgwjX
         q/Al3mTwI4JoXuwk7+ZKixBycLM1wrjqTXLITYno0YjWg7il2Cv/7aGhvdTGPFtc1P6k
         9UVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750968367; x=1751573167;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QA3UW6Y8rAxAny6iU/eRmOq8dPrpECd+SpYd5oHTFx0=;
        b=rnIGzbnLkoZ7uLWcNoKObqKm/uLTewiuVbshhXsR5tPjOHOs3fMWo2T06zA82PcugC
         gMeSLtATPh8MENif3j4Az444YU/dMV7UOPfL/JLePxX1j/jPgaB6tzDFXf7LVGubuMHj
         2SPo26fThFlbZC6ORAF3oe9EYpk4maNN64nbJXLHILV6u9V3cw91sYkgipTe5e/PTl5i
         hyNnsDDOG5dkiIthJqOlfunZjz9dVEMHTzl2Aa3TKQdbhiXLUhvqC6hBeuYOy6WUM4xU
         VtHSow1nKQTiVACq8oW1tLdXBgXK/a5tZ8XslvDdyespVe+HjPvtPeJyTYRMUQUb+mx7
         UU+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXRc49+HxdL6B0a1XK7vUwSU9q4hovMmQNV2rKTiHDw88QyY6FdadDIdqJ4erur2lf61bUJhF4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwBnJEEqq+YTNjvrDuxVKYEAMFvoX+FgHxxAhE7uOqLPYJAv1Zd
	eooJl5WILAFDzIE7BrnW4u0EKg1F5elX9INhlIlFmbzfcM/nXKAuK+vaC3G2FLYTp3SeR4999BQ
	UiSjkePhCTIKBzCQsKoyUi97Mig==
X-Google-Smtp-Source: AGHT+IEzT1wnDgAQ96OJkbudRajHKCKUOzyR2rX0XafuH6cZli5Gqftia2M8Ig1EJNOLt/wms6hYjIofKHvZFHa92Q==
X-Received: from ilbbc25.prod.google.com ([2002:a05:6e02:99:b0:3df:40c1:c1ac])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1748:b0:3df:3be7:59d1 with SMTP id e9e14a558f8ab-3df4ab87f69mr10145295ab.11.1750968367035;
 Thu, 26 Jun 2025 13:06:07 -0700 (PDT)
Date: Thu, 26 Jun 2025 20:04:51 +0000
In-Reply-To: <20250626200459.1153955-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250626200459.1153955-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626200459.1153955-16-coltonlewis@google.com>
Subject: [PATCH v3 15/22] KVM: arm64: Setup MDCR_EL2 to handle a partitioned PMU
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Setup MDCR_EL2 to handle a partitioned PMU. That means calculate an
appropriate value for HPMN instead of the maximum setting the host
allows (which implies no partition) so hardware enforces that a guest
will only see the counters in the guest partition.

With HPMN set, we can now leave the TPM and TPMCR bits unset unless
FGT is not available, in which case we need to fall back to that.

Also, if available, set the filtering bits HPMD and HCCD to be extra
sure nothing counts at EL2.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_pmu.h | 11 ++++++
 arch/arm64/kvm/debug.c           | 23 ++++++++++---
 arch/arm64/kvm/pmu-part.c        | 57 ++++++++++++++++++++++++++++++++
 3 files changed, 86 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index 62c8032a548f..35674879aae0 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -96,6 +96,9 @@ u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
 void kvm_pmu_host_counters_enable(void);
 void kvm_pmu_host_counters_disable(void);
 
+u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu);
+u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu);
+
 #if !defined(__KVM_NVHE_HYPERVISOR__)
 bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu);
@@ -158,6 +161,14 @@ static inline bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu)
 {
 	return false;
 }
+static inline u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+static inline u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
 static inline void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu,
 					     u64 select_idx, u64 val) {}
 static inline void kvm_pmu_set_counter_value_user(struct kvm_vcpu *vcpu,
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index a554c3e368dc..b420fec3c754 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -37,15 +37,28 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
 	 * to disable guest access to the profiling and trace buffers
 	 */
-	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN,
-					 *host_data_ptr(nr_event_counters));
-	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
-				MDCR_EL2_TPMS |
-				MDCR_EL2_TTRF |
+	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN, kvm_pmu_hpmn(vcpu));
+	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TTRF |
 				MDCR_EL2_TPMCR |
 				MDCR_EL2_TDRA |
 				MDCR_EL2_TDOSA);
 
+	if (kvm_vcpu_pmu_is_partitioned(vcpu)
+	    && is_pmuv3p1(read_pmuver())) {
+		/*
+		 * Filtering these should be redundant because we trap
+		 * all the TYPER and FILTR registers anyway and ensure
+		 * they filter EL2, but set the bits if they are here.
+		 */
+		vcpu->arch.mdcr_el2 |= MDCR_EL2_HPMD;
+
+		if (is_pmuv3p5(read_pmuver()))
+			vcpu->arch.mdcr_el2 |= MDCR_EL2_HCCD;
+	}
+
+	if (!kvm_vcpu_pmu_use_fgt(vcpu))
+		vcpu->arch.mdcr_el2 |= MDCR_EL2_TPM | MDCR_EL2_TPMCR;
+
 	/* Is the VM being debugged by userspace? */
 	if (vcpu->guest_debug)
 		/* Route all software debug exceptions to EL2 */
diff --git a/arch/arm64/kvm/pmu-part.c b/arch/arm64/kvm/pmu-part.c
index 92775e19cbf6..f954d2d29314 100644
--- a/arch/arm64/kvm/pmu-part.c
+++ b/arch/arm64/kvm/pmu-part.c
@@ -137,3 +137,60 @@ void kvm_pmu_host_counters_disable(void)
 	mdcr &= ~MDCR_EL2_HPME;
 	write_sysreg(mdcr, mdcr_el2);
 }
+
+/**
+ * kvm_pmu_guest_num_counters() - Number of counters to show to guest
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Calculate the number of counters to show to the guest via
+ * PMCR_EL0.N, making sure to respect the maximum the host allows,
+ * which is hpmn_max if partitioned and host_max otherwise.
+ *
+ * Return: Valid value for PMCR_EL0.N
+ */
+u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu)
+{
+	u8 nr_cnt = vcpu->kvm->arch.nr_pmu_counters;
+	int hpmn_max = vcpu->kvm->arch.arm_pmu->hpmn_max;
+	u8 host_max = *host_data_ptr(nr_event_counters);
+
+	if (kvm_vcpu_pmu_is_partitioned(vcpu)) {
+		if (nr_cnt <= hpmn_max && nr_cnt <= host_max)
+			return nr_cnt;
+		if (hpmn_max <= host_max)
+			return hpmn_max;
+	}
+
+	if (nr_cnt <= host_max)
+		return nr_cnt;
+
+	return host_max;
+}
+
+/**
+ * kvm_pmu_hpmn() - Calculate HPMN field value
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Calculate the appropriate value to set for MDCR_EL2.HPMN, ensuring
+ * it always stays below the number of counters on the current CPU and
+ * above 0 unless the CPU has FEAT_HPMN0.
+ *
+ * This function works whether or not the PMU is partitioned.
+ *
+ * Return: A valid HPMN value
+ */
+u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
+{
+	u8 hpmn = kvm_pmu_guest_num_counters(vcpu);
+	int hpmn_max = vcpu->kvm->arch.arm_pmu->hpmn_max;
+	u8 host_max = *host_data_ptr(nr_event_counters);
+
+	if (hpmn == 0 && !cpus_have_final_cap(ARM64_HAS_HPMN0)) {
+		if (kvm_vcpu_pmu_is_partitioned(vcpu))
+			return hpmn_max;
+		else
+			return host_max;
+	}
+
+	return hpmn;
+}
-- 
2.50.0.727.gbf7dc18ff4-goog

