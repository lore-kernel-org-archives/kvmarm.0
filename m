Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2A3044AB6A
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 11:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789386166; cv=none; b=OXMSG2XjS+ORgHUY0H+CbEDCcK52WI3H7vMx/o6nwYkDZimwFoxaVgBNeaeROFIs/YcD2M1CSOLBeCQlyaLWiar4VmK0yM3SKJuRjJtodtFl2b8w/+bwLpy43EZ7DmoSnMM27MS9v5EqCfX71DV+20RDNbDlhgXtKsoG83/oioQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789386166; c=relaxed/simple;
	bh=Tfgm9WXcmRxelzdJdDKljVp7Ced7YFV3TbgyJMrdSII=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=mPEhM9yrrzHlxQLgJ7SdLWioD8LmiWpgrwgxSJ3GSM74f7B0zaktQ5QTf9okdfPFLO0emtaFDjMbPYg5Fy4KuyhQ88gMuiOe5ELt5ifS1HqEv53rd0m7XL2njpvpbk4Sd0QT6VETBgN1khXguhXS7be+ZFvcGuYCKVH8EEfKw9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=MqZjC3Q6; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="MqZjC3Q6"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 68EBfjsE084060
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 14 Sep 2026 20:41:55 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=6lniNaSo1hUoB3R0uLY0fE5jF1IOAjXaMQncZzAQRLI=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1789386115; v=1;
        b=MqZjC3Q631qgf/D/9saoaop9848yJFFlTUCVHWBOLPo7ufsEDgJ6Zl2a4Dx69uBO
         kx0zDaZ0HpT7ZXyxUGvrl/OjdF8z/MigpX7pgMsqam8jPv+nwtpzOveFHW4lHeC+
         g8jYVyc/TBV5kJ2aMBkTauEOCxu0sft9MtWM1jUeyDwjKO5CX5Diu5yS7ll0dAHb
         2HbLl6mEJWCoNkVzerQp6b6S/7cj7W16sktrOhc/osoP/D+e2sn70o7c3eMm91e2
         74OQ1HMcsnhi/z3yiARU0qnWZZj3hrvUruavx25cCe8PvyK0tfHbE9RPg/w2/9WS
         DLIy5T8c8FchsSxwLJC0Ag==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 14 Sep 2026 20:40:51 +0900
Subject: [PATCH v10 12/20] KVM: arm64: selftests: Cover PMU state in
 MDCR_EL2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-hybrid-v10-12-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
References: <20260914-hybrid-v10-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260914-hybrid-v10-0-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
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
        Steffen Eiden <seiden@linux.ibm.com>, Fuad Tabba <tabba@google.com>,
        Shannon Zhao <shannon.zhao@linaro.org>,
        Andrew Jones <drjones@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>,
        Fuad Tabba <fuad.tabba@linux.dev>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=5050;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=Tfgm9WXcmRxelzdJdDKljVp7Ced7YFV3TbgyJMrdSII=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ9byu0WrlkQy797y2fZu7CkTbVnO9ks34wInvSgWvPkgq
 Xht5PbCjlIWBjEuBlkxRZaUot3cGtG1nwoT4ltg5rAygQxh4OIUgInw2TIyHNY815t6MXHTtJtL
 l9psvGup/1+UJ6r7+7Xf3wIqD7X8OszI8Hr/yjDG0DXzl/8RM8wpOX3Q4sKtLua/72ZujT7qFDg
 nmBUA
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

Add MDCR_EL2 coverage to vpmu_counter_access when EL2 is available.

For each configured PMCR_EL0.N value, verify that an arbitrary HPMN
value, including one above the configured counter count, round-trips
through KVM_SET_ONE_REG and survives SET_NR_COUNTERS. Also verify that
HPME can be toggled without disturbing HPMN and that KVM_ARM_VCPU_INIT
resets HPMN from the configured count.

Assisted-by: Codex:gpt-5.5
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Reviewed-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 .../selftests/kvm/arm64/vpmu_counter_access.c      | 90 ++++++++++++++++++++--
 1 file changed, 85 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index 05135bcdb462..73b4f1870d3d 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -25,6 +25,14 @@
 /* The cycle counter bit position that's common among the PMU registers */
 #define ARMV8_PMU_CYCLE_IDX		31
 
+#ifndef MDCR_EL2_HPMN
+#define MDCR_EL2_HPMN			GENMASK_ULL(4, 0)
+#endif
+
+#ifndef MDCR_EL2_HPME
+#define MDCR_EL2_HPME			BIT_ULL(7)
+#endif
+
 struct vpmu_vm {
 	struct kvm_vm *vm;
 	struct kvm_vcpu *vcpu;
@@ -465,15 +473,12 @@ static void guest_code_done(void)
 	GUEST_DONE();
 }
 
-static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters, bool expect_fail)
+static void set_nr_counters(struct kvm_vcpu *vcpu,
+			    unsigned int nr_counters, bool expect_fail)
 {
-	struct kvm_vcpu *vcpu;
 	unsigned int prev;
 	int ret;
 
-	create_vpmu_vm(guest_code);
-	vcpu = vpmu_vm.vcpu;
-
 	prev = get_pmcr_n(vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_PMCR_EL0)));
 
 	ret = __vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
@@ -485,6 +490,17 @@ static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters, bool
 			    nr_counters, prev);
 	else
 		TEST_ASSERT(!ret, KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
+}
+
+static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters,
+						 bool expect_fail)
+{
+	struct kvm_vcpu *vcpu;
+
+	create_vpmu_vm(guest_code);
+	vcpu = vpmu_vm.vcpu;
+
+	set_nr_counters(vcpu, nr_counters, expect_fail);
 
 	vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL, KVM_ARM_VCPU_PMU_V3_INIT, NULL);
 }
@@ -589,6 +605,69 @@ static void run_pmregs_validity_test(u64 pmcr_n)
 	destroy_vpmu_vm();
 }
 
+static void run_mdcr_el2_validity_test(u64 pmcr_n)
+{
+	struct kvm_vcpu_init init;
+	struct kvm_vcpu *vcpu;
+	u64 expected_mdcr, mdcr;
+
+	pr_debug("MDCR_EL2 test with pmcr_n %lu\n", pmcr_n);
+
+	create_vpmu_vm(guest_code);
+	if (!vm_supports_el2(vpmu_vm.vm)) {
+		destroy_vpmu_vm();
+		return;
+	}
+
+	vcpu = vpmu_vm.vcpu;
+
+	mdcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2));
+	expected_mdcr = u64_replace_bits(mdcr, FIELD_MAX(MDCR_EL2_HPMN),
+					 MDCR_EL2_HPMN);
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2),
+		     expected_mdcr);
+
+	mdcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2));
+	TEST_ASSERT(mdcr == expected_mdcr,
+		    "MDCR_EL2 was not properly updated after HPMN write (expected 0x%lx, got 0x%lx)",
+		    expected_mdcr, mdcr);
+
+	set_nr_counters(vcpu, pmcr_n, false);
+
+	mdcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2));
+	TEST_ASSERT(mdcr == expected_mdcr,
+		    "MDCR_EL2 changed after PMU_V3_SET_NR_COUNTERS (expected 0x%lx, got 0x%lx)",
+		    expected_mdcr, mdcr);
+
+	vcpu_device_attr_set(vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+			     KVM_ARM_VCPU_PMU_V3_INIT, NULL);
+
+	mdcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2));
+	TEST_ASSERT(mdcr == expected_mdcr,
+		    "MDCR_EL2 changed after PMU_V3_INIT (expected 0x%lx, got 0x%lx)",
+		    expected_mdcr, mdcr);
+
+	expected_mdcr = mdcr ^ MDCR_EL2_HPME;
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2),
+		     expected_mdcr);
+
+	mdcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2));
+	TEST_ASSERT(mdcr == expected_mdcr,
+		    "MDCR_EL2 was not properly updated after HPME write (expected 0x%lx, got 0x%lx)",
+		    expected_mdcr, mdcr);
+
+	kvm_get_default_vcpu_target(vpmu_vm.vm, &init);
+	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
+	aarch64_vcpu_setup(vcpu, &init);
+
+	mdcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2));
+	TEST_ASSERT(FIELD_GET(MDCR_EL2_HPMN, mdcr) == pmcr_n,
+		    "MDCR_EL2.HPMN is not reset after INIT (expected %lu, got %lu)",
+		    pmcr_n, FIELD_GET(MDCR_EL2_HPMN, mdcr));
+
+	destroy_vpmu_vm();
+}
+
 /*
  * Create a guest with one vCPU, and attempt to set the PMCR_EL0.N for
  * the vCPU to @pmcr_n, which is larger than the host value.
@@ -673,6 +752,7 @@ int main(void)
 	for (i = 0; i <= pmcr_n; i++) {
 		run_access_test(i);
 		run_pmregs_validity_test(i);
+		run_mdcr_el2_validity_test(i);
 	}
 
 	for (i = pmcr_n + 1; i < ARMV8_PMU_MAX_COUNTERS; i++)

-- 
2.55.0

