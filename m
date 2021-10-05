Return-Path: <SRS0=da30=OZ=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EB4DC4332F
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:39 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D2B9C61507
	for <kvmarm@archiver.kernel.org>; Tue,  5 Oct 2021 01:19:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D2B9C61507
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 879C04B29C;
	Mon,  4 Oct 2021 21:19:38 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id KnKKP2sVPCZY; Mon,  4 Oct 2021 21:19:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3AEBE4B2CC;
	Mon,  4 Oct 2021 21:19:36 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC6774B2B9
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id RsmleBvFEofR for <kvmarm@lists.cs.columbia.edu>;
 Mon,  4 Oct 2021 21:19:34 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 8FE274B2B5
 for <kvmarm@lists.cs.columbia.edu>; Mon,  4 Oct 2021 21:19:33 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 i83-20020a252256000000b005b67a878f56so26009289ybi.17
 for <kvmarm@lists.cs.columbia.edu>; Mon, 04 Oct 2021 18:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=9eram93ljMwsqb7jsk2L6oZKCRfve8Gk2Irw1aKvfII=;
 b=HbSl19hLJ4SkgqGT2gzqmgBNx+DRJUk2+wGUDBQhyLYOjU+1cUcCUnSeSLnWDES7YE
 fEvXFu3/aAg2ORn2L9tPbH+UGBtMZ4vcH4RdMATaj/FhyJfcJLFdEiQrDtwqtIx2D4YM
 Fl3USo4YN+FdqzzTNwiz6WDIm/7UqTKiilYZppa7P5tzjIDnlNdO9FgakvluDfMFEqZA
 Y6+FaTXQV4un2QTI7nhSaJ/7LSshR04d1JRSaatalNX5dBdghqBjCahGJU8oBhihlYqV
 OlSkebLUjY4+Mj8iybEm2Jkhzmjd+uwFhHEBsr6Ff6YvMSrqi3UlLtAMwTm6a060tsCk
 GXVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=9eram93ljMwsqb7jsk2L6oZKCRfve8Gk2Irw1aKvfII=;
 b=Nzm5l9IM8y7Rsuxaz02Zw3/rIEBIqe41mWw8mJGuf+ApOhF5Ab+Wou12JIWdpM5bKH
 Zlu2OvvzDet7cgplT/3mie0swjCpzm2rXY/+85KSonmcStj+wR0NmGR1/CJ9EUM8yyfg
 1Kw0IGT5fG/NIXA65pBL6pTkG1c9SSusoZRTKtycquc+5q5ii6VrFi/ESyhdjovuAExL
 SzCrQwf73Ps1rLyP3uvGRc9SrWRhUQm8ncyc7QIK/oIT65rCgws74OF8XsXmoS+Mmbzh
 RpXZKl9DGW2By57N6FnKb3nqVIRBx97ojtZIXk44Lbwm0i/dNsAvvpxFPMk+Z06PTlWA
 i5GA==
X-Gm-Message-State: AOAM531ewu3E2JUfo1I3Yvp7y1JDrW2zc0KZ0zlPb8UwDFLsoGnENLgG
 BBwPucS4SRzCDUIeLqqY18pYdCtVx3fykw==
X-Google-Smtp-Source: ABdhPJyOwHwgjEh7E0BFPgyYUqTAnbHWWC1AI//3kHQVSLc+P8hFanOZnjiRrISF/kxYvZdmrYhYe9d+RgJYBA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a25:d251:: with SMTP id
 j78mr18340344ybg.185.1633396773123; Mon, 04 Oct 2021 18:19:33 -0700 (PDT)
Date: Mon,  4 Oct 2021 18:19:16 -0700
In-Reply-To: <20211005011921.437353-1-ricarkol@google.com>
Message-Id: <20211005011921.437353-7-ricarkol@google.com>
Mime-Version: 1.0
References: <20211005011921.437353-1-ricarkol@google.com>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
Subject: [PATCH v4 06/11] KVM: arm64: selftests: Make vgic_init gic version
 agnostic
From: Ricardo Koller <ricarkol@google.com>
To: kvm@vger.kernel.org, maz@kernel.org, kvmarm@lists.cs.columbia.edu, 
 drjones@redhat.com, eric.auger@redhat.com, alexandru.elisei@arm.com
Cc: pshier@google.com, Paolo Bonzini <pbonzini@redhat.com>, shuah@kernel.org
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

As a preparation for the next commits which will add some tests for
GICv2, make aarch64/vgic_init GIC version agnostic. Add a new generic
run_tests function(gic_dev_type) that starts all applicable tests using
GICv3 or GICv2. GICv2 tests are attempted if GICv3 is not available in
the system. There are currently no GICv2 tests, but the test passes now
in GICv2 systems.

Reviewed-by: Eric Auger <eric.auger@redhat.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_init.c | 156 +++++++++++-------
 1 file changed, 95 insertions(+), 61 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_init.c b/tools/testing/selftests/kvm/aarch64/vgic_init.c
index 623f31a14326..896a29f2503d 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_init.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_init.c
@@ -22,6 +22,9 @@
 
 #define GICR_TYPER 0x8
 
+#define VGIC_DEV_IS_V2(_d) ((_d) == KVM_DEV_TYPE_ARM_VGIC_V2)
+#define VGIC_DEV_IS_V3(_d) ((_d) == KVM_DEV_TYPE_ARM_VGIC_V3)
+
 struct vm_gic {
 	struct kvm_vm *vm;
 	int gic_fd;
@@ -30,8 +33,8 @@ struct vm_gic {
 static int max_ipa_bits;
 
 /* helper to access a redistributor register */
-static int access_redist_reg(int gicv3_fd, int vcpu, int offset,
-			     uint32_t *val, bool write)
+static int access_v3_redist_reg(int gicv3_fd, int vcpu, int offset,
+				uint32_t *val, bool write)
 {
 	uint64_t attr = REG_OFFSET(vcpu, offset);
 
@@ -58,7 +61,7 @@ static int run_vcpu(struct kvm_vm *vm, uint32_t vcpuid)
 	return 0;
 }
 
-static struct vm_gic vm_gic_create(void)
+static struct vm_gic vm_gic_v3_create(void)
 {
 	struct vm_gic v;
 
@@ -80,7 +83,7 @@ static void vm_gic_destroy(struct vm_gic *v)
  * device gets created, a legacy RDIST region is set at @0x0
  * and a DIST region is set @0x60000
  */
-static void subtest_dist_rdist(struct vm_gic *v)
+static void subtest_v3_dist_rdist(struct vm_gic *v)
 {
 	int ret;
 	uint64_t addr;
@@ -145,7 +148,7 @@ static void subtest_dist_rdist(struct vm_gic *v)
 }
 
 /* Test the new REDIST region API */
-static void subtest_redist_regions(struct vm_gic *v)
+static void subtest_v3_redist_regions(struct vm_gic *v)
 {
 	uint64_t addr, expected_addr;
 	int ret;
@@ -249,7 +252,7 @@ static void subtest_redist_regions(struct vm_gic *v)
  * VGIC KVM device is created and initialized before the secondary CPUs
  * get created
  */
-static void test_vgic_then_vcpus(void)
+static void test_v3_vgic_then_vcpus(uint32_t gic_dev_type)
 {
 	struct vm_gic v;
 	int ret, i;
@@ -257,7 +260,7 @@ static void test_vgic_then_vcpus(void)
 	v.vm = vm_create_default(0, 0, guest_code);
 	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
 
-	subtest_dist_rdist(&v);
+	subtest_v3_dist_rdist(&v);
 
 	/* Add the rest of the VCPUs */
 	for (i = 1; i < NR_VCPUS; ++i)
@@ -270,14 +273,14 @@ static void test_vgic_then_vcpus(void)
 }
 
 /* All the VCPUs are created before the VGIC KVM device gets initialized */
-static void test_vcpus_then_vgic(void)
+static void test_v3_vcpus_then_vgic(uint32_t gic_dev_type)
 {
 	struct vm_gic v;
 	int ret;
 
-	v = vm_gic_create();
+	v = vm_gic_v3_create();
 
-	subtest_dist_rdist(&v);
+	subtest_v3_dist_rdist(&v);
 
 	ret = run_vcpu(v.vm, 3);
 	TEST_ASSERT(ret == -EINVAL, "dist/rdist overlap detected on 1st vcpu run");
@@ -285,15 +288,15 @@ static void test_vcpus_then_vgic(void)
 	vm_gic_destroy(&v);
 }
 
-static void test_new_redist_regions(void)
+static void test_v3_new_redist_regions(void)
 {
 	void *dummy = NULL;
 	struct vm_gic v;
 	uint64_t addr;
 	int ret;
 
-	v = vm_gic_create();
-	subtest_redist_regions(&v);
+	v = vm_gic_v3_create();
+	subtest_v3_redist_regions(&v);
 	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
 			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
 
@@ -303,8 +306,8 @@ static void test_new_redist_regions(void)
 
 	/* step2 */
 
-	v = vm_gic_create();
-	subtest_redist_regions(&v);
+	v = vm_gic_v3_create();
+	subtest_v3_redist_regions(&v);
 
 	addr = REDIST_REGION_ATTR_ADDR(1, 0x280000, 0, 2);
 	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
@@ -317,8 +320,8 @@ static void test_new_redist_regions(void)
 
 	/* step 3 */
 
-	v = vm_gic_create();
-	subtest_redist_regions(&v);
+	v = vm_gic_v3_create();
+	subtest_v3_redist_regions(&v);
 
 	_kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, dummy, true);
@@ -338,7 +341,7 @@ static void test_new_redist_regions(void)
 	vm_gic_destroy(&v);
 }
 
-static void test_typer_accesses(void)
+static void test_v3_typer_accesses(void)
 {
 	struct vm_gic v;
 	uint64_t addr;
@@ -351,12 +354,12 @@ static void test_typer_accesses(void)
 
 	vm_vcpu_add_default(v.vm, 3, guest_code);
 
-	ret = access_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
+	ret = access_v3_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
 	TEST_ASSERT(ret && errno == EINVAL, "attempting to read GICR_TYPER of non created vcpu");
 
 	vm_vcpu_add_default(v.vm, 1, guest_code);
 
-	ret = access_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
+	ret = access_v3_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
 	TEST_ASSERT(ret && errno == EBUSY, "read GICR_TYPER before GIC initialized");
 
 	vm_vcpu_add_default(v.vm, 2, guest_code);
@@ -365,7 +368,7 @@ static void test_typer_accesses(void)
 			  KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
 
 	for (i = 0; i < NR_VCPUS ; i++) {
-		ret = access_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
+		ret = access_v3_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
 		TEST_ASSERT(!ret && !val, "read GICR_TYPER before rdist region setting");
 	}
 
@@ -374,10 +377,10 @@ static void test_typer_accesses(void)
 			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 
 	/* The 2 first rdists should be put there (vcpu 0 and 3) */
-	ret = access_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
+	ret = access_v3_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && !val, "read typer of rdist #0");
 
-	ret = access_redist_reg(v.gic_fd, 3, GICR_TYPER, &val, false);
+	ret = access_v3_redist_reg(v.gic_fd, 3, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x310, "read typer of rdist #1");
 
 	addr = REDIST_REGION_ATTR_ADDR(10, 0x100000, 0, 1);
@@ -385,11 +388,11 @@ static void test_typer_accesses(void)
 				 KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 	TEST_ASSERT(ret && errno == EINVAL, "collision with previous rdist region");
 
-	ret = access_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
+	ret = access_v3_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x100,
 		    "no redist region attached to vcpu #1 yet, last cannot be returned");
 
-	ret = access_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
+	ret = access_v3_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x200,
 		    "no redist region attached to vcpu #2, last cannot be returned");
 
@@ -397,10 +400,10 @@ static void test_typer_accesses(void)
 	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 
-	ret = access_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
+	ret = access_v3_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x100, "read typer of rdist #1");
 
-	ret = access_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
+	ret = access_v3_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x210,
 		    "read typer of rdist #1, last properly returned");
 
@@ -417,7 +420,7 @@ static void test_typer_accesses(void)
  * rdist region #2 @0x200000 2 rdist capacity
  *     rdists: 1, 2
  */
-static void test_last_bit_redist_regions(void)
+static void test_v3_last_bit_redist_regions(void)
 {
 	uint32_t vcpuids[] = { 0, 3, 5, 4, 1, 2 };
 	struct vm_gic v;
@@ -444,29 +447,29 @@ static void test_last_bit_redist_regions(void)
 	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 			  KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &addr, true);
 
-	ret = access_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
+	ret = access_v3_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x000, "read typer of rdist #0");
 
-	ret = access_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
+	ret = access_v3_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x100, "read typer of rdist #1");
 
-	ret = access_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
+	ret = access_v3_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x200, "read typer of rdist #2");
 
-	ret = access_redist_reg(v.gic_fd, 3, GICR_TYPER, &val, false);
+	ret = access_v3_redist_reg(v.gic_fd, 3, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x310, "read typer of rdist #3");
 
-	ret = access_redist_reg(v.gic_fd, 5, GICR_TYPER, &val, false);
+	ret = access_v3_redist_reg(v.gic_fd, 5, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x500, "read typer of rdist #5");
 
-	ret = access_redist_reg(v.gic_fd, 4, GICR_TYPER, &val, false);
+	ret = access_v3_redist_reg(v.gic_fd, 4, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x410, "read typer of rdist #4");
 
 	vm_gic_destroy(&v);
 }
 
 /* Test last bit with legacy region */
-static void test_last_bit_single_rdist(void)
+static void test_v3_last_bit_single_rdist(void)
 {
 	uint32_t vcpuids[] = { 0, 3, 5, 4, 1, 2 };
 	struct vm_gic v;
@@ -485,28 +488,32 @@ static void test_last_bit_single_rdist(void)
 	kvm_device_access(v.gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 			  KVM_VGIC_V3_ADDR_TYPE_REDIST, &addr, true);
 
-	ret = access_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
+	ret = access_v3_redist_reg(v.gic_fd, 0, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x000, "read typer of rdist #0");
 
-	ret = access_redist_reg(v.gic_fd, 3, GICR_TYPER, &val, false);
+	ret = access_v3_redist_reg(v.gic_fd, 3, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x300, "read typer of rdist #1");
 
-	ret = access_redist_reg(v.gic_fd, 5, GICR_TYPER, &val, false);
+	ret = access_v3_redist_reg(v.gic_fd, 5, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x500, "read typer of rdist #2");
 
-	ret = access_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
+	ret = access_v3_redist_reg(v.gic_fd, 1, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x100, "read typer of rdist #3");
 
-	ret = access_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
+	ret = access_v3_redist_reg(v.gic_fd, 2, GICR_TYPER, &val, false);
 	TEST_ASSERT(!ret && val == 0x210, "read typer of rdist #3");
 
 	vm_gic_destroy(&v);
 }
 
-void test_kvm_device(void)
+/*
+ * Returns 0 if it's possible to create GIC device of a given type (V2 or V3).
+ */
+int test_kvm_device(uint32_t gic_dev_type)
 {
 	struct vm_gic v;
 	int ret, fd;
+	uint32_t other;
 
 	v.vm = vm_create_default_with_vcpus(NR_VCPUS, 0, 0, guest_code, NULL);
 
@@ -514,38 +521,65 @@ void test_kvm_device(void)
 	ret = _kvm_create_device(v.vm, 0, true, &fd);
 	TEST_ASSERT(ret && errno == ENODEV, "unsupported device");
 
-	/* trial mode with VGIC_V3 device */
-	ret = _kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, true, &fd);
-	if (ret) {
-		print_skip("GICv3 not supported");
-		exit(KSFT_SKIP);
-	}
-	v.gic_fd = kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	/* trial mode */
+	ret = _kvm_create_device(v.vm, gic_dev_type, true, &fd);
+	if (ret)
+		return ret;
+	v.gic_fd = kvm_create_device(v.vm, gic_dev_type, false);
+
+	ret = _kvm_create_device(v.vm, gic_dev_type, false, &fd);
+	TEST_ASSERT(ret && errno == EEXIST, "create GIC device twice");
 
-	ret = _kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, false, &fd);
-	TEST_ASSERT(ret && errno == EEXIST, "create GICv3 device twice");
+	kvm_create_device(v.vm, gic_dev_type, true);
 
-	kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V3, true);
+	/* try to create the other gic_dev_type */
+	other = VGIC_DEV_IS_V2(gic_dev_type) ? KVM_DEV_TYPE_ARM_VGIC_V3
+					     : KVM_DEV_TYPE_ARM_VGIC_V2;
 
-	if (!_kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V2, true, &fd)) {
-		ret = _kvm_create_device(v.vm, KVM_DEV_TYPE_ARM_VGIC_V2, false, &fd);
-		TEST_ASSERT(ret && errno == EINVAL, "create GICv2 while v3 exists");
+	if (!_kvm_create_device(v.vm, other, true, &fd)) {
+		ret = _kvm_create_device(v.vm, other, false, &fd);
+		TEST_ASSERT(ret && errno == EINVAL,
+				"create GIC device while other version exists");
 	}
 
 	vm_gic_destroy(&v);
+
+	return 0;
+}
+
+void run_tests(uint32_t gic_dev_type)
+{
+	if (VGIC_DEV_IS_V3(gic_dev_type)) {
+		test_v3_vcpus_then_vgic(gic_dev_type);
+		test_v3_vgic_then_vcpus(gic_dev_type);
+		test_v3_new_redist_regions();
+		test_v3_typer_accesses();
+		test_v3_last_bit_redist_regions();
+		test_v3_last_bit_single_rdist();
+	}
 }
 
 int main(int ac, char **av)
 {
+	int ret;
+
 	max_ipa_bits = kvm_check_cap(KVM_CAP_ARM_VM_IPA_SIZE);
 
-	test_kvm_device();
-	test_vcpus_then_vgic();
-	test_vgic_then_vcpus();
-	test_new_redist_regions();
-	test_typer_accesses();
-	test_last_bit_redist_regions();
-	test_last_bit_single_rdist();
+	ret = test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V3);
+	if (!ret) {
+		pr_info("Running GIC_v3 tests.\n");
+		run_tests(KVM_DEV_TYPE_ARM_VGIC_V3);
+		return 0;
+	}
+
+	ret = test_kvm_device(KVM_DEV_TYPE_ARM_VGIC_V2);
+	if (!ret) {
+		pr_info("Running GIC_v2 tests.\n");
+		run_tests(KVM_DEV_TYPE_ARM_VGIC_V2);
+		return 0;
+	}
 
+	print_skip("No GICv2 nor GICv3 support");
+	exit(KSFT_SKIP);
 	return 0;
 }
-- 
2.33.0.800.g4c38ced690-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
