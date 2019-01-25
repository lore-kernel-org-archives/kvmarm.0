From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v2 2/2] KVM: doc: add API documentation on the
 KVM_REG_ARM_WORKAROUNDS register
Date: Fri, 25 Jan 2019 15:07:41 +0000
Message-ID: <20190125150741.184128-3-andre.przywara@arm.com>
References: <20190125150741.184128-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A30294A3E8
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 10:08:00 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 3YiMHMSebFzx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jan 2019 10:07:56 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E38F94A3F0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 10:07:54 -0500 (EST)
In-Reply-To: <20190125150741.184128-1-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
Cc: kvm@vger.kernel.org, Steven Price <steven.price@arm.com>, kvmarm@lists.cs.columbia.edu, Dave Martin <dave.martin@arm.com>, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Add documentation for the newly defined firmware registers to save and
restore any vulnerability migitation status.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 Documentation/virtual/kvm/arm/psci.txt | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/Documentation/virtual/kvm/arm/psci.txt b/Documentation/virtual/kvm/arm/psci.txt
index aafdab887b04..411f77e685d4 100644
--- a/Documentation/virtual/kvm/arm/psci.txt
+++ b/Documentation/virtual/kvm/arm/psci.txt
@@ -28,3 +28,24 @@ The following register is defined:
   - Allows any PSCI version implemented by KVM and compatible with
     v0.2 to be set with SET_ONE_REG
   - Affects the whole VM (even if the register view is per-vcpu)
+
+* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1:
+  Holds the state of the firmware controlled workaround to mitigate
+  CVE-2017-5715, as described under SMCCC_ARCH_WORKAROUND_1 in [1].
+  Accepted values are:
+    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_NOT_AVAIL: Workaround not available.
+    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_1_AVAIL: Workaround active for the guest.
+
+* KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2:
+  Holds the state of the firmware controlled workaround to mitigate
+  CVE-2018-3639, as described under SMCCC_ARCH_WORKAROUND_2 in [1].
+  Accepted values are:
+    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_NOT_AVAIL: Workaround not available.
+    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNKNOWN: Workaround state unknown.
+    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_AVAIL: Workaround available, and can
+      be disabled by a vCPU. If KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_ENABLED is
+      set, it is active for this vCPU.
+    KVM_REG_ARM_SMCCC_ARCH_WORKAROUND_2_UNAFFECTED: Workaround always active
+      or not needed.
+
+[1] https://developer.arm.com/-/media/developer/pdf/ARM_DEN_0070A_Firmware_interfaces_for_mitigating_CVE-2017-5715.pdf
-- 
2.17.1
