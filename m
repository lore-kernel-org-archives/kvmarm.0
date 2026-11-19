Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795114369;
	b=qHsLGOuEm5YXV+ySkMQUU7j9O2d89lYHfJSBN8YZkvo0wv3+0xpjby2+qNpnjHGCCcF+
	 9qQNUSfHjmIyFwFNRTBnEaD5zNYVRk7FFtfGci5TUx988rSDTT5HtB5zwyVXnSu9K7slA
	 R4yBukxf/mtVjq1/OtElAJawpGzrSlhNiza4vkjLI8S20MaMKkuulz4KCS4iGRKAjry/t
	 5j6oWTEB9RgG2LzUsG9Cf2ZJ7D+XmK65KEbDiL4f7337bX6XFz2LBNTbxwYBA96yAha8x
	 +UE52WAy+SlaQN+0HSEPB+idlbtH/zmC8RW1WH0sMzOPg8JSoty2NjdI90L8Wz/dXDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795114369;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=nV3ZauVP4dhg+DnvUVPzUXSu4/5yW2ysB5SIRrxUiJA=;
	b=qVOUK1P/3GzrSiTpxTDzWQkmwWYGkNwmRvCD8kmcSzuJbMNwinSRrUkRKbUPnimKaGuW
	 aZYAezICrH2E1n3n7HgUG2oYM9IpzGwFQSWeEThqzgH0FrFy2HaBQnCu8kXRkuruXI3V+
	 9JoFykHf1yEfFClpOIFILmtiAxQBNwjdiWPj0gv32FSBcibOfaBz8tfQqufU0KrxQNnL2
	 MWz8SaIQ5d8WxCJL3g5TGZMtmFqMgQb/54HGYBKduwLnFEfalDcKOPKN2XoC4mm/u7UXT
	 lBZ6zwR8pAKuhVshgxl08Ptefl2s4q50gigJ7EbWsXfNTTUJBoe0Pz/qz1OIwsXMMIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=d0hJv7mp;
	arc=none smtp.remote-ip=209.85.210.69
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575EB607315A
	for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 18:52:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 575EB607315A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=d0hJv7mp
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-86313f7f4faso129491a34.1
        for <kvmarm@lists.linux.dev>; Thu, 19 Nov 2026 10:52:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795114366; x=1795719166; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nV3ZauVP4dhg+DnvUVPzUXSu4/5yW2ysB5SIRrxUiJA=;
        b=d0hJv7mpyRuL6FOQ4sNeDXmJK55ILwr3Nb4KTIW/dk/gZXeyx9nomdcm35UICbOK2T
         ieZ7nvdXbHv+ZCMp/WgpUYdjL2f5yf2RhryoMOOkG45OfH+HT1Lj/9LbD0WwsETwp3HD
         CcjWqwTdencVvhF2iEjSTvH8kTcbgeu+vEX9S3iMnSyn1wkNCFp42CXMA0wLavKgKdlG
         jvFs2osoWK5dxSdkaKAWDli+H6F+6d3ril7NO3SMxxafRU5yvlnq19FN19qVDrxSABDi
         WGOf5uKJZn2QzB7Vn+QemAh5skpXrT5xbtdJKWIL2jJkPsWL41vevZIcOs2nQs2Siprs
         r36g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795114366; x=1795719166;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nV3ZauVP4dhg+DnvUVPzUXSu4/5yW2ysB5SIRrxUiJA=;
        b=Sj48HSpNuo1VNm1WpOxmiQyADFx6wDhB2m+np/8wp1Soki4FKhsJu8LXy16+a01tZe
         NSlEalRteqlV8vtOtIej/ik0qs37DUiwLKxh282wP4OZXR1ewR8QqTJ89MWlm3FQSoj0
         7HQx45JaFOSS3t/3/0hw+nL2YtZcCcIiVRTWHCqCY0JfOPV4vX0xTizM1O8VHwg03+42
         myDnihK9ERUJcXVvMLqSUdtpUJPcICtbNaAUNV7jhJNHlmk5JHm/M6YxRwE7lXm0qC3U
         IF4CEdjDFORjJSxdiVfadP6mUoA46YOHA4qmGvdZ4RouhFkDjltZfoB4/qID0rd4QPSd
         zoMQ==
X-Forwarded-Encrypted: i=1; AL+hErFiEtWDoFr5rV6Jl0enCuJuWz1np5jlFXweEH86exsf92TpJTPuwSbSD4DLgT0OERaNzdPk7qM=@lists.linux.dev
X-Gm-Message-State: APuU4Z/47KiDmkFJR85YdLTOUA9ErWxU0YDcdTs+Xj+jbtZcrwmbK001
	SaEzw9QKoo5O9Fv+5uvzg4d1tneztzfSegCVvn3V//IvaIGmho/LeS6CZoUeg97yH33G+lUU4+1
	0OB+VvkiiCfe1i38jOMbIcEz7Ag==
X-Received: from iodz8.prod.google.com ([2002:a05:6602:6f48:b0:9c7:a5de:745e])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6808:14ca:b0:4f3:e98f:fa26 with SMTP id 5614622812f47-57a0d0e3264mr899339b6e.58.1795114365963;
 Thu, 19 Nov 2026 10:52:45 -0800 (PST)
Date: Thu, 19 Nov 2026 18:52:13 +0000
In-Reply-To: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261119185215.632334-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.56.1.809.ga0b61035b5-goog
Message-ID: <20261119185215.632334-32-coltonlewis@google.com>
Subject: [PATCH v10 31/33] KVM: arm64: Add vCPU device attr to partition the PMU
From: Colton Lewis <coltonlewis@google.com>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Russell King <linux@armlinux.org.uk>, Jonathan Corbet <corbet@lwn.net>, 
	Fuad Tabba <fuad.tabba@linux.dev>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, James Clark <james.clark@linaro.org>, 
	Alexandru Elisei <alexandru.elisei@arm.com>, Mingwei Zhang <mizhang@google.com>, 
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>, kvmarm@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Add the KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION vCPU device attribute to
enable a Partitioned PMU on hosts with VHE and PMUv3 support.

When partitioning is enabled (KVM_ARCH_FLAG_PARTITION_PMU_ENABLED),
userspace must configure guest general-purpose counters via
KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS before KVM_ARM_VCPU_PMU_V3_INIT:
- Require kvm_arm_pmu_part_hpmn(n) < max_counters so at least one
  general-purpose counter remains available for host profiling.
- Allow n == 0 (cycle counter only) on hosts without FEAT_HPMN0 when
  max_counters >= 2, reserving physical counter 0 (MDCR_EL2.HPMN = 1)
  and hiding it from the guest via traps.

Because PMU attributes are invoked per-vCPU while arm_pmu,
nr_pmu_counters, and partitioning state are VM-wide, VMMs such as QEMU
iterate over vCPUs (CPU_FOREACH) and call KVM_ARM_VCPU_PMU_V3_INIT on
vCPU 0 before configuring vCPU 1..N. Allow SET_PMU, SET_NR_COUNTERS, and
ENABLE_PARTITION to succeed when a vCPU PMU is already initialized as
long as the requested value matches the VM's existing configuration, and
return -EBUSY on conflicting changes.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 Documentation/virt/kvm/devices/vcpu.rst | 57 +++++++++++++++--
 arch/arm64/include/asm/kvm_host.h       |  1 +
 arch/arm64/include/uapi/asm/kvm.h       |  2 +
 arch/arm64/kvm/pmu.c                    | 83 ++++++++++++++++++++++++-
 arch/arm64/kvm/sys_regs.c               |  5 +-
 include/kvm/arm_pmu.h                   |  6 ++
 6 files changed, 148 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 7e23584fd74aa..1140c1d731d63 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -57,6 +57,9 @@ Returns:
                   hardware PMU, or interrupt number not set (non-GICv5
                   guests, only)
 	 -EBUSY   PMUv3 already initialized
+	 -EINVAL  Partitioning enabled without explicitly configuring
+		  a valid counter count via
+		  KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS
 	 =======  ======================================================
 
 Request the initialization of the PMUv3.  If using the PMUv3 with an in-kernel
@@ -161,16 +164,62 @@ the cpu field to the processor id.
                   an event filter has already been set
 	 -EFAULT  Error accessing the value pointed to by addr
 	 -ENODEV  PMUv3 not supported or GIC not initialized
-	 -EINVAL  No PMUv3 explicitly selected, or value of N out of
-	 	  range
+	 -EINVAL  No PMUv3 explicitly selected, or value of N > max_counters,
+		  or N > max_counters - 1 (or N == 0 when max_counters < 2
+		  without FEAT_HPMN0) when partitioning is enabled
 	 =======  ====================================================
 
 Set the number of implemented event counters in the virtual PMU. This
 mandates that a PMU has explicitly been selected via
 KVM_ARM_VCPU_PMU_V3_SET_PMU, and will fail when no PMU has been
 explicitly selected, or the number of counters is out of range for the
-selected PMU. Selecting a new PMU cancels the effect of setting this
-attribute.
+selected PMU. The maximum number of general-purpose counters (max_counters)
+implemented by a PMU can be queried from sysfs at
+/sys/bus/event_source/devices/<pmu>/caps/num_counters. Selecting a new PMU
+cancels the effect of setting this attribute.
+
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
+		  > max_counters - 1 (or 0 when max_counters < 2 without
+		  FEAT_HPMN0)
+	 -ENXIO   Returned by KVM_HAS_DEVICE_ATTR when PMU partitioning is
+		  unsupported on host hardware
+	 =======  ========================================================
+
+Enable or disable hardware PMU partitioning for the VM. When enabled, physical
+PMUv3 hardware counters are partitioned between the guest and host using
+MDCR_EL2.HPMN (and FEAT_FGT fine-grained traps when supported by hardware).
+This grants the guest direct, untrapped EL0/EL1 hardware access to event
+counters 0..HPMN-1 and the cycle counter (PMCCNTR_EL0), and restricts the VM's
+supported physical CPUs to those associated with the VM's PMU.
+
+When PMU partitioning is enabled, userspace must explicitly configure the
+number of guest event counters via KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS with a
+value strictly less than the maximum number of general-purpose counters
+implemented by the PMU (leaving at least one general-purpose counter reserved
+for host profiling) prior to calling KVM_ARM_VCPU_PMU_V3_INIT. Configuring 0
+event counters (cycle counter only) on hosts without FEAT_HPMN0 programs
+MDCR_EL2.HPMN = 1, reserves physical counter 0 in addition to PMCCNTR_EL0
+while hiding it from the guest via traps, and therefore requires at least two
+implemented general-purpose counters (max_counters >= 2) so at least one
+remains for host profiling. Note that KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS
+configures general-purpose event counters (PMCR_EL0.N / MDCR_EL2.HPMN); the
+dedicated cycle counter (PMCCNTR_EL0) is unconditionally assigned to the
+guest partition when partitioning is enabled.
 
 2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
 =================================
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 1fcb12995c34c..01f26a37c7f9c 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -472,6 +472,7 @@ struct kvm_arch {
 
 	/* Maximum number of counters for the guest */
 	u8 nr_pmu_counters;
+	bool pmu_nr_counters_specified;
 
 	/* PMMIR_EL1.SLOTS value exposed to the guest. */
 	u8 pmmir_slots;
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 65ee09bd14636..80e2504c1d9fb 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -453,6 +453,8 @@ struct kvm_vgic_v5_ist {
 #define   KVM_ARM_VCPU_PMU_V3_FILTER		2
 #define   KVM_ARM_VCPU_PMU_V3_SET_PMU		3
 #define   KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS	4
+#define   KVM_ARM_VCPU_PMU_V3_ENABLE_PARTITION	5
+
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 02a1968bd6cb1..e11f54a92ecfe 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -479,12 +479,22 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 	return 0;
 }
 
+bool kvm_arm_pmu_part_nr_valid(struct kvm *kvm, unsigned int n)
+{
+	return kvm_arm_pmu_part_hpmn(n) < kvm_arm_pmu_get_max_counters(kvm);
+}
+
 static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 {
 	/* Only possible when using KVM_ARM_VCPU_PMU_V3_STRICT */
 	if (!vcpu->kvm->arch.arm_pmu)
 		return -ENXIO;
 
+	if (kvm_pmu_is_partitioned(vcpu->kvm) &&
+	    (!vcpu->kvm->arch.pmu_nr_counters_specified ||
+	     !kvm_arm_pmu_part_nr_valid(vcpu->kvm, vcpu->kvm->arch.nr_pmu_counters)))
+		return -EINVAL;
+
 	if (irqchip_in_kernel(vcpu->kvm)) {
 		int ret;
 
@@ -596,11 +606,25 @@ static void kvm_arm_set_nr_counters(struct kvm *kvm, unsigned int nr)
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
 
@@ -647,6 +671,11 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 				break;
 			}
 
+			if (kvm_arm_pmu_any_vcpu_created(kvm)) {
+				ret = (kvm->arch.arm_pmu == arm_pmu) ? 0 : -EBUSY;
+				break;
+			}
+
 			kvm_arm_set_pmu(kvm, arm_pmu);
 			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
 
@@ -672,14 +701,31 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 static int kvm_arm_pmu_v3_set_nr_counters(struct kvm_vcpu *vcpu, unsigned int n)
 {
 	struct kvm *kvm = vcpu->kvm;
+	unsigned int max_counters;
+
+	if (kvm_vm_has_ran_once(kvm))
+		return -EBUSY;
+
+	if (kvm_arm_pmu_any_vcpu_created(kvm)) {
+		if (!kvm->arch.pmu_nr_counters_specified ||
+		    kvm->arch.nr_pmu_counters != n)
+			return -EBUSY;
+		return 0;
+	}
 
 	if (!kvm->arch.arm_pmu)
 		return -EINVAL;
 
-	if (n > kvm_arm_pmu_get_max_counters(kvm))
+	max_counters = kvm_arm_pmu_get_max_counters(kvm);
+	if (n > max_counters)
+		return -EINVAL;
+
+	if (kvm_pmu_is_partitioned(kvm) &&
+	    !kvm_arm_pmu_part_nr_valid(kvm, n))
 		return -EINVAL;
 
 	kvm_arm_set_nr_counters(kvm, n);
+	kvm->arch.pmu_nr_counters_specified = true;
 	return 0;
 }
 
@@ -791,6 +837,36 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
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
+		if (kvm_arm_pmu_any_vcpu_created(kvm))
+			return kvm_pmu_is_partitioned(kvm) == !!val ? 0 : -EBUSY;
+
+		if (!kvm->arch.arm_pmu)
+			return -EINVAL;
+
+		if (val && kvm->arch.pmu_nr_counters_specified &&
+		    !kvm_arm_pmu_part_nr_valid(kvm, kvm->arch.nr_pmu_counters))
+			return -EINVAL;
+
+		if (val)
+			cpumask_copy(kvm->arch.supported_cpus,
+				     &kvm->arch.arm_pmu->supported_cpus);
+
+		kvm_pmu_partition_enable(kvm, val);
+		return 0;
+	}
 	case KVM_ARM_VCPU_PMU_V3_INIT:
 		return kvm_arm_pmu_v3_init(vcpu);
 	}
@@ -832,6 +908,11 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
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
index 4967954f42b01..22d78605b8f65 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -1591,7 +1591,10 @@ static int set_pmcr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
 	if (!kvm_vm_has_ran_once(kvm) &&
 	    !vcpu_has_nv(vcpu)	      &&
 	    !kvm_vcpu_has_pmuv3_strict(vcpu) &&
-	    new_n <= kvm_arm_pmu_get_max_counters(kvm))
+	    !kvm->arch.pmu_nr_counters_specified &&
+	    new_n <= kvm_arm_pmu_get_max_counters(kvm) &&
+	    (!kvm_pmu_is_partitioned(kvm) ||
+	     kvm_arm_pmu_part_nr_valid(kvm, new_n)))
 		kvm->arch.nr_pmu_counters = new_n;
 
 	mutex_unlock(&kvm->arch.config_lock);
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index bebf981855040..479eabc96b412 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -138,6 +138,7 @@ u64 kvm_pmu_evtyper_mask(struct kvm *kvm);
 int kvm_arm_set_default_pmu(struct kvm *kvm);
 u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm);
 unsigned int kvm_arm_pmu_part_hpmn(unsigned int n);
+bool kvm_arm_pmu_part_nr_valid(struct kvm *kvm, unsigned int n);
 
 u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu);
 bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu, unsigned int idx);
@@ -283,6 +284,11 @@ static inline unsigned int kvm_arm_pmu_part_hpmn(unsigned int n)
 	return n;
 }
 
+static inline bool kvm_arm_pmu_part_nr_valid(struct kvm *kvm, unsigned int n)
+{
+	return false;
+}
+
 static inline u64 kvm_vcpu_read_pmcr(struct kvm_vcpu *vcpu)
 {
 	return 0;
-- 
2.56.1.708.g77570a6a1d-goog

