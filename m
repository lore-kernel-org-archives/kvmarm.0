Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77BA22F19B8
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 20:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750968377; cv=none; b=LQiOHnJt/rpGZ1OON8ih1lYRk+AmDzjFTrlgc00WpyvjpRV22t5WMGG9K2hPfoEX7Sx+huWXBxIoep10Qry6KXWh1AnL+J8S8L2TXLcUWs0gzx4dph6qQpXKNET+K8g08N+CPEW6SLZT0pIksuTzJamTsIKj9OJekiDvFEJ6Nfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750968377; c=relaxed/simple;
	bh=gH+Yd1mzVo9y7Dr3+Hxk8fddtdVh8GqAqskRlpwY6xU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Evpi9vkfEDR0NM41FlKEBL13vdnefjMQHefGGuQQyiIxOy4qgVp/t/ZGvMtnqh+h9yBx39ppmISiDEqazDniwzikxQ2+9VkGvHd+ZvvIhDrFSi5UualOGzDe+Zq+re//3QGbLl66LiRUmjTUhHVDarL6waQpX8/1T4tlMyKLMyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=PyJFlL7o; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="PyJFlL7o"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3df2e9e6146so8782865ab.3
        for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 13:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750968372; x=1751573172; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ai9/sepaJ5XVOCTHqXQnbqMQb7WUqdqFh88LxqpgeeM=;
        b=PyJFlL7o81cuRpuC22ae0WtmlQEeYvDbjSDtqfsuwP2LT25Si0k5D7FeQh1NfWoBLf
         qdG1mpK5vEypNfwAE3MF40XR+J3BKFvBWb580DAVuULEQcSYDJkhI7IIY3eENgChbk7i
         O5JKIpUIBDV8rG1PkRck/jCoj5RdEf6C8BGwG2cTlrMnKRpCkLRGP1L+H7MVZ+n71YMB
         hXjvLwZ72uSMKynJjUC69UxtLqDyKUGd1cyP22gJtDr1N8v4toHCrIZM3g7Rr6JoNELw
         qXI7UgCJFt1JevvrntxE6rStR/wMm6GroRTTePDH5IaKx3Gn12HxKrn7qN7zlNf6sZh2
         A1pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750968372; x=1751573172;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ai9/sepaJ5XVOCTHqXQnbqMQb7WUqdqFh88LxqpgeeM=;
        b=VT/xVexaPGMauvzDPnzUaW2PDBCVPbV1FULjAUoU29tFe+3tMXu4veg2R+wmyB4Z5J
         MGpHYrH1+92FFVotmdwRpwctDNc0y8pQhDiPI11o9abNwhpQiXLCu6QbvKTewthFRB+9
         wuP/EL9cNXuftL4oEudfdQ3UbLYI9ICmwAabJKKFfVBuOyk7YC9+p2uGFeJKf9cpokBX
         KlDnbpT8npAW7I/OZv5tI39kWFlyYMlo2ku017TKM3YcOwiy2WGiqc8nQJErqH6JXgXG
         rH6RF3ge6wO/pFN+XaMEyh/MblXG/HglvBRucyRCDopiKa8xM6qhy5dtL6wuJ8qVhowG
         p+vw==
X-Forwarded-Encrypted: i=1; AJvYcCWcjkSayAnJ4w/daHimkzEZ5hpWG9gqSQbVsn0GGuxTaWMy/xXdnDuyRl1pAr57qwwgKMB+p3o=@lists.linux.dev
X-Gm-Message-State: AOJu0YwuG0gG2eb0YMsxBcO5nacp7U+EO2vmoSeECFVo1FAiPOqmZ92L
	8YjPujCkuEhb/LAgg7Lwj5hCx+1nh1qVZZVPtR6MxXPaHQptn0Z/JmQGj7K2UO6JyTVLugFWOFy
	/Elos33cUL2Wj5/Hu5J0C5Vorkw==
X-Google-Smtp-Source: AGHT+IHMxVNZWApbptZpNTBCT5d8XSjlwqRmfTyoWU26w+gUqtg0TL1VrqiKQldGVuUwisWThSdEUMcZDgoysCsEWA==
X-Received: from ilos8.prod.google.com ([2002:a92:cb08:0:b0:3db:8374:9a74])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1c04:b0:3dc:7cc1:b731 with SMTP id e9e14a558f8ab-3df4aacec3amr12947595ab.0.1750968372540;
 Thu, 26 Jun 2025 13:06:12 -0700 (PDT)
Date: Thu, 26 Jun 2025 20:04:56 +0000
In-Reply-To: <20250626200459.1153955-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250626200459.1153955-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626200459.1153955-21-coltonlewis@google.com>
Subject: [PATCH v3 20/22] KVM: arm64: Inject recorded guest interrupts
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

When we re-enter the VM after handling a PMU interrupt, calculate
whether it was any of the guest counters that overflowed and inject an
interrupt into the guest if so.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_pmu.h |  2 ++
 arch/arm64/kvm/pmu-emul.c        |  4 ++--
 arch/arm64/kvm/pmu-part.c        | 22 +++++++++++++++++++++-
 arch/arm64/kvm/pmu.c             |  6 +++++-
 4 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index 03e3bd318e4b..d047def897bc 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -86,6 +86,8 @@ bool pmu_access_el0_disabled(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_resync_el0(void);
+bool kvm_pmu_emul_overflow_status(struct kvm_vcpu *vcpu);
+bool kvm_pmu_part_overflow_status(struct kvm_vcpu *vcpu);
 
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index bcaa9f7a8ca2..6f41fc3e3f74 100644
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
diff --git a/arch/arm64/kvm/pmu-part.c b/arch/arm64/kvm/pmu-part.c
index bd04c37b19b9..165d1eae2634 100644
--- a/arch/arm64/kvm/pmu-part.c
+++ b/arch/arm64/kvm/pmu-part.c
@@ -279,7 +279,7 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu)
 	write_pmcr(val);
 
 	/*
-	 * Loading these registers is tricky because of
+	 * Loading these registers is more intricate because of
 	 * 1. Applying only the bits for guest counters (indicated by mask)
 	 * 2. Setting and clearing are different registers
 	 */
@@ -355,3 +355,23 @@ void kvm_pmu_handle_guest_irq(u64 govf)
 
 	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, govf);
 }
+
+/**
+ * kvm_pmu_part_overflow_status() - Determine if any guest counters have overflowed
+ * @vcpu: Ponter to struct kvm_vcpu
+ *
+ * Determine if any guest counters have overflowed and therefore an
+ * IRQ needs to be injected into the guest.
+ *
+ * Return: True if there was an overflow, false otherwise
+ */
+bool kvm_pmu_part_overflow_status(struct kvm_vcpu *vcpu)
+{
+	struct arm_pmu *pmu = vcpu->kvm->arch.arm_pmu;
+	u64 mask = kvm_pmu_guest_counter_mask(pmu);
+	u64 pmovs = __vcpu_sys_reg(vcpu, PMOVSSET_EL0);
+	u64 pmint = read_pmintenset();
+	u64 pmcr = read_pmcr();
+
+	return (pmcr & ARMV8_PMU_PMCR_E) && (mask & pmovs & pmint);
+}
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 9469f1e0a0b6..6ab0d23f9251 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -407,7 +407,11 @@ static void kvm_pmu_update_state(struct kvm_vcpu *vcpu)
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
 
-- 
2.50.0.727.gbf7dc18ff4-goog

