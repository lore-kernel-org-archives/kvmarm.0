Return-Path: <SRS0=ky3n=LC=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_ADSP_ALL,
	DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2FC5C4743D
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 07:29:37 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 64B8261285
	for <kvmarm@archiver.kernel.org>; Tue,  8 Jun 2021 07:29:37 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 64B8261285
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=amazon.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 072EA4A49C;
	Tue,  8 Jun 2021 03:29:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@amazon.de
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rR3djjAFI4GD; Tue,  8 Jun 2021 03:29:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 601B54A4E5;
	Tue,  8 Jun 2021 03:29:34 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EE59E407F4
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 15:00:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xe-iLZQ7Gqhw for <kvmarm@lists.cs.columbia.edu>;
 Mon,  7 Jun 2021 15:00:06 -0400 (EDT)
Received: from smtp-fw-6001.amazon.com (smtp-fw-6001.amazon.com [52.95.48.154])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 94B6240870
 for <kvmarm@lists.cs.columbia.edu>; Mon,  7 Jun 2021 15:00:06 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amazon.de; i=@amazon.de; q=dns/txt; s=amazon201209;
 t=1623092406; x=1654628406;
 h=from:to:cc:subject:date:message-id:in-reply-to:
 references:mime-version:content-transfer-encoding;
 bh=jISdOgQ/JTsW0H3WM9A+q97dEXgXLmFL+7Pu1AAf/5U=;
 b=lUkAi663tLabMowYdJ8iGl1eqznBOtf5ZuZE00zXkGVKVLfPIjEvZHwA
 hYB/64D1ohQYDsalRgtWcRkoZCOtdEA6HlfHTIC4uSOSpKxPpc+C2Abqg
 6ZSLDX79bK2i+fKndnHcI5yD6+TBxnoXlbHVGblU3J/XIU/SVjbER+w7C 0=;
X-IronPort-AV: E=Sophos;i="5.83,255,1616457600"; d="scan'208";a="118583534"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO
 email-inbound-relay-2c-2225282c.us-west-2.amazon.com) ([10.43.8.6])
 by smtp-border-fw-6001.iad6.amazon.com with ESMTP; 07 Jun 2021 18:59:58 +0000
Received: from EX13D19EUA001.ant.amazon.com
 (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
 by email-inbound-relay-2c-2225282c.us-west-2.amazon.com (Postfix) with ESMTPS
 id 69681A1810; Mon,  7 Jun 2021 18:59:57 +0000 (UTC)
Received: from u5213831450fd59.ant.amazon.com (10.43.161.201) by
 EX13D19EUA001.ant.amazon.com (10.43.165.74) with Microsoft SMTP Server (TLS)
 id 15.0.1497.18; Mon, 7 Jun 2021 18:59:52 +0000
From: Jinank Jain <jinankj@amazon.de>
To: <linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.cs.columbia.edu>,
 <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] KVM: arm64: Properly restore PMU state during
 live-migration
Date: Mon, 7 Jun 2021 20:58:59 +0200
Message-ID: <20210607185858.2254-1-jinankj@amazon.de>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210603110554.13643-1-jinankj@amazon.de>
References: <20210603110554.13643-1-jinankj@amazon.de>
MIME-Version: 1.0
X-Originating-IP: [10.43.161.201]
X-ClientProxiedBy: EX13D46UWC003.ant.amazon.com (10.43.162.119) To
 EX13D19EUA001.ant.amazon.com (10.43.165.74)
X-Mailman-Approved-At: Tue, 08 Jun 2021 03:29:32 -0400
Cc: Alexander Graf <graf@amazon.de>, Will Deacon <will@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Jinank Jain <jinankj@amazon.de>
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

Currently if a guest is live-migrated while it is actively using perf
counters, then after live-migrate it will notice that all counters would
suddenly start reporting 0s. This is due to the fact we are not
re-creating the relevant perf events inside the kernel.

Usually on live-migration guest state is restored using KVM_SET_ONE_REG
ioctl interface, which simply restores the value of PMU registers
values but does not re-program the perf events so that the guest can seamlessly
use these counters even after live-migration like it was doing before
live-migration.

Instead there are two completely different code path between guest
accessing PMU registers and VMM restoring counters on
live-migration.

In case of KVM_SET_ONE_REG:

kvm_arm_set_reg()
...... kvm_arm_sys_reg_set_reg()
........... reg_from_user()

but in case when guest tries to access these counters:

handle_exit()
..... kvm_handle_sys_reg()
..........perform_access()
...............access_pmu_evcntr()
...................kvm_pmu_set_counter_value()
.......................kvm_pmu_create_perf_event()

The drawback of using the KVM_SET_ONE_REG interface is that the host pmu
events which were registered for the source instance are not present for
the destination instance. Thus, passively restoring PMCR_EL0 using
KVM_SET_ONE_REG interface would not create the necessary host pmu events
which are crucial for seamless guest experience across live migration.

In ordet to fix the situation, on first vcpu load we should restore
PMCR_EL0 in the same exact way like the guest was trying to access
these counters. And then we will also recreate the relevant host pmu
events.

Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Jinank Jain <jinankj@amazon.de>
Cc: Alexander Graf (AWS) <graf@amazon.de>
Cc: Marc Zyngier <maz@kernel.org>
Cc: James Morse <james.morse@arm.com>
Cc: Alexandru Elisei <alexandru.elisei@arm.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/arm.c              | 4 ++++
 arch/arm64/kvm/pmu-emul.c         | 3 +++
 3 files changed, 8 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 7cd7d5c8c4bc..6336b4309114 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -46,6 +46,7 @@
 #define KVM_REQ_VCPU_RESET	KVM_ARCH_REQ(2)
 #define KVM_REQ_RECORD_STEAL	KVM_ARCH_REQ(3)
 #define KVM_REQ_RELOAD_GICv4	KVM_ARCH_REQ(4)
+#define KVM_REQ_RELOAD_PMU	KVM_ARCH_REQ(5)
 
 #define KVM_DIRTY_LOG_MANUAL_CAPS   (KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE | \
 				     KVM_DIRTY_LOG_INITIALLY_SET)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e720148232a0..facf4d41d32a 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -689,6 +689,10 @@ static void check_vcpu_requests(struct kvm_vcpu *vcpu)
 			vgic_v4_load(vcpu);
 			preempt_enable();
 		}
+
+		if (kvm_check_request(KVM_REQ_RELOAD_PMU, vcpu))
+			kvm_pmu_handle_pmcr(vcpu,
+					    __vcpu_sys_reg(vcpu, PMCR_EL0));
 	}
 }
 
diff --git a/arch/arm64/kvm/pmu-emul.c b/arch/arm64/kvm/pmu-emul.c
index fd167d4f4215..a0bbb7111f57 100644
--- a/arch/arm64/kvm/pmu-emul.c
+++ b/arch/arm64/kvm/pmu-emul.c
@@ -850,6 +850,9 @@ int kvm_arm_pmu_v3_enable(struct kvm_vcpu *vcpu)
 		   return -EINVAL;
 	}
 
+	/* One-off reload of the PMU on first run */
+	kvm_make_request(KVM_REQ_RELOAD_PMU, vcpu);
+
 	return 0;
 }
 
-- 
2.31.1




Amazon Development Center Germany GmbH
Krausenstr. 38
10117 Berlin
Geschaeftsfuehrung: Christian Schlaeger, Jonathan Weiss
Eingetragen am Amtsgericht Charlottenburg unter HRB 149173 B
Sitz: Berlin
Ust-ID: DE 289 237 879



_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
