From: Joe Perches <joe@perches.com>
Subject: [PATCH 02/18] ARM: KVM: Move asmlinkage before type
Date: Wed,  5 Jul 2017 13:02:11 -0700
Message-ID: <005b8e120650c6a13b541e420f4e3605603fe9e6.1499284835.git.joe@perches.com>
References: <cover.1499284835.git.joe@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D726C40D14
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jul 2017 16:02:19 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id QZG+IpJLWZlC for <kvmarm@lists.cs.columbia.edu>;
 Wed,  5 Jul 2017 16:02:19 -0400 (EDT)
Received: from smtprelay.hostedemail.com (smtprelay0029.hostedemail.com
 [216.40.44.29])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 2818540C5A
 for <kvmarm@lists.cs.columbia.edu>; Wed,  5 Jul 2017 16:02:19 -0400 (EDT)
In-Reply-To: <cover.1499284835.git.joe@perches.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andrew Morton <akpm@linux-foundation.org>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

asmlinkage is either 'extern "C"' or blank.

Move the uses of asmlinkage before the return types to be similar
to the rest of the kernel.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/include/asm/kvm_hyp.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/kvm_hyp.h b/arch/arm/include/asm/kvm_hyp.h
index 58508900c4bb..14b5903f0224 100644
--- a/arch/arm/include/asm/kvm_hyp.h
+++ b/arch/arm/include/asm/kvm_hyp.h
@@ -110,8 +110,8 @@ void __sysreg_restore_state(struct kvm_cpu_context *ctxt);
 void __vgic_v3_save_state(struct kvm_vcpu *vcpu);
 void __vgic_v3_restore_state(struct kvm_vcpu *vcpu);
 
-void asmlinkage __vfp_save_state(struct vfp_hard_struct *vfp);
-void asmlinkage __vfp_restore_state(struct vfp_hard_struct *vfp);
+asmlinkage void __vfp_save_state(struct vfp_hard_struct *vfp);
+asmlinkage void __vfp_restore_state(struct vfp_hard_struct *vfp);
 static inline bool __vfp_enabled(void)
 {
 	return !(read_sysreg(HCPTR) & (HCPTR_TCP(11) | HCPTR_TCP(10)));
@@ -120,8 +120,8 @@ static inline bool __vfp_enabled(void)
 void __hyp_text __banked_save_state(struct kvm_cpu_context *ctxt);
 void __hyp_text __banked_restore_state(struct kvm_cpu_context *ctxt);
 
-int asmlinkage __guest_enter(struct kvm_vcpu *vcpu,
+asmlinkage int __guest_enter(struct kvm_vcpu *vcpu,
 			     struct kvm_cpu_context *host);
-int asmlinkage __hyp_do_panic(const char *, int, u32);
+asmlinkage int __hyp_do_panic(const char *, int, u32);
 
 #endif /* __ARM_KVM_HYP_H__ */
-- 
2.10.0.rc2.1.g053435c
