From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 47/55] KVM: arm64: vgic-its: Fix vgic_its_check_device_id BE
 handling
Date: Fri, 22 Jul 2016 18:29:04 +0100
Message-ID: <1469208552-4155-48-git-send-email-marc.zyngier@arm.com>
References: <1469208552-4155-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8B5F649BD3
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:25:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Slbzk99FjvpA for <kvmarm@lists.cs.columbia.edu>;
 Fri, 22 Jul 2016 13:25:03 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CDAD949BF5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 22 Jul 2016 13:25:03 -0400 (EDT)
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

The ITS tables are stored in LE format. If the host is reading
a L1 table entry to check its validity, it must convert it to
the CPU endianness.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index d6697c4..2ac5927 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -707,6 +707,8 @@ static bool vgic_its_check_device_id(struct kvm *kvm, struct vgic_its *its,
 			   &indirect_ptr, sizeof(indirect_ptr)))
 		return false;
 
+	indirect_ptr = le64_to_cpu(indirect_ptr);
+
 	/* check the valid bit of the first level entry */
 	if (!(indirect_ptr & BIT_ULL(63)))
 		return false;
-- 
2.8.1
