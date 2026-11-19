Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114374;
	b=qj6uGv8nwiFzNGTE06HbZz0sSWNeUULmzzjdEYpL1QFMgQf6N56sY0URlc/3lohr42UN
	 oi9WA5O4V+6+LBZ/WERK4Tq9Pw8ipi186fZW0bfqnXnLr3aUtYvCpAj7HSKZXCLM5Z92I
	 aeemqB3CoM62C2T8HCIpf3JZl5ilvP/i98/761hKGWtU6XySAdHFx1gdjkKNtwjD4Ffsa
	 Q1lo0WHP+3+B/WxTiih7WCAT2r/BYFvDaw32B4qzneDjqFtBmZpzbYG0EkoqYzYd5Rf9X
	 bV/PQ1H1KFD5zhuPa1HQot73VnOPiswli93FzDieeo3ncIHd9ZVVdjHxIq4po2QfETA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114374;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:Mime-Version:
	 X-Mailer:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=TH5vitwFPm9bGuJwkWFGWD1DGO5XNv6nZY+HFNZ0AOQ=;
	b=GVO+KHP2YU7t2l6ar2GA2FzHLhMgSMXG+T8b9JtJjLC5wu30x5w3a5SZnxdAFb8qac8/
	 OiyrkRD5GJC+I/wsKjzYiV4+a2qp5LvrdismRnQvYlaOY7mOAebn0eo1CBU9hxaQ6tkuN
	 8ird56lSnA7xAJJ5cpIriKdz2JEr0fkFGZ5y1z2OIVF7Rs173M8CjmQYn185tpJQz9G0Z
	 EgqQI21b/k87keCTCAjrss69bkGaa9P90SX2bN2TUQRUbJT3UoXAmLfjonjd1+9dlS9d8
	 I2Vs6w1zmZ0q1b6wj4hxWp9LRwJYJ/SsMRGIppckIpYWhLVKi8gdl7jQ2KVYu3MUUbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OYeeuFXl;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C82460A5BE0
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9C82460A5BE0
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=OYeeuFXl
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-540537f959fso199566b6e.0
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114373; x=1795719173; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=TH5vitwFPm9bGuJwkWFGWD1DGO5XNv6nZY+HFNZ0AOQ=;
        b=OYeeuFXlN5WaHA9lXM2yVBl/9zw8idc6TbXkfdXhrDVzFVW0Qnv5vMNaFfhN4W/R8y
         quI2gIAAXNrHBYYgtrasg4gYv/i3PvhH1sQEZbLBnWlHYSpmoM6vbtpq4cBFZp0oO2/6
         xIuuIxuO1hcvlbvtOIwmqGARTBsa+iMnyMx52DBApK9Quy75UE0bHYQoma6QNvXF7847
         1nohKmYX6QB/dDK58uQWHohWo3c4iap7LnxIFS1DVEX1wVuyNNHrKxTYmGnhuVtwMhXv
         iIHbVW5HQuhxGjMPWDbqxewMuiUQTRiufdl7Bq0394CfG++AlUIBBTp3G5zQLfntgk1n
         cVgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114373; x=1795719173;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TH5vitwFPm9bGuJwkWFGWD1DGO5XNv6nZY+HFNZ0AOQ=;
        b=R48/fQzacv4E3rpvTfMtsgZyfuEfoieMpT/JTE4M1hol9qtI2wQ2hY5g+BJpajLI0c
         P4ggRMKDF1+wnv51s4xmj13V08DlhrqoqwL7Uu09sp87MxiQQdBbWI2igJv/0ZrqN0Uh
         aobzLZxwiqmhisaJJs1n/8/POJ4Q+obXPkaY/bY/vp/yM0SoKcMCKDakslaIHt6SZIA1
         FPzuXbyRWmDruDwwoe0IqhLq7eJeZDsDx+1gUzohdV4szv0f/NbN4F137d4jLLqH47/+
         lxFbNqUew1lDYx0FGaSxPyh8vk3DyE++OaS55M9ZjSaTBSwOh1VxreWkaJN07ek7ZMM8
         fd4w==
X-Forwarded-Encrypted: i=1; AL+hErEGuOSEqZu9EscmzEpY+KQ0ZNuHekx5tyYfoDvHqIIP46H+zRrFAR3oVCkzGNScQSmSQ0RJSZk=@lists.linux.dev
X-Gm-Message-State: APuU4Z92Cq+A2iqHyc+jf6r2YV6PfUhUdNiqp/Vt+mLpHgmylYkCWll3
	nkL/6anQKML90RQGKeMisHZkuczdy5p6dF7DWTCcYFGB1e/PC01fYsVdmNDjPek8yITfvCBajCn
	HRYBNkS6xwa0JgYMM3g8laE4vIQ==
X-Received: from ilmy14.prod.google.com ([2002:a92:d80e:0:b0:50c:2841:18fc])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:1528:b0:4d6:90d3:e185 with SMTP id 5614622812f47-57a0b645ee5mr1052075b6e.46.1795114372340;
 Thu, 19 Nov 2026 10:52:52 -0800 (PST)
Date: Thu, 19 Nov 2026 18:52:51 +0000
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119185251.638036-1-coltonlewis@google.com>
Subject: [RFC PATCH v2] target/arm: Enable KVM PMU partitioning and counter limit
From: Colton Lewis <coltonlewis@google.com>
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, 
	Pierrick Bouvier <pierrick.bouvier@oss.qualcomm.com>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oupton@kernel.org>, Will Deacon <will@kernel.org>, 
	James Clark <james.clark@linaro.org>, Mingwei Zhang <mizhang@google.com>, qemu-arm@nongnu.org, 
	qemu-devel@nongnu.org, kvmarm@lists.linux.dev, kvm@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add CPU properties to configure PMU event counters and KVM ARM64 PMU
counter partitioning:
- 'kvm-pmu-partition' (bool, KVM only): enables
  KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION
- 'pmu-num-counters' (uint32, TCG and KVM): sets the number of
  general-purpose PMU event counters (PMCR_EL0.N) and configures
  KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS under KVM

When 'kvm-pmu-partition=on' and 'pmu-num-counters=N' are passed via
-cpu under KVM, QEMU enables hardware PMU partitioning and reserves N
general-purpose event counters for the guest prior to calling
KVM_ARM_VCPU_PMU_V3_INIT.

Note that this patch is an RFC to demonstrate the KVM ARM64 PMU
Partitioning uAPI. That is why it aborts immediately if setting the
device attributes does not succeed.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
Companion RFC to the v10 kernel series "ARM64 PMU Partitioning", based
on QEMU master (`08c9bbb825`, v11.2.0-rc1).
`KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION` is attribute 5 (with
`KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS` = 4), matching the v10 uAPI.

Built cleanly (0 warnings) for both native x86_64 and cross-arm64
(`aarch64-softmmu` with KVM and `aarch64-linux-user`). Verified with
the v10 kernel (`7.4.0-rc3+`):
- TCG (`aarch64-softmmu`): `pmu-num-counters` = 0, 2, default (6), 31,
  `pmu=off`, rejection of `pmu-num-counters=32` (> 31), and rejection
  of `kvm-pmu-partition=on` under TCG.
- KVM (`-accel kvm -machine virt,gic-version=3`, cross-arm64 binary
  inside a VHE TCG host with 6 GP counters): `-smp 2` boots with
  `kvm-pmu-partition=on` (`pmu-num-counters` = 0, 2, 5) and emulated
  `pmu-num-counters=3`, plus negative rejections for missing
  `pmu-num-counters`, `pmu-num-counters=6` (partitioned), `=7`
  (emulated), and `=32` (> 31). Zero host kernel warnings.

Changes since v1:
https://lore.kernel.org/kvmarm/20260924173051.2117637-1-coltonlewis@google.com/
- Rebase onto QEMU master (`08c9bbb825`, v11.2.0-rc1).
- Tag patch as RFC until the kernel uAPI is accepted (Peter Maydell).
- Document `kvm-pmu-partition` (including `pmu-num-counters=0` without
  `FEAT_HPMN0`) and `pmu-num-counters` in
  `docs/system/arm/cpu-features.rst` (Peter Maydell).
- Move the partitioning toggle into `kvm_arm_add_vcpu_properties()` as
  `kvm-pmu-partition` using `DEFINE_PROP_BOOL` (Peter Maydell).
- Keep `pmu-num-counters` general (`DEFINE_PROP_UINT32`) and wire it up
  for both TCG (`reset_pmcr_el0`) and KVM (Peter Maydell).
- Guard the `pmu_num_counters` override in `arm_cpu_realizefn()` with
  `#ifndef CONFIG_USER_ONLY` so `aarch64-linux-user` does not zero
  `reset_pmcr_el0.N`.
- Wrap commit message lines to 72 columns.

 docs/system/arm/cpu-features.rst | 29 +++++++++++++++++++++
 target/arm/cpu.c                 | 19 ++++++++++++++
 target/arm/cpu.h                 |  4 +++
 target/arm/kvm.c                 | 44 ++++++++++++++++++++++++++++++++
 4 files changed, 96 insertions(+)

diff --git a/docs/system/arm/cpu-features.rst b/docs/system/arm/cpu-features.rst
index 10b0eff27e..9d95f727be 100644
--- a/docs/system/arm/cpu-features.rst
+++ b/docs/system/arm/cpu-features.rst
@@ -217,6 +217,21 @@ the list of KVM VCPU features and their descriptions.
 
   Current valid values are: 0.1, 0.2, 1.0, 1.1, 1.2, and 1.3.
 
+``kvm-pmu-partition``
+  By default kvm-pmu-partition is disabled.
+
+  When kvm-pmu-partition is enabled, KVM partitions the physical PMUv3
+  hardware counters between the guest and host using ``MDCR_EL2.HPMN``,
+  granting the guest direct, untrapped access to its partition of event
+  counters and the cycle counter.  Enabling ``kvm-pmu-partition``
+  requires explicitly configuring the number of guest event counters via
+  ``pmu-num-counters`` to a value strictly less than the number of
+  general-purpose counters implemented by the host PMU (leaving at least
+  one general-purpose counter reserved for host profiling).  On hosts
+  without ``FEAT_HPMN0``, setting ``pmu-num-counters=0`` (cycle counter
+  only) requires at least two general-purpose host counters so physical
+  counter 0 can be reserved and hidden behind traps.
+
 TCG VCPU Features
 =================
 
@@ -495,3 +510,17 @@ Legal values for ``S`` are 30, 34, 36, and 39; the default is 30.
 
 As with ``x-rme``, the ``x-l0gptsz`` property may be renamed or
 removed in some future QEMU release.
+
+PMU CPU Properties
+==================
+
+``pmu``
+  Enable or disable the Performance Monitoring Unit (PMU).
+
+``pmu-num-counters``
+  Set the number of general-purpose event counters exposed by the PMU
+  (encoded in ``PMCR_EL0.N``) for both TCG and KVM guests (between 0 and
+  31 for TCG, or up to the number of counters supported by the host PMU
+  for KVM).  When ``kvm-pmu-partition`` is enabled under KVM, this
+  value must be strictly less than the number of general-purpose
+  counters implemented by the host PMU.
diff --git a/target/arm/cpu.c b/target/arm/cpu.c
index dde03ffdd6..81b2b83ce2 100644
--- a/target/arm/cpu.c
+++ b/target/arm/cpu.c
@@ -1361,6 +1361,9 @@ static const Property arm_cpu_pmsav7_dregion_property =
             DEFINE_PROP_UNSIGNED_NODEFAULT("pmsav7-dregion", ARMCPU,
                                            pmsav7_dregion,
                                            qdev_prop_uint32, uint32_t);
+static const Property arm_cpu_pmu_num_counters_property =
+            DEFINE_PROP_UINT32("pmu-num-counters", ARMCPU, pmu_num_counters,
+                               UINT32_MAX);
 #endif
 
 static bool arm_get_pmu(Object *obj, Error **errp)
@@ -1628,6 +1631,10 @@ static void arm_cpu_post_init(Object *obj)
     if (arm_feature(&cpu->env, ARM_FEATURE_PMU)) {
         cpu->has_pmu = true;
         object_property_add_bool(obj, "pmu", arm_get_pmu, arm_set_pmu);
+#ifndef CONFIG_USER_ONLY
+        qdev_property_add_static(DEVICE(obj),
+                                 &arm_cpu_pmu_num_counters_property);
+#endif
     }
 
     /*
@@ -2250,6 +2257,18 @@ static void arm_cpu_realizefn(DeviceState *dev, Error **errp)
         unset_feature(env, ARM_FEATURE_PMU);
     }
     if (arm_feature(env, ARM_FEATURE_PMU)) {
+#ifndef CONFIG_USER_ONLY
+        if (cpu->pmu_num_counters != UINT32_MAX) {
+            if (cpu->pmu_num_counters > 31) {
+                error_setg(errp, "pmu-num-counters %" PRIu32
+                           " exceeds maximum of 31", cpu->pmu_num_counters);
+                return;
+            }
+            cpu->isar.reset_pmcr_el0 =
+                (cpu->isar.reset_pmcr_el0 & ~PMCRN_MASK) |
+                (cpu->pmu_num_counters << PMCRN_SHIFT);
+        }
+#endif
         pmu_init(cpu);
 
         if (tcg_enabled() || hvf_enabled()) {
diff --git a/target/arm/cpu.h b/target/arm/cpu.h
index b2f393f501..990204d7b6 100644
--- a/target/arm/cpu.h
+++ b/target/arm/cpu.h
@@ -1024,6 +1024,10 @@ struct ArchCPU {
     bool has_el3;
     /* CPU has PMU (Performance Monitor Unit) */
     bool has_pmu;
+    /* CPU has PMU Partitioning enabled in KVM mode */
+    bool kvm_pmu_partition;
+    /* Number of PMU event counters (PMCR_EL0.N) */
+    uint32_t pmu_num_counters;
     /* CPU has VFP */
     bool has_vfp;
     /* CPU has 32 VFP registers */
diff --git a/target/arm/kvm.c b/target/arm/kvm.c
index df86ad387c..a712c5a1d1 100644
--- a/target/arm/kvm.c
+++ b/target/arm/kvm.c
@@ -37,6 +37,7 @@
 #include "gdbstub/enums.h"
 #include "hw/core/boards.h"
 #include "hw/core/irq.h"
+#include "hw/core/qdev-properties.h"
 #include "qapi/visitor.h"
 #include "qemu/log.h"
 #include "hw/acpi/acpi.h"
@@ -608,6 +609,9 @@ static void kvm_set_psci_version(Object *obj, const char *value, Error **errp)
     cpu->psci_version = PSCI_VERSION(maj, min);
 }
 
+static const Property arm_cpu_kvm_pmu_partition_property =
+    DEFINE_PROP_BOOL("kvm-pmu-partition", ARMCPU, kvm_pmu_partition, false);
+
 /* KVM VCPU properties should be prefixed with "kvm-". */
 void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
 {
@@ -624,6 +628,14 @@ void kvm_arm_add_vcpu_properties(ARMCPU *cpu)
                                         "will be counted.");
     }
 
+    if (arm_feature(env, ARM_FEATURE_PMU)) {
+        qdev_property_add_static(DEVICE(obj),
+                                 &arm_cpu_kvm_pmu_partition_property);
+        object_property_set_description(obj, "kvm-pmu-partition",
+                                        "Set on to enable KVM PMU counter "
+                                        "partitioning.");
+    }
+
     cpu->kvm_steal_time = ON_OFF_AUTO_AUTO;
     object_property_add_bool(obj, "kvm-steal-time", kvm_steal_time_get,
                              kvm_steal_time_set);
@@ -1913,6 +1925,10 @@ static bool kvm_arm_set_device_attr(ARMCPU *cpu, struct kvm_device_attr *attr,
     return true;
 }
 
+#ifndef KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION
+#define KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION 5
+#endif
+
 void kvm_arm_pmu_init(ARMCPU *cpu)
 {
     struct kvm_device_attr attr = {
@@ -1923,6 +1939,34 @@ void kvm_arm_pmu_init(ARMCPU *cpu)
     if (!cpu->has_pmu) {
         return;
     }
+
+    if (cpu->kvm_pmu_partition) {
+        uint32_t partition = 1;
+        struct kvm_device_attr part_attr = {
+            .group = KVM_ARM_VCPU_PMU_V3_CTRL,
+            .attr = KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION,
+            .addr = (intptr_t)&partition,
+        };
+
+        if (!kvm_arm_set_device_attr(cpu, &part_attr, "PMU partition")) {
+            error_report("failed to enable KVM PMU partition");
+            abort();
+        }
+    }
+
+    if (cpu->pmu_num_counters != UINT32_MAX) {
+        struct kvm_device_attr cnt_attr = {
+            .group = KVM_ARM_VCPU_PMU_V3_CTRL,
+            .attr = KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS,
+            .addr = (intptr_t)&cpu->pmu_num_counters,
+        };
+
+        if (!kvm_arm_set_device_attr(cpu, &cnt_attr, "PMU nr_counters")) {
+            error_report("failed to set KVM PMU nr_counters");
+            abort();
+        }
+    }
+
     if (!kvm_arm_set_device_attr(cpu, &attr, "PMU")) {
         error_report("failed to init PMU");
         abort();

base-commit: 08c9bbb825148dec9669f5184ecf18823bb6d631
-- 
2.56.1.708.g77570a6a1d-goog

