Return-Path: <SRS0=3K2b=XE=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5843C49ED6
	for <kvmarm@archiver.kernel.org>; Mon,  9 Sep 2019 13:49:23 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id 5D6022196E
	for <kvmarm@archiver.kernel.org>; Mon,  9 Sep 2019 13:49:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5D6022196E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 117B54A5CD;
	Mon,  9 Sep 2019 09:49:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PwP6Ji7q1gAl; Mon,  9 Sep 2019 09:49:21 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id EBC474A5DB;
	Mon,  9 Sep 2019 09:49:21 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D9A504A5D0
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Sep 2019 09:49:20 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id K8R0RDjbbnp1 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  9 Sep 2019 09:49:19 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28FD84A5FA
 for <kvmarm@lists.cs.columbia.edu>; Mon,  9 Sep 2019 09:49:19 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id F126319F6;
 Mon,  9 Sep 2019 06:49:18 -0700 (PDT)
Received: from localhost.localdomain (unknown [172.31.20.19])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C2A6F3F59C;
 Mon,  9 Sep 2019 06:49:16 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: Paolo Bonzini <pbonzini@redhat.com>,
 =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Subject: [PATCH 11/17] arm64/kvm: Remove VMID rollover I-cache maintenance
Date: Mon,  9 Sep 2019 14:48:01 +0100
Message-Id: <20190909134807.27978-12-maz@kernel.org>
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

From: Mark Rutland <mark.rutland@arm.com>

For VPIPT I-caches, we need I-cache maintenance on VMID rollover to
avoid an ABA problem. Consider a single vCPU VM, with a pinned stage-2,
running with an idmap VA->IPA and idmap IPA->PA. If we don't do
maintenance on rollover:

        // VMID A
        Writes insn X to PA 0xF
        Invalidates PA 0xF (for VMID A)

        I$ contains [{A,F}->X]

        [VMID ROLLOVER]

        // VMID B
        Writes insn Y to PA 0xF
        Invalidates PA 0xF (for VMID B)

        I$ contains [{A,F}->X, {B,F}->Y]

        [VMID ROLLOVER]

        // VMID A
        I$ contains [{A,F}->X, {B,F}->Y]

        Unexpectedly hits stale I$ line {A,F}->X.

However, for PIPT and VIPT I-caches, the VMID doesn't affect lookup or
constrain maintenance. Given the VMID doesn't affect PIPT and VIPT
I-caches, and given VMID rollover is independent of changes to stage-2
mappings, I-cache maintenance cannot be necessary on VMID rollover for
PIPT or VIPT I-caches.

This patch removes the maintenance on rollover for VIPT and PIPT
I-caches. At the same time, the unnecessary colons are removed from the
asm statement to make it more legible.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Christoffer Dall <christoffer.dall@arm.com>
Reviewed-by: James Morse <james.morse@arm.com>
Cc: Julien Thierry <julien.thierry.kdev@gmail.com>
Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/tlb.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index d49a14497715..c466060b76d6 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -193,6 +193,18 @@ void __hyp_text __kvm_flush_vm_context(void)
 {
 	dsb(ishst);
 	__tlbi(alle1is);
-	asm volatile("ic ialluis" : : );
+
+	/*
+	 * VIPT and PIPT caches are not affected by VMID, so no maintenance
+	 * is necessary across a VMID rollover.
+	 *
+	 * VPIPT caches constrain lookup and maintenance to the active VMID,
+	 * so we need to invalidate lines with a stale VMID to avoid an ABA
+	 * race after multiple rollovers.
+	 *
+	 */
+	if (icache_is_vpipt())
+		asm volatile("ic ialluis");
+
 	dsb(ish);
 }
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
