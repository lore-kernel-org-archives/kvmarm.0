Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5E5328B7B
	for <kvmarm@lists.linux.dev>; Mon,  9 Feb 2026 22:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770676865; cv=none; b=I5UgoWSB1cN9qLn2tOqTQ9FIEhkSrkM+jM8fJw8NUjeCcsrVPMDTHNvWjy3e1ZlZmPOZZ16vg5E6tQ3ZOidfg0U8DZbtUc7xPvCJFDMglN1YiCjOMXOIeiWl3WmFb0/Pkmu9QORUof757Lf5uefZ9R5L83hhgs7kN5yGhEy+mpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770676865; c=relaxed/simple;
	bh=RowRt03ThgQKuNhhFZ3YMhl1qn0omKfjfEtkXkjMK7g=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=G1n+PrzZ+RN6Flqtcni06ea/PIJx/qyfaZ3c2PVaxCfRLjfLZHvdkVlPbxrWzIHL27jubpfoYbh6Q3E7JJB7SLlBXl/ueyzW/2Fcckb4Hm5GGemahLJAx5X3TJ51dV05+vVmnsNLOSEpvnt7KRNhYwpBPFwsiFcNiB7UUDJCvik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WoENMEEm; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WoENMEEm"
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-66317aad908so12089259eaf.3
        for <kvmarm@lists.linux.dev>; Mon, 09 Feb 2026 14:41:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770676860; x=1771281660; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xtvZ/CVAyvlBIyi+KC1xnXowl3JGTClEkFZx5dHECQw=;
        b=WoENMEEmxV5GXo8aPtPUkjdLnd8gtL7J6TwsxscemYa/foAJeXB5DPvike1BAg+R62
         vzxGsIPKWtdgIIe3JEQJ5za1j3HM9T53jVLy78Z//pB2z3LbJMwgbGVcVU5fcphnQx/g
         WWzO11qk6G95zk6AtXgjSrlyHXwXpc8JDasgY6ZvtQSsmkJ/OyIhDDDHxPFHO2J7MkH9
         A9KOmufzAl325e72bhkgF+O0wsyI8Jmu2DIt22sV2VFIWynXcla0sGwZoTdGjbS5kJPn
         CFKzYp30ZloWYak+vF3Y6Uqj2uAz/E8UFTMU4010Qb3GaLAzIZ9EHYRqsjnMaDsZv8Zq
         0aIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770676860; x=1771281660;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xtvZ/CVAyvlBIyi+KC1xnXowl3JGTClEkFZx5dHECQw=;
        b=js5LSvf2788nA6Rr3Pt9eS2nAOOhAdZFq7fUXgw+SpG9JCKepRKisj8t4kGlHjpWk1
         AUjxIER1BcMXRZBvxqp/feMFWXFTjcbVWUDkAodw3YPdScscNbDIQE/h9cABaxO+nNoQ
         FJgHkPGcaVPgxJLQIX6LumnteKWs5Y3G4IEuIitnoQh0Aq2IoYSfelJ6CnfgUbRCwUTj
         eYoGyqZZFqd14NISTpb5fuvoaPGBJtNCoHgb4iDBiLeJbZLMr472UeLtxCiIZSNGRTH+
         YgLMbtRk5J6HF8P91Wta6ZjkInQTwI42yAC5xxNN1WqMm64bqZoW1XSi8dE+EADxee2t
         wpsQ==
X-Forwarded-Encrypted: i=1; AJvYcCV2HvsCrnYU0xhEpR5KEZTyHQN9naXJkVkklyUkIIC//n45vfE+FaZtkamHwh0DIeIzOMMlIo8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVPcELN1X6fZJhmcrsYg7fkplvR1KTRPDsoKZunXHIIHhFo1Ut
	GNNp1oTzr8pnulibhuWKljKc3bR+F3QT4dZvFWWA4oOit47pkccav21jcsJ4l4doLYvb37/f0NB
	kfxbIB2rv9kJdRVg/tGFWI2pk5A==
X-Received: from ilbbg8.prod.google.com ([2002:a05:6e02:3108:b0:482:7936:419f])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:4913:b0:662:fa75:d6df with SMTP id 006d021491bc7-672fdc0a914mr57705eaf.12.1770676860543;
 Mon, 09 Feb 2026 14:41:00 -0800 (PST)
Date: Mon,  9 Feb 2026 22:14:10 +0000
In-Reply-To: <20260209221414.2169465-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260209221414.2169465-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209221414.2169465-16-coltonlewis@google.com>
Subject: [PATCH v6 15/19] KVM: arm64: Detect overflows for the Partitioned PMU
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

When we re-enter the VM after handling a PMU interrupt, calculate
whether it was any of the guest counters that overflowed and inject an
interrupt into the guest if so.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-direct.c | 30 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/pmu-emul.c   |  4 ++--
 arch/arm64/kvm/pmu.c        |  6 +++++-
 include/kvm/arm_pmu.h       |  2 ++
 4 files changed, 39 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 79d13a0aa2fd6..6ebb59d2aa0e7 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -378,3 +378,33 @@ void kvm_pmu_handle_guest_irq(struct arm_pmu *pmu, u64 pmovsr)
 
 	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, govf);
 }
+
+/**
+ * kvm_pmu_part_overflow_status() - Determine if any guest counters have overflowed
+ * @vcpu: Pointer to struct kvm_vcpu
+ *
+ * Determine if any guest counters have overflowed and therefore an
+ * IRQ needs to be injected into the guest. If access is still free,
+ * then the guest hasn't accessed the PMU yet so we know the guest
+ * context is not loaded onto the pCPU and an overflow is impossible.
+ *
+ * Return: True if there was an overflow, false otherwise
+ */
+bool kvm_pmu_part_overflow_status(struct kvm_vcpu *vcpu)
+{
+	struct arm_pmu *pmu;
+	u64 mask, pmovs, pmint, pmcr;
+	bool overflow;
+
+	if (vcpu->arch.pmu.access == VCPU_PMU_ACCESS_FREE)
+		return false;
+
+	pmu = vcpu->kvm->arch.arm_pmu;
+	mask = kvm_pmu_guest_counter_mask(pmu);
+	pmovs = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
+	pmint = read_pmintenset();
+	pmcr = read_pmcr();
+	overflow = (pmcr & ARMV8_PMU_PMCR_E) && (mask & pmovs & pmint);
+
+	return overflow;
+}
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index a40db0d5120ff..c5438de3e5a74 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -268,7 +268,7 @@ void kvm_pmu_reprogram_counter_mask(struct kvm_vcpu *vcpu, u64 val)
  * counter where the values of the global enable control, PMOVSSET_EL0[n], and
  * PMINTENSET_EL1[n] are all 1.
  */
-bool kvm_pmu_overflow_status(struct kvm_vcpu *vcpu)
+bool kvm_pmu_emul_overflow_status(struct kvm_vcpu *vcpu)
 {
 	u64 reg = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
 
@@ -405,7 +405,7 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
 		kvm_pmu_counter_increment(vcpu, BIT(idx + 1),
 					  ARMV8_PMUV3_PERFCTR_CHAIN);
 
-	if (kvm_pmu_overflow_status(vcpu)) {
+	if (kvm_pmu_emul_overflow_status(vcpu)) {
 		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
 
 		if (!in_nmi())
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index b198356d772ca..72d5b7cb3d93e 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -408,7 +408,11 @@ static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	bool overflow;
 
-	overflow = kvm_pmu_overflow_status(vcpu);
+	if (kvm_vcpu_pmu_is_partitioned(vcpu))
+		overflow = kvm_pmu_part_overflow_status(vcpu);
+	else
+		overflow = kvm_pmu_emul_overflow_status(vcpu);
+
 	if (pmu->irq_level == overflow)
 		return;
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 3d922bd145d4e..93586691a2790 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -90,6 +90,8 @@ bool kvm_set_pmuserenr(u64 val);
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_resync_el0(void);
+bool kvm_pmu_emul_overflow_status(struct kvm_vcpu *vcpu);
+bool kvm_pmu_part_overflow_status(struct kvm_vcpu *vcpu);
 
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))
-- 
2.53.0.rc2.204.g2597b5adb4-goog

