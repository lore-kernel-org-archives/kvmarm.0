Received: from mta0.migadu.com (out-27.mta0.migadu.com [91.218.175.27])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02901472F73
	for <kvmarm@lists.linux.dev>; Mon, 14 Sep 2026 12:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.27
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390717; cv=none; b=M46CP8/i2VaRgmsGBjem/FFoJVPhrxCmf9BTC29cl1NJRJLSCmdNLHgvqIgwN8hjFqhRnO6RkTVRtengnXVBFAvy5rL1w155JhSBUcxGitUezrggT6x/gHIWGu12a5JQe0KvmDYpEZZEq6doe86ap551zBzoqiKBTNIJTNA7L80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390717; c=relaxed/simple;
	bh=vVA+BcQVTE6b1DspVs3rDyX78CT3oRsosEdsCjY+fSM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iWYrj1VAzZVMGgxi5A8U1U2EmqRT51ED7ArnorAagj9aqcZ/SqmbipEQfRd4v0oSA0j/pvW5L5+W1vyS2oHUFy/1w4dLNyX+5cSx5+Ommnln+gud4Vo33EOGOrIuYdB2tNY6Qjwq0IbHB3/+Xm8MAQRZsnKYMCe7TOjnOJ9+Ubs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=bMm8RZpy; arc=none smtp.client-ip=91.218.175.27
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="bMm8RZpy"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=vVA+BcQVTE6b1DspVs3rDyX78CT3oRsosEdsCjY+fSM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789390712; v=1; x=1789995512;
 b=bMm8RZpyG5HUw2c0hDDsEwsGZp89eesx3rT4XUViMWRnGGz7GGJ9ihYTya34RMCfImzJ8GIp
 AmRSO2vYapdunMSFkNGnyw4L2sWKyhyZbdpD4N1NmYzYQGXbD0+6aC6hzXeNtvu0O9CDCSNAjmI
 wL/v0KyVzbZZoj8Jy2Ja7+m8=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id fe0470a03d8b6acf;
	Mon, 14 Sep 2026 12:58:32 +0000
X-Mizu-Trace-ID: fe0470a03d8b6acf
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>,
	Fuad Tabba <tabba@google.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] KVM: arm64: selftests: Check the mandatory SMCCC_ARCH_FEATURES queries
Date: Mon, 14 Sep 2026 13:58:27 +0100
Message-Id: <20260914125827.1645980-2-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260914125827.1645980-1-fuad.tabba@linux.dev>
References: <20260914125827.1645980-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

tools/testing/selftests/kvm/arm64/hypercalls.c checks SMCCC_ARCH_FEATURES
with two expectations: hvc_info[] expects NOT_SUPPORTED with the
pseudo-firmware bitmaps cleared and something else with them set, and
false_hvc_info[] expects NOT_SUPPORTED for mismatched pairs. DEN0028H
7.3.6 mandates SUCCESS for arch_func_id SMCCC_VERSION and
SMCCC_ARCH_FEATURES itself, whatever the bitmaps hold, which neither
expectation allows.

Check those two in the feature-disabled and feature-enabled stages, so
the answer is asserted with the bitmaps cleared and again at their reset
values. They pass only with the preceding patch applied.

Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 .../testing/selftests/kvm/arm64/hypercalls.c  | 27 ++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/arm64/hypercalls.c b/tools/testing/selftests/kvm/arm64/hypercalls.c
index 5d96cdf382c47..e74410cef0fe0 100644
--- a/tools/testing/selftests/kvm/arm64/hypercalls.c
+++ b/tools/testing/selftests/kvm/arm64/hypercalls.c
@@ -6,7 +6,8 @@
  * via the psuedo-firmware bitmap register. This includes the registers'
  * read/write behavior before and after the VM has started, and if the
  * hypercalls are properly masked or unmasked to the guest when disabled or
- * enabled from the KVM userspace, respectively.
+ * enabled from the KVM userspace, respectively. It also checks the two
+ * SMCCC_ARCH_FEATURES queries whose answer SMCCC pins to SUCCESS.
  */
 #include <errno.h>
 #include <linux/arm-smccc.h>
@@ -97,6 +98,12 @@ static const struct test_hvc_info false_hvc_info[] = {
 	TEST_HVC_INFO(ARM_SMCCC_HV_PV_TIME_FEATURES, ARM_SMCCC_TRNG_RND64),
 };
 
+/* SMCCC pins the answer to SUCCESS, whatever the bitmaps hold. */
+static const struct test_hvc_info always_hvc_info[] = {
+	TEST_HVC_INFO(ARM_SMCCC_ARCH_FEATURES_FUNC_ID, ARM_SMCCC_VERSION_FUNC_ID),
+	TEST_HVC_INFO(ARM_SMCCC_ARCH_FEATURES_FUNC_ID, ARM_SMCCC_ARCH_FEATURES_FUNC_ID),
+};
+
 static void guest_test_hvc(const struct test_hvc_info *hc_info)
 {
 	unsigned int i;
@@ -128,6 +135,23 @@ static void guest_test_hvc(const struct test_hvc_info *hc_info)
 	}
 }
 
+static void guest_test_always_hvc(void)
+{
+	struct arm_smccc_res res;
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(always_hvc_info); i++) {
+		memset(&res, 0, sizeof(res));
+		do_smccc(always_hvc_info[i].func_id, always_hvc_info[i].arg1,
+			 0, 0, 0, 0, 0, 0, &res);
+
+		__GUEST_ASSERT(res.a0 == SMCCC_RET_SUCCESS,
+			       "a0 = 0x%lx, func_id = 0x%x, arg1 = 0x%lx, stage = %u",
+			       res.a0, always_hvc_info[i].func_id,
+			       always_hvc_info[i].arg1, stage);
+	}
+}
+
 static void guest_code(void)
 {
 	while (stage != TEST_STAGE_END) {
@@ -137,6 +161,7 @@ static void guest_code(void)
 		case TEST_STAGE_HVC_IFACE_FEAT_DISABLED:
 		case TEST_STAGE_HVC_IFACE_FEAT_ENABLED:
 			guest_test_hvc(hvc_info);
+			guest_test_always_hvc();
 			break;
 		case TEST_STAGE_HVC_IFACE_FALSE_INFO:
 			guest_test_hvc(false_hvc_info);
-- 
2.39.5

