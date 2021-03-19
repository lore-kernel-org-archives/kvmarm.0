Return-Path: <SRS0=Zs50=IS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F873C433E3
	for <kvmarm@archiver.kernel.org>; Sat, 20 Mar 2021 13:29:02 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CB5E56196D
	for <kvmarm@archiver.kernel.org>; Sat, 20 Mar 2021 13:29:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CB5E56196D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C59DB4B4C0;
	Sat, 20 Mar 2021 09:28:59 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PPtjpXvDRKw6; Sat, 20 Mar 2021 09:28:58 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id DC01D4B383;
	Sat, 20 Mar 2021 09:28:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9900E4B66E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 12:18:10 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yLj+OU7Kl5f7 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 12:18:09 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6B2554B664
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 12:18:09 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 23191101E;
 Fri, 19 Mar 2021 09:18:09 -0700 (PDT)
Received: from yoan-MS-7758.Home (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id C95FA3F718;
 Fri, 19 Mar 2021 09:18:07 -0700 (PDT)
From: Yoan Picchi <yoan.picchi@arm.com>
To: maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH 7/7] KVM: arm64: Add irq_inject counter for kvm_stat
Date: Fri, 19 Mar 2021 16:17:11 +0000
Message-Id: <20210319161711.24972-8-yoan.picchi@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210319161711.24972-1-yoan.picchi@arm.com>
References: <20210319161711.24972-1-yoan.picchi@arm.com>
X-Mailman-Approved-At: Sat, 20 Mar 2021 09:28:53 -0400
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

Add a counter for interrupt injections. That is when kvm relay an
interrupt to the guest (for instance a timer, or a device interrupt
like from a network card)

Signed-off-by: Yoan Picchi <yoan.picchi@arm.com>
---
 arch/arm64/include/asm/kvm_host.h | 2 ++
 arch/arm64/kvm/arm.c              | 2 ++
 arch/arm64/kvm/guest.c            | 2 ++
 arch/arm64/kvm/vgic/vgic.c        | 2 ++
 4 files changed, 8 insertions(+)

diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index fa59b669c..253acb8c2 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -551,6 +551,7 @@ struct kvm_vm_stat {
 	ulong memory_slot_unmaped;
 	ulong stage2_unmap_vm;
 	ulong cached_page_invalidated;
+	ulong irq_inject;
 };
 
 struct kvm_vcpu_stat {
@@ -567,6 +568,7 @@ struct kvm_vcpu_stat {
 	u64 mmio_exit_kernel;
 	u64 regular_page_mapped;
 	u64 huge_page_mapped;
+	u64 irq_inject;
 	u64 exits;
 };
 
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index fc4c95dd2..841551f14 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -895,6 +895,8 @@ static int vcpu_interrupt_line(struct kvm_vcpu *vcpu, int number, bool level)
 	bool set;
 	unsigned long *hcr;
 
+	vcpu->stat.irq_inject++;
+
 	if (number == KVM_ARM_IRQ_CPU_IRQ)
 		bit_index = __ffs(HCR_VI);
 	else /* KVM_ARM_IRQ_CPU_FIQ */
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 129c0d53d..f663b03ae 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -45,6 +45,8 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VM_STAT("memory_slot_unmaped", memory_slot_unmaped),
 	VM_STAT("stage2_unmap_vm", stage2_unmap_vm),
 	VM_STAT("cached_page_invalidated", cached_page_invalidated),
+	VM_STAT("irq_inject", irq_inject),
+	VCPU_STAT("irq_inject", irq_inject),
 	VCPU_STAT("exits", exits),
 	VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
 	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
diff --git a/arch/arm64/kvm/vgic/vgic.c b/arch/arm64/kvm/vgic/vgic.c
index 1c597c988..9e504243b 100644
--- a/arch/arm64/kvm/vgic/vgic.c
+++ b/arch/arm64/kvm/vgic/vgic.c
@@ -458,6 +458,8 @@ int kvm_vgic_inject_irq(struct kvm *kvm, int cpuid, unsigned int intid,
 
 	raw_spin_lock_irqsave(&irq->irq_lock, flags);
 
+	kvm->stat.irq_inject++;
+
 	if (!vgic_validate_injection(irq, level, owner)) {
 		/* Nothing to see here, move along... */
 		raw_spin_unlock_irqrestore(&irq->irq_lock, flags);
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
