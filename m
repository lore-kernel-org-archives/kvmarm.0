From: Eric Auger <eric.auger@redhat.com>
Subject: [PATCH v3 10/11] KVM: arm/arm64: Document KVM_DEV_ARM_ITS_CTRL_RESET
Date: Mon, 16 Oct 2017 17:03:31 +0200
Message-ID: <1508166212-9599-11-git-send-email-eric.auger@redhat.com>
References: <1508166212-9599-1-git-send-email-eric.auger@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4556941185
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 11:03:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xDxx6G0W+V04 for <kvmarm@lists.cs.columbia.edu>;
 Mon, 16 Oct 2017 11:03:40 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5D71340638
 for <kvmarm@lists.cs.columbia.edu>; Mon, 16 Oct 2017 11:03:40 -0400 (EDT)
In-Reply-To: <1508166212-9599-1-git-send-email-eric.auger@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: eric.auger.pro@gmail.com, eric.auger@redhat.com, linux-kernel@vger.kernel.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, marc.zyngier@arm.com, cdall@linaro.org, peter.maydell@linaro.org, andre.przywara@arm.com, wanghaibin.wang@huawei.com
Cc: wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

At the moment, the in-kernel emulated ITS is not properly reset.
On guest restart/reset some registers keep their old values and
internal structures like device, ITE, and collection lists are not
freed.

This may lead to various bugs. Among them, we can have incorrect state
backup or failure when saving the ITS state at early guest boot stage.

This patch documents a new attribute, KVM_DEV_ARM_ITS_CTRL_RESET in
the KVM_DEV_ARM_VGIC_GRP_CTRL group.

Upon this action, we can reset registers and especially those
pointing to tables previously allocated by the guest and free
the internal data structures storing the list of devices, collections
and lpis.

The usual approach for device reset of having userspace write
the reset values of the registers to the kernel via the register
read/write APIs doesn't work for the ITS because it has some
internal state (caches) which is not exposed as registers,
and there is no register interface for "drop cached data without
writing it back to RAM". So we need a KVM API which mimics the
hardware's reset line, to provide the equivalent behaviour to
a "pull the power cord out of the back of the machine" reset.

Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reported-by: wanghaibin <wanghaibin.wang@huawei.com>

---
v2 -> v3:
- reword commit message, credit to Peter Maydell.
- take into account Christoffer rewording comments but still
  kept details. Added Peter's comment but still kept details.
  Peter may disagree.

v1 -> v2:
- Describe architecturally-defined reset values
---
 Documentation/virtual/kvm/devices/arm-vgic-its.txt | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic-its.txt b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
index eb06beb..4e9bb6f 100644
--- a/Documentation/virtual/kvm/devices/arm-vgic-its.txt
+++ b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
@@ -33,6 +33,10 @@ Groups:
       request the initialization of the ITS, no additional parameter in
       kvm_device_attr.addr.
 
+    KVM_DEV_ARM_ITS_CTRL_RESET
+      reset the ITS, no additional parameter in kvm_device_attr.addr.
+      See "ITS Reset State" section.
+
     KVM_DEV_ARM_ITS_SAVE_TABLES
       save the ITS table data into guest RAM, at the location provisioned
       by the guest in corresponding registers/table entries.
@@ -157,3 +161,19 @@ Then vcpus can be started.
  - pINTID is the physical LPI ID; if zero, it means the entry is not valid
    and other fields are not meaningful.
  - ICID is the collection ID
+
+ ITS Reset State:
+ ----------------
+
+RESET returns the ITS to the same state that it was when first created and
+inited:
+
+- The ITS is not enabled and quiescent
+  GITS_CTLR.Enabled = 0 .Quiescent=1
+- There is no internally cache state
+- No collection or device table are used
+  GITS_BASER<n>.Valid = 0
+- The command queue is not allocated:
+  GITS_CBASER = 0, GITS_CREADR = 0, GITS_CWRITER = 0
+- The ABI version is unchanged and remains the one set when the ITS
+  device was first created.
-- 
2.5.5
