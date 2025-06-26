Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B011C2FD885
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 20:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750968377; cv=none; b=L3KO7zg26xCw7BZgSfEsTvlqjhuFFhuVwq/bJquoR6ETmFHS2gotL9b6VL15J+RVjGc9WZ5qJ9umY+sC4Lw2DmWO/DWnUsf1j6heY+hL4vpJAnPcHg7nquIrSMB6uVlh2pnkUMRWLJG5esHEDjdopnsCk6Z3S4KyHyGwOYhGX5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750968377; c=relaxed/simple;
	bh=gOCVNUcJxbP4E19oVaSXNAaxiVd9KT2116peS7a3WYY=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=jldAnGHV46Vz2FLFpr9ufSgMi5+cX4qvoLhMQn3osqoh/hrq04QDnxsFnmI9MBb1kmIBSGGVmQStjbaqpVakudpf6lwc53d2YC9VU9iEZKQd90LWZ8FyxtFfI4rnuvyJcpVhA5QdYIToHp9YRurVqFia8vhksaVTmwwbkWm0afw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fmLMg7eB; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fmLMg7eB"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3df3b71b987so12792705ab.0
        for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 13:06:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750968371; x=1751573171; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=S6YI1PbJ7Kn84JnSkWupK7ZLYRCn92aoL1PXIwZUeC8=;
        b=fmLMg7eBQCfAdvoIibFS45skvTEdFa4c6NHprpMZp442NJXSQAksYROC0MptYhJrn0
         f5g3MKJECzNudvhVcdqW35xblNvI8tBTA7wiu0gsyyoek4jIBuV0IbH4INn6vZ5GTLjX
         rXrbZ5R7WSgLeYzje+XdayJcnh91bD6OWS8GxqyqSGzzZwwZ6l1Pguon9AVMT6AqXRkW
         jjCItncUMScvrk89vEb+5yZFqSnzwdEuoC6nOALYNKDKFX6g1/cKxW08EpFZsZ3j6jY2
         kEs8xBUDQAsCetPA/23iT1mNxLeo2rRwOFO17r3/XROunVafVyG/TtlSW0ATgQ700o6y
         n6JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750968371; x=1751573171;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=S6YI1PbJ7Kn84JnSkWupK7ZLYRCn92aoL1PXIwZUeC8=;
        b=B18zrCfwzaDLCE1v/ZVGJJ+0GB/DOFO4ynUtHCbrhsA7L6ajasQxgjrNFrfiGCg2B7
         VvpZX0KzWO0br46h+PRUJffhRS6XraKOD5ia2kV0Ojvs50yLJ1s1FG97CoCRlBDRigHL
         IyKrPgmHYtKQPlJarFIIoD40SYvvmsFM6xZATRrArpDZX5DaB5IN2v9Nyccf8KaffsNs
         u7rdXP7HvA5iPsnwKXiUCyEZFVH4A/iONKsRoT9NBRfVmFR4X7AZH3HIEOvVsMTWWFU6
         DBLVyP9PxE+3EQJdOk0hGbcy9UpiCh12CE0LVFRL/0f9pJ16bct5bjm9K/qgQnvVXIxK
         OsDQ==
X-Forwarded-Encrypted: i=1; AJvYcCULnrX84ABgx1YkpZ1Z7GhFdc/0DYxcgWvT4RUojxs6qzMO6A/ygOVMtqkiibeC4F6w+3ZIxYQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzGqmcUJHgraW6CZ9z3GeW2nhTyUZoQ1cTbyIKcXVoIDnKH4ji4
	3+hJjBtwAvaed7V7aZH99Ufov1021z4z5Nh+b+8W84T8l3oLzc5mOcTq+UTvHES9yJjCIHuuoX5
	5Q+7MJvR1A0T9QH3MbwINHJrBMQ==
X-Google-Smtp-Source: AGHT+IHJUkjGyGvNcWxAAAjfiD6q7g9phykRry/HcdOfgoIUsGWYJ5QzPA0/oIz6lali1a+s4FtxtR3CCKpC4TGpWw==
X-Received: from ilbbb14.prod.google.com ([2002:a05:6e02:e:b0:3df:38c1:b314])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:154a:b0:3de:25cb:42c2 with SMTP id e9e14a558f8ab-3df4acdd094mr10972865ab.18.1750968371417;
 Thu, 26 Jun 2025 13:06:11 -0700 (PDT)
Date: Thu, 26 Jun 2025 20:04:55 +0000
In-Reply-To: <20250626200459.1153955-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250626200459.1153955-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626200459.1153955-20-coltonlewis@google.com>
Subject: [PATCH v3 19/22] perf: arm_pmuv3: Handle IRQs for Partitioned PMU
 guest counters
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

Guest counters will still trigger interrupts that need to be handled
by the host PMU interrupt handler. Clear the overflow flags in
hardware to handle the interrupt as normal, but record which guest
overflow flags were set in the virtual overflow register for later
injecting the interrupt into the guest.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm/include/asm/arm_pmuv3.h |  6 ++++++
 arch/arm64/include/asm/kvm_pmu.h |  2 ++
 arch/arm64/kvm/pmu-part.c        | 17 +++++++++++++++++
 drivers/perf/arm_pmuv3.c         |  9 +++++++++
 4 files changed, 34 insertions(+)

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index 5f6269039f44..36638efe4258 100644
--- a/arch/arm/include/asm/arm_pmuv3.h
+++ b/arch/arm/include/asm/arm_pmuv3.h
@@ -180,6 +180,11 @@ static inline void write_pmintenset(u32 val)
 	write_sysreg(val, PMINTENSET);
 }
 
+static inline u32 read_pmintenset(void)
+{
+	return read_sysreg(PMINTENSET);
+}
+
 static inline void write_pmintenclr(u32 val)
 {
 	write_sysreg(val, PMINTENCLR);
@@ -249,6 +254,7 @@ static inline u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)
 	return ~0;
 }
 
+static inline void kvm_pmu_handle_guest_irq(u64 govf) {}
 
 static inline bool has_vhe(void)
 {
diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index 4f0741bf6779..03e3bd318e4b 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -95,6 +95,7 @@ u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu);
 u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
 void kvm_pmu_host_counters_enable(void);
 void kvm_pmu_host_counters_disable(void);
+void kvm_pmu_handle_guest_irq(u64 govf);
 
 u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu);
 u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu);
@@ -291,6 +292,7 @@ static inline u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)
 
 static inline void kvm_pmu_host_counters_enable(void) {}
 static inline void kvm_pmu_host_counters_disable(void) {}
+static inline void kvm_pmu_handle_guest_irq(u64 govf) {}
 
 #endif
 
diff --git a/arch/arm64/kvm/pmu-part.c b/arch/arm64/kvm/pmu-part.c
index 1451870757e1..bd04c37b19b9 100644
--- a/arch/arm64/kvm/pmu-part.c
+++ b/arch/arm64/kvm/pmu-part.c
@@ -338,3 +338,20 @@ void kvm_pmu_put(struct kvm_vcpu *vcpu)
 	val = read_pmintenset();
 	__vcpu_assign_sys_reg(vcpu, PMINTENSET_EL1, val & mask);
 }
+
+/**
+ * kvm_pmu_handle_guest_irq() - Record IRQs in guest counters
+ * @govf: Bitmask of guest overflowed counters
+ *
+ * Record IRQs from overflows in guest-reserved counters in the VCPU
+ * register for the guest to clear later.
+ */
+void kvm_pmu_handle_guest_irq(u64 govf)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+
+	if (!vcpu)
+		return;
+
+	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, govf);
+}
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 5836672a3dd9..dba7dcee8258 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -750,6 +750,8 @@ static u64 armv8pmu_getreset_flags(void)
 
 	/* Write to clear flags */
 	value &= ARMV8_PMU_CNT_MASK_ALL;
+	/* Only reset interrupt enabled counters. */
+	value &= read_pmintenset();
 	write_pmovsclr(value);
 
 	return value;
@@ -852,6 +854,7 @@ static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
 static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
 {
 	u64 pmovsr;
+	u64 govf;
 	struct perf_sample_data data;
 	struct pmu_hw_events *cpuc = this_cpu_ptr(cpu_pmu->hw_events);
 	struct pt_regs *regs;
@@ -906,6 +909,12 @@ static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
 		 */
 		perf_event_overflow(event, &data, regs);
 	}
+
+	govf = pmovsr & kvm_pmu_guest_counter_mask(cpu_pmu);
+
+	if (kvm_pmu_is_partitioned(cpu_pmu) && govf)
+		kvm_pmu_handle_guest_irq(govf);
+
 	armv8pmu_start(cpu_pmu);
 
 	return IRQ_HANDLED;
-- 
2.50.0.727.gbf7dc18ff4-goog

