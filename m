Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 106B0C433EF
	for <kvmarm@archiver.kernel.org>; Wed,  9 Mar 2022 18:13:28 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 57D7149EDE;
	Wed,  9 Mar 2022 13:13:28 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Authentication-Results: mm01.cs.columbia.edu (amavisd-new); dkim=softfail
	(fail, message has been altered) header.i=@kernel.org
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id hvaN8ocbbr5C; Wed,  9 Mar 2022 13:13:27 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 2C39149E22;
	Wed,  9 Mar 2022 13:13:27 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3A11B412AF
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 13:13:25 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id H5obvHByrzfV for <kvmarm@lists.cs.columbia.edu>;
 Wed,  9 Mar 2022 13:13:24 -0500 (EST)
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3C37141071
 for <kvmarm@lists.cs.columbia.edu>; Wed,  9 Mar 2022 13:13:24 -0500 (EST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by dfw.source.kernel.org (Postfix) with ESMTPS id 754B861631;
 Wed,  9 Mar 2022 18:13:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45ECCC340E8;
 Wed,  9 Mar 2022 18:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
 s=k20201202; t=1646849602;
 bh=lyggJlXndKJKDnziS0BOwCX9JVHL04zmV0yEEEp8eGw=;
 h=From:To:Cc:Subject:Date:From;
 b=cIxCCctPMem2NI35nWHGiSJ5+I2A4y5VacGJ+61FL2HnZgfVbAAWqY9OHmcJ01RIs
 EgKmez5rNwoevHVNayWlb3ey7cH5DVdVbUNTrSRNg+/A4ovH/ZN3gXrV7QHCg3DMtV
 JskZ5L21U0tHd5g9clh0dmZUPxQKmnCDkC412PvIXwA1FkiMhUxYxB4tX2125NbyrJ
 5wlloMmq2RrGoSwWWxQUcAIvM7qZCJ6pwuiS7AZnXVzY4acOWPDJ+TrDPCbd4zH85U
 0w8fREeDpKTW9v/VlLtH70aa5KOHzAYtgKZ0+wRl2E2ZgNrufyhmqjGdevL0IrpL4P
 Tcv5ZFToZvGsg==
From: Will Deacon <will@kernel.org>
To: kvmarm@lists.cs.columbia.edu
Subject: [PATCH] KVM: arm64: Really propagate PSCI SYSTEM_RESET2 arguments to
 userspace
Date: Wed,  9 Mar 2022 18:13:08 +0000
Message-Id: <20220309181308.982-1-will@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Cc: maz@kernel.org, Will Deacon <will@kernel.org>,
 Andrew Walbran <qwandor@google.com>, linux-arm-kernel@lists.infradead.org
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

Commit d43583b890e7 ("KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the
guest") hooked up the SYSTEM_RESET2 PSCI call for guests but failed to
preserve its arguments for userspace, instead overwriting them with
zeroes via smccc_set_retval(). As Linux only passes zeroes for these
arguments, this appeared to be working for Linux guests. Oh well.

Don't call smccc_set_retval() for a SYSTEM_RESET2 heading to userspace
and instead set X0 (and only X0) explicitly to PSCI_RET_INTERNAL_FAILURE
just in case the vCPU re-enters the guest.

Fixes: d43583b890e7 ("KVM: arm64: Expose PSCI SYSTEM_RESET2 call to the guest")
Reported-by: Andrew Walbran <qwandor@google.com>
Signed-off-by: Will Deacon <will@kernel.org>
---
 arch/arm64/kvm/psci.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/arm64/kvm/psci.c b/arch/arm64/kvm/psci.c
index ecb4b74cb12a..b0c920717632 100644
--- a/arch/arm64/kvm/psci.c
+++ b/arch/arm64/kvm/psci.c
@@ -367,14 +367,14 @@ static int kvm_psci_1_x_call(struct kvm_vcpu *vcpu, u32 minor)
 		if (minor >= 1) {
 			arg = smccc_get_arg1(vcpu);
 
-			if (arg > PSCI_1_1_RESET_TYPE_SYSTEM_WARM_RESET &&
-			    arg < PSCI_1_1_RESET_TYPE_VENDOR_START) {
-				val = PSCI_RET_INVALID_PARAMS;
-			} else {
+			if (arg <= PSCI_1_1_RESET_TYPE_SYSTEM_WARM_RESET ||
+			    arg >= PSCI_1_1_RESET_TYPE_VENDOR_START) {
 				kvm_psci_system_reset2(vcpu);
-				val = PSCI_RET_INTERNAL_FAILURE;
-				ret = 0;
+				vcpu_set_reg(vcpu, 0, PSCI_RET_INTERNAL_FAILURE);
+				return 0;
 			}
+
+			val = PSCI_RET_INVALID_PARAMS;
 			break;
 		};
 		fallthrough;
-- 
2.35.1.616.g0bdcbb4464-goog

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
