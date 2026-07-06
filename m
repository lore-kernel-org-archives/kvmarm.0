Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8941D41DEED
	for <kvmarm@lists.linux.dev>; Mon,  6 Jul 2026 10:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783332552; cv=none; b=OIFT4F1vdxBKh5kNZE13kHUG5TFDGI+AQjuhMVnFHMkXzo2q+5z4WZpOlGHsNmud7WwMXUdspTCQr1YP/rYKUOHXzVJo6dRXYQClLxT7oQNGpmv8JjFlr3aVplsBjvNSWzrfqHueTPfnvMN7RAEmywnPvux+km399zoL49QOWv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783332552; c=relaxed/simple;
	bh=r6e98YlV4OLCCvE9+/j+v6Rli9RH4Iy/ZRmHUETXBw0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=rrlYJrmoLwoCUbNcYyWqbw6nwggDoGYiRyj2zi6JTpd/OzDA/xu6HtNOW/b9gy2JkaJsA15wiDRKwXHGrqk/jqnkmqVLMVHOZR5zfhtmMg6amq43SgZC3fP0+F3wjrQ8aAct6d+Th9bih0Cnv70umTpfUk4U+/ohreWbwb2Umys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=DU1X6V89 reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="DU1X6V89"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 666A3TQ4013128
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 6 Jul 2026 19:03:43 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=nCwZNeDZlJVGlaWCLeWYvbGvxte1zenM4jubK+YhaG0=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1783332223; v=1;
        b=DU1X6V895JVkXdpTIAHNPQNWV5xjYrmYk8nt6k0TwVv2ESbhpC7q09iWxmCFBnSM
         LjlIq0647f8DMew/wQ0GlTAwmY+reFS9YOSeIUPzsVQz5wTxfpuIQmim3mGYqOJ8
         1INSgWTuy2fUXrfv1+YN9KCwKDaBYeGH3szy2HijVP4BJwNBlqd1RrkufE/DmfRG
         o3Q88L81VzlPKx4sdBFXTtZwWvsRFVuWNPqIbRA3eoy4rGDA5BvZwCPg7s7Zzbgg
         OeptxjvHbFbfkXxPccrcR1BvsKXMwrqPP24wl7HFYMrxPnGTTI9V5BUY8Hnji/py
         zuI1kyA7vN5/z7NMNtqtLg==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 06 Jul 2026 19:03:24 +0900
Subject: [PATCH v8 1/7] KVM: arm64: Disallow vPMU when pPMUs do not cover
 all CPUs
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260706-hybrid-v8-1-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
References: <20260706-hybrid-v8-0-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260706-hybrid-v8-0-de459617b59d@rsg.ci.i.u-tokyo.ac.jp>
To: Marc Zyngier <maz@kernel.org>, Oliver Upton <oupton@kernel.org>,
        Joey Gouly <joey.gouly@arm.com>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Zenghui Yu <yuzenghui@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, Kees Cook <kees@kernel.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Jonathan Corbet <corbet@lwn.net>,
        Shuah Khan <shuah@kernel.org>, Shuah Khan <skhan@linuxfoundation.org>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.16-dev-925f5

Commit ec3eb9ed6081 ("KVM: arm64: PMU: Disallow vPMU on non-uniform
PMUVer") made KVM reject vPMU unless the system-wide PMUVer is usable.
That covers systems where PMUv3 is absent or non-uniform, as well as
systems where IMPDEF PMUv3 sysreg traps are unavailable.

However, KVM can still accept vPMU when all CPUs uniformly trap PMUv3
sysregs, but the pPMUs registered with KVM only cover a subset of
possible CPUs.

Reject vPMU unless the registered pPMUs cover every possible CPU.
This avoids carrying support for partial pPMU coverage into the
fixed-counters-only UAPI introduced later in the series.

Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 arch/arm64/kvm/arm.c      | 16 +++++++++++++---
 arch/arm64/kvm/pmu-emul.c | 20 ++++++++++++++++++--
 include/kvm/arm_pmu.h     |  6 +++---
 3 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index 29f48f2c63ec..68767bb08285 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -1527,14 +1527,19 @@ int kvm_vm_ioctl_irq_line(struct kvm *kvm, struct kvm_irq_level *irq_level,
 	return -EINVAL;
 }
 
-static unsigned long system_supported_vcpu_features(void)
+static long system_supported_vcpu_features(void)
 {
 	unsigned long features = KVM_VCPU_VALID_FEATURES;
+	int r;
 
 	if (!cpus_have_final_cap(ARM64_HAS_32BIT_EL1))
 		clear_bit(KVM_ARM_VCPU_EL1_32BIT, &features);
 
-	if (!kvm_supports_guest_pmuv3())
+	r = kvm_supports_guest_pmuv3();
+	if (r < 0)
+		return r;
+
+	if (!r)
 		clear_bit(KVM_ARM_VCPU_PMU_V3, &features);
 
 	if (!system_supports_sve())
@@ -1555,6 +1560,7 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 					const struct kvm_vcpu_init *init)
 {
 	unsigned long features = init->features[0];
+	long r;
 	int i;
 
 	if (features & ~KVM_VCPU_VALID_FEATURES)
@@ -1565,7 +1571,11 @@ static int kvm_vcpu_init_check_features(struct kvm_vcpu *vcpu,
 			return -ENOENT;
 	}
 
-	if (features & ~system_supported_vcpu_features())
+	r = system_supported_vcpu_features();
+	if (r < 0)
+		return r;
+
+	if (features & ~r)
 		return -EINVAL;
 
 	/*
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index c816db5d6761..f50bb9d9a1e7 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -24,10 +24,26 @@ static void kvm_pmu_create_perf_event(struct kvm_pmc *pmc);
 static void kvm_pmu_release_perf_event(struct kvm_pmc *pmc);
 static bool kvm_pmu_counter_is_enabled(struct kvm_pmc *pmc);
 
-bool kvm_supports_guest_pmuv3(void)
+int kvm_supports_guest_pmuv3(void)
 {
+	cpumask_var_t cpus __free(free_cpumask_var) = CPUMASK_VAR_NULL;
+	struct arm_pmu_entry *entry;
+
+	if (!alloc_cpumask_var(&cpus, GFP_KERNEL))
+		return -ENOMEM;
+
+	cpumask_copy(cpus, cpu_possible_mask);
+
 	guard(mutex)(&arm_pmus_lock);
-	return !list_empty(&arm_pmus);
+
+	list_for_each_entry(entry, &arm_pmus, entry) {
+		struct arm_pmu *pmu = entry->arm_pmu;
+
+		if (!cpumask_andnot(cpus, cpus, &pmu->supported_cpus))
+			return 1;
+	}
+
+	return 0;
 }
 
 static struct kvm_vcpu *kvm_pmc_to_vcpu(const struct kvm_pmc *pmc)
diff --git a/include/kvm/arm_pmu.h b/include/kvm/arm_pmu.h
index 0a36a3d5c894..354f06edfdee 100644
--- a/include/kvm/arm_pmu.h
+++ b/include/kvm/arm_pmu.h
@@ -40,7 +40,7 @@ struct arm_pmu_entry {
 	struct arm_pmu *arm_pmu;
 };
 
-bool kvm_supports_guest_pmuv3(void);
+int kvm_supports_guest_pmuv3(void);
 #define kvm_arm_pmu_irq_initialized(v)	((v)->arch.pmu.irq_num != 0)
 u64 kvm_pmu_get_counter_value(struct kvm_vcpu *vcpu, u64 select_idx);
 void kvm_pmu_set_counter_value(struct kvm_vcpu *vcpu, u64 select_idx, u64 val);
@@ -99,9 +99,9 @@ void kvm_pmu_nested_transition(struct kvm_vcpu *vcpu);
 struct kvm_pmu {
 };
 
-static inline bool kvm_supports_guest_pmuv3(void)
+static inline int kvm_supports_guest_pmuv3(void)
 {
-	return false;
+	return 0;
 }
 
 #define kvm_arm_pmu_irq_initialized(v)	(false)

-- 
2.55.0

