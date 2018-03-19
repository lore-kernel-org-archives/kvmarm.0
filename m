From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 06/12] KVM: arm/arm64: Helper to detect whether an RDIST is the
 last one
Date: Mon, 19 Mar 2018 10:20:14 +0100
Message-ID: <1521451220-27754-7-git-send-email-eric.auger@redhat.com>
References: <1521451220-27754-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D70F949F88
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Mar 2018 05:13:29 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eHnL2e7KncP0 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 19 Mar 2018 05:13:08 -0400 (EDT)
Received: from mx1.redhat.com (mx3-rdu2.redhat.com [66.187.233.73])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id D89DF49FA7
 for <kvmarm@lists.cs.columbia.edu>; Mon, 19 Mar 2018 05:13:03 -0400 (EDT)
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

The TYPER of an redistributor needs to reflect whether the rdist is
the last one of the redistributor region. With a single region we compared
the vcpu id against the number of online vcpus. With multiple regions,
we also need to check the region is not full.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 virt/kvm/arm/vgic/vgic-mmio-v3.c | 3 +--
 virt/kvm/arm/vgic/vgic.h         | 9 +++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
index 227b8b6..5768034 100644
--- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
+++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
@@ -637,8 +637,7 @@ int vgic_register_redist_iodev(struct kvm_vcpu *vcpu)
 	}
 
 	rdreg->free_pfn_offset += 2;
-	vgic_cpu->rdist_last =
-		(vcpu->vcpu_id == atomic_read(&vcpu->kvm->online_vcpus) - 1);
+	vgic_cpu->rdist_last = vgic_v3_last_rdist(vcpu, rdreg);
 out:
 	mutex_unlock(&kvm->slots_lock);
 	return ret;
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 38b2406..04456d3 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -254,6 +254,15 @@ vgic_v3_redist_region_full(struct vgic_redist_region *region)
 	return (region->free_pfn_offset > region->pfns - 2);
 }
 
+static inline bool
+vgic_v3_last_rdist(struct kvm_vcpu *vcpu, struct vgic_redist_region *region)
+{
+	if (vcpu->vcpu_id == atomic_read(&vcpu->kvm->online_vcpus) - 1)
+		return true;
+
+	return vgic_v3_redist_region_full(region);
+}
+
 struct vgic_redist_region *vgic_v3_rdist_free_slot(struct list_head *rd_regions,
 						   uint32_t *free_pfn_offset);
 
-- 
2.5.5
