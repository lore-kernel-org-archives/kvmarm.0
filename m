From: Michal Marek <mmarek@suse.com>
Subject: [PATCH 2/9] KVM: arm: Do not indent the arguments of DECLARE_BITMAP
Date: Thu, 15 Oct 2015 22:16:28 +0200
Message-ID: <1444940195-28272-3-git-send-email-mmarek@suse.com>
References: <1444940195-28272-1-git-send-email-mmarek@suse.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1444940195-28272-1-git-send-email-mmarek@suse.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kbuild@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Besides being a coding style issue, it confuses make tags:

ctags: Warning: include/kvm/arm_vgic.h:307: null expansion of name pattern "\1"
ctags: Warning: include/kvm/arm_vgic.h:308: null expansion of name pattern "\1"
ctags: Warning: include/kvm/arm_vgic.h:309: null expansion of name pattern "\1"
ctags: Warning: include/kvm/arm_vgic.h:317: null expansion of name pattern "\1"

Cc: kvmarm@lists.cs.columbia.edu
Signed-off-by: Michal Marek <mmarek@suse.com>
---
 include/kvm/arm_vgic.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index d901f1a47be6..58c5c0eb8d2d 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -304,9 +304,9 @@ struct vgic_cpu {
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
@@ -314,7 +314,7 @@ struct vgic_cpu {
 	unsigned long   *pend_act_shared;
 
 	/* Bitmap of used/free list registers */
-	DECLARE_BITMAP(	lr_used, VGIC_V2_MAX_LRS);
+	DECLARE_BITMAP(lr_used, VGIC_V2_MAX_LRS);
 
 	/* Number of list registers on this CPU */
 	int		nr_lr;
-- 
2.1.4
