Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B18393DFB
	for <kvmarm@lists.linux.dev>; Sun, 20 Sep 2026 11:17:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789903047; cv=none; b=Fntsqr+/Rs4EAaw2E3YJNKWIjnq+LLl+nurSVo8pBMo4Bvzqzoi36HqLRSg0Z5ZfWnwE9b0rCM1UXoOylfLqYKcHfFk9qw54c6i1ASonod3ouHtxeiBQcS031NPqmQGIrPEsK4GHshmlVsZBngtEgHZg6rBd/MvdRpXYBZQtSFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789903047; c=relaxed/simple;
	bh=H2g4538IfXd2kheuqnE5Mr24KkazPziDTCFj6z5rfZc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=P/G3GD+sVSiTrD4pTzv8BVyXY6DFz4ivPQPnHSmQF1SrTKvHvFG0K+ZXY0ppQDeXSHwXuxqfrH1E70u08pkUk4AtzD+fTZXGZYgZiVKr/giLrlO5MiTi5FDhU8qrU0iCIFgGeQclvZ1ZKjH592wj4uRNmwOu7OdptGIkcyQIyT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=tj50jvEo; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="tj50jvEo"
Received: from [192.168.10.153] (p865013-ipoe.ipoe.ocn.ne.jp [153.242.222.12])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 68KBG36h088236
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 20 Sep 2026 20:16:17 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=FmUmPMIGOPuKi9K6lwCbOkYFQrg2Rso9aQclWwVUFGU=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1789902978; v=1;
        b=tj50jvEoYItTWxs392XVQV/Mhj+zzOFgf21ioC/d8qE5/df2sf77ymKtO6wo0l+F
         InWA+iyGWaGnn46Xk3GN9296Jxinhj2U4mqNWmFPA98BGKPntQFzwYDqJ59PWLVX
         ozBCIyap7TdpOI1NuPZjo2RIg0iT1E+ynko26kGfZNk/gITCkFeGyxWFTUbomUau
         VwVsfj+i43suVGT8P07r9bYUM5TV7rsdmouzNGdukFZiNaJAH7mceb2ONn+GFCU5
         vH6gcAepMB24fgmf+FquSkRIjsEnDG9oKP0KjXeU9A4v1EjeOq+YhYLRIKypq18W
         NolkxNshDZjk1ZHVW+sTJA==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Sun, 20 Sep 2026 20:16:01 +0900
Subject: [PATCH v11 20/21] KVM: arm64: PMU: Introduce FIXED_COUNTERS_ONLY
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-hybrid-v11-20-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
References: <20260920-hybrid-v11-0-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260920-hybrid-v11-0-03618771b0e1@rsg.ci.i.u-tokyo.ac.jp>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>,
        Yury Norov <yury.norov@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Eiden <seiden@linux.ibm.com>,
        Andrew Jones <andrew.jones@oss.qualcomm.com>,
        Fuad Tabba <fuad.tabba@linux.dev>, Mark Rutland <mark.rutland@arm.com>,
        Sean Christopherson <seanjc@google.com>,
        Shannon Zhao <shannon.zhao@linaro.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Fuad Tabba <fuad.tabba@linux.dev>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=10538;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=H2g4538IfXd2kheuqnE5Mr24KkazPziDTCFj6z5rfZc=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ9b6A0WlBzYFfeNVUtJlvJgzMaiHfdLOR3fdjeWdwlc9+
 iig1+fcUcrCIMbFICumyJJStJtbI7r2U2FCfAvMHFYmkCEMXJwCMBEJdYY/XBH10zblK6ca/7Jg
 PSjdLLnDQuCFZvDql6kBlptssnX+MvwPWp8xcwbHI54JSYmsaVY6K7yX7sxZeEyhIzP1/zXbhA8
 sAA==
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

Introduce the KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY attribute to
create a "fixed-counters-only" PMU.

Much like KVM_ARM_VCPU_PMU_V3_IRQ and other read-write attributes, this
attribute provides a getter that facilitates kernel and userspace
debugging/testing.

Allow strict PMUv3 vCPUs to initialize the PMU after selecting
fixed-counters-only mode, without selecting a VM-wide hardware PMU.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 Documentation/virt/kvm/api.rst          |  8 +++++--
 Documentation/virt/kvm/devices/vcpu.rst | 42 ++++++++++++++++++++++++++-------
 arch/arm64/include/uapi/asm/kvm.h       |  1 +
 arch/arm64/kvm/pmu-emul.c               | 34 ++++++++++++++++++++++----
 tools/arch/arm64/include/uapi/asm/kvm.h |  1 +
 5 files changed, 71 insertions(+), 15 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index 1a90598901c5..a6aef405ef87 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -3531,9 +3531,13 @@ Possible features:
 
 	    * Userspace must explicitly select a PMU implementation before
 	      initializing the PMU or configuring a PMU event filter
+	      (KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY also satisfies the
+	      initialization requirement; event filtering remains unavailable
+	      in that mode)
 
-	    * If the PMU implements FEAT_PMUv3p4, PMMIR_EL1.SLOTS provides the
-	      hardware value of the underlying implementation
+	    * If a hardware PMU is selected and implements FEAT_PMUv3p4,
+	      PMMIR_EL1.SLOTS provides its hardware value. In fixed-counters-only
+	      mode, PMMIR_EL1 reads as zero
 
 	    * Writes to PMCR_EL0.N via KVM_SET_ONE_REG are ignored
 
diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index a3f20a4ee4b1..41f6d708ff43 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -53,9 +53,9 @@ Returns:
 	 =======  ======================================================
 	 -EEXIST  Interrupt number already used
 	 -ENODEV  PMUv3 not supported or GIC not initialized
-	 -ENXIO   PMUv3 not supported, missing VCPU feature, missing
-                  hardware PMU, or interrupt number not set (non-GICv5
-                  guests, only)
+	 -ENXIO   PMUv3 not supported, missing VCPU feature,
+		  neither hardware PMU nor FIXED_COUNTERS_ONLY selected,
+		  or interrupt number not set (non-GICv5 guests only)
 	 -EBUSY   PMUv3 already initialized
 	 =======  ======================================================
 
@@ -64,7 +64,8 @@ virtual GIC implementation, this must be done after initializing the in-kernel
 irqchip.
 
 When the KVM_ARM_VCPU_PMU_V3_STRICT vCPU feature is enabled this must be done
-after selecting a hardware PMU.
+after selecting a hardware PMU or enabling
+KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY.
 
 1.3 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_FILTER
 -----------------------------------------
@@ -78,7 +79,8 @@ after selecting a hardware PMU.
 	 -ENODEV  PMUv3 not supported or GIC not initialized
 	 -ENXIO   PMUv3 not properly configured or in-kernel irqchip not
 	 	  configured as required prior to calling this attribute
-	 -EBUSY   PMUv3 already initialized or a VCPU has already run
+	 -EBUSY   PMUv3 already initialized, a VCPU has already run or
+		  FIXED_COUNTERS_ONLY has already been set
 	 -EINVAL  Invalid filter range
 	 =======  ======================================================
 
@@ -123,14 +125,14 @@ after selecting a hardware PMU.
 
 :Returns:
 
-	 =======  ====================================================
+	 =======  ===========================================================
 	 -EBUSY   PMUv3 already initialized, a VCPU has already run or
-                  an event filter has already been set
+                  an event filter or FIXED_COUNTERS_ONLY has already been set
 	 -EFAULT  Error accessing the PMU identifier
 	 -ENXIO   PMU not found
 	 -ENODEV  PMUv3 not supported or GIC not initialized
 	 -ENOMEM  Could not allocate memory
-	 =======  ====================================================
+	 =======  ===========================================================
 
 Request that the VCPU uses the specified hardware PMU when creating guest events
 for the purpose of PMU emulation. The PMU identifier can be read from the "type"
@@ -172,6 +174,30 @@ explicitly selected, or the number of counters is out of range for the
 selected PMU. Selecting a new PMU cancels the effect of setting this
 attribute.
 
+1.6 ATTRIBUTE: KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY
+------------------------------------------------------
+
+:Parameters: no additional parameter in kvm_device_attr.addr
+
+:Returns:
+
+	 =======  ==================================================
+	 -EBUSY   PMUv3 already initialized, a VCPU has already run,
+		  an event filter has already been set or
+		  a hardware PMU has already been specified
+	 -ENXIO   Attempted to get before setting
+	 -ENODEV  Attempted to set while PMUv3 not supported
+	 =======  ==================================================
+
+If set, KVM emulates PMUv3 without programmable event counters.
+
+With KVM_ARM_VCPU_PMU_V3_STRICT, enabling this attribute satisfies the
+PMU selection requirement for KVM_ARM_VCPU_PMU_V3_INIT.
+
+When this attribute is enabled, the vCPU can run on any physical CPU
+that has a PMU, regardless of the underlying implementation. This
+attribute is VM-scoped.
+
 2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
 =================================
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 65ee09bd1463..7a6a0af14f5a 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -453,6 +453,7 @@ struct kvm_vgic_v5_ist {
 #define   KVM_ARM_VCPU_PMU_V3_FILTER		2
 #define   KVM_ARM_VCPU_PMU_V3_SET_PMU		3
 #define   KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS	4
+#define   KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY	5
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 9c1e2f3e41db..ebb648eabdc6 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1017,8 +1017,8 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 
 static int kvm_arm_pmu_v3_init(struct kvm_vcpu *vcpu)
 {
-	/* Only possible when using KVM_ARM_VCPU_PMU_V3_STRICT */
-	if (!vcpu->kvm->arch.arm_pmu)
+	/* Strict PMUv3 requires a hardware PMU or fixed-counters-only mode. */
+	if (!vcpu->kvm->arch.arm_pmu && !kvm_pmu_fixed_counters_only(vcpu->kvm))
 		return -ENXIO;
 
 	if (irqchip_in_kernel(vcpu->kvm)) {
@@ -1153,8 +1153,8 @@ int kvm_arm_set_default_pmu(struct kvm *kvm)
 	 * affines the VMM to a particular cluster of cores.
 	 *
 	 * In any case, userspace should just do the sane thing and use the UAPI
-	 * to select a PMU type directly. But, be wary of the baggage being
-	 * carried here.
+	 * to select a PMU type directly, or request fixed-counters-only
+	 * emulation. But, be wary of the baggage being carried here.
 	 */
 	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu(raw_smp_processor_id());
 
@@ -1179,11 +1179,13 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 		arm_pmu = entry->arm_pmu;
 		if (arm_pmu->pmu.type == pmu_id) {
 			if (kvm_vm_has_ran_once(kvm) ||
+			    kvm_pmu_fixed_counters_only(kvm) ||
 			    (kvm->arch.pmu_filter && kvm->arch.arm_pmu != arm_pmu)) {
 				ret = -EBUSY;
 				break;
 			}
 
+			set_bit(KVM_ARCH_FLAG_PMU_V3_EXPLICIT, &kvm->arch.flags);
 			kvm_arm_set_pmu(kvm, arm_pmu);
 			cpumask_copy(kvm->arch.supported_cpus, &arm_pmu->supported_cpus);
 
@@ -1205,6 +1207,22 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
 	return ret;
 }
 
+static int kvm_arm_pmu_v3_set_pmu_fixed_counters_only(struct kvm_vcpu *vcpu)
+{
+	struct kvm *kvm = vcpu->kvm;
+
+	lockdep_assert_held(&kvm->arch.config_lock);
+
+	if (kvm_vm_has_ran_once(kvm) || kvm->arch.pmu_filter ||
+	    test_bit(KVM_ARCH_FLAG_PMU_V3_EXPLICIT, &kvm->arch.flags))
+		return -EBUSY;
+
+	set_bit(KVM_ARCH_FLAG_PMU_V3_FIXED_COUNTERS_ONLY, &kvm->arch.flags);
+	kvm->arch.nr_pmu_counters = 0;
+
+	return 0;
+}
+
 static int kvm_arm_pmu_v3_set_nr_counters(struct kvm_vcpu *vcpu, unsigned int n)
 {
 	struct kvm *kvm = vcpu->kvm;
@@ -1282,7 +1300,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		     filter.action != KVM_PMU_EVENT_DENY))
 			return -EINVAL;
 
-		if (kvm_vm_has_ran_once(kvm))
+		if (kvm_vm_has_ran_once(kvm) || kvm_pmu_fixed_counters_only(kvm))
 			return -EBUSY;
 
 		if (!kvm->arch.arm_pmu)
@@ -1330,6 +1348,8 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 		return kvm_arm_pmu_v3_set_nr_counters(vcpu, n);
 	}
+	case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
+		return kvm_arm_pmu_v3_set_pmu_fixed_counters_only(vcpu);
 	case KVM_ARM_VCPU_PMU_V3_INIT:
 		return kvm_arm_pmu_v3_init(vcpu);
 	}
@@ -1356,6 +1376,9 @@ int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		irq = vcpu->arch.pmu.irq_num;
 		return put_user(irq, uaddr);
 	}
+	case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
+		if (kvm_pmu_fixed_counters_only(vcpu->kvm))
+			return 0;
 	}
 
 	return -ENXIO;
@@ -1369,6 +1392,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	case KVM_ARM_VCPU_PMU_V3_FILTER:
 	case KVM_ARM_VCPU_PMU_V3_SET_PMU:
 	case KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS:
+	case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
 		if (kvm_vcpu_has_pmu(vcpu))
 			return 0;
 	}
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
index 9998252ea8ec..ec428d9f4ab4 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -452,6 +452,7 @@ struct kvm_vgic_v5_ist {
 #define   KVM_ARM_VCPU_PMU_V3_FILTER		2
 #define   KVM_ARM_VCPU_PMU_V3_SET_PMU		3
 #define   KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS	4
+#define   KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY	5
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1

-- 
2.55.0

