Return-Path: <SRS0=5CXi=JM=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0511AC433B4
	for <kvmarm@archiver.kernel.org>; Thu, 15 Apr 2021 13:17:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6BC8A611CD
	for <kvmarm@archiver.kernel.org>; Thu, 15 Apr 2021 13:17:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6BC8A611CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id BEA3D4B685;
	Thu, 15 Apr 2021 09:17:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id stc3qfRivDUk; Thu, 15 Apr 2021 09:17:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8DABE4B65A;
	Thu, 15 Apr 2021 09:17:00 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D95224B646
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Apr 2021 09:16:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nyMXI5KlhGRB for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Apr 2021 09:16:58 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A20254B642
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Apr 2021 09:16:58 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE92311B3;
 Thu, 15 Apr 2021 06:16:57 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3B0E33F694;
 Thu, 15 Apr 2021 06:16:57 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com, kvm@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH kvmtool] arm: Fail early if KVM_CAP_ARM_PMU_V3 is not supported
Date: Thu, 15 Apr 2021 14:17:25 +0100
Message-Id: <20210415131725.105675-1-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
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

pmu__generate_fdt_nodes() checks if the host has support for PMU in a guest
and prints a warning if that's not the case. However, this check is too
late because the function is called after the VCPU has been created, and
VCPU creation fails if KVM_CAP_ARM_PMU_V3 is not available with a rather
unhelpful error:

$ ./vm run -c1 -m64 -f selftest.flat --pmu
  # lkvm run --firmware selftest.flat -m 64 -c 1 --name guest-1039
  Info: Placing fdt at 0x80200000 - 0x80210000
  Fatal: Unable to initialise vcpu

Move the check for KVM_CAP_ARM_PMU_V3 to kvm_cpu__arch_init() before the
VCPU is created so the user can get a more useful error message. This
also matches the behaviour of KVM_CAP_ARM_EL1_32BIT.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/kvm-cpu.c | 4 ++++
 arm/pmu.c     | 5 -----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/arm/kvm-cpu.c b/arm/kvm-cpu.c
index 2acecaecb696..6a2408c632df 100644
--- a/arm/kvm-cpu.c
+++ b/arm/kvm-cpu.c
@@ -50,6 +50,10 @@ struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
 	    !kvm__supports_extension(kvm, KVM_CAP_ARM_EL1_32BIT))
 		die("32bit guests are not supported\n");
 
+	if (kvm->cfg.arch.has_pmuv3 &&
+	    !kvm__supports_extension(kvm, KVM_CAP_ARM_PMU_V3))
+		die("PMUv3 is not supported");
+
 	vcpu = calloc(1, sizeof(struct kvm_cpu));
 	if (!vcpu)
 		return NULL;
diff --git a/arm/pmu.c b/arm/pmu.c
index ffd152e27447..5b058eabb49d 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -43,11 +43,6 @@ void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 	if (!kvm->cfg.arch.has_pmuv3)
 		return;
 
-	if (!kvm__supports_extension(kvm, KVM_CAP_ARM_PMU_V3)) {
-		pr_info("PMU unsupported\n");
-		return;
-	}
-
 	for (i = 0; i < kvm->nrcpus; i++) {
 		struct kvm_device_attr pmu_attr;
 
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
