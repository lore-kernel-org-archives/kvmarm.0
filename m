From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 33/34] ARM: hyp-stub: Zero r0 on successful stub handling
Date: Mon,  3 Apr 2017 19:38:06 +0100
Message-ID: <20170403183807.1620-34-marc.zyngier@arm.com>
References: <20170403183807.1620-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D509840C54
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:37:24 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Fu2Se289k0-c for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Apr 2017 14:37:23 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B4E9740C5A
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:37:22 -0400 (EDT)
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

We now return HVC_STUB_ERR when a stub hypercall fails, but we
leave whatever was in r0 on success. Zeroing it on return seems
like a good idea.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kernel/hyp-stub.S | 2 ++
 arch/arm/kvm/init.S        | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index 918c64f17128..d8523cc47a54 100644
--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -215,8 +215,10 @@ __hyp_stub_do_trap:
 	beq	__hyp_stub_exit
 
 	ldr	r0, =HVC_STUB_ERR
+	__ERET
 
 __hyp_stub_exit:
+	mov	r0, #0
 	__ERET
 ENDPROC(__hyp_stub_do_trap)
 
diff --git a/arch/arm/kvm/init.S b/arch/arm/kvm/init.S
index 87bcd7ae4552..570ed4a9c261 100644
--- a/arch/arm/kvm/init.S
+++ b/arch/arm/kvm/init.S
@@ -155,8 +155,10 @@ reset:
 	b	exit
 
 1:	ldr	r0, =HVC_STUB_ERR
+	eret
 
 exit:
+	mov	r0, #0
 	eret
 ENDPROC(__kvm_handle_stub_hvc)
 
-- 
2.11.0
