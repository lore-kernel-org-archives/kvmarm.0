From: Eric Auger <eric.auger@redhat.com>
Subject: [RFC 02/13] arm/arm64: vgic: turn vgic_find_mmio_region into public
Date: Thu, 12 Jan 2017 16:56:42 +0100
Message-ID: <1484236613-24633-3-git-send-email-eric.auger@redhat.com>
References: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3362040354
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 10:55:25 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id ibVfgvNPlU9w for <kvmarm@lists.cs.columbia.edu>;
 Thu, 12 Jan 2017 10:55:24 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 634244044B
 for <kvmarm@lists.cs.columbia.edu>; Thu, 12 Jan 2017 10:55:24 -0500 (EST)
In-Reply-To: <1484236613-24633-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, marc.zyngier@arm.com, christoffer.dall@linaro.org, vijayak@caviumnetworks.com, Vijaya.Kumar@cavium.com, peter.maydell@linaro.org, linux-arm-kernel@lists.infradead.org, drjones@redhat.com, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
Cc: andre.przywara@arm.com, pbonzini@redhat.com, dgilbert@redhat.com, Prasun.Kapoor@cavium.com
List-Id: kvmarm@lists.cs.columbia.edu

We plan to use vgic_find_mmio_region in vgic-its.c so let's
turn it into a public function.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
---
 virt/kvm/arm/vgic/vgic-mmio.c | 3 +--
 virt/kvm/arm/vgic/vgic-mmio.h | 5 +++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
index 28fef92..568bffa 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.c
+++ b/virt/kvm/arm/vgic/vgic-mmio.c
@@ -431,8 +431,7 @@ static int match_region(const void *key, const void *elt)
 	return 0;
 }
 
-/* Find the proper register handler entry given a certain address offset. */
-static const struct vgic_register_region *
+const struct vgic_register_region *
 vgic_find_mmio_region(const struct vgic_register_region *region, int nr_regions,
 		      unsigned int offset)
 {
diff --git a/virt/kvm/arm/vgic/vgic-mmio.h b/virt/kvm/arm/vgic/vgic-mmio.h
index b9423b4..ecf8bfb 100644
--- a/virt/kvm/arm/vgic/vgic-mmio.h
+++ b/virt/kvm/arm/vgic/vgic-mmio.h
@@ -196,4 +196,9 @@ u64 vgic_sanitise_shareability(u64 reg);
 u64 vgic_sanitise_field(u64 reg, u64 field_mask, int field_shift,
 			u64 (*sanitise_fn)(u64));
 
+/* Find the proper register handler entry given a certain address offset */
+const struct vgic_register_region *
+vgic_find_mmio_region(const struct vgic_register_region *region,
+		      int nr_regions, unsigned int offset);
+
 #endif
-- 
2.5.5
