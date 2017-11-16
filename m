From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 7/7] arm: KVM: Fix VTTBR_BADDR_MASK BUG_ON off-by-one
Date: Thu, 16 Nov 2017 17:58:21 +0000
Message-ID: <20171116175821.26544-8-marc.zyngier@arm.com>
References: <20171116175821.26544-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 283EB49D23
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Nov 2017 12:56:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VhkIx-MkAvHe for <kvmarm@lists.cs.columbia.edu>;
 Thu, 16 Nov 2017 12:56:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 089EB49D56
 for <kvmarm@lists.cs.columbia.edu>; Thu, 16 Nov 2017 12:56:26 -0500 (EST)
In-Reply-To: <20171116175821.26544-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <cdall@linaro.org>
Cc: kvm@vger.kernel.org, Kristina Martsenko <kristina.martsenko@arm.com>, AKASHI Takahiro <takahiro.akashi@linaro.org>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

VTTBR_BADDR_MASK is used to sanity check the size and alignment of the
VTTBR address. It seems to currently be off by one, thereby only
allowing up to 39-bit addresses (instead of 40-bit) and also
insufficiently checking the alignment. This patch fixes it.

This patch is the 32bit pendent of Kristina's arm64 fix, and
she deserves the actual kudos for pinpointing that one.

Fixes: f7ed45be3ba52 ("KVM: ARM: World-switch implementation")
Cc: <stable@vger.kernel.org> # 3.9
Reported-by: Kristina Martsenko <kristina.martsenko@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/kvm_arm.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/kvm_arm.h b/arch/arm/include/asm/kvm_arm.h
index c8781450905b..3ab8b3781bfe 100644
--- a/arch/arm/include/asm/kvm_arm.h
+++ b/arch/arm/include/asm/kvm_arm.h
@@ -161,8 +161,7 @@
 #else
 #define VTTBR_X		(5 - KVM_T0SZ)
 #endif
-#define VTTBR_BADDR_SHIFT (VTTBR_X - 1)
-#define VTTBR_BADDR_MASK  (((_AC(1, ULL) << (40 - VTTBR_X)) - 1) << VTTBR_BADDR_SHIFT)
+#define VTTBR_BADDR_MASK  (((_AC(1, ULL) << (40 - VTTBR_X)) - 1) << VTTBR_X)
 #define VTTBR_VMID_SHIFT  _AC(48, ULL)
 #define VTTBR_VMID_MASK(size)	(_AT(u64, (1 << size) - 1) << VTTBR_VMID_SHIFT)
 
-- 
2.14.2
