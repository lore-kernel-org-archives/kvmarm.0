From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 10/20] ARM: hyp-stub: Use r1 for the soft-restart address
Date: Fri, 17 Feb 2017 15:44:19 +0000
Message-ID: <20170217154429.5000-11-marc.zyngier@arm.com>
References: <20170217154429.5000-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6685940DDC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Feb 2017 10:44:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FyZg-E+t4uOx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Feb 2017 10:44:36 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 867AB40DEE
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Feb 2017 10:44:36 -0500 (EST)
In-Reply-To: <20170217154429.5000-1-marc.zyngier@arm.com>
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
Cc: Catalin Marinas <catalin.marinas@arm.com>, Russell King <linux@arm.linux.org.uk>
List-Id: kvmarm@lists.cs.columbia.edu

It is not really obvious why the restart address should be in r3
when communicated to the hyp-stub. r1 should be perfectly adequate,
and consistent with the rest of the code.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm/kernel/hyp-stub.S | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm/kernel/hyp-stub.S b/arch/arm/kernel/hyp-stub.S
index 8301db963d83..8fa521bd63d2 100644
--- a/arch/arm/kernel/hyp-stub.S
+++ b/arch/arm/kernel/hyp-stub.S
@@ -214,7 +214,7 @@ __hyp_stub_do_trap:
 
 1:	teq	r0, #HVC_SOFT_RESTART
 	bne	1f
-	bx	r3
+	bx	r1
 
 1:	mov	r0, #-1
 
@@ -258,10 +258,8 @@ ENTRY(__hyp_set_vectors)
 ENDPROC(__hyp_set_vectors)
 
 ENTRY(__hyp_soft_restart)
-	mov	r3, r0
 	mov	r0, #HVC_SOFT_RESTART
 	__HVC(0)
-	mov	r0, r3
 	ret	lr
 ENDPROC(__hyp_soft_restart)
 
-- 
2.11.0
