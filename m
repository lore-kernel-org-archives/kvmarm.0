Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F002443C39
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 11:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789386165; cv=none; b=Q1oV2shyOWezH+4PANnkYIUEcMEmWxXNmm78u+i5f1r8/FkT0Hm5/+NsGFYK8+Rq8BtrB9aMc3nIdL2zAlzPUCojm/M01E6QM0G+mgjAaYwh1BoeKdLltBjHXMKq7XGxeNah1pGi9VmpiHaK5U43CzMZmqER4P/nIg2J2FDpjCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789386165; c=relaxed/simple;
	bh=7qyZ3yw8xwXvroToHAs5qx3zfIpA0akFceWmVOkFa8E=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OMzEeHANTAjzn+hLN8g8ZEuiiCmiWu7N8poruVDh8arZjRwlHrOccIh1hsAgYkEMqbI5SNA7jPAPKEN2eNq6i9klY7gZrKsGTa160ixofBFFybVVOgXT1bdy7eyxTibYTWXkiCkOoqzKvsXGm/L9vJzGkGTKGhjM88GM9uxoRkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=KUM1bhIr; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="KUM1bhIr"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 68EBfjs6084060
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 14 Sep 2026 20:41:52 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=CpstWXsEGNxvTAnG53+JLBqVzfY5FoROk7Pvi0Mk+sY=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1789386113; v=1;
        b=KUM1bhIrNB5o0u7+SEav68b3BZwTf/oYxZ1Bd2HeDp4MMZ2D/DTusgAfYlkFR2qj
         GPHAzBR04pPcagwh7M56BHLp/xD6MgqDN5tZSxm3cXL6RWDGupkr5ub4bA2WQLCo
         iIegMATIE6GPZAgON7qJ1OQq6rBCNUpbix0qBvc1mUF0Mu/SjZJSl3Rtcw0FtsfB
         ZkwxfMZh2hfbOwLQTu7N3nSevkX+LdhBjBhKch7PvYcBhgJqwOwIDX8Z845ps0EM
         v5a5GnEB4vif+ay9jZwe9ZnPqQp0ohm70yL9O0LL13kceEVSl/jE33sEukrt5xKc
         xAH/1x00S4/Yz3YVuhjwJg==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 14 Sep 2026 20:40:43 +0900
Subject: [PATCH v10 04/20] KVM: arm64: selftests: Test SET_NR_COUNTERS
 after first run
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260914-hybrid-v10-4-92788053a691@rsg.ci.i.u-tokyo.ac.jp>
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
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.17-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3449;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=7qyZ3yw8xwXvroToHAs5qx3zfIpA0akFceWmVOkFa8E=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ9byu7li/+fc3Xds+zOzU6WzG66//Cfke4dZ5/I13dT6q
 bofU+8d7yhlYRDjYpAVU2RJKdrNrRFd+6kwIb4FZg4rE8gQBi5OAZjI7yeMDAu5U+4wm22+sai+
 3ltw+xnV1N9zU7wmRzLFP3OdsCOr3IWR4f7KXom5v1gSBYVYll67JObC9Vh2XozfXL1vm3p2JWw
 IZgUA
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

Add a regression test that runs one vCPU and then tries to change the
VM-scoped PMU counter count through an idle sibling. Verify that
SET_NR_COUNTERS fails with EBUSY once any vCPU has run.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 .../selftests/kvm/arm64/vpmu_counter_access.c      | 47 ++++++++++++++++++++--
 1 file changed, 43 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index 22223395969e..05135bcdb462 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -443,11 +443,10 @@ static void destroy_vpmu_vm(void)
 	kvm_vm_free(vpmu_vm.vm);
 }
 
-static void run_vcpu(struct kvm_vcpu *vcpu, u64 pmcr_n)
+static void run_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct ucall uc;
 
-	vcpu_args_set(vcpu, 1, pmcr_n);
 	vcpu_run(vcpu);
 	switch (get_ucall(vcpu, &uc)) {
 	case UCALL_ABORT:
@@ -461,6 +460,11 @@ static void run_vcpu(struct kvm_vcpu *vcpu, u64 pmcr_n)
 	}
 }
 
+static void guest_code_done(void)
+{
+	GUEST_DONE();
+}
+
 static void test_create_vpmu_vm_with_nr_counters(unsigned int nr_counters, bool expect_fail)
 {
 	struct kvm_vcpu *vcpu;
@@ -503,7 +507,8 @@ static void run_access_test(u64 pmcr_n)
 	/* Save the initial sp to restore them later to run the guest again */
 	sp = vcpu_get_reg(vcpu, ctxt_reg_alias(vcpu, SYS_SP_EL1));
 
-	run_vcpu(vcpu, pmcr_n);
+	vcpu_args_set(vcpu, 1, pmcr_n);
+	run_vcpu(vcpu);
 
 	/*
 	 * Reset and re-initialize the vCPU, and run the guest code again to
@@ -516,7 +521,8 @@ static void run_access_test(u64 pmcr_n)
 	vcpu_set_reg(vcpu, ctxt_reg_alias(vcpu, SYS_SP_EL1), sp);
 	vcpu_set_reg(vcpu, ARM64_CORE_REG(regs.pc), (u64)guest_code);
 
-	run_vcpu(vcpu, pmcr_n);
+	vcpu_args_set(vcpu, 1, pmcr_n);
+	run_vcpu(vcpu);
 
 	destroy_vpmu_vm();
 }
@@ -622,6 +628,37 @@ static bool kvm_supports_nr_counters_attr(void)
 	return supported;
 }
 
+static void test_set_nr_counters_after_vcpu_run(void)
+{
+	struct kvm_vcpu *running_vcpu, *stopped_vcpu;
+	unsigned int nr_counters = 0;
+	struct kvm_vcpu_init init;
+	struct kvm_vm *vm;
+	int ret;
+	u64 irq = 23;
+
+	vm = vm_create(2);
+	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init);
+	init.features[0] |= BIT(KVM_ARM_VCPU_PMU_V3);
+	running_vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code_done);
+	stopped_vcpu = aarch64_vcpu_add(vm, 1, &init, guest_code_done);
+	kvm_arch_vm_finalize_vcpus(vm);
+
+	vcpu_device_attr_set(running_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+			     KVM_ARM_VCPU_PMU_V3_IRQ, &irq);
+	vcpu_device_attr_set(running_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+			     KVM_ARM_VCPU_PMU_V3_INIT, NULL);
+	run_vcpu(running_vcpu);
+
+	ret = __vcpu_device_attr_set(stopped_vcpu, KVM_ARM_VCPU_PMU_V3_CTRL,
+				     KVM_ARM_VCPU_PMU_V3_SET_NR_COUNTERS,
+				     &nr_counters);
+	TEST_ASSERT(ret == -1 && errno == EBUSY,
+		    KVM_IOCTL_ERROR(KVM_SET_DEVICE_ATTR, ret));
+
+	kvm_vm_free(vm);
+}
+
 int main(void)
 {
 	u64 i, pmcr_n;
@@ -630,6 +667,8 @@ int main(void)
 	TEST_REQUIRE(kvm_supports_vgic_v3());
 	TEST_REQUIRE(kvm_supports_nr_counters_attr());
 
+	test_set_nr_counters_after_vcpu_run();
+
 	pmcr_n = get_pmcr_n_limit();
 	for (i = 0; i <= pmcr_n; i++) {
 		run_access_test(i);

-- 
2.55.0

