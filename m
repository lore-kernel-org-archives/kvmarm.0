Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FB825B683
	for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 22:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750457946; cv=none; b=qt5npZIAQD1tCgm5mWFhv3btSIxk4oGxPEwegUsLta3h+XkOjQLDAnK0QPPicZt7aYN+WRurFCdAUlF3jdoNpOPgNFl9HrKE9rcI1Aztnzk8JDAKBvJnccQQbt1LL2E7Yl+kTRJbFONJTDb2V+U3Vc7kZU0xg5dAArFaLXMJvjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750457946; c=relaxed/simple;
	bh=pIKenjuivsuNxrfTX5gucCTB8XKdbMKFSXxxmN3Vba4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=TgG5058OzxDOgwUxB4hdoRjf9HdzZGd2E6QcDcFKosXJWjuShw7wEOBRLhaOmdAylFzmtWFOS7D92cWvkk1mTq8MQk899W67TpMGhOzILLRmSokuR5YCVss9aPc0OqfLqqxJelipeFh3YY8NTzwL9/lYIVjw3k8RtPq/1pkU564=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NwRsZkiJ; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NwRsZkiJ"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3da6fe2a552so49357475ab.1
        for <kvmarm@lists.linux.dev>; Fri, 20 Jun 2025 15:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750457942; x=1751062742; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jlIaNmwKSlc4jhDaObR1hwnxm1Q7OVOS47yjE2eb8lw=;
        b=NwRsZkiJwnoRI9TDgmKyUopyIBKaZ9T1uUfcaVf4TtEbIXYOzjlEPjcqtO2tIPaOJm
         9hNMeB9hgEwzdySLJQRf8Mzx9WbRs1rLohSYyycFd7XEf69qf9xLbpJzSCHiGRO+9bJa
         0dGEEkn7Z0kxaPqCmtb/NX/sEUzY3RFQ8rE8wwOID14KdrsrPGLZjUe3I6CZ2cPQjlC3
         osZ1u9l4kikv5EY/sx1Fmrpx+FO0D68AypRSVZGf6FSb/D69XSSZiXruCGCXl96SS4oN
         l/ORPkqRRTAzW7dZJQu/CwCYEfeNE5oRFcuI0BKIJGMj2CeL1k8PxkqXTmUntR38fA+C
         E3HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750457942; x=1751062742;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jlIaNmwKSlc4jhDaObR1hwnxm1Q7OVOS47yjE2eb8lw=;
        b=lp3HStcc+xIAe6watucBAxhwRgl7Tnq2M2FNZB+piiBPJJh8J5DCXKUoM31oQl9boG
         c25JGx5mSOJ20zJmDa3MFTLADO4PvV8HHNY6d8PZ9ml/3b+ejZjjhAORHDi/F9Onedk2
         NnqJs7cmayeyMzRyuceFxAUhrOjOcatbn0tNP4qM0nrWhjWRtqi5o1zIK3ZNKIn81YMx
         3jqGsZ4bGdjQYmrs4kUoIrg/xBclLFdIEx6oYOh86EU7DrgI6oEY3oQiz4bElm+J4UEz
         DOpMaJ83ehtnP8P2QBccdt2rlNvREVh4EFp4CRzdNemLYQKTwVMdNcY2C+MukLrR6EC9
         JCcw==
X-Forwarded-Encrypted: i=1; AJvYcCXFnx5RTcsd8indTz8ELmYb1DGhJKGZAYspROkbupQUsOnbFI7aRCMj5afKDSzRneAC5mOo9oU=@lists.linux.dev
X-Gm-Message-State: AOJu0YwEisLAVca/TGJiefEc3hy4XpxISVEgppO8x8DZrL401kyaflsM
	Ok1Sm3r6+spTAYxDMekKpQ7tYLWhtrtGGW7FEeRLIkaHlfZaT7uiSnUnwwV2gm83n2VzKIvLjl3
	lJo38ODjsiNAO1ZWImF2L7vBABQ==
X-Google-Smtp-Source: AGHT+IGCeCVOZ/lzFtZabgEj5uIBvECJLOzYYRnqGjmZi9n0ocVr8mmsA3q0AfByPW+K8EB/QVJMTveOMkHDJeFyrA==
X-Received: from ilbbs5.prod.google.com ([2002:a05:6e02:2405:b0:3dd:ca16:cb9])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:258e:b0:3dd:d338:5c7a with SMTP id e9e14a558f8ab-3de38c1bed9mr54498185ab.4.1750457942046;
 Fri, 20 Jun 2025 15:19:02 -0700 (PDT)
Date: Fri, 20 Jun 2025 22:13:24 +0000
In-Reply-To: <20250620221326.1261128-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250620221326.1261128-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.714.g196bf9f422-goog
Message-ID: <20250620221326.1261128-25-coltonlewis@google.com>
Subject: [PATCH v2 22/23] KVM: arm64: Add ioctl to partition the PMU when supported
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Joey Gouly <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Zenghui Yu <yuzenghui@huawei.com>, Mark Rutland <mark.rutland@arm.com>, 
	Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev, 
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	Colton Lewis <coltonlewis@google.com>
Content-Type: text/plain; charset="UTF-8"

Add KVM_ARM_PMU_PARTITION to enable the partitioned PMU for a given
vCPU. Add a corresponding KVM_CAP_ARM_PMU_PARTITION to check for this
ability. This capability is allowed on an initialized vCPU where PMUv3
and VHE are supported.

However, because the underlying ability relies on the driver being
passed some command line arguments to configure the hardware partition
at boot, enabling the partitioned PMU will not be allowed without the
underlying driver configuration even though the capability exists.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 Documentation/virt/kvm/api.rst    | 21 +++++++++++++++++++++
 arch/arm64/include/asm/kvm_host.h |  3 +++
 arch/arm64/kvm/arm.c              | 20 ++++++++++++++++++++
 arch/arm64/kvm/pmu-part.c         |  3 ++-
 include/uapi/linux/kvm.h          |  4 ++++
 5 files changed, 50 insertions(+), 1 deletion(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 4ef3d8482000..7e76f7c87598 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6478,6 +6478,27 @@ the capability to be present.
 
 `flags` must currently be zero.
 
+4.144 KVM_ARM_PARTITION_PMU
+---------------------------
+
+:Capability: KVM_CAP_ARM_PARTITION_PMU
+:Architectures: arm64
+:Type: vcpu ioctl
+:Parameters: arg[0] is a boolean to enable the partitioned PMU
+
+This API controls the PMU implementation used for VMs. The capability
+is only available if the host PMUv3 driver was configured for
+partitioning via the module parameters `arm-pmuv3.partition_pmu=y` and
+`arm-pmuv3.reserved_guest_counters=[0-$NR_COUNTERS]`. When enabled,
+VMs are configured to have direct hardware access to the most
+frequently used registers for the counters configured by the
+aforementioned module parameters, bypassing the KVM traps in the
+standard emulated PMU implementation and reducing overhead of any
+guest software that uses PMU capabilities such as `perf`.
+
+If the host driver was configured for partitioning but the partitioned
+PMU is disabled through this interface, the VM will use the legacy PMU
+that shares the host partition.
 
 .. _kvm_run:
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 374771557d2c..0ef7ebb68d17 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -369,6 +369,9 @@ struct kvm_arch {
 	/* Maximum number of counters for the guest */
 	u8 nr_pmu_counters;
 
+	/* Whether this guest uses the partitioned PMU */
+	bool partitioned_pmu_enable;
+
 	/* Iterator for idreg debugfs */
 	u8	idreg_debugfs_iter;
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 7c007ee44ecb..97c320ed07c1 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -21,6 +21,7 @@
 #include <linux/irqbypass.h>
 #include <linux/sched/stat.h>
 #include <linux/psci.h>
+#include <linux/perf/arm_pmu.h>
 #include <trace/events/kvm.h>
 
 #define CREATE_TRACE_POINTS
@@ -38,6 +39,7 @@
 #include <asm/kvm_emulate.h>
 #include <asm/kvm_mmu.h>
 #include <asm/kvm_nested.h>
+#include <asm/kvm_pmu.h>
 #include <asm/kvm_pkvm.h>
 #include <asm/kvm_pmu.h>
 #include <asm/kvm_ptrauth.h>
@@ -383,6 +385,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PMU_V3:
 		r = kvm_supports_guest_pmuv3();
 		break;
+	case KVM_CAP_ARM_PARTITION_PMU:
+		r = kvm_supports_guest_pmuv3() && has_vhe();
+		break;
 	case KVM_CAP_ARM_INJECT_SERROR_ESR:
 		r = cpus_have_final_cap(ARM64_HAS_RAS_EXTN);
 		break;
@@ -1810,6 +1815,21 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 		return kvm_arm_vcpu_finalize(vcpu, what);
 	}
+	case KVM_ARM_PARTITION_PMU: {
+		bool enable;
+
+		if (unlikely(!kvm_vcpu_initialized(vcpu)))
+			return -ENOEXEC;
+
+		if (!kvm_pmu_is_partitioned(vcpu->kvm->arch.arm_pmu))
+			return -EPERM;
+
+		if (copy_from_user(&enable, argp, sizeof(enable)))
+			return -EFAULT;
+
+		vcpu->kvm->arch.partitioned_pmu_enable = enable;
+		return 0;
+	}
 	default:
 		r = -EINVAL;
 	}
diff --git a/arch/arm64/kvm/pmu-part.c b/arch/arm64/kvm/pmu-part.c
index 2c347e7a26d8..2388590f4843 100644
--- a/arch/arm64/kvm/pmu-part.c
+++ b/arch/arm64/kvm/pmu-part.c
@@ -38,7 +38,8 @@ bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
  */
 bool kvm_vcpu_pmu_is_partitioned(struct kvm_vcpu *vcpu)
 {
-	return kvm_pmu_is_partitioned(vcpu->kvm->arch.arm_pmu);
+	return kvm_pmu_is_partitioned(vcpu->kvm->arch.arm_pmu)
+		&& vcpu->kvm->arch.partitioned_pmu_enable;
 }
 
 /**
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c74cf8f73337..2f8a8d4cfe3c 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -935,6 +935,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_EL2_E2H0 241
 #define KVM_CAP_RISCV_MP_STATE_RESET 242
 #define KVM_CAP_GMEM_SHARED_MEM 243
+#define KVM_CAP_ARM_PARTITION_PMU 244
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1413,6 +1414,9 @@ struct kvm_enc_region {
 #define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
 #define KVM_SET_SREGS2             _IOW(KVMIO,  0xcd, struct kvm_sregs2)
 
+/* Available with KVM_CAP_ARM_PARTITION_PMU */
+#define KVM_ARM_PARTITION_PMU	_IOWR(KVMIO, 0xce, bool)
+
 #define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
 #define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
 
-- 
2.50.0.714.g196bf9f422-goog

