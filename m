From: Christoffer Dall <cdall@linaro.org>
Subject: [PULL 06/37] arm/arm64: vgic: turn vgic_find_mmio_region into public
Date: Tue,  9 May 2017 12:44:35 +0200
Message-ID: <20170509104506.30929-7-cdall@linaro.org>
References: <20170509104506.30929-1-cdall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2CE7640AF9
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id d0FBecJqJDE2 for <kvmarm@lists.cs.columbia.edu>;
 Tue,  9 May 2017 06:42:04 -0400 (EDT)
Received: from mail-qk0-f175.google.com (mail-qk0-f175.google.com
 [209.85.220.175])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 3084840C58
 for <kvmarm@lists.cs.columbia.edu>; Tue,  9 May 2017 06:42:04 -0400 (EDT)
Received: by mail-qk0-f175.google.com with SMTP id y201so42660023qka.0
 for <kvmarm@lists.cs.columbia.edu>; Tue, 09 May 2017 03:45:19 -0700 (PDT)
In-Reply-To: <20170509104506.30929-1-cdall@linaro.org>
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
Cc: Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

We plan to use vgic_find_mmio_region in vgic-its.c so let's
turn it into a public function.

Also let's take the opportunity to rename the region parameter
into regions to emphasize this latter is an array of regions.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reviewed-by: Andre Przywara <andre.przywara@arm.com>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Acked-by: Christoffer Dall <cdall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 11 +++++------
 virt/kvm/arm/vgic/vgic-mmio.h |  5 +++++
 2 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 2a5db13..1c17b2a 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -446,13 +446,12 @@ static int match_region(const void *key, const void *elt)
 	return 0;
 }
 
-/* Find the proper register handler entry given a certain address offset. */
-static const struct vgic_register_region *
-vgic_find_mmio_region(const struct vgic_register_region *region, int nr_regions,
-		      unsigned int offset)
+const struct vgic_register_region *
+vgic_find_mmio_region(const struct vgic_register_region *regions,
+		      int nr_regions, unsigned int offset)
 {
-	return bsearch((void *)(uintptr_t)offset, region, nr_regions,
-		       sizeof(region[0]), match_region);
+	return bsearch((void *)(uintptr_t)offset, regions, nr_regions,
+		       sizeof(regions[0]), match_region);
 }
 
 void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index 98bb566..6eec91b 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -192,4 +192,9 @@ u64 vgic_sanitise_shareability(u64 reg);
 u64 vgic_sanitise_field(u64 reg, u64 field_mask, int field_shift,
 			u64 (*sanitise_fn)(u64));
 
+/* Find the proper register handler entry given a certain address offset */
+const struct vgic_register_region *
+vgic_find_mmio_region(const struct vgic_register_region *regions,
+		      int nr_regions, unsigned int offset);
+
 #endif
-- 
2.9.0
