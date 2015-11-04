From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 18/21] KVM: arm: Do not indent the arguments of DECLARE_BITMAP
Date: Wed,  4 Nov 2015 15:49:57 +0100
Message-ID: <1446648600-27297-19-git-send-email-christoffer.dall@linaro.org>
References: <1446648600-27297-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7E93A4999F
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2015 09:50:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id T96+6fO8j-sz for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2015 09:50:05 -0500 (EST)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 7AA65499DA
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2015 09:50:03 -0500 (EST)
Received: by wmll128 with SMTP id l128so116258388wml.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2015 06:53:16 -0800 (PST)
In-Reply-To: <1446648600-27297-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Michal Marek <mmarek@suse.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Michal Marek <mmarek@suse.com>

Besides being a coding style issue, it confuses make tags:

ctags: Warning: include/kvm/arm_vgic.h:307: null expansion of name pattern "\1"
ctags: Warning: include/kvm/arm_vgic.h:308: null expansion of name pattern "\1"
ctags: Warning: include/kvm/arm_vgic.h:309: null expansion of name pattern "\1"
ctags: Warning: include/kvm/arm_vgic.h:317: null expansion of name pattern "\1"

Cc: kvmarm@lists.cs.columbia.edu
Signed-off-by: Michal Marek <mmarek@suse.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 include/kvm/arm_vgic.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 7bc5d02..8065801 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -299,9 +299,9 @@ struct vgic_cpu {
 	u8		*vgic_irq_lr_map;
 
 	/* Pending/active/both interrupts on this VCPU */
-	DECLARE_BITMAP(	pending_percpu, VGIC_NR_PRIVATE_IRQS);
-	DECLARE_BITMAP(	active_percpu, VGIC_NR_PRIVATE_IRQS);
-	DECLARE_BITMAP(	pend_act_percpu, VGIC_NR_PRIVATE_IRQS);
+	DECLARE_BITMAP(pending_percpu, VGIC_NR_PRIVATE_IRQS);
+	DECLARE_BITMAP(active_percpu, VGIC_NR_PRIVATE_IRQS);
+	DECLARE_BITMAP(pend_act_percpu, VGIC_NR_PRIVATE_IRQS);
 
 	/* Pending/active/both shared interrupts, dynamically sized */
 	unsigned long	*pending_shared;
@@ -309,7 +309,7 @@ struct vgic_cpu {
 	unsigned long   *pend_act_shared;
 
 	/* Bitmap of used/free list registers */
-	DECLARE_BITMAP(	lr_used, VGIC_V2_MAX_LRS);
+	DECLARE_BITMAP(lr_used, VGIC_V2_MAX_LRS);
 
 	/* Number of list registers on this CPU */
 	int		nr_lr;
-- 
2.1.2.330.g565301e.dirty
