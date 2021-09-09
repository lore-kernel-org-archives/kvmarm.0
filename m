Return-Path: <SRS0=JP/k=N7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 017B4C433FE
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 01:39:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id A749761167
	for <kvmarm@archiver.kernel.org>; Thu,  9 Sep 2021 01:39:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A749761167
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5BC004B105;
	Wed,  8 Sep 2021 21:39:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 0O5NV5i7JKow; Wed,  8 Sep 2021 21:39:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0DA2A4029C;
	Wed,  8 Sep 2021 21:39:01 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B35084A531
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 21:38:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WoTo57z+G+cS for <kvmarm@lists.cs.columbia.edu>;
 Wed,  8 Sep 2021 21:38:58 -0400 (EDT)
Received: from mail-yb1-f201.google.com (mail-yb1-f201.google.com
 [209.85.219.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 670B94B105
 for <kvmarm@lists.cs.columbia.edu>; Wed,  8 Sep 2021 21:38:58 -0400 (EDT)
Received: by mail-yb1-f201.google.com with SMTP id
 f64-20020a2538430000b0290593bfc4b046so406487yba.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 08 Sep 2021 18:38:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=dIO3bJcCcsJgj6H+C/RQ54N/wYHZAN3qawTcM2QNEMU=;
 b=WtlxqIExWluJ+gz3G6WEWAJzwZNCrMqhj5uBzg+xL/0WIZa269+Ew1WjzrCRnky+VI
 l2fHKBclWRDqYu1p9iZ9x90cpra2Cxsqf2uJ8DF+QDwgjr49JF87QoRS79Xm5b7d8r/G
 jxdZJLYeyEAFvDE2cXVgoG1gzo48wFTY5bo5OjeZ428FWDEk5b4Dlh4sA9OGeafsBrO5
 mtBws12nX15l8HW/5vnVYsxSk1msKZLZP2POGVnXE7bm5MS/fPerK+jPhYug8xUe4550
 hBr3NgA+jQ9uCAfH1tuYjzsKTAon8Y7Ou4hFOAQ9UVOZqqgxFp3gU2wNjKuYz3mIHK1q
 vHvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=dIO3bJcCcsJgj6H+C/RQ54N/wYHZAN3qawTcM2QNEMU=;
 b=mKUyKSMDMh0XG6IpExEOJUnSjVvhnq9nCmLv5ux77DP2VXW8aIkNxnc5F758kONCUr
 IjRHPJpc2TLpI3+ryvmwifX0uCISmLj/MQSbjq8KbDca4lR34RtuTN98rPgr60RmyA0y
 kBsvheQWlDOUY9BtZAEwp65G2s73RzjF5mh+42EI+xD30k4R0aipyJ+ywwDwH3nniido
 V6alagMwrAeh/X3xANaft30JRYrpk7oxRxCgNno17CsrCsvaIFm/51HKYfygRcqgmLy3
 cx+q/8497y9VPAF141cFqaXxnvwpLdX1fisVT/9PAM8hXrtNoucyDj7RSANEqK1cHHso
 3WCg==
X-Gm-Message-State: AOAM5329FlzS02vyRhGyfIOXG4glo1tw4r1cIFmfQbGiQ7dvyTAJix/Z
 ni3w7hwkz40vMLqZZx7TcjD/C/wNHBLU
X-Google-Smtp-Source: ABdhPJw3lyrZigZ0lyqnRcsV8MPIT9rXCF3qEygV0fl3otkVWKB+0GuwV1S2Fc90Bg6qc71tsxnR6E+M/WtZ
X-Received: from rananta-virt.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:1bcc])
 (user=rananta job=sendgmr) by 2002:a25:c0c1:: with SMTP id
 c184mr542320ybf.382.1631151538010; Wed, 08 Sep 2021 18:38:58 -0700 (PDT)
Date: Thu,  9 Sep 2021 01:38:14 +0000
In-Reply-To: <20210909013818.1191270-1-rananta@google.com>
Message-Id: <20210909013818.1191270-15-rananta@google.com>
Mime-Version: 1.0
References: <20210909013818.1191270-1-rananta@google.com>
X-Mailer: git-send-email 2.33.0.153.gba50c8fa24-goog
Subject: [PATCH v4 14/18] KVM: arm64: selftests: Add host support for vGIC
From: Raghavendra Rao Ananta <rananta@google.com>
To: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <maz@kernel.org>, 
 Andrew Jones <drjones@redhat.com>, James Morse <james.morse@arm.com>, 
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
 Peter Shier <pshier@google.com>, linux-kernel@vger.kernel.org,
 Will Deacon <will@kernel.org>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

Implement a simple library to perform vGIC-v3 setup
from a host point of view. This includes creating a
vGIC device, setting up distributor and redistributor
attributes, and mapping the guest physical addresses.

The definition of REDIST_REGION_ATTR_ADDR is taken
from aarch64/vgic_init test.

Signed-off-by: Raghavendra Rao Ananta <rananta@google.com>
---
 tools/testing/selftests/kvm/Makefile          |  2 +-
 .../selftests/kvm/include/aarch64/vgic.h      | 20 +++++++
 .../testing/selftests/kvm/lib/aarch64/vgic.c  | 60 +++++++++++++++++++
 3 files changed, 81 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/kvm/include/aarch64/vgic.h
 create mode 100644 tools/testing/selftests/kvm/lib/aarch64/vgic.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 5476a8ddef60..8342f65c1d96 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -35,7 +35,7 @@ endif
 
 LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
 LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
-LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c
+LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c lib/aarch64/vgic.c
 LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
 
 TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
diff --git a/tools/testing/selftests/kvm/include/aarch64/vgic.h b/tools/testing/selftests/kvm/include/aarch64/vgic.h
new file mode 100644
index 000000000000..3a776af958a0
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/aarch64/vgic.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/*
+ * ARM Generic Interrupt Controller (GIC) host specific defines
+ */
+
+#ifndef SELFTEST_KVM_VGIC_H
+#define SELFTEST_KVM_VGIC_H
+
+#include <linux/kvm.h>
+
+#define REDIST_REGION_ATTR_ADDR(count, base, flags, index) \
+	(((uint64_t)(count) << 52) | \
+	((uint64_t)((base) >> 16) << 16) | \
+	((uint64_t)(flags) << 12) | \
+	index)
+
+int vgic_v3_setup(struct kvm_vm *vm,
+				uint64_t gicd_base_gpa, uint64_t gicr_base_gpa);
+
+#endif /* SELFTEST_KVM_VGIC_H */
diff --git a/tools/testing/selftests/kvm/lib/aarch64/vgic.c b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
new file mode 100644
index 000000000000..2318912ab134
--- /dev/null
+++ b/tools/testing/selftests/kvm/lib/aarch64/vgic.c
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ARM Generic Interrupt Controller (GIC) v3 host support
+ */
+
+#include <linux/kvm.h>
+#include <linux/sizes.h>
+
+#include "kvm_util.h"
+#include "vgic.h"
+
+#define VGIC_V3_GICD_SZ		(SZ_64K)
+#define VGIC_V3_GICR_SZ		(2 * SZ_64K)
+
+/*
+ * vGIC-v3 default host setup
+ *
+ * Input args:
+ *	vm - KVM VM
+ *	gicd_base_gpa - Guest Physical Address of the Distributor region
+ *	gicr_base_gpa - Guest Physical Address of the Redistributor region
+ *
+ * Output args: None
+ *
+ * Return: GIC file-descriptor or negative error code upon failure
+ *
+ * The function creates a vGIC-v3 device and maps the distributor and
+ * redistributor regions of the guest. Since it depends on the number of
+ * vCPUs for the VM, it must be called after all the vCPUs have been created.
+ */
+int vgic_v3_setup(struct kvm_vm *vm,
+		uint64_t gicd_base_gpa, uint64_t gicr_base_gpa)
+{
+	uint64_t redist_attr;
+	int gic_fd, nr_vcpus;
+	unsigned int nr_gic_pages;
+
+	nr_vcpus = vm_get_nr_vcpus(vm);
+	TEST_ASSERT(nr_vcpus > 0, "Invalid number of CPUs: %u\n", nr_vcpus);
+
+	/* Distributor setup */
+	gic_fd = kvm_create_device(vm, KVM_DEV_TYPE_ARM_VGIC_V3, false);
+	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			KVM_VGIC_V3_ADDR_TYPE_DIST, &gicd_base_gpa, true);
+	nr_gic_pages = vm_calc_num_guest_pages(vm_get_mode(vm), VGIC_V3_GICD_SZ);
+	virt_map(vm, gicd_base_gpa, gicd_base_gpa,  nr_gic_pages);
+
+	/* Redistributor setup */
+	redist_attr = REDIST_REGION_ATTR_ADDR(nr_vcpus, gicr_base_gpa, 0, 0);
+	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_ADDR,
+			KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION, &redist_attr, true);
+	nr_gic_pages = vm_calc_num_guest_pages(vm_get_mode(vm),
+						VGIC_V3_GICR_SZ * nr_vcpus);
+	virt_map(vm, gicr_base_gpa, gicr_base_gpa,  nr_gic_pages);
+
+	kvm_device_access(gic_fd, KVM_DEV_ARM_VGIC_GRP_CTRL,
+				KVM_DEV_ARM_VGIC_CTRL_INIT, NULL, true);
+
+	return gic_fd;
+}
-- 
2.33.0.153.gba50c8fa24-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
