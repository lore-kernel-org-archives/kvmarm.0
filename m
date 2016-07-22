From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 46/55] KVM: arm64: vgic-its: Fix handling of indirect tables
Date: Fri, 22 Jul 2016 18:29:03 +0100
Message-ID: <1469208552-4155-47-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C46949BF5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:25:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id O+XLoomlEwln for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 13:25:01 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D007D49B9B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:25:01 -0400 (EDT)
In-Reply-To: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, Andre Przywara <andre.przywara@arm.com>, kvmarm@lists.cs.columbia.edu, Dan Carpenter <dan.carpenter@oracle.com>
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
2.8.1
