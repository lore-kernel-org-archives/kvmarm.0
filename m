From: Christoffer Dall <cdall@kernel.org>
Subject: [PULL 09/19] arm: KVM: Fix VTTBR_BADDR_MASK BUG_ON off-by-one
Date: Mon,  4 Dec 2017 15:03:38 +0100
Message-ID: <20171204140348.21965-7-cdall@kernel.org>
References: <20171204135637.21620-1-cdall@kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20171204135637.21620-1-cdall@kernel.org>
Sender: stable-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

From: Marc Zyngier <marc.zyngier@arm.com>

VTTBR_BADDR_MASK is used to sanity check the size and alignment of the
VTTBR address. It seems to currently be off by one, thereby only
allowing up to 39-bit addresses (instead of 40-bit) and also
insufficiently checking the alignment. This patch fixes it.

This patch is the 32bit pendent of Kristina's arm64 fix, and
she deserves the actual kudos for pinpointing that one.

Fixes: f7ed45be3ba52 ("KVM: ARM: World-switch implementation")
Cc: <stable@vger.kernel.org> # 3.9
Reported-by: Kristina Martsenko <kristina.martsenko@arm.com>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
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
