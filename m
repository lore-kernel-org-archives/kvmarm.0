From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 18/34] ARM: hyp-stub: Define a return value for failed stub
 calls
Date: Mon,  3 Apr 2017 19:37:51 +0100
Message-ID: <20170403183807.1620-19-marc.zyngier@arm.com>
References: <20170403183807.1620-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EACF640C2C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:36:55 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sVJQKYqw9hzv for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Apr 2017 14:36:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id ED7BB40625
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:36:54 -0400 (EDT)
In-Reply-To: <20170403183807.1620-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Keerthy <j-keerthy@ti.com>
List-Id: kvmarm@lists.cs.columbia.edu

Define a standard return value to be returned when a hyp stub
call fails.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/include/asm/virt.h | 2 ++
 arch/arm/kernel/hyp-stub.S  | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/arm/include/asm/virt.h b/arch/arm/include/asm/virt.h
index 4ea16fcaf2ed..c16f70d6953f 100644
--- a/arch/arm/include/asm/virt.h
+++ b/arch/arm/include/asm/virt.h
@@ -104,4 +104,6 @@ extern char __hyp_text_end[];
 
 #endif /* __ASSEMBLY__ */
 
+#define HVC_STUB_ERR	0xbadca11
+
 #endif /* ! VIRT_H */
diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index 15eaa14322a7..b20ca8815911 100644
--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -216,7 +216,7 @@ __hyp_stub_do_trap:
 	bne	1f
 	bx	r1
 
-1:	mov	r0, #-1
+1:	ldr	r0, =HVC_STUB_ERR
 
 __hyp_stub_exit:
 	__ERET
-- 
2.11.0
