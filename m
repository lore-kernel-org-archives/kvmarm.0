Return-Path: <SRS0=sayA=JR=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3ABBC43462
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 13:34:11 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 770AC6113C
	for <kvmarm@archiver.kernel.org>; Tue, 20 Apr 2021 13:34:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 770AC6113C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 150F14B3D5;
	Tue, 20 Apr 2021 09:34:11 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 5unMtx1GSTMy; Tue, 20 Apr 2021 09:34:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A0124B3D6;
	Tue, 20 Apr 2021 09:34:07 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8FE094B360
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 09:08:53 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id szwfPpas0nVB for <kvmarm@lists.cs.columbia.edu>;
 Tue, 20 Apr 2021 09:08:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 528BD4B382
 for <kvmarm@lists.cs.columbia.edu>; Tue, 20 Apr 2021 09:08:49 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E3C221478;
 Tue, 20 Apr 2021 06:08:48 -0700 (PDT)
Received: from yoan-MS-7758.Home (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8A57F3F792;
 Tue, 20 Apr 2021 06:08:47 -0700 (PDT)
From: Yoan Picchi <yoan.picchi@arm.com>
To: maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH v2 3/3] KVM: arm64: Add irq_exit counter for kvm_stat
Date: Tue, 20 Apr 2021 14:08:25 +0100
Message-Id: <20210420130825.15585-4-yoan.picchi@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210420130825.15585-1-yoan.picchi@arm.com>
References: <20210420130825.15585-1-yoan.picchi@arm.com>
X-Mailman-Approved-At: Tue, 20 Apr 2021 09:34:06 -0400
Cc: catalin.marinas@arm.com, Yoan Picchi <yoan.picchi@arm.com>, will@kernel.org
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

This counter is meant to detect when the guest vm exits due to an
interrupt. Those interrupts might be unrelated to the guest VM (say, some
network packet arrived, and such) but they still trigger an exit which is
recorded by the "exit" counter. The main purpose of this counter is to
give some more granularity to this base exit counter so that one can have
a rough idea of where those exits comes from and so, if those general
exits happen because of the host or of the guest.

Signed-off-by: Yoan Picchi <yoan.picchi@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 1 +
 arch/arm64/kvm/guest.c            | 1 +
 arch/arm64/kvm/handle_exit.c      | 1 +
 3 files changed, 3 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 8f9d27571..185e707fb 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -565,6 +565,7 @@ struct kvm_vcpu_stat {
 	u64 mmio_exit_kernel;
 	u64 stage2_abort_exit;
 	u64 exits;
+	u64 irq_exits;
 };
 
 int kvm_vcpu_preferred_target(struct kvm_vcpu_init *init);
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 41316b30e..eb4c24b7a 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -42,6 +42,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("exits", exits),
 	VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
 	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
+	VCPU_STAT("irq_exits", irq_exits),
 	VM_STAT("regular_page_mapped", regular_page_mapped),
 	VM_STAT("huge_page_mapped", huge_page_mapped),
 	{ NULL }
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index cebe39f3b..7e5dbc5ff 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -244,6 +244,7 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 
 	switch (exception_index) {
 	case ARM_EXCEPTION_IRQ:
+		vcpu->stat.irq_exits++;
 		return 1;
 	case ARM_EXCEPTION_EL1_SERROR:
 		return 1;
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
