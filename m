Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6523337FF7B
	for <kvmarm@lists.linux.dev>; Thu,  2 Jul 2026 19:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.34.181.151
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783019082; cv=none; b=ea91lFlDfi4HQAdQZUBKreVhRBaaFQ2JCfYgFTQb5KpeGfz7Fp7825JEMCtU2aXwx+B6nPCM1JzM3yVi9HyKeXBEzwk4u9vg7FVZ31MS2KXKwedR6v/m0UMMNcR6DDuWOp+qzazgkFHjOLMNy/nxAandkxAlHnovZZoCigb6P40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783019082; c=relaxed/simple;
	bh=MvUxF2zsh8mW6QOHnT/WgmpNWzUEaDa5iKLRm2zSA5k=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SCn2JS8CVtMk8b1shC4DfDcR9eSsDv8k6cVvdpUag14BKQ4FeTO5ZdbXTnMs65gkdV7cMaL7w74tz36R4e5Z/35++7xibXkN9hvFRAZP/oJXj2ljkPX9e0JiBCXtzuQxAvK1fdu68w3I1HXhrGXtDl/6t4gVrvgIpY/sVCWQIAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=YzXcd6r+; arc=none smtp.client-ip=52.34.181.151
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="YzXcd6r+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1783019081; x=1814555081;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jN/WkzMFGUFt/RPp6TzvnHSdHbLQg7oor4+aGJgH13w=;
  b=YzXcd6r+IOlHGNf8/SVhS5TXEukhn5Hxu0qGUKmqpfGwySGE5til0HGS
   TOIfrw+/MUojDy6NRs832sJD+gFd2aB93i3a4Fh07LxUPeS/ulHh7WiiV
   Sgayx6ig6D/39hM99AqwsXotsb7cEAf0BnB5gOuouuHfI2eSJC4kMAcR+
   pcr4iRB+0M+EtD6fV9TeRyLvsugJk1ApX1pr1buvFhwKwaDKNrgTJEGTz
   QNn0WFGCWKyTwgCdD1SY16EiMC9QuQRINAllRMzobgUsgF7JGD6um8vUG
   wiUnz/DubCULKRGmx/VSt2OxmLoUXBLgIjwlncJSzIkiFdzzOLbcREd6A
   g==;
X-CSE-ConnectionGUID: Fgog3/IyQf+0jBlKaWo8Kw==
X-CSE-MsgGUID: RbZsELl0RUabGM37BE/1aw==
X-IronPort-AV: E=Sophos;i="6.25,144,1779148800"; 
   d="scan'208";a="22937563"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2026 19:04:41 +0000
Received: from EX19MTAUWB002.ant.amazon.com [205.251.233.111:17307]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.20.237:2525] with esmtp (Farcaster)
 id 330d23d9-ef2c-4a1b-a43e-161770cf5f29; Thu, 2 Jul 2026 19:04:40 +0000 (UTC)
X-Farcaster-Flow-ID: 330d23d9-ef2c-4a1b-a43e-161770cf5f29
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43;
 Thu, 2 Jul 2026 19:04:40 +0000
Received: from dev-dsk-congkai-2a-df9e8fab.us-west-2.amazon.com
 (172.23.251.204) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.43; Thu, 2 Jul 2026
 19:04:40 +0000
From: Congkai Tan <congkai@amazon.com>
To: Oliver Upton <oupton@kernel.org>, <kvmarm@lists.linux.dev>,
	<linux-arm-kernel@lists.infradead.org>
CC: Congkai Tan <congkai@amazon.com>, Marc Zyngier <maz@kernel.org>, "Joey
 Gouly" <joey.gouly@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Jonathan
 Corbet" <corbet@lwn.net>, Haris Okanovic <harisokn@amazon.com>, Geoff Blake
	<blakgeof@amazon.com>, Stanislav Spassov <stanspas@amazon.de>,
	<kvm@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kselftest@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 1/3] KVM: arm64: Add KVM_ARM_VCPU_PMU_V3_STRICT vCPU feature
Date: Thu, 2 Jul 2026 19:04:19 +0000
Message-ID: <20260702190421.420992-2-congkai@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260702190421.420992-1-congkai@amazon.com>
References: <20260702190421.420992-1-congkai@amazon.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D045UWC004.ant.amazon.com (10.13.139.203) To
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
runs, so kvm_arm_pmu_v3_enable() now refuses to run if kvm->arch.arm_pmu
is NULL.

Signed-off-by: Congkai Tan <congkai@amazon.com>
Reviewed-by: Geoff Blake <blakgeof@amazon.com>
Reviewed-by: Haris Okanovic <harisokn@amazon.com>
Reviewed-by: Stanislav Spassov <stanspas@amazon.de>
---
 Documentation/virt/kvm/api.rst          |  5 +++++
 arch/arm64/include/asm/kvm_host.h       |  2 +-
 arch/arm64/include/uapi/asm/kvm.h       |  1 +
 arch/arm64/kvm/arm.c                    | 18 ++++++++++++++----
 arch/arm64/kvm/pmu-emul.c               | 14 +++++++++++++-
 include/kvm/arm_pmu.h                   |  4 ++++
 tools/arch/arm64/include/uapi/asm/kvm.h |  1 +
 7 files changed, 39 insertions(+), 6 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 52bbbb553ce1..79b024a7ba16 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3515,6 +3515,11 @@ Possible features:
 	  Depends on KVM_CAP_ARM_PSCI_0_2.
 	- KVM_ARM_VCPU_PMU_V3: Emulate PMUv3 for the CPU.
 	  Depends on KVM_CAP_ARM_PMU_V3.
+	- KVM_ARM_VCPU_PMU_V3_STRICT: Enable strict PMUv3 UAPI.
+	  Requires KVM_ARM_VCPU_PMU_V3. If set, KVM does not create a default
+	  PMU; userspace must select a PMU implementation with
+	  KVM_ARM_VCPU_PMU_V3_SET_PMU before the first KVM_RUN. The selected
+	  PMU exposes the SLOTS field of its PMMIR_EL1 register to the guest.
 
 	- KVM_ARM_VCPU_PTRAUTH_ADDRESS: Enables Address Pointer authentication
 	  for arm64 only.
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 65eead8362e0..a6e33aaf400d 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -39,7 +39,7 @@
 
 #define KVM_MAX_VCPUS VGIC_V3_MAX_CPUS
 
-#define KVM_VCPU_MAX_FEATURES 9
+#define KVM_VCPU_MAX_FEATURES 10
 #define KVM_VCPU_VALID_FEATURES	(BIT(KVM_VCPU_MAX_FEATURES) - 1)
 
 #define KVM_REQ_SLEEP \
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 1c13bfa2d38a..019e5e3d892e 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -106,6 +106,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
 #define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
 #define KVM_ARM_VCPU_HAS_EL2_E2H0	8 /* Limit NV support to E2H RES0 */
+#define KVM_ARM_VCPU_PMU_V3_STRICT	9 /* No default PMU creation */
 
 struct kvm_vcpu_init {
 	__u32 target;
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 9453321ef8c6..d1914bee1e76 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1548,8 +1548,10 @@ static unsigned long system_supported_vcpu_features(void)
 	if (!cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
 		clear_bit(KVM_ARM_VCPU_EL1_32BIT, &features);
 
-	if (!kvm_supports_guest_pmuv3())
+	if (!kvm_supports_guest_pmuv3()) {
 		clear_bit(KVM_ARM_VCPU_PMU_V3, &features);
+		clear_bit(KVM_ARM_VCPU_PMU_V3_STRICT, &features);
+	}
 
 	if (!system_supports_sve())
 		clear_bit(KVM_ARM_VCPU_SVE, &features);
@@ -1590,6 +1592,11 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 	    test_bit(KVM_ARM_VCPU_PTRAUTH_GENERIC, &features))
 		return -EINVAL;
 
+	/* Strict PMUv3 UAPI requires PMUv3. */
+	if (test_bit(KVM_ARM_VCPU_PMU_V3_STRICT, &features) &&
+	    !test_bit(KVM_ARM_VCPU_PMU_V3, &features))
+		return -EINVAL;
+
 	if (!test_bit(KVM_ARM_VCPU_EL1_32BIT, &features))
 		return 0;
 
@@ -1619,10 +1626,13 @@ static int kvm_setup_vcpu(struct kvm_vcpu *vcpu)
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
index e1860acae641..1f24169505a9 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -923,6 +923,9 @@ void kvm_vcpu_reload_pmu(struct kvm_vcpu *vcpu)
 
 int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 {
+	if (!vcpu->kvm->arch.arm_pmu)
+		return -EINVAL;
+
 	if (!vcpu->arch.pmu.created)
 		return -EINVAL;
 
@@ -1021,6 +1024,14 @@ u8 kvm_arm_pmu_get_max_counters(struct kvm *kvm)
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
@@ -1062,7 +1073,8 @@ static void kvm_arm_set_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
 }
 
 /**
- * kvm_arm_set_default_pmu - No PMU set, get the default one.
+ * kvm_arm_set_default_pmu - No PMU set and KVM_ARM_VCPU_PMU_V3_STRICT not
+ * set, get the default one.
  * @kvm: The kvm pointer
  *
  * The observant among you will notice that the supported_cpus
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 0a36a3d5c894..13468bd5bbf2 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -76,6 +76,9 @@ void kvm_vcpu_pmu_resync_el0(void);
 #define kvm_vcpu_has_pmu(vcpu)					\
 	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3))
 
+#define kvm_vcpu_has_pmuv3_strict(vcpu)				\
+	(vcpu_has_feature(vcpu, KVM_ARM_VCPU_PMU_V3_STRICT))
+
 /*
  * Updates the vcpu's view of the pmu events for this cpu.
  * Must be called before every vcpu run after disabling interrupts, to ensure
@@ -161,6 +164,7 @@ static inline u64 kvm_pmu_get_pmceid(struct kvm_vcpu *vcpu, bool pmceid1)
 }
 
 #define kvm_vcpu_has_pmu(vcpu)		({ false; })
+#define kvm_vcpu_has_pmuv3_strict(vcpu)	({ false; })
 static inline void kvm_pmu_update_vcpu_events(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_guest(struct kvm_vcpu *vcpu) {}
 static inline void kvm_vcpu_pmu_restore_host(struct kvm_vcpu *vcpu) {}
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
index 1c13bfa2d38a..019e5e3d892e 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -106,6 +106,7 @@ struct kvm_regs {
 #define KVM_ARM_VCPU_PTRAUTH_GENERIC	6 /* VCPU uses generic authentication */
 #define KVM_ARM_VCPU_HAS_EL2		7 /* Support nested virtualization */
 #define KVM_ARM_VCPU_HAS_EL2_E2H0	8 /* Limit NV support to E2H RES0 */
+#define KVM_ARM_VCPU_PMU_V3_STRICT	9 /* No default PMU creation */
 
 struct kvm_vcpu_init {
 	__u32 target;
-- 
2.50.1

