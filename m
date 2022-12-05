Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55EF1C4321E
	for <kvmarm@archiver.kernel.org>; Mon,  5 Dec 2022 11:40:55 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id B890A4B17D;
	Mon,  5 Dec 2022 06:40:54 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id a5rVjkNIRfLO; Mon,  5 Dec 2022 06:40:52 -0500 (EST)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id C94E34B17C;
	Mon,  5 Dec 2022 06:40:52 -0500 (EST)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B309B4141A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2022 06:40:51 -0500 (EST)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id IODQIxV0nh-7 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  5 Dec 2022 06:40:50 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 48C444002F
 for <kvmarm@lists.cs.columbia.edu>; Mon,  5 Dec 2022 06:40:50 -0500 (EST)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 40CE123A;
 Mon,  5 Dec 2022 03:40:56 -0800 (PST)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com
 [10.1.196.159])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1FAC73F73D;
 Mon,  5 Dec 2022 03:40:48 -0800 (PST)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: [PATCH v1] KVM: arm64: Fix benign bug with incorrect use of VA_BITS.
Date: Mon,  5 Dec 2022 11:40:31 +0000
Message-Id: <20221205114031.3972780-1-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>,
 kvmarm@lists.linux.dev, kvmarm@lists.cs.columbia.edu,
 linux-arm-kernel@lists.infradead.org
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

get_user_mapping_size() uses kvm's pgtable library to walk a user space
page table created by the kernel, and in doing so, fakes up the metadata
that the library needs, including ia_bits, which defines the size of the
input address.

For the case where the kernel is compiled for 52 VA bits but runs on HW
that does not support LVA, it will fall back to 48 VA bits at runtime.
Therefore we must use vabits_actual rather than VA_BITS to get the true
address size.

This is benign in the current code base because the pgtable library only
uses it for error checking.

Fixes: 6011cf68c885 ("KVM: arm64: Walk userspace page tables to compute
the THP mapping size")

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/kvm/mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 4efb983cff43..1ef0704420d9 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -641,7 +641,7 @@ static int get_user_mapping_size(struct kvm *kvm, u64 addr)
 {
 	struct kvm_pgtable pgt = {
 		.pgd		= (kvm_pte_t *)kvm->mm->pgd,
-		.ia_bits	= VA_BITS,
+		.ia_bits	= vabits_actual,
 		.start_level	= (KVM_PGTABLE_MAX_LEVELS -
 				   CONFIG_PGTABLE_LEVELS),
 		.mm_ops		= &kvm_user_mm_ops,
--
2.25.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
