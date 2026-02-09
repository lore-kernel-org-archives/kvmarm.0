Received: from mail-oa1-f73.google.com (mail-oa1-f73.google.com [209.85.160.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AEE03254A9
	for <kvmarm@lists.linux.dev>; Mon,  9 Feb 2026 22:41:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770676863; cv=none; b=Iu1QgX5K3zAG6zohgCGMaZKDl7yGUuhTYXatPKPOAemEP/NIEBq87VpBu4GevnBMt0aRNb2/V02FsWpi5raFGRXezy/1GPlsa0EV2PaYFjP/ut5zgnzGYo0UC9lwSfHJ3W9S12v5eURQiC2p1InIY7zgKgZD42HoHpcQ7vwlR+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770676863; c=relaxed/simple;
	bh=LS/mEjV4jNCK1fswN5F1dSimFWuhvVCl6oqxmUKaPBc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=p+a4aKV3ufOSttY8rGgcrUTjxCY3bK28fBjAyOGPHRM9UqF8LQOA5O+NnflFuBJ2eCylrgXAJHSH3w8tzLp0RETQOwNyPTanExuG/cMFjCK3X8uoSUGJUXrIMywMO1SRpbN747Tcn4xOetPyBOTEGnlIQx705nyt1q7pdIiLIqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=exRB6qF6; arc=none smtp.client-ip=209.85.160.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="exRB6qF6"
Received: by mail-oa1-f73.google.com with SMTP id 586e51a60fabf-40aee511210so791061fac.2
        for <kvmarm@lists.linux.dev>; Mon, 09 Feb 2026 14:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770676859; x=1771281659; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Fbs2IJ0IMwh/1h3wCPgscqdo8v8XfIhb3eCvNMBg5sM=;
        b=exRB6qF6gEP3ZPJd3nWB1WyCTgpG5FLNAEcsk9l9FLPEOr9zUsAoYnCCGLTyaJ+jIH
         aiTKtBFflW+i2o8shOTZebmCSOpmVuz67J+nYe+zEhRgK8CjY2jX4fBVSYAzrDlMovEo
         z9mdyB1AAVRMvm8uKhwg1WWzBRQMXsxEEgm5rJ1V1NiBXeRWHupUAj454njG3vScrzv+
         Zexm0kvvyCPDKA/sYoZ+zQsEvT/PSSgDochPJpVJtVNrzZMaBRJOV+4TUjQ+71GEa6P4
         zMy7kumpveTJaaLZx3y0+Gp3RIg4xhZNIdI8uaebgqA12juqEzE/unI1wIir+qbEB64n
         Zr0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770676859; x=1771281659;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fbs2IJ0IMwh/1h3wCPgscqdo8v8XfIhb3eCvNMBg5sM=;
        b=ls+5lX4XN/ecKTdqdqGOhYYd1CWHmWpRBs29trJqAi86RJEZPZRwVWSx3tEB0aVZaf
         Na8zXYCEd80/j9NB/hC+Nu1N3hQl8ZBBgMh/Q2ddUjtgnjXTIeMzjHs08Jhlsj6cuESE
         h3P+401ACVG5FHogKsJCaXvPyJxW8seRnaNA+JP2xKuxBkhD5Xlh/l2H/cOQFEFkwOQX
         gdZraSdapOP/4KJlJsLmQs2f7i7Anw2P37sbw9imjbidPYF/Y/JbKD5wtpm6cDR/i1VB
         jbgu4//tOh2M5C7qgm1WKPj14tVdRJeYw98gp3r9Mb0SiD8KOiU61DHIYlxSOLoj/3Dr
         /How==
X-Forwarded-Encrypted: i=1; AJvYcCVwHVGlUzIOFcvpOK6FH9Rb4PBbLxbXWTL63mbHvY/29X7I4/Jam/F+qKpYSZ4QWnNfQxuYUYo=@lists.linux.dev
X-Gm-Message-State: AOJu0YxfcDcOwK7Op7hL7uxyD1qpH2NWNEklFG11IFveg2OLvuDvGNPp
	isoBXwzQF9z81xM/Twa8N8SGyd+Ok9PqkBDh9pmkrcfPQobEU/fPfUPwj3lqdZsTJQTYj+p+Y4U
	P1x692lvuq29dcFfwo8e+45RNcQ==
X-Received: from ioyy2.prod.google.com ([2002:a05:6602:2142:b0:957:61bf:f0ca])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:1607:b0:66a:adbb:31c1 with SMTP id 006d021491bc7-66d0c856dbcmr5554562eaf.61.1770676859402;
 Mon, 09 Feb 2026 14:40:59 -0800 (PST)
Date: Mon,  9 Feb 2026 22:14:09 +0000
In-Reply-To: <20260209221414.2169465-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260209221414.2169465-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209221414.2169465-15-coltonlewis@google.com>
Subject: [PATCH v6 14/19] perf: arm_pmuv3: Handle IRQs for Partitioned PMU
 guest counters
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

Because ARM hardware is not yet capable of direct PPI injection into
guests, guest counters will still trigger interrupts that need to be
handled by the host PMU interrupt handler. Clear the overflow flags in
hardware to handle the interrupt as normal, but the virtual overflow
register for later injecting the interrupt into the guest.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm/include/asm/arm_pmuv3.h   |  6 ++++++
 arch/arm64/include/asm/arm_pmuv3.h |  5 +++++
 arch/arm64/kvm/pmu-direct.c        | 22 ++++++++++++++++++++++
 drivers/perf/arm_pmuv3.c           | 24 +++++++++++++++++-------
 include/kvm/arm_pmu.h              |  2 ++
 5 files changed, 52 insertions(+), 7 deletions(-)

diff --git a/arch/arm/include/asm/arm_pmuv3.h b/arch/arm/include/asm/arm_pmuv3.h
index bed4dfa755681..d2ed4f2f02b25 100644
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
 
+static inline void kvm_pmu_handle_guest_irq(struct arm_pmu *pmu, u64 pmovsr) {}
 
 /* PMU Version in DFR Register */
 #define ARMV8_PMU_DFR_VER_NI        0
diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 27c4d6d47da31..69ff4d014bf39 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -110,6 +110,11 @@ static inline void write_pmintenset(u64 val)
 	write_sysreg(val, pmintenset_el1);
 }
 
+static inline u64 read_pmintenset(void)
+{
+	return read_sysreg(pmintenset_el1);
+}
+
 static inline void write_pmintenclr(u64 val)
 {
 	write_sysreg(val, pmintenclr_el1);
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 11fae54cd6534..79d13a0aa2fd6 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -356,3 +356,25 @@ void kvm_pmu_put(struct kvm_vcpu *vcpu)
 
 	preempt_enable();
 }
+
+/**
+ * kvm_pmu_handle_guest_irq() - Record IRQs in guest counters
+ * @pmu: PMU to check for overflows
+ * @pmovsr: Overflow flags reported by driver
+ *
+ * Set overflow flags in guest-reserved counters in the VCPU register
+ * for the guest to clear later.
+ */
+void kvm_pmu_handle_guest_irq(struct arm_pmu *pmu, u64 pmovsr)
+{
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
+	u64 mask = kvm_pmu_guest_counter_mask(pmu);
+	u64 govf = pmovsr & mask;
+
+	write_pmovsclr(govf);
+
+	if (!vcpu)
+		return;
+
+	__vcpu_rmw_sys_reg(vcpu, PMOVSSET_EL0, |=, govf);
+}
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 6395b6deb78c2..9520634991305 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -774,16 +774,15 @@ static void armv8pmu_disable_event_irq(struct perf_event *event)
 	armv8pmu_disable_intens(BIT(event->hw.idx));
 }
 
-static u64 armv8pmu_getreset_flags(void)
+static u64 armv8pmu_getovf_flags(void)
 {
 	u64 value;
 
 	/* Read */
 	value = read_pmovsclr();
 
-	/* Write to clear flags */
-	value &= ARMV8_PMU_CNT_MASK_ALL;
-	write_pmovsclr(value);
+	/* Only report interrupt enabled counters. */
+	value &= read_pmintenset();
 
 	return value;
 }
@@ -903,16 +902,17 @@ static void read_branch_records(struct pmu_hw_events *cpuc,
 
 static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
 {
-	u64 pmovsr;
 	struct perf_sample_data data;
 	struct pmu_hw_events *cpuc = this_cpu_ptr(cpu_pmu->hw_events);
 	struct pt_regs *regs;
+	u64 host_set = kvm_pmu_host_counter_mask(cpu_pmu);
+	u64 pmovsr;
 	int idx;
 
 	/*
-	 * Get and reset the IRQ flags
+	 * Get the IRQ flags
 	 */
-	pmovsr = armv8pmu_getreset_flags();
+	pmovsr = armv8pmu_getovf_flags();
 
 	/*
 	 * Did an overflow occur?
@@ -920,6 +920,12 @@ static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
 	if (!armv8pmu_has_overflowed(pmovsr))
 		return IRQ_NONE;
 
+	/*
+	 * Guest flag reset is handled the kvm hook at the bottom of
+	 * this function.
+	 */
+	write_pmovsclr(pmovsr & host_set);
+
 	/*
 	 * Handle the counter(s) overflow(s)
 	 */
@@ -961,6 +967,10 @@ static irqreturn_t armv8pmu_handle_irq(struct arm_pmu *cpu_pmu)
 		 */
 		perf_event_overflow(event, &data, regs);
 	}
+
+	if (kvm_pmu_is_partitioned(cpu_pmu))
+		kvm_pmu_handle_guest_irq(cpu_pmu, pmovsr);
+
 	armv8pmu_start(cpu_pmu);
 
 	return IRQ_HANDLED;
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 82665d54258df..3d922bd145d4e 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -99,6 +99,7 @@ u64 kvm_pmu_host_counter_mask(struct arm_pmu *pmu);
 u64 kvm_pmu_guest_counter_mask(struct arm_pmu *pmu);
 void kvm_pmu_host_counters_enable(void);
 void kvm_pmu_host_counters_disable(void);
+void kvm_pmu_handle_guest_irq(struct arm_pmu *pmu, u64 pmovsr);
 
 u8 kvm_pmu_guest_num_counters(struct kvm_vcpu *vcpu);
 u8 kvm_pmu_hpmn(struct kvm_vcpu *vcpu);
@@ -306,6 +307,7 @@ static inline u64 kvm_pmu_guest_counter_mask(void *pmu)
 
 static inline void kvm_pmu_host_counters_enable(void) {}
 static inline void kvm_pmu_host_counters_disable(void) {}
+static inline void kvm_pmu_handle_guest_irq(struct arm_pmu *pmu, u64 pmovsr) {}
 
 #endif
 
-- 
2.53.0.rc2.204.g2597b5adb4-goog

