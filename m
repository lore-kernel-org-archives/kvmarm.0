From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 7/8] KVM: arm/arm64: vgic-its: Check CBASER/BASER validity
 before enabling the ITS
Date: Mon, 30 Oct 2017 03:56:02 +0100
Message-ID: <20171030025603.23550-8-christoffer.dall@linaro.org>
References: <20171030025603.23550-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6102B406D0
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 22:54:48 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id YlK3IVR8beDY for <kvmarm@lists.cs.columbia.edu>;
 Sun, 29 Oct 2017 22:54:47 -0400 (EDT)
Received: from mail-wm0-f68.google.com (mail-wm0-f68.google.com [74.125.82.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 35B1949D1B
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 22:54:47 -0400 (EDT)
Received: by mail-wm0-f68.google.com with SMTP id b189so12864242wmd.4
 for <kvmarm@lists.cs.columbia.edu>; Sun, 29 Oct 2017 19:56:19 -0700 (PDT)
In-Reply-To: <20171030025603.23550-1-christoffer.dall@linaro.org>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

From: Eric Auger <eric.auger@redhat.com>

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
Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 virt/kvm/arm/vgic/vgic-its.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index 6a715a6ec64e..e69ef7d27fde 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -1466,6 +1466,16 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
 {
 	mutex_lock(&its->cmd_lock);
 
+	/*
+	 * It is UNPREDICTABLE to enable the ITS if any of the CBASER or
+	 * device/collection BASER are invalid
+	 */
+	if (!its->enabled && (val & GITS_CTLR_ENABLE) &&
+		(!(its->baser_device_table & GITS_BASER_VALID) ||
+		 !(its->baser_coll_table & GITS_BASER_VALID) ||
+		 !(its->cbaser & GITS_CBASER_VALID)))
+		goto out;
+
 	its->enabled = !!(val & GITS_CTLR_ENABLE);
 
 	/*
@@ -1474,6 +1484,7 @@ static void vgic_mmio_write_its_ctlr(struct kvm *kvm, struct vgic_its *its,
 	 */
 	vgic_its_process_commands(kvm, its);
 
+out:
 	mutex_unlock(&its->cmd_lock);
 }
 
-- 
2.14.2
