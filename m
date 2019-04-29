Return-Path: <SRS0=Jnhn=S7=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C18FC43219
	for <kvmarm@archiver.kernel.org>; Mon, 29 Apr 2019 19:13:21 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id ADF2520675
	for <kvmarm@archiver.kernel.org>; Mon, 29 Apr 2019 19:13:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ADF2520675
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 15C7A4A476;
	Mon, 29 Apr 2019 15:13:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xt2PkG+85hEX; Mon, 29 Apr 2019 15:13:18 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CEE254A44D;
	Mon, 29 Apr 2019 15:13:18 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BCF534A44D
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Apr 2019 15:13:17 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kiSpRXsDN8ZC for <kvmarm@lists.cs.columbia.edu>;
 Mon, 29 Apr 2019 15:13:16 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 55DAF4A3B2
 for <kvmarm@lists.cs.columbia.edu>; Mon, 29 Apr 2019 15:13:16 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.72.51.249])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 875E6374;
 Mon, 29 Apr 2019 12:13:15 -0700 (PDT)
Received: from e119886-lin.cambridge.arm.com (unknown [10.37.6.20])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1B6073F5C1;
 Mon, 29 Apr 2019 12:13:13 -0700 (PDT)
From: Andrew Murray <andrew.murray@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH] arm64: KVM: fix perf cycle counter support for VHE
Date: Mon, 29 Apr 2019 20:13:05 +0100
Message-Id: <20190429191305.21000-1-andrew.murray@arm.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Cc: Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will.deacon@arm.com>, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
Message-ID: <20190429191305.-cOKwAY41sKX0LgsjH6NrRBQz4Ro6Y1-wyEDjk2yXbY@z>

The kvm_vcpu_pmu_{read,write}_evtype_direct functions do not handle
the cycle counter use-case, this leads to inaccurate counts and a
WARN message when using perf with the cycle counter (-e cycle).

Let's fix this by adding a use case for pmccfiltr_el0.

Reported-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Andrew Murray <andrew.murray@arm.com>
---
 arch/arm64/kvm/pmu.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/kvm/pmu.c b/arch/arm64/kvm/pmu.c
index 4d55193ccc71..e790051ed6ae 100644
--- a/arch/arm64/kvm/pmu.c
+++ b/arch/arm64/kvm/pmu.c
@@ -134,12 +134,15 @@ void __hyp_text __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 	PMEVTYPER_##readwrite##_CASE(30)
 
 /*
- * Read a value direct from PMEVTYPER<idx>
+ * Read a value direct from PMEVTYPER<idx> where idx is 0-30
+ * or PMCCFILTR_EL0 where idx is ARMV8_PMU_CYCLE_IDX (31).
  */
 static u64 kvm_vcpu_pmu_read_evtype_direct(int idx)
 {
 	switch (idx) {
 	PMEVTYPER_CASES(READ);
+	case ARMV8_PMU_CYCLE_IDX:
+		return read_sysreg(pmccfiltr_el0);
 	default:
 		WARN_ON(1);
 	}
@@ -148,12 +151,16 @@ static u64 kvm_vcpu_pmu_read_evtype_direct(int idx)
 }
 
 /*
- * Write a value direct to PMEVTYPER<idx>
+ * Write a value direct to PMEVTYPER<idx> where idx is 0-30
+ * or PMCCFILTR_EL0 where idx is ARMV8_PMU_CYCLE_IDX (31).
  */
 static void kvm_vcpu_pmu_write_evtype_direct(int idx, u32 val)
 {
 	switch (idx) {
 	PMEVTYPER_CASES(WRITE);
+	case ARMV8_PMU_CYCLE_IDX:
+		write_sysreg(val, pmccfiltr_el0);
+		break;
 	default:
 		WARN_ON(1);
 	}
-- 
2.21.0

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
