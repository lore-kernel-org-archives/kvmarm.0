Return-Path: <SRS0=C9Vx=X2=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 969E6C352AA
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 10:24:07 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5570B21906
	for <kvmarm@archiver.kernel.org>; Tue,  1 Oct 2019 10:24:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5570B21906
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 09C354A6D6;
	Tue,  1 Oct 2019 06:24:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 46BYMcFClELS; Tue,  1 Oct 2019 06:24:06 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 862E54A809;
	Tue,  1 Oct 2019 06:24:04 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9D2F4A6ED
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 06:24:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 9WtNsXOBw3Cx for <kvmarm@lists.cs.columbia.edu>;
 Tue,  1 Oct 2019 06:24:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CFE254A58C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  1 Oct 2019 06:24:01 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A36D71570;
 Tue,  1 Oct 2019 03:24:01 -0700 (PDT)
Received: from e123195-lin.cambridge.arm.com (e123195-lin.cambridge.arm.com
 [10.1.196.63])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 68ADB3F739;
 Tue,  1 Oct 2019 03:24:00 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: kvm@vger.kernel.org,
	kvmarm@lists.cs.columbia.edu
Subject: [kvm-unit-tests RFC PATCH v2 16/19] arm64: selftest: Add basic test
 for EL2
Date: Tue,  1 Oct 2019 11:23:20 +0100
Message-Id: <20191001102323.27628-17-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001102323.27628-1-alexandru.elisei@arm.com>
References: <20191001102323.27628-1-alexandru.elisei@arm.com>
MIME-Version: 1.0
Cc: maz@kernel.org, andre.przywara@arm.com, pbonzini@redhat.com
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Add a rudimentary test for EL2 that checks that we are indeed running with
VHE enabled and that we are using SMC for issuing PSCI calls.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 lib/arm64/asm/processor.h |  6 ++++++
 arm/selftest.c            | 35 ++++++++++++++++++++++++++++++++++-
 arm/unittests.cfg         |  8 ++++++++
 3 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/lib/arm64/asm/processor.h b/lib/arm64/asm/processor.h
index 7e9f76d73f1b..4bbd82d9bfde 100644
--- a/lib/arm64/asm/processor.h
+++ b/lib/arm64/asm/processor.h
@@ -116,5 +116,11 @@ static inline u32 get_cntfrq(void)
 	return read_sysreg(cntfrq_el0);
 }
 
+static inline bool vhe_enabled(void)
+{
+	unsigned long hcr = read_sysreg(hcr_el2);
+	return (hcr & HCR_EL2_E2H) && (hcr & HCR_EL2_TGE);
+}
+
 #endif /* !__ASSEMBLY__ */
 #endif /* _ASMARM64_PROCESSOR_H_ */
diff --git a/arm/selftest.c b/arm/selftest.c
index 68dd34e59f3d..69994dcd3506 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -209,6 +209,11 @@ static void check_pabt(void)
 	test_exception("mov r2, #0x0", "bx r2", "");
 	__builtin_unreachable();
 }
+
+static void check_el2(void)
+{
+	report("EL2 only available on arm64", false);
+}
 #elif defined(__aarch64__)
 static unsigned long expected_level;
 
@@ -382,6 +387,31 @@ static void user_psci_system_off(struct pt_regs *regs, unsigned int esr)
 {
 	__user_psci_system_off();
 }
+
+#define ID_AA64MMFR1_VHE_MASK		(0xf << 8)
+#define ID_AA64MMFR1_VHE_SUPPORTED	(1 << 8)
+static bool vhe_supported(void)
+{
+	u64 aa64mmfr1 = read_sysreg(id_aa64mmfr1_el1);
+
+	return (aa64mmfr1 & ID_AA64MMFR1_VHE_MASK) == ID_AA64MMFR1_VHE_SUPPORTED;
+}
+
+static void check_el2_cpu(void *data __unused)
+{
+	int cpu = smp_processor_id();
+
+	report("CPU(%3d) Running at EL2", current_level() == CurrentEL_EL2, cpu);
+	report("CPU(%3d) VHE supported and enabled",
+			vhe_supported() && vhe_enabled(), cpu);
+}
+
+static bool psci_check(void);
+static void check_el2(void)
+{
+	report("PSCI conduit", psci_check());
+	on_cpus(check_el2_cpu, NULL);
+}
 #endif
 
 static void check_vectors(void *arg __unused)
@@ -437,7 +467,6 @@ static bool psci_check(void)
 		printf("psci method must be smc\n");
 		return false;
 	}
-
 	if (current_level() == CurrentEL_EL1 &&
 	    strcmp(method->data, "hvc") != 0) {
 		printf("psci method must be hvc\n");
@@ -490,6 +519,10 @@ int main(int argc, char **argv)
 		report("PSCI version", psci_check());
 		on_cpus(cpu_report, NULL);
 
+	} else if (strcmp(argv[1], "el2") == 0) {
+
+		check_el2();
+
 	} else {
 		printf("Unknown subtest\n");
 		abort();
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 6d3df92a4e28..c632f4e75382 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -55,6 +55,14 @@ smp = $MAX_SMP
 extra_params = -append 'smp'
 groups = selftest
 
+# Test EL2 support
+[selftest-el2]
+file = selftest.flat
+smp = 2
+extra_params = -append 'el2'
+groups = selftest
+arch = arm64
+
 # Test PCI emulation
 [pci-test]
 file = pci-test.flat
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
