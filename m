From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 06/58] KVM: arm/arm64: Use uaccess functions for GICv3
 {sc}active
Date: Fri, 30 Jun 2017 09:44:22 +0100
Message-ID: <20170630084514.6779-7-marc.zyngier@arm.com>
References: <20170630084514.6779-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 12E6440D77
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:45:51 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CNkB6A4Nczlg for <kvmarm@lists.cs.columbia.edu>;
 Fri, 30 Jun 2017 04:45:50 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A99F840DF2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 30 Jun 2017 04:45:49 -0400 (EDT)
In-Reply-To: <20170630084514.6779-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: Christoffer Dall <cdall@linaro.org>, Stefan Traby <stefan@hello-penguin.com>, kvm@vger.kernel.org, David Daney <david.daney@cavium.com>, Catalin Marinas <catalin.marinas@arm.com>, Hu Huajun <huhuajun@huawei.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Christoffer Dall <cdall@linaro.org>

We recently rewrote the sactive and cactive handlers to take the kvm
lock for guest accesses to these registers.  However, when accessed from
userspace this lock is already held.  Unfortunately we forgot to change
the private accessors for GICv3, because these are redistributor
registers and not distributor registers.

Signed-off-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 23c0d56436a7..e25567a93dd5 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -528,12 +528,14 @@ static const struct vgic_register_region vgic_v3_sgibase_registers[] = {
 		vgic_mmio_read_pending, vgic_mmio_write_cpending,
 		vgic_mmio_read_raz, vgic_mmio_write_wi, 4,
 		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_ISACTIVER0,
-		vgic_mmio_read_active, vgic_mmio_write_sactive, 4,
-		VGIC_ACCESS_32bit),
-	REGISTER_DESC_WITH_LENGTH(GICR_ICACTIVER0,
-		vgic_mmio_read_active, vgic_mmio_write_cactive, 4,
-		VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICR_ISACTIVER0,
+		vgic_mmio_read_active, vgic_mmio_write_sactive,
+		NULL, vgic_mmio_uaccess_write_sactive,
+		4, VGIC_ACCESS_32bit),
+	REGISTER_DESC_WITH_LENGTH_UACCESS(GICR_ICACTIVER0,
+		vgic_mmio_read_active, vgic_mmio_write_cactive,
+		NULL, vgic_mmio_uaccess_write_cactive,
+		4, VGIC_ACCESS_32bit),
 	REGISTER_DESC_WITH_LENGTH(GICR_IPRIORITYR0,
 		vgic_mmio_read_priority, vgic_mmio_write_priority, 32,
 		VGIC_ACCESS_32bit | VGIC_ACCESS_8bit),
-- 
2.11.0
