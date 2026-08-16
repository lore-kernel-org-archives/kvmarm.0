Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AE933C198
	for <kvmarm@lists.linux.dev>; Sun, 16 Aug 2026 05:41:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786858896; cv=none; b=S1EVcvEAheiTUbRL/jNMyazq1q0B9J/DSK8ZN4NxmSLba9g6frE0TOY2OivEXPtOKEpnsEco+XphtDHWmf9FszV3Rs6bnlo2tr5dlRyJ7Yawg3RfvHY3BfearTMRTNp9chawyGhHPYEOhYePMd3DjbQEQ8yhEvzOj9zvx69/hkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786858896; c=relaxed/simple;
	bh=d/Ao4wKiSiLJZi4bRJg/BFn2Y1USPT1CKN7K+Vz0ZDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBfVmams83u389lQp+y7g8FCG/K5OD2P1YluqVZDQLLEtmnmm15HTKHHG7+9tgawcGyW8JzVaiejUZxOUwvmroXmRlmDXZSbRHSO3lpGB6jMJ+VnBGhU7coKEhID9VuOvf3mvffWRApbxHXNhkvR+pkHLjNi5MmPjfX6KJTgp/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bna8cNCl; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bna8cNCl"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67G53sFV1456687;
	Sun, 16 Aug 2026 05:40:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=PyeQb
	6LHbwg25+8X59mZg516oh13F55u7lRDi45/Btk=; b=bna8cNClQPLNttjM35VIO
	qkdubDQXQ/mpqOtwwRGb+HF+i4iEVQscLEN7TWVpH6x8KanvT1ICplfrrr33UOyD
	aRBEhfMke1H1k0prrYIn+ZkzyOr4yUvKR3jtTnjZcl5phTZDbjZIPgPMraETXk6C
	myTEdUNCNC6u3Uup2zpjSebJaeixB/aH7s8T4F3NxBFPYdrLubATS43C2NRs9y7u
	4O+moI+LiedFKhiB33XapVKRz+/mzMDYhKhS0YYsI65oO+daqcqy17Deum/d8Dv/
	Rd5JKUZ1l4y6ohq0OW3AaUgKhlWKkOZ1CcfOvc0wRJvoXUl3m37GO43DDx3NOvms
	w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4g2ehc0y52-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 16 Aug 2026 05:40:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 67G5e9fU011006;
	Sun, 16 Aug 2026 05:40:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4g2ejammcc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 16 Aug 2026 05:40:56 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 67G5ereZ012353;
	Sun, 16 Aug 2026 05:40:56 GMT
Received: from localhost.localdomain (ca-dev80.us.oracle.com [10.211.9.80])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4g2ejammbp-4;
	Sun, 16 Aug 2026 05:40:55 +0000 (GMT)
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev,
        linux-kselftest@vger.kernel.org
Cc: seanjc@google.com, pbonzini@redhat.com, maz@kernel.org, oupton@kernel.org,
        fuad.tabba@linux.dev, joey.gouly@arm.com, seiden@linux.ibm.com,
        suzuki.poulose@arm.com, yuzenghui@huawei.com, dwmw2@infradead.org,
        joe.jin@oracle.com
Subject: [PATCH 3/4] KVM: selftests: Test steal time across vCPU pid changes on x86
Date: Sat, 15 Aug 2026 22:33:04 -0700
Message-ID: <20260816053630.527528-4-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <20260816053630.527528-1-dongli.zhang@oracle.com>
References: <20260816053630.527528-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-16_01,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 spamscore=0 suspectscore=0 bulkscore=0
 adultscore=0 malwarescore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608160039
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODE2MDAzOSBTYWx0ZWRfXy5Zd7bLZySk6
 rl60HTcY3NUNBbWB/zJ68VTXWA7Xcw2zCsbtfIDmtPnH91xdLpdtn5FK/wuw3QO3utQayrWMLQ4
 3JOoml6vYWGLgNb5rzZPWHveuw2yDE9AghTQD1QPCB+1WDJ8EpzxllxcU07S0wlJSyYfc8FuGJD
 ygbP+MWVA73uOS8GN7FC2ezCCvvrimPxxjaGcn7Zj8B6y13qkpQxnIIpWVv4zsHzLB3s5lbkvzf
 MjW2GD5J/m0Jg0TURaAf2heAC/pIi8bPXBLpRBTsNRJvdvbIbGACYJ+GtkCcFFULb7bbzr5qCWH
 aAijBLAmP9Y57ePdvQauYnVKSwWxN+W5+URQvToNPKDSQl+tGROSyruuyj6d8ZZABmmU+0mWLd9
 AlDgUUwY1zqo7pnwfQ5vZlVNgNwzNwnxf27qXmeGOR51E3E8r2oqN7Isgrw30guVdhnBHrHji+c
 VLVZNA7lSluN08AHQWw==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODE2MDAzOSBTYWx0ZWRfX9yCb1K5RWrlC
 T0f4Hu+Lf9H/ip39/oNh2S8f62lgpFLV6AgAOKBb38pJrnSRd0Jue0ygkvjsr+xePiR3Ga0/oJr
 vx6oa3+O14adeCMEtJX5cvW6uSf1j/1ke+4070CfLQLF9ImARrI5
X-Authority-Analysis: v=2.4 cv=fO0JG5ae c=1 sm=1 tr=0 ts=6a814d69 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=x4eqshVgHu-cdnggieHk:22 a=yPCof4ZbAAAA:8 a=PND2N7sVUnHy1iep4VUA:9
X-Proofpoint-GUID: 7rL223awZOWRAmZsF1o6Fsa3BBjLasQ6
X-Proofpoint-ORIG-GUID: 7rL223awZOWRAmZsF1o6Fsa3BBjLasQ6

Add a selftest for the case where the same vCPU fd is run from a new host
thread after steal time has already been enabled and updated.

Pin the vCPU thread and a busy-loop thread to CPU 0, force host-side
run_delay to accumulate, and run the vCPU again to observe guest steal
time. Then run the same vCPU fd from a newly created host thread and verify
that the next steal time value observed on the new thread remains monotonic
and sane relative to the value observed on the old thread.

This indirectly validates that vcpu->arch.st.last_steal is reset when the
vCPU run PID changes.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/steal_time_change_pid.c     | 162 ++++++++++++++++++
 2 files changed, 163 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/steal_time_change_pid.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 6fc34e9bf8e1..c8ce17851561 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -159,6 +159,7 @@ TEST_GEN_PROGS_x86 += hardware_disable_test
 TEST_GEN_PROGS_x86 += mmu_stress_test
 TEST_GEN_PROGS_x86 += rseq_test
 TEST_GEN_PROGS_x86 += steal_time
+TEST_GEN_PROGS_x86 += steal_time_change_pid
 TEST_GEN_PROGS_x86 += system_counter_offset_test
 TEST_GEN_PROGS_x86 += pre_fault_memory_test
 
diff --git a/tools/testing/selftests/kvm/steal_time_change_pid.c b/tools/testing/selftests/kvm/steal_time_change_pid.c
new file mode 100644
index 000000000000..3c39594db398
--- /dev/null
+++ b/tools/testing/selftests/kvm/steal_time_change_pid.c
@@ -0,0 +1,162 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Verify that KVM resets steal-time accounting when a vCPU fd is run from
+ * a different host PID.
+ */
+
+#include <pthread.h>
+#include <asm/kvm_para.h>
+#include "kvm_util.h"
+#include "processor.h"
+
+#define ST_GPA_BASE		(1 << 30)
+#define ST_SANE_DELTA_NS	(1ULL << 63)
+
+static void *st_gva;
+static u64 guest_stolen_time;
+static u64 main_steal;
+static u64 thread_steal;
+
+#if defined(__x86_64__)
+
+#define STEAL_TIME_SIZE	((sizeof(struct kvm_steal_time) + 63) & ~63)
+
+static void guest_code(void)
+{
+	struct kvm_steal_time *st = st_gva;
+
+	WRITE_ONCE(guest_stolen_time, READ_ONCE(st->steal));
+	GUEST_SYNC(0);
+
+	WRITE_ONCE(guest_stolen_time, READ_ONCE(st->steal));
+	GUEST_SYNC(1);
+
+	WRITE_ONCE(guest_stolen_time, READ_ONCE(st->steal));
+	GUEST_DONE();
+}
+
+static bool steal_time_supported(struct kvm_vcpu *vcpu)
+{
+	return kvm_cpu_has(X86_FEATURE_KVM_STEAL_TIME);
+}
+
+static void steal_time_enable(struct kvm_vcpu *vcpu)
+{
+	vcpu_set_msr(vcpu, MSR_KVM_STEAL_TIME,
+		     (ulong)st_gva | KVM_MSR_ENABLED);
+}
+
+#else
+#error "steal_time_change_pid is not implemented on this architecture"
+#endif
+
+static void run_vcpu(struct kvm_vcpu *vcpu)
+{
+	struct ucall uc;
+
+	vcpu_run(vcpu);
+
+	switch (get_ucall(vcpu, &uc)) {
+	case UCALL_SYNC:
+	case UCALL_DONE:
+		break;
+	case UCALL_ABORT:
+		REPORT_GUEST_ASSERT(uc);
+	default:
+		TEST_ASSERT(false, "Unexpected exit: %s",
+			    exit_reason_str(vcpu->run->exit_reason));
+	}
+}
+
+static void *do_steal_time(void *arg)
+{
+	struct timespec ts, stop;
+
+	clock_gettime(CLOCK_MONOTONIC, &ts);
+	stop = timespec_add_ns(ts, MIN_RUN_DELAY_NS);
+
+	while (timespec_to_ns(timespec_sub(ts, stop)) < 0)
+		clock_gettime(CLOCK_MONOTONIC, &ts);
+
+	return NULL;
+}
+
+static void *vcpu_thread(void *arg)
+{
+	struct kvm_vcpu *vcpu = arg;
+
+	run_vcpu(vcpu);
+	sync_global_from_guest(vcpu->vm, guest_stolen_time);
+	thread_steal = guest_stolen_time;
+
+	return NULL;
+}
+
+int main(void)
+{
+	struct kvm_vcpu *vcpu;
+	struct kvm_vm *vm;
+	pthread_attr_t attr;
+	pthread_t thread;
+	cpu_set_t cpuset;
+	long run_delay;
+	long run_delay_delta;
+
+	ksft_print_header();
+	ksft_set_plan(1);
+
+	CPU_ZERO(&cpuset);
+	CPU_SET(0, &cpuset);
+	pthread_attr_init(&attr);
+	pthread_attr_setaffinity_np(&attr, sizeof(cpuset), &cpuset);
+	pthread_setaffinity_np(pthread_self(), sizeof(cpuset), &cpuset);
+
+	vm = vm_create_with_one_vcpu(&vcpu, guest_code);
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS,
+				    ST_GPA_BASE, 1, 1, 0);
+	virt_map(vm, ST_GPA_BASE, ST_GPA_BASE, 1);
+
+	st_gva = (void *)ST_GPA_BASE;
+	sync_global_to_guest(vm, st_gva);
+	memset(addr_gva2hva(vm, ST_GPA_BASE), 0, STEAL_TIME_SIZE);
+
+	TEST_REQUIRE(steal_time_supported(vcpu));
+
+	steal_time_enable(vcpu);
+	run_vcpu(vcpu);
+
+	run_delay = get_run_delay();
+	pthread_create(&thread, &attr, do_steal_time, NULL);
+
+	while (get_run_delay() - run_delay < MIN_RUN_DELAY_NS)
+		sched_yield();
+
+	pthread_join(thread, NULL);
+	run_delay_delta = get_run_delay() - run_delay;
+	TEST_ASSERT(run_delay_delta >= MIN_RUN_DELAY_NS,
+		    "Expected run_delay >= %ld, got %ld",
+		    MIN_RUN_DELAY_NS, run_delay_delta);
+
+	run_vcpu(vcpu);
+	sync_global_from_guest(vm, guest_stolen_time);
+	main_steal = guest_stolen_time;
+
+	TEST_ASSERT(main_steal >= MIN_RUN_DELAY_NS,
+		    "Expected steal time >= %ld, got %"PRIu64,
+		    MIN_RUN_DELAY_NS, main_steal);
+
+	pthread_create(&thread, NULL, vcpu_thread, vcpu);
+	pthread_join(thread, NULL);
+
+	TEST_ASSERT(thread_steal >= main_steal &&
+		    thread_steal - main_steal < ST_SANE_DELTA_NS,
+		    "Expected sane steal after vCPU pid change: "
+		    "old=%"PRIu64", new=%"PRIu64,
+		    main_steal, thread_steal);
+
+	ksft_test_result_pass("steal time remains sane across vCPU pid change\n");
+
+	pthread_attr_destroy(&attr);
+	kvm_vm_free(vm);
+	ksft_finished();
+}
-- 
2.43.5

