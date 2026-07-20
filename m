Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84F7F3A9870
	for <kvmarm@lists.linux.dev>; Mon, 20 Jul 2026 05:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784526238; cv=none; b=nfuJ/ywJOIh8QFIxxHAwIPtBdWgrLxlBAkogWLd/BCNjd8cSAfm+u1fgCR6ZftPsRwOKIcmb0Opyz0L74VpKHvpwMpnz1Nf7LH9KW5ez+TUtz24ZkYnf+GV1xQQIc4+QgRCzh67aYx2unNmoIlxJlrHN+/D0jHN/kghzd+DDMt4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784526238; c=relaxed/simple;
	bh=BBucYUZX8Oc0BbLNMW6+Moe/S16AQy1iES1ROmKJY08=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=p2lDadM8ZzVaIVh0pPFHJP67PSqurNFffGcW3aVD+AKUQOJB0phflO4+g9Zz1ERGA+2QARD4bnyW40hXTdCHz7bCC20M36B3VeTp9UQ7HMO0oENsLT5p+3IF103vuN5/iJMDmHARnMm2aSc23GUsOu7MDwH60AxVpKiVB1Fqc0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=VRFSVgfu reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="VRFSVgfu"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66K5c7om075973
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Mon, 20 Jul 2026 14:38:26 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=KpB6X7mai5xhV0NQDiFgu0TlCfG7qzHiZetXWMkwXj8=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1784525906; v=1;
        b=VRFSVgfuDBUuzl46mrVXSkdUt/QVcXmSxeYj6ooPaG7UUl7t7g4pH+Haj+rIlZON
         4iyeSpzYZIqOEtfzo16vw4IBD0mkG2T1VTuCbtYlIVgywykpAO+SqwqpBRT3q8Hb
         HASHNq3hiQNrs7FfQoBA3edbe7CmQxUYFd+y94xYnv0IgYTgnSPRtntikLGkMs+i
         uVnQx7lZQBp4OYxJiIw/a9O+4YK0nZaI+TkNWOAQMpRvSyUjPJHwCdlD0rP42LDN
         cTLYXwgfuG6VoE1H3N18aGNJu6mjoht3BQak3iISV+Yp3peIlz7LYHTu73USooNJ
         IzCUbviI5gY8ObXp+81Z/A==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Mon, 20 Jul 2026 14:37:58 +0900
Subject: [PATCH v9 04/16] KVM: arm64: selftests: Test SET_NR_COUNTERS after
 first run
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-hybrid-v9-4-2b713ca1b5dc@rsg.ci.i.u-tokyo.ac.jp>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2438;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=BBucYUZX8Oc0BbLNMW6+Moe/S16AQy1iES1ROmKJY08=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ1bsFtdpMrefTNexDn347KXQ5IZ122eIOZhOvpOvfVc6f
 G/eVPG9HaUsDGJcDLJiiiwpRbu5NaJrPxUmxLfAzGFlAhnCwMUpABPR6GJkWCGtMePinozcHy2M
 XFwHPZJcMjpX2Wxf1cT77ULplvZnagz/U9sX+hZq8Wge05APa1o4l8m/vjNfyuxcraSB8c4HDbt
 4AQ==
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

Add a regression test that runs one vCPU and then tries to change the
VM-scoped PMU counter count through an idle sibling. Verify that
SET_NR_COUNTERS fails with EBUSY once any vCPU has run.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 .../selftests/kvm/arm64/vpmu_counter_access.c      | 38 ++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index 22223395969e..3b5bb421f401 100644
--- a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
+++ b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
@@ -461,6 +461,11 @@ static void run_vcpu(struct kvm_vcpu *vcpu, u64 pmcr_n)
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
@@ -622,6 +627,37 @@ static bool kvm_supports_nr_counters_attr(void)
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
+	vcpu_run(running_vcpu);
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
@@ -630,6 +666,8 @@ int main(void)
 	TEST_REQUIRE(kvm_supports_vgic_v3());
 	TEST_REQUIRE(kvm_supports_nr_counters_attr());
 
+	test_set_nr_counters_after_vcpu_run();
+
 	pmcr_n = get_pmcr_n_limit();
 	for (i = 0; i <= pmcr_n; i++) {
 		run_access_test(i);

-- 
2.55.0

