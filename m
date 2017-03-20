From: Christoffer Dall <cdall@linaro.org>
Subject: [PATCH 8/9] KVM: arm/arm64: vgic: Don't check vgic_initialized in
 flush_hwstate
Date: Mon, 20 Mar 2017 11:58:17 +0100
Message-ID: <20170320105818.20481-9-cdall@linaro.org>
References: <20170320105818.20481-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 773C140C66
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 06:56:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id FY0QzDZ-GkGj for <kvmarm@lists.cs.columbia.edu>;
 Mon, 20 Mar 2017 06:56:50 -0400 (EDT)
Received: from mail-wr0-f179.google.com (mail-wr0-f179.google.com
 [209.85.128.179])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5877340CE4
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 06:56:49 -0400 (EDT)
Received: by mail-wr0-f179.google.com with SMTP id u48so89502177wrc.0
 for <kvmarm@lists.cs.columbia.edu>; Mon, 20 Mar 2017 03:58:34 -0700 (PDT)
In-Reply-To: <20170320105818.20481-1-cdall@linaro.org>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <cdall@linaro.org>, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Now when we do an early init of the static parts of the VGIC data
structures, we can do things like checking if the AP lists are empty
directly without having to explicitly check if the vgic is initialized
and reduce a bit of work in our criticial path.

Note: list_empty is a single atomic read (uses READ_ONCE) and can
therefore check if a list is empty or not without the need to take the
spinlock protecting the list.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index f5b3c25..093873e 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -653,9 +653,6 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 /* Flush our emulation state into the GIC hardware before entering the guest. */
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 {
-	if (unlikely(!vgic_initialized(vcpu->kvm)))
-		return;
-
 	if (list_empty(&vcpu->arch.vgic_cpu.ap_list_head))
 		return;
 
-- 
2.9.0
