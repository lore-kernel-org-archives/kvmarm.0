Received: from mail-oi1-f201.google.com (mail-oi1-f201.google.com [209.85.167.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB1A3D1ABC
	for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 19:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781292574; cv=none; b=qu/DmoWGGf8bEpdJL4Fd7t0Ksdo86IvSTvFpU9UCC/cduyd2ZYxOFWfdQ1l4cOwFqAEavtQY1j36k+QLssFfsEjX1xDQYYVWrUBIUEDY9sz1qzU5P2gPLdU5KB2oguhEHyj+PJLvys7iGTD+Oh68qAkKuijPQDpyld2PH2RpO3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781292574; c=relaxed/simple;
	bh=Z169fBUkCIg9BiMlDMCUBmqUN7mLkV31cpse2h+VzWs=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=oJ6Edv/i8dxchopx36WATECtqvc/1FMjyfhou2AaiJJ/Pi3JHuPGqsuIq4NDv+LYcdq0wH2HtUsJJa47KXN4OWoVfgjiEqvUJX6bXoq1a61neScP/YCW7HnWz9lesbepfqs7cjZXDzBd7RQHDcYlUzvYV871YGnDgbmnaruTzcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mx1gxjya; arc=none smtp.client-ip=209.85.167.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mx1gxjya"
Received: by mail-oi1-f201.google.com with SMTP id 5614622812f47-4863a55600aso1245730b6e.1
        for <kvmarm@lists.linux.dev>; Fri, 12 Jun 2026 12:29:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781292567; x=1781897367; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=xMUfkA0Qvrb7iW5rl1K95T0ct8KyLE0h2lxpS+ugXRA=;
        b=mx1gxjya7XCcYrvRdrcV16qWpXb0b6Pw2CMyoe2DVp39ZFNftc7y5vJ2vhDXiKc20t
         TN77zsbwy8k0LU7DxH1nu+8GmjoZLaRHldXQO0d2P6Ga/C+UoOBReOBTG4Y1KXjwj8hi
         k/fl8deSra+91NuNv30gAoDXdo8dckosDbsJs1i4kTKvwEeME0wj9zKDcEpi8BOeLaOJ
         NfhQVK/MrNJFwdJOaIhxphPzwYwZazsJ+YjwzaAiaaKppNT7MqZCzIsIJwrblPKxCSKu
         JVLWGl3aBOrkvLr10AhNTytdpvMtLaFRwbpL4YvPEN5GO4tncu+co/KDg7Um0E4xJgpl
         5c/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781292567; x=1781897367;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xMUfkA0Qvrb7iW5rl1K95T0ct8KyLE0h2lxpS+ugXRA=;
        b=QHc8KT7bTzQHn0d/Yw6V8IcikgjG6tGghC1wJwW2qBwEGvo9L4jq3JoKBoP/2Vdic1
         E/5nZr2bKurLBqGRhNaJoUXlKEeP/a3s0CCXlCoY/WrwDhdgEwsPtvM+XG9qFEwwTZGo
         AvlPaBqdpAzyY9qTpaCB2uFvVlZYnOrIE7HC+cb6Py8waZHoyhzjTbhAu4yGQuGYjcAG
         JuUMnAzQjUcaJ9ffHwiNMz3vEpBrbcZEG9bW3cDiLC+JbbwqcSjiNuB6l/ewEcqg2NQG
         2dJ3KftUZGCIRQwnzD/4OJPNUQr5781XA3lngYOpzd2B4On0p+GjZAfrjStowCWrHvhn
         epTw==
X-Forwarded-Encrypted: i=1; AFNElJ+E9NDaO1UpiQ0/xU4DIUtWxEmrZ+M56/ab8cj7xMkvq00BMYB7mXKYqwTPn4ANcoEY5X8LJMg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwRa2oyH6OP8qjFu8kwadSRuulU+cMud2J39HKwD8WdaNmgo5go
	sNjp6HLx2vQ29HEkoTWCfkFwubpSTkCGWfT8DgBW7JZiX8xnMoEqmcZI/dFht3VDkaniwHRUNny
	5tjYPF4CNJ3t/3GLmWgLaSb/COA==
X-Received: from ilbdx1-n1.prod.google.com ([2002:a05:6e02:4201:10b0:4fa:1e84:4047])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:170f:b0:485:15bd:60e8 with SMTP id 5614622812f47-48741b51368mr655188b6e.35.1781292567145;
 Fri, 12 Jun 2026 12:29:27 -0700 (PDT)
Date: Fri, 12 Jun 2026 19:29:06 +0000
In-Reply-To: <20260612192909.1153907-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260612192909.1153907-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.54.0.1136.gdb2ca164c4-goog
Message-ID: <20260612192909.1153907-19-coltonlewis@google.com>
Subject: [PATCH 18/21] KVM: arm64: Add vCPU device attr to partition the PMU
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	James Clark <james.clark@linaro.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a new PMU device attr to enable the partitioned PMU for a given
VM. This capability can be set when the PMU is initially configured
before the vCPU starts running and is allowed where PMUv3 and VHE are
supported and the host driver was configured with
arm_pmuv3.reserved_host_counters.

The enabled capability is tracked by the new flag
KVM_ARCH_FLAG_PARTITION_PMU_ENABLED.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/uapi/asm/kvm.h |  2 ++
 arch/arm64/kvm/pmu-direct.c       | 30 ++++++++++++++++++++++++++++++
 arch/arm64/kvm/pmu.c              | 23 +++++++++++++++++++++++
 include/kvm/arm_pmu.h             |  9 +++++++++
 4 files changed, 64 insertions(+)

diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 1c13bfa2d38aa..7f57b8c132925 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -437,6 +437,8 @@ enum {
 #define   KVM_ARM_VCPU_PMU_V3_FILTER		2
 #define   KVM_ARM_VCPU_PMU_V3_SET_PMU		3
 #define   KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS	4
+#define   KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION	5
+
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 0062d1d8e1999..2d2294b78ebe0 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -24,6 +24,36 @@ bool has_host_pmu_partition_support(void)
 		system_supports_pmuv3();
 }
 
+
+/**
+ * has_kvm_pmu_partition_support() - If we can enable/disable partition
+ *
+ * Return: true if allowed, false otherwise.
+ */
+bool has_kvm_pmu_partition_support(void)
+{
+	return has_host_pmu_partition_support() &&
+		kvm_supports_guest_pmuv3() &&
+		armv8pmu_is_partitioned;
+}
+
+/**
+ * kvm_pmu_partition_enable() - Enable/disable partition flag
+ * @kvm: Pointer to vcpu
+ * @enable: Whether to enable or disable
+ *
+ * If we want to enable the partition, the guest is free to grab
+ * hardware by accessing PMU registers. Otherwise, the host maintains
+ * control.
+ */
+void kvm_pmu_partition_enable(struct kvm *kvm, bool enable)
+{
+	if (enable)
+		set_bit(KVM_ARCH_FLAG_PARTITION_PMU_ENABLED, &kvm->arch.flags);
+	else
+		clear_bit(KVM_ARCH_FLAG_PARTITION_PMU_ENABLED, &kvm->arch.flags);
+}
+
 /**
  * pmu_is_partitioned() - Determine if given PMU is partitioned
  * @pmu: Pointer to arm_pmu struct
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index f5ee18b4dfae7..4e15948ac2565 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -769,6 +769,28 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 		return kvm_arm_pmu_v3_set_nr_counters(vcpu, n);
 	}
+	case KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION: {
+		unsigned int __user *uaddr = (unsigned int __user *)(long)attr->addr;
+		u32 val;
+
+		if (get_user(val, uaddr))
+			return -EFAULT;
+
+		if (!has_kvm_pmu_partition_support())
+			return -EPERM;
+
+		if (kvm_vm_has_ran_once(kvm))
+			return -EBUSY;
+
+		kvm_pmu_partition_enable(kvm, val);
+		if (val) {
+			unsigned int max_counters = kvm_arm_pmu_get_max_counters(kvm);
+
+			if (kvm->arch.nr_pmu_counters > max_counters)
+				kvm_arm_set_nr_counters(kvm, max_counters);
+		}
+		return 0;
+	}
 	case KVM_ARM_VCPU_PMU_V3_INIT:
 		return kvm_arm_pmu_v3_init(vcpu);
 	}
@@ -808,6 +830,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	case KVM_ARM_VCPU_PMU_V3_FILTER:
 	case KVM_ARM_VCPU_PMU_V3_SET_PMU:
 	case KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS:
+	case KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION:
 		if (kvm_vcpu_has_pmu(vcpu))
 			return 0;
 	}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index f72d080ee7ba2..6a5572994b7fa 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -99,6 +99,8 @@ bool kvm_pmu_part_overflow_status(struct kvm_vcpu *vcpu);
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))
 
+bool has_kvm_pmu_partition_support(void);
+void kvm_pmu_partition_enable(struct kvm *kvm, bool enable);
 bool pmu_is_partitioned(struct arm_pmu *pmu);
 bool kvm_pmu_is_partitioned(struct kvm *kvm);
 void kvm_pmu_direct_pmcr_write(struct kvm_vcpu *vcpu, u64 val);
@@ -279,6 +281,13 @@ static inline u64 kvm_pmu_guest_counter_mask(void *kvm)
 
 static inline void kvm_pmu_handle_guest_irq(struct arm_pmu *pmu, u64 pmovsr) {}
 
+static inline bool has_kvm_pmu_partition_support(void)
+{
+	return false;
+}
+
+static inline void kvm_pmu_partition_enable(struct kvm *kvm, bool enable) {}
+
 #endif
 
 #endif
-- 
2.54.0.1136.gdb2ca164c4-goog

