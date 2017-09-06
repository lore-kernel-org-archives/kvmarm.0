From: Vijaya Kumar K <vkilari@codeaurora.org>
Subject: [PATCH] KVM: arm64: vgic-its: Fix wrong return value check in vgic_its_restore_device_tables
Date: Wed,  6 Sep 2017 10:56:05 +0530
Message-ID: <1504675565-13641-1-git-send-email-vkilari@codeaurora.org>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu, eric.auger@redhat.com, marc.zyngier@arm.com, cdall@linaro.org, andre.przywara@arm.com
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, shankerd@codeaurora.org, vvenkat@codeaurora.org, Vijaya Kumar K <vkilari@codeaurora.org>
List-Id: kvmarm@lists.cs.columbia.edu

scan_its_table() return 1 on success. In the function vgic_its_restore_device_tables()
the return value of scan_its_table() is checked against success value
and returns -EINVAL. Hence migration fails for VM with ITS.

With this patch the failure return value is checked while returning
-EINVAL.

Signed-off-by: Vijaya Kumar K <vkilari@codeaurora.org>

diff --git a/virt/kvm/arm/vgic/vgic-its.c b/virt/kvm/arm/vgic/vgic-its.c
index aa6b68d..63f8ac3 100644
--- a/virt/kvm/arm/vgic/vgic-its.c
+++ b/virt/kvm/arm/vgic/vgic-its.c
@@ -2142,7 +2142,7 @@ static int vgic_its_restore_device_tables(struct vgic_its *its)
 				     vgic_its_restore_dte, NULL);
 	}
 
-	if (ret > 0)
+	if (ret <= 0)
 		ret = -EINVAL;
 
 	return ret;
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project
