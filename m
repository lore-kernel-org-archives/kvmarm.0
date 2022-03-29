Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BE64C433F5
	for <kvmarm@archiver.kernel.org>; Tue, 29 Mar 2022 03:22:00 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DD0E84B1C3;
	Mon, 28 Mar 2022 23:21:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 9kIxEE8s7gOq; Mon, 28 Mar 2022 23:21:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 88BDB4B137;
	Mon, 28 Mar 2022 23:21:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D483B40D0B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 23:21:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eYC3qZv8SUpS for <kvmarm@lists.cs.columbia.edu>;
 Mon, 28 Mar 2022 23:21:56 -0400 (EDT)
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com
 [209.85.128.201])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 911974120D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 23:21:56 -0400 (EDT)
Received: by mail-yw1-f201.google.com with SMTP id
 00721157ae682-2e9ae7bd8deso84612437b3.9
 for <kvmarm@lists.cs.columbia.edu>; Mon, 28 Mar 2022 20:21:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20210112;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=7iMUePCdm48RwGI5QpprEBWmHvkOkE/Zq9CohlSdcbk=;
 b=QkJcDHwJyhURTxTUFsi16+avdBoFXNI12eZ6wczhcQrFCymIWWU+jQ5QVXcBJs6jiW
 jnU3t8qA58tAaUlnvILo3aHsjsWptm5+y295qLEna4IsoIroFzZVPhjZ+L2wlTyZ1f0t
 X1bDbupjs+GiokEVEG/awPbvpyN3hJcS64AbcNFpJ99wU9YtwlsIUMU8n6hMGTlvNvPb
 28l4aoCHpPBbGLVMrkRuZqcq4vs5tRwd6W+SFaWpicM0RDYvcUr2cTU7GgyYYTO8zlvE
 lp4hoeMaLf6aR2Mr2iRjS4pB+zj6+2EtjWc4MRpbrL26KCa7BG+/+8fCIyu5F7TmXAAT
 i2oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20210112;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=7iMUePCdm48RwGI5QpprEBWmHvkOkE/Zq9CohlSdcbk=;
 b=lu2h6n4cugBTsJQTuP98sdAimkeN+wQ9Sw8fjjRIK8U8Bm9oYlVV3iXF0Luq48c29Z
 uGCeOPVzivbZSFprhodBy61YKfkWH6dc9LAKtoyKofPBXTnHprQa6QVCqH/rNRuCLeHd
 nn1U5qO13xze+AmEmXGppri73sWlGLsFfL8kGuUHHHrwjolTzBFZ/V46u+eeKHxin01J
 31glXcezwfRkrdgK5JB/DV/0B8DG2bZ+ved1EWf0I3x10AJurQBF6aRD8ir1IpvaAyGw
 YXeqHgI6HZEgaatuIG101+zGym1qoahGlmdxLcKNMycHaoCP+Bs4hIYTkwsAytALHVCR
 1fWQ==
X-Gm-Message-State: AOAM532yyy44FzSIPOBQeARV5cr1aFUhSz0nMb7Pw/GJsd5EY71gubdR
 5HXYno3Bd7c+SdH7w2npMz0vxdHcxdw=
X-Google-Smtp-Source: ABdhPJxFsAU62XiTogfF9PaZsbu/nfGu6WWhivIcQYgbqiCjn/RjOeffXjytLV4Gi6o7okfa6fKzIw/q1yc=
X-Received: from reiji-vws-sp.c.googlers.com
 ([fda3:e722:ac3:cc00:7f:e700:c0a8:3d59])
 (user=reijiw job=sendgmr) by 2002:a25:a0c5:0:b0:633:63da:5ead with SMTP id
 i5-20020a25a0c5000000b0063363da5eadmr26964307ybm.412.1648524116006; Mon, 28
 Mar 2022 20:21:56 -0700 (PDT)
Date: Mon, 28 Mar 2022 20:19:24 -0700
In-Reply-To: <20220329031924.619453-1-reijiw@google.com>
Message-Id: <20220329031924.619453-3-reijiw@google.com>
Mime-Version: 1.0
References: <20220329031924.619453-1-reijiw@google.com>
X-Mailer: git-send-email 2.35.1.1021.g381101b075-goog
Subject: [PATCH v6 2/2] KVM: arm64: selftests: Introduce vcpu_width_config
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
Reviewed-by: Oliver Upton <oupton@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |   1 +
 tools/testing/selftests/kvm/Makefile          |   1 +
 .../selftests/kvm/aarch64/vcpu_width_config.c | 122 ++++++++++++++++++
 3 files changed, 124 insertions(+)
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
index 0e4926bc9a58..06a5a982123e 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -104,6 +104,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/arch_timer
 TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/psci_cpu_on_test
+TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
 TEST_GEN_PROGS_aarch64 += demand_paging_test
diff --git a/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
new file mode 100644
index 000000000000..6e9402679229
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/vcpu_width_config.c
@@ -0,0 +1,122 @@
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
+ * configured, and two mixed-width vCPUs cannot be configured.
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
+	if (!kvm_check_cap(KVM_CAP_ARM_EL1_32BIT)) {
+		print_skip("KVM_CAP_ARM_EL1_32BIT is not supported");
+		exit(KSFT_SKIP);
+	}
+
+	/* Get the preferred target type and copy that to init2 for later use */
+	vm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+	vm_ioctl(vm, KVM_ARM_PREFERRED_TARGET, &init1);
+	kvm_vm_free(vm);
+	init2 = init1;
+
+	/* Test with 64bit vCPUs */
+	ret = add_init_2vcpus(&init1, &init1);
+	TEST_ASSERT(ret == 0,
+		    "Configuring 64bit EL1 vCPUs failed unexpectedly");
+	ret = add_2vcpus_init_2vcpus(&init1, &init1);
+	TEST_ASSERT(ret == 0,
+		    "Configuring 64bit EL1 vCPUs failed unexpectedly");
+
+	/* Test with 32bit vCPUs */
+	init1.features[0] = (1 << KVM_ARM_VCPU_EL1_32BIT);
+	ret = add_init_2vcpus(&init1, &init1);
+	TEST_ASSERT(ret == 0,
+		    "Configuring 32bit EL1 vCPUs failed unexpectedly");
+	ret = add_2vcpus_init_2vcpus(&init1, &init1);
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
2.35.1.1021.g381101b075-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
