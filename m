From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH 6/7] arm64: Do not apply vector harderning for hyp entries
 from EL2
Date: Wed, 26 Sep 2018 14:56:23 +0100
Message-ID: <1537970184-44348-7-git-send-email-julien.thierry@arm.com>
References: <1537970184-44348-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id EAF6C4A200
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Sep 2018 09:56:42 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5sm4W4NxhYmm for <kvmarm@lists.cs.columbia.edu>;
 Wed, 26 Sep 2018 09:56:41 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C3D354A1FD
 for <kvmarm@lists.cs.columbia.edu>; Wed, 26 Sep 2018 09:56:41 -0400 (EDT)
In-Reply-To: <1537970184-44348-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org
Cc: marc.zyngier@arm.com, catalin.marinas@arm.com, will.deacon@arm.com, kvmarm@lists.cs.columbia.edu, Dave.Martin@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

When an EL2 entry of __kvm_hyp_vector is taken, it means an entry from a
lower EL was previously taken to exit the guest. Taking that lower EL entry
already applied vector hardening if needed, so there is no need to do it
again.

Only apply vector hardening for exception coming from lower EL.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Cc: kvmarm@lists.cs.columbia.edu
---
 arch/arm64/kvm/hyp/hyp-entry.S | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kvm/hyp/hyp-entry.S b/arch/arm64/kvm/hyp/hyp-entry.S
index 24b4fba..da31386 100644
--- a/arch/arm64/kvm/hyp/hyp-entry.S
+++ b/arch/arm64/kvm/hyp/hyp-entry.S
@@ -257,7 +257,15 @@ ENTRY(__kvm_hyp_vector)
 ENDPROC(__kvm_hyp_vector)

 #ifdef CONFIG_KVM_INDIRECT_VECTORS
-.macro hyp_ventry
+.macro hyp_el2_ventry
+	.align 7
+1:	b	__kvm_hyp_vector + (1b - 0b)
+	.rept 31
+	nop
+	.endr
+.endm
+
+.macro hyp_el1_ventry
 	.align 7
 1:	.rept 27
 	nop
@@ -290,8 +298,11 @@ alternative_cb_end

 .macro generate_vectors
 0:
-	.rept 16
-	hyp_ventry
+	.rept 8
+	hyp_el2_ventry
+	.endr
+	.rept 8
+	hyp_el1_ventry
 	.endr
 	.org 0b + SZ_2K		// Safety measure
 .endm
--
1.9.1
