Return-Path: <SRS0=Zs50=IS=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89316C433C1
	for <kvmarm@archiver.kernel.org>; Sat, 20 Mar 2021 13:28:58 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 29B656196D
	for <kvmarm@archiver.kernel.org>; Sat, 20 Mar 2021 13:28:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 29B656196D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=arm.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 155464B2C2;
	Sat, 20 Mar 2021 09:28:57 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id cpPc9yoDeGSW; Sat, 20 Mar 2021 09:28:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 76F164B2D6;
	Sat, 20 Mar 2021 09:28:54 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17DE34B2B5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 12:18:03 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rOIuMJRXi1Ta for <kvmarm@lists.cs.columbia.edu>;
 Fri, 19 Mar 2021 12:18:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B333F4B65D
 for <kvmarm@lists.cs.columbia.edu>; Fri, 19 Mar 2021 12:18:01 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 21C411063;
 Fri, 19 Mar 2021 09:18:01 -0700 (PDT)
Received: from yoan-MS-7758.Home (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id BC9253F718;
 Fri, 19 Mar 2021 09:17:59 -0700 (PDT)
From: Yoan Picchi <yoan.picchi@arm.com>
To: maz@kernel.org, james.morse@arm.com, julien.thierry.kdev@gmail.com,
 suzuki.poulose@arm.com, linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu
Subject: [PATCH 2/7] KVM: arm64: Add remote_tlb_flush counter for kvm_stat
Date: Fri, 19 Mar 2021 16:17:06 +0000
Message-Id: <20210319161711.24972-3-yoan.picchi@arm.com>
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

Add a counter for remote tlb flushes.
I think flushing the tlb is important enough of a thing so that one using
kvm_stat should be aware if their code is trigering several flushes.
Beside the event is recorded in x86 and ppc as well so there might be
even more reasons that I can't think of.
Looking at where this is called, it mostly happen when someone is
updating the dirty pages while we are doing some operation on them
(like enabling dirty pages logging)

There's one catch though, it is not always thread safe. Sometime it is
called under some lock, some other time it isn't.
We can't change the counter to an atomic_t as all the counters are
unsigned. We shouldn't add a lock as this could be adding a lock
(say, to kvm->arch) for a very minor thing and I would rather not pollute
anything without a better reason. That's why I ended up using cmpxchg
which according to LWN (https://lwn.net/Articles/695257/) is an old way
to do without atomic. It's less efficient than an atomic increment, but
this should happen very rarely anyway and is stil better than a lock.

Signed-off-by: Yoan Picchi <yoan.picchi@arm.com>
---
 arch/arm64/kvm/guest.c |  1 +
 arch/arm64/kvm/mmu.c   | 11 +++++++++++
 2 files changed, 12 insertions(+)

diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 14b15fb8f..1029976ca 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -40,6 +40,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] = {
 	VCPU_STAT("mmio_exit_kernel", mmio_exit_kernel),
 	VCPU_STAT("regular_page_mapped", regular_page_mapped),
 	VCPU_STAT("huge_page_mapped", huge_page_mapped),
+	VM_STAT("remote_tlb_flush", remote_tlb_flush),
 	VCPU_STAT("exits", exits),
 	VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
 	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 3996b28da..55d7fe63b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -80,6 +80,17 @@ static bool memslot_is_logging(struct kvm_memory_slot *memslot)
  */
 void kvm_flush_remote_tlbs(struct kvm *kvm)
 {
+	ulong old, new;
+	/*
+	 * This is not always called in thread safe code so we need an atomic add
+	 * or a lock. The two would pollute otherwise clean code for just a counter
+	 * so we use an older atomic primitive that work on the counter data type.
+	 */
+	do {
+        old = kvm->stat.remote_tlb_flush;
+        new = old + 1;
+    } while (cmpxchg(&(kvm->stat.remote_tlb_flush), old, new) != old);
+
 	kvm_call_hyp(__kvm_tlb_flush_vmid, &kvm->arch.mmu);
 }
 
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
