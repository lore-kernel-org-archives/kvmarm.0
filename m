Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFC942980D4
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 22:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752533995; cv=none; b=C2w5kHyGvm/UaIhx88Z4c743v+f8F8jmqQGYX2xzbEspIUhIAziWQWdKcOhuLqvucVIILAYWFbcvelk0ZIlGu7FIuXRgEJ64jaalC4BwKtIljXByHUj61IrYeUDbZl/KWES+QJzyMIKJX4mP43rkHQKQRp9NduXyeK9wLyCehRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752533995; c=relaxed/simple;
	bh=p5hjuRItxud1tuLT297KADQzzBBvn6FNPEJSo8u9i5M=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=JkRTs49hgT54UAYl/eM1TS8xmqUe4vKsS/ES0IHlUyq19lol0lJMieHIeUzsl1Sb2WjXAWHHI7uWDyAeLDz+QWFRsMLJWqzBqCKckVZOXVVxYeMlnY0GExB7bvNt1E7YlgXnrsV0VTXbYTRG7sxDR6CGPMdpAbwdaNmujhCVtiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DAR/71KC; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DAR/71KC"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3ddd5cd020dso99374835ab.0
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 15:59:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752533991; x=1753138791; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=owVeMj/9hQdREoMrYrf+cb3JPwx5Updk91QFCpBYEPQ=;
        b=DAR/71KC7l6GN8Ca5XZ65a4d3Vpe4xY+TbS4lsgnqXbwogZ2GdlCvHzPG0X4mn6jGC
         D6APWtNZPivkPKLE8TBBzfREbereqJp/td66erYYfPlEBcCqRQdi28FRx2B5JY9zDU2+
         uASJwj+24V0fjvVoDsH+RnXrdW15aalejL8bBlpAxyLsx8NTTqaYJc4JKdpAeiLzU0pS
         8Ddet688Cc79FDNa9ORUUy7Bg8utAEUJgg116jzhBFTbyzwLi0N10OAONfqT+mJQtm18
         bhetVYi3IrQ3CGRBQ0033IKJMUsrDPx3HVmb6tSAkzq9Xoqh+RFV2MviEw/Py6QljVhQ
         lYmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752533991; x=1753138791;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=owVeMj/9hQdREoMrYrf+cb3JPwx5Updk91QFCpBYEPQ=;
        b=crI5TVXNGdlId9lq+8dlda6UwcVE5oIBWmncfBW+xssNJTMcCPnz81u76hIAnHBHLV
         D6EXQqtpyCtafclnwJNyk4iXl3CAP1dUo0EQ/qNlJN7HEqyPoS+MzP9BV+Mcx71C6MzK
         1APO8n/FOzmcheAlEtK5DJPbCMzmOjfulm2BmFjj104y8EHsHVEbb4gVxnUkxkvaYFKf
         HTluZx/cpohsVSb2Ve8Ius/Bj/FFUXEHsxz5QZhy9N6qQfCK4X2kZTO+1OQDP7u9agPj
         PEqCTsqUdFTOmwPUMHRXu6FeAnF7SkA29t3iXqWP0Nhf4IWdcrzMGlP0CXbID1lIeEcQ
         2b7w==
X-Forwarded-Encrypted: i=1; AJvYcCWVhf3mQFS2X+Ov2wtaI9ukuB4o+HefmzTM4IuUalOstHbo/F6Zl+R/coX4sgIYZSgxzdqHQDI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yya/tAJxttqw/oAsP43AJAzWSgTdg13GUNFOTfswpmCCOGNn9gt
	0cbqjKiJPdzNXCrgd1j6lTgGMHJy5Daerjhy8jnIzWKdGWPZp3fKMDC3C4NPWG9G99Q0h6CrlHC
	zC+5sr+xCGbhWGT0x+oNRrALExw==
X-Google-Smtp-Source: AGHT+IFhP5mgyGUmG3pmQj8bVOziDPF6iO6lkJxF0ZjHKQgYCC4Elel7HDH7jDBm3sU0yo1Sa4ndzKb0EA7KNwiitw==
X-Received: from ilbea23-n1.prod.google.com ([2002:a05:6e02:4517:10b0:3dd:78b6:1265])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1c05:b0:3e0:ec1e:18fe with SMTP id e9e14a558f8ab-3e25332ed05mr145231275ab.15.1752533991250;
 Mon, 14 Jul 2025 15:59:51 -0700 (PDT)
Date: Mon, 14 Jul 2025 22:59:14 +0000
In-Reply-To: <20250714225917.1396543-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250714225917.1396543-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250714225917.1396543-21-coltonlewis@google.com>
Subject: [PATCH v4 20/23] perf: arm_pmuv3: Handle IRQs for Partitioned PMU
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
 arch/arm64/kvm/pmu-direct.c      | 17 +++++++++++++++++
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
index 47cfff7ebc26..6149eb051ff9 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -96,6 +96,7 @@ u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu);
 u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
 void kvm_pmu_host_counters_enable(void);
 void kvm_pmu_host_counters_disable(void);
+void kvm_pmu_handle_guest_irq(u64 govf);
 
 bool kvm_pmu_regs_free(struct kvm_vcpu *vcpu);
 bool kvm_pmu_regs_host_owned(struct kvm_vcpu *vcpu);
@@ -310,6 +311,7 @@ static inline u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu)
 
 static inline void kvm_pmu_host_counters_enable(void) {}
 static inline void kvm_pmu_host_counters_disable(void) {}
+static inline void kvm_pmu_handle_guest_irq(u64 govf) {}
 
 #endif
 
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 28d8540c5ed2..3f9e0d4a74e1 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -339,3 +339,20 @@ void kvm_pmu_put(struct kvm_vcpu *vcpu)
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
index bc8a99cf4f88..6307cd851eb6 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -755,6 +755,8 @@ static u64 armv8pmu_getreset_flags(void)
 
 	/* Write to clear flags */
 	value &= ARMV8_PMU_CNT_MASK_ALL;
+	/* Only reset interrupt enabled counters. */
+	value &= read_pmintenset();
 	write_pmovsclr(value);
 
 	return value;
@@ -857,6 +859,7 @@ static void armv8pmu_stop(struct arm_pmu *cpu_pmu)
 static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
 {
 	u64 pmovsr;
+	u64 govf;
 	struct perf_sample_data data;
 	struct pmu_hw_events *cpuc = this_cpu_ptr(cpu_pmu->hw_events);
 	struct pt_regs *regs;
@@ -911,6 +914,12 @@ static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
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

