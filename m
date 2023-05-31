Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 417783C0A6
	for <kvmarm@lists.linux.dev>; Wed, 31 May 2023 20:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685564096;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X1+M7T6Odh2i5zf9nHT26H5Q4uJWOu5S7+RgtQe0rFw=;
	b=ViJjWtZafaOYOaSZgamasKr+56Z9/A+bG7fHFE+DhpGUW7gSFrdTq4VzoodABaOxmXJWLY
	eDTuhj1rAOb90PamUkYQipJz4r4dGHK0edi7sh+FR+KQ6I9BOrcUlXagjiLRMk+H6yLP0P
	0jxeVKPUOnNBYxlR89YcewX0k6Ut/mM=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-544-F48u5WuFMAGitiHcgKRB_Q-1; Wed, 31 May 2023 16:14:54 -0400
X-MC-Unique: F48u5WuFMAGitiHcgKRB_Q-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 22C3F1C03DB6;
	Wed, 31 May 2023 20:14:53 +0000 (UTC)
Received: from laptop.redhat.com (unknown [10.39.193.41])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 08C98407DEC0;
	Wed, 31 May 2023 20:14:50 +0000 (UTC)
From: Eric Auger <eric.auger@redhat.com>
To: eric.auger.pro@gmail.com,
	eric.auger@redhat.com,
	kvm@vger.kernel.org,
	kvmarm@lists.linux.dev,
	andrew.jones@linux.dev,
	maz@kernel.org,
	will@kernel.org,
	oliver.upton@linux.dev,
	ricarkol@google.com,
	reijiw@google.com,
	alexandru.elisei@arm.com
Cc: mark.rutland@arm.com
Subject: [kvm-unit-tests PATCH v2 4/6] arm: pmu: Fix chain counter enable/disable sequences
Date: Wed, 31 May 2023 22:14:36 +0200
Message-Id: <20230531201438.3881600-5-eric.auger@redhat.com>
In-Reply-To: <20230531201438.3881600-1-eric.auger@redhat.com>
References: <20230531201438.3881600-1-eric.auger@redhat.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1

In some ARM ARM ddi0487 revisions it is said that
disabling/enabling a pair of counters that are paired
by a CHAIN event should follow a given sequence:

Enable the high counter first, isb, enable low counter
Disable the low counter first, isb, disable the high counter

This was the case in Fc. However this is not written anymore
in subsequent revions such as Ia.

Anyway, just in case, and because it also makes the code a
little bit simpler, introduce 2 helpers to enable/disable chain
counters that execute those sequences and replace the existing
PMCNTENCLR/ENSET calls (at least this cannot do any harm).

Also fix 2 write_sysreg_s(0x0, PMCNTENSET_EL0) in subtest 5 & 6
and replace them by PMCNTENCLR writes since writing 0 in
PMCNTENSET_EL0 has no effect.

Signed-off-by: Eric Auger <eric.auger@redhat.com>

---

v1 -> v2:
- fix the enable_chain_counter()/disable_chain_counter()
  sequence, ie. swap n + 1 / n as reported by Alexandru.
- fix an other comment using the 'low' terminology
---
 arm/pmu.c | 37 ++++++++++++++++++++++++++++---------
 1 file changed, 28 insertions(+), 9 deletions(-)

diff --git a/arm/pmu.c b/arm/pmu.c
index 74dd4c10..74c9f6f9 100644
--- a/arm/pmu.c
+++ b/arm/pmu.c
@@ -731,6 +731,22 @@ static void test_chained_sw_incr(bool unused)
 		    read_regn_el0(pmevcntr, 0), \
 		    read_sysreg(pmovsclr_el0))
 
+static void enable_chain_counter(int even)
+{
+	write_sysreg_s(BIT(even + 1), PMCNTENSET_EL0); /* Enable the high counter first */
+	isb();
+	write_sysreg_s(BIT(even), PMCNTENSET_EL0); /* Enable the low counter */
+	isb();
+}
+
+static void disable_chain_counter(int even)
+{
+	write_sysreg_s(BIT(even), PMCNTENCLR_EL0); /* Disable the low counter first*/
+	isb();
+	write_sysreg_s(BIT(even + 1), PMCNTENCLR_EL0); /* Disable the high counter */
+	isb();
+}
+
 static void test_chain_promotion(bool unused)
 {
 	uint32_t events[] = {MEM_ACCESS, CHAIN};
@@ -769,16 +785,17 @@ static void test_chain_promotion(bool unused)
 	/* 1st COUNT with CHAIN enabled, next COUNT with CHAIN disabled */
 	report_prefix_push("subtest3");
 	pmu_reset();
-	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
-	isb();
+	enable_chain_counter(0);
 	PRINT_REGS("init");
 
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 1st loop");
 
 	/* disable the CHAIN event */
-	write_sysreg_s(0x2, PMCNTENCLR_EL0);
+	disable_chain_counter(0);
+	write_sysreg_s(0x1, PMCNTENSET_EL0); /* Enable the low counter */
+	isb();
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 2nd loop");
 	report(read_sysreg(pmovsclr_el0) == 0x1,
@@ -799,9 +816,11 @@ static void test_chain_promotion(bool unused)
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 1st loop");
 
-	/* enable the CHAIN event */
-	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	/* Disable the low counter first and enable the chain counter */
+	write_sysreg_s(0x1, PMCNTENCLR_EL0);
 	isb();
+	enable_chain_counter(0);
+
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 
 	PRINT_REGS("After 2nd loop");
@@ -825,10 +844,10 @@ static void test_chain_promotion(bool unused)
 	PRINT_REGS("After 1st loop");
 
 	/* 0 becomes CHAINED */
-	write_sysreg_s(0x0, PMCNTENSET_EL0);
+	write_sysreg_s(0x3, PMCNTENCLR_EL0);
 	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
-	write_sysreg_s(0x3, PMCNTENSET_EL0);
 	write_regn_el0(pmevcntr, 1, 0x0);
+	enable_chain_counter(0);
 
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 2nd loop");
@@ -844,13 +863,13 @@ static void test_chain_promotion(bool unused)
 	write_regn_el0(pmevtyper, 0, MEM_ACCESS | PMEVTYPER_EXCLUDE_EL0);
 	write_regn_el0(pmevtyper, 1, CHAIN | PMEVTYPER_EXCLUDE_EL0);
 	write_regn_el0(pmevcntr, 0, PRE_OVERFLOW2_32);
-	write_sysreg_s(0x3, PMCNTENSET_EL0);
+	enable_chain_counter(0);
 	PRINT_REGS("init");
 
 	mem_access_loop(addr, COUNT, pmu.pmcr_ro | PMU_PMCR_E);
 	PRINT_REGS("After 1st loop");
 
-	write_sysreg_s(0x0, PMCNTENSET_EL0);
+	disable_chain_counter(0);
 	write_regn_el0(pmevtyper, 1, CPU_CYCLES | PMEVTYPER_EXCLUDE_EL0);
 	write_sysreg_s(0x3, PMCNTENSET_EL0);
 
-- 
2.38.1

