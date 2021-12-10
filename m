Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5536BC433FE
	for <kvmarm@archiver.kernel.org>; Fri, 10 Dec 2021 17:36:48 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0ED2A4B206;
	Fri, 10 Dec 2021 12:36:48 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amd.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZcCk8qwMVMzh; Fri, 10 Dec 2021 12:36:46 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 088614B22C;
	Fri, 10 Dec 2021 12:36:36 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AAF254B0D6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 11:49:39 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rSC6KNwi+3H5 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 10 Dec 2021 11:49:38 -0500 (EST)
Received: from NAM02-SN1-obe.outbound.protection.outlook.com
 (mail-sn1anam02on2058.outbound.protection.outlook.com [40.107.96.58])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0EE8B4B164
 for <kvmarm@lists.cs.columbia.edu>; Fri, 10 Dec 2021 11:49:38 -0500 (EST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OWtUptNjSDoR/Dvw/7bLz/TPDlhvDzir5yHzZZ6DoSH88CG8A6HOlHHGmGCTu2WjotmQrg1EC2tZFCiV61qwU7qLJ2WWdqQMZO7kg81Yox419UOEab69+cnLh5I+RqvHPhZClu/f3hsusG70njRPiyIR7VjU9CsgudGmJ2D0u9q0q6s2oXQMIZCL9oBMVLEzEMsSkpcPVJ5KbkNoJadVvtt31NheneYHMgU+RL/JIo02+CFJYyjZtcR+NkxysA4aew4HlOZOuc2Ih4EZXRH9pSrHTjjdcWXFPmhAXwSbFx5+WcBpNiY9A+UQc54vjCMivIB7HCSJEEj1y4oR1DqEgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com; 
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W9nCFk6+rGgW5VR2SNapsFNkgbbgH+bQ5jnsnfkSEfQ=;
 b=gTwzUS+1nqnhyHYnR8yueVs8cAbNzMJoEKxvG7uwJYqXV1ZfLuF6D7WUFfER4cwugMyJfM2mzb1E7s1Rmyq4n+cokbzl+8Zr+pYI3iQ4cVCGk3RzKJ1FDpzLzgR27Y0jIiEG85ROslKGwUzhgTOzcEJNBA92+brZsc8/4s9BUiZhfNdhEg8jcVSZMwN3mt1QDN60k0gfiDU/pKadWCsnLdXblg8TSWx0dpz54J8H+aVGo4PLB5hBtCebCk3grqeeKTtdAjfHLnbVrEHUX7u900zZv0+PHg1DDr4h1RFnouCr6CbK0mm7UXfplHuFbrGaXxAhCwcEurJ2zoi5H5yAYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1; 
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W9nCFk6+rGgW5VR2SNapsFNkgbbgH+bQ5jnsnfkSEfQ=;
 b=CQr+VgQwTooi7eagyJLw9Ztld7H9Dxr97tkwWiLFHylbFNSYwoTiSBCSWU9av5KmgXmUa/pIsfPjXw0d8fnBSaqJLWxmRM4LTSJiHC2GR69Bld+3Sc3cFn84WvJZyAoYC0t2d/JxQHn5CJ2AYEdv2jdRswWHHeA9RiJpbkkwrUw=
Received: from DM6PR01CA0005.prod.exchangelabs.com (2603:10b6:5:296::10) by
 BY5PR12MB4034.namprd12.prod.outlook.com (2603:10b6:a03:205::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4755.11; Fri, 10 Dec 2021 16:49:35 +0000
Received: from DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:296:cafe::b9) by DM6PR01CA0005.outlook.office365.com
 (2603:10b6:5:296::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.13 via Frontend
 Transport; Fri, 10 Dec 2021 16:49:35 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com;
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT040.mail.protection.outlook.com (10.13.173.133) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.4778.13 via Frontend Transport; Fri, 10 Dec 2021 16:49:35 +0000
Received: from localhost (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Fri, 10 Dec
 2021 10:49:34 -0600
From: Michael Roth <michael.roth@amd.com>
To: <linux-kselftest@vger.kernel.org>
Subject: [PATCH RFC 05/10] kvm: s390: selftests: use ucall_ops to define
 default ucall implementation
Date: Fri, 10 Dec 2021 10:46:15 -0600
Message-ID: <20211210164620.11636-6-michael.roth@amd.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211210164620.11636-1-michael.roth@amd.com>
References: <20211210164620.11636-1-michael.roth@amd.com>
MIME-Version: 1.0
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB03.amd.com
 (10.181.40.144)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 019c4edf-1e10-4762-5f04-08d9bbfd0c0a
X-MS-TrafficTypeDiagnostic: BY5PR12MB4034:EE_
X-Microsoft-Antispam-PRVS: <BY5PR12MB40349678DCF560EF5A20168695719@BY5PR12MB4034.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6imi8g9jEf4u6gpR1UuQ2gyT/JDXZJfHiwC6yfWny3lxSgmbeUFJU80px5lHvQsO9zRZdvPykizduvVwGoM6PX+Wcg2/mnC9J81Fw/MqBVFCGLi5gN+SueG/SRb7K8J+4H0DvtNtFiwee2qQFf8Au7XSATF4Nj9L5jfnpjEovFBzlRX9Wfcee/sAqnzptfJNK9Vu9lDUyoATwW6fozjt4oN2FbQR39SGn1Scw3TCRKANtpp37ysYPqiSYw0nN+pimMdH1mUFvp9A6fxsBjKNvWDzEIcpg5sGO1k0EPLK/fhZLtj2fc35b7Tykbkd38VlM3c3z9ZYgcd63S8scV0mfOBYVUxIcSQ/Rc6HCDmFWF4bfVK7B0Dt7waOI3lLOtX+3xJcm5SnUWKaccUcgiqZvECDh+c2bBDVPQeboPya+4BBbbFlJM7sRgLYJ4SVznjWi/4u367UG+g07l2s0XnlDzTvoGR3rTWDBnt1QY1Jask3rvlGwRCI/ShfXEidK7mCw15PU67BF5qv3QwngbnWuX2N2NXPldHoYj6v3bTpXBQdVrRKBBHunX2AR24SPb+JMZCFkIjXdSc9vvG0feyHpDkQGFrSfGpAm1jQhMn3C41J+ce1J1bYTQLZVkC0Ay3yH3eW5tw/FmAvgrAAA9MBBQjR+4koQ6RwIqQ/xi3m0QoOpIRUqXxApl6FsuR4XYdliKZEPd9K6qPtV4VjlaEDdP636q0Y865U/FY4n+FEPDbfe2R8uPFp4i52GeVLk6NzfGJmy/HhmjNa9gqgX775ypgaM0rkzJk348zk532BiaE=
X-Forefront-Antispam-Report: CIP:165.204.84.17; CTRY:US; LANG:en; SCL:1; SRV:;
 IPV:CAL; SFV:NSPM; H:SATLEXMB03.amd.com; PTR:InfoDomainNonexistent; CAT:NONE;
 SFS:(4636009)(36840700001)(46966006)(40470700001)(316002)(82310400004)(356005)(508600001)(8936002)(2616005)(1076003)(40460700001)(2906002)(86362001)(5660300002)(4326008)(6916009)(54906003)(26005)(6666004)(186003)(81166007)(36756003)(16526019)(83380400001)(70206006)(336012)(36860700001)(47076005)(70586007)(7416002)(44832011)(426003)(8676002)(36900700001);
 DIR:OUT; SFP:1101; 
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2021 16:49:35.1908 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 019c4edf-1e10-4762-5f04-08d9bbfd0c0a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d; Ip=[165.204.84.17];
 Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4034
X-Mailman-Approved-At: Fri, 10 Dec 2021 12:36:33 -0500
Cc: Brijesh Singh <brijesh.singh@amd.com>, kvm@vger.kernel.org,
 David Hildenbrand <david@redhat.com>, Marc Orr <marcorr@google.com>,
 "H . Peter Anvin" <hpa@zytor.com>, Claudio
 Imbrenda <imbrenda@linux.ibm.com>, Shuah Khan <shuah@kernel.org>,
 kvmarm@lists.cs.columbia.edu, Nathan Tempelman <natet@google.com>,
 Janosch Frank <frankja@linux.ibm.com>, Marc Zyngier <maz@kernel.org>,
 Joerg Roedel <joro@8bytes.org>, x86@kernel.org, Ingo Molnar <mingo@redhat.com>,
 Mingwei Zhang <mizhang@google.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Tom Lendacky <thomas.lendacky@amd.com>, Borislav Petkov <bp@alien8.de>,
 Thomas Gleixner <tglx@linutronix.de>, Varad Gautam <varad.gautam@suse.com>,
 Jim Mattson <jmattson@google.com>, Steve
 Rutherford <srutherford@google.com>, linux-kernel@vger.kernel.org,
 Vitaly Kuznetsov <vkuznets@redhat.com>, David Woodhouse <dwmw@amazon.co.uk>
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

As with x86, switch the default ucall implementation to using the new
ucall_ops infrastructure. With this change ucall_init/ucall_uninit are
no longer arch-specific and can now be dropped in favor of the ones in
ucall_common.c.

Signed-off-by: Michael Roth <michael.roth@amd.com>
---
 tools/testing/selftests/kvm/Makefile          |  6 +--
 .../testing/selftests/kvm/include/kvm_util.h  | 10 -----
 .../selftests/kvm/include/s390x/ucall.h       | 18 ++++++++
 tools/testing/selftests/kvm/lib/s390x/ucall.c | 45 +++++++------------
 4 files changed, 38 insertions(+), 41 deletions(-)
 create mode 100644 tools/testing/selftests/kvm/include/s390x/ucall.h

diff --git a/tools/testing/selftests/kvm/Makefile b/tools/testing/selftests/kvm/Makefile
index 2d4299961d0e..06a02b6fa907 100644
--- a/tools/testing/selftests/kvm/Makefile
+++ b/tools/testing/selftests/kvm/Makefile
@@ -33,9 +33,9 @@ ifeq ($(ARCH),s390)
 	UNAME_M := s390x
 endif
 
-LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c
-LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S lib/ucall_common.c
-LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c lib/aarch64/vgic.c lib/ucall_common.c
+LIBKVM = lib/assert.c lib/elf.c lib/io.c lib/kvm_util.c lib/rbtree.c lib/sparsebit.c lib/test_util.c lib/guest_modes.c lib/perf_test_util.c lib/ucall_common.c
+LIBKVM_x86_64 = lib/x86_64/apic.c lib/x86_64/processor.c lib/x86_64/vmx.c lib/x86_64/svm.c lib/x86_64/ucall.c lib/x86_64/handlers.S
+LIBKVM_aarch64 = lib/aarch64/processor.c lib/aarch64/ucall.c lib/aarch64/handlers.S lib/aarch64/spinlock.c lib/aarch64/gic.c lib/aarch64/gic_v3.c lib/aarch64/vgic.c
 LIBKVM_s390x = lib/s390x/processor.c lib/s390x/ucall.c lib/s390x/diag318_test_handler.c
 
 TEST_GEN_PROGS_x86_64 = x86_64/cr4_cpuid_sync_test
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing/selftests/kvm/include/kvm_util.h
index 16ec8c53cd81..f6ec4fcd66d9 100644
--- a/tools/testing/selftests/kvm/include/kvm_util.h
+++ b/tools/testing/selftests/kvm/include/kvm_util.h
@@ -8,16 +8,6 @@
 #define SELFTEST_KVM_UTIL_H
 
 #include "kvm_util_base.h"
-/*
- * TODO: ucall.h contains arch-specific declarations along with
- * ucall_common.h. For now only a subset of archs provide the
- * new header. Once all archs implement the new header the #include for
- * ucall_common.h can be dropped.
- */
-#if defined(__x86_64__) || defined (__aarch64__)
 #include "ucall.h"
-#else
-#include "ucall_common.h"
-#endif
 
 #endif /* SELFTEST_KVM_UTIL_H */
diff --git a/tools/testing/selftests/kvm/include/s390x/ucall.h b/tools/testing/selftests/kvm/include/s390x/ucall.h
new file mode 100644
index 000000000000..6ba8bc77d667
--- /dev/null
+++ b/tools/testing/selftests/kvm/include/s390x/ucall.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Arch-specific ucall implementations.
+ *
+ * A ucall is a "hypercall to userspace".
+ *
+ * Copyright (C) 2021 Advanced Micro Devices
+ */
+#ifndef SELFTEST_KVM_UCALL_H
+#define SELFTEST_KVM_UCALL_H
+
+#include "ucall_common.h"
+
+extern const struct ucall_ops ucall_ops_diag501;
+
+extern const struct ucall_ops ucall_ops_default;
+
+#endif /* SELFTEST_KVM_UCALL_H */
diff --git a/tools/testing/selftests/kvm/lib/s390x/ucall.c b/tools/testing/selftests/kvm/lib/s390x/ucall.c
index 9d3b0f15249a..67f1baa42b28 100644
--- a/tools/testing/selftests/kvm/lib/s390x/ucall.c
+++ b/tools/testing/selftests/kvm/lib/s390x/ucall.c
@@ -1,46 +1,27 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * ucall support. A ucall is a "hypercall to userspace".
+ * Arch-specific ucall implementations.
+ *
+ * A ucall is a "hypercall to userspace".
  *
  * Copyright (C) 2019 Red Hat, Inc.
  */
-#include "kvm_util.h"
-
-void ucall_init(struct kvm_vm *vm, void *arg)
-{
-}
-
-void ucall_uninit(struct kvm_vm *vm)
-{
-}
+#include "kvm_util_base.h"
+#include "ucall.h"
 
-void ucall(uint64_t cmd, int nargs, ...)
+static void
+ucall_ops_diag501_send_cmd(struct ucall *uc)
 {
-	struct ucall uc = {
-		.cmd = cmd,
-	};
-	va_list va;
-	int i;
-
-	nargs = nargs <= UCALL_MAX_ARGS ? nargs : UCALL_MAX_ARGS;
-
-	va_start(va, nargs);
-	for (i = 0; i < nargs; ++i)
-		uc.args[i] = va_arg(va, uint64_t);
-	va_end(va);
-
 	/* Exit via DIAGNOSE 0x501 (normally used for breakpoints) */
 	asm volatile ("diag 0,%0,0x501" : : "a"(&uc) : "memory");
 }
 
-uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
+static uint64_t
+ucall_ops_diag501_recv_cmd(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
 {
 	struct kvm_run *run = vcpu_state(vm, vcpu_id);
 	struct ucall ucall = {};
 
-	if (uc)
-		memset(uc, 0, sizeof(*uc));
-
 	if (run->exit_reason == KVM_EXIT_S390_SIEIC &&
 	    run->s390_sieic.icptcode == 4 &&
 	    (run->s390_sieic.ipa >> 8) == 0x83 &&    /* 0x83 means DIAGNOSE */
@@ -57,3 +38,11 @@ uint64_t get_ucall(struct kvm_vm *vm, uint32_t vcpu_id, struct ucall *uc)
 
 	return ucall.cmd;
 }
+
+const struct ucall_ops ucall_ops_diag501 = {
+	.name = "diag501",
+	.send_cmd = ucall_ops_diag501_send_cmd,
+	.recv_cmd = ucall_ops_diag501_recv_cmd,
+};
+
+const struct ucall_ops ucall_ops_default = ucall_ops_diag501;
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
