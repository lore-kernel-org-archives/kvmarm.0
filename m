Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E802040B3
	for <kvmarm@lists.linux.dev>; Tue,  4 Feb 2025 19:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738699040; cv=none; b=LXt3de0J6JP7SeaAySaifvDjm539zPrfdoL+n3epfdfXwkF2+tg9q7NcdyhwQpmZblgjHiEttyMAzTx9h22bPzWwjcJQu3y5hYT3omI8EvMgzeEPUIAShf1hPAUJEl4SoMSa1SOuKVxahQJmSu62O/+Ipc925mm6LUe/XSj5VBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738699040; c=relaxed/simple;
	bh=iOVyrLDdjhClqri6WHcNTlHR5a0RTnuE85GltSUcA+A=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=Y1YAZxiKKoRSWy9iRbGou8m5Wm4MgZnl/wcmgmYWuyBCd+1Gxlt2wRPSe8SJicMx/GJDMsrkc8TRqx3ZT0fzxJwdpuZKS6o+HVf3c21ELt75WJsqB6jpIHaUqoYX5nzeHRdq6hKBuPma9btjqXdzhuirLI5Rm3Nwpq4t5xDoILk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0mB1jmPO; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0mB1jmPO"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3cfba1ca53bso40592535ab.3
        for <kvmarm@lists.linux.dev>; Tue, 04 Feb 2025 11:57:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738699038; x=1739303838; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=x3nz+sLxzv+mI2fev0uHpyDdU92jr9O5Wy0bm9zvTf8=;
        b=0mB1jmPOyvNfpmtYc2wnFMUbPx/h13uIvpQuAJzn71ywhjiwAxBU38OGgntcToXTqo
         iN2DW/FmWfAG0CMxGRRaVGyS3zGFxa86hwUw/6X+SSSEQ1sisebQkqmimkUwwVYYkV3P
         84dzy9k5tu4m18aoq+rUXv5FMJjvjhsFKgrCCjrQpT2ObqLi4NrLQ6FXT4yQIaEWUynr
         DbZgPlLlg7j5Qj1KYgFGgQXB67mx1ZXIPWTg+GkWHNPvj2KyPdDs7Y6RS9WJlFKR7LHV
         K3XcRRpYikwAhBiBqaPDyhAW7xJc2vpW17ghK5K1a6Yr1SkxqDVsuWJJHFfT1El3ABg/
         dDpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738699038; x=1739303838;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x3nz+sLxzv+mI2fev0uHpyDdU92jr9O5Wy0bm9zvTf8=;
        b=bG1PhSbI3hYbCUnsOEe6GZ0JPu2+GWhk3N6yw/l26LPNpXxunxFO+Y0ML+XGOGyaMR
         AjaZGe/NtcQoId+9XJB+099c6K/G2E1tszefvKnISqdqCHLa74OKFsfwRpLq8VtlNVyK
         V6sgXY0gWNwlN0B5UKtiW8KbstTIR2SbYheqwm5OwTwISGUJ6BTPda557kA+6FdE1+UM
         MOif6+FRHlgJN0uoAVvS0fJyMNgdxtPzoOEcUWd7WIllZJ5qL+8+m8+VlD/xiqC8Z8es
         oIKNX0pB41n+1NVcsKAyFZnRc3pEKO5JjYfk37anc0mnhU0DEUOcs17VoeHSeljsDR1V
         nTVA==
X-Forwarded-Encrypted: i=1; AJvYcCVAvah3N4NOGjaFCfj3X0XAko5cLrJBl3CdmBqV/Ah2w5adHxc5dwwgzBkCQgtFiFC6t9Gimh0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyGxUAXyMuP8ECkuWFBlxsmRDPBfBPszgzwMbll72l1W9pIZ2wf
	aOpPZNPgM7aGizFqOfHId+dHbaYwncgGoi3lwkuVJ9svOBJ7hwoq2abun/LVlI0n8FNR3x1lfO1
	hpC5MM3S5ub1nOXzhAZOhSg==
X-Google-Smtp-Source: AGHT+IFCbd5TbwVMrhJK2bcQCyfCgg4ls4jmx2Zok6lCN7ChS3uIDAMydUcwYx7x9fORmL8hc1+yBurzn+Nb2fztvw==
X-Received: from ilbcr10.prod.google.com ([2002:a05:6e02:3a8a:b0:3ce:8bff:8b9d])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1746:b0:3d0:24c0:bd37 with SMTP id e9e14a558f8ab-3d04f459238mr1943175ab.11.1738699038254;
 Tue, 04 Feb 2025 11:57:18 -0800 (PST)
Date: Tue,  4 Feb 2025 19:57:07 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250204195708.1703531-1-coltonlewis@google.com>
Subject: [PATCH 1/2] perf: arm_pmuv3: Remove cyclical dependency with kvm_host.h
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

asm/kvm_host.h includes asm/arm_pmu.h which includes perf/arm_pmuv3.h
which includes asm/arm_pmuv3.h which includes asm/kvm_host.h This
causes confusing compilation problems when trying to use anything in
the chain.

Break the cycle by taking asm/kvm_host.h out of asm/arm_pmuv3.h
because asm/kvm_host.h is huge and we only need a few functions from
it. Move the required declarations to asm/arm_pmuv3.h.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/arm_pmuv3.h | 24 ++++++++++++++++++++++--
 arch/arm64/include/asm/kvm_host.h  | 18 ------------------
 include/kvm/arm_pmu.h              |  1 -
 3 files changed, 22 insertions(+), 21 deletions(-)

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 8a777dec8d88..89fd6abb7da6 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -6,11 +6,31 @@
 #ifndef __ASM_PMUV3_H
 #define __ASM_PMUV3_H
 
-#include <asm/kvm_host.h>
-
 #include <asm/cpufeature.h>
 #include <asm/sysreg.h>
 
+#include <linux/perf_event.h>
+
+#ifdef CONFIG_KVM
+void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
+void kvm_clr_pmu_events(u64 clr);
+bool kvm_set_pmuserenr(u64 val);
+#else
+static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
+static inline void kvm_clr_pmu_events(u64 clr) {}
+static inline bool kvm_set_pmuserenr(u64 val)
+{
+	return false;
+}
+#endif
+
+static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
+{
+	return (!has_vhe() && attr->exclude_host);
+}
+
+void kvm_vcpu_pmu_resync_el0(void);
+
 #define RETURN_READ_PMEVCNTRN(n) \
 	return read_sysreg(pmevcntr##n##_el0)
 static inline unsigned long read_pmevcntrn(int n)
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index e18e9244d17a..3eeb762944c9 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1362,28 +1362,10 @@ void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu);
 
-static inline bool kvm_pmu_counter_deferred(struct perf_event_attr *attr)
-{
-	return (!has_vhe() && attr->exclude_host);
-}
-
 /* Flags for host debug state */
 void kvm_arch_vcpu_load_debug_state_flags(struct kvm_vcpu *vcpu);
 void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu);
 
-#ifdef CONFIG_KVM
-void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr);
-void kvm_clr_pmu_events(u64 clr);
-bool kvm_set_pmuserenr(u64 val);
-#else
-static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
-static inline void kvm_clr_pmu_events(u64 clr) {}
-static inline bool kvm_set_pmuserenr(u64 val)
-{
-	return false;
-}
-#endif
-
 void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu);
 void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu);
 
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 147bd3ee4f7b..2c78b1b1a9bb 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -74,7 +74,6 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu);
 struct kvm_pmu_events *kvm_get_pmu_events(void);
 void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu);
 void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu);
-void kvm_vcpu_pmu_resync_el0(void);
 
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))

base-commit: 5bc55a333a2f7316b58edc7573e8e893f7acb532
-- 
2.48.1.362.g079036d154-goog

