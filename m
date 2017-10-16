From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 04/11] KVM: arm/arm64: vgic-its: Check CBASER/BASER validity before enabling the ITS
Date: Mon, 16 Oct 2017 17:03:25 +0200
Message-ID: <1508166212-9599-5-git-send-email-eric.auger@redhat.com>
References: <1508166212-9599-1-git-send-email-eric.auger@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1508166212-9599-1-git-send-email-eric.auger@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com
Cc: wu.wubin@huawei.com, drjones@redhat.com, wei@redhat.com
List-Id: kvmarm@lists.cs.columbia.edu

The spec says it is UNPREDICTABLE to enable the ITS
if any of the following conditions are true:

- GITS_CBASER.Valid == 0.
- GITS_BASER<n>.Valid == 0, for any GITS_BASER<n> register
  where the Type field indicates Device.
- GITS_BASER<n>.Valid == 0, for any GITS_BASER<n> register
  where the Type field indicates Interrupt Collection and
  GITS_TYPER.HCC == 0.

In that case, let's keep the ITS disabled.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reported-by: Andre Przywara <andre.przywara@arm.com>

---

v3: creation
---
 virt/kvm/arm/vgic/vgic-its.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 51cb836..c5717cf 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1488,6 +1488,16 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
 	its->enabled = !!(val & GITS_CTLR_ENABLE);
 
 	/*
+	 * It is UNPREDICTABLE to enable the ITS if any of the CBASER or
+	 * device/collection BASER are invalid
+	 */
+	if (its->enabled &&
+		(!(its->baser_device_table & GITS_BASER_VALID) ||
+		 !(its->baser_coll_table & GITS_BASER_VALID) ||
+		 !(its->cbaser && GITS_CBASER_VALID)))
+		its->enabled = false;
+
+	/*
 	 * Try to process any pending commands. This function bails out early
 	 * if the ITS is disabled or no commands have been queued.
 	 */
-- 
2.5.5
