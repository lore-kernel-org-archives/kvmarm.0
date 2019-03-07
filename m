From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 16/16] arm/fdt: Remove PCI probe only property
Date: Thu,  7 Mar 2019 08:36:17 +0000
Message-ID: <1551947777-13044-17-git-send-email-julien.thierry@arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A2EE04A4D3
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id o25AGup9PPLR for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Mar 2019 03:36:47 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id CB5D54A4E5
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:47 -0500 (EST)
In-Reply-To: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Andre.Przywara@arm.com, Sami.Mujawar@arm.com, will.deacon@arm.com, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

PCI devices support BAR reassignment. Get rid of the no longer needed
linux property.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 arm/fdt.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arm/fdt.c b/arm/fdt.c
index 980015b..219248e 100644
--- a/arm/fdt.c
+++ b/arm/fdt.c
@@ -140,7 +140,6 @@ static int setup_fdt(struct kvm *kvm)
 
 	/* /chosen */
 	_FDT(fdt_begin_node(fdt, "chosen"));
-	_FDT(fdt_property_cell(fdt, "linux,pci-probe-only", 1));
 	_FDT(fdt_property_string(fdt, "bootargs", kvm->cfg.real_cmdline));
 	_FDT(fdt_property_u64(fdt, "kaslr-seed", kvm->cfg.arch.kaslr_seed));
 
-- 
1.9.1
