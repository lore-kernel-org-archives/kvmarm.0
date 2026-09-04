Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4175111BC;
	Fri,  4 Sep 2026 17:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788544588; cv=none; b=djTHBmwCiPZunynOo63ggKBHWpQqxdajgUyQU8rbHjoO3oxQIDPfQC3TAeFgAoEIqukjbOXsjhrul4orm9JM81FDpA60Iqhhxd2kAMVlzIAC4h9kgiYw3KeeUYf2RwmfGba3kMoaDcZM8Rp9LODHNLjJzfuCs0hxR2Kx2n71Skc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788544588; c=relaxed/simple;
	bh=pKYsWkAlTdaEl2qFeU+eoOLyQ/Gebv8KxqQnfalA/b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AKmKNRG8JokKZfM4tgf/Bxq6qGOL5t+BDeIEvGv4vB0C0zNPf1LVJrgi2Km7iPiomac5zbXeiCJ7wGggmRmHTJlp3SYToT89s2/emQl3fdOdUvEua4/L+JcWO5JqjPwPhVv4f18rwK0t/6bare3xoh+CV4eAxq9zBzQO/Soi/Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kMMVwINP; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kMMVwINP"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 684GhdeT335136;
	Fri, 4 Sep 2026 17:55:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=corp-2025-04-25; bh=63Fv7
	zT2BVBlASZG2rtkrsa77phYa5TFZK854MyKy2U=; b=kMMVwINPjnU6D7gA+I0bP
	hYfurK2om6e/gKta7Iud0BrEGTfffpZXZZUYChUJeNjcwbYHkTeEjdnUf2EspmDF
	KmHJuDQCSc9Xg4X5hWAskx7zwvVkczsYUJ3Ycy/3IBrZJI5S6LSpPlmQcbTQCXPX
	QsLQlSLpbCVGdo/yCslXn0ir54dld0lONKsiucN9uN2xDdmXncGEV6YMMnV7dFw+
	m5x/Lbsd6biyia2bwwKidtq3ECnR3KxcpEg1trN74qdm07e5FLuWjEVTEmhi3lJ+
	ojeFpmAYtebZnUzHJ8dJR0MDHonGZImlYdz4GYNAArByVmj7BzOpOSJb2vtxdly6
	w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gbqfcbcbf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Sep 2026 17:55:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 684HoYp0016090;
	Fri, 4 Sep 2026 17:55:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4gbnvv368d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 04 Sep 2026 17:55:55 +0000 (GMT)
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 684HrwmL032217;
	Fri, 4 Sep 2026 17:55:54 GMT
Received: from donglzha-e6-vfio-setup.osdevelopmeniad.oraclevcn.com (donglzha-e6-vfio-setup.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.255.69])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4gbnvv366p-4;
	Fri, 04 Sep 2026 17:55:54 +0000 (GMT)
From: Dongli Zhang <dongli.zhang@oracle.com>
To: kvm@vger.kernel.org, kvmarm@lists.linux.dev, loongarch@lists.linux.dev,
        kvm-riscv@lists.infradead.org, linux-kselftest@vger.kernel.org
Cc: maz@kernel.org, oupton@kernel.org, fuad.tabba@linux.dev,
        joey.gouly@arm.com, seiden@linux.ibm.com, suzuki.poulose@arm.com,
        yuzenghui@huawei.com, zhaotianrui@loongson.cn, maobibo@loongson.cn,
        chenhuacai@kernel.org, anup@brainfault.org, atish.patra@linux.dev,
        seanjc@google.com, pbonzini@redhat.com, shuah@kernel.org,
        dwmw2@infradead.org, joe.jin@oracle.com
Subject: [PATCH v2 3/4] KVM: selftests: Test steal time across vCPU pid changes on x86
Date: Fri,  4 Sep 2026 17:55:25 +0000
Message-ID: <20260904175550.430266-4-dongli.zhang@oracle.com>
X-Mailer: git-send-email 2.43.7
In-Reply-To: <20260904175550.430266-1-dongli.zhang@oracle.com>
References: <20260904175550.430266-1-dongli.zhang@oracle.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-04_05,2026-09-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0
 mlxscore=0 bulkscore=0 lowpriorityscore=0 phishscore=0 adultscore=0
 mlxlogscore=999 spamscore=0 suspectscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2609040163
X-Proofpoint-GUID: xpDO8lUZPYLxVwl6A5ALkm3RpfxEZEuP
X-Proofpoint-ORIG-GUID: xpDO8lUZPYLxVwl6A5ALkm3RpfxEZEuP
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTA0MDE2MyBTYWx0ZWRfX0Di60q15OOKx
 sLrNW+jdu+TFodAN5IFF3c2rbqeOV9aVbhNl0Elq+me5sBOmJR5frDTn0g/QEsgdV1z7TyjabIy
 /crbElFH7HcJJwPEDZlpemorJpJ3ggrngJRH0w15+VKKJHoEQ3/F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTA0MDE2MyBTYWx0ZWRfX3ZOHL3ECmhPJ
 GL/THp9S/S4Jz8ExkSqI+ZanEqZ1iL254KoS9CgdsuC/Pl/wAwm+DNoNLMaPle+JlEw8Y3HDFOG
 sA9GkEGcgqIIz57xZvDCAoc28Y/jrZjoJpAa3wOdWxhanwU29fpugPp4ibiILaA/sYtuCa86Jo2
 Bou/srWcglqZjxTXT9dit2dXSZjqbI6xBp7+pwQM0ATJLLbOFDP4L/NLBR0q0shxO06zUzZnd19
 tIPGAKoBs131eek7A80XnqC1PEOS2OfE+wir1P+wYxLdbmo5GYt+OZ3BhxXz+cvfNWIGYYl0EUy
 FFqiTnIRrenl1WAL5NStaOI2KixpBcs+Yhmex4XvwqU4xW2J5OjtoAkawP2ZyUwoH1S2Auy0NUx
 ZKRZiw95y+xZ+R7DEjs3Zy12D3tVHc9c3VdeLkoZAfLbFTYBPRv7rp2OS+8sbfvHev1rnnU7NAE
 ZIh4AYlE7xsPKXrVVELfoCqQ2l6bjFQcl8g2h1EE=
X-Authority-Analysis: v=2.4 cv=a9gAM0SF c=1 sm=1 tr=0 ts=6a9b062c b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=4HIPAbbDNTLo9391j4cA:9
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:12101

Add a selftest for the case where the same vCPU fd is run from a new host
thread after steal time has already been enabled and updated.

Pin the vCPU thread and a busy-loop thread to CPU 0, force host-side
run_delay to accumulate, and run the vCPU again to observe guest steal
time. Then run the same vCPU fd from a newly created host thread and verify
that the next steal time value observed on the new thread remains monotonic
and sane relative to the value observed on the old thread.

This indirectly validates that vcpu->last_steal is reset when the vCPU run
PID changes.

Assisted-by: Codex:GPT-5.5
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
---
As I have access to only x86 and arm64 KVM hosts, I created and validated
the selftest on those two architectures only.

 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/steal_time_change_pid.c     | 162 ++++++++++++++++++
 2 files changed, 163 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/steal_time_change_pid.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 96bab7002d39..036c28849f84 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -164,6 +164,7 @@ TEST_GEN_PROGS_x86 += irq_test
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
2.43.7

