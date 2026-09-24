Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D75364C4F40
	for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 17:30:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790271008; cv=none; b=RIXJiHAod86U1VvC+krvZeFZIpM3KDeFwocv5Ejnr3BYQ+tbKztin+LSw71+bxZ6NwT0hFzVH+MU+0cXoSpiTPqN0yf+iEWmEFaNw2S5Ms6qShX0E9tOb0Owk51xMillre95anhwmEAi5uQM00/AvCmKGYP1bPDHZvssXJmnu4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790271008; c=relaxed/simple;
	bh=tcpNPjXd3qvmrUI3J2vBphxoC0YKj3qhbDd754LNGdc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=m/8qJ50+BXDSDuAkwW+S7eZbFqtDr30XzxSIQqHaMWjqdkF5iVTsRoWkZ8XIz3NnJpqn+coPOtLIVqm5E2hWQqHKdyoK8II9tK6Gaj/QCXOya7qq3jUsZS181gghBM5Zdo7JWM1mbWCIpb1urqzzMSsxCxXFK00REpHHq5ivxwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oEHA2330; arc=none smtp.client-ip=209.85.160.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oEHA2330"
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-45e83fd0663so142279fac.1
        for <kvmarm@lists.linux.dev>; Thu, 24 Sep 2026 10:30:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790271001; x=1790875801; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QpMA8Bt3nlKlM2NP5rgCGn6shCTfzUIqi6x5MzUvxRQ=;
        b=oEHA2330WLCxefA5H5TudoRFd3UhylM7mAdLajN9iXphMIYWR6qOWxEnM6CwNrx04h
         TlMwFXxAMrPD2tFEue64MACqkWx0OUQBnTl9sGOxBoY0JUxPolDeWsPMlwTxurAAiMi3
         cRYenXzHydGoJlPVfIwjq1jKkPMa58h6GJQ+5hxsyihrX24kP5n4M6EhUaExhAI7FOgv
         IfetsWVf+eB9NchlGB5potfg1BgYwc6gyAy7O9mEe2P1Axiu3LuEWABIJ6Dk702H+D6e
         OkV9RkhpjAtY1RGm3icpbjj6drveZjlo/W9FrP+/7C5Paqt8DapZBCbqOltA1cwzgWal
         /62Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790271001; x=1790875801;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QpMA8Bt3nlKlM2NP5rgCGn6shCTfzUIqi6x5MzUvxRQ=;
        b=ilSP/jYr02YBpsS9O50zFYdRKHLqZ5v3JIDEOUIdtZDPFU1pFF8lqO3XmvpuQUoz7/
         A0nJn9doorqLJqOE8eH9G44kei3D9HHW6F3dDvOZNiGpn05ikiNg34erfBT0hrLlQ9X+
         B/rDj39O20LBY7PelyEB8ZKawRBuO52MZzEiqT9ihoZp860ylKJu878pk98geIKuhzLh
         PyYK2WDSD7JZlchL+PwkroeWs/Cq+cGr8RbAGYvwU428YlEyjZP+DcrbM3nS6iofWSZ5
         OWf0pUuVG2Xks8G32e69QfvewvfaYDSEiVlbXzPqqJ5puAumg7ByFjbkl2uC57draD+S
         zhwQ==
X-Forwarded-Encrypted: i=1; AKwUvBwQZkV+EEXmMrLtX2NnYicBJM1u86wOm+lzEMvScrO9FB8CI9Lm8WNiw8e0XVvQhX0CFZ5sbOs=@lists.linux.dev
X-Gm-Message-State: AFuF++le3+6SlBF6GspDhLe02LwRxx4F+6O0LK+jtLMvhnK2yrsfKhZN
	/kqoBtj1wLwVcw2sCzRqgCdWH9iiAjrdkvk1TY5HRjxEQBLKxBznRNeP77+tsKpYm8Dok543IbP
	cezug+fNJKM1rCaq8p+Nv2cp2fA==
X-Received: from ilbem2-n1.prod.google.com ([2002:a05:6e02:2802:10b0:50d:83de:1b53])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:4f0f:b0:4d6:9153:2966 with SMTP id 5614622812f47-4d72b733d4amr3963904b6e.55.1790271000469;
 Thu, 24 Sep 2026 10:30:00 -0700 (PDT)
Date: Thu, 24 Sep 2026 17:29:26 +0000
In-Reply-To: <20260924172928.2110956-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260924172928.2110956-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260924172928.2110956-21-coltonlewis@google.com>
Subject: [PATCH v9 20/22] KVM: arm64: Add vCPU device attr to partition the PMU
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

Add the KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION vCPU device attribute to
enable a Partitioned PMU for a VM where PMUv3 and VHE are supported.

When partitioning is enabled (tracked via
KVM_ARCH_FLAG_PARTITION_PMU_ENABLED), userspace must explicitly
configure the number of guest event counters via
KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS with a value strictly less than the
maximum number of general-purpose counters implemented by the PMU (or
0 only when FEAT_HPMN0 is supported), leaving at least one
general-purpose counter reserved for host profiling prior to calling
KVM_ARM_VCPU_PMU_V3_INIT.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 Documentation/virt/kvm/devices/vcpu.rst | 42 ++++++++++++++-
 arch/arm64/include/asm/kvm_host.h       |  1 +
 arch/arm64/include/uapi/asm/kvm.h       |  2 +
 arch/arm64/kvm/pmu.c                    | 71 ++++++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c               |  5 +-
 5 files changed, 118 insertions(+), 3 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index deb5c51bc00c8..fb5921ed9dea2 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -57,6 +57,9 @@ Returns:
                   hardware PMU, or interrupt number not set (non-GICv5
                   guests, only)
 	 -EBUSY   PMUv3 already initialized
+	 -EINVAL  Partitioning enabled without explicitly configuring
+		  fewer than max_counters via
+		  KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS
 	 =======  ======================================================
 
 Request the initialization of the PMUv3.  If using the PMUv3 with an in-kernel
@@ -162,7 +165,8 @@ the cpu field to the processor id.
 	 -EFAULT  Error accessing the value pointed to by addr
 	 -ENODEV  PMUv3 not supported or GIC not initialized
 	 -EINVAL  No PMUv3 explicitly selected, or value of N out of
-	 	  range
+	 	  range (or N >= max_counters when partitioning is
+		  enabled)
 	 =======  ====================================================
 
 Set the number of implemented event counters in the virtual PMU. This
@@ -172,6 +176,42 @@ explicitly selected, or the number of counters is out of range for the
 selected PMU. Selecting a new PMU cancels the effect of setting this
 attribute.
 
+1.6 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION
+---------------------------------------------------
+
+:Parameters: in kvm_device_attr.addr the address to an unsigned int (u32)
+	     boolean value (non-zero to enable PMU partitioning, 0 to disable)
+
+:Returns:
+
+	 =======  ========================================================
+	 -EBUSY   PMUv3 already initialized or a VCPU has already run
+	 -EFAULT  Error accessing the value pointed to by addr
+	 -ENODEV  KVM_ARM_VCPU_PMU_V3 feature missing from VCPU
+	 -EPERM   Host hardware or kernel configuration does not support
+		  PMU partitioning (requires ARM64 VHE mode and PMUv3)
+	 -EINVAL  No PMUv3 associated with the VM, or
+		  KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS was already set to
+		  >= max_counters
+	 -ENXIO   Returned by KVM_HAS_DEVICE_ATTR when PMU partitioning is
+		  unsupported on host hardware
+	 =======  ========================================================
+
+Enable or disable hardware PMU partitioning for the VM. When enabled, physical
+PMUv3 hardware counters are partitioned between the guest and host using
+MDCR_EL2.HPMN (and FEAT_FGT fine-grained traps when supported by hardware).
+This grants the guest direct, untrapped EL0/EL1 hardware access to event
+counters 0..HPMN-1 and the cycle counter (PMCCNTR_EL0).
+
+When PMU partitioning is enabled, userspace must explicitly configure the
+number of guest event counters via KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS with a
+value strictly less than the maximum number of general-purpose counters
+implemented by the PMU (leaving at least one general-purpose counter reserved
+for host profiling) prior to calling KVM_ARM_VCPU_PMU_V3_INIT. Note that
+KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS configures general-purpose event counters
+(PMCR_EL0.N / MDCR_EL2.HPMN); the dedicated cycle counter (PMCCNTR_EL0) is
+unconditionally assigned to the guest partition when partitioning is enabled.
+
 2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
 =================================
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8dff576667d10..6180b977d8965 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -388,6 +388,7 @@ struct kvm_arch {
 
 	/* Maximum number of counters for the guest */
 	u8 nr_pmu_counters;
+	bool pmu_nr_counters_specified;
 
 	/* PMMIR_EL1.SLOTS value exposed to the guest. */
 	u8 pmmir_slots;
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 019e5e3d892e6..9d38090eb5e71 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -438,6 +438,8 @@ enum {
 #define   KVM_ARM_VCPU_PMU_V3_FILTER		2
 #define   KVM_ARM_VCPU_PMU_V3_SET_PMU		3
 #define   KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS	4
+#define   KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION	5
+
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 4a3c6600b2678..31e46a5e937c7 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -505,6 +505,14 @@ static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 			return ret;
 	}
 
+	if (kvm_pmu_is_partitioned(vcpu->kvm)) {
+		unsigned int max_counters = kvm_arm_pmu_get_max_counters(vcpu->kvm);
+
+		if (!vcpu->kvm->arch.pmu_nr_counters_specified ||
+		    vcpu->kvm->arch.nr_pmu_counters >= max_counters)
+			return -EINVAL;
+	}
+
 	init_irq_work(&vcpu->arch.pmu.overflow_work,
 		      kvm_pmu_perf_overflow_notify_vcpu);
 
@@ -591,11 +599,25 @@ static void kvm_arm_set_nr_counters(struct kvm *kvm, unsigned int nr)
 	}
 }
 
+static bool kvm_arm_pmu_any_vcpu_created(struct kvm *kvm)
+{
+	struct kvm_vcpu *vcpu;
+	unsigned long i;
+
+	kvm_for_each_vcpu(i, vcpu, kvm) {
+		if (vcpu->arch.pmu.created)
+			return true;
+	}
+
+	return false;
+}
+
 static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 {
 	lockdep_assert_held(&kvm->arch.config_lock);
 
 	kvm->arch.arm_pmu = arm_pmu;
+	kvm->arch.pmu_nr_counters_specified = false;
 	kvm_arm_set_nr_counters(kvm, kvm_arm_pmu_get_max_counters(kvm));
 }
 
@@ -642,6 +664,11 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 				break;
 			}
 
+			if (kvm_arm_pmu_any_vcpu_created(kvm)) {
+				ret = (kvm->arch.arm_pmu == arm_pmu) ? 0 : -EBUSY;
+				break;
+			}
+
 			kvm_arm_set_pmu(kvm, arm_pmu);
 			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
 
@@ -667,14 +694,26 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 static int kvm_arm_pmu_v3_set_nr_counters(struct kvm_vcpu *vcpu, unsigned int n)
 {
 	struct kvm *kvm = vcpu->kvm;
+	unsigned int max_counters;
+
+	if (kvm_vm_has_ran_once(kvm) ||
+	    (kvm_arm_pmu_any_vcpu_created(kvm) &&
+	     (!kvm->arch.pmu_nr_counters_specified ||
+	      kvm->arch.nr_pmu_counters != n)))
+		return -EBUSY;
 
 	if (!kvm->arch.arm_pmu)
 		return -EINVAL;
 
-	if (n > kvm_arm_pmu_get_max_counters(kvm))
+	max_counters = kvm_arm_pmu_get_max_counters(kvm);
+	if (n > max_counters)
+		return -EINVAL;
+
+	if (kvm_pmu_is_partitioned(kvm) && n >= max_counters)
 		return -EINVAL;
 
 	kvm_arm_set_nr_counters(kvm, n);
+	kvm->arch.pmu_nr_counters_specified = true;
 	return 0;
 }
 
@@ -786,6 +825,31 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
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
+		if (kvm_vm_has_ran_once(kvm) ||
+		    (kvm_arm_pmu_any_vcpu_created(kvm) &&
+		     kvm_pmu_is_partitioned(kvm) != !!val))
+			return -EBUSY;
+
+		if (!kvm->arch.arm_pmu)
+			return -EINVAL;
+
+		if (val && kvm->arch.pmu_nr_counters_specified &&
+		    kvm->arch.nr_pmu_counters >= kvm_arm_pmu_get_max_counters(kvm))
+			return -EINVAL;
+
+		kvm_pmu_partition_enable(kvm, val);
+		return 0;
+	}
 	case KVM_ARM_VCPU_PMU_V3_INIT:
 		return kvm_arm_pmu_v3_init(vcpu);
 	}
@@ -827,6 +891,11 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	case KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS:
 		if (kvm_vcpu_has_pmu(vcpu))
 			return 0;
+		break;
+	case KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION:
+		if (kvm_vcpu_has_pmu(vcpu) && has_kvm_pmu_partition_support())
+			return 0;
+		break;
 	}
 
 	return -ENXIO;
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 20c46ef705d30..a4779593c4f8d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1756,7 +1756,10 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	if (!kvm_vm_has_ran_once(kvm) &&
 	    !vcpu_has_nv(vcpu)	      &&
 	    !kvm_vcpu_has_pmuv3_strict(vcpu) &&
-	    new_n <= kvm_arm_pmu_get_max_counters(kvm))
+	    !kvm->arch.pmu_nr_counters_specified &&
+	    new_n <= kvm_arm_pmu_get_max_counters(kvm) &&
+	    (!kvm_pmu_is_partitioned(kvm) ||
+	     new_n < kvm_arm_pmu_get_max_counters(kvm)))
 		kvm->arch.nr_pmu_counters = new_n;
 
 	mutex_unlock(&kvm->arch.config_lock);
-- 
2.56.0.rc1.310.g51773c2048-goog

