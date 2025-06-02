Received: from mail-il1-f201.google.com (mail-il1-f201.google.com [209.85.166.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0541522DF8B
	for <kvmarm@lists.linux.dev>; Mon,  2 Jun 2025 19:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748892559; cv=none; b=vF6U9FA7MFdxkwCyQc8+eMws07LF9e088z/xfomjbX4k/AJacJvgN3kCNlPqoor32vcxzkXshHNcbAF+rjKPv/KWnz5mrbXp1oQ5K1V+4pQbP8gc1+/AA3gJPxN3GeRSHXiukG3fxKBzZhrlNHwNRsbzNagXDhRM0+9yhbHAksw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748892559; c=relaxed/simple;
	bh=CcnjBedU7/MUCvahUwrHCirXtUmsFSqeBjbuRsRRORA=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=sENyu57u3ZslAOhh7LQMu9eUjN9xuV1iyS+DYAuEGPRtfi9/6AOrFgF+vP/WljwrkN9JDMIXBWeZOd2AjpGKlz9EdViMjKhyTFeLFFDTabiWq6Xnx6Y1QmnZUzwQ1i/JQTyseOx5PEifjLTp9hzQLKZnecYp9ZI6B+KbRe9XmfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2CQevhG7; arc=none smtp.client-ip=209.85.166.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--coltonlewis.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2CQevhG7"
Received: by mail-il1-f201.google.com with SMTP id e9e14a558f8ab-3dda4bb1c97so17183195ab.1
        for <kvmarm@lists.linux.dev>; Mon, 02 Jun 2025 12:29:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1748892554; x=1749497354; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PcghHp9NHNnZagjNBq90Et1fDsToCSyQRDmWBaP4jq8=;
        b=2CQevhG7IonDtzwRe4cLIeYoiXXVKmrszB58cO3aN9WEUBD+YYHd+IjzBPgAGZASaL
         93UObIRYqgVmjThMG3WvEuh+VkOXMPFw5ZuEU75pfvuPAEmPuXVxTB2erXz2Qp99+IzA
         3msw4EBRdHWxaZ6dZiAX367zU6wRTAuCUbng0fr3Syhz4L7oBsnNtAb/lAW42fchMRSV
         0RtU4So9dA2KZXCzZMRGaN4Fo/UmJYxPK7YGtRAMxK2M0B7aCZ+ovIYMuyk/9ie+NwTp
         m5F6v/hfrAJSAQINNt6NDz/VjJiNmyRnmwnlbs6nCDiaz7dDwHAUvMFfjmmFB9UJLuUN
         cUPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748892554; x=1749497354;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PcghHp9NHNnZagjNBq90Et1fDsToCSyQRDmWBaP4jq8=;
        b=qpqMrRAeJLPSCTgi7vIq+YUniRPjpJ//9ck80yDl1ZHbhAIZJse18cd6BZJQV3M6qN
         b6doiCbnc9iBS8NOvuD+ZlshGS/DGbheJ+n+PT9XAKio843LjsCRZSfzqCwVXJ0/gbsB
         zyT2gPXw37sVYzdiP0kD/xmXKF/1PtmrGUI6y188XcwavUJ9cnEJXvhddO4DkAZtHOes
         g0/LmE7PCGGC68DhXsdxOLRueOH2OccHHL38wdXDnkUe98oC+ZRBWAF6PJuDSy2XChKF
         WzgcanzoNbuAcLC7ifiYWWjMPRJI/4LItRZzZsU8u6xkZsjOXuv91vNl8ZEuXDUViqrl
         CP4A==
X-Forwarded-Encrypted: i=1; AJvYcCU7S6Lb2YSiAc1Hz11cyZ3ySyLiwXZMohKdZjIewY7AzE8d9Y44fOwiqhxqu6TlILBCII2eNME=@lists.linux.dev
X-Gm-Message-State: AOJu0YwRlu/dFL5kXlGwYcpGPvEixpgaXrjbKRhq77zYlemY5NgxS7dV
	G0Tr03CpxXMjCGqzJo2cXenIpFouPAIMwBiAPNOnhfyky1nf5vEJbod8PryDl435yMXVcRhNcYn
	tsjPp7jALUT6ymVKrVZ5DcS4V3g==
X-Google-Smtp-Source: AGHT+IEnhHZikzLqY9Iyw+UlUAPLFo203H/gjCIqwNlpl0+DZeuWgmgKIGVnEnC2cAT2atcfhzVzUE50F2kqc2B8Og==
X-Received: from ilah6.prod.google.com ([2002:a05:6e02:1d86:b0:3dd:a262:4f8c])
 (user=coltonlewis job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6e02:b21:b0:3dc:7bc9:503e with SMTP id e9e14a558f8ab-3dd9c989ce3mr159545185ab.2.1748892554217;
 Mon, 02 Jun 2025 12:29:14 -0700 (PDT)
Date: Mon,  2 Jun 2025 19:27:01 +0000
In-Reply-To: <20250602192702.2125115-1-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20250602192702.2125115-1-coltonlewis@google.com>
X-Mailer: git-send-email 2.49.0.1204.g71687c7c1d-goog
Message-ID: <20250602192702.2125115-17-coltonlewis@google.com>
Subject: [PATCH 16/17] KVM: arm64: Add ioctl to partition the PMU when supported
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

Add KVM_ARM_PMU_PARTITION to partition the PMU for a given vCPU with a
specified number of reserved host counters. Add a corresponding
KVM_CAP_ARM_PMU_PARTITION to check for this ability.

This capability is allowed on an initialized vCPU where PMUv3, VHE,
and FGT are supported.

If the ioctl is never called, partitioning will fall back on kernel
command line kvm.reserved_host_counters as before.

Signed-off-by: Colton Lewis <coltonlewis@google.com>
---
 Documentation/virt/kvm/api.rst | 16 ++++++++++++++++
 arch/arm64/kvm/arm.c           | 21 +++++++++++++++++++++
 include/uapi/linux/kvm.h       |  4 ++++
 3 files changed, 41 insertions(+)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index fe3d6b5d2acc..88b851cb6f66 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -6464,6 +6464,22 @@ the capability to be present.
 
 `flags` must currently be zero.
 
+4.144 KVM_ARM_PARTITION_PMU
+---------------------------
+
+:Capability: KVM_CAP_ARM_PMU_PARTITION
+:Architectures: arm64
+:Type: vcpu ioctl
+:Parameters: arg[0] is the number of counters to reserve for the host
+
+This API controls the ability to partition the PMU counters into two
+sets, one set reserved for the host and one set reserved for the
+guest. When partitoned, KVM will allow the guest direct hardware
+access to the most commonly used PMU capabilities for those counters,
+bypassing the KVM traps in the standard emulated PMU implementation
+and reducing the overhead of any guest software that uses PMU
+capabilities such as `perf`. The host PMU driver will not access any
+of the counters or bits reserved for the guest.
 
 .. _kvm_run:
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 4a1cc7b72295..1c44160d3b2d 100644
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
 #include <asm/kvm_ptrauth.h>
 #include <asm/sections.h>
@@ -382,6 +384,9 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 	case KVM_CAP_ARM_PMU_V3:
 		r = kvm_supports_guest_pmuv3();
 		break;
+	case KVM_CAP_ARM_PARTITION_PMU:
+		r = kvm_pmu_partition_supported();
+		break;
 	case KVM_CAP_ARM_INJECT_SERROR_ESR:
 		r = cpus_have_final_cap(ARM64_HAS_RAS_EXTN);
 		break;
@@ -1809,6 +1814,22 @@ long kvm_arch_vcpu_ioctl(struct file *filp,
 
 		return kvm_arm_vcpu_finalize(vcpu, what);
 	}
+	case KVM_ARM_PARTITION_PMU: {
+		struct arm_pmu *pmu;
+		u8 host_counters;
+
+		if (unlikely(!kvm_vcpu_initialized(vcpu)))
+			return -ENOEXEC;
+
+		if (!kvm_pmu_partition_supported())
+			return -EPERM;
+
+		if (copy_from_user(&host_counters, argp, sizeof(host_counters)))
+			return -EFAULT;
+
+		pmu = vcpu->kvm->arch.arm_pmu;
+		return kvm_pmu_partition(pmu, host_counters);
+	}
 	default:
 		r = -EINVAL;
 	}
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index c9d4a908976e..f7387c0696d5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -932,6 +932,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_ARM_WRITABLE_IMP_ID_REGS 239
 #define KVM_CAP_ARM_EL2 240
 #define KVM_CAP_ARM_EL2_E2H0 241
+#define KVM_CAP_ARM_PARTITION_PMU 242
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
@@ -1410,6 +1411,9 @@ struct kvm_enc_region {
 #define KVM_GET_SREGS2             _IOR(KVMIO,  0xcc, struct kvm_sregs2)
 #define KVM_SET_SREGS2             _IOW(KVMIO,  0xcd, struct kvm_sregs2)
 
+/* Available with KVM_CAP_ARM_PARTITION_PMU */
+#define KVM_ARM_PARTITION_PMU	_IOWR(KVMIO, 0xce, u8)
+
 #define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
 #define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
 
-- 
2.49.0.1204.g71687c7c1d-goog

