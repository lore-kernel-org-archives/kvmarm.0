From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH 30/33] KVM: arm/arm64: Check all vcpu redistributors are set
 on map_resources
Date: Fri,  1 Jun 2018 16:27:44 +0100
Message-ID: <20180601152747.23613-31-marc.zyngier@arm.com>
References: <20180601152747.23613-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2AEFE4A165
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jun 2018 11:22:36 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id PZdHDlx+1SFB for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Jun 2018 11:22:13 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D7E034A153
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jun 2018 11:18:16 -0400 (EDT)
In-Reply-To: <20180601152747.23613-1-marc.zyngier@arm.com>
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
Cc: kvm@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, kvmarm@lists.cs.columbia.edu, Dave Martin <Dave.Martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

On vcpu first run, we eventually know the actual number of vcpus.
This is a synchronization point to check all redistributors
were assigned. On kvm_vgic_map_resources() we check both dist and
redist were set, eventually check potential base address inconsistencies.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Christoffer Dall <christoffer.dall@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 virt/kvm/arm/vgic/vgic-v3.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index ce4476a08f5b..eb32b213f600 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -493,16 +493,25 @@ struct vgic_redist_region *vgic_v3_rdist_free_slot(struct list_head *rd_regions)
 
 int vgic_v3_map_resources(struct kvm *kvm)
 {
-	int ret = 0;
 	struct vgic_dist *dist = &kvm->arch.vgic;
-	struct vgic_redist_region *rdreg =
-		list_first_entry(&dist->rd_regions,
-				 struct vgic_redist_region, list);
+	struct kvm_vcpu *vcpu;
+	int ret = 0;
+	int c;
 
 	if (vgic_ready(kvm))
 		goto out;
 
-	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base) || !rdreg) {
+	kvm_for_each_vcpu(c, vcpu, kvm) {
+		struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
+
+		if (IS_VGIC_ADDR_UNDEF(vgic_cpu->rd_iodev.base_addr)) {
+			kvm_debug("vcpu %d redistributor base not set\n", c);
+			ret = -ENXIO;
+			goto out;
+		}
+	}
+
+	if (IS_VGIC_ADDR_UNDEF(dist->vgic_dist_base)) {
 		kvm_err("Need to set vgic distributor addresses first\n");
 		ret = -ENXIO;
 		goto out;
-- 
2.17.1
