Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F8F1FA3743
	for <kvmarm@archiver.kernel.org>; Thu, 27 Oct 2022 12:10:07 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 07D1C40E00;
	Thu, 27 Oct 2022 08:10:07 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id YnV2488vMh3V; Thu, 27 Oct 2022 08:10:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C230F40DE6;
	Thu, 27 Oct 2022 08:10:05 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4C1B340DE6
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 08:10:04 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id l1JIjovKH4Os for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Oct 2022 08:10:02 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BD92D40658
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2022 08:10:02 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6141C23A;
 Thu, 27 Oct 2022 05:10:08 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com
 [10.1.196.169])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8DA863F7B4;
 Thu, 27 Oct 2022 05:10:00 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: [PATCH v1] KVM: arm64: Fix bad dereference on MTE-enabled systems.
Date: Thu, 27 Oct 2022 13:09:45 +0100
Message-Id: <20221027120945.29679-1-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.17.1
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 Steven Price <steven.price@arm.com>, kvmarm@lists.linux.dev,
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

enter_exception64() performs an MTE check, which involves dereferencing
vcpu->kvm. While vcpu has already been fixed up for hyp va, kvm is still
a kern va pointer.

Fix this by first converting kvm to a hyp va pointer. If the system does
not support MTE, the dereference is avoided in the first place.

Fixes: ea7fc1bb1cd1 ("KVM: arm64: Introduce MTE VM feature")

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/kvm/hyp/exception.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index b7557b25ed56..791d3de76771 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -13,6 +13,7 @@
 #include <hyp/adjust_pc.h>
 #include <linux/kvm_host.h>
 #include <asm/kvm_emulate.h>
+#include <asm/kvm_mmu.h>

 #if !defined (__KVM_NVHE_HYPERVISOR__) && !defined (__KVM_VHE_HYPERVISOR__)
 #error Hypervisor code only!
@@ -115,7 +116,7 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 	new |= (old & PSR_C_BIT);
 	new |= (old & PSR_V_BIT);

-	if (kvm_has_mte(vcpu->kvm))
+	if (kvm_has_mte(kern_hyp_va(vcpu->kvm)))
 		new |= PSR_TCO_BIT;

 	new |= (old & PSR_DIT_BIT);
--
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
