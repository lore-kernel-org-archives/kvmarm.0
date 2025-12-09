Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF24E306486
	for <kvmarm@lists.linux.dev>; Tue,  9 Dec 2025 20:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765313573; cv=none; b=gkw7CX5gzl8Hyy7GQ3e2Ps9oHQt54HUfZK+zPjf2bCOx0z3qT6O7IY8+fRq9LjWtdKii3v3LurQ13d/uyVnS1m7tbNbuFy4BKuShtpe098mbotP/80Fu40gWBw6aR4QvbI8ACEBWzZEHe6JP98bkpIJKQDKiwrEbYH/vKmwe7gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765313573; c=relaxed/simple;
	bh=vH4vToO1Kn0jUWaD9r2NByPEBh2j2Tq7llj3z+1eFKA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=ZU8HRUhVUKx8PoiKa4NO72hFRdFTJcA5lvH8egVCNI0Y/nKQnliwudWVmu3o5VXyGg3E60AtgMLD4C0ELxhFqfpUgTJkngvH+UeSmsMa3nGrceToahir4M/gJA5xmiDfZ5jLoMW51BxfX/t8SOpxTXzGpKyHO7USs78L4sHO7C4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=STBZ+p+l; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="STBZ+p+l"
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7cacaa675feso1161246a34.3
        for <kvmarm@lists.linux.dev>; Tue, 09 Dec 2025 12:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765313561; x=1765918361; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I7rslOWyfBKryoyVeAdT+vyRO2ASxcyyBGT1wwSBsKE=;
        b=STBZ+p+lQvkzXXKblrGMLmTCssIJdf5y+prWZCATvum8VykEAVYy/ISB/cuMqWXYc/
         r/QnDbmhbUGt9s7b55YbjyJ08vrCUcnwS+sMSNaazhAxLQzC/lu3SlfJirpFIbLY6etj
         AR84V7BkYNkTvfaAtiwMCMh+XckGITPOzWQ5qxafDt1Cdf0Pcv2yK4HfTh4hql5U/c5V
         qLw7o/UTJN/kkG+jNZjHayF3bzcm3fZKpLQMiRe4BnDkR27v6nUhQwhldPxT0mfUuEYB
         us1ry6epgRX9+uOCoypYEx9rrJIfqNZarsONEDk88pXef5411XyoPy4aKt7ZxLEqJ4a1
         /ixQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765313561; x=1765918361;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I7rslOWyfBKryoyVeAdT+vyRO2ASxcyyBGT1wwSBsKE=;
        b=TT81N8dsjRmN5s8Ssca3PtoiNpi9r++6Niq3ebqArXU6CtMch2SRSXZoG5QY4zeDw/
         srxQR0rashDl4XhfKhCYc3wzQIMtu1biNWdZA2KNVYLbmIdnTjM4XGpFDpJNKHw91Wzs
         ij7bqPpw8Y069TVfeBqSQU77rnlgC7QTDdX+sn8UTWauiVujR+4cuHXFC/Tgp2TzwQMn
         GmqucvvzwmZI+r7q0D/IuHpNOQ0GL3ItdMxOenvZt3FNbYVYQXQampS0AOZpq0yrJzn/
         HtLW+Al7MKJQRYT1VLyxieD/U05znQ3ntuyiQW7gps5v8W6BLu9lFklW+m/bvlXj7fZC
         bxhQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXaptJMWQJaqRg/Z9wYGgx3lfBU9kfObXztpVrAAch1gm7Ho9ddC7IM/YrFeDjPukc2uOmiJI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1OE5kBeb5vNEQhmauyWgB+ri/PEhCx6xyxbWx16Tk95JiSY3P
	xxCQnzDPSu5DcH7nARZRmFLVB4RF1uLwil8IT0Ztw/T8JcmOpDefRuMuaDsBq+DyIeA/SOwl6Kh
	5H8iRo98lXd2YkGGAL0DNMmhmUw==
X-Google-Smtp-Source: AGHT+IFdNtZkxvJxJ9KoIinFxTXoYCnJbZauUeKj4oIMf+rqE8iUac1MGIbX45NhV6sJzZWUdWJoByDmtDg2d29Vpw==
X-Received: from ilbbc25.prod.google.com ([2002:a05:6e02:99:b0:434:972f:bf92])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:4cc2:b0:659:9a49:9050 with SMTP id 006d021491bc7-65b2ac45517mr108480eaf.27.1765313561253;
 Tue, 09 Dec 2025 12:52:41 -0800 (PST)
Date: Tue,  9 Dec 2025 20:51:12 +0000
In-Reply-To: <20251209205121.1871534-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20251209205121.1871534-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.52.0.239.gd5f0c6e74e-goog
Message-ID: <20251209205121.1871534-16-coltonlewis@google.com>
Subject: [PATCH v5 15/24] KVM: arm64: Setup MDCR_EL2 to handle a partitioned PMU
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
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
 arch/arm64/include/asm/kvm_pmu.h | 11 ++++++
 arch/arm64/kvm/debug.c           | 29 ++++++++++++--
 arch/arm64/kvm/pmu-direct.c      | 65 ++++++++++++++++++++++++++++++++
 3 files changed, 102 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index 60b8a48cad456..8b634112eded2 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -101,6 +101,9 @@ u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
 void kvm_pmu_host_counters_enable(void);
 void kvm_pmu_host_counters_disable(void);
 
+u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu);
+u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu);
+
 #if !defined(__KVM_NVHE_HYPERVISOR__)
 bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu);
@@ -173,6 +176,14 @@ static inline u64 kvm_pmu_fgt2_bits(void)
 {
 	return 0;
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
index 4dd160c878862..7fb4fb5c22e2a 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -154,3 +154,68 @@ void kvm_pmu_host_counters_disable(void)
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
+	int hpmn_max = armv8pmu_hpmn_max;
+	u8 host_max = *host_data_ptr(nr_event_counters);
+
+	if (vcpu->kvm->arch.arm_pmu)
+		hpmn_max = vcpu->kvm->arch.arm_pmu->hpmn_max;
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
+ * Calculate the appropriate value to set for MDCR_EL2.HPMN. If
+ * partitioned, this is the number of counters set for the guest if
+ * supported, falling back to hpmn_max if needed. If we are not
+ * partitioned or can't set the implied HPMN value, fall back to the
+ * host value.
+ *
+ * Return: A valid HPMN value
+ */
+u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu)
+{
+	u8 nr_guest_cnt = kvm_pmu_guest_num_counters(vcpu);
+	int nr_guest_cnt_max = armv8pmu_hpmn_max;
+	u8 nr_host_cnt_max = *host_data_ptr(nr_event_counters);
+
+	if (vcpu->kvm->arch.arm_pmu)
+		nr_guest_cnt_max = vcpu->kvm->arch.arm_pmu->hpmn_max;
+
+	if (kvm_vcpu_pmu_is_partitioned(vcpu)) {
+		if (cpus_have_final_cap(ARM64_HAS_HPMN0))
+			return nr_guest_cnt;
+		else if (nr_guest_cnt > 0)
+			return nr_guest_cnt;
+		else if (nr_guest_cnt_max > 0)
+			return nr_guest_cnt_max;
+	}
+
+	return nr_host_cnt_max;
+}
-- 
2.52.0.239.gd5f0c6e74e-goog

