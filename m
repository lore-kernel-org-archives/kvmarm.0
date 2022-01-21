Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D27C433EF
	for <kvmarm@archiver.kernel.org>; Fri, 21 Jan 2022 18:42:22 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B67A149E46;
	Fri, 21 Jan 2022 13:42:21 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id zjo0CfAHRXsl; Fri, 21 Jan 2022 13:42:20 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 89AE840C67;
	Fri, 21 Jan 2022 13:42:20 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1E2B249DF6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jan 2022 13:42:19 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QY9hO4Eez7Nv for <kvmarm@lists.cs.columbia.edu>;
 Fri, 21 Jan 2022 13:42:17 -0500 (EST)
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B46FA41016
 for <kvmarm@lists.cs.columbia.edu>; Fri, 21 Jan 2022 13:42:17 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ams.source.kernel.org (Postfix) with ESMTPS id 55F23B82077;
 Fri, 21 Jan 2022 18:42:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FF6DC340E1;
 Fri, 21 Jan 2022 18:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1642790533;
 bh=pv2iyFT30rSVyRx5jMpbmdKHGSOmPxgdCT2YMK+DUmI=;
 h=From:To:Cc:Subject:Date:From;
 b=WV+AG3c8LTiS9L3CfICfHwyoWm5gJQ8lPR5Xy4BuJu1gOGlqbAm8/VL1ukbVeegU6
 +UXYzYO89F2Qx8qF6Vg+kRuGrYJnkLtXk1K9ErMcziB3pPNBKIJhNOLoB0ZKjlbedh
 pd3wn0qr4VxY/NVmJQe2bX/Iu0YdDNCmkIRCzyPpx1qigGufn+VwIroNCLgUg2Vxk/
 ZNpuwyAdA3a9K/qT7MKR4WbydzB5lJHIZRsfoDHS5kucJuo3msbV7f6iD4nBS5h0TT
 dwqutm/kuVsyDCtWbSbu/M9czAumNlrYzkGA2pCrAatjcV84KgLCFwq7oYxGlAR62A
 J80lKBQVVIhpQ==
Received: from sofa.misterjones.org ([185.219.108.64] helo=hot-poop.lan)
 by disco-boy.misterjones.org with esmtpsa (TLS1.3) tls
 TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384 (Exim 4.94.2)
 (envelope-from <maz@kernel.org>)
 id 1nAyrS-001ySz-Li; Fri, 21 Jan 2022 18:42:10 +0000
From: Marc Zyngier <maz@kernel.org>
To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Subject: [PATCH] KVM: arm64: Use shadow SPSR_EL1 when injecting exceptions on
 !VHE
Date: Fri, 21 Jan 2022 18:42:07 +0000
Message-Id: <20220121184207.423426-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, james.morse@arm.com,
 suzuki.poulose@arm.com, alexandru.elisei@arm.com, will@kernel.org,
 qperret@google.com, tabba@google.com, kernel-team@android.com,
 stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org);
 SAEximRunCond expanded to false
Cc: kernel-team@android.com, Will Deacon <will@kernel.org>,
 stable@vger.kernel.org
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

Injecting an exception into a guest with non-VHE is risky business.
Instead of writing in the shadow register for the switch code to
restore it, we override the CPU register instead. Which gets
overriden a few instructions later by said restore code.

The result is that although the guest correctly gets the exception,
it will return to the original context in some random state,
depending on what was there the first place... Boo.

Fix the issue by writing to the shadow register. The original code
is absolutely fine on VHE, as the state is already loaded, and writing
to the shadow register in that case would actually be a bug.

Fixes: bb666c472ca2 ("KVM: arm64: Inject AArch64 exceptions from HYP")
Cc: stable@vger.kernel.org
Signed-off-by: Marc Zyngier <maz@kernel.org>
---
 arch/arm64/kvm/hyp/exception.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 0418399e0a20..c5d009715402 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -38,7 +38,10 @@ static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 
 static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
 {
-	write_sysreg_el1(val, SYS_SPSR);
+	if (has_vhe())
+		write_sysreg_el1(val, SYS_SPSR);
+	else
+		__vcpu_sys_reg(vcpu, SPSR_EL1) = val;
 }
 
 static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)
-- 
2.34.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
