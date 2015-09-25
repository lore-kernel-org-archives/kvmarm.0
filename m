From: Eric Auger <eric.auger@linaro.org>
Subject: [PATCH v3 2/4] KVM: arm/arm64: check power_off in
 kvm_arch_vcpu_runnable
Date: Fri, 25 Sep 2015 23:41:15 +0200
Message-ID: <1443217277-13173-3-git-send-email-eric.auger@linaro.org>
References: <1443217277-13173-1-git-send-email-eric.auger@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0AB4848AD0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Sep 2015 17:41:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gDZnKN6Tb+68 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Sep 2015 17:41:08 -0400 (EDT)
Received: from mail-pa0-f47.google.com (mail-pa0-f47.google.com
 [209.85.220.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3378748AF2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Sep 2015 17:41:08 -0400 (EDT)
Received: by pacex6 with SMTP id ex6so116322444pac.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Sep 2015 14:42:32 -0700 (PDT)
In-Reply-To: <1443217277-13173-1-git-send-email-eric.auger@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger@st.com, eric.auger@linaro.org, christoffer.dall@linaro.org, marc.zyngier@arm.com, drjones@redhat.com, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
List-Id: kvmarm@lists.cs.columbia.edu

kvm_arch_vcpu_runnable now also checks whether the power_off
flag is set.

Signed-off-by: Eric Auger <eric.auger@linaro.org>
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 arch/arm/kvm/arm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/kvm/arm.c b/arch/arm/kvm/arm.c
index 2b19ef7..9d16f76 100644
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
1.9.1
