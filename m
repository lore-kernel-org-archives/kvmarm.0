Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1F724BBF9
	for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 18:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739469925; cv=none; b=odjKUNCJqUlWn3UHc8aKqiZMNFHfwwoJA1aMrsMSBbZipm1ixxCz6gW67iPX47WFAWPEkDMJsXO+cLE03XBakKLGVFzXgWqiUsyFzTOaV61aXX/528MeS3h73jk+Fqt+6H89QGgADCPb6SjezcXCNW0KgTiN8P6boRK98kS3g/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739469925; c=relaxed/simple;
	bh=fZjI6jyXbj5J+H1dhYbBv4gfTLdsOoEZWMhRkLloJXs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=FxAGNrkhm+Mhu8kji4ud32LdDcSVcUOI0p9a4NgLLYXsVeGUvA7xCUOQTRtgMZBCUMoqIeYgDq5o/Ryy7DMZswvorPBee9vmtJhEZ72Tez9m8jC/I7Z/M7Q0Gx+YSG7r9vBKQqBVQ2F/pLcErq2k6ETOUwMowokNMLcdE6MKzSc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=AED9x9q3; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="AED9x9q3"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3d14a3f810fso7662855ab.3
        for <kvmarm@lists.linux.dev>; Thu, 13 Feb 2025 10:05:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1739469920; x=1740074720; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dq7JupJfqupn6bj3Nl6z9Mq+cMEnqj9ECjf86JM2UFM=;
        b=AED9x9q3+1hmDQiXyFqDlq7sp2EtkZPTfpSq0ceEbtXX29dKluYAuU4I8bWCW+i+Xn
         G06WBgdL7pC/TJtIBUqU6PBXCUkzemcdtfQI2MFMc9PVVuR4nVxfavgVXTh91SmqLR10
         lNrI2Ygh1m6XfcpqTULZyhDrlmnIy6YXMHv4iw2/xomrEiM/g/p16P5J9NvmA4AgeD6z
         dCX/bywmvodbFgu0UZKfptWaPhTU3Yb1wUqXdVtB/3aUrxq3v1Shmrm5zdSCIgamIOzm
         OoSxfQH1BBiTuR6gFCAuaqbfMzuO8oc0vEL1ylRyoRf6xxKz1KDmjHAt/UIEZfmiqdDK
         /C4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739469920; x=1740074720;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dq7JupJfqupn6bj3Nl6z9Mq+cMEnqj9ECjf86JM2UFM=;
        b=rjb85qBPZzoUEuiU6Gn9CDiS4mf5ivy2Ygz4U2t6FsGtfTHqZA59BWOOpi095QpDnb
         EhW0XEggbuUTpjTe19APJOBDMIWcIz0i6nZYt5n+51wgiwvoC5p4cCLmm40b3fgIrVr2
         StxplRqcX67jkpPuWXTJbK+SbPmnqJ5rzFVlLgMOeFJ49WeOY7WLqzoEgX0peUJOR62O
         37c2W8PPYuYvrwwjCwktEcFsF9kQN8UyeDft3LcUkOrPEMjRjz4rcl8zs1+mDW3/Ng4R
         GfSD7CUNi5/0MkltApw0Ru9UD7BWF+fzHbS+mAewXeuzBR8c8VszhkqM7vWSq8eEFWNa
         +o8w==
X-Forwarded-Encrypted: i=1; AJvYcCWATVBzhM0qyanhpSx6nh+/VgIJG/jcVjz82vsFcMDJ9inMbqX/k7jYJ64CuqRoBk9nqmZC9ec=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2rnUpDRgIp/+8zPG+bgenYi3uCDT50GlpWVsu+WWEbDy3UDUT
	pBm/SyaP1FNfsc2u+WGsZDpd7BvtR/MnSoRUPxYJKgDjuaDRHWFVg0FC2Jznkupi/xJrAn/9h3K
	kI1MHkxmvn6QDMYGYkB/YmA==
X-Google-Smtp-Source: AGHT+IG9yUY19PrB7CUAP1YCyZmOUqmjAlpEtfXNoKRyP2K6BA/Dl/Zm7nJWWsMJ2WVwqa/OpSnedg/QppfMvmglxw==
X-Received: from ilbdz17.prod.google.com ([2002:a05:6e02:4411:b0:3d0:ebcd:cf64])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:3989:b0:3d0:618c:1b29 with SMTP id e9e14a558f8ab-3d18c2167e2mr43303965ab.5.1739469920127;
 Thu, 13 Feb 2025 10:05:20 -0800 (PST)
Date: Thu, 13 Feb 2025 18:03:14 +0000
In-Reply-To: <20250213180317.3205285-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250213180317.3205285-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.48.1.601.g30ceb7b040-goog
Message-ID: <20250213180317.3205285-6-coltonlewis@google.com>
Subject: [RFC PATCH v3 5/8] KVM: arm64: Introduce module param to partition
 the PMU
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

For PMUv3, the register MDCR_EL2.HPMN partitiones the PMU counters
into two ranges where counters 0..HPMN-1 are accessible by EL1 and, if
allowed, EL0 while counters HPMN..N are only accessible by EL2.

Introduce a module parameter in KVM to set this register. The name
reserved_host_counters reflects the intent to reserve some counters
for the host so the guest may eventually be allowed direct access to a
subset of PMU functionality for increased performance.

Track HPMN and whether the pmu is partitioned in struct arm_pmu
because both KVM and the PMUv3 driver will need to know that to handle
guests correctly.

Due to the difficulty this feature would create for the driver running
at EL1 on the host, partitioning is only allowed in VHE mode. Working
on nVHE mode would require a hypercall for every register access
because the counters reserved for the host by HPMN are now only
accessible to EL2.

The parameter is only configurable at boot time. Making the parameter
configurable on a running system is dangerous due to the difficulty of
knowing for sure no counters are in use anywhere so it is safe to
reporgram HPMN.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_pmu.h |  4 +++
 arch/arm64/kvm/Makefile          |  2 +-
 arch/arm64/kvm/debug.c           |  9 ++++--
 arch/arm64/kvm/pmu-part.c        | 47 ++++++++++++++++++++++++++++++++
 arch/arm64/kvm/pmu.c             |  2 ++
 include/linux/perf/arm_pmu.h     |  2 ++
 6 files changed, 62 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm64/kvm/pmu-part.c

diff --git a/arch/arm64/include/asm/kvm_pmu.h b/arch/arm64/include/asm/kvm_pmu.h
index 613cddbdbdd8..174b7f376d95 100644
--- a/arch/arm64/include/asm/kvm_pmu.h
+++ b/arch/arm64/include/asm/kvm_pmu.h
@@ -22,6 +22,10 @@ bool kvm_set_pmuserenr(u64 val);
 void kvm_vcpu_pmu_resync_el0(void);
 void kvm_host_pmu_init(struct arm_pmu *pmu);
 
+u8 kvm_pmu_get_reserved_counters(void);
+u8 kvm_pmu_hpmn(u8 nr_counters);
+void kvm_pmu_partition(struct arm_pmu *pmu);
+
 #else
 
 static inline void kvm_set_pmu_events(u64 set, struct perf_event_attr *attr) {}
diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
index 3cf7adb2b503..065a6b804c84 100644
--- a/arch/arm64/kvm/Makefile
+++ b/arch/arm64/kvm/Makefile
@@ -25,7 +25,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
 	 vgic/vgic-mmio-v3.o vgic/vgic-kvm-device.o \
 	 vgic/vgic-its.o vgic/vgic-debug.o
 
-kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu.o
+kvm-$(CONFIG_HW_PERF_EVENTS)  += pmu-emul.o pmu-part.o pmu.o
 kvm-$(CONFIG_ARM64_PTR_AUTH)  += pauth.o
 kvm-$(CONFIG_PTDUMP_STAGE2_DEBUGFS) += ptdump.o
 
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index 7fb1d9e7180f..b5ac5a213877 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -31,15 +31,18 @@
  */
 static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 {
+	u8 counters = *host_data_ptr(nr_event_counters);
+	u8 hpmn = kvm_pmu_hpmn(counters);
+
 	preempt_disable();
 
 	/*
 	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
 	 * to disable guest access to the profiling and trace buffers
 	 */
-	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN,
-					 *host_data_ptr(nr_event_counters));
-	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
+	vcpu->arch.mdcr_el2 = FIELD_PREP(MDCR_EL2_HPMN, hpmn);
+	vcpu->arch.mdcr_el2 |= (MDCR_EL2_HPMD |
+				MDCR_EL2_TPM |
 				MDCR_EL2_TPMS |
 				MDCR_EL2_TTRF |
 				MDCR_EL2_TPMCR |
diff --git a/arch/arm64/kvm/pmu-part.c b/arch/arm64/kvm/pmu-part.c
new file mode 100644
index 000000000000..e74fecc67e37
--- /dev/null
+++ b/arch/arm64/kvm/pmu-part.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (C) 2025 Google LLC
+ * Author: Colton Lewis <coltonlewis@google.com>
+ */
+
+#include <linux/kvm_host.h>
+#include <linux/perf/arm_pmu.h>
+
+#include <asm/kvm_pmu.h>
+
+static u8 reserved_host_counters __read_mostly;
+
+module_param(reserved_host_counters, byte, 0);
+MODULE_PARM_DESC(reserved_host_counters,
+		 "Partition the PMU into host and guest counters");
+
+u8 kvm_pmu_get_reserved_counters(void)
+{
+	return reserved_host_counters;
+}
+
+u8 kvm_pmu_hpmn(u8 nr_counters)
+{
+	if (reserved_host_counters >= nr_counters) {
+		if (this_cpu_has_cap(ARM64_HAS_HPMN0))
+			return 0;
+
+		return 1;
+	}
+
+	return nr_counters - reserved_host_counters;
+}
+
+void kvm_pmu_partition(struct arm_pmu *pmu)
+{
+	u8 nr_counters = *host_data_ptr(nr_event_counters);
+	u8 hpmn = kvm_pmu_hpmn(nr_counters);
+
+	if (hpmn < nr_counters) {
+		pmu->hpmn = hpmn;
+		pmu->partitioned = true;
+	} else {
+		pmu->hpmn = nr_counters;
+		pmu->partitioned = false;
+	}
+}
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 85b5cb432c4f..7169c1a24dd6 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -243,6 +243,8 @@ void kvm_host_pmu_init(struct arm_pmu *pmu)
 	entry->arm_pmu = pmu;
 	list_add_tail(&entry->entry, &arm_pmus);
 
+	kvm_pmu_partition(pmu);
+
 	if (list_is_singular(&arm_pmus))
 		static_branch_enable(&kvm_arm_pmu_available);
 
diff --git a/include/linux/perf/arm_pmu.h b/include/linux/perf/arm_pmu.h
index 35c3a85bee43..ee4fc2e26bff 100644
--- a/include/linux/perf/arm_pmu.h
+++ b/include/linux/perf/arm_pmu.h
@@ -125,6 +125,8 @@ struct arm_pmu {
 
 	/* Only to be used by ACPI probing code */
 	unsigned long acpi_cpuid;
+	u8		hpmn; /* MDCR_EL2.HPMN: counter partition pivot */
+	bool		partitioned;
 };
 
 #define to_arm_pmu(p) (container_of(p, struct arm_pmu, pmu))
-- 
2.48.1.601.g30ceb7b040-goog

