Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B796522EE2
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 17:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e6Q/7Kfr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1699897418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rFxvHnd11qAThubLbHtzlm28zwDTg4C1GGUVCeRK1zw=;
	b=e6Q/7Kfr7g7NuXn/dVhfqG0+PeAzrXMjiIVINuXftqOExZyGi6e3jmoe7qhBdMKNMqoK4p
	CcbbY7Idbb3k2M6/IbgCIRPuvAWoODGXgUzkodgtILGwzsSvZNO75m3ujQfHYSh0UwYsOV
	Hl9PujOUXy4Czs++JcJzVUYKee64gd4=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-83-GpgElajJMDeBw_4coXVJqw-1; Mon,
 13 Nov 2023 12:43:31 -0500
X-MC-Unique: GpgElajJMDeBw_4coXVJqw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0C1A438143A3;
	Mon, 13 Nov 2023 17:43:31 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.115])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 65BCE1121306;
	Mon, 13 Nov 2023 17:43:29 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev,
	maz@kernel.org,
	oliver.upton@linux.dev,
	alexandru.elisei@arm.com
Cc: jarichte@redhat.com
Subject: [kvm-unit-tests PATCH v2 2/2] arm: pmu-overflow-interrupt: Increase count values
Date: Mon, 13 Nov 2023 18:42:41 +0100
Message-ID: <20231113174316.341630-3-eric.auger@redhat.com>
In-Reply-To: <20231113174316.341630-1-eric.auger@redhat.com>
References: <20231113174316.341630-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.3

On some hardware, some pmu-overflow-interrupt failures can be observed.
Although the even counter overflows, the interrupt is not seen as
expected. This happens in the subtest after "promote to 64-b" comment.
After analysis, the PMU overflow interrupt actually hits, ie.
kvm_pmu_perf_overflow() gets called and KVM_REQ_IRQ_PENDING is set,
as expected. However the PMCR.E is reset by the handle_exit path, at
kvm_pmu_handle_pmcr() before the next guest entry and
kvm_pmu_flush_hwstate/kvm_pmu_update_state subsequent call.
There, since the enable bit has been reset, kvm_pmu_update_state() does
not inject the interrupt into the guest.

This does not seem to be a KVM bug but rather an unfortunate
scenario where the test disables the PMCR.E too closely to the
advent of the overflow interrupt.

Since it looks like a benign and inlikely case, let's resize the number
of iterations to prevent the PMCR enable bit from being resetted
immediately at the same time as the actual overflow event.

COUNT_INT is introduced, arbitrarily set to 1000 iterations and is
used in this test.

An alternative would be to let the PMU enabled and wait for the
interrupt but those extra executions might disturb the counting.

Reported-by: Jan Richter <jarichte@redhat.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- Only increase mem_access_loop iterations
---
 arm/pmu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 86199577..4b388899 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -66,6 +66,7 @@
 #define PRE_OVERFLOW_64		0xFFFFFFFFFFFFFFF0ULL
 #define COUNT 250
 #define MARGIN 100
+#define COUNT_INT 1000
 /*
  * PRE_OVERFLOW2 is set so that 1st @COUNT iterations do not
  * produce 32b overflow and 2nd @COUNT iterations do. To accommodate
@@ -978,7 +979,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 
 	/* interrupts are disabled (PMINTENSET_EL1 == 0) */
 
-	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
+	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	report(expect_interrupts(0), "no overflow interrupt after preset");
 
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
@@ -1002,7 +1003,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 	write_sysreg(ALL_SET_32, pmintenset_el1);
 	isb();
 
-	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
+	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 
 	set_pmcr(pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	isb();
@@ -1010,7 +1011,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 	for (i = 0; i < 100; i++)
 		write_sysreg(0x3, pmswinc_el0);
 
-	mem_access_loop(addr, 200, pmu.pmcr_ro);
+	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro);
 	report_info("overflow=0x%lx", read_sysreg(pmovsclr_el0));
 	report(expect_interrupts(0x3),
 		"overflow interrupts expected on #0 and #1");
@@ -1029,7 +1030,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
 	write_regn_el0(pmevcntr, 0, pre_overflow);
 	isb();
-	mem_access_loop(addr, 200, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
+	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	report(expect_interrupts(0x1), "expect overflow interrupt");
 
 	/* overflow on odd counter */
@@ -1037,7 +1038,7 @@ static void test_overflow_interrupt(bool overflow_at_64bits)
 	write_regn_el0(pmevcntr, 0, pre_overflow);
 	write_regn_el0(pmevcntr, 1, all_set);
 	isb();
-	mem_access_loop(addr, 400, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
+	mem_access_loop(addr, COUNT_INT, pmu.pmcr_ro | PMU_PMCR_E | pmcr_lp);
 	if (overflow_at_64bits) {
 		report(expect_interrupts(0x1),
 		       "expect overflow interrupt on even counter");
-- 
2.41.0

