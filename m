Return-Path: <SRS0=bjrO=KC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F267C433B4
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:33:00 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 0CB39610A7
	for <kvmarm@archiver.kernel.org>; Fri,  7 May 2021 06:33:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0CB39610A7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id A67EF4B31F;
	Fri,  7 May 2021 02:32:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YNYUh0Ukw82A; Fri,  7 May 2021 02:32:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 67B5B4B491;
	Fri,  7 May 2021 02:32:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AA764B24B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:32:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QNUW1QKqZkOZ for <kvmarm@lists.cs.columbia.edu>;
 Fri,  7 May 2021 02:32:56 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [216.205.24.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 273304B31F
 for <kvmarm@lists.cs.columbia.edu>; Fri,  7 May 2021 02:32:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1620369176;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=FZ6/ii7HCmSCakWhgJxu+33lfc0a/k5KfVAStzZkCRk=;
 b=NF/UzM3HLd6vLlStpH2A9SxalywYJfkoBEZoOYxZomhAAhL/w46x6J6YZSQhJAYOTQNyT4
 TpZRmkNMmN1wn7xdAraNwbRbGM83kPRrhJ6ylrCZDyFfwvShbzZTGXXh3Zk0tsEk6qqiPg
 jJp6f9f1IIJfeFddbakLEzvgEDc1ZT4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-95-kGoK49aYOmaN5KWhZS7NdA-1; Fri, 07 May 2021 02:32:54 -0400
X-MC-Unique: kGoK49aYOmaN5KWhZS7NdA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com
 [10.5.11.14])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EA96464149;
 Fri,  7 May 2021 06:32:52 +0000 (UTC)
Received: from gshan.redhat.com (vpn2-54-42.bne.redhat.com [10.64.54.42])
 by smtp.corp.redhat.com (Postfix) with ESMTP id ABA8A5D9CA;
 Fri,  7 May 2021 06:32:50 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v3 21/21] KVM: selftests: Add SDEI test case
Date: Fri,  7 May 2021 16:31:24 +0800
Message-Id: <20210507083124.43347-22-gshan@redhat.com>
In-Reply-To: <20210507083124.43347-1-gshan@redhat.com>
References: <20210507083124.43347-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Cc: maz@kernel.org, linux-kernel@vger.kernel.org, shan.gavin@gmail.com,
 Jonathan.Cameron@huawei.com, pbonzini@redhat.com, will@kernel.org
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

This adds SDEI test case into selftests where the various hypercalls
are issued to kvm private event (0x40200000) and then ensure that's
completed without error. Note that two vCPUs are started up by default
to run same consequence. Actually, it's simulating what SDEI client
driver does and the following hypercalls are issued in sequence:

   SDEI_1_0_FN_SDEI_VERSION            (probing SDEI capability)
   SDEI_1_0_FN_SDEI_PE_UNMASK          (CPU online)
   SDEI_1_0_FN_SDEI_PRIVATE_RESET      (restart SDEI)
   SDEI_1_0_FN_SDEI_SHARED_RESET
   SDEI_1_0_FN_SDEI_EVENT_GET_INFO     (register event)
   SDEI_1_0_FN_SDEI_EVENT_GET_INFO
   SDEI_1_0_FN_SDEI_EVENT_GET_INFO
   SDEI_1_0_FN_SDEI_EVENT_REGISTER
   SDEI_1_0_FN_SDEI_EVENT_ENABLE       (enable event)
   SDEI_1_0_FN_SDEI_EVENT_DISABLE      (disable event)
   SDEI_1_0_FN_SDEI_EVENT_UNREGISTER   (unregister event)
   SDEI_1_0_FN_SDEI_PE_MASK            (CPU offline)

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/Makefile       |   1 +
 tools/testing/selftests/kvm/aarch64/sdei.c | 172 +++++++++++++++++++++
 2 files changed, 173 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/sdei.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index e439d027939d..ddca67b420b2 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -79,6 +79,7 @@ TEST_GEN_PROGS_x86_64 += steal_time
 
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list-sve
+TEST_GEN_PROGS_aarch64 += aarch64/sdei
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += demand_paging_test
 TEST_GEN_PROGS_aarch64 += dirty_log_test
diff --git a/tools/testing/selftests/kvm/aarch64/sdei.c b/tools/testing/selftests/kvm/aarch64/sdei.c
new file mode 100644
index 000000000000..1a4cdae84ad5
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/sdei.c
@@ -0,0 +1,172 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ARM SDEI test
+ *
+ * Copyright (C) 2021 Red Hat, Inc.
+ *
+ * Author(s): Gavin Shan <gshan@redhat.com>
+ */
+#define _GNU_SOURCE
+#include <stdio.h>
+
+#include "test_util.h"
+#include "kvm_util.h"
+#include "processor.h"
+#include "asm/kvm_sdei.h"
+#include "linux/arm_sdei.h"
+
+#define NR_VCPUS	2
+#define SDEI_GPA_BASE	(1 << 30)
+
+struct sdei_event {
+	uint32_t	cpu;
+	uint64_t	version;
+	uint64_t	num;
+	uint64_t	type;
+	uint64_t	priority;
+	uint64_t	signaled;
+};
+
+static struct sdei_event sdei_events[NR_VCPUS];
+
+static int64_t smccc(uint32_t func, uint64_t arg0, uint64_t arg1,
+		     uint64_t arg2, uint64_t arg3, uint64_t arg4)
+{
+	int64_t ret;
+
+	asm volatile(
+		"mov    x0, %1\n"
+		"mov    x1, %2\n"
+		"mov    x2, %3\n"
+		"mov    x3, %4\n"
+		"mov    x4, %5\n"
+		"mov    x5, %6\n"
+		"hvc    #0\n"
+		"mov    %0, x0\n"
+	: "=r" (ret) : "r" (func), "r" (arg0), "r" (arg1),
+	"r" (arg2), "r" (arg3), "r" (arg4) :
+	"x0", "x1", "x2", "x3", "x4", "x5");
+
+	return ret;
+}
+
+static inline bool is_error(int64_t ret)
+{
+	if (ret == SDEI_NOT_SUPPORTED      ||
+	    ret == SDEI_INVALID_PARAMETERS ||
+	    ret == SDEI_DENIED             ||
+	    ret == SDEI_PENDING            ||
+	    ret == SDEI_OUT_OF_RESOURCE)
+		return true;
+
+	return false;
+}
+
+static void guest_code(int cpu)
+{
+	struct sdei_event *event = &sdei_events[cpu];
+	int64_t ret;
+
+	/* CPU */
+	event->cpu = cpu;
+	event->num = KVM_SDEI_DEFAULT_NUM;
+	GUEST_ASSERT(cpu < NR_VCPUS);
+
+	/* Version */
+	ret = smccc(SDEI_1_0_FN_SDEI_VERSION, 0, 0, 0, 0, 0);
+	GUEST_ASSERT(!is_error(ret));
+	GUEST_ASSERT(SDEI_VERSION_MAJOR(ret) == 1);
+	GUEST_ASSERT(SDEI_VERSION_MINOR(ret) == 0);
+	event->version = ret;
+
+	/* CPU unmasking */
+	ret = smccc(SDEI_1_0_FN_SDEI_PE_UNMASK, 0, 0, 0, 0, 0);
+	GUEST_ASSERT(!is_error(ret));
+
+	/* Reset */
+	ret = smccc(SDEI_1_0_FN_SDEI_PRIVATE_RESET, 0, 0, 0, 0, 0);
+	GUEST_ASSERT(!is_error(ret));
+	ret = smccc(SDEI_1_0_FN_SDEI_SHARED_RESET, 0, 0, 0, 0, 0);
+	GUEST_ASSERT(!is_error(ret));
+
+	/* Event properties */
+	ret = smccc(SDEI_1_0_FN_SDEI_EVENT_GET_INFO,
+		     event->num, SDEI_EVENT_INFO_EV_TYPE, 0, 0, 0);
+	GUEST_ASSERT(!is_error(ret));
+	event->type = ret;
+
+	ret = smccc(SDEI_1_0_FN_SDEI_EVENT_GET_INFO,
+		    event->num, SDEI_EVENT_INFO_EV_PRIORITY, 0, 0, 0);
+	GUEST_ASSERT(!is_error(ret));
+	event->priority = ret;
+
+	ret = smccc(SDEI_1_0_FN_SDEI_EVENT_GET_INFO,
+		    event->num, SDEI_EVENT_INFO_EV_SIGNALED, 0, 0, 0);
+	GUEST_ASSERT(!is_error(ret));
+	event->signaled = ret;
+
+	/* Event registration */
+	ret = smccc(SDEI_1_0_FN_SDEI_EVENT_REGISTER,
+		    event->num, 0, 0, SDEI_EVENT_REGISTER_RM_ANY, 0);
+	GUEST_ASSERT(!is_error(ret));
+
+	/* Event enablement */
+	ret = smccc(SDEI_1_0_FN_SDEI_EVENT_ENABLE,
+		    event->num, 0, 0, 0, 0);
+	GUEST_ASSERT(!is_error(ret));
+
+	/* Event disablement */
+	ret = smccc(SDEI_1_0_FN_SDEI_EVENT_DISABLE,
+		    event->num, 0, 0, 0, 0);
+	GUEST_ASSERT(!is_error(ret));
+
+	/* Event unregistration */
+	ret = smccc(SDEI_1_0_FN_SDEI_EVENT_UNREGISTER,
+		    event->num, 0, 0, 0, 0);
+	GUEST_ASSERT(!is_error(ret));
+
+	/* CPU masking */
+	ret = smccc(SDEI_1_0_FN_SDEI_PE_MASK, 0, 0, 0, 0, 0);
+	GUEST_ASSERT(!is_error(ret));
+
+	GUEST_DONE();
+}
+
+int main(int argc, char **argv)
+{
+	struct kvm_vm *vm;
+	int i;
+
+	if (!kvm_check_cap(KVM_CAP_ARM_SDEI)) {
+		pr_info("SDEI not supported\n");
+		return 0;
+	}
+
+	vm = vm_create_default(0, 0, guest_code);
+	ucall_init(vm, NULL);
+
+	for (i = 1; i < NR_VCPUS; i++)
+		vm_vcpu_add_default(vm, i, guest_code);
+
+	for (i = 0; i < NR_VCPUS; i++) {
+		vcpu_args_set(vm, i, 1, i);
+		vcpu_run(vm, i);
+
+		sync_global_from_guest(vm, sdei_events[i]);
+		pr_info("--------------------------------\n");
+		pr_info("CPU:      %d\n",
+			sdei_events[i].cpu);
+		pr_info("Version:  %ld.%ld (0x%lx)\n",
+			SDEI_VERSION_MAJOR(sdei_events[i].version),
+			SDEI_VERSION_MINOR(sdei_events[i].version),
+			SDEI_VERSION_VENDOR(sdei_events[i].version));
+		pr_info("Event:    0x%08lx\n",
+			sdei_events[i].num);
+		pr_info("Type:     %s\n",
+			sdei_events[i].type ? "shared" : "private");
+		pr_info("Signaled: %s\n",
+			sdei_events[i].signaled ? "yes" : "no");
+	}
+
+	return 0;
+}
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
