From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 01/12] KVM: arm/arm64: Set dist->spis to NULL after kfree
Date: Fri, 13 Apr 2018 10:20:47 +0200
Message-ID: <1523607658-9166-2-git-send-email-eric.auger@redhat.com>
References: <1523607658-9166-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5A63249FA9
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Apr 2018 04:12:34 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oNS-rUL1JYtH for <kvmarm@lists.cs.columbia.edu>;
 Fri, 13 Apr 2018 04:12:13 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 155B14A0A3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 13 Apr 2018 04:12:13 -0400 (EDT)
In-Reply-To: <1523607658-9166-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@kernel.org, peter.maydell@linaro.org
Cc: andre.przywara@arm.com
List-Id: kvmarm@lists.cs.columbia.edu

in case kvm_vgic_map_resources() fails, typically if the vgic
distributor is not defined, __kvm_vgic_destroy will be called
several times. Indeed kvm_vgic_map_resources() is called on
first vcpu run. As a result dist->spis is freeed more than once
and on the second time it causes a "kernel BUG at mm/slub.c:3912!"

Set dist->spis to NULL to avoid the crash.

Fixes: ad275b8bb1e6 ("KVM: arm/arm64: vgic-new: vgic_init: implement
vgic_init")

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>

---

v2 -> v3:
- added Marc's R-b and Fixed commit
---
 virt/kvm/arm/vgic/vgic-init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 68378fe..c52f03d 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -308,6 +308,7 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 	dist->initialized = false;
 
 	kfree(dist->spis);
+	dist->spis = NULL;
 	dist->nr_spis = 0;
 
 	if (vgic_supports_direct_msis(kvm))
-- 
2.5.5
