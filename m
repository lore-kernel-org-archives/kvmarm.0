From: Andre Przywara <andre.przywara@arm.com>
Subject: [PATCH v3 06/16] KVM: arm/arm64: make GIC frame address
 initialization model specific
Date: Wed,  7 Oct 2015 15:55:16 +0100
Message-ID: <1444229726-31559-7-git-send-email-andre.przywara@arm.com>
References: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8AAF74113E
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Oct 2015 10:52:50 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id pKlDDr-3Kugv for <kvmarm@lists.cs.columbia.edu>;
 Wed,  7 Oct 2015 10:52:49 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 17F5A46FCD
 for <kvmarm@lists.cs.columbia.edu>; Wed,  7 Oct 2015 10:52:46 -0400 (EDT)
In-Reply-To: <1444229726-31559-1-git-send-email-andre.przywara@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: marc.zyngier@arm.com, christoffer.dall@linaro.org
Cc: kvm@vger.kernel.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Currently we initialize all the possible GIC frame addresses in one
function, without looking at the specific GIC model we instantiate
for the guest.
As this gets confusing when adding another VGIC model later, lets
move these initializations into the respective model's emulation
init functions.

Signed-off-by: Andre Przywara <andre.przywara@arm.com>
---
Changelog v2..v3:
- none

 virt/kvm/arm/vgic-v2-emul.c | 3 +++
 virt/kvm/arm/vgic-v3-emul.c | 3 +++
 virt/kvm/arm/vgic.c         | 3 ---
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/virt/kvm/arm/vgic-v2-emul.c b/virt/kvm/arm/vgic-v2-emul.c
index 1390797..8faa28c 100644
--- a/virt/kvm/arm/vgic-v2-emul.c
+++ b/virt/kvm/arm/vgic-v2-emul.c
@@ -567,6 +567,9 @@ void vgic_v2_init_emulation(struct kvm *kvm)
 	dist->vm_ops.init_model = vgic_v2_init_model;
 	dist->vm_ops.map_resources = vgic_v2_map_resources;
 
+	dist->vgic_cpu_base = VGIC_ADDR_UNDEF;
+	dist->vgic_dist_base = VGIC_ADDR_UNDEF;
+
 	kvm->arch.max_vcpus = VGIC_V2_MAX_CPUS;
 }
 
diff --git a/virt/kvm/arm/vgic-v3-emul.c b/virt/kvm/arm/vgic-v3-emul.c
index d2eeb20..1f42348 100644
--- a/virt/kvm/arm/vgic-v3-emul.c
+++ b/virt/kvm/arm/vgic-v3-emul.c
@@ -885,6 +885,9 @@ void vgic_v3_init_emulation(struct kvm *kvm)
 	dist->vm_ops.destroy_model = vgic_v3_destroy_model;
 	dist->vm_ops.map_resources = vgic_v3_map_resources;
 
+	dist->vgic_dist_base = VGIC_ADDR_UNDEF;
+	dist->vgic_redist_base = VGIC_ADDR_UNDEF;
+
 	kvm->arch.max_vcpus = KVM_MAX_VCPUS;
 }
 
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index b71f627..1dd79e1 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -2160,9 +2160,6 @@ int kvm_vgic_create(struct kvm *kvm, u32 type)
 	kvm->arch.vgic.in_kernel = true;
 	kvm->arch.vgic.vgic_model = type;
 	kvm->arch.vgic.vctrl_base = vgic->vctrl_base;
-	kvm->arch.vgic.vgic_dist_base = VGIC_ADDR_UNDEF;
-	kvm->arch.vgic.vgic_cpu_base = VGIC_ADDR_UNDEF;
-	kvm->arch.vgic.vgic_redist_base = VGIC_ADDR_UNDEF;
 
 out_unlock:
 	for (; vcpu_lock_idx >= 0; vcpu_lock_idx--) {
-- 
2.5.1
