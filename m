From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 04/13] KVM: arm64: vgic-its: Fix handling of indirect tables
Date: Mon, 18 Jul 2016 16:54:06 +0100
Message-ID: <1468857255-9543-5-git-send-email-marc.zyngier@arm.com>
References: <1468857255-9543-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 80B6349B43
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 11:48:22 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id GswX9F1Q7JIe for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2016 11:48:21 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id AC7EA49B55
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 11:48:20 -0400 (EDT)
In-Reply-To: <1468857255-9543-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>, Andre Przywara <andre.przywara@arm.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

The current code will fail on valid indirect tables, and happily
use the ones that are pointing out of the guest RAM. Funny what a
small "!" can do for you...

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index f427fa2..d6697c4 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -702,9 +702,9 @@ static bool vgic_its_check_device_id(struct kvm *kvm, struct vgic_its *its,
 		return false;
 
 	/* Each 1st level entry is represented by a 64-bit value. */
-	if (!kvm_read_guest(kvm,
-			    BASER_ADDRESS(r) + index * sizeof(indirect_ptr),
-			    &indirect_ptr, sizeof(indirect_ptr)))
+	if (kvm_read_guest(kvm,
+			   BASER_ADDRESS(r) + index * sizeof(indirect_ptr),
+			   &indirect_ptr, sizeof(indirect_ptr)))
 		return false;
 
 	/* check the valid bit of the first level entry */
-- 
2.1.4
