Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FB65C433EF
	for <kvmarm@archiver.kernel.org>; Thu,  2 Jun 2022 08:30:42 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C84694B34F;
	Thu,  2 Jun 2022 04:30:41 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id WXreNS7mBhUo; Thu,  2 Jun 2022 04:30:40 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 5C81D4B315;
	Thu,  2 Jun 2022 04:30:39 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3A6740D26
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2022 04:30:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id MAKPJeT7NR1Y for <kvmarm@lists.cs.columbia.edu>;
 Thu,  2 Jun 2022 04:30:37 -0400 (EDT)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id E996240FD6
 for <kvmarm@lists.cs.columbia.edu>; Thu,  2 Jun 2022 04:30:36 -0400 (EDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 66B4460F6B;
 Thu,  2 Jun 2022 08:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE15DC3411D;
 Thu,  2 Jun 2022 08:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1654158635;
 bh=haGu+jI7bthU49uBnWUYZDqFo4eo6P3HlxDw/iKv+bg=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=OoyfVgdGWh8QTZLWKeBSKcxkFIirLp5xe3j7V5r2WxMNbDdnhrk/Ko5L48eQhRUoI
 0V1HnqR6lRKJWYMRPOh28MQ4dArtnypScXYhp+Un6xK33q+E+/3X8NMSZGs6RqFD/b
 2wcWISq6TwYnTTAAgyLChmLVU1dK9OSYNYfd3gcYPrqe4JBv6IJLxJ1V18Ensi1kcA
 ozBh8bNVFXn61deaBDnRTzNlwh//OnQiJiGwB01W2L65Ek9Lb1TJA9sMR+JPtWSkv/
 fElVFC6PRZW8/evhKrLepQaxNX3w5kp5aRgdPiySH/ha55Pxx25W9YutgjvVJ3S7ej
 TKGROVgwqUmKA==
Received: from sofa.misterjones.org ([185.219.108.64] helo=why.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nwgDx-00F9Sj-FB; Thu, 02 Jun 2022 09:30:33 +0100
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org,
 kvm@vger.kernel.org
Subject: [PATCH 3/3] KVM: arm64: Warn if accessing timer pending state outside
 of vcpu context
Date: Thu,  2 Jun 2022 09:30:25 +0100
Message-Id: <20220602083025.1110433-4-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220602083025.1110433-1-maz@kernel.org>
References: <20220602083025.1110433-1-maz@kernel.org>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, eauger@redhat.com,
 ricarkol@google.com, james.morse@arm.com, suzuki.poulose@arm.com,
 alexandru.elisei@arm.com, oupton@google.com, kernel-team@android.com
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Eric Auger <eauger@redhat.com>
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

A recurrent bug in the KVM/arm64 code base consists in trying to
access the timer pending state outside of the vcpu context, which
makes zero sense (the pending state only exists when the vcpu
is loaded).

In order to avoid more embarassing crashes and catch the offenders
red-handed, add a warning to kvm_arch_timer_get_input_level() and
return the state as non-pending. This avoids taking the system down,
and still helps tracking down silly bugs.

Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/arch_timer.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/kvm/arch_timer.c b/arch/arm64/kvm/arch_timer.c
index 5290ca5db663..bb24a76b4224 100644
--- a/arch/arm64/kvm/arch_timer.c
+++ b/arch/arm64/kvm/arch_timer.c
@@ -1230,6 +1230,9 @@ bool kvm_arch_timer_get_input_level(int vintid)
 	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	struct arch_timer_context *timer;
 
+	if (WARN(!vcpu, "No vcpu context!\n"))
+		return false;
+
 	if (vintid == vcpu_vtimer(vcpu)->irq.irq)
 		timer = vcpu_vtimer(vcpu);
 	else if (vintid == vcpu_ptimer(vcpu)->irq.irq)
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
