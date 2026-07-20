Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79783A960F
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 05:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784525951; cv=none; b=Agl77kvmTQAbr5o5XayMSRA6PnzCXfRomUQIyOwBviGZ1R+ZMWwznaphCQHYDu8NxRvUUPM32VRuuym0TwITiwlmkP/gdlxKU5yX/dhR0E8yoFIvV2lehNftbE6WcRmjvmDNUOyOnWc/Ghn79onwncp1gqU1JIQCoLC3a1mLktU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784525951; c=relaxed/simple;
	bh=QXLi4BaISj6K96xiBotXfi41vMcOQpXCXihj7bhuZOM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=B4pD30fWEMIDTlzU4n2XU6OO8B/uLnatF+o/3x2FKUXeRtBV0XSPeqTPNGv/Yz2T+zMM9CQjv4jHTrF7jONc5CMMe5tZfy5TgGMhwN8BzRqPwS3NyL/uAI4b4tV0mJL1wxFF04plCbW06EeMwDpFBpga5+kovhQVm1jT405lK2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=UX/qEQ9y reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="UX/qEQ9y"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66K5c7ox075973
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 20 Jul 2026 14:38:29 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=sryd5wgM/WV7CCzgVPBhME2gOGQl3p56pZ3ofzm2E08=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1784525910; v=1;
        b=UX/qEQ9ylaxpkctA5ySyBA6yOHyXvDr22pzL85d60tX9o/nmTj/K7NZnyqvY1UZp
         HBrPor2P/qv/NkME6lLKJ+G0A5D9HqQN3MLOls0ZIGpGZHIdCdxKBMftZCsSgfD1
         sg9KNytv4e7BK8PhB6OrAf8uD8j84zvBOzSX0bMRL/MHwG5tcHGX2bVmwSLxfZFk
         tuCZSjF6eR+rha283jCf5F8qzJdzXDndUPI0tED0TIV8wsawfZj5ogG8dWBI0Zhz
         QdxniXXZ2hXtM/6eeOUqr8Y8zCZwp8CtdPetiPLha8QDazrbGUpR6bOewpDWQmT5
         5R/vN+29NsL34sQMamx3Tg==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 20 Jul 2026 14:38:09 +0900
Subject: [PATCH v9 15/16] KVM: arm64: PMU: Introduce FIXED_COUNTERS_ONLY
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hybrid-v9-15-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
References: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260720-hybrid-v9-0-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
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
        Steffen Eiden <seiden@linux.ibm.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.16-dev-925f5
X-Developer-Signature: v=1; a=openpgp-sha256; l=7747;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=QXLi4BaISj6K96xiBotXfi41vMcOQpXCXihj7bhuZOM=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ1bsFj+vq09nSe4q5bYWmLu3ReXc8lP+L+SYD51NY1ymN
 S9Puyapo5SFQYyLQVZMkSWlaDe3RnTtp8KE+BaYOaxMIEMYuDgFYCJ5XowM7/UjPtyP+ZU26/F6
 7sTZ6+yk7lhLnXdXeWju/SKk7KDjLUaG42tdMgIFS9d2rIz2V5G3c/l25Mjqa4kRH5bu4JW9xSb
 FDgA=
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

Introduce the KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY attribute to
create a "fixed-counters-only" PMU.

Much like KVM_ARM_VCPU_PMU_V3_IRQ and other read-write attributes, this
attribute provides a getter that facilitates kernel and userspace
debugging/testing.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 Documentation/virt/kvm/devices/vcpu.rst | 30 ++++++++++++++++++++++++++----
 arch/arm64/include/uapi/asm/kvm.h       |  1 +
 arch/arm64/kvm/pmu-emul.c               | 30 +++++++++++++++++++++++++++---
 tools/arch/arm64/include/uapi/asm/kvm.h |  1 +
 4 files changed, 55 insertions(+), 7 deletions(-)

diff --git a/Documentation/virt/kvm/devices/vcpu.rst b/Documentation/virt/kvm/devices/vcpu.rst
index 66e714f2fcfa..1d592e70bdea 100644
--- a/Documentation/virt/kvm/devices/vcpu.rst
+++ b/Documentation/virt/kvm/devices/vcpu.rst
@@ -74,7 +74,8 @@ irqchip.
 	 -ENODEV  PMUv3 not supported or GIC not initialized
 	 -ENXIO   PMUv3 not properly configured or in-kernel irqchip not
 	 	  configured as required prior to calling this attribute
-	 -EBUSY   PMUv3 already initialized or a VCPU has already run
+	 -EBUSY   PMUv3 already initialized, a VCPU has already run or
+		  FIXED_COUNTERS_ONLY has already been set
 	 -EINVAL  Invalid filter range
 	 =======  ======================================================
 
@@ -116,14 +117,14 @@ using event 0x11 (CPU_CYCLES).
 
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
@@ -165,6 +166,27 @@ explicitly selected, or the number of counters is out of range for the
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
+When this attribute is enabled, the vCPU can run on any physical CPU
+that has a PMU, regardless of the underlying implementation. This
+attribute is VM-scoped.
+
 2. GROUP: KVM_ARM_VCPU_TIMER_CTRL
 =================================
 
diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
index 1c13bfa2d38a..39a1a1e412e6 100644
--- a/arch/arm64/include/uapi/asm/kvm.h
+++ b/arch/arm64/include/uapi/asm/kvm.h
@@ -437,6 +437,7 @@ enum {
 #define   KVM_ARM_VCPU_PMU_V3_FILTER		2
 #define   KVM_ARM_VCPU_PMU_V3_SET_PMU		3
 #define   KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS	4
+#define   KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY	5
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index 1ec09ef28467..ff5d5f66a9c0 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -1118,8 +1118,8 @@ int kvm_arm_set_default_pmu(struct kvm *kvm)
 	 * affines the VMM to a particular cluster of cores.
 	 *
 	 * In any case, userspace should just do the sane thing and use the UAPI
-	 * to select a PMU type directly. But, be wary of the baggage being
-	 * carried here.
+	 * to select a PMU type directly, or request fixed-counters-only
+	 * emulation. But, be wary of the baggage being carried here.
 	 */
 	struct arm_pmu *arm_pmu = kvm_pmu_probe_armpmu(raw_smp_processor_id());
 
@@ -1144,11 +1144,13 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
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
 			ret = 0;
@@ -1159,6 +1161,22 @@ static int kvm_arm_pmu_v3_set_pmu(struct kvm_vcpu *vcpu, int pmu_id)
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
@@ -1236,7 +1254,7 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		     filter.action != KVM_PMU_EVENT_DENY))
 			return -EINVAL;
 
-		if (kvm_vm_has_ran_once(kvm))
+		if (kvm_vm_has_ran_once(kvm) || kvm_pmu_fixed_counters_only(kvm))
 			return -EBUSY;
 
 		if (!kvm->arch.pmu_filter) {
@@ -1281,6 +1299,8 @@ int kvm_arm_pmu_v3_set_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 
 		return kvm_arm_pmu_v3_set_nr_counters(vcpu, n);
 	}
+	case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
+		return kvm_arm_pmu_v3_set_pmu_fixed_counters_only(vcpu);
 	case KVM_ARM_VCPU_PMU_V3_INIT:
 		return kvm_arm_pmu_v3_init(vcpu);
 	}
@@ -1307,6 +1327,9 @@ int kvm_arm_pmu_v3_get_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 		irq = vcpu->arch.pmu.irq_num;
 		return put_user(irq, uaddr);
 	}
+	case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
+		if (kvm_pmu_fixed_counters_only(vcpu->kvm))
+			return 0;
 	}
 
 	return -ENXIO;
@@ -1320,6 +1343,7 @@ int kvm_arm_pmu_v3_has_attr(struct kvm_vcpu *vcpu, struct kvm_device_attr *attr)
 	case KVM_ARM_VCPU_PMU_V3_FILTER:
 	case KVM_ARM_VCPU_PMU_V3_SET_PMU:
 	case KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS:
+	case KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY:
 		if (kvm_vcpu_has_pmu(vcpu))
 			return 0;
 	}
diff --git a/tools/arch/arm64/include/uapi/asm/kvm.h b/tools/arch/arm64/include/uapi/asm/kvm.h
index 1c13bfa2d38a..39a1a1e412e6 100644
--- a/tools/arch/arm64/include/uapi/asm/kvm.h
+++ b/tools/arch/arm64/include/uapi/asm/kvm.h
@@ -437,6 +437,7 @@ enum {
 #define   KVM_ARM_VCPU_PMU_V3_FILTER		2
 #define   KVM_ARM_VCPU_PMU_V3_SET_PMU		3
 #define   KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS	4
+#define   KVM_ARM_VCPU_PMU_V3_FIXED_COUNTERS_ONLY	5
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1

-- 
2.55.0

