Return-Path: <SRS0=dc8k=5U=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC37BC2BA15
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:38:03 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 8326F206F5
	for <kvmarm@archiver.kernel.org>; Sat,  4 Apr 2020 14:38:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eoYQG5LR"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8326F206F5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D65134B1E2;
	Sat,  4 Apr 2020 10:38:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@redhat.com
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id aEMkBMhxlXAQ; Sat,  4 Apr 2020 10:38:01 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id CD5CB4B1F7;
	Sat,  4 Apr 2020 10:37:58 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 24B6C4B188
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:37:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ZTFj-OsdD+bY for <kvmarm@lists.cs.columbia.edu>;
 Sat,  4 Apr 2020 10:37:56 -0400 (EDT)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 15C1E4B18D
 for <kvmarm@lists.cs.columbia.edu>; Sat,  4 Apr 2020 10:37:56 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
 s=mimecast20190719; t=1586011075;
 h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
 to:to:cc:cc:mime-version:mime-version:
 content-transfer-encoding:content-transfer-encoding:
 in-reply-to:in-reply-to:references:references;
 bh=f5/6iYn1/X1EBmc0Lpb8aoWuiKLfFR+TAtLkxR7iQvU=;
 b=eoYQG5LRySaQw/KW87nbw6aAd2nOlhzQ0m0n5ip34tzQ818FPoxS258YSUttHJ/lxicUdB
 KFXZQEHYXeRFaG5CLrn/hhrs4wV6LzBGZX5hclnhjFWUPMjrSAFSgz8UiTZZy9h1KDpQY+
 wZJLWEPqZQkeM5hwBI02Ez9H4u4LbmU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-X8W0NQ34MnSb3nantdKhTg-1; Sat, 04 Apr 2020 10:37:53 -0400
X-MC-Unique: X8W0NQ34MnSb3nantdKhTg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com
 [10.5.11.11])
 (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0FC01140B;
 Sat,  4 Apr 2020 14:37:44 +0000 (UTC)
Received: from kamzik.brq.redhat.com (unknown [10.40.192.30])
 by smtp.corp.redhat.com (Postfix) with ESMTP id F1CF29B912;
 Sat,  4 Apr 2020 14:37:41 +0000 (UTC)
From: Andrew Jones <drjones@redhat.com>
To: pbonzini@redhat.com
Subject: [PULL kvm-unit-tests 02/39] arm/arm64: psci: Don't run C code without
 stack or vectors
Date: Sat,  4 Apr 2020 16:36:54 +0200
Message-Id: <20200404143731.208138-3-drjones@redhat.com>
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

From: Alexandru Elisei <alexandru.elisei@arm.com>

The psci test performs a series of CPU_ON/CPU_OFF cycles for CPU 1. This is
done by setting the entry point for the CPU_ON call to the physical address
of the C function cpu_psci_cpu_die.

The compiler is well within its rights to use the stack when generating
code for cpu_psci_cpu_die.  However, because no stack initialization has
been done, the stack pointer is zero, as set by KVM when creating the VCPU.
This causes a data abort without a change in exception level. The VBAR_EL1
register is also zero (the KVM reset value for VBAR_EL1), the MMU is off,
and we end up trying to fetch instructions from address 0x200.

At this point, a stage 2 instruction abort is generated which is taken to
KVM. KVM interprets this as an instruction fetch from an I/O region, and
injects a prefetch abort into the guest. Prefetch abort is a synchronous
exception, and on guest return the VCPU PC will be set to VBAR_EL1 + 0x200,
which is...  0x200. The VCPU ends up in an infinite loop causing a prefetch
abort while fetching the instruction to service the said abort.

To avoid all of this, lets use the assembly function halt as the CPU_ON
entry address. Also, expand the check to test that we only get
PSCI_RET_SUCCESS exactly once, as we're never offlining the CPU during the
test.

Signed-off-by: Alexandru Elisei <alexandru.elisei@arm.com>
Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 arm/psci.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/arm/psci.c b/arm/psci.c
index 5c1accb6cea4..ffc09a2e9858 100644
--- a/arm/psci.c
+++ b/arm/psci.c
@@ -79,13 +79,14 @@ static void cpu_on_secondary_entry(void)
 	cpumask_set_cpu(cpu, &cpu_on_ready);
 	while (!cpu_on_start)
 		cpu_relax();
-	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(cpu_psci_cpu_die));
+	cpu_on_ret[cpu] = psci_cpu_on(cpus[1], __pa(halt));
 	cpumask_set_cpu(cpu, &cpu_on_done);
 }
 
 static bool psci_cpu_on_test(void)
 {
 	bool failed = false;
+	int ret_success = 0;
 	int cpu;
 
 	cpumask_set_cpu(1, &cpu_on_ready);
@@ -104,7 +105,7 @@ static bool psci_cpu_on_test(void)
 	cpu_on_start = 1;
 	smp_mb();
 
-	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(cpu_psci_cpu_die));
+	cpu_on_ret[0] = psci_cpu_on(cpus[1], __pa(halt));
 	cpumask_set_cpu(0, &cpu_on_done);
 
 	while (!cpumask_full(&cpu_on_done))
@@ -113,12 +114,19 @@ static bool psci_cpu_on_test(void)
 	for_each_present_cpu(cpu) {
 		if (cpu == 1)
 			continue;
-		if (cpu_on_ret[cpu] != PSCI_RET_SUCCESS && cpu_on_ret[cpu] != PSCI_RET_ALREADY_ON) {
+		if (cpu_on_ret[cpu] == PSCI_RET_SUCCESS) {
+			ret_success++;
+		} else if (cpu_on_ret[cpu] != PSCI_RET_ALREADY_ON) {
 			report_info("unexpected cpu_on return value: caller=CPU%d, ret=%d", cpu, cpu_on_ret[cpu]);
 			failed = true;
 		}
 	}
 
+	if (ret_success != 1) {
+		report_info("got %d CPU_ON success", ret_success);
+		failed = true;
+	}
+
 	return !failed;
 }
 
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
