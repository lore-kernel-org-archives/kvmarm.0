Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6D8044B675
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 11:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784116757; cv=none; b=cbdqiqjesigUyfvuTcp1sXeYfPgTBKCO3vgKWhRY32WL3DkhFOuCJwnZfVMY8RMCm7HInHsLoZ71v/DZMMxFN8yWFc/Bxnx/yXXoLdMgEnCrPjbADphsM8rUr6IxaWwC/sVCfYk5E016xP+l6/PCGRHyzR9s8459fAuTVSOfAgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784116757; c=relaxed/simple;
	bh=l/hpWbBATRgNusqw4IkGxPNUk54fHjitd3cZTYOU0Us=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=gT3Dn9Mv4RDfPGdjio6ACSaz7KCgetssvuG7e4F7DzWbDOBh5PVC+yZnzoS9gE61fF3gEW+QSbjkRRsDFx480B4EM6nz3K0AUvNdocodRoSt9dHMLOw1x3TLuCiUZJV4OSBablnfIkcq3K0gJfneFZ9aiNWdCpTs+nfP95T32MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=jLv4MmxW; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--smostafa.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="jLv4MmxW"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-493ba771d1bso20790775e9.2
        for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 04:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784116754; x=1784721554; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ol5Kv9IuMOC5gLvUo+ftrDGNdodUvogtRoPdfqHnaTA=;
        b=jLv4MmxWsUkmO1NIY0lry557eRIAGnz6s0si2IibyBHmS1LBDNsbGx6ukTwbvYH59T
         30KobxENxHsHxeux3/QomYoN11W1N4qHnDjvsoXiiqIHt9FGzQGoGJ8JPUFw89cfz8bq
         bR6G/PCeOdOqjgr2xpQeIZ9HuRqeKygMkImpldIc+rXb1oah1ZDXoQN/sO6973viYhZf
         SJ0YJ9AlVgFEcgYDVwikADUay8tPsUO7wASpzq9AE/vMjV9XBhenZlpechmxaqpNfLSP
         hENEocHfIHrPnInLyqFcxoih707lV/G+EFs6Q9TWJAlIJ4MNbHUioMWtGPS/tTDoqyoL
         kDmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784116754; x=1784721554;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ol5Kv9IuMOC5gLvUo+ftrDGNdodUvogtRoPdfqHnaTA=;
        b=ermOxBgD5izbCFTgIps8SPpe152+I9GegEgC8IpaRRfeau8pDwvF9OHFTkBWmgOa5N
         6YrnlLv+h5NwaliQzDmMn01dhK9XIpQMyt8lQxWuz8VsxJagbj8UA3Fley++I5O0aBb4
         lAOd/wpAq92TbqN0I0/ePyAI63DbXwVeyz3e6zH6Z+CNVHOfbLcxgoTXPXnnVSqcKvY5
         WavB6E4HO3AeemqhZ3o9fNBckoOOBEOjEuHmlAJ9jvXobR+OijFfBAqkUTGdrCHwQ/QU
         MDVNMMQlwkLtYu3ApuO5TyxZT7Dva3d9UFl8YWgDuAeNVxY49ALA2ngPlnviXdqvLHP0
         BYnQ==
X-Forwarded-Encrypted: i=1; AHgh+Rq3DPxrpb/io00AoF5MCAC47CV2IfbzRlEkTlDTnbEjXSmqqapNnH1vFmqLis7SVnG6TM53Hi8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyH4fDS/fiHJgGJ8v1kAeeuKKLMmDfYYZ6u97CfY/n7PSWYv9mZ
	ErUzpIU0yQXI8z5IKHfMaRw1j43x75fHjZJTALMCb3gODnQ4lyyUwbOIva3apZGVOetwFhyUJVq
	VLVJR1svrK2+Y6g==
X-Received: from wmbe13.prod.google.com ([2002:a05:600c:590d:b0:493:bb14:ecfa])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3f06:b0:495:3c8c:c16a with SMTP id 5b1f17b1804b1-4953c8cc25bmr27537525e9.0.1784116753865;
 Wed, 15 Jul 2026 04:59:13 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:58:42 +0000
In-Reply-To: <20260715115906.2664882-1-smostafa@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260715115906.2664882-1-smostafa@google.com>
X-Mailer: git-send-email 2.55.0.141.g00534a21ce-goog
Message-ID: <20260715115906.2664882-2-smostafa@google.com>
Subject: [PATCH v7 01/24] KVM: arm64: Add a generic clock
From: Mostafa Saleh <smostafa@google.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, iommu@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, maz@kernel.org, 
	oliver.upton@linux.dev, joey.gouly@arm.com, suzuki.poulose@arm.com, 
	yuzenghui@huawei.com, joro@8bytes.org, jgg@ziepe.ca, mark.rutland@arm.com, 
	qperret@google.com, tabba@google.com, vdonnefort@google.com, 
	sebastianene@google.com, keirf@google.com, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"

IOMMU drivers need to track time, mainly for timeouts.

Add 2 new functions to nvhe/clock.c:
- hyp_clock_init(): Get the system timer frequency at boot
- hyp_clock_ns(): Get current time in nano seconds.

This is mainly used for timeouts, so a malicious host can DoS the
system or cause premature timeouts which likely end up in hyp panic,
that should be acceptable as neither of those would undermine the
security guarantees.

Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 arch/arm64/kvm/hyp/include/nvhe/clock.h |  3 +++
 arch/arm64/kvm/hyp/nvhe/Makefile        |  4 ++--
 arch/arm64/kvm/hyp/nvhe/clock.c         | 29 +++++++++++++++++++++++++
 arch/arm64/kvm/hyp/nvhe/setup.c         |  5 +++++
 4 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/hyp/include/nvhe/clock.h b/arch/arm64/kvm/hyp/include/nvhe/clock.h
index ae03ec6965af..7ef982939bf9 100644
--- a/arch/arm64/kvm/hyp/include/nvhe/clock.h
+++ b/arch/arm64/kvm/hyp/include/nvhe/clock.h
@@ -13,4 +13,7 @@ static inline void
 trace_hyp_clock_update(u32 mult, u32 shift, u64 epoch_ns, u64 epoch_cyc) { }
 static inline u64 trace_hyp_clock(void) { return 0; }
 #endif
+
+u64 hyp_clock_ns(void);
+int hyp_clock_init(void);
 #endif
diff --git a/arch/arm64/kvm/hyp/nvhe/Makefile b/arch/arm64/kvm/hyp/nvhe/Makefile
index f57450ebcb49..7c879292974d 100644
--- a/arch/arm64/kvm/hyp/nvhe/Makefile
+++ b/arch/arm64/kvm/hyp/nvhe/Makefile
@@ -26,10 +26,10 @@ hyp-obj-y := timer-sr.o sysreg-sr.o debug-sr.o switch.o tlb.o hyp-init.o host.o
 	 hyp-main.o hyp-smp.o psci-relay.o early_alloc.o page_alloc.o \
 	 cache.o setup.o mm.o mem_protect.o sys_regs.o pkvm.o stacktrace.o ffa.o
 hyp-obj-y += ../vgic-v3-sr.o ../aarch32.o ../vgic-v2-cpuif-proxy.o ../entry.o \
-	 ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o
+	 ../hyp-entry.o ../exception.o ../pgtable.o ../vgic-v5-sr.o clock.o
 hyp-obj-y += ../../../kernel/smccc-call.o
 hyp-obj-$(CONFIG_LIST_HARDENED) += list_debug.o
-hyp-obj-$(CONFIG_NVHE_EL2_TRACING) += clock.o trace.o events.o
+hyp-obj-$(CONFIG_NVHE_EL2_TRACING) += trace.o events.o
 hyp-obj-y += $(lib-objs)
 
 # Path to simple_ring_buffer.c
diff --git a/arch/arm64/kvm/hyp/nvhe/clock.c b/arch/arm64/kvm/hyp/nvhe/clock.c
index f3e2619db4e4..43d2cba4f810 100644
--- a/arch/arm64/kvm/hyp/nvhe/clock.c
+++ b/arch/arm64/kvm/hyp/nvhe/clock.c
@@ -8,7 +8,12 @@
 
 #include <asm/arch_timer.h>
 #include <asm/div64.h>
+#include <linux/math64.h>
+#include <vdso/time64.h>
 
+static u32 timer_freq;
+
+#ifdef CONFIG_NVHE_EL2_TRACING
 static struct clock_data {
 	struct {
 		u32 mult;
@@ -66,3 +71,27 @@ u64 trace_hyp_clock(void)
 
 	return (u64)ns + clock->data[bank].epoch_ns;
 }
+#endif /* CONFIG_NVHE_EL2_TRACING */
+
+int hyp_clock_init(void)
+{
+	timer_freq = read_sysreg(cntfrq_el0);
+	/*
+	 * KVM will not initialize if FW didn't set cntfrq_el0, that is already
+	 * part of the boot protocol.
+	 */
+	if (!timer_freq)
+		return -ENODEV;
+
+	/* Timer freq can't be larger than 1Ghz by spec. */
+	if (timer_freq > NSEC_PER_SEC)
+		return -EINVAL;
+
+	return 0;
+}
+
+/* Return time in ns. */
+u64 hyp_clock_ns(void)
+{
+	return mul_u64_u32_div(__arch_counter_get_cntvct(), NSEC_PER_SEC, timer_freq);
+}
diff --git a/arch/arm64/kvm/hyp/nvhe/setup.c b/arch/arm64/kvm/hyp/nvhe/setup.c
index 75b00c323310..970c5cf342f5 100644
--- a/arch/arm64/kvm/hyp/nvhe/setup.c
+++ b/arch/arm64/kvm/hyp/nvhe/setup.c
@@ -10,6 +10,7 @@
 #include <asm/kvm_pgtable.h>
 #include <asm/kvm_pkvm.h>
 
+#include <nvhe/clock.h>
 #include <nvhe/early_alloc.h>
 #include <nvhe/ffa.h>
 #include <nvhe/gfp.h>
@@ -320,6 +321,10 @@ void __noreturn __pkvm_init_finalise(void)
 	if (ret)
 		goto out;
 
+	ret = hyp_clock_init();
+	if (ret)
+		goto out;
+
 	ret = fix_host_ownership();
 	if (ret)
 		goto out;
-- 
2.55.0.141.g00534a21ce-goog

