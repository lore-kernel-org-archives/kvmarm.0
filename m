From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 7/8] KVM: arm/arm64: vgic-its: Make attribute accessors static
Date: Thu, 28 Mar 2019 13:36:07 +0000
Message-ID: <20190328133608.110805-8-marc.zyngier@arm.com>
References: <20190328133608.110805-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 71F494A2E5
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Mar 2019 09:36:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id I59Ov-1PwZfd for <kvmarm@lists.cs.columbia.edu>;
 Thu, 28 Mar 2019 09:36:55 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 914EA4A3B4
 for <kvmarm@lists.cs.columbia.edu>; Thu, 28 Mar 2019 09:36:55 -0400 (EDT)
In-Reply-To: <20190328133608.110805-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>, Julien Grall <julien.grall@arm.com>, Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: YueHaibing <yuehaibing@huawei.com>

Fix sparse warnings:

arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-its.c:1732:5: warning:
 symbol 'vgic_its_has_attr_regs' was not declared. Should it be static?
arch/arm64/kvm/../../../virt/kvm/arm/vgic/vgic-its.c:1753:5: warning:
 symbol 'vgic_its_attr_regs_access' was not declared. Should it be static?

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
[maz: fixed subject]
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-its.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index fcb2fceaa4a5..44ceaccb18cf 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1736,8 +1736,8 @@ static void vgic_its_destroy(struct kvm_device *kvm_dev)
 	kfree(its);
 }
 
-int vgic_its_has_attr_regs(struct kvm_device *dev,
-			   struct kvm_device_attr *attr)
+static int vgic_its_has_attr_regs(struct kvm_device *dev,
+				  struct kvm_device_attr *attr)
 {
 	const struct vgic_register_region *region;
 	gpa_t offset = attr->attr;
@@ -1757,9 +1757,9 @@ int vgic_its_has_attr_regs(struct kvm_device *dev,
 	return 0;
 }
 
-int vgic_its_attr_regs_access(struct kvm_device *dev,
-			      struct kvm_device_attr *attr,
-			      u64 *reg, bool is_write)
+static int vgic_its_attr_regs_access(struct kvm_device *dev,
+				     struct kvm_device_attr *attr,
+				     u64 *reg, bool is_write)
 {
 	const struct vgic_register_region *region;
 	struct vgic_its *its;
-- 
2.20.1
