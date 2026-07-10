Received: from pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.42.203.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94760383999
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 06:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.42.203.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783665939; cv=none; b=TSTVtcfz+KulajSBO6QsVwukiscgtFeElGSdDclKJc+uCgQ8SgmANmupMETafY3fn6cxnBUcX23GB65Vc+5zM0fScNBPhzfqvk2Oqer/PZPBUSi6wODZpRTjkGKn5MKA0kE9f6lHh6RTuB1GRgjEPftIuFhUBbiWsFHJgfj3WPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783665939; c=relaxed/simple;
	bh=e5Bl/DtahM5m3oGNg6W1qTFY42KyEVFijhMuSsyeH9Y=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WdB90DPnsZmUGDMMHsw5lNr7gEN+d76Dt9kOwjlXsXv4cmQLpfNlhry23bXMrhLPY5/r86nLGXP9FzvA6AInHze5l8P3KVcsmAXvUagt+fN4eSVRlBucsdfe42ZTehvWvYqaH3TCm9K9SZaJb/YkR4SSVkHr7dCBZTqxH7B359g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=amKzr4xG; arc=none smtp.client-ip=52.42.203.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="amKzr4xG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1783665937; x=1815201937;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TM+nxZld2Hns5mSjiSG+hFIbK+AXxcbV4j0W5iXh5EA=;
  b=amKzr4xGc/E9epvl2BkMyH6niTIkDvZj8n3240xltuK3DYrl7eLj0+lo
   uLpnWn2nG6B4XxwlWtY5O5OXx1DJ4c/lj6TBpbtgYdG+m0arfO7pWi9Q8
   DzD4RD1UTmhIZTgPyjM8xUXCd+Bouc/FiSuT3m5I5o5g9u9zBmniVVcne
   4dIp8MsXGEw0U5+AdhKdHp8qcZa0p4gkYh1YkUvj7pIeaC65U5s6FUfm9
   HsempWxXk6IcFHIEfFoQQ4rIAvk7dM+o5+auIFRUmA4pjSJp6k5chR0E4
   Qx3JBOO2sLG1XIzLjNUrhnzM8BAgSr08T6FpPbrdP4bJrzFPz5V7vOcYC
   A==;
X-CSE-ConnectionGUID: WTV9SxdtQxWNd7Mz5WIYrw==
X-CSE-MsgGUID: guInl4CxQD+7l2f3tVBPQQ==
X-IronPort-AV: E=Sophos;i="6.25,154,1779148800"; 
   d="scan'208";a="23439201"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-008.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jul 2026 06:45:37 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:1470]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.47.135:2525] with esmtp (Farcaster)
 id d8dcac52-0378-4be4-aa72-d99b8a0a3801; Fri, 10 Jul 2026 06:45:36 +0000 (UTC)
X-Farcaster-Flow-ID: d8dcac52-0378-4be4-aa72-d99b8a0a3801
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Fri, 10 Jul 2026 06:45:36 +0000
Received: from dev-dsk-congkai-2a-df9e8fab.us-west-2.amazon.com
 (172.23.251.204) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Fri, 10 Jul 2026
 06:45:36 +0000
From: Congkai Tan <congkai@amazon.com>
To: <oupton@kernel.org>
CC: <blakgeof@amazon.com>, <catalin.marinas@arm.com>, <congkai@amazon.com>,
	<corbet@lwn.net>, <harisokn@amazon.com>, <joey.gouly@arm.com>,
	<kvm@vger.kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<maz@kernel.org>, <pbonzini@redhat.com>, <stanspas@amazon.de>,
	<suzuki.poulose@arm.com>, <will@kernel.org>, <yuzenghui@huawei.com>
Subject: Re: [PATCH v2 0/3] KVM: arm64: Expose PMMIR_EL1.SLOTS to guests
Date: Fri, 10 Jul 2026 06:44:23 +0000
Message-ID: <20260710064423.2667799-1-congkai@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <ak19mPPWcupFwfuE@kernel.org>
References: <ak19mPPWcupFwfuE@kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D038UWC004.ant.amazon.com (10.13.139.229) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Tue, Jul 07, 2026 at 03:28:40PM -0700, Oliver Upton wrote:
> I've addressed all of this locally and pushed to my tree [*]. Untested,
> as always :) Would you be able to give it a spin?

Thank you so much for the review and code suggestions! I integrated
them and created v3 (with one extra change of wiring
KVM_CAP_ARM_PMU_V3_STRICT into kvm_vm_ioctl_check_extension() so
userspace can detect it). I tested the patches with kernel 7.2 and
patched QEMU 9.2.3, and the behaviors were as expected.

I'll send out the v3 patches shortly.

> Also, do you have VMM patches for using the new feature flag?

Below is the patch against QEMU 9.2.3 that I used for testing. The tests
were performed using different combinations of the four flags (host
PMMIR_EL1.SLOTS = 0xa):

- pmu-strict=on,pmu-set=on,pmmir-force=off,pmcr-n-force=off:
    new happy path where guest read the correct SLOTS (0xa).

- pmu-strict=off,pmu-set=off,pmmir-force=off,pmcr-n-force=off:
    old happy path where guest read SLOTS as 0x0.

- pmu-strict=off,pmu-set=on,pmmir-force=off,pmcr-n-force=off:
    non-strict with a PMU set, guest read SLOTS as 0x0 (SLOTS stays
    gated on the flag).

- pmu-strict=on,pmu-set=off,pmmir-force=off,pmcr-n-force=off:
    strict with no PMU, so KVM_ARM_VCPU_PMU_V3_INIT failed with -ENXIO
    and the guest did not boot.

- pmu-strict=on,pmu-set=on,pmmir-force=0,pmcr-n-force=off:
    strict with PMMIR forced to 0 (backward compatibility), where the
    KVM_SET_ONE_REG succeeded and guest read SLOTS as 0x0.

- pmu-strict=on,pmu-set=on,pmmir-force=7,pmcr-n-force=off:
    strict with PMMIR forced to a mismatching value, so KVM_SET_ONE_REG
    rejected with -EINVAL and guest still read SLOTS as 0xa.

- pmu-strict=off,pmu-set=on,pmmir-force=0,pmcr-n-force=off:
    non-strict with PMMIR forced to 0, KVM_SET_ONE_REG returned no error
    and guest read SLOTS as 0x0.

- pmu-strict=off,pmu-set=off,pmmir-force=10,pmcr-n-force=off:
    non-strict with PMMIR forced to a non-zero value, KVM_SET_ONE_REG
    rejected with -EINVAL and guest read SLOTS as 0x0.

- pmu-strict=off,pmu-set=off,pmmir-force=off,pmcr-n-force=3:
    non-strict with a PMCR_EL0.N write (original behavior), so the write
    was honored and N read back as 3.

- pmu-strict=on,pmu-set=on,pmmir-force=off,pmcr-n-force=3:
    strict with a PMCR_EL0.N write, so the write was ignored and N read
    back 6 (the PMU maximum).

---
Local test patch for the kernel "strict PMUv3 UAPI / PMMIR_EL1.SLOTS"
series.

Adds four 'virt' machine properties (all default off):

  pmu-strict=on   request KVM_ARM_VCPU_PMU_V3_STRICT at VCPU_INIT
  pmu-set=off     skip KVM_ARM_VCPU_PMU_V3_SET_PMU (exercise the no-PMU path)
  pmmir-force=N   write PMMIR_EL1=N via KVM_SET_ONE_REG (0 = set_pmmir reset)
  pmcr-n-force=N  write then read PMCR_EL0.N; strict ignores the write

SET_PMU is issued before PMU_V3_INIT (the kernel rejects it afterwards) and
is followed by a cpreg-cache refresh so the stale PMMIR_EL1=0 cached at init
is not written back.

Signed-off-by: Congkai Tan <congkai@amazon.com>
---
--- a/target/arm/kvm.c	2025-03-26 19:37:01.000000000 +0000
+++ b/target/arm/kvm.c	2026-07-10 04:05:16.082093995 +0000
@@ -18,11 +18,16 @@
 #include "qemu/timer.h"
 #include "qemu/error-report.h"
 #include "qemu/main-loop.h"
+#include "qemu/cutils.h"
 #include "qom/object.h"
 #include "qapi/error.h"
 #include "sysemu/sysemu.h"
 #include "sysemu/runstate.h"
 #include "sysemu/kvm.h"
+
+#ifndef KVM_ARM_VCPU_PMU_V3_STRICT
+#define KVM_ARM_VCPU_PMU_V3_STRICT 9
+#endif
 #include "sysemu/kvm_int.h"
 #include "kvm_arm.h"
 #include "cpu.h"
@@ -1728,6 +1733,82 @@
     }
 }
 
+/* Test knob: 'pmu-strict' machine property (request KVM_ARM_VCPU_PMU_V3_STRICT). */
+bool kvm_arm_pmu_strict_enabled(void)
+{
+    Object *m = qdev_get_machine();
+
+    if (m && object_property_find(m, "pmu-strict")) {
+        return object_property_get_bool(m, "pmu-strict", NULL);
+    }
+    return false;
+}
+
+/* Test knob: 'pmu-set' machine property (issue SET_PMU; off = no-PMU path). */
+static bool kvm_arm_pmu_set_enabled(void)
+{
+    Object *m = qdev_get_machine();
+
+    if (m && object_property_find(m, "pmu-set")) {
+        return object_property_get_bool(m, "pmu-set", NULL);
+    }
+    return false;
+}
+
+/* Read the host PMUv3 perf "type" id from sysfs; -1 on failure. */
+static int kvm_arm_pmu_read_host_pmu_type(void)
+{
+    const char *path = "/sys/bus/event_source/devices/armv8_pmuv3_0/type";
+    g_autofree char *contents = NULL;
+    const char *ep;
+    gsize len;
+    int type;
+
+    if (!g_file_get_contents(path, &contents, &len, NULL)) {
+        return -1;
+    }
+    if (qemu_strtoi(contents, &ep, 10, &type) < 0 || (*ep && *ep != '\n')) {
+        return -1;
+    }
+    return type;
+}
+
+/*
+ * Select the host PMU (SET_PMU). Under the strict UAPI this is mandatory and
+ * makes the kernel snapshot PMMIR_EL1.SLOTS. Call after INIT, before PMU_V3_INIT.
+ */
+void kvm_arm_pmu_set_pmu(ARMCPU *cpu)
+{
+    int pmu_type;
+    struct kvm_device_attr attr = {
+        .group = KVM_ARM_VCPU_PMU_V3_CTRL,
+        .attr = KVM_ARM_VCPU_PMU_V3_SET_PMU,
+    };
+
+    if (!cpu->has_pmu || !kvm_arm_pmu_set_enabled()) {
+        return;
+    }
+
+    pmu_type = kvm_arm_pmu_read_host_pmu_type();
+    if (pmu_type < 0) {
+        warn_report("PMU: could not read host PMU type; "
+                    "PMMIR_EL1.SLOTS will read 0 in the guest");
+        return;
+    }
+    attr.addr = (intptr_t)&pmu_type;
+
+    if (!kvm_arm_set_device_attr(cpu, &attr, "PMU SET_PMU")) {
+        warn_report("PMU: KVM_ARM_VCPU_PMU_V3_SET_PMU unsupported or failed; "
+                    "PMMIR_EL1.SLOTS will read 0 in the guest");
+        return;
+    }
+
+    /* Refresh the cpreg cache so the stale PMMIR_EL1=0 isn't written back. */
+    if (!write_kvmstate_to_list(cpu)) {
+        warn_report("PMU: failed to refresh cpreg cache after SET_PMU");
+    }
+}
+
 void kvm_arm_pmu_set_irq(ARMCPU *cpu, int irq)
 {
     struct kvm_device_attr attr = {
@@ -1904,6 +1985,10 @@
     }
     if (cpu->has_pmu) {
         cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PMU_V3;
+        /* Test knob: opt in to the strict PMUv3 UAPI. */
+        if (kvm_arm_pmu_strict_enabled()) {
+            cpu->kvm_init_features[0] |= 1 << KVM_ARM_VCPU_PMU_V3_STRICT;
+        }
     }
     if (cpu_isar_feature(aa64_sve, cpu)) {
         assert(kvm_arm_sve_supported());
--- a/target/arm/kvm_arm.h	2025-03-26 19:37:01.000000000 +0000
+++ b/target/arm/kvm_arm.h	2026-07-10 04:05:25.331964805 +0000
@@ -207,6 +207,10 @@
 
 void kvm_arm_pmu_init(ARMCPU *cpu);
 void kvm_arm_pmu_set_irq(ARMCPU *cpu, int irq);
+/* Test knob: select the host PMU (SET_PMU). Call after INIT, before PMU_V3_INIT. */
+void kvm_arm_pmu_set_pmu(ARMCPU *cpu);
+/* Test knob: true if the 'pmu-strict' machine property is set. */
+bool kvm_arm_pmu_strict_enabled(void);
 
 /**
  * kvm_arm_pvtime_init:
@@ -280,6 +284,16 @@
     g_assert_not_reached();
 }
 
+static inline void kvm_arm_pmu_set_pmu(ARMCPU *cpu)
+{
+    g_assert_not_reached();
+}
+
+static inline bool kvm_arm_pmu_strict_enabled(void)
+{
+    return false;
+}
+
 static inline void kvm_arm_pvtime_init(ARMCPU *cpu, uint64_t ipa)
 {
     g_assert_not_reached();
--- a/hw/arm/virt.c	2025-03-26 19:37:00.000000000 +0000
+++ b/hw/arm/virt.c	2026-07-10 04:05:51.051606007 +0000
@@ -53,6 +53,7 @@
 #include "hw/loader.h"
 #include "qapi/error.h"
 #include "qemu/bitops.h"
+#include "qemu/cutils.h"
 #include "qemu/error-report.h"
 #include "qemu/module.h"
 #include "hw/pci-host/gpex.h"
@@ -2070,7 +2071,64 @@
                 if (kvm_irqchip_in_kernel()) {
                     kvm_arm_pmu_set_irq(ARM_CPU(cpu), VIRTUAL_PMU_IRQ);
                 }
+                /* Test knob: SET_PMU before PMU_V3_INIT (see kvm_arm_pmu_set_pmu). */
+                kvm_arm_pmu_set_pmu(ARM_CPU(cpu));
                 kvm_arm_pmu_init(ARM_CPU(cpu));
+                /* Test knob: force PMMIR_EL1 (0 = set_pmmir() back-compat reset). */
+                if (vms->pmmir_force >= 0) {
+                    uint64_t v = vms->pmmir_force;
+                    int r = kvm_set_one_reg(cpu, ARM64_SYS_REG(3, 0, 9, 14, 6),
+                                            &v);
+                    if (r) {
+                        warn_report("pmmir-force: KVM_SET_ONE_REG(PMMIR_EL1) "
+                                    "returned %d", r);
+                    }
+                    /* Refresh the cpreg cache so the forced value sticks. */
+                    if (!write_kvmstate_to_list(ARM_CPU(cpu))) {
+                        warn_report("pmmir-force: failed to refresh cpreg "
+                                    "cache after KVM_SET_ONE_REG");
+                    }
+                }
+                /*
+                 * Test knob: SET then GET PMCR_EL0.N. strict=on -> write ignored
+                 * (N stays at max); strict=off -> read-back matches the write.
+                 */
+                if (vms->pmcr_n_force >= 0) {
+                    uint64_t pmcr = 0;
+                    int r = kvm_get_one_reg(cpu, ARM64_SYS_REG(3, 3, 9, 12, 0),
+                                            &pmcr);
+                    if (r) {
+                        warn_report("pmcr-n-force: KVM_GET_ONE_REG(PMCR_EL0) "
+                                    "returned %d", r);
+                    } else {
+                        uint64_t n = vms->pmcr_n_force;
+
+                        pmcr &= ~(uint64_t)PMCRN_MASK;
+                        pmcr |= (n << PMCRN_SHIFT) & PMCRN_MASK;
+                        r = kvm_set_one_reg(cpu,
+                                            ARM64_SYS_REG(3, 3, 9, 12, 0),
+                                            &pmcr);
+                        if (r) {
+                            warn_report("pmcr-n-force: KVM_SET_ONE_REG("
+                                        "PMCR_EL0) returned %d", r);
+                        }
+                        if (!kvm_get_one_reg(cpu,
+                                             ARM64_SYS_REG(3, 3, 9, 12, 0),
+                                             &pmcr)) {
+                            uint64_t got = (pmcr & PMCRN_MASK)
+                                           >> PMCRN_SHIFT;
+                            info_report("pmcr-n-force: wrote N=%" PRIu64
+                                        ", read back N=%" PRIu64 " (strict=%s)",
+                                        n, got,
+                                        vms->pmu_strict ? "on" : "off");
+                        }
+                        /* Keep QEMU's cpreg cache consistent with the kernel. */
+                        if (!write_kvmstate_to_list(ARM_CPU(cpu))) {
+                            warn_report("pmcr-n-force: failed to refresh cpreg "
+                                        "cache after KVM_SET_ONE_REG");
+                        }
+                    }
+                }
             }
             if (steal_time) {
                 kvm_arm_pvtime_init(ARM_CPU(cpu), pvtime_reg_base
@@ -2676,6 +2734,88 @@
     vms->mte = value;
 }
 
+static bool virt_get_pmu_strict(Object *obj, Error **errp)
+{
+    VirtMachineState *vms = VIRT_MACHINE(obj);
+
+    return vms->pmu_strict;
+}
+
+static void virt_set_pmu_strict(Object *obj, bool value, Error **errp)
+{
+    VirtMachineState *vms = VIRT_MACHINE(obj);
+
+    vms->pmu_strict = value;
+}
+
+static bool virt_get_pmu_set(Object *obj, Error **errp)
+{
+    VirtMachineState *vms = VIRT_MACHINE(obj);
+
+    return vms->pmu_set;
+}
+
+static void virt_set_pmu_set(Object *obj, bool value, Error **errp)
+{
+    VirtMachineState *vms = VIRT_MACHINE(obj);
+
+    vms->pmu_set = value;
+}
+
+static char *virt_get_pmmir_force(Object *obj, Error **errp)
+{
+    VirtMachineState *vms = VIRT_MACHINE(obj);
+
+    if (vms->pmmir_force < 0) {
+        return g_strdup("off");
+    }
+    return g_strdup_printf("%" PRId64, vms->pmmir_force);
+}
+
+static void virt_set_pmmir_force(Object *obj, const char *value, Error **errp)
+{
+    VirtMachineState *vms = VIRT_MACHINE(obj);
+    uint64_t v;
+
+    if (!strcmp(value, "off")) {
+        vms->pmmir_force = -1;
+        return;
+    }
+    if (qemu_strtou64(value, NULL, 0, &v) < 0) {
+        error_setg(errp, "Invalid pmmir-force value '%s' "
+                   "(expected 'off' or an integer)", value);
+        return;
+    }
+    vms->pmmir_force = (int64_t)v;
+}
+
+static char *virt_get_pmcr_n_force(Object *obj, Error **errp)
+{
+    VirtMachineState *vms = VIRT_MACHINE(obj);
+
+    if (vms->pmcr_n_force < 0) {
+        return g_strdup("off");
+    }
+    return g_strdup_printf("%" PRId64, vms->pmcr_n_force);
+}
+
+static void virt_set_pmcr_n_force(Object *obj, const char *value, Error **errp)
+{
+    VirtMachineState *vms = VIRT_MACHINE(obj);
+    uint64_t v;
+
+    if (!strcmp(value, "off")) {
+        vms->pmcr_n_force = -1;
+        return;
+    }
+    if (qemu_strtou64(value, NULL, 0, &v) < 0) {
+        error_setg(errp, "Invalid pmcr-n-force value '%s' "
+                   "(expected 'off' or an integer)", value);
+        return;
+    }
+    vms->pmcr_n_force = (int64_t)v;
+}
+
 static char *virt_get_gic_version(Object *obj, Error **errp)
 {
     VirtMachineState *vms = VIRT_MACHINE(obj);
@@ -3233,6 +3373,41 @@
                                           "to a KVM guest using ACPI and guest external abort exceptions");
 
     object_class_property_add_bool(oc, "mte", virt_get_mte, virt_set_mte);
+
+    object_class_property_add_bool(oc, "pmu-strict", virt_get_pmu_strict,
+                                   virt_set_pmu_strict);
+    object_class_property_set_description(oc, "pmu-strict",
+                                          "Test knob: request the strict "
+                                          "PMUv3 UAPI (KVM_ARM_VCPU_PMU_V3_"
+                                          "STRICT) for each vCPU");
+
+    object_class_property_add_bool(oc, "pmu-set", virt_get_pmu_set,
+                                   virt_set_pmu_set);
+    object_class_property_set_description(oc, "pmu-set",
+                                          "Test knob: issue "
+                                          "KVM_ARM_VCPU_PMU_V3_SET_PMU "
+                                          "(default on); off exercises the "
+                                          "strict no-PMU path");
+
+    object_class_property_add_str(oc, "pmmir-force", virt_get_pmmir_force,
+                                  virt_set_pmmir_force);
+    object_class_property_set_description(oc, "pmmir-force",
+                                          "Test knob: force PMMIR_EL1 to this "
+                                          "value via KVM_SET_ONE_REG after the "
+                                          "PMU is selected. 'off' (default) "
+                                          "leaves the kernel snapshot intact; "
+                                          "0 exercises the set_pmmir() "
+                                          "back-compat reset");
+
+    object_class_property_add_str(oc, "pmcr-n-force", virt_get_pmcr_n_force,
+                                  virt_set_pmcr_n_force);
+    object_class_property_set_description(oc, "pmcr-n-force",
+                                          "Test knob: write PMCR_EL0.N with "
+                                          "this value via KVM_SET_ONE_REG, then "
+                                          "read it back and log the result. "
+                                          "Under pmu-strict=on the kernel "
+                                          "ignores the write (N stays at max); "
+                                          "off (default) disables the knob");
     object_class_property_set_description(oc, "mte",
                                           "Set on/off to enable/disable emulating a "
                                           "guest CPU which implements the ARM "
@@ -3290,6 +3465,12 @@
     /* EL2 is also disabled by default, for similar reasons */
     vms->virt = false;
 
+    /* Test knobs default: select a PMU, no strict flag, no pmmir override */
+    vms->pmu_strict = false;
+    vms->pmu_set = true;
+    vms->pmmir_force = -1;
+    vms->pmcr_n_force = -1;
+
     /* High memory is enabled by default */
     vms->highmem = true;
     vms->highmem_compact = !vmc->no_highmem_compact;
--- a/include/hw/arm/virt.h	2025-03-26 19:37:00.000000000 +0000
+++ b/include/hw/arm/virt.h	2026-07-10 04:06:12.091312904 +0000
@@ -180,6 +180,11 @@
     char *oem_id;
     char *oem_table_id;
     bool ns_el2_virt_timer_irq;
+    /* Test knobs for the strict PMUv3 series (-1 / false = off). */
+    bool pmu_strict;      /* request KVM_ARM_VCPU_PMU_V3_STRICT */
+    bool pmu_set;         /* issue SET_PMU (default on) */
+    int64_t pmmir_force;  /* force PMMIR_EL1 via KVM_SET_ONE_REG */
+    int64_t pmcr_n_force; /* write+read PMCR_EL0.N via KVM_SET_ONE_REG */
 };
 
 #define VIRT_ECAM_ID(high) (high ? VIRT_HIGH_PCIE_ECAM : VIRT_PCIE_ECAM)
