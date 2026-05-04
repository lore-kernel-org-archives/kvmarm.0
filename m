Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955FF40244C
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 21:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777929525; cv=none; b=aF392EJAlInm1Ftxmi51X+BhLFacHls/ZVjMZiQwj597+44kKzuwCeLcTINiGwZHvPfzlXonlp+AH1AT3aMv3s1lBE8aXgzbueWd0a35mpjzhYZSAl/YzIf344A/NIO1CGDPiWsgglD+fA3nV5a1a3zGEXaJGi2FZ+647RrwfIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777929525; c=relaxed/simple;
	bh=Ju4hEvbWQIxue7C0GzlmuOc4hIQ+zS118FGwzfP52DY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tBCCr4mn3Zk7dpLlC2cwPR6Vy9biQjXadyTXir/88V+EM0tCI8DmyKupcu+Qeyj9SzxQEBq5F7sUaFfrX7VXFCPLnwRY45ZHyAXhNQ4FnVLAE1Fl1khDLfR604JW2ZBvrdiNVUWQ+KQKZzO18lhd1Mr5HIgE7kG/FOuPCXfaKTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=f8pQgeku; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="f8pQgeku"
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-7de75c9be4aso10763547a34.0
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 14:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777929519; x=1778534319; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2uXhxMRnzPluCmaQoLE1tgsrLMP2Ws4KNKFg4hBQdkY=;
        b=f8pQgekusMFTuww/exHZdvzggx6bHtdIZ3MGaPwSitZHqtlEYovJlw/2nNn7F/Gw5o
         JarNMVR0k3YyxPuLVNxcDIhIQ6nXld3YGwW85Kmg36J5kR2XaMvD7+Px5i+gBMBqHZH+
         wd5XHp2/rT0F7RRh8JE8JbwsYKnGNXowK8H+qND6EZMyNXGgBK7RgcSPgBUV+Y72S91H
         g2TD4ujhkWk5KyguSigj6B+cGidiiLCay3t9FcFy5Kh5IzX/zOAnEtkxlkf6obVDWDXX
         YWstIE8IgxsDlryK9p3pZPerL7WfjOHHqLN886jzojHf/wxuoJZzXZ08tMQtjaFwyMEj
         k0xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777929519; x=1778534319;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2uXhxMRnzPluCmaQoLE1tgsrLMP2Ws4KNKFg4hBQdkY=;
        b=W3P8HjcM35it3IkgQ1r9AXd1on5SstFQbwvAevl+iUh4eW3y7/ynz5dnLZlEPsIfOM
         7fRw9fsg6kmnZMI0DfXyJcIfjQb1xwD1CXeCLxqMq2ZvdvYC+Exz8BkXFlaWDfBWHHe9
         uWEdWjRzD8gkvFO7fAVk3jSf31BrznY/C83SJvsrxZd1rQhfEr1iyVybUNvpubdt/sCt
         yDDxod1MPRuHrIx1GVEgFlD7ZJ4rrB3vucU1KeiQhrjSVz1IvZrKES0Y4+Uv9oy1mRqE
         0xOJwJgu8NOTA7WyKy0AnkMlR9gNiK6qV8YMnihA02i88SVxcbaH4Dv+5R0XhyTgwf3D
         ftFQ==
X-Forwarded-Encrypted: i=1; AFNElJ/fIarU34m2RzRqxWP/2AHzh4yCWIytj8rv3nA+EzL8YTIjus2mv74bPBLgcToPtRFkqS5KVYw=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywe5vp29jN3PXowUb3ZzO7QgeOWu+JQU/M8PEE0+cYRAPcVbvWk
	vgbXHQ2gtug/QfJU2UvNvH62N/XezS0Q8UTd1WhnUftA0CYQzK72nb4pzAkMGmYsez8L2oJa8wI
	az2fufilLjUxPxlHtFFww+l+ACw==
X-Received: from ilsi9.prod.google.com ([2002:a05:6e02:549:b0:4fe:73ca:fda6])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a4a:e911:0:b0:684:188a:737d with SMTP id 006d021491bc7-6998d257e73mr177660eaf.44.1777929518793;
 Mon, 04 May 2026 14:18:38 -0700 (PDT)
Date: Mon,  4 May 2026 21:18:02 +0000
In-Reply-To: <20260504211813.1804997-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260504211813.1804997-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260504211813.1804997-10-coltonlewis@google.com>
Subject: [PATCH v7 09/20] KVM: arm64: Set up MDCR_EL2 to handle a Partitioned PMU
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	James Clark <james.clark@linaro.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Set up MDCR_EL2 to handle a Partitioned PMU. That means calculate an
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
index 2148bc46079c4..63ac72910e4b5 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -74,3 +74,27 @@ bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu)
 		cpus_have_final_cap(ARM64_HAS_FGT) &&
 		(hpmn != 0 || cpus_have_final_cap(ARM64_HAS_HPMN0));
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
index ee2f0f7e61bcf..8c10ad05661bc 100644
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
index c3987e0c01775..6aaeb27642540 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -94,6 +94,9 @@ void kvm_vcpu_pmu_resync_el0(void);
 
 bool kvm_pmu_is_partitioned(struct arm_pmu *pmu);
 
+u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu);
+u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu);
+
 #if !defined(__KVM_NVHE_HYPERVISOR__)
 bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu);
 bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu);
@@ -156,6 +159,14 @@ static inline bool kvm_vcpu_pmu_use_fgt(struct kvm_vcpu *vcpu)
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
2.54.0.545.g6539524ca2-goog

