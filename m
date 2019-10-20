Return-Path: <SRS0=jJ2v=YN=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B171ECA9EA0
	for <kvmarm@archiver.kernel.org>; Sun, 20 Oct 2019 10:11:50 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 6C0262190F
	for <kvmarm@archiver.kernel.org>; Sun, 20 Oct 2019 10:11:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="mRCCWvsk"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6C0262190F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 277684AC1D;
	Sun, 20 Oct 2019 06:11:50 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id H4pCgmhgfPO2; Sun, 20 Oct 2019 06:11:49 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E0FD4AC1F;
	Sun, 20 Oct 2019 06:11:49 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 37BB54AC0E
 for <kvmarm@lists.cs.columbia.edu>; Sun, 20 Oct 2019 06:11:48 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id tZRWTzJeb4nO for <kvmarm@lists.cs.columbia.edu>;
 Sun, 20 Oct 2019 06:11:47 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3688F4A9B1
 for <kvmarm@lists.cs.columbia.edu>; Sun, 20 Oct 2019 06:11:47 -0400 (EDT)
Received: from big-swifty.lan (78.163-31-62.static.virginmediabusiness.co.uk
 [62.31.163.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 3B37D2190F;
 Sun, 20 Oct 2019 10:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=default; t=1571566306;
 bh=om3Cj3Gh8W38m+op9WkaTNAgw+rHdyTrhOQkkaQCz40=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=mRCCWvskMmuSgZrasQVj9s6NTQm49gUlfviEBCz4nKzWyEJ9yPX/sPN13N05vxt12
 3QKIlNPSs0zoMYczKpfjNsS43TeVOlvm13dCuIcXCz1URXTcGVQTc3lZYW59N2L4Eo
 //Y/+847gu1WQSofWjKIGbKX4UnT5AAKXiVhmeC4=
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 4/4] KVM: arm64: pmu: Reset sample period on overflow handling
Date: Sun, 20 Oct 2019 11:11:29 +0100
Message-Id: <20191020101129.2612-5-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191020101129.2612-1-maz@kernel.org>
References: <20191020101129.2612-1-maz@kernel.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu,
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
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

The PMU emulation code uses the perf event sample period to trigger
the overflow detection. This works fine  for the *first* overflow
handling, but results in a huge number of interrupts on the host,
unrelated to the number of interrupts handled in the guest (a x20
factor is pretty common for the cycle counter). On a slow system
(such as a SW model), this can result in the guest only making
forward progress at a glacial pace.

It turns out that the clue is in the name. The sample period is
exactly that: a period. And once the an overflow has occured,
the following period should be the full width of the associated
counter, instead of whatever the guest had initially programed.

Reset the sample period to the architected value in the overflow
handler, which now results in a number of host interrupts that is
much closer to the number of interrupts in the guest.

Fixes: b02386eb7dac ("arm64: KVM: Add PMU overflow interrupt routing")
Reviewed-by: Andrew Murray <andrew.murray@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/arm/pmu.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/virt/kvm/arm/pmu.c b/virt/kvm/arm/pmu.c
index f291d4ac3519..8731dfeced8b 100644
--- a/virt/kvm/arm/pmu.c
+++ b/virt/kvm/arm/pmu.c
@@ -8,6 +8,7 @@
 #include <linux/kvm.h>
 #include <linux/kvm_host.h>
 #include <linux/perf_event.h>
+#include <linux/perf/arm_pmu.h>
 #include <linux/uaccess.h>
 #include <asm/kvm_emulate.h>
 #include <kvm/arm_pmu.h>
@@ -442,8 +443,25 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
 				  struct pt_regs *regs)
 {
 	struct kvm_pmc *pmc = perf_event->overflow_handler_context;
+	struct arm_pmu *cpu_pmu = to_arm_pmu(perf_event->pmu);
 	struct kvm_vcpu *vcpu = kvm_pmc_to_vcpu(pmc);
 	int idx = pmc->idx;
+	u64 period;
+
+	cpu_pmu->pmu.stop(perf_event, PERF_EF_UPDATE);
+
+	/*
+	 * Reset the sample period to the architectural limit,
+	 * i.e. the point where the counter overflows.
+	 */
+	period = -(local64_read(&perf_event->count));
+
+	if (!kvm_pmu_idx_is_64bit(vcpu, pmc->idx))
+		period &= GENMASK(31, 0);
+
+	local64_set(&perf_event->hw.period_left, 0);
+	perf_event->attr.sample_period = period;
+	perf_event->hw.sample_period = period;
 
 	__vcpu_sys_reg(vcpu, PMOVSSET_EL0) |= BIT(idx);
 
@@ -451,6 +469,8 @@ static void kvm_pmu_perf_overflow(struct perf_event *perf_event,
 		kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
 		kvm_vcpu_kick(vcpu);
 	}
+
+	cpu_pmu->pmu.start(perf_event, PERF_EF_RELOAD);
 }
 
 /**
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
