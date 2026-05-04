Received: from mail-ot1-f73.google.com (mail-ot1-f73.google.com [209.85.210.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B8214266A2
	for <kvmarm@lists.linux.dev>; Mon,  4 May 2026 21:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777929542; cv=none; b=D86+KtVAkwlWBLdQymvjWG5TxzbQvpzQc59CEC4pUtNQCtWSipurR0yTNjFID7gG8uKtYx2zfmWi+psgS/InQDa+blL1hCGwLr6c6cRZXCEpr6wqqTZ10/qa9x1I8kdUzmWpD0Ra/KeDlwK3z75fBJwp/VWlkM3GH0KVkXoRHEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777929542; c=relaxed/simple;
	bh=84vobWOH05RGjv7LtGVjVHJaaRYadM6oijMz8EoqR4o=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=tUXJHwWaW5DvpXaMl8ScFkNnSDieXxSEXdo2H1R6Gh+kD/lC6LtC6E648RPdktG72BroteA82Ay53I2Xj/Gik60LbhkgH+tkpkivmmKHTPaczmUL34MiAP9inkkGJI5tDwZHx9Arj8gdYCE0+fz3t3Y0s4gEuFY7oVCzUNd0IXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CCKOYlmk; arc=none smtp.client-ip=209.85.210.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CCKOYlmk"
Received: by mail-ot1-f73.google.com with SMTP id 46e09a7af769-7dbd60b7ecbso10085940a34.1
        for <kvmarm@lists.linux.dev>; Mon, 04 May 2026 14:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777929531; x=1778534331; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5s0tIXpB8hlNO6Tpc8lm3vOaXeUhQ8iprPjSFyACC84=;
        b=CCKOYlmkiYN0uqMwxpPCcvvbZBCiTZ2Lm0yWj1rDhkeeQkteSDk2n9RJXMj4r86ldc
         B4IfB2QIiQMSSbEwMlYJ7UIdyJwCTsHXUoJK7n9zDuzUsP5M1/u1vHxX1i+iULXl+JFF
         9zai99bboZvwj10M9kD3EpUJ8pIAxMii7v9KGZUKRpF4DSJXGhV0P9xjKbIYFtWhmsGy
         B+xK2Mb2gPHs50comymlY3ZELC1lGXN4w+lihMcnl2XE+IaapksqqoSNwt56uPlBKkkG
         0Wq6bIJH/Dd3ob166CqegZj7bJCGy89ojMuJMR3VxDpP3y5uHzc2ACbj+EvhgB565qnf
         xReg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777929531; x=1778534331;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5s0tIXpB8hlNO6Tpc8lm3vOaXeUhQ8iprPjSFyACC84=;
        b=Y6VbLfuB+xtkhX4OuwSIMy7r3hr5Gb0s35u6YoLt/U/3z/H2T27ozEd16z27uGhD2m
         i9Z0KjoQP46q3VrRTDfrriILs9NktUQUauZzv2bAPOC3/+aK6oodn94MwWe6qLH4RlNR
         DNF5Io96h9Ssrzgwd/UIdBjeP+sqs2V1vKeYTGJ9eW15iC2FQpVzVCAiNa3KpZ1JnIJv
         PPnGznT6CFFYOREEYWcIOKLMYLrAzLU+k5fjPzHGgVO2Kpwje8g9qYCaX6b8zQzLofsm
         wbYQWtpHwElNOWNycrcYQ8Sx6yaAOt9/emXLPR0DXc/Ewgs0rrzpYzHsoemn7ueGm4hZ
         /UYQ==
X-Forwarded-Encrypted: i=1; AFNElJ/bF2gZUmsxFJT2kOnRHKTC82vqlnxcd3yMN8bZk1HsnUF1pPzOdnZiRIHTRlI8ywmViqhV54E=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9PNzjGwM2Bi4DqPJNz/Jp4KVCo8dNjgv5dt+pDvDf6CWUvHS+
	IWWuMgNMAJdVLWiC2C03lM9lgdNS+/iZ1g4ShfpzCLZS3LbA3torQpkbqCPW3UuSOOVybJ2Yesq
	RkpEv2eOboj8izJs9/fPKop45/w==
X-Received: from ilbeh6-n2.prod.google.com ([2002:a05:6e02:4c06:20b0:4fb:4dad:95a4])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6820:211:b0:696:6585:a4b with SMTP id 006d021491bc7-696979cbddfmr5538431eaf.5.1777929530625;
 Mon, 04 May 2026 14:18:50 -0700 (PDT)
Date: Mon,  4 May 2026 21:18:10 +0000
In-Reply-To: <20260504211813.1804997-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260504211813.1804997-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260504211813.1804997-18-coltonlewis@google.com>
Subject: [PATCH v7 17/20] KVM: arm64: Add vCPU device attr to partition the PMU
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
 arch/arm64/include/asm/kvm_host.h |  2 ++
 arch/arm64/include/uapi/asm/kvm.h |  2 ++
 arch/arm64/kvm/pmu-direct.c       | 35 ++++++++++++++++++++++++++++---
 arch/arm64/kvm/pmu.c              | 14 +++++++++++++
 include/kvm/arm_pmu.h             |  9 ++++++++
 5 files changed, 59 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 891433fe304ac..22b3985b978de 100644
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
index 9693d9eb69daa..47fd143cf4ac7 100644
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
 }
 
 /**
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index f1c66ce678840..add5e7da830b2 100644
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
index 4af8abf2dde0f..131c4b8eec194 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -107,6 +107,8 @@ void kvm_pmu_load(struct kvm_vcpu *vcpu);
 void kvm_pmu_put(struct kvm_vcpu *vcpu);
 
 void kvm_pmu_set_guest_owned(struct kvm_vcpu *vcpu);
+bool has_kvm_pmu_partition_support(void);
+void kvm_pmu_partition_enable(struct kvm *kvm, bool enable);
 
 #if !defined(__KVM_NVHE_HYPERVISOR__)
 bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu);
@@ -295,6 +297,13 @@ static inline u64 kvm_pmu_guest_counter_mask(void *kvm)
 
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
2.54.0.545.g6539524ca2-goog

