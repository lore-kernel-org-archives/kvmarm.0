From: Julien Thierry <julien.thierry@arm.com>
Subject: [PATCH kvmtool 08/16] arm/pci: Do not use first PCI IO space bytes
 for devices
Date: Thu,  7 Mar 2019 08:36:09 +0000
Message-ID: <1551947777-13044-9-git-send-email-julien.thierry@arm.com>
References: <1551947777-13044-1-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 108CC4A4CE
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:38 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id atihJ7mpn033 for <kvmarm@lists.cs.columbia.edu>;
 Thu,  7 Mar 2019 03:36:37 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A2364A4D2
 for <kvmarm@lists.cs.columbia.edu>; Thu,  7 Mar 2019 03:36:36 -0500 (EST)
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

Linux has this convention that the lower 0x1000 bytes of the IO space
should not be used. (cf PCIBIOS_MIN_IO).

Just allocate those bytes to prevent future allocation assigning it to
devices.

Signed-off-by: Julien Thierry <julien.thierry@arm.com>
---
 arm/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arm/pci.c b/arm/pci.c
index 83238ca..559e0cf 100644
--- a/arm/pci.c
+++ b/arm/pci.c
@@ -37,6 +37,9 @@ void pci__arm_init(struct kvm *kvm)
 
 	/* Make PCI port allocation start at a properly aligned address */
 	pci_get_io_space_block(align_pad);
+
+	/* Convention, don't allocate first 0x1000 bytes of PCI IO */
+	pci_get_io_space_block(0x1000);
 }
 
 void pci__generate_fdt_nodes(void *fdt)
-- 
1.9.1
