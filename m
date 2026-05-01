Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3033439E184
	for <kvmarm@lists.linux.dev>; Fri,  1 May 2026 11:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777634393; cv=none; b=h2A+iperNawlmXKXy0AfHOeZ+DtyRDDSzf5a/zQcui9eyTgXl+/v9cSXLHKqMsPU6QnNNpE9otRwSNX/tGE3K0EyQi2UkT8zCH6Dy75LHL3B+ZCxPzAH7qQ8gtL5ruRM6BTGdNxOg7OcFCKM6VN0WoyWXgh58TiL5f3ViRXJ1WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777634393; c=relaxed/simple;
	bh=hQvMJPmlY2Hj6FmtUqvk5LfujDesEr9peo98uTnWvUw=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gZLL9VkK8bSA1FNFzd1MFL63LbRNACp23RF52MJIZJLRqe3qqEdw747DGOzSA+03SulKFWuu8ehcXh5/4+agYkUx2h1r2Lc/s7uh7m13Ob1KH3SDAbQfwtsI4M1dpx54K9sa0m3FQpnVOMJ0Ct0Ohm7bseeQMiOaQpECle+vOcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=t1zIeww8; arc=none smtp.client-ip=209.85.208.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="t1zIeww8"
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-66b0d92bffaso1562848a12.1
        for <kvmarm@lists.linux.dev>; Fri, 01 May 2026 04:19:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777634390; x=1778239190; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=ycktJLz1KBPXSpg6NVU24LQdR/O3V/jOKSZRApslagY=;
        b=t1zIeww8mohl7hAy5UIWP4x8ZE3quOk/Vfj+M6/26kyUcXS4feCdqnrhJiPAx1hoX4
         chlgPgVVGMf249n0/hs+R1+tEko14Hx4ZMTF1/etZ3gl/c5r07GCrniMnAWKwIYoYMLO
         a7MlvaNUdpKbspd3RrwAQ75DwfaVItU148Dd7IlWBxXO3AzORdZSUbgBGbia4Znl86y2
         RyZB4Bqs2bPXeGz/cyjv0wm4lCZv/zQGEdcDad5B9zLbYtLpUew2RG4YXSphvOCK/SqH
         uQvPn7wDKNzAZ9uiEj3Rz7mRDgJsGa/xpQD1I46ij0dncvFfZgd6dBjFs7lreh9BXDD/
         P68Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777634390; x=1778239190;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ycktJLz1KBPXSpg6NVU24LQdR/O3V/jOKSZRApslagY=;
        b=sjhZBMLWyBMenhfmJUBSmyT1ZNOM1WwsdyJuk33GSlNatThlqJBpDCF1GpTZvq16nX
         DrbWPVD3EFnEMniEFNmW+odY8ozL7sPhDcben1yOWNiDwUK6oEcDp0gEaVvZFBPhGioP
         2XMdDWLh2APc1qmCE+1LqKe3oXHPa/ytIJgsx3PxciwYRJDIcp65AzDb5KeOAbrH36ca
         GLtDhaOh5pj9GkJqzvDeJjqwH7Z3E91N7xhONcZokPcNxrhwE7+O5nipAyycq3pFFvOr
         lobwmfCI7di4vgyc+uz4tnGe9f3eq+0kW64djCg0O6BA1rcfm2nGx+TQL/dWr/ZwUIoQ
         Oo8g==
X-Forwarded-Encrypted: i=1; AFNElJ8jk8t1PJ8rMlg7tRVxB2YcO5Giqb3cV3rNWADxkFvugI9YKIlvg2LBAJUNU0/C6rWkBDfjG44=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywn3zdeJgriw3Z+HQAW3MXzxHh7V6ZFieA/5V8yosiGjnKN31uX
	YTjIgmmPRl1AwFPcYmxdQfe9uOvvAC1l/GKaVkbeQHHlyNnExmOeN0HuLGbtP5972weY5IZ4JPz
	WFoQLjBCj1X/Ifg==
X-Received: from edag36.prod.google.com ([2002:a05:6402:3224:b0:66e:76b4:2912])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:46d8:b0:678:a507:e81b with SMTP id 4fb4d7f45d1cf-67b5d97defdmr2810112a12.21.1777634390386;
 Fri, 01 May 2026 04:19:50 -0700 (PDT)
Date: Fri,  1 May 2026 11:19:03 +0000
In-Reply-To: <20260501111928.259252-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260501111928.259252-1-smostafa@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260501111928.259252-2-smostafa@google.com>
Subject: [PATCH v6 01/25] KVM: arm64: Generalize trace clock
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jean-philippe@linaro.org, jgg@ziepe.ca, 
	mark.rutland@arm.com, qperret@google.com, tabba@google.com, 
	vdonnefort@google.com, sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

IOMMU drivers need to track time, mainly for timeouts.
Generalize the tracing clock functions in the hypervsior, so they can
be used from IOMMU drivers.

1) Make the compilation independent from tracing.

2) As drivers might need to use that quite early, provide default
   values for the clock data based on cntfrq_el0, the driver can
   keep using these values without calling hyp_clock_update() as
   they don't need to sync with the host timers.

This is mainly used for timeouts, so a malicious host can DoS the
system or cause premature timeouts which likely end up in hyp panic,
that should be acceptable as neither of those would undermine the
security guarantees.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/clock.h | 11 ++-----
 arch/arm64/kvm/hyp/nvhe/Makefile        |  4 +--
 arch/arm64/kvm/hyp/nvhe/clock.c         | 44 ++++++++++++++++++++++---
 arch/arm64/kvm/hyp/nvhe/setup.c         |  5 +++
 arch/arm64/kvm/hyp/nvhe/trace.c         |  4 +--
 5 files changed, 51 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/clock.h b/arch/arm64/kvm/hyp/include/nvhe/clock.h
index 9f429f5c0664..e6a0e43af88d 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/clock.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/clock.h
@@ -5,12 +5,7 @@
 
 #include <asm/kvm_hyp.h>
 
-#ifdef CONFIG_NVHE_EL2_TRACING
-void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
-u64 trace_clock(void);
-#else
-static inline void
-trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) { }
-static inline u64 trace_clock(void) { return 0; }
-#endif
+void hyp_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc);
+u64 hyp_clock_ns(void);
+int hyp_clock_init(void);
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index 62cdfbff7562..89d0533921f9 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -26,10 +26,10 @@ hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
-	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o
+	 ../fpsimd.o ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o clock.o
 hyp-obj-y += ../../../kernel/smccc-call.o
 hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
-hyp-obj-$(CONFIG_NVHE_EL2_TRACING) += clock.o trace.o events.o
+hyp-obj-$(CONFIG_NVHE_EL2_TRACING) += trace.o events.o
 hyp-obj-y += $(lib-objs)
 
 # Path to simple_ring_buffer.c
diff --git a/arch/arm64/kvm/hyp/nvhe/clock.c b/arch/arm64/kvm/hyp/nvhe/clock.c
index 32fc4313fe43..53d0bd55e866 100644
--- a/arch/arm64/kvm/hyp/nvhe/clock.c
+++ b/arch/arm64/kvm/hyp/nvhe/clock.c
@@ -18,7 +18,41 @@ static struct clock_data {
 		u64 cyc_overflow64;
 	} data[2];
 	u64 cur;
-} trace_clock_data;
+} clock_data;
+
+#define HYP_CLK_SEC_TO_NS 1000000000UL
+
+int hyp_clock_init(void)
+{
+	u32 timer_freq = read_sysreg(cntfrq_el0);
+	u32 shift = 32;
+	u64 mult;
+
+	/*
+	 * KVM will not initialize if FW didn't set cntfrq_el0, that is already
+	 * part of the boot protocol.
+	 */
+	if (!timer_freq)
+		return -ENODEV;
+
+	/* Timer freq can't be larger than 1Ghz by spec. */
+	if (timer_freq > HYP_CLK_SEC_TO_NS)
+		return -EINVAL;
+
+	/* Simplified logic from clocks_calc_mult_shift() */
+	do {
+		mult = (HYP_CLK_SEC_TO_NS << shift);
+		mult = div_u64(mult, timer_freq);
+		if (mult <= (~0U))
+			break;
+		shift--;
+	} while (shift > 0);
+
+	clock_data.data[0].shift = shift;
+	clock_data.data[0].mult = mult;
+	clock_data.data[0].cyc_overflow64 = ULONG_MAX / mult;
+	return 0;
+}
 
 static u64 __clock_mult_uint128(u64 cyc, u32 mult, u32 shift)
 {
@@ -30,9 +64,9 @@ static u64 __clock_mult_uint128(u64 cyc, u32 mult, u32 shift)
 }
 
 /* Does not guarantee no reader on the modified bank. */
-void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
+void hyp_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
 {
-	struct clock_data *clock = &trace_clock_data;
+	struct clock_data *clock = &clock_data;
 	u64 bank = clock->cur ^ 1;
 
 	clock->data[bank].mult			= mult;
@@ -45,9 +79,9 @@ void trace_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
 }
 
 /* Use untrusted host data */
-u64 trace_clock(void)
+u64 hyp_clock_ns(void)
 {
-	struct clock_data *clock = &trace_clock_data;
+	struct clock_data *clock = &clock_data;
 	u64 bank = smp_load_acquire(&clock->cur);
 	u64 cyc, ns;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index d8e5b563fd3d..8041f6e80cd1 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -10,6 +10,7 @@
 #include <asm/kvm_pgtable.h>
 #include <asm/kvm_pkvm.h>
 
+#include <nvhe/clock.h>
 #include <nvhe/early_alloc.h>
 #include <nvhe/ffa.h>
 #include <nvhe/gfp.h>
@@ -312,6 +313,10 @@ void __noreturn __pkvm_init_finalise(void)
 	};
 	pkvm_pgtable.mm_ops = &pkvm_pgtable_mm_ops;
 
+	ret = hyp_clock_init();
+	if (ret)
+		goto out;
+
 	ret = fix_host_ownership();
 	if (ret)
 		goto out;
diff --git a/arch/arm64/kvm/hyp/nvhe/trace.c b/arch/arm64/kvm/hyp/nvhe/trace.c
index a6ca27b18e15..e30de840e6c2 100644
--- a/arch/arm64/kvm/hyp/nvhe/trace.c
+++ b/arch/arm64/kvm/hyp/nvhe/trace.c
@@ -35,7 +35,7 @@ static bool hyp_trace_buffer_loaded(struct hyp_trace_buffer *trace_buffer)
 void *tracing_reserve_entry(unsigned long length)
 {
 	return simple_ring_buffer_reserve(this_cpu_ptr(trace_buffer.simple_rbs), length,
-					  trace_clock());
+					  hyp_clock_ns());
 }
 
 void tracing_commit_entry(void)
@@ -285,7 +285,7 @@ void __tracing_update_clock(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc)
 	}
 
 	/* ...we can now override the old one and swap. */
-	trace_clock_update(mult, shift, epoch_ns, epoch_cyc);
+	hyp_clock_update(mult, shift, epoch_ns, epoch_cyc);
 }
 
 int __tracing_reset(unsigned int cpu)
-- 
2.54.0.545.g6539524ca2-goog

