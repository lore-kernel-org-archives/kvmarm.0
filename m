Return-Path: <SRS0=kdt8=XU=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D62DC432C2
	for <kvmarm@archiver.kernel.org>; Wed, 25 Sep 2019 11:20:16 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id D3B9C21D7C
	for <kvmarm@archiver.kernel.org>; Wed, 25 Sep 2019 11:20:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D3B9C21D7C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 3ED514A69D;
	Wed, 25 Sep 2019 07:20:05 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id xV9bNRUkssd7; Wed, 25 Sep 2019 07:20:04 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 321BC4A6CB;
	Wed, 25 Sep 2019 07:20:03 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 219AB4A6CD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Sep 2019 07:20:02 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2LFfXvhAZuj2 for <kvmarm@lists.cs.columbia.edu>;
 Wed, 25 Sep 2019 07:20:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3E5444A663
 for <kvmarm@lists.cs.columbia.edu>; Wed, 25 Sep 2019 07:20:00 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EB0341570;
 Wed, 25 Sep 2019 04:19:59 -0700 (PDT)
Received: from filthy-habits.cambridge.arm.com
 (filthy-habits.cambridge.arm.com [10.1.197.61])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A436D3F694;
 Wed, 25 Sep 2019 04:19:58 -0700 (PDT)
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org
Subject: [PATCH 3/5] arm64: KVM: Disable EL1 PTW when invalidating S2 TLBs
Date: Wed, 25 Sep 2019 12:19:39 +0100
Message-Id: <20190925111941.88103-4-maz@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190925111941.88103-1-maz@kernel.org>
References: <20190925111941.88103-1-maz@kernel.org>
MIME-Version: 1.0
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>
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

When erratum 1319367 is being worked around, special care must
be taken not to allow the page table walker to populate TLBs
while we have the stage-2 translation enabled (which would otherwise
result in a bizare mix of the host S1 and the guest S2).

We enforce this by setting TCR_EL1.EPD{0,1} before restoring the S2
configuration, and clear the same bits after having disabled S2.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/tlb.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/arm64/kvm/hyp/tlb.c b/arch/arm64/kvm/hyp/tlb.c
index eb0efc5557f3..4ef0bf0d76a6 100644
--- a/arch/arm64/kvm/hyp/tlb.c
+++ b/arch/arm64/kvm/hyp/tlb.c
@@ -63,6 +63,22 @@ static void __hyp_text __tlb_switch_to_guest_vhe(struct kvm *kvm,
 static void __hyp_text __tlb_switch_to_guest_nvhe(struct kvm *kvm,
 						  struct tlb_inv_context *cxt)
 {
+	if (cpus_have_const_cap(ARM64_WORKAROUND_1319367)) {
+		u64 val;
+
+		/*
+		 * For CPUs that are affected by ARM 1319367, we need to
+		 * avoid a host Stage-1 walk while we have the guest's
+		 * Stage-2 set in the VTTBR in order to invalidate TLBs.
+		 * We're guaranteed that the S1 MMU is enabled, so we can
+		 * simply set the EPD bits to avoid any further TLB fill.
+		 */
+		val = cxt->tcr = read_sysreg_el1(SYS_TCR);
+		val |= TCR_EPD1_MASK | TCR_EPD0_MASK;
+		write_sysreg_el1(val, SYS_TCR);
+		isb();
+	}
+
 	__load_guest_stage2(kvm);
 	isb();
 }
@@ -100,6 +116,13 @@ static void __hyp_text __tlb_switch_to_host_nvhe(struct kvm *kvm,
 						 struct tlb_inv_context *cxt)
 {
 	write_sysreg(0, vttbr_el2);
+
+	if (cpus_have_const_cap(ARM64_WORKAROUND_1319367)) {
+		/* Ensure stage-2 is actually disabled */
+		isb();
+		/* Restore the host's TCR_EL1 */
+		write_sysreg_el1(cxt->tcr, SYS_TCR);
+	}
 }
 
 static void __hyp_text __tlb_switch_to_host(struct kvm *kvm,
-- 
2.20.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
