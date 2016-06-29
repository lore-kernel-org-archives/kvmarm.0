From: Itaru Kitayama <itaru.kitayama@riken.jp>
Subject: [PATCH] KVM: arm64: Check GICV address is placed at a 4Kb boundary
Date: Wed, 29 Jun 2016 15:22:45 +0900
Message-ID: <cb18ab2d-12d9-bdd2-8432-801af488e340@riken.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 38E4149B4C
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2016 02:17:37 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7XgKz0pUAlKg for <kvmarm@lists.cs.columbia.edu>;
 Wed, 29 Jun 2016 02:17:35 -0400 (EDT)
Received: from postman.riken.jp (postman1.riken.jp [134.160.33.83])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 6CAF749B2E
 for <kvmarm@lists.cs.columbia.edu>; Wed, 29 Jun 2016 02:17:35 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Make sure GICV physical address is placed at a 4Kb boundary as spec 
says, not host kernel's page boundary. This prevents !4Kb kernels from 
returning an ENXIO prematurely during the KVM init phase at boot.
Tested on Overdrive 3000 with 64Kb page-size kernel with ACPI.

Signed-off-by: Itaru Kitayama <itaru.kitayama@riken.jp>
Cc: Marc Zyngier <marc.zyngier@arm.com>


diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index e31405e..0123e5d 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -309,17 +309,15 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
                 return -ENXIO;
         }

-       if (!PAGE_ALIGNED(info->vcpu.start)) {
-               kvm_err("GICV physical address 0x%llx not page aligned\n",
+       if (!IS_ALIGNED(info->vcpu.start, SZ_4K)) {
+               kvm_err("GICV physical address 0x%llx not 4Kb aligned\n",
                         (unsigned long long)info->vcpu.start);
                 return -ENXIO;
         }

-       if (!PAGE_ALIGNED(resource_size(&info->vcpu))) {
-               kvm_err("GICV size 0x%llx not a multiple of page size 
0x%lx\n",
-                       (unsigned long long)resource_size(&info->vcpu),
+       if (!PAGE_ALIGNED(resource_size(&info->vcpu)))
+               kvm_warn("GICV size 0x%llx not a multiple of page size 
0x%lx, system may be unsafe\n", (unsigned long 
long)resource_size(&info->vcpu),
                         PAGE_SIZE);
-               return -ENXIO;
         }

         kvm_vgic_global_state.vctrl_base = ioremap(info->vctrl.start,
