Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114341;
	b=YSGahashqa7hzJDOgV6xNnj9TiSwGS8GIlXrIyVeio1U3eQkby/8ho+/IzXESIGxyyo7
	 6ai4gHIE3kuh4CSbr+EXWPPfuXiUrgz2eGb1Od/GSoUwcbpawg6obiIFLypdvttrZ+biH
	 Jo/R1VZtWQgMa8iwq+TuLiyEe10d6NhK+tE7+fxRxhgMCbHMJZYmLM9iSTY9FunfWnl4k
	 VmidVUdu0Bqog5VhnJ96Lr9fVt8uj0GYuibGWiHPH05OZCIgSqDqXG6JdsuTnRZZ7TNHq
	 Gs4xgzGhSZ5pxKawxIOmBlCuAcMtFPYjCn+KWwzP8PjhDJ4036TBr5woIo5inpSnHUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114341;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=KQsSEkRceSASTHzJzgBIIkzZNEt4co2b8TqRiek6Jc4=;
	b=VN0Y51pBkEp/ndKkWk73Fh4abluPbxDtFNRP05ZzVyZZLCUTgqNnzlO63ITe8esLhayf
	 xUU0o/P4geAzLKrKvIOvFFskzxBeJqm5pNyI11QCCm3qd36CnJN5ATs8GF17Mmt4B0Ofn
	 JMRqzAMtWGbES9EJ43+767KrZ3i2xKekHYdzEhOw9xp/Cb3dehbXE4YPPqWjAF/8QbrBU
	 JYEB1dmioKXMlv7237KQiBnX56/vwPFmRdHHBsaJZOQJVP7Kcczz9SnYJLQg8ai4cSp0I
	 C2mBDJp8W1OtMPLd6gzhc8YytFG5+YA+Rquzd52bGbxA5QhJw4tsAOoOrEZDBUbXz+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ltkQZ5oI;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2B0F60A2602
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2B0F60A2602
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ltkQZ5oI
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4dab94dc3e7so198606b6e.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114340; x=1795719140; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KQsSEkRceSASTHzJzgBIIkzZNEt4co2b8TqRiek6Jc4=;
        b=ltkQZ5oIYKkFZRvnp8ODhYZbNiTu4WK2gPwucJW1DSG5zjsFIZqH/ynPw7ZXUGNGFA
         itQbxuZaM9Jq8t8r305dXJbCIlngprp+MGX1dc7Ou46kC7glGL1KZxwu0nyEisXF5uqF
         UyLMBACmY7pdBF9CftXf1H059QKdio5lUjgZv9ED9QpJ1M7BF0f05SsD7nd1W/y6zbtB
         9ltrEkKD4GbOcwTf+RiCPrUZgIJ+cN3XJ1G5M9ORlLsmK/FQgTHJZDA1iOUxxD1/mqq2
         JQAgVmii8W0dmYLZgwWxInAAME6kBS/WRlltYBnKbGN5FrBVlqySelca4XW8pZi9Cb2N
         QnmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114340; x=1795719140;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KQsSEkRceSASTHzJzgBIIkzZNEt4co2b8TqRiek6Jc4=;
        b=oFPV5qgyb2S3tTG4y5r96hviWxBCZgYQzrq6aKKZX+SIXMyOhD4CRmQNHgSygCVp0S
         1MtFg+Z82PoIObs0S8BpQEv7zZonD0aca0haI92x20bLxPZlslwQ3qETauX6sDPQ26eF
         69gtYJPzgh2+CHR511wHb/0QyB/nN0FOCBEmZSDRoNWh2GLGGdCJaM95zgIbbrpTJmXv
         mU0pFbUuTNoJeSI251KmZ3lLROL3lvs/s2kbygNjYxsN79+gWHBPdlAY0WncWdR8+Bwo
         9clNBzkYEsCBhcu9rZrBIKulYAGFl7z//7oLZsiXWKg8NPZqr9egxVW9yqvjD1kI9eYa
         H9gw==
X-Forwarded-Encrypted: i=1; AL+hErFHXQo5O/sTBc3rs5o+sRFgCOalQSNq/OGZ+WTFutQrn4REcX0zmPOigUBCJxuIBDlwK1z8vZU=@lists.linux.dev
X-Gm-Message-State: APuU4Z9z/ha6Zf7X0yIi/DCj8QcrymcCrIVRQw9CbkIejb3QFzkzf4Dg
	DGJ2dZHQ5tshkbX4KUHurEoUSzpupKKtaq1Uxkd5dW6yANY5FYkwwMJir5KdE3/wCLfGSCLzXpe
	7Yan8imanN+NPw3OvxWUearIA8Q==
X-Received: from iobmp26-n1.prod.google.com ([2002:a05:6602:a2da:10b0:9c7:5697:9ad7])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:3193:b0:56a:cf0b:a5fb with SMTP id 5614622812f47-57a0b145c20mr991415b6e.36.1795114339806;
 Thu, 19 Nov 2026 10:52:19 -0800 (PST)
Date: Thu, 19 Nov 2026 18:51:46 +0000
In-Reply-To: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119185215.632334-5-coltonlewis@google.com>
Subject: [PATCH v10 04/33] KVM: arm64: Use nr_pmu_counters in kvm_pmu_implemented_counter_mask()
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Russell King <linux@armlinux.org.uk>, Jonathan Corbet <corbet@lwn.net>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, James Clark <james.clark@linaro.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

kvm_pmu_implemented_counter_mask() returns the bitmask of all counters
implemented by the VM (0..N-1 and PMCCNTR_EL0). Previously it extracted
N from kvm_vcpu_read_pmcr(vcpu), which commit 600f6fa5c90c ("KVM: arm64:
Let kvm_vcpu_read_pmcr() return an EL-dependent value for PMCR_EL0.N")
changed to substitute MDCR_EL2.HPMN for PMCR_EL0.N whenever
vcpu_has_nv(vcpu) && !vcpu_is_el2(vcpu).

As a result, when kvm_vcpu_reload_pmu() services KVM_REQ_RELOAD_PMU
while the vCPU is at vEL1 or vEL0 (for example, when entering a nested
guest after an L1 MDCR_EL2 update), kvm_pmu_implemented_counter_mask()
omits HPMN..N-1 and kvm_vcpu_reload_pmu() wipes L1's hypervisor counter
bits in PMOVSSET_EL0, PMINTENSET_EL1, and PMCNTENSET_EL0.

Fix this in three parts:
- Read vcpu->kvm->arch.nr_pmu_counters directly in
  kvm_pmu_implemented_counter_mask() so the VM-wide implemented mask is
  independent of the vCPU's current exception level.
- Use kvm_pmu_accessible_counter_mask(vcpu) & ~BIT(ARMV8_PMU_CYCLE_IDX)
  for PMCR_EL0.P event counter resets instead of open-coding the
  subtraction of kvm_pmu_hyp_counter_mask(vcpu) below EL2.
- Mask trapped reads in access_pmcnten(), access_pminten(), and
  access_pmovs() with kvm_pmu_accessible_counter_mask(vcpu) (matching
  existing write masking) so retained hypervisor counter bits in
  HPMN..N-1 read as zero at EL1 and EL0.

Fixes: 600f6fa5c90c ("KVM: arm64: Let kvm_vcpu_read_pmcr() return an EL-dependent value for PMCR_EL0.N")
Fixes: 9a1c58cfefb0 ("KVM: arm64: nv: Adjust range of accessible PMCs according to HPMN")
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/kvm/pmu-emul.c | 5 +----
 arch/arm64/kvm/pmu.c      | 2 +-
 arch/arm64/kvm/sys_regs.c | 6 +++---
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index ea5908df42890..9eff208547746 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -446,12 +446,9 @@ void kvm_pmu_handle_pmcr(struct kvm_vcpu *vcpu, u64 val)
 		kvm_pmu_set_counter_value(vcpu, ARMV8_PMU_CYCLE_IDX, 0);
 
 	if (val & ARMV8_PMU_PMCR_P) {
-		unsigned long mask = kvm_pmu_implemented_counter_mask(vcpu) &
+		unsigned long mask = kvm_pmu_accessible_counter_mask(vcpu) &
 				     ~BIT(ARMV8_PMU_CYCLE_IDX);
 
-		if (!vcpu_is_el2(vcpu))
-			mask &= ~kvm_pmu_hyp_counter_mask(vcpu);
-
 		for_each_set_bit(i, &mask, 32)
 			kvm_pmu_set_pmc_value(kvm_vcpu_idx_to_pmc(vcpu, i), 0, true);
 	}
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 567de460205a0..dbbe219ac874f 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -852,7 +852,7 @@ u8 kvm_arm_pmu_get_pmuver_limit(void)
 
 u64 kvm_pmu_implemented_counter_mask(struct kvm_vcpu *vcpu)
 {
-	u64 val = FIELD_GET(ARMV8_PMU_PMCR_N, kvm_vcpu_read_pmcr(vcpu));
+	u64 val = vcpu->kvm->arch.nr_pmu_counters;
 
 	if (val == 0)
 		return BIT(ARMV8_PMU_CYCLE_IDX);
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 04947bfbd0ee5..6e8bc4618870d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1359,7 +1359,7 @@ static bool access_pmcnten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 
 		kvm_pmu_reprogram_counter_mask(vcpu, val);
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0);
+		p->regval = __vcpu_sys_reg(vcpu, PMCNTENSET_EL0) & mask;
 	}
 
 	return true;
@@ -1383,7 +1383,7 @@ static bool access_pminten(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			/* accessing PMINTENCLR_EL1 */
 			__vcpu_rmw_sys_reg(vcpu, PMINTENSET_EL1, &=, ~val);
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, PMINTENSET_EL1);
+		p->regval = __vcpu_sys_reg(vcpu, PMINTENSET_EL1) & mask;
 	}
 
 	return true;
@@ -1463,7 +1463,7 @@ static bool access_pmovs(struct kvm_vcpu *vcpu, struct sys_reg_params *p,
 			/* accessing PMOVSCLR_EL0 */
 			__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, &=, ~(p->regval & mask));
 	} else {
-		p->regval = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
+		p->regval = __vcpu_sys_reg(vcpu, PMOVSSET_EL0) & mask;
 	}
 
 	return true;
-- 
2.56.1.708.g77570a6a1d-goog

