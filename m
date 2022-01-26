Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22B5AC28CF5
	for <kvmarm@archiver.kernel.org>; Wed, 26 Jan 2022 13:53:34 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8550040B78;
	Wed, 26 Jan 2022 08:53:34 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id Z4Zj9pj4Jhdi; Wed, 26 Jan 2022 08:53:32 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 49E5440C0A;
	Wed, 26 Jan 2022 08:53:32 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B747940C0A
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 08:53:30 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5JXp-daWzH20 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Jan 2022 08:53:28 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5BBE140BEE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Jan 2022 08:53:28 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id A8C8CB81E15;
 Wed, 26 Jan 2022 13:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B4CC340E3;
 Wed, 26 Jan 2022 13:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1643205205;
 bh=SB1wPkecSWgUxIk4Kgzf28opZ+Vn2jcLSfzzazV/QB8=;
 h=From:To:Cc:Subject:Date:From;
 b=p8cpGDeAymdCdWT6X54KxabPxqJi8EQEzIY+wCfhKMsnJ+jBEFxPYPeyL/+pu7qZo
 3oD58Gy6ce45UP/h9KMq1X7rI7kHgyCLl3HUJgiRVPIiZLtDDSm/iagabO7rWXnBez
 d2tfYonckL5KqKYH5T6sBZAoQGH6vO832N0oS+ery4ZzzDQhZ1Rhi8TAKYwmLLajKD
 uT2A2WMDy69nYggSeK2CxONIa0n/efVPH7TZ+bvFMKwiWbn5qaEFhKePlK2k7pDQOK
 ZDWzeLbPFfTUr6aYvxnUA0EG+Yqh9EDzC12sjSSpRgUcVRjDP52t94JcbtgSdOImOq
 pZ4cwdJG8eNpg==
From: Mark Brown <broonie@kernel.org>
To: Marc Zyngier <maz@kernel.org>,
	Shuah Khan <shuah@kernel.org>
Subject: [PATCH v2] kselftest: kvm/arm64: Skip tests if we can't create a
 vgic-v3
Date: Wed, 26 Jan 2022 13:53:19 +0000
Message-Id: <20220126135319.1918802-1-broonie@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Cc: Mark Brown <broonie@kernel.org>, linux-kselftest@vger.kernel.org,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

The arch_timer and vgic_irq kselftests assume that they can create a
vgic-v3, using the library function vgic_v3_setup() which aborts with a
test failure if it is not possible to do so. Since vgic-v3 can only be
instantiated on systems where the host has GICv3 this leads to false
positives on older systems where that is not the case.

Fix this by changing vgic_v3_setup() to return an error if the vgic can't
be instantiated and have the callers skip if this happens. We could also
exit flagging a skip in vgic_v3_setup() but this would prevent future test
cases conditionally deciding which GIC to use or generally doing more
complex output.

Signed-off-by: Mark Brown <broonie@kernel.org>
---

v2:
 - The test for being able to create the GIC doesn't actually
   instantiate it, add a call doing so in that case.

 tools/testing/selftests/kvm/aarch64/arch_timer.c | 7 ++++++-
 tools/testing/selftests/kvm/aarch64/vgic_irq.c   | 4 ++++
 tools/testing/selftests/kvm/lib/aarch64/vgic.c   | 5 ++++-
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index 9ad38bd360a4..791d38404652 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -366,6 +366,7 @@ static struct kvm_vm *test_vm_create(void)
 {
 	struct kvm_vm *vm;
 	unsigned int i;
+	int ret;
 	int nr_vcpus = test_args.nr_vcpus;
 
 	vm = vm_create_default_with_vcpus(nr_vcpus, 0, 0, guest_code, NULL);
@@ -382,7 +383,11 @@ static struct kvm_vm *test_vm_create(void)
 
 	ucall_init(vm, NULL);
 	test_init_timer_irq(vm);
-	vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+	ret = vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
+	if (ret < 0) {
+		pr_info("Failed to create vgic-v3, skipping\n");
+		exit(KSFT_SKIP);
+	}
 
 	/* Make all the test's cmdline args visible to the guest */
 	sync_global_to_guest(vm, test_args);
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index e6c7d7f8fbd1..b127a261fd29 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -761,6 +761,10 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 
 	gic_fd = vgic_v3_setup(vm, 1, nr_irqs,
 			GICD_BASE_GPA, GICR_BASE_GPA);
+	if (gic_fd < 0) {
+		pr_info("Failed to create vgic-v3, skipping\n");
+		exit(KSFT_SKIP);
+	}
 
 	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT,
 		guest_irq_handlers[args.eoi_split][args.level_sensitive]);
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index b3a0fca0d780..4ea65e119bdd 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -51,7 +51,10 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
 			"Number of vCPUs requested (%u) doesn't match with the ones created for the VM (%u)\n",
 			nr_vcpus, nr_vcpus_created);
 
-	/* Distributor setup */
+	/* Distributor setup - test if it's possible then actually do it */
+	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, true);
+	if (gic_fd != 0)
+		return -1;
 	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
 
 	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
