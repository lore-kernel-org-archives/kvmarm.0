Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81242C4332F
	for <kvmarm@archiver.kernel.org>; Mon, 14 Mar 2022 06:23:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AF7C40C52;
	Mon, 14 Mar 2022 02:23:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id W+RVz6FAg4cE; Mon, 14 Mar 2022 02:23:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D730040C31;
	Mon, 14 Mar 2022 02:23:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0083040C31
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 02:23:34 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id w5xUFehpVAn0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 14 Mar 2022 02:23:32 -0400 (EDT)
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com
 [209.85.215.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id ADAC840BFA
 for <kvmarm@lists.cs.columbia.edu>; Mon, 14 Mar 2022 02:23:32 -0400 (EDT)
Received: by mail-pg1-f201.google.com with SMTP id
 h12-20020a63530c000000b0037c8f45bf1bso9469909pgb.7
 for <kvmarm@lists.cs.columbia.edu>; Sun, 13 Mar 2022 23:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=EHwG8z9qnaxk4PwPg/y1XhImE75YdLJJtdToy35TxYQ=;
 b=AgveOScDL5C+JmoOWNfZdXIr+k0OoiMS61XY+BfsRGafjJsXlZoaguSmJHInVI97yC
 9Yx8Z2Ta44jLVtwJW8PDucEAxrh7PrClBxFj/FHighe7/VKifa0KEg0R9xIt+hQnZPCZ
 XkcAw3GREZx6ufqyP5e4/zsrX/18Lnb8IcY3daUkAj3I4QlMqPUdAaNRIqBMT6031z4b
 veAOwiGAslwWrxpDyh2O5lL6TKBVcnnwgmFOzuO9/5OcS6PKGj/IehUoLsKDicGK2kTZ
 OulfErexfbXsJRnW+nS+GylGVpgXmzbwowDHsF0+5vjqWYRxJ+24nv48VfwYJu8Ik0jc
 Iy8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=EHwG8z9qnaxk4PwPg/y1XhImE75YdLJJtdToy35TxYQ=;
 b=Rs8k5UiaTuwedYBmLvHPK2DAiIaAUPPKh7XqmtfPvxOfvMuRae+JA87Bb37MD/AYIy
 4wP2++icbKB6zsGn1JKf9Qc07YtEQdQoPwtZwXmaWT3/Q2kX4lSuJcuQHU2TSc5yEnkW
 HS8GohxILuLRTDsC+XA0MiWdLcjp01EMPJyHHwrs+x0Y1zOxiAZJgOenWywVCV7FoMeJ
 CvQLtqdJAQNVyIZmmqSkd8kt9vq0uqpVnJWHpauk7fhf8Sjp2OLPgKbP3l34R1OU2fQF
 dBW0ARTI6/AO8o07GgHNiesBu+xbO6LwKSrxBtPUvqPraG46a/Cmife0ku2MrN+TS201
 M8jw==
X-Gm-Message-State: AOAM531WLY+wHtuDf+Tn3a7GS1Q0cY4IQCQeNsfZg79kgGBWkRujmhBe
 +LvYRmqNf/JR3SqvZmj+rVBYDzSoYO0=
X-Google-Smtp-Source: ABdhPJxa+hH3/rRGFjoKdLzOtEdTBO958Iu6JmsKf4sHZ4Y9siscygzFD6vJtYfoq4QeZARAWOYmjOePjrw=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a17:90a:4590:b0:1bc:4afa:1778 with SMTP id
 v16-20020a17090a459000b001bc4afa1778mr34562775pjg.14.1647239011762; Sun, 13
 Mar 2022 23:23:31 -0700 (PDT)
Date: Sun, 13 Mar 2022 23:19:59 -0700
In-Reply-To: <20220314061959.3349716-1-reijiw@google.com>
Message-Id: <20220314061959.3349716-4-reijiw@google.com>
Mime-Version: 1.0
References: <20220314061959.3349716-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v4 3/3] KVM: arm64: selftests: Introduce vcpu_width_config
From: Reiji Watanabe <reijiw@google.com>
To: Marc Zyngier <maz@kernel.org>, kvmarm@lists.cs.columbia.edu
Cc: kvm@vger.kernel.org, Will Deacon <will@kernel.org>,
 Peter Shier <pshier@google.com>, Paolo Bonzini <pbonzini@redhat.com>,
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

Introduce a test for aarch64 that ensures non-mixed-width vCPUs
(all 64bit vCPUs or all 32bit vcPUs) can be configured, and
mixed-width vCPUs cannot be configured.

Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Reiji Watanabe <reijiw@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/vcpu_width_config.c | 125 ++++++++++++++++++
 3 files changed, 127 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/vcpu_width_config.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index dce7de7755e6..4e884e29b2a8 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -3,6 +3,7 @@
 /aarch64/debug-exceptions
 /aarch64/get-reg-list
 /aarch64/psci_cpu_on_test
+/aarch64/vcpu_width_config
 /aarch64/vgic_init
 /aarch64/vgic_irq
 /s390x/memop
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 17c3f0749f05..3482586c6e33 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -103,6 +103,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
+TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
 TEST_GEN_PROGS_aarch64 += demand_paging_test
diff --git a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
new file mode 100644
index 000000000000..6e6e6a9f69e3
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
@@ -0,0 +1,125 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * vcpu_width_config - Test KVM_ARM_VCPU_INIT() with KVM_ARM_VCPU_EL1_32BIT.
+ *
+ * Copyright (c) 2022 Google LLC.
+ *
+ * This is a test that ensures that non-mixed-width vCPUs (all 64bit vCPUs
+ * or all 32bit vcPUs) can be configured and mixed-width vCPUs cannot be
+ * configured.
+ */
+
+#define _GNU_SOURCE
+
+#include "kvm_util.h"
+#include "processor.h"
+#include "test_util.h"
+
+
+/*
+ * Add a vCPU, run KVM_ARM_VCPU_INIT with @init1, and then
+ * add another vCPU, and run KVM_ARM_VCPU_INIT with @init2.
+ */
+static int add_init_2vcpus(struct kvm_vcpu_init *init1,
+			   struct kvm_vcpu_init *init2)
+{
+	struct kvm_vm *vm;
+	int ret;
+
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+
+	vm_vcpu_add(vm, 0);
+	ret = _vcpu_ioctl(vm, 0, KVM_ARM_VCPU_INIT, init1);
+	if (ret)
+		goto free_exit;
+
+	vm_vcpu_add(vm, 1);
+	ret = _vcpu_ioctl(vm, 1, KVM_ARM_VCPU_INIT, init2);
+
+free_exit:
+	kvm_vm_free(vm);
+	return ret;
+}
+
+/*
+ * Add two vCPUs, then run KVM_ARM_VCPU_INIT for one vCPU with @init1,
+ * and run KVM_ARM_VCPU_INIT for another vCPU with @init2.
+ */
+static int add_2vcpus_init_2vcpus(struct kvm_vcpu_init *init1,
+				  struct kvm_vcpu_init *init2)
+{
+	struct kvm_vm *vm;
+	int ret;
+
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+
+	vm_vcpu_add(vm, 0);
+	vm_vcpu_add(vm, 1);
+
+	ret = _vcpu_ioctl(vm, 0, KVM_ARM_VCPU_INIT, init1);
+	if (ret)
+		goto free_exit;
+
+	ret = _vcpu_ioctl(vm, 1, KVM_ARM_VCPU_INIT, init2);
+
+free_exit:
+	kvm_vm_free(vm);
+	return ret;
+}
+
+/*
+ * Tests that two 64bit vCPUs can be configured, two 32bit vCPUs can be
+ * configured, and two mixed-witgh vCPUs cannot be configured.
+ * Each of those three cases, configure vCPUs in two different orders.
+ * The one is running KVM_CREATE_VCPU for 2 vCPUs, and then running
+ * KVM_ARM_VCPU_INIT for them.
+ * The other is running KVM_CREATE_VCPU and KVM_ARM_VCPU_INIT for a vCPU,
+ * and then run those commands for another vCPU.
+ */
+int main(void)
+{
+	struct kvm_vcpu_init init1, init2;
+	struct kvm_vm *vm;
+	int ret;
+
+	if (kvm_check_cap(KVM_CAP_ARM_EL1_32BIT) <= 0) {
+		print_skip("KVM_CAP_ARM_EL1_32BIT is not supported");
+		exit(KSFT_SKIP);
+	}
+
+	/* Get the preferred target type and copy that to init2 */
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init1);
+	kvm_vm_free(vm);
+	memcpy(&init2, &init1, sizeof(init2));
+
+	/* Test with 64bit vCPUs */
+	ret = add_init_2vcpus(&init1, &init2);
+	TEST_ASSERT(ret == 0,
+		    "Configuring 64bit EL1 vCPUs failed unexpectedly");
+	ret = add_2vcpus_init_2vcpus(&init1, &init2);
+	TEST_ASSERT(ret == 0,
+		    "Configuring 64bit EL1 vCPUs failed unexpectedly");
+
+	/* Test with 32bit vCPUs */
+	init1.features[0] = (1 << KVM_ARM_VCPU_EL1_32BIT);
+	init2.features[0] = (1 << KVM_ARM_VCPU_EL1_32BIT);
+	ret = add_init_2vcpus(&init1, &init2);
+	TEST_ASSERT(ret == 0,
+		    "Configuring 32bit EL1 vCPUs failed unexpectedly");
+	ret = add_2vcpus_init_2vcpus(&init1, &init2);
+	TEST_ASSERT(ret == 0,
+		    "Configuring 32bit EL1 vCPUs failed unexpectedly");
+
+	/* Test with mixed-width vCPUs  */
+	init1.features[0] = 0;
+	init2.features[0] = (1 << KVM_ARM_VCPU_EL1_32BIT);
+	ret = add_init_2vcpus(&init1, &init2);
+	TEST_ASSERT(ret != 0,
+		    "Configuring mixed-width vCPUs worked unexpectedly");
+	ret = add_2vcpus_init_2vcpus(&init1, &init2);
+	TEST_ASSERT(ret != 0,
+		    "Configuring mixed-width vCPUs worked unexpectedly");
+
+	return 0;
+}
-- 
2.35.1.723.g4982287a31-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
