From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 11/21] KVM: arm/arm64: check power_off in kvm_arch_vcpu_runnable
Date: Wed,  4 Nov 2015 15:49:50 +0100
Message-ID: <1446648600-27297-12-git-send-email-christoffer.dall@linaro.org>
References: <1446648600-27297-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 75531499C8
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2015 09:49:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 2bpz8BOupXLC for <kvmarm@lists.cs.columbia.edu>;
 Wed,  4 Nov 2015 09:49:57 -0500 (EST)
Received: from mail-wm0-f50.google.com (mail-wm0-f50.google.com [74.125.82.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 836FD49A07
 for <kvmarm@lists.cs.columbia.edu>; Wed,  4 Nov 2015 09:49:56 -0500 (EST)
Received: by wmff134 with SMTP id f134so43610548wmf.0
 for <kvmarm@lists.cs.columbia.edu>; Wed, 04 Nov 2015 06:53:09 -0800 (PST)
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
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@linaro.org>

kvm_arch_vcpu_runnable now also checks whether the power_off
flag is set.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 9d2fb47..d04deeb 100644
--- a/arch/arm/kvm/arm.c
+++ b/arch/arm/kvm/arm.c
@@ -352,7 +352,8 @@ int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
  */
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *v)
 {
-	return !!v->arch.irq_lines || kvm_vgic_vcpu_pending_irq(v);
+	return ((!!v->arch.irq_lines || kvm_vgic_vcpu_pending_irq(v))
+		&& !v->arch.power_off);
 }
 
 /* Just ensure a guest exit from a particular CPU */
-- 
2.1.2.330.g565301e.dirty
