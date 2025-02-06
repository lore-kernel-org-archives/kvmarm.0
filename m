Received: from mail-ot1-f74.google.com (mail-ot1-f74.google.com [209.85.210.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A182905
	for <kvmarm@lists.linux.dev>; Thu,  6 Feb 2025 00:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738801111; cv=none; b=IMs363v6dt4Ehu233tIV8rCcFjFjcI7+jWjmkMNTiW1R+WezP/aK8IcAtF4bm5AW6tRtdfYPXXHH/g4kbtoDNySD7dcly7CiEGC6G1xuypYDITSrT6YYikxBfIg91pLecueK7mO3A/orrq+a/FEC2+wz/23yMyKoV/+YKvxieQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738801111; c=relaxed/simple;
	bh=E10Fe+xOECzbVvSUHJIawMxUtiAytKMIxx8zDDSzvhw=;
	h=Date:Mime-Version:Message-ID:Subject:From:To:Cc:Content-Type; b=p11HOciqbdki7THbt4l5uEKDswWaydep7ulY8rsllawPFcQt3IYDoyodGwE6aX7eAnkyzlk0MQZNa8RH/j9bYh5hZIkvQ4hnyLuNqu5gXJ338GlOLoXBVHutyjSAzBwzduix7tLsHW5paLNRAW/Q6zSE18D1gOxu9GYK0KHxC+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cefrp8gD; arc=none smtp.client-ip=209.85.210.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cefrp8gD"
Received: by mail-ot1-f74.google.com with SMTP id 46e09a7af769-71e1c2b6f72so443427a34.1
        for <kvmarm@lists.linux.dev>; Wed, 05 Feb 2025 16:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1738801109; x=1739405909; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Zr3/LuzVjUoCOE75RpPvv8HgrgBhtrHXf0v0cKrFx3I=;
        b=cefrp8gDvTCB7qiCnkEb5UOkSOoifNNbRBfWeZfYD8N1wgCwgaM8kQxbldCuOJswNA
         PwymaqE2Pgo+XkcKDQsoTWLL10med4O3iXvH5rgVHBVx8shZ95v9iEKoJt1o68XGaLXJ
         Sm5LU64/9dp1WSPP+DSmcWDmcpkbTY6hpwkIX2Oo5rQWYi9aCo5PZswQwh+vTSZXbcqO
         H47eQIPu0zvyUuXU9z1cVnVWA0OZtRw28mXjv/1dQ912XXUgIxWA3dB2wIFvn4apetyZ
         y5NFYFQgys2WiysxzjUGqVBI3cdQ7svvKPmdeT65VFvwR06z/V4MbfzlOkyJnUwXdWki
         Am3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738801109; x=1739405909;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zr3/LuzVjUoCOE75RpPvv8HgrgBhtrHXf0v0cKrFx3I=;
        b=rHdVyjDthvaUbqMNDwQpWobN3jUACT+BNcaItxL+6i1sEBqmoJDapbAisnj/1qL1EJ
         txQjZVlhsbhVUcuftjAuunHOfjXsV0pTm0YiMRTlGD5X4NDvIEaYZLqXQS2bfzxOuFVR
         DwqulpyPEdtMW4s2viOdeVDUhweGPjoORHv4BEk9qSwuBG6ifyTFa9qMzDjbqFzX7hEG
         uBNXRMLc/p/sIUV8J9Yz/uDs/47CJvZql8i21bgzDaM3emh4HX+CxezeOnjvXHyvjHQQ
         vf98HndQI5ELl3G53TcESaQBaSb0cwgvl/xzY5wajWGqWed20tn0Gpy7yeH0G6WaOsD9
         Zo7w==
X-Forwarded-Encrypted: i=1; AJvYcCWtj1j0/n/3HWyctYZ/3Lg9gAIMrlEX9zJNg90GJXr07xPauFGJy2pGgveiBYivDksWRBoYDb0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwzCcBMPocHRMfBvbvk7577iJeQRpdrWyt0+Oh+D/0YZn0dtAT6
	nR8hMIHq4k2DmK8hIIJsoZHzRXfQcdAys1tjIFRhZlA8VmSdomMP36jk47Go8R81xzDFmeGZpNk
	4vMB76+fPn2w8omuf4dRclQ==
X-Google-Smtp-Source: AGHT+IEVrsS8ZrjIpYlGyg1Ed1+MVibgRhSBBaTAljJpus0kxqPO6kMqiuj10XnP6c5iR6jfwp3/WzcdNy0U3kgBdA==
X-Received: from otqn6.prod.google.com ([2002:a9d:6f06:0:b0:71d:fe90:fac3])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6830:3982:b0:71d:eee3:fd1a with SMTP id 46e09a7af769-726a3fbc8e8mr3724016a34.0.1738801108890;
 Wed, 05 Feb 2025 16:18:28 -0800 (PST)
Date: Thu,  6 Feb 2025 00:17:44 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
X-Mailer: git-send-email 2.48.1.362.g079036d154-goog
Message-ID: <20250206001744.3155465-1-coltonlewis@google.com>
Subject: [PATCH v2] KVM: arm64: Remove cyclical dependency in arm_pmuv3.h
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

asm/kvm_host.h includes asm/arm_pmu.h which includes perf/arm_pmuv3.h
which includes asm/arm_pmuv3.h which includes asm/kvm_host.h This
causes confusing compilation problems why trying to use anything
defined in any of the headers in any other headers. Header guards is
the only reason this cycle didn't create tons of redefinition
warnings.

The motivating example was figuring out it was impossible to use the
hypercall macros kvm_call_hyp* from kvm_host.h in arm_pmuv3.h. The
compiler will insist they aren't defined even though kvm_host.h is
included. Many other examples are lurking which could confuse
developers in the future.

Break the cycle by taking asm/kvm_host.h out of asm/arm_pmuv3.h
because asm/kvm_host.h is huge and we only need a few functions from
it. Move the required declarations to a new header asm/kvm_pmu.h.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---

Possibly spinning more definitions out of asm/kvm_host.h would be a
good idea, but I'm not interested in getting bogged down in which
functions ideally belong where. This is sufficient to break the
cyclical dependency and get rid of the compilation issues. Though I
mention the one example I found, many other similar problems could
confuse developers in the future.

v2:
* Make a new header instead of moving kvm functions into the
  dedicated pmuv3 header

v1:
https://lore.kernel.org/kvm/20250204195708.1703531-1-coltonlewis@google.com/

 arch/arm64/include/asm/arm_pmuv3.h |  3 +--
 arch/arm64/include/asm/kvm_host.h  | 14 --------------
 arch/arm64/include/asm/kvm_pmu.h   | 26 ++++++++++++++++++++++++++
 include/kvm/arm_pmu.h              |  1 -
 4 files changed, 27 insertions(+), 17 deletions(-)
 create mode 100644 arch/arm64/include/asm/kvm_pmu.h

diff --git a/arch/arm64/include/asm/arm_pmuv3.h b/arch/arm64/include/asm/arm_pmuv3.h
index 8a777dec8d88..54dd27a7a19f 100644
--- a/arch/arm64/include/asm/arm_pmuv3.h
+++ b/arch/arm64/include/asm/arm_pmuv3.h
@@ -6,9 +6,8 @@
 #ifndef __ASM_PMUV3_H
 #define __ASM_PMUV3_H

-#include <asm/kvm_host.h>
-
 #include <asm/cpufeature.h>
+#include <asm/kvm_pmu.h>
 #include <asm/sysreg.h>

 #define RETURN_READ_PMEVCNTRN(n) \
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cfa024de4e3..6d4a2e7ab310 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -1385,25 +1385,11 @@ void kvm_arch_vcpu_ctxflush_fp(struct kvm_vcpu *vcpu);
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
new file mode 100644
index 000000000000..3a8f737504d2
--- /dev/null
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -0,0 +1,26 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef __KVM_PMU_H
+#define __KVM_PMU_H
+
+void kvm_vcpu_pmu_resync_el0(void);
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
+#endif
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

base-commit: 2014c95afecee3e76ca4a56956a936e23283f05b
--
2.48.1.362.g079036d154-goog
