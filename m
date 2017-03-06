From: Marc Zyngier <marc.zyngier@arm.com>
Subject: [PATCH v3 25/25] arm/arm64: Add hyp-stub API documentation
Date: Mon,  6 Mar 2017 14:24:58 +0000
Message-ID: <20170306142458.8875-26-marc.zyngier@arm.com>
References: <20170306142458.8875-1-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B437A40B58
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:25:42 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id L8dzCJNvygmN for <kvmarm@lists.cs.columbia.edu>;
 Mon,  6 Mar 2017 09:25:41 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7838A40B3E
 for <kvmarm@lists.cs.columbia.edu>; Mon,  6 Mar 2017 09:25:40 -0500 (EST)
In-Reply-To: <20170306142458.8875-1-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Russell King <linux@arm.linux.org.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Catalin Marinas <catalin.marinas@arm.com>, cdall@linaro.org, james.morse@arm.com
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

In order to help people understanding the hyp-stub API that exists
between the host kernel and the hypervisor mode (whether a hypervisor
has been installed or not), let's document said API.

As as with any form of documentation, I expect it to become obsolete
and completely misleading within 20 minutes after having being merged.

Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
---
 Documentation/virtual/kvm/arm/hyp-abi.txt | 45 +++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)
 create mode 100644 Documentation/virtual/kvm/arm/hyp-abi.txt

diff --git a/Documentation/virtual/kvm/arm/hyp-abi.txt b/Documentation/virtual/kvm/arm/hyp-abi.txt
new file mode 100644
index 000000000000..a1e0314d2249
--- /dev/null
+++ b/Documentation/virtual/kvm/arm/hyp-abi.txt
@@ -0,0 +1,45 @@
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
+  of the architecture. Only implemented by the initial stubs.
+
+* r0/x0 = HVC_RESET_VECTORS
+
+  Turn HYP/EL2 MMU off, and reset HVBAR/VBAR_EL2 to the default
+  value. This effectively disables an existing hypervisor.
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
-- 
2.11.0
