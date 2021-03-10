Return-Path: <SRS0=f6Gw=II=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0053DC433E0
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 00:30:54 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 9D2D065100
	for <kvmarm@archiver.kernel.org>; Wed, 10 Mar 2021 00:30:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9D2D065100
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 4E30B4B5B5;
	Tue,  9 Mar 2021 19:30:53 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@google.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 7OzeIln9D4h4; Tue,  9 Mar 2021 19:30:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 171B44B581;
	Tue,  9 Mar 2021 19:30:51 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 089724B39A
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Mar 2021 19:30:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IpGxPvSIyDfS for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 Mar 2021 19:30:46 -0500 (EST)
Received: from mail-qv1-f73.google.com (mail-qv1-f73.google.com
 [209.85.219.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C5CA84B5A1
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 Mar 2021 19:30:46 -0500 (EST)
Received: by mail-qv1-f73.google.com with SMTP id s16so11503986qvw.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 Mar 2021 16:30:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=20161025;
 h=date:in-reply-to:message-id:mime-version:references:subject:from:to
 :cc; bh=DHxB02lHBuSNm1Tq7ppWLhclQ6LGjD2vwbT8+0hyBYQ=;
 b=i9nnGI1yJf5zkDtvuzAcFHkNKf3iYy4fMgWPsn0CUr62qyKKEML7n/XqRiL4DuhrVD
 lOYIjYImLQHRMCLtPvlKUFDxo1P7/lsLESUmJw0tVdAgsA54KJz5QlWXoqESVY0fXkYS
 KJ+M9fOfot6eeFDCrwoGSqeBqbJGQEoxwG3zMnPXqpV5ZMbroRPNsnIYd1I9SoaLcNfV
 2Ehb5DHXA9zswPk9gJK87g+ScrbL46n7nqhZIrrsCH9ySbP5XLo+k2xO9bYMaYPpHUpH
 b8ohv5kWZiy5uVMb+jik0GkoEQUvObXLnigZ2hmjx/h3f8OYWB2BIEzR/TH2cjB1N4wS
 TlfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=1e100.net; s=20161025;
 h=x-gm-message-state:date:in-reply-to:message-id:mime-version
 :references:subject:from:to:cc;
 bh=DHxB02lHBuSNm1Tq7ppWLhclQ6LGjD2vwbT8+0hyBYQ=;
 b=tw9iGQf4kN8ReYtYpmG5XqSiZ7IQzesyk1WKqh0uBD42wEDmLlAM4g8eo8/ADJUT1C
 QJEN1BjkQS0aImI/dwFE8YjcTUAM1scj93tAh1uT+CTRlooJHso+jxdOosZuM9+D85gt
 tL4qXZ+atCS6ZxZVQySf833yu7rMNThb5y8FasiDbFCrixrVnWcvD//DwvQbNBKeJr21
 E6lzRjvFJptl8vDWOfODsQHBDkP2PlAickzAP5BQQNDY45dj3X4QWB+uI+DuzM8P0lm7
 28X9eOhy861d436FDhMnh080OKIJtxzcxryfOy3kypL2GoE0fLAD0Rkfb2J9qZhk2Zmx
 ZwJA==
X-Gm-Message-State: AOAM532KiM9MSmFuJ6s+i5vpSPsZCrxkPz5E/0uXlv3PtTrmfSpd08vD
 floEynvb4wSFpu9b2FT2ITscC5ZphXCnuBbobg==
X-Google-Smtp-Source: ABdhPJyUNUM/sAdenGIGgvVPCloQCo5gPdn0LHQMLGSw3kNLQg8mscQ8MFWXB1+jfVgEjigVvGqt7memgn4xEsF28w==
X-Received: from jingzhangos.c.googlers.com
 ([fda3:e722:ac3:10:2b:ff92:c0a8:513])
 (user=jingzhangos job=sendgmr) by 2002:a0c:9e15:: with SMTP id
 p21mr678608qve.53.1615336246323; Tue, 09 Mar 2021 16:30:46 -0800 (PST)
Date: Wed, 10 Mar 2021 00:30:24 +0000
In-Reply-To: <20210310003024.2026253-1-jingzhangos@google.com>
Message-Id: <20210310003024.2026253-5-jingzhangos@google.com>
Mime-Version: 1.0
References: <20210310003024.2026253-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
Subject: [RFC PATCH 4/4] KVM: selftests: Add selftest for KVM binary form
 statistics interface
From: Jing Zhang <jingzhangos@google.com>
To: KVM <kvm@vger.kernel.org>, KVM ARM <kvmarm@lists.cs.columbia.edu>, 
 Linux MIPS <linux-mips@vger.kernel.org>, KVM PPC <kvm-ppc@vger.kernel.org>, 
 Linux S390 <linux-s390@vger.kernel.org>, 
 Linux kselftest <linux-kselftest@vger.kernel.org>,
 Paolo Bonzini <pbonzini@redhat.com>, 
 Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>, 
 Julien Thierry <julien.thierry.kdev@gmail.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, 
 Will Deacon <will@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, 
 Aleksandar Markovic <aleksandar.qemu.devel@gmail.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Paul Mackerras <paulus@ozlabs.org>, 
 Christian Borntraeger <borntraeger@de.ibm.com>,
 Janosch Frank <frankja@linux.ibm.com>, 
 David Hildenbrand <david@redhat.com>, Cornelia Huck <cohuck@redhat.com>, 
 Claudio Imbrenda <imbrenda@linux.ibm.com>,
 Sean Christopherson <seanjc@google.com>, 
 Vitaly Kuznetsov <vkuznets@redhat.com>, Jim Mattson <jmattson@google.com>, 
 Peter Shier <pshier@google.com>, Oliver Upton <oupton@google.com>, 
 David Rientjes <rientjes@google.com>,
 Emanuele Giuseppe Esposito <eesposit@redhat.com>
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

Check if the KVM binary form statistics works correctly and whether the
statistics name strings are synced correctly with KVM internal stats
data.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 tools/testing/selftests/kvm/.gitignore        |  1 +
 tools/testing/selftests/kvm/Makefile          |  3 +
 .../selftests/kvm/kvm_bin_form_stats.c        | 89 +++++++++++++++++++
 3 files changed, 93 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/kvm_bin_form_stats.c

diff --git a/tools/testing/selftests/kvm/.gitignore b/tools/testing/selftests/kvm/.gitignore
index 32b87cc77c8e..0c8241bd9a17 100644
--- a/tools/testing/selftests/kvm/.gitignore
+++ b/tools/testing/selftests/kvm/.gitignore
@@ -38,3 +38,4 @@
 /memslot_modification_stress_test
 /set_memory_region_test
 /steal_time
+/kvm_bin_form_stats
diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index a6d61f451f88..5cdd52ccedf2 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -72,6 +72,7 @@ TEST_GEN_PROGS_x86_64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_x86_64 += memslot_modification_stress_test
 TEST_GEN_PROGS_x86_64 += set_memory_region_test
 TEST_GEN_PROGS_x86_64 += steal_time
+TEST_GEN_PROGS_x86_64 += kvm_bin_form_stats
 
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list
 TEST_GEN_PROGS_aarch64 += aarch64/get-reg-list-sve
@@ -81,6 +82,7 @@ TEST_GEN_PROGS_aarch64 += dirty_log_perf_test
 TEST_GEN_PROGS_aarch64 += kvm_create_max_vcpus
 TEST_GEN_PROGS_aarch64 += set_memory_region_test
 TEST_GEN_PROGS_aarch64 += steal_time
+TEST_GEN_PROGS_aarch64 += kvm_bin_form_stats
 
 TEST_GEN_PROGS_s390x = s390x/memop
 TEST_GEN_PROGS_s390x += s390x/resets
@@ -89,6 +91,7 @@ TEST_GEN_PROGS_s390x += demand_paging_test
 TEST_GEN_PROGS_s390x += dirty_log_test
 TEST_GEN_PROGS_s390x += kvm_create_max_vcpus
 TEST_GEN_PROGS_s390x += set_memory_region_test
+TEST_GEN_PROGS_s390x += kvm_bin_form_stats
 
 TEST_GEN_PROGS += $(TEST_GEN_PROGS_$(UNAME_M))
 LIBKVM += $(LIBKVM_$(UNAME_M))
diff --git a/tools/testing/selftests/kvm/kvm_bin_form_stats.c b/tools/testing/selftests/kvm/kvm_bin_form_stats.c
new file mode 100644
index 000000000000..36cf206470b1
--- /dev/null
+++ b/tools/testing/selftests/kvm/kvm_bin_form_stats.c
@@ -0,0 +1,89 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * kvm_bin_form_stats
+ *
+ * Copyright (C) 2021, Google LLC.
+ *
+ * Test for fd-based IOCTL commands for retrieving KVM statistics data in
+ * binary form. KVM_CAP_STATS_BINARY_FORM, KVM_STATS_GET_INFO,
+ * KVM_STATS_GET_NAMES and KVM_STATS_GET_DATA are checked.
+ */
+
+#define _GNU_SOURCE /* for program_invocation_short_name */
+#include <fcntl.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+
+#include "test_util.h"
+
+#include "kvm_util.h"
+#include "asm/kvm.h"
+#include "linux/kvm.h"
+
+int main(int argc, char *argv[])
+{
+	struct kvm_stats_info stats_info = {0};
+	struct kvm_stats_names *stats_names;
+	struct kvm_stats_data *stats_data;
+	struct kvm_vm *kvm;
+	int i, ret;
+
+	kvm = vm_create(VM_MODE_DEFAULT, DEFAULT_GUEST_PHY_PAGES, O_RDWR);
+
+	ret = kvm_check_cap(KVM_CAP_STATS_BINARY_FORM);
+	if (ret < 0) {
+		pr_info("Binary form statistics interface is not supported!\n");
+		goto out_free_kvm;
+	}
+
+	ret = -1;
+	vm_ioctl(kvm, KVM_STATS_GET_INFO, &stats_info);
+	if (stats_info.num_stats == 0) {
+		pr_info("KVM_STATS_GET_INFO failed!\n");
+		pr_info("Or the number of stistics data is zero.\n");
+		goto out_free_kvm;
+	}
+
+	/* Allocate memory for stats name strings and value */
+	stats_names = malloc(sizeof(*stats_names) +
+			stats_info.num_stats * KVM_STATS_NAME_LEN);
+	if (!stats_names) {
+		pr_info("Memory allocation failed!\n");
+		goto out_free_kvm;
+	}
+
+	stats_data = malloc(sizeof(*stats_data) +
+				stats_info.num_stats * sizeof(__u64));
+	if (!stats_data) {
+		pr_info("Memory allocation failed!\n");
+		goto out_free_names;
+	}
+
+	/* Retrieve the name strings and data */
+	stats_names->size = stats_info.num_stats * KVM_STATS_NAME_LEN;
+	vm_ioctl(kvm, KVM_STATS_GET_NAMES, stats_names);
+
+	stats_data->size = stats_info.num_stats * sizeof(__u64);
+	vm_ioctl(kvm, KVM_STATS_GET_DATA, stats_data);
+
+	/* Display supported statistics names */
+	for (i = 0; i < (int)stats_info.num_stats; i++) {
+		char *name = (char *)stats_names->names + i * KVM_STATS_NAME_LEN;
+
+		if (strnlen(name, KVM_STATS_NAME_LEN) == 0) {
+			pr_info("Empty stats name at offset %d!\n", i);
+			goto out_free_data;
+		}
+		pr_info("%s\n", name);
+	}
+
+	ret = 0;
+out_free_data:
+	free(stats_data);
+out_free_names:
+	free(stats_names);
+out_free_kvm:
+	kvm_vm_free(kvm);
+	return ret;
+}
-- 
2.30.1.766.gb4fecdf3b7-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
