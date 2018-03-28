From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 74/85] arm64: KVM: Reserve 4 additional instructions in the
 BPI template
Date: Wed, 28 Mar 2018 13:52:43 +0100
Message-ID: <20180328125254.31380-75-marc.zyngier@arm.com>
References: <20180328125254.31380-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id BEC2D4A0EE
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 09:01:11 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KhiScPOYbpcb for <kvmarm@lists.cs.columbia.edu>;
 Wed, 28 Mar 2018 09:00:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0EF3A4A05E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 28 Mar 2018 08:50:02 -0400 (EDT)
In-Reply-To: <20180328125254.31380-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
Cc: Christoffer Dall <cdall@cs.columbia.edu>, Shunyong Yang <shunyong.yang@hxt-semitech.com>, Julien Thierry <julien.thierry@arm.com>, Andre Przywara <andre.przywara@arm.com>, Will Deacon <will.deacon@arm.com>, Shih-Wei Li <shihwei@cs.columbia.edu>, Catalin Marinas <catalin.marinas@arm.com>, Dave Martin <Dave.Martin@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

So far, we only reserve a single instruction in the BPI template in
order to branch to the vectors. As we're going to stuff a few more
instructions there, let's reserve a total of 5 instructions, which
we're going to patch later on as required.

We also introduce a small refactor of the vectors themselves, so that
we stop carrying the target branch around.

Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Reviewed-by: Andrew Jones <drjones@redhat.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 arch/arm64/kernel/bpi.S | 39 +++++++++++++++------------------------
 1 file changed, 15 insertions(+), 24 deletions(-)

diff --git a/arch/arm64/kernel/bpi.S b/arch/arm64/kernel/bpi.S
index 447188e2a664..ce1cfe3b24e6 100644
--- a/arch/arm64/kernel/bpi.S
+++ b/arch/arm64/kernel/bpi.S
@@ -19,33 +19,24 @@
 #include <linux/linkage.h>
 #include <linux/arm-smccc.h>
 
-.macro ventry target
-	.rept 31
+.macro hyp_ventry
+	.align 7
+1:	.rept 27
 	nop
 	.endr
-	b	\target
+	b	__kvm_hyp_vector + (1b - 0b)
+	nop
+	nop
+	nop
+	nop
 .endm
 
-.macro vectors target
-	ventry \target + 0x000
-	ventry \target + 0x080
-	ventry \target + 0x100
-	ventry \target + 0x180
-
-	ventry \target + 0x200
-	ventry \target + 0x280
-	ventry \target + 0x300
-	ventry \target + 0x380
-
-	ventry \target + 0x400
-	ventry \target + 0x480
-	ventry \target + 0x500
-	ventry \target + 0x580
-
-	ventry \target + 0x600
-	ventry \target + 0x680
-	ventry \target + 0x700
-	ventry \target + 0x780
+.macro generate_vectors
+0:
+	.rept 16
+	hyp_ventry
+	.endr
+	.org 0b + SZ_2K		// Safety measure
 .endm
 
 
@@ -55,7 +46,7 @@
 	.align	11
 ENTRY(__bp_harden_hyp_vecs_start)
 	.rept 4
-	vectors __kvm_hyp_vector
+	generate_vectors
 	.endr
 ENTRY(__bp_harden_hyp_vecs_end)
 
-- 
2.14.2
