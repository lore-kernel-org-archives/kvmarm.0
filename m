From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] KVM: arm/arm64: drop resource size check for GICV window
Date: Fri,  1 Jun 2018 17:06:28 +0200
Message-ID: <20180601150628.10111-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 0BAFD4A10E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jun 2018 10:55:59 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id B7GXLRbFoDGN for <kvmarm@lists.cs.columbia.edu>;
 Fri,  1 Jun 2018 10:55:36 -0400 (EDT)
Received: from mail-wm0-f66.google.com (mail-wm0-f66.google.com [74.125.82.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A80D44A0E8
 for <kvmarm@lists.cs.columbia.edu>; Fri,  1 Jun 2018 10:55:36 -0400 (EDT)
Received: by mail-wm0-f66.google.com with SMTP id v131-v6so3200773wma.1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 01 Jun 2018 08:06:39 -0700 (PDT)
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
Cc: marc.zyngier@arm.com, linux-arm-kernel@lists.infradead.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

When booting a 64 KB pages kernel on a ACPI GICv3 system that
implements support for v2 emulation, the following warning is
produced

  GICV size 0x2000 not a multiple of page size 0x10000

and support for v2 emulation is disabled, preventing GICv2 VMs
from being able to run on such hosts.

The reason is that vgic_v3_probe() performs a sanity check on the
size of the window (it should be a multiple of the page size),
while the ACPI MADT parsing code hardcodes the size of the window
to 8 KB. This makes sense, considering that ACPI does not bother
to describe the size in the first place, under the assumption that
platforms implementing ACPI will follow the architecture and not
put anything else in the same 64 KB window.

So let's just drop the sanity check altogether, and assume that
the window is at least 64 KB in size.

Fixes: 909777324588 ("KVM: arm/arm64: vgic-new: vgic_init: implement kvm_vgic_hyp_init")
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 virt/kvm/arm/vgic/vgic-v3.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index bdcf8e7a6161..72fc688c3e9d 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -552,11 +552,6 @@ int vgic_v3_probe(const struct gic_kvm_info *info)
 		pr_warn("GICV physical address 0x%llx not page aligned\n",
 			(unsigned long long)info->vcpu.start);
 		kvm_vgic_global_state.vcpu_base = 0;
-	} else if (!PAGE_ALIGNED(resource_size(&info->vcpu))) {
-		pr_warn("GICV size 0x%llx not a multiple of page size 0x%lx\n",
-			(unsigned long long)resource_size(&info->vcpu),
-			PAGE_SIZE);
-		kvm_vgic_global_state.vcpu_base = 0;
 	} else {
 		kvm_vgic_global_state.vcpu_base = info->vcpu.start;
 		kvm_vgic_global_state.can_emulate_gicv2 = true;
-- 
2.17.0
