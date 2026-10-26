Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792977692;
	b=PwswJvr0NhJIeIn/vz/KranZoLwZZbuXsZjGSwvnSrGw7I7uFhMkapR1+ZuOvLzH3vab
	 KKjcafat5HdC2vaZX4GWcYPFDNo57etrrH5ULxsEekJDBrpSGCA4f2Zt5XEwrzQfArr4v
	 lzqz4bUWw2kD7bgNV1qSkuPfAPLvWsGrOHR+r/h93uVqsG6jpC6adh9A84y2UR8k7R54O
	 qigoKNSw4FmeFyhte20ATmER+eefOZO89FNllsibAi04vsMfna1w1YvKtGTEsujMh7YK5
	 I2HQq3oszfooFVEGjA8N5l89ekle7uC/RPb5fp0idl0UdjrBu5jbch5OEAhHCWIkXEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792977692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C5ioxP7uY30s85vV8DwHkSdiepRHIKFRzyzh0pLyvrQ=;
	b=xMaC5EGF1JkvdEufvnl86L8uj5WzFTyhsj/cDQE2NlRMiMNQjry/vzHnZWsPIzatHcX6
	 ph01Vj8eK/dq24mTqH5SKzFfVs0uChLrzyEfseQa/BHYMc2+Ck4PzXPzBC4Ql42taGLJ9
	 i3Ix346Gh+RWWxmvZzUe1ybOLvJJHq1R6bseaXGp6uL3YxpEIV1KKkQTwMJabxD+vOChS
	 Vv5+hNAxCLb01afXfXtR2klEehOqOrR4bmRbqKc6Dsk7aq/g0BATZLKCmR3FSPTjGLZMx
	 fzde7eXtwO2fyGCgzZdfEjdODab+TMpJBmU6/+xYeGMJk9vQeLNFQNOAkqSPog294vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V1DqB3pb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1860D606A31A;
	Mon, 26 Oct 2026 01:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=V1DqB3pb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6BEC1F01825;
	Mon, 26 Oct 2026 01:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792977691;
	bh=C5ioxP7uY30s85vV8DwHkSdiepRHIKFRzyzh0pLyvrQ=;
	h=From:To:Cc:Subject:Date;
	b=V1DqB3pbxP7rI9SN1R43pBQWTS3C67zUkKSoznsjQEqKyNtm8D6VseVMV4dlPp+Yj
	 vUfWs8GRNk8VeYo1YsHqRQb/2GPMcudOZ/dSNZw7amrf+fH7BeRNCYHSmgbGXMfawP
	 N2BBF1UKzjie0mK5a3YE7Wc1wUe3aLXW1ArWK9O4MAKNaqX4o3XUbCPiZ/6NVVainY
	 2ZqMA2i5RDZOCzcWFB6DhMgVp9FjqoQBzYu0jUuQYzuHEYDYGRcicx7C2vXRn8lpST
	 4RO/SjJB9dhvFteWGILoKpABngLxeW43OkAEphOc7N6fnhgx3l9heeD2DCL2ikPWsN
	 q0ZeSD33q5Sdg==
From: Sasha Levin <sashal@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Shuah Khan <shuah@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Itaru Kitayama <itaru.kitayama@fujitsu.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] KVM: arm64: selftests: Skip unwritable ID fields in the failed-run test
Date: Sun, 25 Oct 2026 21:21:28 -0400
Message-ID: <20261026012128.2270251-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

test_idreg_frozen_after_failed_run() checks that changing a feature ID
register after a failed first KVM_RUN is rejected with -EBUSY, and does
so for every field of every register in test_regs.

On a host without AArch32 support at EL0, KVM treats the AArch32 ID
registers as RAZ/WI: aa32_id_visibility() returns REG_RAZ | REG_USER_WI,
and kvm_sys_reg_set_user() ignores the write and returns 0 before
set_id_reg() checks whether the ID registers are final. The test then
fails on the first such register:

  arm64/set_id_regs.c:870: r < 0 && errno == EBUSY
  ID_DFR0_EL1_PerfMon write after failed first run: r=0 errno=16

KernelCI hits this on every run on an AArch64 only GB300 host.

Only a field that userspace can change can be frozen, and KVM reports
these registers as not writable in KVM_ARM_GET_REG_WRITABLE_MASKS. Skip
the fields that the writable mask does not cover. test_vm_ftr_id_regs()
already requires the mask to cover every other field in test_regs, so
this only drops the fields KVM never lets userspace change. Whether KVM
accepts writes to fields it reports as not writable is a separate
question from finalization.

Fixes: 00e309933879 ("KVM: arm64: selftests: Check ID regs are immutable after a failed run")
Link: https://d.kernelci.org/test/maestro:6adcad0c55fda50760800a00
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
Changes in v2:
- Skip every field that KVM_ARM_GET_REG_WRITABLE_MASKS does not report as
  writable, instead of special casing the AArch32 ID registers (Mark Brown).

v1: https://lore.kernel.org/all/20261024161118.1007472-1-sashal@kernel.org/

 tools/testing/selftests/kvm/arm64/set_id_regs.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 10849d21c0dd2..1d2cc25cb3f4c 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -815,6 +815,10 @@ static void test_idreg_frozen_after_failed_run(void)
 		SYS_REVIDR_EL1,
 		SYS_AIDR_EL1,
 	};
+	u64 masks[KVM_ARM_FEATURE_ID_RANGE_SIZE];
+	struct reg_mask_range range = {
+		.addr = (__u64)masks,
+	};
 	struct kvm_vcpu_init init;
 	struct kvm_vcpu *vcpu;
 	struct kvm_vm *vm;
@@ -831,6 +835,7 @@ static void test_idreg_frozen_after_failed_run(void)
 
 	vm = vm_create(1);
 	vm_enable_cap(vm, KVM_CAP_ARM_WRITABLE_IMP_ID_REGS, 0);
+	vm_ioctl(vm, KVM_ARM_GET_REG_WRITABLE_MASKS, &range);
 	kvm_get_default_vcpu_target(vm, &init);
 	init.features[0] |= (1 << KVM_ARM_VCPU_PMU_V3);
 	vcpu = aarch64_vcpu_add(vm, 0, &init, guest_code);
@@ -852,7 +857,9 @@ static void test_idreg_frozen_after_failed_run(void)
 	 */
 	for (int i = 0; i < ARRAY_SIZE(test_regs); i++) {
 		const struct reg_ftr_bits *ftr_bits = test_regs[i].ftr_bits;
-		u64 reg = KVM_ARM64_SYS_REG(test_regs[i].reg);
+		u32 reg_id = test_regs[i].reg;
+		u64 reg = KVM_ARM64_SYS_REG(reg_id);
+		u64 mask = masks[encoding_to_range_idx(reg_id)];
 		u64 val = vcpu_get_reg(vcpu, reg);
 
 		for (int j = 0; ftr_bits[j].type != FTR_END; j++) {
@@ -860,6 +867,10 @@ static void test_idreg_frozen_after_failed_run(void)
 			u64 safe = get_safe_value(&ftr_bits[j], ftr);
 			u64 new_val;
 
+			/* Only a field userspace could change can be frozen. */
+			if ((mask & ftr_bits[j].mask) != ftr_bits[j].mask)
+				continue;
+
 			if (safe == ftr)
 				continue;
 

base-commit: 21a7f44fd0765fcc5194130b28767786eba1d1e7
-- 
2.53.0

