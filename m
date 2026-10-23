Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.150
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792738883;
	b=By/lNTb6lTDsiH4eJq+WLHqEwHbPMYQGr3d5CYvIjVkuF0V1QrNxNYjixGUSyyZz0lLd
	 q0JzANOaIGFA/yUCeJrXDfi1rsZfVmBA7tUdgxVMY39z0AS9yk5YC8N9ZTYP3IiTsxBX+
	 8ldFHmtuNzKY2gE4jDcn0FM+EzuFBt6tbB6dM6rF4sejqWTJbw9tgtTIOjqK81ZkBt7E9
	 UXdCwWCuTBcQEaqxNsM8TbUkQPXUcZwzdc0LSoBqr0lNZdP+oB2tw7CoGXM7SnIi7+MVz
	 1jBBcH3Sf5uCH1ta13YJk1/q0mKAzcAoj5WAvUUCoRud9DRDcvd/4N7rC3wGnmVmu2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792738883;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=rUCmr5KNsTqdAFtykuTtOHLJ0k3Z9x+lHOLfB29fVwI=;
	b=eJQ0kp+TMcuJvQEWU7OH7gTBKSV/4O6i3vG37FI4skUrhhvt/qavQj4a9mQBkvMwRAWU
	 cWe/9ALKm4sl/OOgF1LejtDbf1VZViAq79+qndiof8htMbbGvD1CLSXe2jOAc/am6sPFk
	 OMvr4f/s5SS1FtVOQUa8xTkhFrr2iWJkZbLlbng5RTCw/PZR0ocP0psnTZgdsSuL4SpXR
	 JkNOQVfpmrnVAtbUs7/PweaOWYeX2vHdV3Zy4IoFDOtjjYFITQcBqcjn+z2rUTyutAhnJ
	 nUndXtDvK0D7USkM/ZdGdT3TA3uwFC26kdP+ERvQDlfcXVJaD+aME41mGhdI48F/xNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PoDPze0g;
	arc=none smtp.remote-ip=91.218.175.150
Received: from mta0.migadu.com (out-150.mta0.migadu.com [91.218.175.150])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82C56606A329
	for <kvmarm@lists.linux.dev>; Fri, 23 Oct 2026 07:01:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82C56606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PoDPze0g
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=eS/K4doPXluNCr1/hI+pokpdsQChHXvBQQzirTFG9AU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792738880; v=1; x=1793343680;
 b=PoDPze0g8zldcDV/HwCZOP7leQ1N5HWH/s4sa6iVzVsq4qFzdk2aPNQUhUxkM9T2jSP/0sqF
 DFp0VlHtBj4Dmf6VS4BdkTlwGHc311NBy3LTU8q6fIhdEiPptBUulsjv6Rph9wgj1DItDStsN4Z
 1brxc9aLY/X/yxiwXDmAsyTY=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id 2ac626447dabcc43;
	Fri, 23 Oct 2026 07:01:20 +0000
X-Mizu-Trace-ID: 2ac626447dabcc43
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Cc: Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Yicong Yang <yangyicong@hisilicon.com>,
	Zhou Wang <wangzhou1@hisilicon.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Fuad Tabba <tabba@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: arm64: selftests: Test ID_AA64ISAR1_EL1.LS64 on its own
Date: Fri, 23 Oct 2026 08:01:10 +0100
Message-ID: <20261023070110.1833446-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261023070110.1833446-1-fuad.tabba@linux.dev>
References: <20261023070110.1833446-1-fuad.tabba@linux.dev>
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

KVM caps ID_AA64ISAR1_EL1.LS64 at LS64_V, but accepts a write of any
level up to the host's and caps it. On a host at LS64_ACCDATA or above,
the generic test writes the level above KVM's value and expects it to
be rejected, but KVM accepts it.

Move LS64 out of the generic table into its own test. It checks that the
field reads as the host's level capped at LS64_V, that a write of 0 is
kept and one of the host's level is capped, and that a level above the
host's is rejected.

Cc: stable@vger.kernel.org
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 .../testing/selftests/kvm/arm64/set_id_regs.c | 49 ++++++++++++++++++-
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/set_id_regs.c b/tools/testing/selftests/kvm/arm64/set_id_regs.c
index 7429a1055df56..60b96f7608dc3 100644
--- a/tools/testing/selftests/kvm/arm64/set_id_regs.c
+++ b/tools/testing/selftests/kvm/arm64/set_id_regs.c
@@ -108,7 +108,6 @@ static const struct reg_ftr_bits ftr_id_aa64isar0_el1[] = {
 };
 
 static const struct reg_ftr_bits ftr_id_aa64isar1_el1[] = {
-	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR1_EL1, LS64, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR1_EL1, XS, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR1_EL1, I8MM, 0),
 	REG_FTR_BITS(FTR_LOWER_SAFE, ID_AA64ISAR1_EL1, DGH, 0),
@@ -644,6 +643,51 @@ static void test_user_set_mte_reg(struct kvm_vcpu *vcpu)
 		ksft_test_result_pass("ID_AA64PFR1_EL1.MTE_frac no longer 0xF\n");
 }
 
+#define LS64_IDREG_TEST 4
+static void test_user_set_ls64_reg(struct kvm_vcpu *vcpu)
+{
+	u64 reg = KVM_ARM64_SYS_REG(SYS_ID_AA64ISAR1_EL1);
+	u64 val, ls64, host, limit;
+	int err;
+
+	/* LS64 is visible to EL0, so this reads the host's sanitised level */
+	host = FIELD_GET(ID_AA64ISAR1_EL1_LS64, read_sysreg(id_aa64isar1_el1));
+	limit = min(host, ID_AA64ISAR1_EL1_LS64_LS64_V);
+
+	val = vcpu_get_reg(vcpu, reg);
+	ls64 = FIELD_GET(ID_AA64ISAR1_EL1_LS64, val);
+	if (ls64 == limit)
+		ksft_test_result_pass("ID_AA64ISAR1_EL1.LS64=%lu, host at %lu\n", ls64, host);
+	else
+		ksft_test_result_fail("ID_AA64ISAR1_EL1.LS64=%lu, host at %lu\n", ls64, host);
+
+	val &= ~ID_AA64ISAR1_EL1_LS64_MASK;
+	err = __vcpu_set_reg(vcpu, reg, val);
+	ls64 = FIELD_GET(ID_AA64ISAR1_EL1_LS64, vcpu_get_reg(vcpu, reg));
+	if (!err && !ls64)
+		ksft_test_result_pass("ID_AA64ISAR1_EL1.LS64=0 accepted\n");
+	else
+		ksft_test_result_fail("ID_AA64ISAR1_EL1.LS64=0: err %d, reads %lu\n", err, ls64);
+
+	/*
+	 * A VM saved on an older kernel carries the host's level, which KVM
+	 * must accept from the VMM but keep at the limit.
+	 */
+	err = __vcpu_set_reg(vcpu, reg, val | FIELD_PREP(ID_AA64ISAR1_EL1_LS64_MASK, host));
+	ls64 = FIELD_GET(ID_AA64ISAR1_EL1_LS64, vcpu_get_reg(vcpu, reg));
+	if (!err && ls64 == limit)
+		ksft_test_result_pass("ID_AA64ISAR1_EL1.LS64=%lu accepted as %lu\n", host, ls64);
+	else
+		ksft_test_result_fail("ID_AA64ISAR1_EL1.LS64=%lu: err %d, reads %lu\n",
+				      host, err, ls64);
+
+	err = __vcpu_set_reg(vcpu, reg, val | FIELD_PREP(ID_AA64ISAR1_EL1_LS64_MASK, host + 1));
+	if (err && errno == EINVAL)
+		ksft_test_result_pass("ID_AA64ISAR1_EL1.LS64=%lu rejected\n", host + 1);
+	else
+		ksft_test_result_fail("ID_AA64ISAR1_EL1.LS64=%lu not rejected\n", host + 1);
+}
+
 static u64 reset_mutable_bits(u32 id, u64 val)
 {
 	struct test_feature_reg *reg = NULL;
@@ -828,7 +872,7 @@ int main(void)
 
 	ksft_print_header();
 
-	test_cnt = 3 + MPAM_IDREG_TEST + MTE_IDREG_TEST;
+	test_cnt = 3 + MPAM_IDREG_TEST + MTE_IDREG_TEST + LS64_IDREG_TEST;
 	for (i = 0; i < ARRAY_SIZE(test_regs); i++)
 		for (j = 0; test_regs[i].ftr_bits[j].type != FTR_END; j++)
 			test_cnt++;
@@ -840,6 +884,7 @@ int main(void)
 	test_vcpu_non_ftr_id_regs(vcpu);
 	test_user_set_mpam_reg(vcpu);
 	test_user_set_mte_reg(vcpu);
+	test_user_set_ls64_reg(vcpu);
 
 	test_guest_reg_read(vcpu);
 
-- 
2.47.3

