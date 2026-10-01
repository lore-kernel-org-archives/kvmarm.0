Received: from mta1.migadu.com (out-82.mta1.migadu.com [95.215.58.82])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7B13C10B9
	for <kvmarm@lists.linux.dev>; Thu,  1 Oct 2026 07:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.82
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790838683; cv=none; b=GLUxivm6tQCkS12LY9n4kJnEw8w+GXWzxBnEpfyZ2bbJfpB3Xg4KSm12z+vcOYQJo7TfIbGggbeQfmp9JEo7fgMHAVNBFlLXLfQZVAJZ2N/tfYPplzGNyQ2dK6KtrVADbhPVdBYECt8HGEcx4XjGscqD0EVrD0su41aa7ZQaWxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790838683; c=relaxed/simple;
	bh=HOo5y6QTDCHnkQa5ckZ2GEYF7RbvKYN4owTkDranMnk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Ro5Rmpv/4RzD5qLJqvfi3lEL36tGtx0ysAgJerO8MLn3ajMt9czmxZYQXT0EbiBwoRSi/DwssMKlGjiSDfVcG0KamiNR742EwYoZnSVk4Boy2JZoihXlV4mztvXQenkU/vW/jha//Id47T1gpI8u3wI6AVSrMPUkELkML3OdGhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hrms5o+4; arc=none smtp.client-ip=95.215.58.82
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hrms5o+4"
X-Envelope-To: kvmarm@lists.linux.dev
DKIM-Signature: a=rsa-sha256; bh=HOo5y6QTDCHnkQa5ckZ2GEYF7RbvKYN4owTkDranMnk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790838675; v=1; x=1791443475;
 b=hrms5o+4D9y6eAt60qeqIAuzFTNRPOBKZr+a1wINh4RoPRxUJHOJd1TE6tmM2twzaeUH37Z2
 4qO3n0bLShr6Ekh5XxrnlbMtgqaSl4Hr6FVIdiCkdbPEtuwYsr5t4+InjbPQVZG9HDXqDsVH8Z7
 UyFC85quWFaVbl0EI7Wn1Zsk=
X-Envelope-To: kvmarm@lists.linux.dev
Received: by smtp.migadu.com with ESMTPS id a69b8103f79d734c;
	Thu, 01 Oct 2026 07:11:14 +0000
X-Mizu-Trace-ID: a69b8103f79d734c
X-Migadu-Flow: FLOW_OUT
From: Fuad Tabba <fuad.tabba@linux.dev>
To: Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oupton@kernel.org>
Cc: kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	Will Deacon <will@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Steffen Eiden <seiden@linux.ibm.com>,
	Yuchao Zhang <ndaugoing@gmail.com>,
	Fuad Tabba <tabba@google.com>
Subject: [PATCH v2 2/3] KVM: arm64: selftests: Build a VM per test in vgic_lpi_stress
Date: Thu,  1 Oct 2026 08:10:59 +0100
Message-Id: <20261001071100.190013-3-fuad.tabba@linux.dev>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261001071100.190013-1-fuad.tabba@linux.dev>
References: <20261001071100.190013-1-fuad.tabba@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

vgic_lpi_stress runs its one test, the stress test, in a VM built from
the command-line configuration. Build the VM per test instead, from the
test's own configuration, guest code and IRQ handler, so that other ITS
tests can go in the same file.

The command-line configuration becomes the stress test's own
(stress_args), and each run destroys its thread barrier so the next test
can initialise it again. The guest's wait for the stop request moves to
guest_wait_for_stop(), for the other tests to share.

No functional change intended.

Suggested-by: Marc Zyngier <maz@kernel.org>
Assisted-by: LLM
Signed-off-by: Fuad Tabba <fuad.tabba@linux.dev>
---
 .../selftests/kvm/arm64/vgic_lpi_stress.c     | 64 ++++++++++++-------
 1 file changed, 41 insertions(+), 23 deletions(-)

diff --git a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
index 9a69c439a0f8f..63c725b6b156c 100644
--- a/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
+++ b/tools/testing/selftests/kvm/arm64/vgic_lpi_stress.c
@@ -29,7 +29,7 @@ static struct kvm_vm *vm;
 static struct kvm_vcpu **vcpus;
 static int its_fd;
 
-static struct test_data {
+struct test_data {
 	bool		request_vcpus_stop;
 	u32		nr_cpus;
 	u32		nr_devices;
@@ -43,7 +43,11 @@ static struct test_data {
 
 	gpa_t		lpi_prop_table;
 	gpa_t		lpi_pend_tables;
-} test_data =  {
+};
+
+static struct test_data test_data;
+
+static struct test_data stress_args = {
 	.nr_cpus	= 1,
 	.nr_devices	= 1,
 	.nr_event_ids	= 16,
@@ -124,13 +128,8 @@ static void guest_setup_gic(void)
 		its_send_sync_cmd(test_data.cmdq_base_va, cpuid);
 }
 
-static void guest_code(size_t nr_lpis)
+static void guest_wait_for_stop(void)
 {
-	guest_setup_gic();
-	local_irq_enable();
-
-	GUEST_SYNC(0);
-
 	/*
 	 * Don't use WFI here to avoid blocking the vCPU thread indefinitely and
 	 * never getting the stop signal.
@@ -141,6 +140,16 @@ static void guest_code(size_t nr_lpis)
 	GUEST_DONE();
 }
 
+static void guest_stress_code(size_t nr_lpis)
+{
+	guest_setup_gic();
+	local_irq_enable();
+
+	GUEST_SYNC(0);
+
+	guest_wait_for_stop();
+}
+
 static void setup_memslot(void)
 {
 	size_t pages;
@@ -297,7 +306,7 @@ static void report_stats(struct timespec delta)
 	pr_info("Rate: %.2f LPIs/sec\n", nr_lpis / time);
 }
 
-static void run_test(void)
+static void run_stress_test(void)
 {
 	u32 nr_devices = test_data.nr_devices;
 	u32 nr_vcpus = test_data.nr_cpus;
@@ -329,10 +338,12 @@ static void run_test(void)
 	for (i = 0; i < nr_vcpus; i++)
 		kvm_pthread_join(vcpu_threads[i], NULL);
 
+	pthread_barrier_destroy(&test_setup_barrier);
+
 	report_stats(delta);
 }
 
-static void setup_vm(void)
+static void setup_vm(void *guest_code, handler_fn irq_handler)
 {
 	int i;
 
@@ -345,7 +356,7 @@ static void setup_vm(void)
 	for (i = 0; i < test_data.nr_cpus; i++)
 		vcpu_init_descriptor_tables(vcpus[i]);
 
-	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT, guest_irq_handler);
+	vm_install_exception_handler(vm, VECTOR_IRQ_CURRENT, irq_handler);
 
 	setup_memslot();
 
@@ -361,12 +372,23 @@ static void destroy_vm(void)
 	free(vcpus);
 }
 
+static void test_lpi_stress(void)
+{
+	test_data = stress_args;
+
+	setup_vm(guest_stress_code, guest_irq_handler);
+
+	run_stress_test();
+
+	destroy_vm();
+}
+
 static void pr_usage(const char *name)
 {
 	pr_info("%s [-v NR_VCPUS] [-d NR_DEVICES] [-e NR_EVENTS] [-i ITERS] -h\n", name);
-	pr_info("  -v:\tnumber of vCPUs (default: %u)\n", test_data.nr_cpus);
-	pr_info("  -d:\tnumber of devices (default: %u)\n", test_data.nr_devices);
-	pr_info("  -e:\tnumber of event IDs per device (default: %u)\n", test_data.nr_event_ids);
+	pr_info("  -v:\tnumber of vCPUs (default: %u)\n", stress_args.nr_cpus);
+	pr_info("  -d:\tnumber of devices (default: %u)\n", stress_args.nr_devices);
+	pr_info("  -e:\tnumber of event IDs per device (default: %u)\n", stress_args.nr_event_ids);
 	pr_info("  -i:\tnumber of iterations (default: %lu)\n", nr_iterations);
 }
 
@@ -380,13 +402,13 @@ int main(int argc, char **argv)
 	while ((c = getopt(argc, argv, "hv:d:e:i:")) != -1) {
 		switch (c) {
 		case 'v':
-			test_data.nr_cpus = atoi(optarg);
+			stress_args.nr_cpus = atoi(optarg);
 			break;
 		case 'd':
-			test_data.nr_devices = atoi(optarg);
+			stress_args.nr_devices = atoi(optarg);
 			break;
 		case 'e':
-			test_data.nr_event_ids = atoi(optarg);
+			stress_args.nr_event_ids = atoi(optarg);
 			break;
 		case 'i':
 			nr_iterations = strtoul(optarg, NULL, 0);
@@ -398,16 +420,12 @@ int main(int argc, char **argv)
 		}
 	}
 
-	nr_threads = test_data.nr_cpus + test_data.nr_devices;
+	nr_threads = stress_args.nr_cpus + stress_args.nr_devices;
 	if (nr_threads > get_nprocs())
 		pr_info("WARNING: running %u threads on %d CPUs; performance is degraded.\n",
 			 nr_threads, get_nprocs());
 
-	setup_vm();
-
-	run_test();
-
-	destroy_vm();
+	test_lpi_stress();
 
 	return 0;
 }
-- 
2.39.5

