Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF3C4A0926
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 17:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790270978; cv=none; b=eHmylkzEG++o6AzAlUxLzbmOYtSzauPZOkehJWEAvZ3K8Hm2XJJ2lBeExf+Q1FTbDv74bgP2wwSK7xgqd02sJhlDaEpVNbykrQ5CdO23PVd3cawLalr20PhFuJtvidPEoHRf5e2LbG1SObsuYNQ1v3gdHYjgx49xR9fnrHNkJuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790270978; c=relaxed/simple;
	bh=VlWvAjAP1913DfFfg+Z/66iJjPOhP9T8nprEmhFxqQg=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=lOBK4IPSXFlazkZYbdCorObL6adxudm2h7k3QuFMo9J1LO7PyEN5175VAlZgLTjW7qkKtDoxDsYKWhOQPWoGblL5AwY39igFwU0DcC0YBQj5WQKvHl/t0OZYKIVD1B4IHu4qlk8AuJBP3ZhXkGSGONWgzn18wx0UOd05aSbSS5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dnmOoJ7f; arc=none smtp.client-ip=209.85.160.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dnmOoJ7f"
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-46509ab0149so144320fac.2
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790270973; x=1790875773; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RYFEpxoGGmna9mpp9QPIVq2tst2FuBotWNGHR3RNMBQ=;
        b=dnmOoJ7f8DtJYrOb4Jx3JQm3GVrxd5f07PPZkAnopKXWaA7mJBjP0MVJKHDbDqCvcZ
         26GbSe7gW+ovS0xKuGtmgUwdAuFDBZzOEvY5ton6SYdTTV2loOCJT/pxG+6QD+mmBMvo
         sGNdIepnuLR6g9ICW/9OOeMWGQDWXRr7WrriUbRv0luMPF79i8AuPdufoM8C7t3Kr4RT
         CEfGNBomdxovZGko+eJ0yy+2nWx0y1vSvj6AB36TUpDnGOEwlYPFtbUevbbeKuQUQZ/i
         Ykvg5KMh2CW0vnwSQjou34WxIT/ONSciw7BMPHL4zLJ97IRDjTm+EExWCVVA5eq3Xfoa
         aiwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790270973; x=1790875773;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RYFEpxoGGmna9mpp9QPIVq2tst2FuBotWNGHR3RNMBQ=;
        b=VPeUM+MMBzAVJsITuNXgf8zSO0ke9VgyzUIEoaQMl4P9IxVyA/g74UgCxr9oxhXrCJ
         WZiZaMn3WyCTJpXgn7ufHs9IGAIyxuaHAmaXjt4ECg1D5BCGs8fhdrkJY1sNIW4l+t/O
         q0CHYGSNRExnnjecbnrOGV9EDiOlqkZDrzwH9tnRNqAtFAtZNsdrkPVBrVvqPRj2ET8a
         vxQGlAT5l8QUJqgIh9KojAjOIGyTJMnnheSVrIf8TYqPcuOBt6AcWoh+6HHDPgvu3AqP
         yirIbVqOnLEWNa8orDZP4tnnS95jSfqPwrRLDPxLvnB/uciUWKOuHO9qbs59JAjx0mpn
         0rYA==
X-Forwarded-Encrypted: i=1; AKwUvBx7QbGGW8lFOl35AtZcilX2FG69Q/QHUaUD8pefJYXdWN2MNsvObYRR5WB4bdQaHavPGPC2W+8=@lists.linux.dev
X-Gm-Message-State: AFuF++nsD91KUFwZJO6JInztthWvBpiAecA60qKOHpMdt3tgpg2uPyVe
	6xSDtWfub8VQtQPh6DofR6A2Ob7MDqjBTE9KrLMw4vuQEuthEeZysfqBTQ2WlfRblydnHXGboF2
	mQrDDiKzdiB2Z5zoB7LD6lFhjcQ==
X-Received: from iloo5-n1.prod.google.com ([2002:a05:6e02:6105:10b0:509:e003:76d7])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:22a4:b0:4b3:3e1:4a25 with SMTP id 5614622812f47-4d728925895mr3587842b6e.11.1790270972821;
 Thu, 24 Sep 2026 10:29:32 -0700 (PDT)
Date: Thu, 24 Sep 2026 17:29:08 +0000
In-Reply-To: <20260924172928.2110956-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260924172928.2110956-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260924172928.2110956-3-coltonlewis@google.com>
Subject: [PATCH v9 02/22] KVM: arm64: Reorganize PMU includes
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	James Clark <james.clark@linaro.org>, Robin Murphy <robin.murphy@arm.com>, 
	Zide Chen <zide.chen@intel.com>, Alexandru Elisei <alexandru.elisei@arm.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, Mingwei Zhang <mizhang@google.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, Shuah Khan <shuah@kernel.org>, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

From: Marc Zyngier <maz@kernel.org>

Including *all* of asm/kvm_host.h in asm/arm_pmuv3.h is a bad idea
because that is much more than arm_pmuv3.h logically needs and creates
a circular dependency that makes it easy to introduce compiler errors
when editing this code.

asm/kvm_host.h includes kvm/arm_pmu.h includes perf/arm_pmuv3.h
includes asm/arm_pmuv3.h includes asm/kvm_host.h

Reorganize the PMU includes to be more sane. In particular:

- Remove the circular dependency by removing the kvm_host.h include
  from asm/arm_pmuv3.h since 99% of it isn't needed.

- Move the remaining tiny bit of KVM/PMU interface from kvm_host.h
  into arm_pmu.h

- Conditionally on ARM64, include the more targeted arm_pmu.h directly
  in the arm_pmuv3.c driver.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/arm_pmuv3.h |  2 --
 arch/arm64/include/asm/kvm_host.h  | 14 --------------
 drivers/perf/arm_pmuv3.c           |  5 +++++
 include/kvm/arm_pmu.h              | 19 +++++++++++++++++++
 4 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 8a777dec8d88a..cf2b2212e00a2 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -6,8 +6,6 @@
 #ifndef __ASM_PMUV3_H
 #define __ASM_PMUV3_H
 
-#include <asm/kvm_host.h>
-
 #include <asm/cpufeature.h>
 #include <asm/sysreg.h>
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 27fe0cd5b2d7a..217c36af1ca51 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1467,25 +1467,11 @@ void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
 
-static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
-{
-	return (!has_vhe() && attr->exclude_host);
-}
-
 #ifdef CONFIG_KVM
-void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
-void kvm_clr_pmu_events(u64 clr);
-bool kvm_set_pmuserenr(u64 val);
 void kvm_enable_trbe(void);
 void kvm_disable_trbe(void);
 void kvm_tracing_set_el1_configuration(u64 trfcr_while_in_guest);
 #else
-static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
-static inline void kvm_clr_pmu_events(u64 clr) {}
-static inline bool kvm_set_pmuserenr(u64 val)
-{
-	return false;
-}
 static inline void kvm_enable_trbe(void) {}
 static inline void kvm_disable_trbe(void) {}
 static inline void kvm_tracing_set_el1_configuration(u64 trfcr_while_in_guest) {}
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 03359e078301f..fbd631ec71a65 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -10,6 +10,11 @@
 
 #include <asm/cputype.h>
 #include <asm/irq_regs.h>
+
+#if defined(CONFIG_ARM64)
+#include <kvm/arm_pmu.h>
+#endif
+
 #include <asm/perf_event.h>
 #include <asm/virt.h>
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 6b4a118d17ca9..93f41ac77c25f 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -9,12 +9,22 @@
 
 #include <linux/perf_event.h>
 #include <linux/perf/arm_pmuv3.h>
+#include <linux/perf/arm_pmu.h>
 
 #define KVM_ARMV8_PMU_MAX_COUNTERS	32
 
 /* PPI #23 - architecturally specified for GICv5 */
 #define KVM_ARMV8_PMU_GICV5_IRQ		0x20000017
 
+#define kvm_pmu_counter_deferred(attr)			\
+	({						\
+		!has_vhe() && (attr)->exclude_host;	\
+	})
+
+struct kvm;
+struct kvm_device_attr;
+struct kvm_vcpu;
+
 #if IS_ENABLED(CONFIG_HW_PERF_EVENTS) && IS_ENABLED(CONFIG_KVM)
 struct kvm_pmc {
 	u8 idx;	/* index into the pmu->pmc array */
@@ -68,6 +78,9 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu);
 
 struct kvm_pmu_events *kvm_get_pmu_events(void);
+void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
+void kvm_clr_pmu_events(u64 clr);
+bool kvm_set_pmuserenr(u64 val);
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_resync_el0(void);
@@ -165,6 +178,12 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 #define kvm_vcpu_has_pmu(vcpu)		({ false; })
 #define kvm_vcpu_has_pmuv3_strict(vcpu)	({ false; })
 static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
+static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
+static inline void kvm_clr_pmu_events(u64 clr) {}
+static inline bool kvm_set_pmuserenr(u64 val)
+{
+	return false;
+}
 static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu) {}
-- 
2.56.0.rc1.310.g51773c2048-goog

