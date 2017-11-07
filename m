From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [PULL 23/26] KVM: arm/arm64: Document KVM_DEV_ARM_ITS_CTRL_RESET
Date: Tue,  7 Nov 2017 11:47:56 +0100
Message-ID: <20171107104800.30021-24-christoffer.dall@linaro.org>
References: <20171107104800.30021-1-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1279449D80
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 05:46:57 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id KcKgDPPGtovf for <kvmarm@lists.cs.columbia.edu>;
 Tue,  7 Nov 2017 05:46:56 -0500 (EST)
Received: from mail-wm0-f65.google.com (mail-wm0-f65.google.com [74.125.82.65])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id C6CC049D9D
 for <kvmarm@lists.cs.columbia.edu>; Tue,  7 Nov 2017 05:46:49 -0500 (EST)
Received: by mail-wm0-f65.google.com with SMTP id p75so2739500wmg.3
 for <kvmarm@lists.cs.columbia.edu>; Tue, 07 Nov 2017 02:48:44 -0800 (PST)
In-Reply-To: <20171107104800.30021-1-christoffer.dall@linaro.org>
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

Reviewed-by: Christoffer Dall <christoffer.dall@linaro.org>
Reviewed-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Eric Auger <eric.auger@redhat.com>
Reported-by: wanghaibin <wanghaibin.wang@huawei.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 Documentation/virtual/kvm/devices/arm-vgic-its.txt | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/Documentation/virtual/kvm/devices/arm-vgic-its.txt b/Documentation/virtual/kvm/devices/arm-vgic-its.txt
index eb06beb75960..8d5830eab26a 100644
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
+initialized. When the RESET command returns, the following things are
+guaranteed:
+
+- The ITS is not enabled and quiescent
+  GITS_CTLR.Enabled = 0 .Quiescent=1
+- There is no internally cached state
+- No collection or device table are used
+  GITS_BASER<n>.Valid = 0
+- GITS_CBASER = 0, GITS_CREADR = 0, GITS_CWRITER = 0
+- The ABI version is unchanged and remains the one set when the ITS
+  device was first created.
-- 
2.14.2
