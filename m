Received: from mail-il1-f202.google.com (mail-il1-f202.google.com [209.85.166.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8477E2FE331
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 20:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750968378; cv=none; b=tEaDoI2rQ9xmMYzpFU12y7WZqT7Y06ha8AnXBw5ed9/a5CA99ekOt/qsSHEtOpJxNhVUf/EfNK1JVZ2bLowVDt3yV/o2A/M1F6nhmceU6Tz2VPIGoy1Nky4R+RJOAxRxz46mleHPcz2p472Ts1i0DNP/3qKk6CAX9IWU2nTyXLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750968378; c=relaxed/simple;
	bh=Ur9B1M7+gVwDPw0f+x/fdeLOw95hKGc1bWeTEwS7dE0=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=bnA9FSSFiG5wPoUIbNU1+MYRh3z1q3WPykid9diUa342P7EY75FfSDyRtC8nJrjVJRngIxendVQQYfbHRqb4ZAVQ7otfqFr24W24psRgk+h43EFTsWM54nPhReqlnRiaQJhJnRiubm8b4ucb4U6oQSxQJ8nbT83SdYGmpICxgD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=e/LViCKf; arc=none smtp.client-ip=209.85.166.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="e/LViCKf"
Received: by mail-il1-f202.google.com with SMTP id e9e14a558f8ab-3de0dc57859so16841765ab.2
        for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 13:06:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1750968373; x=1751573173; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sHvOqMg130dyJ4sC7dKVjeSNT/BBBCVrJwL/iamcsPo=;
        b=e/LViCKfHKm1noTkDzJM39ugTfLjpf5jyexHF1EqV+3PaW3nFnFIdOyyGCcLf8F0rw
         9f9ch+SzT0c09d8Qiuo0zcUfJ0kx4dNOeNjRy4lIbsPWFutWhrKwC8IiNp82WsZXSekP
         8zPRmG3EbqQxC843+xYB2BgzcPG6HosgZLoZKn18SyZgX2m6CSPFo8KG/SShzAzv3sNk
         bkBShNnQH1UTUUeYN7hmdxRUtUmKD9Av6Rc1ASJfreOWg0ESinqjujaH8FFgVAifWP//
         C2hB6jBV3fyfvqxeB6ZU5iKaPK215upcVATHwB7+IDxpdXmR9DjCd8jFBOyitHbJ2UIb
         7nSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750968373; x=1751573173;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sHvOqMg130dyJ4sC7dKVjeSNT/BBBCVrJwL/iamcsPo=;
        b=eXdb+y+CZ7kGbMKGtyFWjqjPaWGGWpi8OZ62/dALgihgmVF7OuCRfegG4OCNjRohIY
         XIHdtbL9DxLRCS57VHdLcU/pQ+xdbuUBMZDqrRtDlU6UjxPK2xpMjaR0pGSSnzlQq9pR
         mELkSBa7wnQWKJMyKVJZrmTB1N1QurUNiZQL852sMhEpZOkWB929nZy7d/G2cRZCbEBE
         0LBcFfzDGHzGNagNRqP6jr2pnKI8D7d777aY82ojxCvW3IZk4Q3jVGxfrOzQBF5QSvMT
         +4eEgVQ1N4MJs+kuooGQn3qDjZPwyujE1aeUzSmPJPVZbAhsXXmV0JD3xe/GiPU+A68I
         X9Kg==
X-Forwarded-Encrypted: i=1; AJvYcCUWIhXQKQtlDTbQQDSvLxLroovO0Mxe+3cn6COazy8BEWjy/ae4LESOfydXVujbgNHy32PZwug=@lists.linux.dev
X-Gm-Message-State: AOJu0YzEcXc8q4Fy8uxhHmDGjxnOVfoukhk9KdpLzUhIOs4NpKwnvjbM
	yXOacXgHFLaRd7WUaKcxX8O9FjIPH6DWjjQ0vgsnYkSRgLat+XGi9V1JUzPEOOX5W3baxdptLmH
	fruMj8dugi/HxGcHW4oLQ0EAUPA==
X-Google-Smtp-Source: AGHT+IFCTmpcPKfhbRYfbWmSV70zC3G54uswHvEuJzrqC5pwlW7LzTFUxkgmMX60c/miGwoG/j77iicLZrxALiS37Q==
X-Received: from ilbec6.prod.google.com ([2002:a05:6e02:4706:b0:3df:16fc:af6f])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:1c23:b0:3dd:dd39:324c with SMTP id e9e14a558f8ab-3df4ab6d058mr11317385ab.9.1750968373400;
 Thu, 26 Jun 2025 13:06:13 -0700 (PDT)
Date: Thu, 26 Jun 2025 20:04:57 +0000
In-Reply-To: <20250626200459.1153955-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250626200459.1153955-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.50.0.727.gbf7dc18ff4-goog
Message-ID: <20250626200459.1153955-22-coltonlewis@google.com>
Subject: [PATCH v3 21/22] KVM: arm64: Add ioctl to partition the PMU when supported
From: Colton Lewis <coltonlewis@google.com>
To: kvm@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>, 
	Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>, 
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>, 
	Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, 
	Mark Rutland <mark.rutland@arm.com>, Shuah Khan <shuah@kernel.org>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
	kvmarm@lists.linux.dev, linux-perf-users@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, Colton Lewis <coltonlewis@google.com>
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
index 2df76689381a..3f835b28c855 100644
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
index 7c007ee44ecb..cb4380f39d98 100644
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
+		r = kvm_pmu_partition_supported();
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
index 165d1eae2634..7b5c5fcc6623 100644
--- a/arch/arm64/kvm/pmu-part.c
+++ b/arch/arm64/kvm/pmu-part.c
@@ -53,7 +53,8 @@ bool kvm_pmu_is_partitioned(struct arm_pmu *pmu)
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
2.50.0.727.gbf7dc18ff4-goog

