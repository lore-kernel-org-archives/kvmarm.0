Received: from mail-oi1-f202.google.com (mail-oi1-f202.google.com [209.85.167.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC8BE32143D
	for <kvmarm@lists.linux.dev>; Mon,  9 Feb 2026 22:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770676859; cv=none; b=WinSL2d9yzvBgqjtHQtsfS+l4xIYpa1mybY5NaU4+jwCtc93VDux0QDg60sVDys2wDMVYdy/W+nlaQCjbj1DZgS3+GojJqqJPapywWVTfLopBjJsOgBz3VnQ61lpyHfRBP1p0fY9Bgb96053r5mn7lKuZvX2tTGBeNlxRrMfr1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770676859; c=relaxed/simple;
	bh=ssl/5MqNa1agAhX4GvIbWHZqFYEeaev35rRVg6Go1qI=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kFeTGAZyINRzklmiJWTI9JO2TPzF7RhnRM3dcB5ZIoSZWMaOyC5r4TqCcBh51BHCcQI8zzdgoOKFCW4GG+KgIeMZzHcbocVPz/XJ7BVtS3BNhj69bZGwJvnDTJZktdq6BWP/DNndUwkRrxdgeNHYRhBz8gVKPpc8oebZgGVKotE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I2MDeEmi; arc=none smtp.client-ip=209.85.167.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I2MDeEmi"
Received: by mail-oi1-f202.google.com with SMTP id 5614622812f47-45ee72d15f7so877992b6e.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Feb 2026 14:40:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770676855; x=1771281655; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DzFE4miTcOtAr/dPUTYbZiH7kW5NfaMHCMboYuCvXco=;
        b=I2MDeEmi03+5n/DAmK6TVKpSC3IlCW/R9WQw5ZdM97nCX5f4O5YYlN39Co8Lw9UDqY
         u4FTkY9b6agbJWgu2zWrNhNeLgaOmlM4NZDtW5ZkavJoVLuwdXmdsFv/bkZ6m/4Hlf1n
         Me5cXeZoO61n0Q/Za/FHmFkB8hSF0z9ookilOuNJjAQnnWAGkgLLBLchHjzvPgc35CII
         MWDq3B3eWDWYsZgZSm1ApKIotsRcEn/gWZGmGXo5yd7u4OHa7OGYbg2O7aUaZVvASAuu
         gccf8/Ytm9yFYJ+PdM3MnGX0H83ozxCJj3N3rKLXOY6oMND61yNmjGTCOxYl1JmfSpsZ
         V0SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770676855; x=1771281655;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DzFE4miTcOtAr/dPUTYbZiH7kW5NfaMHCMboYuCvXco=;
        b=i+32bFQI39+0IrzsO+23fTx2nqffn3hRHnC525xiog6L7I1T1gylgfWocz1idcUnPT
         bTLYdVAoNwd5A0N04y6uZ0hJ6zDlHSGA9cUj4h1ynnqMrN+IvHrFiv/EaANTYNnBZ8U7
         g5EghLWVjao7XvU4i4qNUNAuFsqQmQ/ODVhGgjLicu/BxPbOXBG+P9ax7hNDPY0XmrB/
         2FJ9E8PTu8Iu44s8ubH4sjB9Qrk72FWH4fQFhJjTCKBpLIBk0ZdGHH23TdpTQvIQaBpH
         JoKC/zN+zH0WXRYluSF8J3nInw5axYzmJ4RI8+44DWk2wnUHQXw4rQ51zAJxkO4kX87+
         Suvw==
X-Forwarded-Encrypted: i=1; AJvYcCXpUHVEdMZN827FmHAJxX8lzv2rSK/zSMjIzwiq/n4AjdTXy0MHDEbj0nW03fsO1fGO4HxQ9Sc=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx47x0tRtuIJjLkD2Q6KCgFBMosHTwo8rEeBk7csk2Q5D3QPxvg
	oeR1OEFa33ienTya3WtWw2KgQ++yRFo0JjduV24Y+q5CXgfXffDsjtlnV59wiQ+DpZUodNrs3yl
	JLEBUDV0dOUBMVZf4d5gibBZ7Zw==
X-Received: from iozc9.prod.google.com ([2002:a05:6602:3349:b0:957:7945:e822])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:1610:b0:66b:ea2:afa with SMTP id 006d021491bc7-66d09f9c4bbmr4972919eaf.20.1770676854816;
 Mon, 09 Feb 2026 14:40:54 -0800 (PST)
Date: Mon,  9 Feb 2026 22:14:05 +0000
In-Reply-To: <20260209221414.2169465-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260209221414.2169465-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209221414.2169465-11-coltonlewis@google.com>
Subject: [PATCH v6 10/19] KVM: arm64: Setup MDCR_EL2 to handle a partitioned PMU
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

Setup MDCR_EL2 to handle a partitioned PMU. That means calculate an
appropriate value for HPMN instead of the default maximum setting the
host allows (which implies no partition) so hardware enforces that a
guest will only see the counters in the guest partition.

Setting HPMN to a non default value means the global enable bit for
the host counters is now MDCR_EL2.HPME instead of the usual
PMCR_EL0.E. Enable the HPME bit to allow the host to count guest
events. Since HPME only has an effect when HPMN is set which we only
do for the guest, it is correct to enable it unconditionally here.

Unset the TPM and TPMCR bits, which trap all PMU accesses, if
FGT (fine grain trapping) is being used.

If available, set the filtering bits HPMD and HCCD to be extra sure
nothing in the guest counts at EL2.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/debug.c      | 29 ++++++++++++++++++++++++++---
 arch/arm64/kvm/pmu-direct.c | 24 ++++++++++++++++++++++++
 arch/arm64/kvm/pmu.c        |  7 +++++++
 include/kvm/arm_pmu.h       | 11 +++++++++++
 4 files changed, 68 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 3ad6b7c6e4ba7..0ab89c91e19cb 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -36,20 +36,43 @@ static int cpu_has_spe(u64 dfr0)
  */
 static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 {
+	int hpmn = kvm_pmu_hpmn(vcpu);
+
 	preempt_disable();
 
 	/*
 	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
 	 * to disable guest access to the profiling and trace buffers
 	 */
-	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN,
-					 *host_data_ptr(nr_event_counters));
+
+	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN, hpmn);
 	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
 				MDCR_EL2_TPMS |
 				MDCR_EL2_TTRF |
 				MDCR_EL2_TPMCR |
 				MDCR_EL2_TDRA |
-				MDCR_EL2_TDOSA);
+				MDCR_EL2_TDOSA |
+				MDCR_EL2_HPME);
+
+	if (kvm_vcpu_pmu_is_partitioned(vcpu)) {
+		/*
+		 * Filtering these should be redundant because we trap
+		 * all the TYPER and FILTR registers anyway and ensure
+		 * they filter EL2, but set the bits if they are here.
+		 */
+		if (is_pmuv3p1(read_pmuver()))
+			vcpu->arch.mdcr_el2 |= MDCR_EL2_HPMD;
+		if (is_pmuv3p5(read_pmuver()))
+			vcpu->arch.mdcr_el2 |= MDCR_EL2_HCCD;
+
+		/*
+		 * Take out the coarse grain traps if we are using
+		 * fine grain traps.
+		 */
+		if (kvm_vcpu_pmu_use_fgt(vcpu))
+			vcpu->arch.mdcr_el2 &= ~(MDCR_EL2_TPM | MDCR_EL2_TPMCR);
+
+	}
 
 	/* Is the VM being debugged by userspace? */
 	if (vcpu->guest_debug)
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 275bd4156871e..f2e6b1eea8bd6 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -139,3 +139,27 @@ void kvm_pmu_host_counters_disable(void)
 	mdcr &= ~MDCR_EL2_HPME;
 	write_sysreg(mdcr, mdcr_el2);
 }
+
+/**
+ * kvm_pmu_hpmn() - Calculate HPMN field value
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Calculate the appropriate value to set for MDCR_EL2.HPMN. If
+ * partitioned, this is the number of counters set for the guest if
+ * supported, falling back to max_guest_counters if needed. If we are not
+ * partitioned or can't set the implied HPMN value, fall back to the
+ * host value.
+ *
+ * Return: A valid HPMN value
+ */
+u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
+{
+	u8 nr_guest_cntr = vcpu->kvm->arch.nr_pmu_counters;
+
+	if (kvm_vcpu_pmu_is_partitioned(vcpu)
+	    && !vcpu_on_unsupported_cpu(vcpu)
+	    && (cpus_have_final_cap(ARM64_HAS_HPMN0) || nr_guest_cntr > 0))
+		return nr_guest_cntr;
+
+	return *host_data_ptr(nr_event_counters);
+}
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 344ed9d8329a6..b198356d772ca 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -542,6 +542,13 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
 	if (cpus_have_final_cap(ARM64_WORKAROUND_PMUV3_IMPDEF_TRAPS))
 		return 1;
 
+	/*
+	 * If partitioned then we are limited by the max counters in
+	 * the guest partition.
+	 */
+	if (kvm_pmu_is_partitioned(arm_pmu))
+		return arm_pmu->max_guest_counters;
+
 	/*
 	 * The arm_pmu->cntr_mask considers the fixed counter(s) as well.
 	 * Ignore those and return only the general-purpose counters.
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index f21439000129b..8fab533fa3ebc 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -98,6 +98,9 @@ u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
 void kvm_pmu_host_counters_enable(void);
 void kvm_pmu_host_counters_disable(void);
 
+u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu);
+u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu);
+
 #if !defined(__KVM_NVHE_HYPERVISOR__)
 bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu);
@@ -162,6 +165,14 @@ static inline bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu)
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
-- 
2.53.0.rc2.204.g2597b5adb4-goog

