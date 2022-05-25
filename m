Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAC2EC433F5
	for <kvmarm@archiver.kernel.org>; Wed, 25 May 2022 16:57:09 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 440004B2F6;
	Wed, 25 May 2022 12:57:09 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2pDtpNS+g876; Wed, 25 May 2022 12:57:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D19414B2F7;
	Wed, 25 May 2022 12:57:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 03F7C4B2F1
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 12:57:06 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id wuhQLd-cr7TL for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 May 2022 12:57:04 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8EAB94B2EE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 May 2022 12:57:04 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id D2F0A14BF;
 Wed, 25 May 2022 09:57:03 -0700 (PDT)
Received: from monolith.localdoman (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9F5F23F93E;
 Wed, 25 May 2022 09:57:02 -0700 (PDT)
From: Alexandru Elisei <alexandru.elisei@arm.com>
To: will@kernel.org, julien.thierry.kdev@gmail.com,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 andre.przywara@arm.com
Subject: [PATCH kvmtool 1/2] arm64: Honor --vcpu-affinity for aarch32 guests
Date: Wed, 25 May 2022 17:57:03 +0100
Message-Id: <20220525165704.186754-2-alexandru.elisei@arm.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220525165704.186754-1-alexandru.elisei@arm.com>
References: <20220525165704.186754-1-alexandru.elisei@arm.com>
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

Commit 4639b72f61a3 ("arm64: Add --vcpu-affinity command line argument")
introduced the --vcpu-affinity command line argument to pin the VCPUs to a
given list of physical CPUs. Unfortunately, the affinity is set only for an
arm64 guest, leading to the following error when running a 32-bit guest on
a system with two or more PMUs:

KVM exit reason: 9 ("KVM_EXIT_FAIL_ENTRY")

 Registers:
 PC:    0x8000c608
 PSTATE:    0x200000d3
 SP_EL1:    0x0
 LR:    0x0

*pc:
 0x8000c608: 25 3f a0 e1  83 61 a0 e1
 0x8000c610: 83 31 98 e7  04 10 82 e1
 0x8000c618: 07 2c 81 e3  28 10 1b e5
 0x8000c620: 03 20 82 e3  03 00 a0 e1

*lr:
  Warning: unable to translate guest address 0x0 to host
 0x00000000: <unknown>
 0x00000008: <unknown>
 0x00000010: <unknown>
 0x00000018: <unknown>

  # KVM compatibility warning.
	virtio-net device was not detected.
	While you have requested a virtio-net device, the guest kernel did not initialize it.
	Please make sure that the guest kernel was compiled with CONFIG_VIRTIO_NET=y enabled in .config.

  # KVM session ended normally.

Make the error go away by setting the affinity of the VCPUs for both 32-bit
and 64-bit guests.

Fixes: 4639b72f61a3 ("arm64: Add --vcpu-affinity command line argument")
Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
---
 arm/aarch64/kvm-cpu.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/arm/aarch64/kvm-cpu.c b/arm/aarch64/kvm-cpu.c
index 4ac0fafae06b..c8be10b3ca94 100644
--- a/arm/aarch64/kvm-cpu.c
+++ b/arm/aarch64/kvm-cpu.c
@@ -88,16 +88,7 @@ static void reset_vcpu_aarch64(struct kvm_cpu *vcpu)
 {
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_one_reg reg;
-	cpu_set_t *affinity;
 	u64 data;
-	int ret;
-
-	affinity = kvm->arch.vcpu_affinity_cpuset;
-	if (affinity) {
-		ret = sched_setaffinity(0, sizeof(cpu_set_t), affinity);
-		if (ret == -1)
-			die_perror("sched_setaffinity");
-	}
 
 	reg.addr = (u64)&data;
 
@@ -179,7 +170,18 @@ int kvm_cpu__configure_features(struct kvm_cpu *vcpu)
 
 void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu)
 {
-	if (vcpu->kvm->cfg.arch.aarch32_guest)
+	struct kvm *kvm = vcpu->kvm;
+	cpu_set_t *affinity;
+	int ret;
+
+	affinity = kvm->arch.vcpu_affinity_cpuset;
+	if (affinity) {
+		ret = sched_setaffinity(0, sizeof(cpu_set_t), affinity);
+		if (ret == -1)
+			die_perror("sched_setaffinity");
+	}
+
+	if (kvm->cfg.arch.aarch32_guest)
 		return reset_vcpu_aarch32(vcpu);
 	else
 		return reset_vcpu_aarch64(vcpu);
-- 
2.36.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
