Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC6C23BF80
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 22:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750457938; cv=none; b=jbyLeBbZw0jDknJnSmhFpIirU+iRBcxj9YVXvJUsRl+hctcVTjZorO/q6CM7mpgc60u8xPI0al5qgH+LX+mBcdNc9Ab5g+pP4mzio0wEs15tx5YxuXtm+OdaOZv1x/ncHeXsUXX0uWyGtCSzGok2zc+8Cw5L0gRtlBSvmlk1T6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750457938; c=relaxed/simple;
	bh=V8F6QXbKZ5qjKUOB8cB6Qj1Bq4o1xFCNUWAnMMd+Y5c=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=VhovPLW+k41miFOYyGYOPfv693hNMjV5AHiY303UE9KhgNpuobPjTytud4dUBvadAHaGxTzdJge6rScK09MDosSdlUHyBX3jRyGdxSmD96gf+QLlDfI7IwSsQQRDRi3I9CUfK6hK4kIBx8RHa/XO4rmqUADS8rJ+JRol2G7DEYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2bD++Rmh; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2bD++Rmh"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-8754cf2d6e2so196098639f.3
        for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 15:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750457934; x=1751062734; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=cZyFqXYBMWnJqAFxJ0Fisis6DfGC/d8Ag5of3Smukjk=;
        b=2bD++Rmh8lPhQJK3iXB2JyQzHGoU1R+2I+m8+gH2QV+NbSKcruYLVAV3mdoSP16QSe
         9i99/Q3+DY1hIUOdAaDLOVtK+1vECsJXXXHJ2ai3T/nzVaLl7grCxlLjVw/dpSnHZAPt
         x3gaAuzm2S++RB39rEQX3TePjEnFmd0MdE/fIFxm0vvTKA9UaCUo+jpqQZ5pfxfFIh2+
         G7kgZ8J+SNQ4rEmSCEmOhufILUe1ePBCjrnqvvdwjF92XjWs1HEc/6w1G/e6k+baan3y
         VNkCKMxD2QGSgXi8WjdvGUy/oCy5R2djoi5drVp27ZXS5UNY9a5P/RB5Dp+AASxNzQx5
         ZzlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750457934; x=1751062734;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cZyFqXYBMWnJqAFxJ0Fisis6DfGC/d8Ag5of3Smukjk=;
        b=WUVv6cq5mSVCZf1y1JDBgz6uZOSTDShM4YSc5YeyxtOMposAYQdv7wu64ZN5XfeutT
         dvbRHu6DhWubvatG+h55I+J3IK6css0pr+7TN1wUT/tSpGWI89YozTqsMbVmEIc4luL5
         Nhhx+5dITssxV6zpAnFCWDzlgKTUr7clz0BaOHcp46L1cGk1Ru+mWwSweAHYTygcOWPD
         2aqsB1UMVGzNHwywUqhgGiKvlISJaJjvgs1nhizLd8G4cYOZrq8zUfg7slj0hZ9JGWTg
         LjOt16PeFFiRmkhK/h+wMef5UKneiJ6DpEhhHTPVfyPapIDoK72kOPtGSWAPbco4n//N
         9HYw==
X-Forwarded-Encrypted: i=1; AJvYcCVQVRH7rQA5vbldp+ctjg9K4vjFvs0rurX8bxz2A+l8pP1ZxT3LQt5y6YBq6A2bYMVVSw9HPIA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwsUe/Cd2Z/XJoRtmCxXxLjRnqWJZ9NModwHvN6mWgazRURts/j
	xvaAMgSFCaPL2XL0PKauwv4gaoc2HeR3Hgb+F1D51zlTCV/bBoevZMg9+DQ6LNWVVePFOZJQK6s
	4/Ea4ceOHo00l4nSk86hBSdvgWA==
X-Google-Smtp-Source: AGHT+IHH9vAF0PeeIga9bJPbVv5gkEIZ1wU4Ll5A3y00fis/xcMt2D7wL+QOVfQw74a3+dOyehd4c5Bz0GZvUuruOg==
X-Received: from ilbdd7.prod.google.com ([2002:a05:6e02:3d87:b0:3dc:a0cf:cd86])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:178e:b0:3dd:b4f4:2bcc with SMTP id e9e14a558f8ab-3de38c986b2mr44226395ab.13.1750457934106;
 Fri, 20 Jun 2025 15:18:54 -0700 (PDT)
Date: Fri, 20 Jun 2025 22:13:17 +0000
In-Reply-To: <20250620221326.1261128-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250620221326.1261128-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <20250620221326.1261128-18-coltonlewis@google.com>
Subject: [PATCH v2 16/23] KVM: arm64: Setup MDCR_EL2 to handle a partitioned PMU
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
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
 arch/arm64/include/asm/kvm_pmu.h |  3 ++
 arch/arm64/kvm/debug.c           | 23 ++++++++++---
 arch/arm64/kvm/pmu-part.c        | 57 ++++++++++++++++++++++++++++++++
 arch/arm64/kvm/pmu.c             |  2 +-
 4 files changed, 79 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index 4e205327b94e..1b68f1a706d1 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -94,6 +94,9 @@ u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
 void kvm_pmu_host_counters_enable(void);
 void kvm_pmu_host_counters_disable(void);
 
+u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu);
+u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu);
+
 #if !defined(__KVM_NVHE_HYPERVISOR__)
 bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu);
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
index 269397a1fcbc..289f396bd887 100644
--- a/arch/arm64/kvm/pmu-part.c
+++ b/arch/arm64/kvm/pmu-part.c
@@ -118,3 +118,60 @@ void kvm_pmu_host_counters_disable(void)
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
+	u8 hpmn_max = vcpu->kvm->arch.arm_pmu->hpmn_max;
+	u8 nr_cnt = vcpu->kvm->arch.nr_pmu_counters;
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
+	u8 hpmn_max = vcpu->kvm->arch.arm_pmu->hpmn_max;
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
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 67216451b8ce..90fc088ce3d3 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -884,7 +884,7 @@ u64 kvm_pmu_accessible_counter_mask(struct kvm_vcpu *vcpu)
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 {
 	u64 pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
-	u64 n = vcpu->kvm->arch.nr_pmu_counters;
+	u64 n = kvm_pmu_hpmn(vcpu);
 
 	if (vcpu_has_nv(vcpu) && !vcpu_is_el2(vcpu))
 		n = FIELD_GET(MDCR_EL2_HPMN, __vcpu_sys_reg(vcpu, MDCR_EL2));
-- 
2.50.0.714.g196bf9f422-goog

