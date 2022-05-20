Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F16EDC433EF
	for <kvmarm@archiver.kernel.org>; Fri, 20 May 2022 12:39:01 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 1A2D94B385;
	Fri, 20 May 2022 08:39:01 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id pG-LfNh9OmMu; Fri, 20 May 2022 08:38:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id D761B4B3B7;
	Fri, 20 May 2022 08:38:59 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0FA4E4B3B6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 08:38:58 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id bFrTsGWH3Zzk for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 May 2022 08:38:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D16F34B37E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 May 2022 08:38:56 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 2273F1477;
 Fri, 20 May 2022 05:38:56 -0700 (PDT)
Received: from login2.euhpc.arm.com (login2.euhpc.arm.com [10.6.27.34])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 4742E3F718;
 Fri, 20 May 2022 05:38:55 -0700 (PDT)
From: Vladimir Murzin <vladimir.murzin@arm.com>
To: linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.cs.columbia.edu
Subject: [PATCH kvmtool] aarch64: Give up with MTE for AArch32 guest
Date: Fri, 20 May 2022 13:38:44 +0100
Message-Id: <20220520123844.127733-1-vladimir.murzin@arm.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Cc: will@kernel.org, maz@kernel.org
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

KVM doesn't support combination of MTE and AArch32 guest, so do not
even try.

Signed-off-by: Vladimir Murzin <vladimir.murzin@arm.com>
---
 arm/aarch64/kvm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arm/aarch64/kvm.c b/arm/aarch64/kvm.c
index 1b992dd..f3fe854 100644
--- a/arm/aarch64/kvm.c
+++ b/arm/aarch64/kvm.c
@@ -120,6 +120,11 @@ void kvm__arch_enable_mte(struct kvm *kvm)
 		.cap = KVM_CAP_ARM_MTE,
 	};
 
+	if (kvm->cfg.arch.aarch32_guest) {
+		pr_debug("MTE is incompatible with AArch32");
+		return;
+	}
+
 	if (kvm->cfg.arch.mte_disabled) {
 		pr_debug("MTE disabled by user");
 		return;
-- 
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
