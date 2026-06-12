Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC67E3D16E9
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 19:29:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781292574; cv=none; b=e78fE8vGUI91AlUpYTyKjqcb+AWszwFB4mq8/2drdyv2Nsbg7+heVYC2DALUMHNKbVGgH/DR8HHptuHDFmHHTNEwvMRUCQt3P7Iiks0L9I6MRLG+LYJSQfKceA4vRNiQlHD0kZBdA0lv1FiPSff1c04DMVSOqjpuTqt3Vl5CBDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781292574; c=relaxed/simple;
	bh=TjYRd0nJW/jKNkkVM+Lek1arEtrbddhEOegCE5t4QhE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p67ijzaCFTe8V++A8xxbKk/iZKd1qhw4skbB/reLTDKDd+JhkFpCx8YnvS4jAzKVnSYYmL/SZCvdHHYcggjP3LnCVi4azNY86exeOQP56VYT2OXOc53+HpmD0gEo41w4zn5YQqUTOwkG1onn4egDNNKeKUeLx6GnzIW0rsDBJnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XPdOLXq3; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XPdOLXq3"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-486e64c8edeso1334173b6e.2
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 12:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781292566; x=1781897366; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=mefc4hk7l8V5q1+Ri7ebgTL5CsdX634wsG3um/9LWKo=;
        b=XPdOLXq33SGpLBkX7FzFk+9u5ke7g9wvQWYGqfTCgPl1ciSXkVlQ8mdOpwNlkz8ba8
         IRaECd6lLRdWkBz34DShrA2JvetRVzKVWRU1dE4YGbclwLAcWQij9zp0ZJ5yMGvES4ir
         coqdDhxZjJIJ/c3mtl+7foT8MyNUhay7hzv18cvuAGBettIU85vWlKfSWo0FEmhoRi1U
         0gnxdhOpizc5nJcb0jjYU4W07yEqptlgC3ypdiukIkCfHsiwce2skFPV0d/D3K8aLmxp
         JCCuCSsoypHKoD9jjP8afzDRlOp0TebfO9WtDFGIQoBD03Cz0OurXZXb/CtL8LCYEEUo
         rZSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781292566; x=1781897366;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mefc4hk7l8V5q1+Ri7ebgTL5CsdX634wsG3um/9LWKo=;
        b=MdmHyVT5sbIzcsnsMKDzSrkqaHhagjfXM2mzvv60VZQDU4f4r9wM1D1dc4Z6M3emF7
         6Le+1YcdyLoCYH/WC15ieQPxc9l5cFjFj77vj+5i1g8jAAuPKnHwbUsho53hPxYQ96M9
         qadKOk/N3fHPcR6AoXGosYTnboj/nP6HUBgHOMzEJAuBbXe6HZb7I441OIT/g/dMwgfx
         IDRvf9+hagLSHv/2j+tX3sOx5bj9boM4hZug+LcKtXvJT3P3oAhPnMK8Tq2koSvGWXyH
         pTNkEdp0vOcY1u0LJCTU+ymLM9y5NO0+huYDzfR4lpEcUiP3JU9qO5FnsT5OV0GDBrHz
         woCQ==
X-Forwarded-Encrypted: i=1; AFNElJ+3AtvTQKxh3mSlwjMgwXoomQpNryCCqMBv3Ov5Ak7N2kODqmuLU7SJw8uYC5Dw/mfgGBNOwEw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSyCYoNTiZM5OKiSR++nCJGBycxOnlGgTZL3Z+ze74MAatyhee
	qw1xicRcDVendJeOzQa4cz0yDBlHPX7LxBUNKQ6psSfNVDGSSrp8fdi54yfc/rkQo8QUSTa7hbC
	cS7Qi3iM9HD2CwEVb3v5iISsDUA==
X-Received: from iloo20-n1.prod.google.com ([2002:a05:6e02:6114:10b0:4fe:69b2:404b])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:3a15:b0:485:d6e7:9dbf with SMTP id 5614622812f47-4872f11d549mr2509778b6e.0.1781292566143;
 Fri, 12 Jun 2026 12:29:26 -0700 (PDT)
Date: Fri, 12 Jun 2026 19:29:05 +0000
In-Reply-To: <20260612192909.1153907-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612192909.1153907-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612192909.1153907-18-coltonlewis@google.com>
Subject: [PATCH 17/21] KVM: arm64: Detect overflows for the Partitioned PMU
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

When we re-enter the VM after handling a PMU interrupt, calculate
whether it was any of the guest counters that overflowed and inject an
interrupt into the guest if so.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-direct.c | 48 +++++++++++++++++++++++++++++++++++++
 arch/arm64/kvm/pmu-emul.c   |  4 ++--
 arch/arm64/kvm/pmu.c        |  6 ++++-
 include/kvm/arm_pmu.h       |  2 ++
 4 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 64f40cfb31012..0062d1d8e1999 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -426,4 +426,52 @@ void kvm_pmu_handle_guest_irq(struct arm_pmu *pmu, u64 pmovsr)
 		return;
 
 	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, govf);
+
+	if (kvm_pmu_part_overflow_status(vcpu)) {
+		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
+
+		if (!in_nmi())
+			kvm_vcpu_kick(vcpu);
+		else
+			irq_work_queue(&vcpu->arch.pmu.overflow_work);
+	}
+}
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
+	pmu = vcpu->kvm->arch.arm_pmu;
+	mask = kvm_pmu_guest_counter_mask(pmu);
+
+	if (vcpu->arch.pmu.access == VCPU_PMU_ACCESS_FREE) {
+		pmovs = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
+		pmint = __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
+		pmcr = __vcpu_sys_reg(vcpu, PMCR_EL0);
+
+		if ((pmcr & ARMV8_PMU_PMCR_E) && (mask & pmovs & pmint))
+			kvm_pmu_set_guest_owned(vcpu);
+		else
+			return false;
+	}
+
+	pmovs = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
+	pmint = read_pmintenset();
+	pmcr = read_pmcr();
+	overflow = (pmcr & ARMV8_PMU_PMCR_E) && (mask & pmovs & pmint);
+
+	return overflow;
 }
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index d1110febe7436..ebc68090bdb26 100644
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
index 55cda8021400a..f5ee18b4dfae7 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -409,7 +409,11 @@ static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
 	struct kvm_pmu *pmu = &vcpu->arch.pmu;
 	bool overflow;
 
-	overflow = kvm_pmu_overflow_status(vcpu);
+	if (kvm_pmu_is_partitioned(vcpu->kvm))
+		overflow = kvm_pmu_part_overflow_status(vcpu);
+	else
+		overflow = kvm_pmu_emul_overflow_status(vcpu);
+
 	if (pmu->irq_level == overflow)
 		return;
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 25163a689ae80..f72d080ee7ba2 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -93,6 +93,8 @@ bool kvm_set_pmuserenr(u64 val);
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_resync_el0(void);
+bool kvm_pmu_emul_overflow_status(struct kvm_vcpu *vcpu);
+bool kvm_pmu_part_overflow_status(struct kvm_vcpu *vcpu);
 
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))
-- 
2.54.0.1136.gdb2ca164c4-goog

