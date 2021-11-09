Return-Path: <SRS0=lFky=P4=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B6E1C433EF
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:48 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id C3999619E4
	for <kvmarm@archiver.kernel.org>; Tue,  9 Nov 2021 02:39:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C3999619E4
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 75C2E4B24E;
	Mon,  8 Nov 2021 21:39:47 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id AmPeToIjMIKF; Mon,  8 Nov 2021 21:39:45 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A2CA84B22B;
	Mon,  8 Nov 2021 21:39:43 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7FD324B216
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:42 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GZ8aKQvgC2vE for <kvmarm@lists.cs.columbia.edu>;
 Mon,  8 Nov 2021 21:39:40 -0500 (EST)
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com
 [209.85.214.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D222A4B227
 for <kvmarm@lists.cs.columbia.edu>; Mon,  8 Nov 2021 21:39:37 -0500 (EST)
Received: by mail-pl1-f201.google.com with SMTP id
 o8-20020a170902d4c800b001424abc88f3so3433788plg.2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 08 Nov 2021 18:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=igtNCs/EdQGdJFkd8S66UsbWC4E3b2XpCSh4teAekRY=;
 b=i0neKE5eIA9O5ihA63SgrJVllahwMqAEv84n9PQafp4I0majIgaxlX1lRfZvQ+2FoR
 QyVP4CWlFmpXrVz0MJbXjL+XiLNgeESeqzmx25UAylf/rQR6VOCcPlG89XgloRKpXKtR
 Ru0D4STMeW1qfxMv+sq6DYdEE/9zM0l0ja13ZOpwq4gzLIqVZQRYMy6ZOjod6u8KQeQw
 nGhUkO9jziaFFKhjDky63H7nCUNFnm/S9elbn0fZO3bTV/z2TZSpuXhR5j5sMAPmwsyX
 x9sB55tWOsIa3Oyz/YBp5VmY2dI3STwUJk0HjAfCVXw8jPxSccxoR0sxxSyJc2SnHxHC
 H+kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=igtNCs/EdQGdJFkd8S66UsbWC4E3b2XpCSh4teAekRY=;
 b=Hc7ZIvUHp817JEHQ8QeKd/Bs8mp+a/C+WmOeayWqAf2D4cecCUVgawVyS/3uMXAM+4
 NAUAMOmEZbh1zVg883crcS2xq97v9iyWTBSSQvga91D7ToudWgyzFmzIrJT/yEjfjf5C
 VUGNWaL79y32uqqNcN6o65TEOJJTF/bXciXJy1Gi4+a9CoSTsRaeu776UJNjs2SJQHLw
 j9MRPkvV+S94kNVxX0+kxux6aJZ0HOmIziRnSwuOMtBK7F35SsUKsDclecaAQlbmx1UN
 O2bhHLJX80CAGt3MaHReTck+uVsNXABplsFlvdravuVjLdIFWa8M2BRiCqjBVDstm+lD
 98vQ==
X-Gm-Message-State: AOAM530sFAG7D/urCk9tSaFX1MK3J3VcCpOhw0s4ayUR7KZ+LgonMav+
 4CdN1uiEFSvhgxV2wudnxO0Xi+QCCi3WQg==
X-Google-Smtp-Source: ABdhPJwpIp4nej4Ka3+5nbnKShwE7lHQyfASuzjkFE1r2avt/z5DkQiTZ2DJ4QZBJfdyPR07SFtRnf1BQiFExA==
X-Received: from ricarkol2.c.googlers.com
 ([fda3:e722:ac3:cc00:24:72f4:c0a8:62fe])
 (user=ricarkol job=sendgmr) by 2002:a17:903:1207:b0:13d:b9b1:ead7 with SMTP
 id l7-20020a170903120700b0013db9b1ead7mr3940753plh.63.1636425577086; Mon, 08
 Nov 2021 18:39:37 -0800 (PST)
Date: Mon,  8 Nov 2021 18:39:04 -0800
In-Reply-To: <20211109023906.1091208-1-ricarkol@google.com>
Message-Id: <20211109023906.1091208-16-ricarkol@google.com>
Mime-Version: 1.0
References: <20211109023906.1091208-1-ricarkol@google.com>
X-Mailer: git-send-email 2.34.0.rc0.344.g81b53c2807-goog
Subject: [PATCH 15/17] KVM: selftests: aarch64: add tests for IRQFD in vgic_irq
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

Add injection tests for the KVM_IRQFD ioctl into vgic_irq.

Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 .../testing/selftests/kvm/aarch64/vgic_irq.c  | 101 +++++++++++++++++-
 .../selftests/kvm/include/aarch64/vgic.h      |   2 +
 2 files changed, 102 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/kvm/aarch64/vgic_irq.c b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
index 9f1674b3a45c..121113f24ed3 100644
--- a/tools/testing/selftests/kvm/aarch64/vgic_irq.c
+++ b/tools/testing/selftests/kvm/aarch64/vgic_irq.c
@@ -10,6 +10,7 @@
 
 #include <asm/kvm.h>
 #include <asm/kvm_para.h>
+#include <sys/eventfd.h>
 #include <linux/sizes.h>
 
 #include "processor.h"
@@ -31,6 +32,8 @@ struct test_args {
 	uint32_t nr_irqs; /* number of KVM supported IRQs. */
 	bool eoi_split; /* 1 is eoir+dir, 0 is eoir only */
 	bool level_sensitive; /* 1 is level, 0 is edge */
+	int kvm_max_routes; /* output of KVM_CAP_IRQ_ROUTING */
+	bool kvm_supports_irqfd; /* output of KVM_CAP_IRQFD */
 };
 
 /*
@@ -61,6 +64,7 @@ typedef enum {
 	KVM_SET_IRQ_LINE,
 	KVM_SET_IRQ_LINE_HIGH,
 	KVM_SET_LEVEL_INFO_HIGH,
+	KVM_INJECT_IRQFD,
 } kvm_inject_cmd;
 
 struct kvm_inject_args {
@@ -100,6 +104,7 @@ struct kvm_inject_desc {
 static struct kvm_inject_desc inject_edge_fns[] = {
 	/*                                      sgi    ppi    spi */
 	{ KVM_INJECT_EDGE_IRQ_LINE,		false, false, true },
+	{ KVM_INJECT_IRQFD,			false, false, true },
 	{ 0, },
 };
 
@@ -107,12 +112,17 @@ static struct kvm_inject_desc inject_level_fns[] = {
 	/*                                      sgi    ppi    spi */
 	{ KVM_SET_IRQ_LINE_HIGH,		false, true,  true },
 	{ KVM_SET_LEVEL_INFO_HIGH,		false, true,  true },
+	{ KVM_INJECT_IRQFD,			false, false, true },
 	{ 0, },
 };
 
 #define for_each_inject_fn(t, f)						\
 	for ((f) = (t); (f)->cmd; (f)++)
 
+#define for_each_supported_inject_fn(args, t, f)				\
+	for_each_inject_fn(t, f)						\
+		if ((args)->kvm_supports_irqfd || (f)->cmd != KVM_INJECT_IRQFD)
+
 /* Shared between the guest main thread and the IRQ handlers. */
 volatile uint64_t irq_handled;
 volatile uint32_t irqnr_received[MAX_SPI + 1];
@@ -403,7 +413,7 @@ static void guest_code(struct test_args args)
 	local_irq_enable();
 
 	/* Start the tests. */
-	for_each_inject_fn(inject_fns, f) {
+	for_each_supported_inject_fn(&args, inject_fns, f) {
 		test_injection(&args, f);
 		test_preemption(&args, f);
 		test_injection_failure(&args, f);
@@ -455,6 +465,88 @@ void kvm_irq_set_level_info_check(int gic_fd, uint32_t intid, int level,
 	}
 }
 
+static void kvm_set_gsi_routing_irqchip_check(struct kvm_vm *vm,
+		uint32_t intid, uint32_t num, uint32_t kvm_max_routes,
+		bool expect_failure)
+{
+	struct kvm_irq_routing *routing;
+	int ret;
+	uint64_t i;
+
+	assert(num <= kvm_max_routes && kvm_max_routes <= KVM_MAX_IRQ_ROUTES);
+
+	routing = kvm_gsi_routing_create();
+	for (i = intid; i < (uint64_t)intid + num; i++)
+		kvm_gsi_routing_irqchip_add(routing, i - MIN_SPI, i - MIN_SPI);
+
+	if (!expect_failure) {
+		kvm_gsi_routing_write(vm, routing);
+	} else {
+		ret = _kvm_gsi_routing_write(vm, routing);
+		/* The kernel only checks for KVM_IRQCHIP_NUM_PINS. */
+		if (intid >= KVM_IRQCHIP_NUM_PINS)
+			TEST_ASSERT(ret != 0 && errno == EINVAL,
+				"Bad intid %u did not cause KVM_SET_GSI_ROUTING "
+				"error: rc: %i errno: %i", intid, ret, errno);
+		else
+			TEST_ASSERT(ret == 0, "KVM_SET_GSI_ROUTING "
+				"for intid %i failed, rc: %i errno: %i",
+				intid, ret, errno);
+	}
+}
+
+static void kvm_routing_and_irqfd_check(struct kvm_vm *vm,
+		uint32_t intid, uint32_t num, uint32_t kvm_max_routes,
+		bool expect_failure)
+{
+	int fd[MAX_SPI];
+	uint64_t val;
+	int ret, f;
+	uint64_t i;
+
+	/*
+	 * There is no way to try injecting an SGI or PPI as the interface
+	 * starts counting from the first SPI (above the private ones), so just
+	 * exit.
+	 */
+	if (INTID_IS_SGI(intid) || INTID_IS_PPI(intid))
+		return;
+
+	kvm_set_gsi_routing_irqchip_check(vm, intid, num,
+			kvm_max_routes, expect_failure);
+
+	/*
+	 * If expect_failure, then just to inject anyway. These
+	 * will silently fail. And in any case, the guest will check
+	 * that no actual interrupt was injected for those cases.
+	 */
+
+	for (f = 0, i = intid; i < (uint64_t)intid + num; i++, f++) {
+		fd[f] = eventfd(0, 0);
+		TEST_ASSERT(fd[f] != -1,
+			"eventfd failed, errno: %i\n", errno);
+	}
+
+	for (f = 0, i = intid; i < (uint64_t)intid + num; i++, f++) {
+		struct kvm_irqfd irqfd = {
+			.fd  = fd[f],
+			.gsi = i - MIN_SPI,
+		};
+		assert(i <= (uint64_t)UINT_MAX);
+		vm_ioctl(vm, KVM_IRQFD, &irqfd);
+	}
+
+	for (f = 0, i = intid; i < (uint64_t)intid + num; i++, f++) {
+		val = 1;
+		ret = write(fd[f], &val, sizeof(uint64_t));
+		TEST_ASSERT(ret == sizeof(uint64_t),
+			"Write to KVM_IRQFD failed with ret: %d\n", ret);
+	}
+
+	for (f = 0, i = intid; i < (uint64_t)intid + num; i++, f++)
+		close(fd[f]);
+}
+
 /* handles the valid case: intid=0xffffffff num=1 */
 #define for_each_intid(first, num, tmp, i)					\
 	for ((tmp) = (i) = (first);						\
@@ -500,6 +592,11 @@ static void run_guest_cmd(struct kvm_vm *vm, int gic_fd,
 			kvm_irq_set_level_info_check(gic_fd, i, 1,
 					expect_failure);
 		break;
+	case KVM_INJECT_IRQFD:
+		kvm_routing_and_irqfd_check(vm, intid, num,
+					test_args->kvm_max_routes,
+					expect_failure);
+		break;
 	default:
 		break;
 	}
@@ -534,6 +631,8 @@ static void test_vgic(uint32_t nr_irqs, bool level_sensitive, bool eoi_split)
 		.nr_irqs = nr_irqs,
 		.level_sensitive = level_sensitive,
 		.eoi_split = eoi_split,
+		.kvm_max_routes = kvm_check_cap(KVM_CAP_IRQ_ROUTING),
+		.kvm_supports_irqfd = kvm_check_cap(KVM_CAP_IRQFD),
 	};
 
 	print_args(&args);
diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
index ce6f0383c1a1..4442081221a0 100644
--- a/tools/testing/selftests/kvm/include/aarch64/vgic.h
+++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
@@ -29,4 +29,6 @@ int _kvm_arm_irq_line(struct kvm_vm *vm, uint32_t intid, int level);
 void kvm_irq_write_ispendr(int gic_fd, uint32_t intid, uint32_t vcpu);
 void kvm_irq_write_isactiver(int gic_fd, uint32_t intid, uint32_t vcpu);
 
+#define KVM_IRQCHIP_NUM_PINS	(1020 - 32)
+
 #endif // SELFTEST_KVM_VGIC_H
-- 
2.34.0.rc0.344.g81b53c2807-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
