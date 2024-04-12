Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8F792446AE;
	Fri, 12 Apr 2024 10:34:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712918091; cv=none; b=mcJMktuxzzxBHtY8Z1vhEfUvIGv5X4D/stMejdrPvG0dOTtnXt4RRpffomN6mjfF/fDnaxp6OoVlKu4nBg/8k1Up3TOHznHuy0+e38OdWtQCgw0u1G7SFuBA4kNJlkhD8MXJUIbiCRgXcSP0wgtJDDfjxtq3yQRwr1h28N3Ipn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712918091; c=relaxed/simple;
	bh=xKyOC9fn7nCYkw8lmsbXFRgExMeFhzgxSZNTu5Y0XRQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OyGUuyzzc7IQY4dqQL6LJ3inSH/Fhd2qZJtwt9VOr9YSRx3MMFC8CPkvtcOuVxfKIT+PttJhNOs0qJbIH/oRNx44MKycRCdYHulNKEQ0acucUqa1Nlj7ipKlmK56pAhFxu4CXO+1qn/VmVdbQRqGhEQrVZanrg6qB3r8AHWTClI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7BEA8113E;
	Fri, 12 Apr 2024 03:35:18 -0700 (PDT)
Received: from ewhatever.cambridge.arm.com (ewhatever.cambridge.arm.com [10.1.197.1])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 6B4763F64C;
	Fri, 12 Apr 2024 03:34:47 -0700 (PDT)
From: Suzuki K Poulose <suzuki.poulose@arm.com>
To: kvmarm@lists.linux.dev
Cc: kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	maz@kernel.org,
	alexandru.elisei@arm.com,
	joey.gouly@arm.com,
	steven.price@arm.com,
	james.morse@arm.com,
	oliver.upton@linux.dev,
	yuzenghui@huawei.com,
	andrew.jones@linux.dev,
	eric.auger@redhat.com,
	Gareth Stockwell <gareth.stockwell@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [kvm-unit-tests PATCH 15/33] arm: realm: add hvc and RSI_HOST_CALL tests
Date: Fri, 12 Apr 2024 11:33:50 +0100
Message-Id: <20240412103408.2706058-16-suzuki.poulose@arm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240412103408.2706058-1-suzuki.poulose@arm.com>
References: <20240412103408.2706058-1-suzuki.poulose@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Gareth Stockwell <gareth.stockwell@arm.com>

Test that a HVC instruction in a Realm is turned into an undefined exception.

Test that RSI_HOST_CALL passes through to the Hypervisor.

Signed-off-by: Gareth Stockwell <gareth.stockwell@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
---
 arm/realm-rsi.c   | 110 +++++++++++++++++++++++++++++++++++++++++++++-
 arm/unittests.cfg |  15 +++++++
 2 files changed, 124 insertions(+), 1 deletion(-)

diff --git a/arm/realm-rsi.c b/arm/realm-rsi.c
index 6c228e42..5b90a343 100644
--- a/arm/realm-rsi.c
+++ b/arm/realm-rsi.c
@@ -14,6 +14,96 @@
 #include <asm/pgtable.h>
 #include <asm/processor.h>
 
+#define FID_SMCCC_VERSION	0x80000000
+#define FID_INVALID		0xc5000041
+
+#define SMCCC_VERSION_1_1	0x10001
+#define SMCCC_SUCCESS		0
+#define SMCCC_NOT_SUPPORTED	-1
+
+static bool unknown_taken;
+
+static void unknown_handler(struct pt_regs *regs, unsigned int esr)
+{
+	report_info("unknown_handler: esr=0x%x", esr);
+	unknown_taken = true;
+}
+
+static void hvc_call(unsigned int fid)
+{
+	struct smccc_result res;
+
+	unknown_taken = false;
+	arm_smccc_hvc(fid, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, &res);
+
+	if (unknown_taken) {
+		report(true, "FID=0x%x caused Unknown exception", fid);
+	} else {
+		report(false, "FID=0x%x did not cause Unknown exception", fid);
+		report_info("x0:  0x%lx", res.r0);
+		report_info("x1:  0x%lx", res.r1);
+		report_info("x2:  0x%lx", res.r2);
+		report_info("x3:  0x%lx", res.r3);
+		report_info("x4:  0x%lx", res.r4);
+		report_info("x5:  0x%lx", res.r5);
+		report_info("x6:  0x%lx", res.r6);
+		report_info("x7:  0x%lx", res.r7);
+	}
+}
+
+static void rsi_test_hvc(void)
+{
+	report_prefix_push("hvc");
+
+	/* Test that HVC causes Undefined exception, regardless of FID */
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, unknown_handler);
+	hvc_call(FID_SMCCC_VERSION);
+	hvc_call(FID_INVALID);
+	install_exception_handler(EL1H_SYNC, ESR_EL1_EC_UNKNOWN, NULL);
+
+	report_prefix_pop();
+}
+
+static void host_call(unsigned int fid, unsigned long expected_x0)
+{
+	struct smccc_result res;
+	struct rsi_host_call __attribute__((aligned(256))) host_call_data = { 0 };
+
+	host_call_data.gprs[0] = fid;
+
+	arm_smccc_smc(SMC_RSI_HOST_CALL, virt_to_phys(&host_call_data),
+		       0, 0, 0, 0, 0, 0, 0, 0, 0, 0, &res);
+
+	if (res.r0) {
+		report(false, "RSI_HOST_CALL returned 0x%lx", res.r0);
+	} else {
+		if (host_call_data.gprs[0] == expected_x0) {
+			report(true, "FID=0x%x x0=0x%lx",
+				fid, host_call_data.gprs[0]);
+		} else {
+			report(false, "FID=0x%x x0=0x%lx expected=0x%lx",
+				fid, host_call_data.gprs[0], expected_x0);
+			report_info("x1:  0x%lx", host_call_data.gprs[1]);
+			report_info("x2:  0x%lx", host_call_data.gprs[2]);
+			report_info("x3:  0x%lx", host_call_data.gprs[3]);
+			report_info("x4:  0x%lx", host_call_data.gprs[4]);
+			report_info("x5:  0x%lx", host_call_data.gprs[5]);
+			report_info("x6:  0x%lx", host_call_data.gprs[6]);
+		}
+	}
+}
+
+static void rsi_test_host_call(void)
+{
+	report_prefix_push("host_call");
+
+	/* Test that host calls return expected values */
+	host_call(FID_SMCCC_VERSION, SMCCC_VERSION_1_1);
+	host_call(FID_INVALID, SMCCC_NOT_SUPPORTED);
+
+	report_prefix_pop();
+}
+
 static void rsi_test_version(void)
 {
 	struct smccc_result res;
@@ -38,6 +128,8 @@ static void rsi_test_version(void)
 
 int main(int argc, char **argv)
 {
+	int i;
+
 	report_prefix_push("rsi");
 
 	if (!is_realm()) {
@@ -45,7 +137,23 @@ int main(int argc, char **argv)
 		goto exit;
 	}
 
-	rsi_test_version();
+	if (argc < 2) {
+		rsi_test_version();
+		rsi_test_host_call();
+		rsi_test_hvc();
+	} else {
+		for (i = 1; i < argc; i++) {
+			if (strcmp(argv[i], "version") == 0) {
+				rsi_test_version();
+			} else if (strcmp(argv[i], "hvc") == 0) {
+				rsi_test_hvc();
+			} else if (strcmp(argv[i], "host_call") == 0) {
+				rsi_test_host_call();
+			} else {
+				report_abort("Unknown subtest '%s'", argv[1]);
+			}
+		}
+	}
 exit:
 	return report_summary();
 }
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index a46c9ec7..b5be6668 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -286,5 +286,20 @@ groups = debug migration
 [realm-rsi]
 file = realm-rsi.flat
 groups = nodefault realms
+extra_params = -append 'version'
+accel = kvm
+arch = arm64
+
+[realm-host-call]
+file = realm-rsi.flat
+groups = nodefault realms
+extra_params = -append 'host_call'
+accel = kvm
+arch = arm64
+
+[realm-hvc]
+file = realm-rsi.flat
+groups = nodefault realms
+extra_params = -append 'hvc'
 accel = kvm
 arch = arm64
-- 
2.34.1

