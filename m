Received: from www3579.sakura.ne.jp (www3579.sakura.ne.jp [49.212.243.89])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28343409283
	for <kvmarm@lists.linux.dev>; Fri, 10 Jul 2026 11:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=49.212.243.89
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783682170; cv=none; b=GtYELHMi/qTNvaf2lS3R6bKC1lSkFR5xb1XrV56VeX4v7YqHyrh6bUANqwgGWL+8C/AyIrs1L+HqlYTriN8sI6LriPaw+lAwYwu15J03ytQNiFNVAQ9u0CyuDwRMhMURBicAgYaTGLDa8ZNKibyYthGBy5Qei8et/CU28SQP+NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783682170; c=relaxed/simple;
	bh=U9MEpE2Ih98r0rKIS5ukgUhQF9OCUYmg2BREdlUGgos=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=bLOhFFkpX4B5tRsHVaWLVnom1iop98mj/WYIvq/WMCpsjrBzkw1Yw7UsxL7isIv1E3nKDdDJ7kHu+S/nfj1sbgqKK/cuhjmz2IbBluFDnVzs5AzYvsSj7slgrhPMcNm+NxHNx15QCbZG44g+jR02CShOgimQv3NDDo4mhOaqGn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp; dkim=fail (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b=mZ/mHjw+ reason="key not found in DNS"; arc=none smtp.client-ip=49.212.243.89
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=rsg.ci.i.u-tokyo.ac.jp
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=rsg.ci.i.u-tokyo.ac.jp header.i=@rsg.ci.i.u-tokyo.ac.jp header.b="mZ/mHjw+"
Received: from h183.csg.ci.i.u-tokyo.ac.jp (h183.csg.ci.i.u-tokyo.ac.jp [133.11.54.183])
	(authenticated bits=0)
	by www3579.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 66ABEvsH024946
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Fri, 10 Jul 2026 20:15:10 +0900 (JST)
	(envelope-from odaki@rsg.ci.i.u-tokyo.ac.jp)
DKIM-Signature: a=rsa-sha256; bh=uYrOcz7cPsXjyBNdYSNHFBXBQv6JgbTYi8PN49aaXZ8=;
        c=relaxed/relaxed; d=rsg.ci.i.u-tokyo.ac.jp;
        h=From:Message-Id:To:Subject:Date;
        s=rs20250326; t=1783682110; v=1;
        b=mZ/mHjw+q5qmL6SJzncK0NvUHK9WAcp5mzhrd+351BTQ3OTW9tPlk8hESlrpH9eu
         WvTo7LkX++pgZuuMDnEmALooMjv0hO0A04LoqC/4A3otIkV07uAY+XjdwAoPWgGo
         yRUSqXk9XRdEfnmK9P3Fq5GSlCllRghQ1G5NsSpAEyEZ6hRnEBSzzBLdG34xVVFt
         EDKMRxkTq9HDwrSCgmnAOxifIua5gxb1wZW+JboMnZ3aEZM5fulciA4NnS31W//E
         UV9bw192xIrz4ExCj/R89VqKrh9460iRgoZ38dANsub5tnHciSEnJwPXS5LkDLAi
         OkRtOUVpJwByY1bh9TdNpA==
From: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
Date: Fri, 10 Jul 2026 20:14:57 +0900
Subject: [PATCH v8 03/11] KVM: arm64: selftests: Cover PMU state in
 MDCR_EL2
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-hybrid-v8-3-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
References: <20260710-hybrid-v8-0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
In-Reply-To: <20260710-hybrid-v8-0-621409f3a592@rsg.ci.i.u-tokyo.ac.jp>
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
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
        devel@daynix.com, kvm@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
X-Mailer: b4 0.16-dev-925f5
X-Developer-Signature: v=1; a=openpgp-sha256; l=4101;
 i=odaki@rsg.ci.i.u-tokyo.ac.jp; h=from:subject:message-id;
 bh=U9MEpE2Ih98r0rKIS5ukgUhQF9OCUYmg2BREdlUGgos=;
 b=owGbwMvMwCWmMbc20y1CyJDxtFoSQ1bAFdOoCdslkj9tDK85mGkeprzlWJKYd6tsW/56hf+r2
 KNM+uZ2lLIwiHExyIopsqQU7ebWiK79VJgQ3wIzh5UJZAgDF6cATORBAiPD4fz/qRuFXrndFrHc
 6Tv74rv96UenzKrcc69SWX9L16LQcwz//Ts3vivq/XrNsfHy8XrPi112U4xuZvXquH6r6vTXVrz
 DAgA=
X-Developer-Key: i=odaki@rsg.ci.i.u-tokyo.ac.jp; a=openpgp;
 fpr=AEDC03C9AF734F2EC26A7BFFA4BAEAA73536753C

Add MDCR_EL2 coverage to vpmu_counter_access when EL2 is available.

For each configured PMCR_EL0.N value, verify that HPMN tracks the
configured counter count, HPME can be toggled without disturbing HPMN,
and KVM_SET_ONE_REG rejects an out-of-range HPMN without changing
MDCR_EL2. Reset the vCPU and verify that HPMN is restored from the
configured count.

Assisted-by: Codex:gpt-5.5
Signed-off-by: Akihiko Odaki <odaki@rsg.ci.i.u-tokyo.ac.jp>
---
 .../selftests/kvm/arm64/vpmu_counter_access.c      | 76 ++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c b/tools/testing/selftests/kvm/arm64/vpmu_counter_access.c
index 22223395969e..25203ea117b0 100644
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
@@ -583,6 +591,73 @@ static void run_pmregs_validity_test(u64 pmcr_n)
 	destroy_vpmu_vm();
 }
 
+static void run_mdcr_el2_validity_test(u64 pmcr_n)
+{
+	struct kvm_vcpu_init init;
+	struct kvm_vcpu *vcpu;
+	u64 mdcr, old_mdcr;
+	int ret;
+
+	pr_debug("MDCR_EL2 test with pmcr_n %lu\n", pmcr_n);
+
+	test_create_vpmu_vm_with_nr_counters(pmcr_n, false);
+	if (!vm_supports_el2(vpmu_vm.vm)) {
+		destroy_vpmu_vm();
+		return;
+	}
+
+	vcpu = vpmu_vm.vcpu;
+
+	mdcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2));
+	TEST_ASSERT(FIELD_GET(MDCR_EL2_HPMN, mdcr) == pmcr_n,
+		    "MDCR_EL2.HPMN is not updated after PMU_V3_SET_NR_COUNTERS (expected %lu, got %lu)",
+		    pmcr_n, FIELD_GET(MDCR_EL2_HPMN, mdcr));
+
+	old_mdcr = mdcr;
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2),
+		     old_mdcr ^ MDCR_EL2_HPME);
+
+	mdcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2));
+	TEST_ASSERT(mdcr == (old_mdcr ^ MDCR_EL2_HPME),
+		    "MDCR_EL2 was not properly updated after HPME write (expected 0x%lx, got 0x%lx)",
+		    old_mdcr ^ MDCR_EL2_HPME, mdcr);
+
+	if (pmcr_n < FIELD_MAX(MDCR_EL2_HPMN)) {
+		errno = 0;
+		old_mdcr = mdcr;
+		ret = __vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2),
+				     u64_replace_bits(mdcr, pmcr_n + 1, MDCR_EL2_HPMN));
+		TEST_ASSERT(ret == -1 && errno == EINVAL,
+			    "Setting MDCR_EL2.HPMN to %lu unexpectedly succeeded",
+			    pmcr_n + 1);
+
+		mdcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2));
+		TEST_ASSERT(mdcr == old_mdcr,
+			    "MDCR_EL2 changed after failed HPMN write (expected 0x%lx, got 0x%lx)",
+			    old_mdcr, mdcr);
+	}
+
+	old_mdcr = mdcr;
+	vcpu_set_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2),
+		     u64_replace_bits(mdcr, 0, MDCR_EL2_HPMN));
+
+	mdcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2));
+	TEST_ASSERT(mdcr == u64_replace_bits(old_mdcr, 0, MDCR_EL2_HPMN),
+		    "MDCR_EL2 was not properly updated after HPMN write (expected 0x%lx, got 0x%lx)",
+		    u64_replace_bits(old_mdcr, 0, MDCR_EL2_HPMN), mdcr);
+
+	kvm_get_default_vcpu_target(vpmu_vm.vm, &init);
+	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
+	aarch64_vcpu_setup(vcpu, &init);
+
+	mdcr = vcpu_get_reg(vcpu, KVM_ARM64_SYS_REG(SYS_MDCR_EL2));
+	TEST_ASSERT(FIELD_GET(MDCR_EL2_HPMN, mdcr) == pmcr_n,
+		    "MDCR_EL2.HPMN is not updated after INIT (expected %lu, got %lu)",
+		    pmcr_n, FIELD_GET(MDCR_EL2_HPMN, mdcr));
+
+	destroy_vpmu_vm();
+}
+
 /*
  * Create a guest with one vCPU, and attempt to set the PMCR_EL0.N for
  * the vCPU to @pmcr_n, which is larger than the host value.
@@ -634,6 +709,7 @@ int main(void)
 	for (i = 0; i <= pmcr_n; i++) {
 		run_access_test(i);
 		run_pmregs_validity_test(i);
+		run_mdcr_el2_validity_test(i);
 	}
 
 	for (i = pmcr_n + 1; i < ARMV8_PMU_MAX_COUNTERS; i++)

-- 
2.55.0

