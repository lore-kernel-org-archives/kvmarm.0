From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v4 18/28] ARM: KVM: Implement HVC_GET_VECTORS in the init code
Date: Tue, 21 Mar 2017 19:20:48 +0000
Message-ID: <20170321192058.9300-19-marc.zyngier@arm.com>
References: <20170321192058.9300-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A09F540C28
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 15:20:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uOP3o9ymol78 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 21 Mar 2017 15:20:35 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DE46140A14
 for <kvmarm@lists.cs.columbia.edu>; Tue, 21 Mar 2017 15:20:35 -0400 (EDT)
In-Reply-To: <20170321192058.9300-1-marc.zyngier@arm.com>
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

Now that we have an infrastructure to handle hypercalls in the KVM
init code, let's implement HVC_GET_VECTORS there.

Tested-by: Keerthy <j-keerthy@ti.com>
Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kvm/init.S | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/init.S b/arch/arm/kvm/init.S
index 9b0c735a68f7..0da120b71c2e 100644
--- a/arch/arm/kvm/init.S
+++ b/arch/arm/kvm/init.S
@@ -122,7 +122,12 @@ __do_hyp_init:
 	eret
 
 ENTRY(__kvm_handle_stub_hvc)
-	cmp	r0, #HVC_RESET_VECTORS
+	cmp	r0, #HVC_GET_VECTORS
+	bne	1f
+	mrc	p15, 4, r0, c12, c0, 0	@ get HVBAR
+	b	exit
+
+1:	cmp	r0, #HVC_RESET_VECTORS
 	bne	1f
 ENTRY(__kvm_hyp_reset)
 	/* We're now in idmap, disable MMU */
-- 
2.11.0
