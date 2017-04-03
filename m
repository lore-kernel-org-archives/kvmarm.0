From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v5 34/34] arm/arm64: Add hyp-stub API documentation
Date: Mon,  3 Apr 2017 19:38:07 +0100
Message-ID: <20170403183807.1620-35-marc.zyngier@arm.com>
References: <20170403183807.1620-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7C94B40C1C
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:37:26 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kVmU184Nmj-0 for <kvmarm@lists.cs.columbia.edu>;
 Mon,  3 Apr 2017 14:37:25 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 862E840625
 for <kvmarm@lists.cs.columbia.edu>; Mon,  3 Apr 2017 14:37:24 -0400 (EDT)
In-Reply-To: <20170403183807.1620-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, Keerthy <j-keerthy@ti.com>
List-Id: kvmarm@lists.cs.columbia.edu

In order to help people understanding the hyp-stub API that exists
between the host kernel and the hypervisor mode (whether a hypervisor
has been installed or not), let's document said API.

As with any form of documentation, I expect it to become obsolete
and completely misleading within 20 minutes after having being merged.

Acked-by: Russell King <rmk+kernel@armlinux.org.uk>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/arm/hyp-abi.txt | 53 +++++++++++++++++++++++++++++++
 1 file changed, 53 insertions(+)
 create mode 100644 Documentation/virtual/kvm/arm/hyp-abi.txt

diff --git a/Documentation/virtual/kvm/arm/hyp-abi.txt b/Documentation/virtual/kvm/arm/hyp-abi.txt
new file mode 100644
index 000000000000..a20a0bee268d
--- /dev/null
+++ b/Documentation/virtual/kvm/arm/hyp-abi.txt
@@ -0,0 +1,53 @@
+* Internal ABI between the kernel and HYP
+
+This file documents the interaction between the Linux kernel and the
+hypervisor layer when running Linux as a hypervisor (for example
+KVM). It doesn't cover the interaction of the kernel with the
+hypervisor when running as a guest (under Xen, KVM or any other
+hypervisor), or any hypervisor-specific interaction when the kernel is
+used as a host.
+
+On arm and arm64 (without VHE), the kernel doesn't run in hypervisor
+mode, but still needs to interact with it, allowing a built-in
+hypervisor to be either installed or torn down.
+
+In order to achieve this, the kernel must be booted at HYP (arm) or
+EL2 (arm64), allowing it to install a set of stubs before dropping to
+SVC/EL1. These stubs are accessible by using a 'hvc #0' instruction,
+and only act on individual CPUs.
+
+Unless specified otherwise, any built-in hypervisor must implement
+these functions (see arch/arm{,64}/include/asm/virt.h):
+
+* r0/x0 = HVC_SET_VECTORS
+  r1/x1 = vectors
+
+  Set HVBAR/VBAR_EL2 to 'vectors' to enable a hypervisor. 'vectors'
+  must be a physical address, and respect the alignment requirements
+  of the architecture. Only implemented by the initial stubs, not by
+  Linux hypervisors.
+
+* r0/x0 = HVC_RESET_VECTORS
+
+  Turn HYP/EL2 MMU off, and reset HVBAR/VBAR_EL2 to the initials
+  stubs' exception vector value. This effectively disables an existing
+  hypervisor.
+
+* r0/x0 = HVC_SOFT_RESTART
+  r1/x1 = restart address
+  x2 = x0's value when entering the next payload (arm64)
+  x3 = x1's value when entering the next payload (arm64)
+  x4 = x2's value when entering the next payload (arm64)
+
+  Mask all exceptions, disable the MMU, move the arguments into place
+  (arm64 only), and jump to the restart address while at HYP/EL2. This
+  hypercall is not expected to return to its caller.
+
+Any other value of r0/x0 triggers a hypervisor-specific handling,
+which is not documented here.
+
+The return value of a stub hypercall is held by r0/x0, and is 0 on
+success, and HVC_STUB_ERR on error. A stub hypercall is allowed to
+clobber any of the caller-saved registers (x0-x18 on arm64, r0-r3 and
+ip on arm). It is thus recommended to use a function call to perform
+the hypercall.
-- 
2.11.0
