Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3585BC433EF
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id DC3B7619E9
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org DC3B7619E9
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 8E55E4B1FD;
	Mon,  8 Nov 2021 21:39:32 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 6z4C-SVb8NP8; Mon,  8 Nov 2021 21:39:30 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B52294B1FE;
	Mon,  8 Nov 2021 21:39:29 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6DC6B4B1EF
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id D3u9LPR0u85g for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 21:39:27 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 47B944B1E0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:26 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 v18-20020a170902e8d200b00141df2da949so7687698plg.10
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 18:39:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=T/U2YZ0Dx5Q+ABkERIkOVQhmFwsBS+/GEeXojMLJ6pM=;
 b=I9J44Tlj1l6UKaQ512FvPEzcX1DdGwiz58SWeR+hdVcMW2kTX45ThPl1NP6G3YkSSt
 RzLiXAjoBnLW1ZE2M2dz2sGGmToLOxHF5C4ZN1awF2Dyt1EEoelXsL7P8NYCsjkejH/k
 FAtj8Zj5iWIHfoTIPzEh6lbXozLXbezmh5WFayZnOdaK/SQXvVdVBpwN0fCcmXD1scvb
 Qb7YvoezFgijKnE8C33RITHSDvk70+mTZyff6dxhO+sKFXeO1Ld/ByXOxp6paFfNLVtC
 3KRS7LOAuqVG+GnxgDzQtcVhbett80WMnoidKPgDHvbgX6YSN3OAU1H7+GHzssfC9pYk
 rfdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=T/U2YZ0Dx5Q+ABkERIkOVQhmFwsBS+/GEeXojMLJ6pM=;
 b=SUQlvnCBkTWaxxaFKbBWMvaCZC+7DB8y+leKSzZs3FmBNFlV9fHkfIOKcXSvKnhxs/
 vePO1JglfzxbezzLmGQU3w8hz15YJJ/5QZnp+eEHOAUOrPnmDfe9b3VF/+rTan2vBLHI
 JlX9TTz+MFysYXj5UkKe4vrI3DH82LaA0nB96c89Bqn2UB1h07omLb8XIPoLt1+8I5eQ
 Ckj9iBGDYzew1HbNJ6VoRLdU/4MMBibXoS/2wHEAscBcEOUXRnQFTXKXm9vsvkId/ZYq
 1dToybUBVZDVYmvfc6G3QmMBg0NGB1VX80pumi2S7ZexI76Cid/d0W/DWs2TuN7BjlTh
 t0aw==
X-Gm-Message-State: AOAM5301WX4rb8mKuclJKiWhW2gfAmEPTQF3Y0hAtCBZ81nhH6JMA2QD
 jk38lB0TphAkXN5T7vjq/EY4ZF780E1dCQ==
X-Google-Smtp-Source: ABdhPJwo5kDWZp3jsZeKBNmmEeBsUziLE7T5cLkpXYrOwjklN8hbYdHReieIXQbhBJdxHHGG9LZhGj4w72n6sg==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:90b:4ace:: with SMTP id
 mh14mr3347384pjb.164.1636425565565; Mon, 08 Nov 2021 18:39:25 -0800 (PST)
Date: Mon,  8 Nov 2021 18:38:57 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-9-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 08/17] KVM: selftests: aarch64: cmdline arg to set number of
 IRQs in vgic_irq test
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

Add the ability to specify the number of vIRQs exposed by KVM (arg
defaults to 64). Then extend the KVM_IRQ_LINE test by injecting all
available SPIs at once (specified by the nr-irqs arg). As a bonus,
inject all SGIs at once as well.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../selftests/kvm/aarch64/arch_timer.c        |   2 +-
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 149 ++++++++++++++----
 .../selftests/kvm/include/aarch64/vgic.h      |   2 +-
 .../testing/selftests/kvm/lib/aarch64/vgic.c  |   9 +-
 4 files changed, 127 insertions(+), 35 deletions(-)

diff --git a/tools/testing/selftests/kvm/aarch64/arch_timer.c b/tools/testing/selftests/kvm/aarch64/arch_timer.c
index bf6a45b0b8dc..9ad38bd360a4 100644
--- a/tools/testing/selftests/kvm/aarch64/arch_timer.c
+++ b/tools/testing/selftests/kvm/aarch64/arch_timer.c
@@ -382,7 +382,7 @@ static struct kvm_vm *test_vm_create(void)
 
 	ucall_init(vm, NULL);
 	test_init_timer_irq(vm);
-	vgic_v3_setup(vm, nr_vcpus, GICD_BASE_GPA, GICR_BASE_GPA);
+	vgic_v3_setup(vm, nr_vcpus, 64, GICD_BASE_GPA, GICR_BASE_GPA);
 
 	/* Make all the test's cmdline args visible to the guest */
 	sync_global_to_guest(vm, test_args);
diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index f5d76fef22f0..0b89a29dfe79 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -23,6 +23,14 @@
 #define GICR_BASE_GPA		0x080A0000ULL
 #define VCPU_ID			0
 
+/*
+ * Stores the user specified args; it's passed to the guest and to every test
+ * function.
+ */
+struct test_args {
+	uint32_t nr_irqs; /* number of KVM supported IRQs. */
+};
+
 /*
  * KVM implements 32 priority levels:
  * 0x00 (highest priority) - 0xF8 (lowest priority), in steps of 8
@@ -51,14 +59,18 @@ typedef enum {
 
 struct kvm_inject_args {
 	kvm_inject_cmd cmd;
-	uint32_t intid;
+	uint32_t first_intid;
+	uint32_t num;
 };
 
 /* Used on the guest side to perform the hypercall. */
-static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t intid);
+static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t first_intid, uint32_t num);
 
 #define KVM_INJECT(cmd, intid)							\
-	kvm_inject_call(cmd, intid)
+	kvm_inject_call(cmd, intid, 1)
+
+#define KVM_INJECT_MULTI(cmd, intid, num)					\
+	kvm_inject_call(cmd, intid, num)
 
 /* Used on the host side to get the hypercall info. */
 static void kvm_inject_get_call(struct kvm_vm *vm, struct ucall *uc,
@@ -122,11 +134,12 @@ static void guest_irq_handler(struct ex_regs *regs)
 	GUEST_ASSERT(!gic_irq_get_pending(intid));
 }
 
-static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t intid)
+static void kvm_inject_call(kvm_inject_cmd cmd, uint32_t first_intid, uint32_t num)
 {
 	struct kvm_inject_args args = {
 		.cmd = cmd,
-		.intid = intid,
+		.first_intid = first_intid,
+		.num = num,
 	};
 	GUEST_SYNC(&args);
 }
@@ -138,14 +151,30 @@ do { 										\
 	GUEST_ASSERT(_intid == 0 || _intid == IAR_SPURIOUS);			\
 } while (0)
 
-static void guest_inject(uint32_t intid, kvm_inject_cmd cmd)
+static void reset_priorities(struct test_args *args)
+{
+	int i;
+
+	for (i = 0; i < args->nr_irqs; i++)
+		gic_set_priority(i, IRQ_DEFAULT_PRIO_REG);
+}
+
+static void guest_inject(struct test_args *args,
+		uint32_t first_intid, uint32_t num,
+		kvm_inject_cmd cmd)
 {
+	uint32_t i;
+
 	reset_stats();
 
+	/* Cycle over all priorities to make things more interesting. */
+	for (i = first_intid; i < num + first_intid; i++)
+		gic_set_priority(i, (i % (KVM_NUM_PRIOS - 1)) << 3);
+
 	asm volatile("msr daifset, #2" : : : "memory");
-	KVM_INJECT(cmd, intid);
+	KVM_INJECT_MULTI(cmd, first_intid, num);
 
-	while (irq_handled < 1) {
+	while (irq_handled < num) {
 		asm volatile("wfi\n"
 			     "msr daifclr, #2\n"
 			     /* handle IRQ */
@@ -154,57 +183,72 @@ static void guest_inject(uint32_t intid, kvm_inject_cmd cmd)
 	}
 	asm volatile("msr daifclr, #2" : : : "memory");
 
-	GUEST_ASSERT_EQ(irq_handled, 1);
-	GUEST_ASSERT_EQ(irqnr_received[intid], 1);
+	GUEST_ASSERT_EQ(irq_handled, num);
+	for (i = first_intid; i < num + first_intid; i++)
+		GUEST_ASSERT_EQ(irqnr_received[i], 1);
 	GUEST_ASSERT_IAR_EMPTY();
+
+	reset_priorities(args);
 }
 
-static void test_injection(struct kvm_inject_desc *f)
+static void test_injection(struct test_args *args, struct kvm_inject_desc *f)
 {
-	if (f->sgi)
-		guest_inject(MIN_SGI, f->cmd);
+	uint32_t nr_irqs = args->nr_irqs;
+
+	if (f->sgi) {
+		guest_inject(args, MIN_SGI, 1, f->cmd);
+		guest_inject(args, 0, 16, f->cmd);
+	}
 
 	if (f->ppi)
-		guest_inject(MIN_PPI, f->cmd);
+		guest_inject(args, MIN_PPI, 1, f->cmd);
 
-	if (f->spi)
-		guest_inject(MIN_SPI, f->cmd);
+	if (f->spi) {
+		guest_inject(args, MIN_SPI, 1, f->cmd);
+		guest_inject(args, nr_irqs - 1, 1, f->cmd);
+		guest_inject(args, MIN_SPI, nr_irqs - MIN_SPI, f->cmd);
+	}
 }
 
-static void guest_code(void)
+static void guest_code(struct test_args args)
 {
-	uint32_t i;
-	uint32_t nr_irqs = 64; /* absolute minimum number of IRQs supported. */
+	uint32_t i, nr_irqs = args.nr_irqs;
 	struct kvm_inject_desc *f;
 
 	gic_init(GIC_V3, 1, dist, redist);
 
-	for (i = 0; i < nr_irqs; i++) {
+	for (i = 0; i < nr_irqs; i++)
 		gic_irq_enable(i);
-		gic_set_priority(i, IRQ_DEFAULT_PRIO_REG);
-	}
 
+	reset_priorities(&args);
 	gic_set_priority_mask(CPU_PRIO_MASK);
 
 	local_irq_enable();
 
 	/* Start the tests. */
 	for_each_inject_fn(inject_edge_fns, f)
-		test_injection(f);
+		test_injection(&args, f);
 
 	GUEST_DONE();
 }
 
 static void run_guest_cmd(struct kvm_vm *vm, int gic_fd,
-		struct kvm_inject_args *inject_args)
+		struct kvm_inject_args *inject_args,
+		struct test_args *test_args)
 {
 	kvm_inject_cmd cmd = inject_args->cmd;
-	uint32_t intid = inject_args->intid;
+	uint32_t intid = inject_args->first_intid;
+	uint32_t num = inject_args->num;
+	uint32_t i;
+
+	assert(intid < UINT_MAX - num);
 
 	switch (cmd) {
 	case KVM_INJECT_EDGE_IRQ_LINE:
-		kvm_arm_irq_line(vm, intid, 1);
-		kvm_arm_irq_line(vm, intid, 0);
+		for (i = intid; i < intid + num; i++)
+			kvm_arm_irq_line(vm, i, 1);
+		for (i = intid; i < intid + num; i++)
+			kvm_arm_irq_line(vm, i, 0);
 		break;
 	default:
 		break;
@@ -222,21 +266,35 @@ static void kvm_inject_get_call(struct kvm_vm *vm, struct ucall *uc,
 	memcpy(args, kvm_args_hva, sizeof(struct kvm_inject_args));
 }
 
+static void print_args(struct test_args *args)
+{
+	printf("nr-irqs=%d\n", args->nr_irqs);
+}
 
-static void test_vgic(void)
+static void test_vgic(uint32_t nr_irqs)
 {
 	struct ucall uc;
 	int gic_fd;
 	struct kvm_vm *vm;
 	struct kvm_inject_args inject_args;
 
+	struct test_args args = {
+		.nr_irqs = nr_irqs,
+	};
+
+	print_args(&args);
+
 	vm = vm_create_default(VCPU_ID, 0, guest_code);
 	ucall_init(vm, NULL);
 
 	vm_init_descriptor_tables(vm);
 	vcpu_init_descriptor_tables(vm, VCPU_ID);
 
-	gic_fd = vgic_v3_setup(vm, 1, GICD_BASE_GPA, GICR_BASE_GPA);
+	/* Setup the guest args page (so it gets the args). */
+	vcpu_args_set(vm, 0, 1, args);
+
+	gic_fd = vgic_v3_setup(vm, 1, nr_irqs,
+			GICD_BASE_GPA, GICR_BASE_GPA);
 
 	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT,
 			guest_irq_handler);
@@ -247,7 +305,7 @@ static void test_vgic(void)
 		switch (get_ucall(vm, VCPU_ID, &uc)) {
 		case UCALL_SYNC:
 			kvm_inject_get_call(vm, &uc, &inject_args);
-			run_guest_cmd(vm, gic_fd, &inject_args);
+			run_guest_cmd(vm, gic_fd, &inject_args, &args);
 			break;
 		case UCALL_ABORT:
 			TEST_FAIL("%s at %s:%ld\n\tvalues: %#lx, %#lx",
@@ -266,12 +324,39 @@ static void test_vgic(void)
 	kvm_vm_free(vm);
 }
 
-int main(int ac, char **av)
+static void help(const char *name)
 {
+	printf(
+	"\n"
+	"usage: %s [-n num_irqs]\n", name);
+	printf(" -n: specify the number of IRQs to configure the vgic with.\n");
+	puts("");
+	exit(1);
+}
+
+int main(int argc, char **argv)
+{
+	uint32_t nr_irqs = 64;
+	int opt;
+
 	/* Tell stdout not to buffer its content */
 	setbuf(stdout, NULL);
 
-	test_vgic();
+	while ((opt = getopt(argc, argv, "hg:n:")) != -1) {
+		switch (opt) {
+		case 'n':
+			nr_irqs = atoi(optarg);
+			if (nr_irqs > 1024 || nr_irqs % 32)
+				help(argv[0]);
+			break;
+		case 'h':
+		default:
+			help(argv[0]);
+			break;
+		}
+	}
+
+	test_vgic(nr_irqs);
 
 	return 0;
 }
diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
index ec8744bb2d4b..ce6f0383c1a1 100644
--- a/tools/testing/selftests/kvm/include/aarch64/vgic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
@@ -14,7 +14,7 @@
 	((uint64_t)(flags) << 12) | \
 	index)
 
-int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
+int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
 		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa);
 
 #define VGIC_MAX_RESERVED	1023
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
index a1f1f6c8e2e0..84206d7c92b4 100644
--- a/tools/testing/selftests/kvm/lib/aarch64/vgic.c
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -31,7 +31,7 @@
  * redistributor regions of the guest. Since it depends on the number of
  * vCPUs for the VM, it must be called after all the vCPUs have been created.
  */
-int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
+int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus, uint32_t nr_irqs,
 		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
 {
 	int gic_fd;
@@ -53,6 +53,13 @@ int vgic_v3_setup(struct kvm_vm *vm, unsigned int nr_vcpus,
 
 	/* Distributor setup */
 	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+
+	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_NR_IRQS,
+			0, &nr_irqs, true);
+
+	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+			KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+
 	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
 			KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd_base_gpa, true);
 	nr_gic_pages = vm_calc_num_guest_pages(vm->mode, KVM_VGIC_V3_DIST_SIZE);
-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
