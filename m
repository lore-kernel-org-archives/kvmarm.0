Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 732D8535FC2
	for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 10:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790074440; cv=none; b=CRJECQaiZB92N6vHJfQCsM7VHIqOeZhAZ/3clw4h4Aqlr/EiY4HrJhihDx+uS3/yhyCxJszTWKC5+980yK39UBUxR6xF9ITyyYN+2CS0eyJIZ3YS7NBG+veYGXuCEixtRNgeNOEq85yjFM09sM+EKunS35yNBdD2TLIyS+ydznk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790074440; c=relaxed/simple;
	bh=vNW+yTPcuPzdtPjrYo3/hoVXx9nsapP55EEFBlMGMb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oxue+ewK+4SKcAheLluWPvmmOA6sBKZn1Sy3rREuOdCWqbEAjn3c9PxUiem61ovlpaPNEJzV4zQFDzH6xyaVsP8gnHjQE+ewcYC92J5Xw4F1J+v79TvSjZO0s+yxvdsabsGR9C9fAuFYY0dH2ieWsTIqr71NxqRyONLF3T/SMUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rCHIhdlc; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rCHIhdlc"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-86ec25cf7ecso706655b3a.1
        for <kvmarm@lists.linux.dev>; Tue, 22 Sep 2026 03:53:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790074426; x=1790679226; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H9gt7rJ9fjZQU3mBCr/CwTz7RfxeR0IdQmWX86WZbcc=;
        b=rCHIhdlccjtUf11InVNlv/862x7x1Xhnd5EddtAb3Qfcuk35EGKggGI498Qi/ipOaZ
         S9W/4ixGnlRs5Of0SRr+6eL6VTa5ZTUeWQEl4Q0XKbDALGdnw8YnW/6k8UcX8Dop3Yj5
         nUB9eUexTGlN3pHgWZkXs2KfI9ou3fhUuAJr4SZHEpmJqxwBReWxN51aaLX6673O5dCF
         fW4rrh4riDQ7xMl90wYRtXNLEVnMsNtmbfepl0UbcuBPCHq1Zz276+kiRsGo45pyUdKl
         HOZQGzcyHGV9v8+EqnGHrBn0TFDou3VgA2yTRqNygMj5PHGslH+NvOmhFronWDO5ecMk
         Rrdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790074426; x=1790679226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=H9gt7rJ9fjZQU3mBCr/CwTz7RfxeR0IdQmWX86WZbcc=;
        b=xtVM9WmEvCgi/9ZR6qutaom2jcCc54CQnVVcKE5xfxpLiDQVRCYsfazZxLl3Cmdzr/
         Nm/nnFFfQJdF8OXN3pgMWZex0aOUQp3T8ta76tp5CqNmdeH+cNuadZddXn7BrmVDRTKr
         OcwL+5dYLIcGPhM22ayPNrkoq+G3ZPNLEQvaMOfWSc3R8iVF+1ULc4OPAko2C89hQzNp
         6DLKYLOy6YCvlfLPR3cbRO5s2lTrK2e07H9BgNTwXr974m1ssyoQRjJd5AGJO3ApqmQW
         LMUbUTpH8Yn1jsGJWjFr5Pb/CGsrFCa4wQznG5j77iIwXuf6PRqh4mLvPfZYrlYJeHYE
         lX3g==
X-Forwarded-Encrypted: i=1; AKwUvBzYRrwJUXcRg2q6mqGn3D8LtB/FihJTWN4tAzWPtpjsFX7kEMKCEW9Od+UO8hNzHIfGGGnkx6w=@lists.linux.dev
X-Gm-Message-State: AFuF++mPO4yw3H2kejqrxFiIR3w2zKuPhUxt5Xn7nvwxtQ2882DmvDul
	9AAZ1j4Lyu88jzl27KzEHJ/z5M9HGWKtzgVt3b/O9CdbW0WLQ5pCLxmB
X-Gm-Gg: AYBFou3+IIRtYSnpRM+UWsa11WXlijV10YuIJPy0bOvaHPJPuGSrV3XW8farVuwofT6
	X1pAy8BR0JVpD6f67WdvnUIDpXPylMugzdwtilIQzZ7kHC7/TZGxNdMQbvqWU9aNgwOcFs9Z4+X
	x/k6FXlmFOo+hPzI/Ca+VQEr2k60GGmsdTplTZSJ0S/zeQcS2IKl0TBdk8zx2w0Rqu37Bu4+dv1
	zvog6TqmvN6smnhlxzEHS2nSi58TCPUjH0QG2uwUT5bg8MygUdDrOjHcRsFm9tXavE971PU4aTi
	mcxCnw1sM3tt+0U83NxwBh6Po99UAwpTwrYPcyzufLw4sdKx7AVyyesfqC+tWuwIDAuP4sCrEj1
	4DXNAFPX9zgQVYPy0cVK6UMt3LOIJoQZySAiipFMsbSUZS0dVnYF8XKpOjYafP61R23587Qe2l2
	gDsl6B9NZ5HRSo9uWfN1UdYC8x+ZZ1EX+0GVEv077woev9j3NJO8NHHP9nX+Zp7RpZ5s7jSu5TV
	8fDXq+aCQ9B4h0k96k2D82CYhep/y/+kjiSRNo=
X-Received: by 2002:a05:6a00:440e:b0:874:2166:4b76 with SMTP id d2e1a72fcca58-87c844386e3mr546940b3a.28.1790074426414;
        Tue, 22 Sep 2026 03:53:46 -0700 (PDT)
Received: from localhost.localdomain ([2409:8a1e:2e81:7320:e5f5:eb9b:fe8e:9197])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87c333a93adsm647344b3a.58.2026.09.22.03.53.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 22 Sep 2026 03:53:45 -0700 (PDT)
From: Yuchao Zhang <ndaugoing@gmail.com>
To: Marc Zyngier <maz@kernel.org>
Cc: Oliver Upton <oupton@kernel.org>,
	Fuad Tabba <fuad.tabba@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	sashiko-reviews@lists.linux.dev,
	kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Yuchao Zhang <ndaugoing@gmail.com>
Subject: [PATCH v2] KVM: selftests: arm64: Add test for cross-vCPU LPI disable race
Date: Tue, 22 Sep 2026 18:53:31 +0800
Message-ID: <20260922105331.40498-1-ndaugoing@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260922102959.41FFA1F000FF@smtp.kernel.org>
References: <20260922102959.41FFA1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a selftest that validates the behavior of remote LPI disabling
while the target vCPU has in-flight/overflowing LPIs.

The test configures an ITS with multiple LPIs targeting vCPU 0, which
receives a continuous stream of MSIs forcing its List Registers to
overflow into the ap_list. Concurrently, vCPU 1 repeatedly toggles
GICR_CTLR.EnableLPIs on vCPU 0's redistributor.

On unpatched kernels, this race can lead to a use-after-free or host
kernel panic in vgic_fold_lr_state() due to a dangling last_lr_irq
pointer. With the fix in place (stopping the VM and holding a
refcount on last_lr_irq), the test runs to completion without errors.

Signed-off-by: Yuchao Zhang <ndaugoing@gmail.com>
---
v2:
- Only send INVALL and SYNC for the mapped collection / target vCPU;
  commands targeting unmapped collections or untouched vCPUs are
  unnecessary and can stall the virtual ITS queue (Sashiko review).
- Re-establish the ITS mappings after every EnableLPIs toggle, since
  the disable path invalidates the ITS caches and the MSI flood would
  otherwise go silent after the first iteration.
- Bounds-check the -e argument and assert nr_lpis <= SZ_64K in
  configure_lpis() so it cannot overflow the 64K ITT or LPI prop tables
  (Sashiko review).
- Correctly check KVM_SIGNAL_MSI return value (>0 on success) and count
  successful injections, asserting at the end that at least one succeeded
  (Sashiko review).
 tools/testing/selftests/kvm/Makefile.kvm      |   1 +
 .../selftests/kvm/arm64/vgic_lpi_disable.c    | 430 ++++++++++++++++++
 2 files changed, 431 insertions(+)
 create mode 100644 tools/testing/selftests/kvm/arm64/vgic_lpi_disable.c

diff --git a/tools/testing/selftests/kvm/Makefile.kvm b/tools/testing/selftests/kvm/Makefile.kvm
index 96bab7002d39..cf0baec3f6c7 100644
--- a/tools/testing/selftests/kvm/Makefile.kvm
+++ b/tools/testing/selftests/kvm/Makefile.kvm
@@ -190,6 +190,7 @@ TEST_GEN_PROGS_arm64 += arm64/vcpu_width_config
 TEST_GEN_PROGS_arm64 += arm64/vgic_init
 TEST_GEN_PROGS_arm64 += arm64/vgic_irq
 TEST_GEN_PROGS_arm64 += arm64/vgic_lpi_stress
+TEST_GEN_PROGS_arm64 += arm64/vgic_lpi_disable
 TEST_GEN_PROGS_arm64 += arm64/vgic_v5
 TEST_GEN_PROGS_arm64 += arm64/vpmu_counter_access
 TEST_GEN_PROGS_arm64 += arm64/no-vgic
diff --git a/tools/testing/selftests/kvm/arm64/vgic_lpi_disable.c b/tools/testing/selftests/kvm/arm64/vgic_lpi_disable.c
new file mode 100644
index 000000000000..d3480369d760
--- /dev/null
+++ b/tools/testing/selftests/kvm/arm64/vgic_lpi_disable.c
@@ -0,0 +1,430 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * vgic_lpi_disable - Test cross-vCPU LPI disabling race condition
+ *
+ * Copyright (c) 2026 Yuchao Zhang <ndaugoing@gmail.com>
+ *
+ * This test verifies that disabling LPIs from a remote vCPU while the
+ * target vCPU has in-flight/overflowing LPIs does not lead to use-after-free
+ * or kernel panic.
+ */
+
+#include <linux/sizes.h>
+#include <pthread.h>
+#include <stdatomic.h>
+#include <sys/sysinfo.h>
+
+#include "kvm_util.h"
+#include "delay.h"
+#include "gic.h"
+#include "gic_v3.h"
+#include "gic_v3_its.h"
+#include "processor.h"
+#include "ucall.h"
+#include "vgic.h"
+
+#define TEST_MEMSLOT_INDEX	1
+#define GIC_LPI_OFFSET		8192
+
+#define TARGET_VCPU_ID		0
+#define DISABLER_VCPU_ID	1
+
+static size_t nr_iterations = 200;
+static gpa_t gpa_base;
+static atomic_int lpis_injected;
+
+static struct kvm_vm *vm;
+static struct kvm_vcpu **vcpus;
+static int its_fd;
+
+static struct test_data {
+	bool		request_vcpus_stop;
+	u32		nr_cpus;
+	u32		nr_devices;
+	u32		nr_event_ids;
+
+	gpa_t		device_table;
+	gpa_t		collection_table;
+	gpa_t		cmdq_base;
+	void		*cmdq_base_va;
+	gpa_t		itt_tables;
+
+	gpa_t		lpi_prop_table;
+	gpa_t		lpi_pend_tables;
+} test_data = {
+	.nr_cpus	= 2,
+	.nr_devices	= 1,
+	.nr_event_ids	= 64,
+};
+
+static void guest_irq_handler(struct ex_regs *regs)
+{
+	u32 intid = gic_get_and_ack_irq();
+
+	if (intid == IAR_SPURIOUS)
+		return;
+
+	GUEST_ASSERT(intid >= GIC_LPI_OFFSET);
+	gic_set_eoi(intid);
+}
+
+static void guest_setup_its_mappings(void)
+{
+	u32 device_id, event_id, intid = GIC_LPI_OFFSET;
+	u32 nr_events = test_data.nr_event_ids;
+	u32 nr_devices = test_data.nr_devices;
+
+	/* Map collection 0 to TARGET_VCPU_ID */
+	its_send_mapc_cmd(test_data.cmdq_base_va, TARGET_VCPU_ID, TARGET_VCPU_ID, true);
+
+	/* Map all LPIs to TARGET_VCPU_ID to force LR overflow */
+	for (device_id = 0; device_id < nr_devices; device_id++) {
+		gpa_t itt_base = test_data.itt_tables + (device_id * SZ_64K);
+
+		its_send_mapd_cmd(test_data.cmdq_base_va, device_id,
+				  itt_base, SZ_64K, true);
+
+		for (event_id = 0; event_id < nr_events; event_id++) {
+			its_send_mapti_cmd(test_data.cmdq_base_va, device_id,
+					   event_id, TARGET_VCPU_ID, intid++);
+		}
+	}
+}
+
+static void guest_invalidate_rdists(void)
+{
+	/*
+	 * Only collection TARGET_VCPU_ID is mapped; INVALL for an
+	 * unmapped collection is a command error that stalls the
+	 * virtual ITS command queue.
+	 */
+	its_send_invall_cmd(test_data.cmdq_base_va, TARGET_VCPU_ID);
+}
+
+static void guest_setup_gic(void)
+{
+	static atomic_int nr_cpus_ready;
+	u32 cpuid = guest_get_vcpuid();
+
+	gic_init(GIC_V3, test_data.nr_cpus);
+	gic_rdist_enable_lpis(test_data.lpi_prop_table, SZ_64K,
+			      test_data.lpi_pend_tables + (cpuid * SZ_64K));
+
+	atomic_fetch_add(&nr_cpus_ready, 1);
+
+	if (cpuid > 0)
+		return;
+
+	while (atomic_load(&nr_cpus_ready) < test_data.nr_cpus)
+		cpu_relax();
+
+	its_init(test_data.collection_table, SZ_64K,
+		 test_data.device_table, SZ_64K,
+		 test_data.cmdq_base, SZ_64K);
+
+	guest_setup_its_mappings();
+	guest_invalidate_rdists();
+
+	/* SYNC to ensure ITS setup is complete */
+	its_send_sync_cmd(test_data.cmdq_base_va, TARGET_VCPU_ID);
+}
+
+static inline void *test_gicr_base_cpu(u32 cpu)
+{
+	return (void *)(GICR_BASE_GPA + cpu * SZ_64K * 2);
+}
+
+static void test_gicv3_gicr_wait_for_rwp(u32 cpu)
+{
+	unsigned int count = 100000;
+
+	while (readl(test_gicr_base_cpu(cpu) + GICR_CTLR) & GICR_CTLR_RWP) {
+		GUEST_ASSERT(count--);
+		udelay(10);
+	}
+}
+
+static void guest_code(size_t nr_lpis)
+{
+	u32 cpuid = guest_get_vcpuid();
+
+	guest_setup_gic();
+
+	if (cpuid == TARGET_VCPU_ID) {
+		local_irq_enable();
+		GUEST_SYNC(0);
+
+		while (!READ_ONCE(test_data.request_vcpus_stop))
+			cpu_relax();
+	} else {
+		GUEST_SYNC(0);
+
+		for (size_t i = 0; i < nr_iterations; i++) {
+			/* Remotely disable LPIs on target vCPU */
+			writel(0, test_gicr_base_cpu(TARGET_VCPU_ID) + GICR_CTLR);
+			test_gicv3_gicr_wait_for_rwp(TARGET_VCPU_ID);
+
+			for (int d = 0; d < 50; d++)
+				cpu_relax();
+
+			/* Remotely re-enable LPIs on target vCPU */
+			writel(GICR_CTLR_ENABLE_LPIS,
+			       test_gicr_base_cpu(TARGET_VCPU_ID) + GICR_CTLR);
+			test_gicv3_gicr_wait_for_rwp(TARGET_VCPU_ID);
+
+			/*
+			 * The disable path invalidates the ITS caches, so
+			 * re-establish the mappings for the next round of
+			 * injections.
+			 */
+			guest_setup_its_mappings();
+			guest_invalidate_rdists();
+			its_send_sync_cmd(test_data.cmdq_base_va,
+					  TARGET_VCPU_ID);
+		}
+
+		WRITE_ONCE(test_data.request_vcpus_stop, true);
+	}
+
+	GUEST_DONE();
+}
+
+static void setup_memslot(void)
+{
+	size_t pages;
+	size_t sz;
+
+	sz = (3 + test_data.nr_devices) * SZ_64K;
+	sz += (1 + test_data.nr_cpus) * SZ_64K;
+
+	pages = sz / vm->page_size;
+	gpa_base = ((vm_compute_max_gfn(vm) + 1) * vm->page_size) - sz;
+	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, gpa_base,
+				    TEST_MEMSLOT_INDEX, pages, 0);
+}
+
+#define LPI_PROP_DEFAULT_PRIO	0xa0
+
+static void configure_lpis(void)
+{
+	size_t nr_lpis = test_data.nr_devices * test_data.nr_event_ids;
+	u8 *tbl = addr_gpa2hva(vm, test_data.lpi_prop_table);
+	size_t i;
+
+	TEST_ASSERT(nr_lpis <= SZ_64K,
+		    "nr_lpis (%zu) exceeds 64K prop table", nr_lpis);
+
+	for (i = 0; i < nr_lpis; i++) {
+		tbl[i] = LPI_PROP_DEFAULT_PRIO |
+			 LPI_PROP_GROUP1 |
+			 LPI_PROP_ENABLED;
+	}
+}
+
+static void setup_test_data(void)
+{
+	size_t pages_per_64k = vm_calc_num_guest_pages(vm->mode, SZ_64K);
+	u32 nr_devices = test_data.nr_devices;
+	u32 nr_cpus = test_data.nr_cpus;
+	gpa_t cmdq_base;
+
+	test_data.device_table = vm_phy_pages_alloc(vm, pages_per_64k,
+						    gpa_base,
+						    TEST_MEMSLOT_INDEX);
+
+	test_data.collection_table = vm_phy_pages_alloc(vm, pages_per_64k,
+							gpa_base,
+							TEST_MEMSLOT_INDEX);
+
+	cmdq_base = vm_phy_pages_alloc(vm, pages_per_64k, gpa_base,
+				       TEST_MEMSLOT_INDEX);
+	virt_map(vm, cmdq_base, cmdq_base, pages_per_64k);
+	test_data.cmdq_base = cmdq_base;
+	test_data.cmdq_base_va = (void *)cmdq_base;
+
+	test_data.itt_tables = vm_phy_pages_alloc(vm, pages_per_64k * nr_devices,
+						  gpa_base, TEST_MEMSLOT_INDEX);
+
+	test_data.lpi_prop_table = vm_phy_pages_alloc(vm, pages_per_64k,
+						      gpa_base, TEST_MEMSLOT_INDEX);
+	configure_lpis();
+
+	test_data.lpi_pend_tables = vm_phy_pages_alloc(vm, pages_per_64k * nr_cpus,
+						       gpa_base, TEST_MEMSLOT_INDEX);
+
+	sync_global_to_guest(vm, test_data);
+}
+
+static void setup_gic(void)
+{
+	its_fd = vgic_its_setup(vm);
+}
+
+static void signal_lpi(u32 device_id, u32 event_id)
+{
+	gpa_t db_addr = GITS_BASE_GPA + GITS_TRANSLATER;
+
+	struct kvm_msi msi = {
+		.address_lo	= db_addr,
+		.address_hi	= db_addr >> 32,
+		.data		= event_id,
+		.devid		= device_id,
+		.flags		= KVM_MSI_VALID_DEVID,
+	};
+
+	int ret = __vm_ioctl(vm, KVM_SIGNAL_MSI, &msi);
+
+	/*
+	 * KVM_SIGNAL_MSI returns 1 on success (MSI delivered to target vCPU),
+	 * and 0 if the MSI was blocked (e.g. while LPIs are disabled or being
+	 * remapped). Count successes so a permanently broken environment cannot
+	 * yield a false pass.
+	 */
+	if (ret > 0)
+		atomic_fetch_add(&lpis_injected, 1);
+}
+
+static pthread_barrier_t test_setup_barrier;
+
+static atomic_bool stop_lpi_thread;
+
+static void *lpi_worker_thread(void *data)
+{
+	u32 device_id = (size_t)data;
+	u32 event_id;
+
+	pthread_barrier_wait(&test_setup_barrier);
+
+	while (!atomic_load(&stop_lpi_thread)) {
+		for (event_id = 0; event_id < test_data.nr_event_ids; event_id++)
+			signal_lpi(device_id, event_id);
+		usleep(100);
+	}
+
+	return NULL;
+}
+
+static void *vcpu_worker_thread(void *data)
+{
+	struct kvm_vcpu *vcpu = data;
+	struct ucall uc;
+
+	while (true) {
+		vcpu_run(vcpu);
+
+		switch (get_ucall(vcpu, &uc)) {
+		case UCALL_SYNC:
+			pthread_barrier_wait(&test_setup_barrier);
+			continue;
+		case UCALL_DONE:
+			if (vcpu == vcpus[DISABLER_VCPU_ID]) {
+				atomic_store(&stop_lpi_thread, true);
+				write_guest_global(vm, test_data.request_vcpus_stop, true);
+			}
+			return NULL;
+		case UCALL_ABORT:
+			REPORT_GUEST_ASSERT(uc);
+			break;
+		default:
+			TEST_FAIL("Unknown ucall: %lu", uc.cmd);
+		}
+	}
+
+	return NULL;
+}
+
+static void run_test(void)
+{
+	pthread_t *vcpu_threads;
+	pthread_t lpi_thread;
+	u32 i;
+
+	pthread_barrier_init(&test_setup_barrier, NULL, test_data.nr_cpus + 1);
+
+	vcpu_threads = malloc(sizeof(pthread_t) * test_data.nr_cpus);
+	TEST_ASSERT(vcpu_threads, "Failed to allocate vcpu_threads");
+
+	for (i = 0; i < test_data.nr_cpus; i++)
+		pthread_create(&vcpu_threads[i], NULL, vcpu_worker_thread, vcpus[i]);
+
+	pthread_create(&lpi_thread, NULL, lpi_worker_thread, (void *)(size_t)0);
+
+	pthread_join(lpi_thread, NULL);
+	for (i = 0; i < test_data.nr_cpus; i++)
+		pthread_join(vcpu_threads[i], NULL);
+
+	TEST_ASSERT(atomic_load(&lpis_injected) > 0,
+		    "no LPI was ever injected; broken test environment?");
+
+	free(vcpu_threads);
+}
+
+static void setup_vm(void)
+{
+	int i;
+
+	vm = vm_create_with_vcpus(test_data.nr_cpus, guest_code, vcpus);
+
+	vm_init_descriptor_tables(vm);
+	for (i = 0; i < test_data.nr_cpus; i++)
+		vcpu_init_descriptor_tables(vcpus[i]);
+
+	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT, guest_irq_handler);
+
+	setup_memslot();
+	setup_gic();
+	setup_test_data();
+}
+
+static void destroy_vm(void)
+{
+	close(its_fd);
+	kvm_vm_free(vm);
+}
+
+static void help(const char *name)
+{
+	pr_info("Usage: %s [-i iterations] [-e event_ids]\n", name);
+	pr_info(" -i: number of iterations to toggle GICR_CTLR.EnableLPIs (default %lu)\n",
+		nr_iterations);
+	pr_info(" -e: number of event IDs/LPIs to inject (default %u)\n",
+		test_data.nr_event_ids);
+}
+
+int main(int argc, char **argv)
+{
+	int opt;
+
+	TEST_REQUIRE(kvm_supports_vgic_v3());
+
+	while ((opt = getopt(argc, argv, "i:e:h")) != -1) {
+		switch (opt) {
+		case 'i':
+			nr_iterations = atoi_positive("iterations", optarg);
+			break;
+		case 'e':
+			test_data.nr_event_ids = atoi_positive("event_ids", optarg);
+			TEST_ASSERT(test_data.nr_event_ids <= SZ_64K / 8,
+				    "event_ids must fit in one 64K ITT page");
+			break;
+		case 'h':
+		default:
+			help(argv[0]);
+			exit(opt == 'h' ? 0 : 1);
+		}
+	}
+
+	vcpus = malloc(sizeof(struct kvm_vcpu *) * test_data.nr_cpus);
+	TEST_ASSERT(vcpus, "Failed to allocate vcpus array");
+
+	setup_vm();
+	run_test();
+	destroy_vm();
+
+	free(vcpus);
+
+	pr_info("Completed %lu iterations of remote LPI disable successfully\n",
+		nr_iterations);
+
+	return 0;
+}
-- 
2.53.0

