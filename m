From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v6 03/15] KVM: extend struct kvm_msi to hold a 32-bit device ID
Date: Fri, 17 Jun 2016 13:08:35 +0100
Message-ID: <1466165327-32060-4-git-send-email-andre.przywara@arm.com>
References: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C93E749B84
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2016 08:04:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id NK56LszEGoqc for <kvmarm@lists.cs.columbia.edu>;
 Fri, 17 Jun 2016 08:04:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C127349B81
 for <kvmarm@lists.cs.columbia.edu>; Fri, 17 Jun 2016 08:04:05 -0400 (EDT)
In-Reply-To: <1466165327-32060-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

The ARM GICv3 ITS MSI controller requires a device ID to be able to
assign the proper interrupt vector. On real hardware, this ID is
sampled from the bus. To be able to emulate an ITS controller, extend
the KVM MSI interface to let userspace provide such a device ID. For
PCI devices, the device ID is simply the 16-bit bus-device-function
triplet, which should be easily available to the userland tool.

Also there is a new KVM capability which advertises whether the
current VM requires a device ID to be set along with the MSI data.
This flag is still reported as not available everywhere, later we will
enable it when ITS emulation is used.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
Reviewed-by: Eric Auger <eric.auger@linaro.org>
---
 Documentation/virtual/kvm/api.txt | 12 ++++++++++--
 include/uapi/linux/kvm.h          |  5 ++++-
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/Documentation/virtual/kvm/api.txt b/Documentation/virtual/kvm/api.txt
index a4482cc..bf76639 100644
--- a/Documentation/virtual/kvm/api.txt
+++ b/Documentation/virtual/kvm/api.txt
@@ -2169,10 +2169,18 @@ struct kvm_msi {
 	__u32 address_hi;
 	__u32 data;
 	__u32 flags;
-	__u8  pad[16];
+	__u32 devid;
+	__u8  pad[12];
 };
 
-No flags are defined so far. The corresponding field must be 0.
+flags: KVM_MSI_VALID_DEVID: devid contains a valid value
+devid: If KVM_MSI_VALID_DEVID is set, contains a unique device identifier
+       for the device that wrote the MSI message.
+       For PCI, this is usually a BFD identifier in the lower 16 bits.
+
+The per-VM KVM_CAP_MSI_DEVID capability advertises the need to provide
+the device ID. If this capability is not set, userland cannot rely on
+the kernel to allow the KVM_MSI_VALID_DEVID flag being set.
 
 
 4.71 KVM_CREATE_PIT2
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 05ebf47..7de96f5 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -866,6 +866,7 @@ struct kvm_ppc_smmu_info {
 #define KVM_CAP_ARM_PMU_V3 126
 #define KVM_CAP_VCPU_ATTRIBUTES 127
 #define KVM_CAP_MAX_VCPU_ID 128
+#define KVM_CAP_MSI_DEVID 129
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1024,12 +1025,14 @@ struct kvm_one_reg {
 	__u64 addr;
 };
 
+#define KVM_MSI_VALID_DEVID	(1U << 0)
 struct kvm_msi {
 	__u32 address_lo;
 	__u32 address_hi;
 	__u32 data;
 	__u32 flags;
-	__u8  pad[16];
+	__u32 devid;
+	__u8  pad[12];
 };
 
 struct kvm_arm_device_addr {
-- 
2.8.2
