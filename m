From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 28/28] arm: KVM: Add S2_PMD_{MASK,SIZE} constants
Date: Wed, 19 Dec 2018 18:03:49 +0000
Message-ID: <20181219180349.242681-29-marc.zyngier@arm.com>
References: <20181219180349.242681-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 053E34A373
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:05:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id fZqefkiQtKMJ for <kvmarm@lists.cs.columbia.edu>;
 Wed, 19 Dec 2018 13:05:27 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ACB414A37D
 for <kvmarm@lists.cs.columbia.edu>; Wed, 19 Dec 2018 13:05:27 -0500 (EST)
In-Reply-To: <20181219180349.242681-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: Punit Agrawal <punit.agrawal@arm.com>, kvm@vger.kernel.org, "Gustavo A . R . Silva" <gustavo@embeddedor.com>, Will Deacon <will.deacon@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, Lukas Braun <koomi@moshbit.net>
List-Id: kvmarm@lists.cs.columbia.edu

They were missing, and it turns out that we do need them now.

Acked-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/stage2_pgtable.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm/include/asm/stage2_pgtable.h b/arch/arm/include/asm/stage2_pgtable.h
index f9017167a8d1..c4b1d4fb1797 100644
--- a/arch/arm/include/asm/stage2_pgtable.h
+++ b/arch/arm/include/asm/stage2_pgtable.h
@@ -73,4 +73,7 @@ static inline bool kvm_stage2_has_pud(struct kvm *kvm)
 	return false;
 }
 
+#define S2_PMD_MASK				PMD_MASK
+#define S2_PMD_SIZE				PMD_SIZE
+
 #endif	/* __ARM_S2_PGTABLE_H_ */
-- 
2.19.2
