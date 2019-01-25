From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH kvmtool] arm: Allow command line for firmware
Date: Fri, 25 Jan 2019 15:43:08 +0000
Message-ID: <20190125154308.185131-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B53F04A3C6
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 10:43:33 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id kI46jbBMpQti for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jan 2019 10:43:28 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B05714A3BD
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 10:43:28 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Will Deacon <will.deacon@arm.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

When loading a firmware instead of a kernel, we can still pass on any
*user-provided* command line, as /chosen/bootargs is a generic device tree
feature. We just need to make sure to not pass our mangled-for-Linux
version.

This allows to run "firmware" images which make use of a command line,
still are not Linux kernels, like kvm-unit-tests.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Hi Will,

this goes on top of Julien's firmware series (which did not yet appear
on kernel.org?)
This fixes an issue with some kvm-unit-tests support. [1]

Cheers,
Andre.

[1] https://lists.cs.columbia.edu/pipermail/kvmarm/2019-January/034251.html

 arm/fdt.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/arm/fdt.c b/arm/fdt.c
index e3a7a647..a1f8e912 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -163,14 +163,11 @@ static int setup_fdt(struct kvm *kvm)
 	_FDT(fdt_begin_node(fdt, "chosen"));
 	_FDT(fdt_property_cell(fdt, "linux,pci-probe-only", 1));
 
+	/* Pass on our amended command line to a Linux kernel only. */
 	if (kvm->cfg.firmware_filename) {
-		/*
-		 * When using a firmware, command line is not passed through DT,
-		 * or the firmware can add it itself
-		 */
 		if (kvm->cfg.kernel_cmdline)
-			pr_warning("Ignoring custom bootargs: %s\n",
-				   kvm->cfg.kernel_cmdline);
+			_FDT(fdt_property_string(fdt, "bootargs",
+						 kvm->cfg.kernel_cmdline));
 	} else
 		_FDT(fdt_property_string(fdt, "bootargs",
 					 kvm->cfg.real_cmdline));
-- 
2.17.1
