Return-Path: <SRS0=dc8k=5U=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B575BC2BA19
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:39:40 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6FFD8206F5
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:39:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IWPv0Z/l"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FFD8206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 051E64B202;
	Sat,  4 Apr 2020 10:39:40 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2z-0cCcxym0S; Sat,  4 Apr 2020 10:39:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 726F24B290;
	Sat,  4 Apr 2020 10:39:37 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E6DC24B179
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:39:35 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oRlJBcogEMCP for <kvmarm@lists.cs.columbia.edu>;
 Sat,  4 Apr 2020 10:39:34 -0400 (EDT)
Received: from us-smtp-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B01BC4B271
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:39:34 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586011174;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=uvnZtk9MYZ3Ee6O6BcV8wY1ClITdYU83OUWZcVLM8OQ=;
 b=IWPv0Z/lQOiLdnQf3sKe+pvSrQia7JeP77NR+odZUSC/TPl5aBdwaKadVFGn0ER2B9MQAp
 q68b/lDcd+n5aQM/bjIx4lBsrpnJkH+KiI+J0Xxjwl3TgjB1oB6ZNqui/cTF3o1Gs4EWJ8
 jhbBr5V8TozoesWrwWHLKprpjsGOrcQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-110-q4bsuQKJOnOrl5rpaXtw8A-1; Sat, 04 Apr 2020 10:39:32 -0400
X-MC-Unique: q4bsuQKJOnOrl5rpaXtw8A-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57D6E8017CE;
 Sat,  4 Apr 2020 14:39:31 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
 by smtp.corp.redhat.com (Postfix) with ESMTP id 0810A9B912;
 Sat,  4 Apr 2020 14:39:29 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: pbonzini@redhat.com
Subject: [PULL kvm-unit-tests 39/39] arm/arm64: ITS: pending table migration
 test
Date: Sat,  4 Apr 2020 16:37:31 +0200
Message-Id: <20200404143731.208138-40-drjones@redhat.com>
In-Reply-To: <20200404143731.208138-1-drjones@redhat.com>
References: <20200404143731.208138-1-drjones@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
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

From: Eric Auger <eric.auger@redhat.com>

Add two new migration tests. One testing the migration of
a topology where collection were unmapped. The second test
checks the migration of the pending table.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
[ Complete migration even when the test is skipped. Otherwise the
  migration scripts hang. Also, without the KVM fix for unmapped
  collections, migration will fail and the test will hang, so use
  errata to skip it instead. ]
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/gic.c         | 152 ++++++++++++++++++++++++++++++++++++++++++++++
 arm/unittests.cfg |  16 +++++
 errata.txt        |   1 +
 3 files changed, 169 insertions(+)

diff --git a/arm/gic.c b/arm/gic.c
index d98d70a5d9e9..dc1e88c67a9c 100644
--- a/arm/gic.c
+++ b/arm/gic.c
@@ -12,6 +12,7 @@
  * This work is licensed under the terms of the GNU LGPL, version 2.
  */
 #include <libcflat.h>
+#include <errata.h>
 #include <asm/setup.h>
 #include <asm/processor.h>
 #include <asm/delay.h>
@@ -193,6 +194,7 @@ static void lpi_handler(struct pt_regs *regs __unused)
 	smp_rmb(); /* pairs with wmb in lpi_stats_expect */
 	lpi_stats.observed.cpu_id = smp_processor_id();
 	lpi_stats.observed.lpi_id = irqnr;
+	acked[lpi_stats.observed.cpu_id]++;
 	smp_wmb(); /* pairs with rmb in check_lpi_stats */
 }
 
@@ -238,6 +240,22 @@ static void secondary_lpi_test(void)
 	while (1)
 		wfi();
 }
+
+static void check_lpi_hits(int *expected, const char *msg)
+{
+	bool pass = true;
+	int i;
+
+	for_each_present_cpu(i) {
+		if (acked[i] != expected[i]) {
+			report_info("expected %d LPIs on PE #%d, %d observed",
+				    expected[i], i, acked[i]);
+			pass = false;
+			break;
+		}
+	}
+	report(pass, "%s", msg);
+}
 #endif
 
 static void gicv2_ipi_send_self(void)
@@ -593,6 +611,8 @@ static void gic_test_mmio(void)
 static void test_its_introspection(void) {}
 static void test_its_trigger(void) {}
 static void test_its_migration(void) {}
+static void test_its_pending_migration(void) {}
+static void test_migrate_unmapped_collection(void) {}
 
 #else /* __aarch64__ */
 
@@ -798,6 +818,130 @@ do_migrate:
 	its_send_int(dev7, 255);
 	check_lpi_stats("dev7/eventid=255 triggers LPI 8196 on PE #2 after migration");
 }
+
+#define ERRATA_UNMAPPED_COLLECTIONS "ERRATA_8c58be34494b"
+
+static void test_migrate_unmapped_collection(void)
+{
+	struct its_collection *col = NULL;
+	struct its_device *dev2 = NULL, *dev7 = NULL;
+	bool test_skipped = false;
+	int pe0 = 0;
+	u8 config;
+
+	if (its_setup1()) {
+		test_skipped = true;
+		goto do_migrate;
+	}
+
+	if (!errata(ERRATA_UNMAPPED_COLLECTIONS)) {
+		report_skip("Skipping test, as this test hangs without the fix. "
+			    "Set %s=y to enable.", ERRATA_UNMAPPED_COLLECTIONS);
+		test_skipped = true;
+		goto do_migrate;
+	}
+
+	col = its_create_collection(pe0, pe0);
+	dev2 = its_get_device(2);
+	dev7 = its_get_device(7);
+
+	/* MAPTI with the collection unmapped */
+	its_send_mapti(dev2, 8192, 0, col);
+	gicv3_lpi_set_config(8192, LPI_PROP_DEFAULT);
+
+do_migrate:
+	puts("Now migrate the VM, then press a key to continue...\n");
+	(void)getchar();
+	report_info("Migration complete");
+	if (test_skipped)
+		return;
+
+	/* on the destination, map the collection */
+	its_send_mapc(col, true);
+	its_send_invall(col);
+
+	lpi_stats_expect(2, 8196);
+	its_send_int(dev7, 255);
+	check_lpi_stats("dev7/eventid= 255 triggered LPI 8196 on PE #2");
+
+	config = gicv3_lpi_get_config(8192);
+	report(config == LPI_PROP_DEFAULT,
+	       "Config of LPI 8192 was properly migrated");
+
+	lpi_stats_expect(pe0, 8192);
+	its_send_int(dev2, 0);
+	check_lpi_stats("dev2/eventid = 0 triggered LPI 8192 on PE0");
+}
+
+static void test_its_pending_migration(void)
+{
+	struct its_device *dev;
+	struct its_collection *collection[2];
+	int *expected = calloc(nr_cpus, sizeof(int));
+	int pe0 = nr_cpus - 1, pe1 = nr_cpus - 2;
+	bool test_skipped = false;
+	u64 pendbaser;
+	void *ptr;
+	int i;
+
+	if (its_prerequisites(4)) {
+		test_skipped = true;
+		goto do_migrate;
+	}
+
+	dev = its_create_device(2 /* dev id */, 8 /* nb_ites */);
+	its_send_mapd(dev, true);
+
+	collection[0] = its_create_collection(pe0, pe0);
+	collection[1] = its_create_collection(pe1, pe1);
+	its_send_mapc(collection[0], true);
+	its_send_mapc(collection[1], true);
+
+	/* disable lpi at redist level */
+	gicv3_lpi_rdist_disable(pe0);
+	gicv3_lpi_rdist_disable(pe1);
+
+	/* lpis are interleaved inbetween the 2 PEs */
+	for (i = 0; i < 256; i++) {
+		struct its_collection *col = i % 2 ? collection[0] :
+						     collection[1];
+		int vcpu = col->target_address >> 16;
+
+		its_send_mapti(dev, LPI(i), i, col);
+		gicv3_lpi_set_config(LPI(i), LPI_PROP_DEFAULT);
+		gicv3_lpi_set_clr_pending(vcpu, LPI(i), true);
+	}
+	its_send_invall(collection[0]);
+	its_send_invall(collection[1]);
+
+	/* Clear the PTZ bit on each pendbaser */
+
+	expected[pe0] = 128;
+	expected[pe1] = 128;
+
+	ptr = gicv3_data.redist_base[pe0] + GICR_PENDBASER;
+	pendbaser = readq(ptr);
+	writeq(pendbaser & ~GICR_PENDBASER_PTZ, ptr);
+
+	ptr = gicv3_data.redist_base[pe1] + GICR_PENDBASER;
+	pendbaser = readq(ptr);
+	writeq(pendbaser & ~GICR_PENDBASER_PTZ, ptr);
+
+	gicv3_lpi_rdist_enable(pe0);
+	gicv3_lpi_rdist_enable(pe1);
+
+do_migrate:
+	puts("Now migrate the VM, then press a key to continue...\n");
+	(void)getchar();
+	report_info("Migration complete");
+	if (test_skipped)
+		return;
+
+	/* let's wait for the 256 LPIs to be handled */
+	mdelay(1000);
+
+	check_lpi_hits(expected, "128 LPIs on both PE0 and PE1 after migration");
+}
 #endif
 
 int main(int argc, char **argv)
@@ -839,6 +983,14 @@ int main(int argc, char **argv)
 		report_prefix_push(argv[1]);
 		test_its_migration();
 		report_prefix_pop();
+	} else if (!strcmp(argv[1], "its-pending-migration")) {
+		report_prefix_push(argv[1]);
+		test_its_pending_migration();
+		report_prefix_pop();
+	} else if (!strcmp(argv[1], "its-migrate-unmapped-collection")) {
+		report_prefix_push(argv[1]);
+		test_migrate_unmapped_collection();
+		report_prefix_pop();
 	} else if (strcmp(argv[1], "its-introspection") == 0) {
 		report_prefix_push(argv[1]);
 		test_its_introspection();
diff --git a/arm/unittests.cfg b/arm/unittests.cfg
index 20a1ae269571..f776b66ef96d 100644
--- a/arm/unittests.cfg
+++ b/arm/unittests.cfg
@@ -199,6 +199,22 @@ extra_params = -machine gic-version=3 -append 'its-migration'
 groups = its migration
 arch = arm64
 
+[its-pending-migration]
+file = gic.flat
+smp = $MAX_SMP
+accel = kvm
+extra_params = -machine gic-version=3 -append 'its-pending-migration'
+groups = its migration
+arch = arm64
+
+[its-migrate-unmapped-collection]
+file = gic.flat
+smp = $MAX_SMP
+accel = kvm
+extra_params = -machine gic-version=3 -append 'its-migrate-unmapped-collection'
+groups = its migration
+arch = arm64
+
 # Test PSCI emulation
 [psci]
 file = psci.flat
diff --git a/errata.txt b/errata.txt
index 7d6abc2a7bf6..b66afaa9c079 100644
--- a/errata.txt
+++ b/errata.txt
@@ -5,4 +5,5 @@
 9e3f7a296940    : 4.9                           : arm64: KVM: pmu: Fix AArch32 cycle counter access
 7b6b46311a85    : 4.11                          : KVM: arm/arm64: Emulate the EL1 phys timer registers
 6c7a5dce22b3    : 4.12                          : KVM: arm/arm64: fix races in kvm_psci_vcpu_on
+8c58be34494b    : 5.6                           : KVM: arm/arm64: vgic-its: Fix restoration of unmapped collections
 #---------------:-------------------------------:---------------------------------------------------
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
