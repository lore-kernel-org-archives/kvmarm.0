Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D179A32939A
	for <kvmarm@lists.linux.dev>; Mon,  9 Feb 2026 22:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770676871; cv=none; b=oDtP2k8DBTK9Apa+kWAKQGaW+zxTiZdnxVufwKTXN4EpgDqQ7G3MCIZKNKWYK5AB4c5d0A8VpK8H8zJrybIYh9k1uVwPpxStyWJ4e2PdO+JNKzd4r62ShuzJBJHPzBLSzQfO3OBLhsm/VaYz76J7JUyLt3/eR/Cmkmle1A1Tekc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770676871; c=relaxed/simple;
	bh=IGbjYf4aDEdJzYqyHxQ48Lwc7zrh6q6MUfA91xc3mH0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=uI7RnSryAe2TZSIEt2j7bAehfYa8IU/ZAprdodtkGYO1ZZpQU01dmxN40/BMy/2McOD1lZSEEYIss0L9f0FzAJTztAs8W4xqWwPPUjdixYRR2kX4rranQnubNuSkDCw8LgEFzPCrpApyNe4lS7HelhgxcHqDfXjBbYllf4Z39wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IJBIiyLU; arc=none smtp.client-ip=209.85.161.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IJBIiyLU"
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-6630c8af251so759029eaf.1
        for <kvmarm@lists.linux.dev>; Mon, 09 Feb 2026 14:41:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770676862; x=1771281662; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=I8vsvPCwrm4qK2tJSRhYymVMX8OUXdkNYkDGMZ9conM=;
        b=IJBIiyLUQyiZmhesK6F7d8ILDt8J7xYcMRZit3lGYpFZe5uITBc0eaUa1/8yQ3EpX8
         Ao2HcZQIlW8X/BFdN1m9/bwPbVI64rHleKf3z0TRU7BI7/+KedrS9EdGR8KQvu/FF3ah
         Qb2l7SLgxQ0h5a+QbRe4UIm5U8kka33wl5/4otOPQJQyw8VmAqhn+JF5vtJwRgEknuqi
         SK3zanc8pWh72nGYEo0y2mszhV3vVvXLmksLHsUwppeUnWgWzb6Wmj8Bz/77Et+yPYfg
         iTJytfOeIoQBUJjI4H+i3sVIlh3MKiekWr4VOFpKm5lkKvksBD5ZCQzxdzcDWC8BLMtN
         fWOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770676862; x=1771281662;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I8vsvPCwrm4qK2tJSRhYymVMX8OUXdkNYkDGMZ9conM=;
        b=QdDxmFmbQ/vX6zsyHKkAQOHKw1fR58xLif4BVpVb2Y1SkE8oF/V74gCMwWc/BPcLHb
         Xa68+OjLig9mp4xpxkIGARrodnhXdVzFzFQAuLJjmAVd663N1r+zLnr3/pQtc3uE3mTJ
         oFmCJHWjLaxGhDHvprCrS4DVxrfvHuAAhwU3qnpcRWJnVsl/EDn7AsuS9Xh8+mpolKg/
         8IdJXgo1wNVzPZd9kyTbMf+jFfN67/W0wupYcXJ61/2a51ok3iVB0KpUgm7rUMywMUCm
         +5IJ7RDMvdZPCYJdmByGfbsGfYvS21cpq711gQkd9i0B+GSRlLBIUowEdu8nYfKYN3+W
         6h8g==
X-Forwarded-Encrypted: i=1; AJvYcCWdJZU1nZBaPpjrmKFqAvCv8g6uN0urNzeueo4qmK5h/oDa3SAS8pFQvv4ASSV631jaVOwdNgk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyaqDuRgV05oDQlOjj6cafOkmk2kmFtGj1KyzvdRpMb0C+HY1p5
	F6zxXDBeE9oB9T+beDHASP2w62u4UCVPmjY8cy/Ids1UOghwaX3UJethEz788vopXYxsT3XN2YG
	YJQe30kK5bMayqka9OOs32P+Sqw==
X-Received: from iomv22.prod.google.com ([2002:a5e:d716:0:b0:957:5d25:584])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:1622:b0:662:f8f6:e8d1 with SMTP id 006d021491bc7-66d09ac24cdmr6817429eaf.6.1770676861761;
 Mon, 09 Feb 2026 14:41:01 -0800 (PST)
Date: Mon,  9 Feb 2026 22:14:11 +0000
In-Reply-To: <20260209221414.2169465-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260209221414.2169465-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260209221414.2169465-17-coltonlewis@google.com>
Subject: [PATCH v6 16/19] KVM: arm64: Add vCPU device attr to partition the PMU
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Alexandru Elisei <alexandru.elisei@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Jonathan Corbet <corbet@lwn.net>, Russell King <linux@armlinux.org.uk>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, 
	Oliver Upton <oliver.upton@linux.dev>, Mingwei Zhang <mizhang@google.com>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a new PMU device attr to enable the partitioned PMU for a given
VM. This capability can be set when the PMU is initially configured
before the vCPU starts running and is allowed where PMUv3 and VHE are
supported and the host driver was configured with
arm_pmuv3.reserved_host_counters.

The enabled capability is tracked by the new flag
KVM_ARCH_FLAG_PARTITIONED_PMU_ENABLED.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/include/uapi/asm/kvm.h |  2 ++
 arch/arm64/kvm/pmu-direct.c       | 35 ++++++++++++++++++++++++++++---
 arch/arm64/kvm/pmu.c              | 14 +++++++++++++
 include/kvm/arm_pmu.h             |  9 ++++++++
 5 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 41577ede0254f..f0b0a5edc7252 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -353,6 +353,8 @@ struct kvm_arch {
 #define KVM_ARCH_FLAG_WRITABLE_IMP_ID_REGS		10
 	/* Unhandled SEAs are taken to userspace */
 #define KVM_ARCH_FLAG_EXIT_SEA				11
+	/* Partitioned PMU Enabled */
+#define KVM_ARCH_FLAG_PARTITION_PMU_ENABLED		12
 	unsigned long flags;
 
 	/* VM-wide vCPU feature set */
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index a792a599b9d68..3e0b7619f781d 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -436,6 +436,8 @@ enum {
 #define   KVM_ARM_VCPU_PMU_V3_FILTER		2
 #define   KVM_ARM_VCPU_PMU_V3_SET_PMU		3
 #define   KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS	4
+#define   KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION	5
+
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
diff --git a/arch/arm64/kvm/pmu-direct.c b/arch/arm64/kvm/pmu-direct.c
index 6ebb59d2aa0e7..1dbf50b8891f6 100644
--- a/arch/arm64/kvm/pmu-direct.c
+++ b/arch/arm64/kvm/pmu-direct.c
@@ -44,8 +44,8 @@ bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
 }
 
 /**
- * kvm_vcpu_pmu_is_partitioned() - Determine if given VCPU has a partitioned PMU
- * @vcpu: Pointer to kvm_vcpu struct
+ * kvm_pmu_is_partitioned() - Determine if given VCPU has a partitioned PMU
+ * @kvm: Pointer to kvm_vcpu struct
  *
  * Determine if given VCPU has a partitioned PMU by extracting that
  * field and passing it to :c:func:`kvm_pmu_is_partitioned`
@@ -55,7 +55,36 @@ bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
 bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu)
 {
 	return kvm_pmu_is_partitioned(vcpu->kvm->arch.arm_pmu) &&
-		false;
+		test_bit(KVM_ARCH_FLAG_PARTITION_PMU_ENABLED, &vcpu->kvm->arch.flags);
+}
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
+		armv8pmu_max_guest_counters > -1;
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
 }
 
 /**
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 72d5b7cb3d93e..cdf51f24fdaf3 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -759,6 +759,19 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 		return kvm_arm_pmu_v3_set_nr_counters(vcpu, n);
 	}
+	case KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION: {
+		unsigned int __user *uaddr = (unsigned int __user *)(long)attr->addr;
+		bool enable;
+
+		if (get_user(enable, uaddr))
+			return -EFAULT;
+
+		if (!has_kvm_pmu_partition_support())
+			return -EPERM;
+
+		kvm_pmu_partition_enable(kvm, enable);
+		return 0;
+	}
 	case KVM_ARM_VCPU_PMU_V3_INIT:
 		return kvm_arm_pmu_v3_init(vcpu);
 	}
@@ -798,6 +811,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	case KVM_ARM_VCPU_PMU_V3_FILTER:
 	case KVM_ARM_VCPU_PMU_V3_SET_PMU:
 	case KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS:
+	case KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION:
 		if (kvm_vcpu_has_pmu(vcpu))
 			return 0;
 	}
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 93586691a2790..ff898370fa63f 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -109,6 +109,8 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu);
 void kvm_pmu_put(struct kvm_vcpu *vcpu);
 
 void kvm_pmu_set_physical_access(struct kvm_vcpu *vcpu);
+bool has_kvm_pmu_partition_support(void);
+void kvm_pmu_partition_enable(struct kvm *kvm, bool enable);
 
 #if !defined(__KVM_NVHE_HYPERVISOR__)
 bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu);
@@ -311,6 +313,13 @@ static inline void kvm_pmu_host_counters_enable(void) {}
 static inline void kvm_pmu_host_counters_disable(void) {}
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
2.53.0.rc2.204.g2597b5adb4-goog

