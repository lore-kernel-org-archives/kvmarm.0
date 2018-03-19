From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 01/12] KVM: arm/arm64: Avoid multiple dist->spis kfree
Date: Mon, 19 Mar 2018 10:20:09 +0100
Message-ID: <1521451220-27754-2-git-send-email-eric.auger@redhat.com>
References: <1521451220-27754-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DAFD649FB1
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Mar 2018 05:13:09 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id anV1pcqLUKaT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Mar 2018 05:12:48 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 42BC049EB8
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Mar 2018 05:12:48 -0400 (EDT)
In-Reply-To: <1521451220-27754-1-git-send-email-eric.auger@redhat.com>
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
first vcpu run. As a result dist->spis is freeed twice and on
the second time it causes a "kernel BUG at mm/slub.c:3912!"

This patch avoids freeing dist->spis twice.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 virt/kvm/arm/vgic/vgic-init.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
index 743ca5c..38fd5f1 100644
--- a/virt/kvm/arm/vgic/vgic-init.c
+++ b/virt/kvm/arm/vgic/vgic-init.c
@@ -324,7 +324,10 @@ static void kvm_vgic_dist_destroy(struct kvm *kvm)
 	dist->ready = false;
 	dist->initialized = false;
 
-	kfree(dist->spis);
+	if (dist->spis) {
+		kfree(dist->spis);
+		dist->spis = NULL;
+	}
 	dist->nr_spis = 0;
 
 	if (vgic_supports_direct_msis(kvm))
-- 
2.5.5
