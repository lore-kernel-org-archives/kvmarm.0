Received: from mail-io1-f74.google.com (mail-io1-f74.google.com [209.85.166.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CC6279789
	for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 22:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752533974; cv=none; b=DUZMtX0v3z6izIzBebzu2oRVxvYlN5U8JeNR1cGk3PhkO+tG0A+Rt0WBVUwbqcX1ZhpnMUFUvD8Y8fekfxIpB6Jf7UoUAv2rb4/wQG05SCvT0Kp7ONqr7iXbgkTiNQOUCqzSDvTNfT411A32Bmf3vSfvSrcBEmgO8fOsIt81JwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752533974; c=relaxed/simple;
	bh=hOTRa511jzbS7yKwTFBz9jTYvhLCpapYcm6zER8h/+U=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=KlaL8V1O8TY4nLNR1v41N4P5B16gk85+Qg+9/VqWovlKEIXaX4AVasCCL5fyw7j4QAQpNo6R7bFnWI9WzhxUj+9wvT4LLXuxheWef31y/0QitnY0fQZtmuM5kujo97vMaw61bWO+FAVQiafbjmFfgjQdwtPzGjOa5CRJfGe+31k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TpjMPYQ6; arc=none smtp.client-ip=209.85.166.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TpjMPYQ6"
Received: by mail-io1-f74.google.com with SMTP id ca18e2360f4ac-86cfccca327so990387439f.2
        for <kvmarm@lists.linux.dev>; Mon, 14 Jul 2025 15:59:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1752533972; x=1753138772; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RsXzykyZ0LoYkkSjRYm7JEpztKOUc4MUEbwC3RjOmME=;
        b=TpjMPYQ60DNulOMsHsYJ7sBL8dYV50vy4TNG3jsEMGMU5Ea2p1bBuXqDFWT7eyT51c
         RMlFELSMPtrAuWqOstISZbQ2UVrCf/5qZsjLQU+uOygKuxnNtUqTFrBw0vYARcWwMXBT
         HcVPgqzeAMrH+U6IPCbWyPjLg5IiOR7/0Lv3Bq+UZ8D5R1FIHkHSn03mJSqPfX5y1qGA
         g/KwbSac4rDmqZ5MyVrytwld308EFdHPKGimBNKxLrVhZ23HV+Q1wAM2bczvf4FkYcEb
         DmDqWwHdd02OSq6WpWdbhSfuPfHaWQA6qt3wPVDTekalSzPtSwP5fyd83xrbpB2VnVG7
         byFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752533972; x=1753138772;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RsXzykyZ0LoYkkSjRYm7JEpztKOUc4MUEbwC3RjOmME=;
        b=JYPADWAzA/mnmImF2MdoJyKylME90it65VTjFszyPjoDdEIupDTQwuy6jr+uuiR9j0
         UPVeqb9dKom7t63te4tHT+kKTbg6zrtuJQ9CErjpYdzPsmHlxcCCKmqJ3CuX6UJYui27
         pZSb0s1Wqk/DOVSjL9AfMQQGe9YBwYBC9OvadUvCCEsxDMGpZ+6J5mSqcJdthB21LeiU
         iMyn0JOWHkx4LmfwnsPiKlWk5zRqU7iLw5gN/i5wnn3oJNip6jXQ0D3bX8xFW3VYChbO
         rKKnJWiTuzE7TK9EzFdWSu/Lj2tag4TpafCefvS0D7UUu/V7viFFiJIoRogdGx1Bwc8y
         +2JA==
X-Forwarded-Encrypted: i=1; AJvYcCWaKDzjud0LVQxIWgSgsNILL0LaPrTqenaAeAwBwgg9NXBeXk74R1q2eU2vQNkKxordnBlLuuA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxjKaNG3eU2WPYn7kEhiEsoYKcdnf+J6jjrORBJ092Fm+uhwnNv
	Y/GHH1CdF4wqaC89QR2VYpQ954mizLCkzK4tIlq1XbjMrlzT7kkojpzp3TKnYC955PpIgu9dUO/
	kTsF1ElUR9FmpLTHPDJqeEgQeWA==
X-Google-Smtp-Source: AGHT+IEpddQm39eOue1RsOnjPQc1DAuSYoVtcPcyMtHmEBXoJpp94iomugG2xoJBhD4Zximcypfn3q/M/U33LBaYPw==
X-Received: from iosu5.prod.google.com ([2002:a05:6602:29a5:b0:86c:f382:ca9f])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6602:6c0e:b0:876:8790:6ac8 with SMTP id ca18e2360f4ac-879b0a8db9emr69267639f.1.1752533972180;
 Mon, 14 Jul 2025 15:59:32 -0700 (PDT)
Date: Mon, 14 Jul 2025 22:58:56 +0000
In-Reply-To: <20250714225917.1396543-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250714225917.1396543-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250714225917.1396543-3-coltonlewis@google.com>
Subject: [PATCH v4 02/23] KVM: arm64: Reorganize PMU includes
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

From: Marc Zyngier <maz@kernel.org>

Including *all* of asm/kvm_host.h in asm/arm_pmuv3.h is a bad idea
because that is much more than arm_pmuv3.h logically needs and creates
a circular dependency that makes it easy to introduce compiler errors
when editing this code.

asm/kvm_host.h includes asm/kvm_pmu.h includes perf/arm_pmuv3.h
includes asm/arm_pmuv3.h includes asm/kvm_host.h

Reorganize the PMU includes to be more sane. In particular:

* Remove the circular dependency by removing the kvm_host.h include
  since it isn't needed in that header.

* Conditionally on ARM64, include the more targeted kvm_pmu.h directly
  in the arm_pmuv3.c driver, where some functions defining the KVM/PMU
  interface are needed.

* Move the last bit of KVM/PMU interface from kvm_host.h into
  kvm_pmu.h

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/arm_pmuv3.h |  2 --
 arch/arm64/include/asm/kvm_host.h  | 14 --------------
 arch/arm64/include/asm/kvm_pmu.h   | 15 +++++++++++++++
 drivers/perf/arm_pmuv3.c           |  5 +++++
 4 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 8a777dec8d88..cf2b2212e00a 100644
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
index 27ed26bd4381..92d672429233 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1487,25 +1487,11 @@ void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu);
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
diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index baf028d19dfc..ad3247b46838 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -11,9 +11,15 @@
 #include <linux/kvm_types.h>
 #include <linux/perf_event.h>
 #include <linux/perf/arm_pmuv3.h>
+#include <linux/perf/arm_pmu.h>
 
 #define KVM_ARMV8_PMU_MAX_COUNTERS	32
 
+#define kvm_pmu_counter_deferred(attr)			\
+	({						\
+		!has_vhe() && (attr)->exclude_host;	\
+	})
+
 #if IS_ENABLED(CONFIG_HW_PERF_EVENTS) && IS_ENABLED(CONFIG_KVM)
 struct kvm_pmc {
 	u8 idx;	/* index into the pmu->pmc array */
@@ -68,6 +74,9 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu,
 int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu);
 
 struct kvm_pmu_events *kvm_get_pmu_events(void);
+void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
+void kvm_clr_pmu_events(u64 clr);
+bool kvm_set_pmuserenr(u64 val);
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_resync_el0(void);
@@ -161,6 +170,12 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 
 #define kvm_vcpu_has_pmu(vcpu)		({ false; })
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
diff --git a/drivers/perf/arm_pmuv3.c b/drivers/perf/arm_pmuv3.c
index 3db9f4ed17e8..c2e3672e1228 100644
--- a/drivers/perf/arm_pmuv3.c
+++ b/drivers/perf/arm_pmuv3.c
@@ -9,6 +9,11 @@
  */
 
 #include <asm/irq_regs.h>
+
+#if defined(CONFIG_ARM64)
+#include <asm/kvm_pmu.h>
+#endif
+
 #include <asm/perf_event.h>
 #include <asm/virt.h>
 
-- 
2.50.0.727.gbf7dc18ff4-goog

