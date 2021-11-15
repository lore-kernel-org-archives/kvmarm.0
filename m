Return-Path: <SRS0=JhWI=QC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8300C433EF
	for <kvmarm@archiver.kernel.org>; Mon, 15 Nov 2021 16:55:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5A4B860174
	for <kvmarm@archiver.kernel.org>; Mon, 15 Nov 2021 16:55:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 5A4B860174
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0F8A24B1D2;
	Mon, 15 Nov 2021 11:55:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id fm6WEJLqV13G; Mon, 15 Nov 2021 11:55:37 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 6575A4B1B5;
	Mon, 15 Nov 2021 11:55:37 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 25E7C4B1AD
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Nov 2021 11:55:36 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5XUSQ+fvADvo for <kvmarm@lists.cs.columbia.edu>;
 Mon, 15 Nov 2021 11:55:34 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BA7F84B0CB
 for <kvmarm@lists.cs.columbia.edu>; Mon, 15 Nov 2021 11:55:34 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4DD241063;
 Mon, 15 Nov 2021 08:55:34 -0800 (PST)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D0A0B3F766;
 Mon, 15 Nov 2021 08:55:32 -0800 (PST)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 maz@kernel.org, james.morse@arm.com, suzuki.poulose@arm.com,
 mark.rutland@arm.com
Subject: [PATCH kvmtool 5/9] arm64: Rework set_pmu_attr()
Date: Mon, 15 Nov 2021 16:57:01 +0000
Message-Id: <20211115165705.195736-6-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165705.195736-1-alexandru.elisei@arm.com>
References: <20211115165705.195736-1-alexandru.elisei@arm.com>
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

By the time kvmtool generates the DTB node for the PMU, the
KVM_ARM_VCPU_PMU_V3 VCPU feature is already set by kvm_cpu__arch_init().

KVM refuses to run a VCPU if the PMU hasn't been initialized. A PMU
cannot be initialized if the interrupt ID hasn't been set by userspace.
As a consequence, kvmtool will get an error if the interrupt ID or if
the PMU has not been initialized:

KVM_RUN failed: Invalid argument

To make debugging easier, exit with an error message as soon as one the
PMU ioctls fails, instead of waiting until the VCPU is first run.

To avoid the repetition of assigning a new kvm_device_attr struct in the
main body of pmu__generate_fdt_nodes(), which hinders readability of the
function, move the struct to set_pmu_attr().

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch64/pmu.c | 48 ++++++++++++++++-------------------------------
 1 file changed, 16 insertions(+), 32 deletions(-)

diff --git a/arm/aarch64/pmu.c b/arm/aarch64/pmu.c
index 6b190c5e2ae5..ac5b7bcd6ca9 100644
--- a/arm/aarch64/pmu.c
+++ b/arm/aarch64/pmu.c
@@ -7,30 +7,31 @@
 
 #include "asm/pmu.h"
 
-static int set_pmu_attr(struct kvm *kvm, int vcpu_idx,
-			struct kvm_device_attr *attr)
+static void set_pmu_attr(struct kvm_cpu *vcpu, void *addr, u64 attr)
 {
-	int ret, fd;
-
-	fd = kvm->cpus[vcpu_idx]->vcpu_fd;
+	struct kvm_device_attr pmu_attr = {
+		.group	= KVM_ARM_VCPU_PMU_V3_CTRL,
+		.addr	= (u64)addr,
+		.attr	= attr,
+	};
+	int ret;
 
-	ret = ioctl(fd, KVM_HAS_DEVICE_ATTR, attr);
+	ret = ioctl(vcpu->vcpu_fd, KVM_HAS_DEVICE_ATTR, &pmu_attr);
 	if (!ret) {
-		ret = ioctl(fd, KVM_SET_DEVICE_ATTR, attr);
+		ret = ioctl(vcpu->vcpu_fd, KVM_SET_DEVICE_ATTR, &pmu_attr);
 		if (ret)
-			perror("PMU KVM_SET_DEVICE_ATTR failed");
+			die_perror("PMU KVM_SET_DEVICE_ATTR");
 	} else {
-		pr_err("Unsupported PMU on vcpu%d\n", vcpu_idx);
+		die_perror("PMU KVM_HAS_DEVICE_ATTR");
 	}
-
-	return ret;
 }
 
 void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 {
 	const char compatible[] = "arm,armv8-pmuv3";
 	int irq = KVM_ARM_PMUv3_PPI;
-	int i, ret;
+	struct kvm_cpu *vcpu;
+	int i;
 
 	u32 cpu_mask = (((1 << kvm->nrcpus) - 1) << GIC_FDT_IRQ_PPI_CPU_SHIFT) \
 		       & GIC_FDT_IRQ_PPI_CPU_MASK;
@@ -44,26 +45,9 @@ void pmu__generate_fdt_nodes(void *fdt, struct kvm *kvm)
 		return;
 
 	for (i = 0; i < kvm->nrcpus; i++) {
-		struct kvm_device_attr pmu_attr;
-
-		pmu_attr = (struct kvm_device_attr){
-			.group	= KVM_ARM_VCPU_PMU_V3_CTRL,
-			.addr	= (u64)(unsigned long)&irq,
-			.attr	= KVM_ARM_VCPU_PMU_V3_IRQ,
-		};
-
-		ret = set_pmu_attr(kvm, i, &pmu_attr);
-		if (ret)
-			return;
-
-		pmu_attr = (struct kvm_device_attr){
-			.group	= KVM_ARM_VCPU_PMU_V3_CTRL,
-			.attr	= KVM_ARM_VCPU_PMU_V3_INIT,
-		};
-
-		ret = set_pmu_attr(kvm, i, &pmu_attr);
-		if (ret)
-			return;
+		vcpu = kvm->cpus[i];
+		set_pmu_attr(vcpu, &irq, KVM_ARM_VCPU_PMU_V3_IRQ);
+		set_pmu_attr(vcpu, NULL, KVM_ARM_VCPU_PMU_V3_INIT);
 	}
 
 	_FDT(fdt_begin_node(fdt, "pmu"));
-- 
2.31.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
