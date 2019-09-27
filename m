Return-Path: <SRS0=2Aw4=XW=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0274CC4360C
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 10:42:45 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id B4C7920673
	for <kvmarm@archiver.kernel.org>; Fri, 27 Sep 2019 10:42:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B4C7920673
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CB9A4A76F;
	Fri, 27 Sep 2019 06:42:44 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id I4i8pEVHwz5f; Fri, 27 Sep 2019 06:42:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 500274A75A;
	Fri, 27 Sep 2019 06:42:43 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A72074A742
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 06:42:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id v3m3vuPnNN-m for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 Sep 2019 06:42:40 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 42B8B4A735
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 Sep 2019 06:42:39 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F3E8328;
 Fri, 27 Sep 2019 03:42:38 -0700 (PDT)
Received: from donnerap.arm.com (donnerap.cambridge.arm.com [10.1.197.44])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 330543F534;
 Fri, 27 Sep 2019 03:42:38 -0700 (PDT)
From: Andre Przywara <andre.przywara@arm.com>
To: Paolo Bonzini <pbonzini@redhat.com>,
	Andrew Jones <drjones@redhat.com>
Subject: [kvm-unit-tests PATCH 5/6] arm: selftest: Make MPIDR output stable
Date: Fri, 27 Sep 2019 11:42:26 +0100
Message-Id: <20190927104227.253466-6-andre.przywara@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190927104227.253466-1-andre.przywara@arm.com>
References: <20190927104227.253466-1-andre.przywara@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

At the moment the smp selftest outputs one line for each vCPU, with the
CPU number and its MPIDR printed in the same test result line.
For automated test frameworks this has the problem of including variable
output in the test name, also the number of tests varies, depending on the
number of vCPUs.

Fix this by only generating a single line of output for the SMP test,
which summarises the result. We use two cpumasks, to let each vCPU report
its result and completion of the test (code stolen from the GIC test).

For informational purposes we keep the one line per CPU, but prefix it
with an INFO: tag, so that frameworks can ignore it.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/selftest.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arm/selftest.c b/arm/selftest.c
index a0c1ab8..e9dc5c0 100644
--- a/arm/selftest.c
+++ b/arm/selftest.c
@@ -17,6 +17,8 @@
 #include <asm/smp.h>
 #include <asm/barrier.h>
 
+static cpumask_t ready, valid;
+
 static void __user_psci_system_off(void)
 {
 	psci_system_off();
@@ -341,8 +343,11 @@ static void cpu_report(void *data __unused)
 	uint64_t mpidr = get_mpidr();
 	int cpu = smp_processor_id();
 
-	report("CPU(%3d) mpidr=%010" PRIx64,
-		mpidr_to_cpu(mpidr) == cpu, cpu, mpidr);
+	if (mpidr_to_cpu(mpidr) == cpu)
+		cpumask_set_cpu(smp_processor_id(), &valid);
+	smp_wmb();		/* Paired with rmb in main(). */
+	cpumask_set_cpu(smp_processor_id(), &ready);
+	report_info("CPU%3d: MPIDR=%010" PRIx64, cpu, mpidr);
 }
 
 int main(int argc, char **argv)
@@ -371,6 +376,11 @@ int main(int argc, char **argv)
 
 		report("PSCI version", psci_check());
 		on_cpus(cpu_report, NULL);
+		while (!cpumask_full(&ready))
+			cpu_relax();
+		smp_rmb();		/* Paired with wmb in cpu_report(). */
+		report("MPIDR test on all CPUs", cpumask_full(&valid));
+		report_info("%d CPUs reported back", nr_cpus);
 
 	} else {
 		printf("Unknown subtest\n");
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
