Return-Path: <SRS0=5TFS=PB=lists.cs.columbia.edu=kvmarm-bounces@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63EA4C433EF
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 12:26:56 +0000 (UTC)
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by mail.kernel.org (Postfix) with ESMTP id CD71A610E7
	for <kvmarm@archiver.kernel.org>; Wed, 13 Oct 2021 12:26:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org CD71A610E7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.cs.columbia.edu
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 70DA94B11B;
	Wed, 13 Oct 2021 08:26:55 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 1LRNIgxj-HrZ; Wed, 13 Oct 2021 08:26:53 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id E17E54B0D0;
	Wed, 13 Oct 2021 08:26:53 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A80284B08D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:26:52 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id x-6ZLYNE5hNq for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Oct 2021 08:26:51 -0400 (EDT)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B7D3F4B08B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Oct 2021 08:26:51 -0400 (EDT)
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org
 [51.254.78.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mail.kernel.org (Postfix) with ESMTPSA id B990161151;
 Wed, 13 Oct 2021 12:26:50 +0000 (UTC)
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1maczJ-00GTgY-EP; Wed, 13 Oct 2021 13:04:01 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH v9 22/22] KVM: arm64: pkvm: Give priority to standard traps
 over pvm handling
Date: Wed, 13 Oct 2021 13:03:46 +0100
Message-Id: <20211013120346.2926621-12-maz@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211013120346.2926621-1-maz@kernel.org>
References: <20211010145636.1950948-12-tabba@google.com>
 <20211013120346.2926621-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, will@kernel.org, james.morse@arm.com,
 alexandru.elisei@arm.com, suzuki.poulose@arm.com, mark.rutland@arm.com,
 pbonzini@redhat.com, drjones@redhat.com, oupton@google.com, qperret@google.com,
 kernel-team@android.com, tabba@google.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, pbonzini@redhat.com, will@kernel.org
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

Checking for pvm handling first means that we cannot handle ptrauth
traps or apply any of the workarounds (GICv3 or TX2 #219).

Flip the order around.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/nvhe/switch.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 50c7d48e0fa0..c0e3fed26d93 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -167,10 +167,13 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
  */
 static bool kvm_handle_pvm_sys64(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
-	if (kvm_handle_pvm_sysreg(vcpu, exit_code))
-		return true;
-
-	return kvm_hyp_handle_sysreg(vcpu, exit_code);
+	/*
+	 * Make sure we handle the exit for workarounds and ptrauth
+	 * before the pKVM handling, as the latter could decide to
+	 * UNDEF.
+	 */
+	return (kvm_hyp_handle_sysreg(vcpu, exit_code) ||
+		kvm_handle_pvm_sysreg(vcpu, exit_code));
 }
 
 /**
-- 
2.30.2

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
