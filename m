From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [GIT PULL 4/5] arm/arm64: KVM: fix missing unlock on error in
 kvm_vgic_create()
Date: Mon, 16 Mar 2015 13:55:02 +0100
Message-ID: <1426510503-27995-5-git-send-email-christoffer.dall@linaro.org>
References: <1426510503-27995-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 92C3048E52
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2015 08:48:38 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id gxtKmB+YV3bN for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Mar 2015 08:48:31 -0400 (EDT)
Received: from mail-lb0-f176.google.com (mail-lb0-f176.google.com
 [209.85.217.176])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9EF4148E5F
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2015 08:48:31 -0400 (EDT)
Received: by lbcds1 with SMTP id ds1so29954053lbc.3
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Mar 2015 05:55:04 -0700 (PDT)
In-Reply-To: <1426510503-27995-1-git-send-email-christoffer.dall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Wei Yongjun <yongjun_wei@trendmicro.com.cn>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Add the missing unlock before return from function kvm_vgic_create()
in the error handling case.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 0cc6ab6..4b2c2e7 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -1583,8 +1583,10 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	 * emulation. So check this here again. KVM_CREATE_DEVICE does
 	 * the proper checks already.
 	 */
-	if (type == KVM_DEV_TYPE_ARM_VGIC_V2 && !vgic->can_emulate_gicv2)
-		return -ENODEV;
+	if (type == KVM_DEV_TYPE_ARM_VGIC_V2 && !vgic->can_emulate_gicv2) {
+		ret = -ENODEV;
+		goto out;
+	}
 
 	/*
 	 * Any time a vcpu is run, vcpu_load is called which tries to grab the
-- 
2.1.2.330.g565301e.dirty
