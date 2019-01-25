From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH kvmtool 2/6] arm: fdt: add stdout-path to /chosen node
Date: Fri, 25 Jan 2019 18:07:57 +0000
Message-ID: <20190125180801.209910-3-andre.przywara@arm.com>
References: <20190125180801.209910-1-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1DA284A3DC
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 13:08:11 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id cLJmggjt7Crf for <kvmarm@lists.cs.columbia.edu>;
 Fri, 25 Jan 2019 13:08:10 -0500 (EST)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2E3AB4A3A2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 25 Jan 2019 13:08:10 -0500 (EST)
In-Reply-To: <20190125180801.209910-1-andre.przywara@arm.com>
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

The DT spec describes the stdout-path property in the /chosen node to
contain the DT path for a default device usable for outputting characters.
The Linux kernel uses this for earlycon (without further parameters),
other DT users might rely on this as well.

Add a property containing the path to our emulated 8250 serial device.

Even when we use the virtio console, the serial console is still there
and works, so we can expose this unconditionally. Putting the virtio
console path in there will not work anyway.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
 arm/fdt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arm/fdt.c b/arm/fdt.c
index 28ba1c2c..8cda3ded 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -143,6 +143,7 @@ static int setup_fdt(struct kvm *kvm)
 	_FDT(fdt_property_cell(fdt, "linux,pci-probe-only", 1));
 	_FDT(fdt_property_string(fdt, "bootargs", kvm->cfg.real_cmdline));
 	_FDT(fdt_property_u64(fdt, "kaslr-seed", kvm->cfg.arch.kaslr_seed));
+	_FDT(fdt_property_string(fdt, "stdout-path", "/U6_16550A@3f8"));
 
 	/* Initrd */
 	if (kvm->arch.initrd_size != 0) {
-- 
2.17.1
