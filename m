Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3317C433F5
	for <kvmarm@archiver.kernel.org>; Fri, 27 May 2022 08:06:58 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57C824B352;
	Fri, 27 May 2022 04:06:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id butxRkxq6I9K; Fri, 27 May 2022 04:06:56 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id AD8584B1E1;
	Fri, 27 May 2022 04:06:56 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 21B604B1E1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:06:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LJfapHXpO4jZ for <kvmarm@lists.cs.columbia.edu>;
 Fri, 27 May 2022 04:06:53 -0400 (EDT)
Received: from us-smtp-delivery-124.mimecast.com
 (us-smtp-delivery-124.mimecast.com [170.10.129.124])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6C8744B186
 for <kvmarm@lists.cs.columbia.edu>; Fri, 27 May 2022 04:06:53 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1653638813;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=gwt9QcPDJhVzAwJQz388VeKwOFQslaYIR/LV9tRZHE0=;
 b=QiZ8ER8ZBV/Omj9KSPM/pvoaIqDYhdEspg935vQiovrcS0VkqkD6GSrM6fKJ9+P1Nxy5nS
 DwyeJe412D37mG4+/mzl5H/pEvhTPzljnkQDPqqepVWRD0woPCtogVU/NinIwbv3JNduBS
 LBwjmCTyIdODye8fLUenWZJRnhnGaxQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-255-vVHNWWkYNUqCbb-_vFVP8Q-1; Fri, 27 May 2022 04:06:48 -0400
X-MC-Unique: vVHNWWkYNUqCbb-_vFVP8Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com
 [10.11.54.4])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8424A811E81;
 Fri, 27 May 2022 08:06:47 +0000 (UTC)
Received: from gshan.redhat.com (ovpn-12-91.pek2.redhat.com [10.72.12.91])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 8FB8020296A2;
 Fri, 27 May 2022 08:06:39 +0000 (UTC)
From: Gavin Shan <gshan@redhat.com>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH v7 22/22] selftests: KVM: aarch64: Add SDEI test case
Date: Fri, 27 May 2022 16:02:53 +0800
Message-Id: <20220527080253.1562538-23-gshan@redhat.com>
In-Reply-To: <20220527080253.1562538-1-gshan@redhat.com>
References: <20220527080253.1562538-1-gshan@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.78 on 10.11.54.4
Cc: maz@kernel.org, shijie@amperemail.onmicrosoft.com,
 linux-kernel@vger.kernel.org, eauger@redhat.com, shan.gavin@gmail.com,
 Jonathan.Cameron@huawei.com, pbonzini@redhat.com, vkuznets@redhat.com,
 will@kernel.org
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

This adds SDEI selftest case where the various hypercalls are
issued to the software signaled event, whose number is zero.
The event is private, signaled and in normal priority.

By default, two vCPUs are started and the following ioctl commands
or hypercalls are sent to them in sequence, to simulate how they
are used in VMM and the linux guest:

   kvm_check_cap(KVM_CAP_ARM_SDEI)     (Available functionality)

   SDEI_1_0_FN_SDEI_VERSION
   SDEI_1_1_FN_SDEI_FEATURES           (SDEI capability probing)
   SDEI_1_0_FN_SDEI_SHARED_RESET       (restart SDEI)
   SDEI_1_0_FN_SDEI_PE_UNMASK          (CPU online)

   SDEI_1_0_FN_SDEI_EVENT_GET_INFO
   SDEI_1_0_FN_SDEI_EVENT_REGISTER     (register event)
   SDEI_1_0_FN_SDEI_EVENT_ENABLE       (enable event)
   SDEI_1_1_FN_SDEI_EVENT_SIGNAL       (event injection)

   SDEI_1_0_FN_SDEI_EVENT_DISABLE      (disable event)
   SDEI_1_0_FN_SDEI_EVENT_UNREGISTER   (unregister event)
   SDEI_1_0_FN_SDEI_PE_MASK            (CPU offline)

Signed-off-by: Gavin Shan <gshan@redhat.com>
---
 tools/testing/selftests/kvm/Makefile       |   1 +
 tools/testing/selftests/kvm/aarch64/sdei.c | 450 +++++++++++++++++++++
 2 files changed, 451 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/aarch64/sdei.c

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 81470a99ed1c..39b976a6568f 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -109,6 +109,7 @@ TEST_GEN_PROGS_aarch64 += aarch64/debug-exceptions
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/hypercalls
 TEST_GEN_PROGS_aarch64 += aarch64/psci_test
+TEST_GEN_PROGS_aarch64 += aarch64/sdei
 TEST_GEN_PROGS_aarch64 += aarch64/vcpu_width_config
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_init
 TEST_GEN_PROGS_aarch64 += aarch64/vgic_irq
diff --git a/tools/testing/selftests/kvm/aarch64/sdei.c b/tools/testing/selftests/kvm/aarch64/sdei.c
new file mode 100644
index 000000000000..7a034d486e83
--- /dev/null
+++ b/tools/testing/selftests/kvm/aarch64/sdei.c
@@ -0,0 +1,450 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * ARM64 SDEI test
+ *
+ * Copyright (C) 2022 Red Hat, Inc.
+ *
+ * Author(s): Gavin Shan <gshan@redhat.com>
+ */
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <string.h>
+#include <pthread.h>
+
+#include <linux/arm-smccc.h>
+#include <linux/arm_sdei.h>
+#include <kvm_util.h>
+#include "processor.h"
+
+#define NR_VCPUS		2
+#define SDEI_TEST_EVENT_NUM	SDEI_SW_SIGNALED_EVENT
+
+#define VCPU_COMMAND_IDLE	0
+#define VCPU_COMMAND_EXIT	1
+
+struct vcpu_command {
+	const char	*name;
+	uint64_t	command;
+};
+
+struct sdei_feature {
+	uint16_t	shared_slots;
+	uint16_t	private_slots;
+	uint8_t		relative_mode;
+};
+
+struct sdei_event_info {
+	uint8_t		type;
+	uint8_t		priority;
+	uint8_t		signaled;
+};
+
+struct sdei_event_signal {
+	uint8_t		handled;
+	uint8_t		irq;
+	uint64_t	status;
+	uint64_t	pc;
+	uint64_t	pstate;
+	uint64_t	regs[18];
+};
+
+struct sdei_state {
+	uint64_t	command;
+	uint64_t	num;
+	uint64_t	status;
+	union {
+		uint64_t			version;
+		struct sdei_feature		feature;
+		struct sdei_event_info		info;
+		struct sdei_event_signal	signal;
+	};
+
+	uint8_t		command_completed;
+};
+
+struct vcpu_state {
+	struct kvm_vm		*vm;
+	uint32_t		vcpu_id;
+	pthread_t		thread;
+	struct sdei_state	state;
+};
+
+extern char vectors;	/* VBAR_EL1 */
+static struct vcpu_state vcpu_states[NR_VCPUS];
+static struct vcpu_command vcpu_commands[] = {
+	{ "VERSION",          SDEI_1_0_FN_SDEI_VERSION          },
+	{ "FEATURES",         SDEI_1_1_FN_SDEI_FEATURES         },
+	{ "SHARED_RESET",     SDEI_1_0_FN_SDEI_SHARED_RESET     },
+	{ "PRIVATE_RESET",    SDEI_1_0_FN_SDEI_PRIVATE_RESET    },
+	{ "PE_UNMASK",        SDEI_1_0_FN_SDEI_PE_UNMASK        },
+	{ "EVENT_GET_INFO",   SDEI_1_0_FN_SDEI_EVENT_GET_INFO   },
+	{ "EVENT_REGISTER",   SDEI_1_0_FN_SDEI_EVENT_REGISTER   },
+	{ "EVENT_ENABLE",     SDEI_1_0_FN_SDEI_EVENT_ENABLE     },
+	{ "EVENT_SIGNAL",     SDEI_1_1_FN_SDEI_EVENT_SIGNAL     },
+	{ "PE_MASK",          SDEI_1_0_FN_SDEI_PE_MASK          },
+	{ "EVENT_DISABLE",    SDEI_1_0_FN_SDEI_EVENT_DISABLE    },
+	{ "EVENT_UNREGISTER", SDEI_1_0_FN_SDEI_EVENT_UNREGISTER },
+};
+
+static inline bool is_error(int64_t status)
+{
+	if (status == SDEI_NOT_SUPPORTED      ||
+	    status == SDEI_INVALID_PARAMETERS ||
+	    status == SDEI_DENIED             ||
+	    status == SDEI_PENDING            ||
+	    status == SDEI_OUT_OF_RESOURCE)
+		return true;
+
+	return false;
+}
+
+static void guest_irq_handler(struct ex_regs *regs)
+{
+	int vcpu_id = guest_get_vcpuid();
+	struct sdei_state *state = &vcpu_states[vcpu_id].state;
+
+	WRITE_ONCE(state->signal.irq, true);
+}
+
+static void sdei_event_handler(uint64_t num, uint64_t arg,
+			       uint64_t pc, uint64_t pstate)
+{
+	struct sdei_state *state = (struct sdei_state *)arg;
+	struct arm_smccc_res res;
+
+	smccc_hvc(SDEI_1_0_FN_SDEI_EVENT_STATUS, num, 0, 0, 0, 0, 0, 0, &res);
+	WRITE_ONCE(state->signal.status, res.a0);
+
+	WRITE_ONCE(state->signal.pc, pc);
+	WRITE_ONCE(state->signal.pstate, pstate);
+
+	smccc_hvc(SDEI_1_0_FN_SDEI_EVENT_CONTEXT, 0, 0, 0, 0, 0, 0, 0, &res);
+	WRITE_ONCE(state->signal.regs[0], res.a0);
+	smccc_hvc(SDEI_1_0_FN_SDEI_EVENT_CONTEXT, 1, 0, 0, 0, 0, 0, 0, &res);
+	WRITE_ONCE(state->signal.regs[1], res.a0);
+	smccc_hvc(SDEI_1_0_FN_SDEI_EVENT_CONTEXT, 2, 0, 0, 0, 0, 0, 0, &res);
+	WRITE_ONCE(state->signal.regs[2], res.a0);
+	smccc_hvc(SDEI_1_0_FN_SDEI_EVENT_CONTEXT, 3, 0, 0, 0, 0, 0, 0, &res);
+	WRITE_ONCE(state->signal.regs[3], res.a0);
+
+	WRITE_ONCE(state->signal.handled, true);
+	smccc_hvc(SDEI_1_0_FN_SDEI_EVENT_COMPLETE_AND_RESUME,
+		  (uint64_t)&vectors + 0x280, 0, 0, 0, 0, 0, 0, &res);
+}
+
+static void guest_code(int vcpu_id)
+{
+	struct sdei_state *state;
+	struct arm_smccc_res res;
+	uint64_t command, last_command = -1UL, num;
+
+	state = &vcpu_states[vcpu_id].state;
+
+	while (1) {
+		command = READ_ONCE(state->command);
+		if (command == last_command)
+			continue;
+
+		num = READ_ONCE(state->num);
+		switch (command) {
+		case VCPU_COMMAND_IDLE:
+			WRITE_ONCE(state->status, SDEI_SUCCESS);
+			break;
+		case SDEI_1_0_FN_SDEI_VERSION:
+			smccc_hvc(command, 0, 0, 0, 0, 0, 0, 0, &res);
+			WRITE_ONCE(state->status, res.a0);
+			if (is_error(res.a0))
+				break;
+
+			WRITE_ONCE(state->version, res.a0);
+			break;
+		case SDEI_1_0_FN_SDEI_PRIVATE_RESET:
+		case SDEI_1_0_FN_SDEI_SHARED_RESET:
+		case SDEI_1_0_FN_SDEI_PE_UNMASK:
+		case SDEI_1_0_FN_SDEI_PE_MASK:
+			smccc_hvc(command, 0, 0, 0, 0, 0, 0, 0, &res);
+			WRITE_ONCE(state->status, res.a0);
+			break;
+		case SDEI_1_1_FN_SDEI_FEATURES:
+			smccc_hvc(command, SDEI_FEATURE_BIND_SLOTS,
+				  0, 0, 0, 0, 0, 0, &res);
+			WRITE_ONCE(state->status, res.a0);
+			if (is_error(res.a0))
+				break;
+
+			WRITE_ONCE(state->feature.shared_slots,
+				   (res.a0 & 0xffff0000) >> 16);
+			WRITE_ONCE(state->feature.private_slots,
+				   (res.a0 & 0x0000ffff));
+			smccc_hvc(command, SDEI_FEATURE_RELATIVE_MODE,
+				  0, 0, 0, 0, 0, 0, &res);
+			WRITE_ONCE(state->status, res.a0);
+			if (is_error(res.a0))
+				break;
+
+			WRITE_ONCE(state->feature.relative_mode, res.a0);
+			break;
+		case SDEI_1_0_FN_SDEI_EVENT_GET_INFO:
+			smccc_hvc(command, num, SDEI_EVENT_INFO_EV_TYPE,
+				  0, 0, 0, 0, 0, &res);
+			WRITE_ONCE(state->status, res.a0);
+			if (is_error(res.a0))
+				break;
+
+			WRITE_ONCE(state->info.type, res.a0);
+			smccc_hvc(command, num, SDEI_EVENT_INFO_EV_PRIORITY,
+				  0, 0, 0, 0, 0, &res);
+			WRITE_ONCE(state->status, res.a0);
+			if (is_error(res.a0))
+				break;
+
+			WRITE_ONCE(state->info.priority, res.a0);
+			smccc_hvc(command, num, SDEI_EVENT_INFO_EV_SIGNALED,
+				  0, 0, 0, 0, 0, &res);
+			if (is_error(res.a0))
+				break;
+
+			WRITE_ONCE(state->info.signaled, res.a0);
+			break;
+		case SDEI_1_0_FN_SDEI_EVENT_REGISTER:
+			smccc_hvc(command, num, (uint64_t)sdei_event_handler,
+				  (uint64_t)state, SDEI_EVENT_REGISTER_RM_ANY,
+				  0, 0, 0, &res);
+			WRITE_ONCE(state->status, res.a0);
+			break;
+		case SDEI_1_0_FN_SDEI_EVENT_ENABLE:
+		case SDEI_1_0_FN_SDEI_EVENT_DISABLE:
+		case SDEI_1_0_FN_SDEI_EVENT_UNREGISTER:
+			smccc_hvc(command, num, 0, 0, 0, 0, 0, 0, &res);
+			WRITE_ONCE(state->status, res.a0);
+			break;
+		case SDEI_1_1_FN_SDEI_EVENT_SIGNAL:
+			/*
+			 * The injected event should be handled and delivered
+			 * immediately in KVM.
+			 */
+			smccc_hvc(command, num, (uint64_t)state,
+				  0, 0, 0, 0, 0, &res);
+			WRITE_ONCE(state->status, res.a0);
+			break;
+		case VCPU_COMMAND_EXIT:
+			WRITE_ONCE(state->status, SDEI_SUCCESS);
+			GUEST_DONE();
+			break;
+		default:
+			WRITE_ONCE(state->status, SDEI_INVALID_PARAMETERS);
+		}
+
+		last_command = command;
+		WRITE_ONCE(state->command_completed, true);
+	}
+}
+
+static void *vcpu_thread(void *arg)
+{
+	struct vcpu_state *state = arg;
+
+	vcpu_run(state->vm, state->vcpu_id);
+
+	return NULL;
+}
+
+static bool vcpu_wait(struct kvm_vm *vm, int timeout_in_seconds)
+{
+	unsigned long count, limit;
+	int i;
+
+	count = 0;
+	limit = (timeout_in_seconds * 1000000) / 50;
+	while (1) {
+		for (i = 0; i < NR_VCPUS; i++) {
+			sync_global_from_guest(vm, vcpu_states[i].state);
+			if (!vcpu_states[i].state.command_completed)
+				break;
+		}
+
+		if (i >= NR_VCPUS)
+			return true;
+
+		if (++count > limit)
+			return false;
+
+		usleep(50);
+	}
+
+	return false;
+}
+
+static void vcpu_send_command(struct kvm_vm *vm, uint64_t command)
+{
+	int i;
+
+	for (i = 0; i < NR_VCPUS; i++) {
+		memset(&vcpu_states[i].state, 0,
+		       sizeof(vcpu_states[0].state));
+		vcpu_states[i].state.num = SDEI_TEST_EVENT_NUM;
+		vcpu_states[i].state.status = SDEI_SUCCESS;
+		vcpu_states[i].state.command = command;
+		vcpu_states[i].state.command_completed = false;
+
+		sync_global_to_guest(vm, vcpu_states[i].state);
+	}
+}
+
+static bool vcpu_check_state(struct kvm_vm *vm)
+{
+	int i, j, ret;
+
+	for (i = 0; i < NR_VCPUS; i++)
+		sync_global_from_guest(vm, vcpu_states[i].state);
+
+	for (i = 0; i < NR_VCPUS; i++) {
+		if (is_error(vcpu_states[i].state.status))
+			return false;
+
+		for (j = 0; j < NR_VCPUS; j++) {
+			ret = memcmp(&vcpu_states[i].state,
+				     &vcpu_states[j].state,
+				     sizeof(vcpu_states[0].state));
+			if (ret)
+				return false;
+		}
+	}
+
+	return true;
+}
+
+static void vcpu_dump_state(int index)
+{
+	struct sdei_state *state = &vcpu_states[0].state;
+
+	pr_info("--- %s\n", vcpu_commands[index].name);
+	switch (state->command) {
+	case SDEI_1_0_FN_SDEI_VERSION:
+		pr_info("    Version:              %ld.%ld (vendor: 0x%lx)\n",
+			SDEI_VERSION_MAJOR(state->version),
+			SDEI_VERSION_MINOR(state->version),
+			SDEI_VERSION_VENDOR(state->version));
+		break;
+	case SDEI_1_1_FN_SDEI_FEATURES:
+		pr_info("    Shared event slots:   %d\n",
+			state->feature.shared_slots);
+		pr_info("    Private event slots:  %d\n",
+			state->feature.private_slots);
+		pr_info("    Relative mode:        %s\n",
+			state->feature.relative_mode ? "Yes" : "No");
+			break;
+	case SDEI_1_0_FN_SDEI_EVENT_GET_INFO:
+		pr_info("    Type:                 %s\n",
+			state->info.type == SDEI_EVENT_TYPE_SHARED ?
+			"Shared" : "Private");
+		pr_info("    Priority:             %s\n",
+			state->info.priority == SDEI_EVENT_PRIORITY_NORMAL ?
+			"Normal" : "Critical");
+		pr_info("    Signaled:             %s\n",
+			state->info.signaled ? "Yes" : "No");
+		break;
+	case SDEI_1_1_FN_SDEI_EVENT_SIGNAL:
+		pr_info("    Handled:              %s\n",
+			state->signal.handled ? "Yes" : "No");
+		pr_info("    IRQ:                  %s\n",
+			state->signal.irq ? "Yes" : "No");
+		pr_info("    Status:               %s-%s-%s\n",
+			state->signal.status & (1 << SDEI_EVENT_STATUS_REGISTERED) ?
+			"Registered" : "x",
+			state->signal.status & (1 << SDEI_EVENT_STATUS_ENABLED) ?
+			"Enabled" : "x",
+			state->signal.status & (1 << SDEI_EVENT_STATUS_RUNNING) ?
+			"Running" : "x");
+		pr_info("    PC/PSTATE:            %016lx %016lx\n",
+			state->signal.pc, state->signal.pstate);
+		pr_info("    Regs:                 %016lx %016lx %016lx %016lx\n",
+			state->signal.regs[0], state->signal.regs[1],
+			state->signal.regs[2], state->signal.regs[3]);
+		break;
+	}
+
+	if (index == ARRAY_SIZE(vcpu_commands))
+		pr_info("\n");
+}
+
+int main(int argc, char **argv)
+{
+	struct kvm_vm *vm;
+	uint32_t vcpu_ids[NR_VCPUS];
+	int i, ret;
+
+	if (!kvm_check_cap(KVM_CAP_ARM_SDEI)) {
+		pr_info("SDEI not supported\n");
+		return 0;
+	}
+
+	/* Create VM */
+	for (i = 0; i < NR_VCPUS; i++) {
+		vcpu_states[i].vcpu_id = i;
+		vcpu_ids[i] = i;
+	}
+
+	vm = vm_create_default_with_vcpus(NR_VCPUS, 0, 0,
+					  guest_code, vcpu_ids);
+	vm_init_descriptor_tables(vm);
+	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT,
+				     guest_irq_handler);
+	ucall_init(vm, NULL);
+
+	/* Start the vCPUs */
+	vcpu_send_command(vm, VCPU_COMMAND_IDLE);
+	for (i = 0; i < NR_VCPUS; i++) {
+		vcpu_states[i].vm = vm;
+		vcpu_args_set(vm, i, 1, i);
+		vcpu_init_descriptor_tables(vm, i);
+		ret = pthread_create(&vcpu_states[i].thread, NULL,
+				     vcpu_thread, &vcpu_states[i]);
+		TEST_ASSERT(!ret, "Failed to create vCPU-%d pthread\n", i);
+	}
+
+	/* Wait the idle command to complete */
+	ret = vcpu_wait(vm, 5);
+	TEST_ASSERT(ret, "Timeout to execute IDLE command\n");
+
+	/* Start the tests */
+	pr_info("\n");
+	pr_info("    NR_VCPUS: %d    SDEI Event: 0x%08x\n\n",
+		NR_VCPUS, SDEI_TEST_EVENT_NUM);
+	for (i = 0; i < ARRAY_SIZE(vcpu_commands); i++) {
+		/*
+		 * We depends on SDEI_EVENT_SIGNAL hypercall to inject SDEI
+		 * event. The number of the injected event must be zero. So
+		 * we have to skip the corresponding test if the SDEI event
+		 * number isn't zero.
+		 */
+		if (SDEI_TEST_EVENT_NUM != SDEI_SW_SIGNALED_EVENT &&
+		    vcpu_commands[i].command == SDEI_1_1_FN_SDEI_EVENT_SIGNAL)
+			continue;
+
+		vcpu_send_command(vm, vcpu_commands[i].command);
+		ret = vcpu_wait(vm, 5);
+		if (!ret) {
+			pr_info("%s: Timeout\n", vcpu_commands[i].name);
+			return -1;
+		}
+
+		ret = vcpu_check_state(vm);
+		if (!ret) {
+			pr_info("%s: Fail\n", vcpu_commands[i].name);
+			return -1;
+		}
+
+		vcpu_dump_state(i);
+	}
+
+	/* Terminate the guests */
+	pr_info("\n    Result: OK\n\n");
+	vcpu_send_command(vm, VCPU_COMMAND_EXIT);
+	sleep(1);
+
+	return 0;
+}
-- 
2.23.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
