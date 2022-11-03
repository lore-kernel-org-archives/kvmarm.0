Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E84AFC4332F
	for <kvmarm@archiver.kernel.org>; Thu,  3 Nov 2022 15:05:26 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 943CE4B64E;
	Thu,  3 Nov 2022 11:05:26 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id ulBwHKrpYBoY; Thu,  3 Nov 2022 11:05:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 546934B629;
	Thu,  3 Nov 2022 11:05:23 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id F3F254B422
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 11:05:21 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id LQmMe57e1bRF for <kvmarm@lists.cs.columbia.edu>;
 Thu,  3 Nov 2022 11:05:18 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A9E7241070
 for <kvmarm@lists.cs.columbia.edu>; Thu,  3 Nov 2022 11:05:18 -0400 (EDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
 by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7921611FB;
 Thu,  3 Nov 2022 08:05:24 -0700 (PDT)
Received: from e125769.cambridge.arm.com (e125769.cambridge.arm.com
 [10.1.196.169])
 by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5D3B23F5A1;
 Thu,  3 Nov 2022 08:05:16 -0700 (PDT)
From: Ryan Roberts <ryan.roberts@arm.com>
To: Marc Zyngier <maz@kernel.org>
Subject: [PATCH v1 2/2] KVM: arm64: Fix PAR_TO_HPFAR() to work independently
 of PA_BITS.
Date: Thu,  3 Nov 2022 15:05:07 +0000
Message-Id: <20221103150507.32948-3-ryan.roberts@arm.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221103150507.32948-1-ryan.roberts@arm.com>
References: <20221103150507.32948-1-ryan.roberts@arm.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Kernel configs with PAGE_SIZE=64KB and PA_BITS=48 still advertise 52 bit
IPA space on HW that implements LPA. This is by design. (Admitedly this
is a very unlikely configuration in the real world).

However on such a config, attempting to create a vm with the guest
kernel placed above 48 bits in IPA space results in misbehaviour due to
the hypervisor incorrectly interpretting a faulting IPA.

Fix up PAR_TO_HPFAR() to always take 52 bits out of the PAR rather than
masking to CONFIG_ARM64_PA_BITS. If the system has a smaller implemented
PARange this should be safe because the bits are res0.

A more robust approach would be to discover the IPA size in use by the
page-table and mask based on that, to avoid relying on res0 reading back
as zero. But this information is difficult to access safely from the
code's location, so take the easy way out.

Fixes: bc1d7de8c550 ("kvm: arm64: Add 52bit support for PAR to HPFAR
conversoin")

Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
---
 arch/arm64/include/asm/kvm_arm.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/kvm_arm.h b/arch/arm64/include/asm/kvm_arm.h
index 8aa8492dafc0..a82f2493a72b 100644
--- a/arch/arm64/include/asm/kvm_arm.h
+++ b/arch/arm64/include/asm/kvm_arm.h
@@ -340,9 +340,13 @@
  * We have
  *	PAR	[PA_Shift - 1	: 12] = PA	[PA_Shift - 1 : 12]
  *	HPFAR	[PA_Shift - 9	: 4]  = FIPA	[PA_Shift - 1 : 12]
+ *
+ * Always assume 52 bit PA since at this point, we don't know how many PA bits
+ * the page table has been set up for. This should be safe since unused address
+ * bits in PAR are res0.
  */
 #define PAR_TO_HPFAR(par)		\
-	(((par) & GENMASK_ULL(PHYS_MASK_SHIFT - 1, 12)) >> 8)
+	(((par) & GENMASK_ULL(52 - 1, 12)) >> 8)
 
 #define ECN(x) { ESR_ELx_EC_##x, #x }
 
-- 
2.17.1

_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
