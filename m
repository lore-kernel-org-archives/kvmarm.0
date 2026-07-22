Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EE34399DE
	for <kvmarm@lists.linux.dev>; Wed, 22 Jul 2026 20:27:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.218.115.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784752046; cv=none; b=Wcaq7yDG91DDLcmgfFFmrHewLBt2RVDJEoREf6Wa/4AE4rI0g2rPStyOJZ2huqMcVvJ6zrATh2nZAvaNnRiSazGwZ4EanXVN6AGd/O4xPlUa+aRnyNkhK8lJ67/f0sCe2iXSSmTpoFjg3GLizV0i/wJRHCLTAEFCVxIx4ajdutU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784752046; c=relaxed/simple;
	bh=ozJ5nbD6JmX0X2r7D2OYntNCJ/DVQ1BmXd0reC3GanQ=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q4qmV/H8JESnYd/J6W+Ej/52lnTMBQ/OEowihMJ24cQOjOvxdORkIIYLtJeDTCysn/fKRN4Oc9g84ra4u58ttExp/s6Jd9q+5K+m7fNE9egpbP4ojO1INM8psMxTxuNFl/0tCUdB7/tuSc524j7F3bQQkzi0iC6WiHhq7GybMWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=lDrkM2XK; arc=none smtp.client-ip=34.218.115.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="lDrkM2XK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1784752044; x=1816288044;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BQ1HJB58rpvqPffKJf0TmIBeL9E2JVg2QLg3N5xQr7M=;
  b=lDrkM2XKvxKT+yKRZ/O63ivH/LcawB8jK92uQEnKP0qF3IVGjA7Bu8f1
   b076lAdkCA2DrcJiGXYW87eSaFLSS6PQDUGi1sCNElrw4pA5M36o/aD25
   ecDw8OTTU0mp53+SDq9EwWJS+lAbyq3AgJCLYB2yUUWRpfh1FWZW2cNhr
   x9gWfM35pVH256l6CqBKFxC/Vy9JanmVrP9mkIu2b/zvwSupyw/rMhd11
   AQOdrbQrUOR1S7sC/gB39GRfqjHAmSspgETWJRfjYWnkxdSueIu/hswfO
   8NeRflJdLLdX6dHN1j2u0DG6xUCnaxjqCc415Tkkz48QpyJvkbsF953Db
   Q==;
X-CSE-ConnectionGUID: RupK4AxCSsSgAC6r6HOo2g==
X-CSE-MsgGUID: 8nmXpRQdQ2mSZoTN+vQODQ==
X-IronPort-AV: E=Sophos;i="6.25,179,1779148800"; 
   d="scan'208";a="23983739"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jul 2026 20:27:24 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:17210]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.25.115:2525] with esmtp (Farcaster)
 id 528b30be-bf0c-4169-96b8-b8ddca4aacce; Wed, 22 Jul 2026 20:27:23 +0000 (UTC)
X-Farcaster-Flow-ID: 528b30be-bf0c-4169-96b8-b8ddca4aacce
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Wed, 22 Jul 2026 20:27:23 +0000
Received: from dev-dsk-congkai-2a-df9e8fab.us-west-2.amazon.com
 (172.23.251.204) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Wed, 22 Jul 2026
 20:27:23 +0000
From: Congkai Tan <congkai@amazon.com>
To: Oliver Upton <oupton@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>
CC: Congkai Tan <congkai@amazon.com>, Marc Zyngier <maz@kernel.org>, "Joey
 Gouly" <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, "Haris
 Okanovic" <harisokn@amazon.com>, Geoff Blake <blakgeof@amazon.com>,
	"Stanislav Spassov" <stanspas@amazon.de>, <kvm@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kselftest@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: [PATCH v3 4/4] KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_STRICT vCPU feature
Date: Wed, 22 Jul 2026 20:27:02 +0000
Message-ID: <20260722202702.4165917-5-congkai@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260722202702.4165917-1-congkai@amazon.com>
References: <20260722202702.4165917-1-congkai@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D045UWC001.ant.amazon.com (10.13.139.223) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

Introduce a new vCPU feature KVM_ARM_VCPU_PMU_V3_STRICT. When set, KVM
does not create a default PMU when initializing the vCPU, and userspace
must select one explicitly via KVM_ARM_VCPU_PMU_V3_SET_PMU before the
first KVM_RUN.

The flag forces the VMM to be aware of the PMU implementation of the
guest to be created, so that certain information about the PMU becomes
deterministic (if on a heterogeneous system) and becomes safe to be
exposed to the guest. It can be used as an umbrella flag to gate future
PMUv3 UAPI changes.

When no default PMU is created, kvm->arch.arm_pmu stays NULL until SET_PMU
runs, so kvm_arm_pmu_v3_init() now refuses to run if kvm->arch.arm_pmu
is NULL.

Signed-off-by: Congkai Tan <congkai@amazon.com>
Reviewed-by: Geoff Blake <blakgeof@amazon.com>
Reviewed-by: Haris Okanovic <harisokn@amazon.com>
Reviewed-by: Stanislav Spassov <stanspas@amazon.de>
Co-developed-by: Oliver Upton <oupton@kernel.org>
Signed-off-by: Oliver Upton <oupton@kernel.org>
---
 Documentation/virt/kvm/api.rst          | 11 +++++++++++
 Documentation/virt/kvm/devices/vcpu.rst | 11 +++++++++--
 arch/arm64/include/asm/kvm_host.h       |  2 +-
 arch/arm64/kvm/arm.c                    | 19 +++++++++++++++----
 arch/arm64/kvm/pmu-emul.c               | 18 +++++++++++++++++-
 include/uapi/linux/kvm.h                |  1 +
 6 files changed, 54 insertions(+), 8 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index a5f9ee92f43e..4988c32df4bf 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3515,6 +3515,17 @@ Possible features:
 	  Depends on KVM_CAP_ARM_PSCI_0_2.
 	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
 	  Depends on KVM_CAP_ARM_PMU_V3.
+	- KVM_ARM_VCPU_PMU_V3_STRICT: Enable strict PMUv3 UAPI.
+	  Requires KVM_ARM_VCPU_PMU_V3. Depends on KVM_CAP_ARM_PMU_V3_STRICT.
+	  When enabled:
+
+	    * Userspace must explicitly select a PMU implementation before
+	      initializing the PMU or configuring a PMU event filter
+
+	    * If the PMU implements FEAT_PMUv3p4, PMMIR_EL1.SLOTS provides the
+	      hardware value of the underlying implementation
+
+	    * Writes to PMCR_EL0.N via KVM_SET_ONE_REG are ignored
 
 	- KVM_ARM_VCPU_PTRAUTH_ADDRESS: Enables Address Pointer authentication
 	  for arm64 only.
diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 66e714f2fcfa..deb5c51bc00c 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -53,8 +53,9 @@ Returns:
 	 =======  ======================================================
 	 -EEXIST  Interrupt number already used
 	 -ENODEV  PMUv3 not supported or GIC not initialized
-	 -ENXIO   PMUv3 not supported, missing VCPU feature or interrupt
-		  number not set (non-GICv5 guests, only)
+	 -ENXIO   PMUv3 not supported, missing VCPU feature, missing
+                  hardware PMU, or interrupt number not set (non-GICv5
+                  guests, only)
 	 -EBUSY   PMUv3 already initialized
 	 =======  ======================================================
 
@@ -62,6 +63,9 @@ Request the initialization of the PMUv3.  If using the PMUv3 with an in-kernel
 virtual GIC implementation, this must be done after initializing the in-kernel
 irqchip.
 
+When the KVM_ARM_VCPU_PMU_V3_STRICT vCPU feature is enabled this must be done
+after selecting a hardware PMU.
+
 1.3 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_FILTER
 -----------------------------------------
 
@@ -108,6 +112,9 @@ hardware event. Filtering event 0x1E (CHAIN) has no effect either, as it
 isn't strictly speaking an event. Filtering the cycle counter is possible
 using event 0x11 (CPU_CYCLES).
 
+When the KVM_ARM_VCPU_PMU_V3_STRICT vCPU feature is enabled this must be done
+after selecting a hardware PMU.
+
 1.4 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_SET_PMU
 ------------------------------------------
 
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 9e035d587970..39f7fc740d07 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -39,7 +39,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 9
+#define KVM_VCPU_MAX_FEATURES 10
 #define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
 
 #define KVM_REQ_SLEEP \
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 50adfff75be8..7dbefdd846aa 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -452,6 +452,7 @@ int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
 		r = get_num_wrps();
 		break;
 	case KVM_CAP_ARM_PMU_V3:
+	case KVM_CAP_ARM_PMU_V3_STRICT:
 		r = kvm_supports_guest_pmuv3();
 		break;
 	case KVM_CAP_ARM_INJECT_SERROR_ESR:
@@ -1563,8 +1564,10 @@ static unsigned long system_supported_vcpu_features(void)
 	if (!cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
 		clear_bit(KVM_ARM_VCPU_EL1_32BIT, &features);
 
-	if (!kvm_supports_guest_pmuv3())
+	if (!kvm_supports_guest_pmuv3()) {
 		clear_bit(KVM_ARM_VCPU_PMU_V3, &features);
+		clear_bit(KVM_ARM_VCPU_PMU_V3_STRICT, &features);
+	}
 
 	if (!system_supports_sve())
 		clear_bit(KVM_ARM_VCPU_SVE, &features);
@@ -1605,6 +1608,11 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, &features))
 		return -EINVAL;
 
+	/* Strict PMUv3 UAPI requires PMUv3. */
+	if (test_bit(KVM_ARM_VCPU_PMU_V3_STRICT, &features) &&
+	    !test_bit(KVM_ARM_VCPU_PMU_V3, &features))
+		return -EINVAL;
+
 	if (!test_bit(KVM_ARM_VCPU_EL1_32BIT, &features))
 		return 0;
 
@@ -1634,10 +1642,13 @@ static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
 	int ret = 0;
 
 	/*
-	 * When the vCPU has a PMU, but no PMU is set for the guest
-	 * yet, set the default one.
+	 * When the vCPU has a PMU, but no PMU is set for the guest yet, set
+	 * the default one. If KVM_ARM_VCPU_PMU_V3_STRICT is set, no default
+	 * PMU is created, and userspace must select a PMU via
+	 * KVM_ARM_VCPU_PMU_V3_SET_PMU.
 	 */
-	if (kvm_vcpu_has_pmu(vcpu) && !kvm->arch.arm_pmu)
+	if (kvm_vcpu_has_pmu(vcpu) && !kvm->arch.arm_pmu &&
+	    !kvm_vcpu_has_pmuv3_strict(vcpu))
 		ret = kvm_arm_set_default_pmu(kvm);
 
 	/* Prepare for nested if required */
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index bcfd0a91e114..5b1af7e2176f 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -939,6 +939,10 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 
 static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 {
+	/* Only possible when using KVM_ARM_VCPU_PMU_V3_STRICT */
+	if (!vcpu->kvm->arch.arm_pmu)
+		return -ENXIO;
+
 	if (irqchip_in_kernel(vcpu->kvm)) {
 		int ret;
 
@@ -1009,6 +1013,14 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
 {
 	struct arm_pmu *arm_pmu = kvm->arch.arm_pmu;
 
+	/*
+	 * Under KVM_ARM_VCPU_PMU_V3_STRICT no PMU exists until userspace sets
+	 * one, so this can be reached before arm_pmu is set. Report no
+	 * counters in that case.
+	 */
+	if (!arm_pmu)
+		return 0;
+
 	/*
 	 * PMUv3 requires that all event counters are capable of counting any
 	 * event, though the same may not be true of non-PMUv3 hardware.
@@ -1050,7 +1062,8 @@ static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 }
 
 /**
- * kvm_arm_set_default_pmu - No PMU set, get the default one.
+ * kvm_arm_set_default_pmu - No PMU set and KVM_ARM_VCPU_PMU_V3_STRICT not
+ * set, get the default one.
  * @kvm: The kvm pointer
  *
  * The observant among you will notice that the supported_cpus
@@ -1190,6 +1203,9 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		if (kvm_vm_has_ran_once(kvm))
 			return -EBUSY;
 
+		if (!kvm->arch.arm_pmu)
+			return -ENXIO;
+
 		if (!kvm->arch.pmu_filter) {
 			kvm->arch.pmu_filter = bitmap_alloc(nr_events, GFP_KERNEL_ACCOUNT);
 			if (!kvm->arch.pmu_filter)
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 419011097fa8..9fc8dfdfd65f 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -997,6 +997,7 @@ struct kvm_enable_cap {
 #define KVM_CAP_S390_KEYOP 247
 #define KVM_CAP_S390_VSIE_ESAMODE 248
 #define KVM_CAP_S390_HPAGE_2G 249
+#define KVM_CAP_ARM_PMU_V3_STRICT 250
 
 struct kvm_irq_routing_irqchip {
 	__u32 irqchip;
-- 
2.50.1

