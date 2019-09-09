Return-Path: <SRS0=3K2b=XE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D888BC4740A
	for <kvmarm@archiver.kernel.org>; Mon,  9 Sep 2019 13:49:28 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 98A3C20828
	for <kvmarm@archiver.kernel.org>; Mon,  9 Sep 2019 13:49:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 98A3C20828
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 50FB84A51E;
	Mon,  9 Sep 2019 09:49:28 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id keCYO77sSmX1; Mon,  9 Sep 2019 09:49:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A6AD4A5E1;
	Mon,  9 Sep 2019 09:49:27 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 658DF4A554
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Sep 2019 09:49:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id rB-gD1IF2gz5 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Sep 2019 09:49:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6F7F74A5E3
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Sep 2019 09:49:24 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 30E621B8E;
 Mon,  9 Sep 2019 06:49:24 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 126283F59C;
 Mon,  9 Sep 2019 06:49:21 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 13/17] KVM: Call kvm_arch_vcpu_blocking early into the
 blocking sequence
Date: Mon,  9 Sep 2019 14:48:03 +0100
Message-Id: <20190909134807.27978-14-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190909134807.27978-1-maz@kernel.org>
References: <20190909134807.27978-1-maz@kernel.org>
MIME-Version: 1.0
Cc: kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>,
 kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
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

When a vpcu is about to block by calling kvm_vcpu_block, we call
back into the arch code to allow any form of synchronization that
may be required at this point (SVN stops the AVIC, ARM synchronises
the VMCR and enables GICv4 doorbells). But this synchronization
comes in quite late, as we've potentially waited for halt_poll_ns
to expire.

Instead, let's move kvm_arch_vcpu_blocking() to the beginning of
kvm_vcpu_block(), which on ARM has several benefits:

- VMCR gets synchronised early, meaning that any interrupt delivered
  during the polling window will be evaluated with the correct guest
  PMR
- GICv4 doorbells are enabled, which means that any guest interrupt
  directly injected during that window will be immediately recognised

Tang Nianyao ran some tests on a GICv4 machine to evaluate such
change, and reported up to a 10% improvement for netperf:

<quote>
	netperf result:
	D06 as server, intel 8180 server as client
	with change:
	package 512 bytes - 5500 Mbits/s
	package 64 bytes - 760 Mbits/s
	without change:
	package 512 bytes - 5000 Mbits/s
	package 64 bytes - 710 Mbits/s
</quote>

Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 virt/kvm/kvm_main.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index c6a91b044d8d..e6de3159e682 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2321,6 +2321,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 	bool waited = false;
 	u64 block_ns;
 
+	kvm_arch_vcpu_blocking(vcpu);
+
 	start = cur = ktime_get();
 	if (vcpu->halt_poll_ns && !kvm_arch_no_poll(vcpu)) {
 		ktime_t stop = ktime_add_ns(ktime_get(), vcpu->halt_poll_ns);
@@ -2341,8 +2343,6 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 		} while (single_task_running() && ktime_before(cur, stop));
 	}
 
-	kvm_arch_vcpu_blocking(vcpu);
-
 	for (;;) {
 		prepare_to_swait_exclusive(&vcpu->wq, &wait, TASK_INTERRUPTIBLE);
 
@@ -2355,9 +2355,8 @@ void kvm_vcpu_block(struct kvm_vcpu *vcpu)
 
 	finish_swait(&vcpu->wq, &wait);
 	cur = ktime_get();
-
-	kvm_arch_vcpu_unblocking(vcpu);
 out:
+	kvm_arch_vcpu_unblocking(vcpu);
 	block_ns = ktime_to_ns(cur) - ktime_to_ns(start);
 
 	if (!vcpu_valid_wakeup(vcpu))
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
