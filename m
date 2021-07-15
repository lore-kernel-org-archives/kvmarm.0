Return-Path: <SRS0=OVIf=MH=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37A28C07E96
	for <kvmarm@archiver.kernel.org>; Thu, 15 Jul 2021 16:32:33 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id E2BCB613F8
	for <kvmarm@archiver.kernel.org>; Thu, 15 Jul 2021 16:32:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E2BCB613F8
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kvmarm-bounces@lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 95B9A4B0A5;
	Thu, 15 Jul 2021 12:32:32 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ZumGw2CJLaEq; Thu, 15 Jul 2021 12:32:31 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 745444B0DF;
	Thu, 15 Jul 2021 12:32:26 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E2E314B09C
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jul 2021 12:32:23 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id yJ0goA++Ez1o for <kvmarm@lists.cs.columbia.edu>;
 Thu, 15 Jul 2021 12:32:20 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id DAC9F4B098
 for <kvmarm@lists.cs.columbia.edu>; Thu, 15 Jul 2021 12:32:19 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id 1208E613FD;
 Thu, 15 Jul 2021 16:32:19 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1m44HZ-00DYjr-Ei; Thu, 15 Jul 2021 17:32:17 +0100
From: Marc Zyngier <maz@kernel.org>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
 kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 08/16] KVM: arm64: Add tracepoint for failed MMIO guard check
Date: Thu, 15 Jul 2021 17:31:51 +0100
Message-Id: <20210715163159.1480168-9-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210715163159.1480168-1-maz@kernel.org>
References: <20210715163159.1480168-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org,
 kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-kernel@vger.kernel.org, will@kernel.org, qperret@google.com,
 dbrazdil@google.com, vatsa@codeaurora.org, sdonthineni@nvidia.com,
 james.morse@arm.com, suzuki.poulose@arm.com, alexandru.elisei@arm.com,
 kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Srivatsa Vaddagiri <vatsa@codeaurora.org>,
 Shanker R Donthineni <sdonthineni@nvidia.com>, will@kernel.org
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

In order to make debugging easier, expose a new trace point
that triggers when a MMIO check fails.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/mmu.c       |  4 +++-
 arch/arm64/kvm/trace_arm.h | 17 +++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 638827c8842b..c2a23457552b 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1229,8 +1229,10 @@ bool kvm_check_ioguard_page(struct kvm_vcpu *vcpu, gpa_t ipa)
 	ret = __check_ioguard_page(vcpu, ipa & PAGE_MASK);
 	spin_unlock(&vcpu->kvm->mmu_lock);
 
-	if (!ret)
+	if (!ret) {
+		trace_kvm_failed_mmio_check(*vcpu_pc(vcpu), ipa);
 		kvm_inject_dabt(vcpu, kvm_vcpu_get_hfar(vcpu));
+	}
 
 	return ret;
 }
diff --git a/arch/arm64/kvm/trace_arm.h b/arch/arm64/kvm/trace_arm.h
index 33e4e7dd2719..e40cfeb251ad 100644
--- a/arch/arm64/kvm/trace_arm.h
+++ b/arch/arm64/kvm/trace_arm.h
@@ -89,6 +89,23 @@ TRACE_EVENT(kvm_access_fault,
 	TP_printk("IPA: %lx", __entry->ipa)
 );
 
+TRACE_EVENT(kvm_failed_mmio_check,
+	TP_PROTO(unsigned long vcpu_pc, unsigned long ipa),
+	TP_ARGS(vcpu_pc, ipa),
+
+	TP_STRUCT__entry(
+		__field(	unsigned long,	vcpu_pc		)
+		__field(	unsigned long,	ipa		)
+	),
+
+	TP_fast_assign(
+		__entry->vcpu_pc	= vcpu_pc;
+		__entry->ipa		= ipa;
+	),
+
+	TP_printk("PC: %lx IPA: %lx", __entry->vcpu_pc, __entry->ipa)
+);
+
 TRACE_EVENT(kvm_irq_line,
 	TP_PROTO(unsigned int type, int vcpu_idx, int irq_num, int level),
 	TP_ARGS(type, vcpu_idx, irq_num, level),
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
