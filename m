From: Alexander Graf <agraf@suse.de>
Subject: [PATCH] KVM: arm/arm64: timer: Fix hw sync for user space irqchip path
Date: Fri, 16 Sep 2016 07:16:11 +0200
Message-ID: <1474002971-31434-1-git-send-email-agraf@suse.de>
Return-path: <kvm-owner@vger.kernel.org>
Sender: kvm-owner@vger.kernel.org
To: kvmarm@lists.cs.columbia.edu
Cc: linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

While adding the new vgic implementation, apparently nobody tested
the non-vgic path where user space controls the vgic, so two functions
slipped through the cracks that get called in generic code but don't
check whether hardware support is enabled.

This patch guards them with proper checks to ensure we only try to
use vgic data structures if they are available. Without this, I get
a stack trace:

[   74.363037] Unable to handle kernel paging request at virtual address ffffffffffffffe8
[...]
[   74.929654] [<ffff000008824bcc>] _raw_spin_lock+0x1c/0x58
[   74.935133] [<ffff0000080b7f20>] kvm_vgic_flush_hwstate+0x88/0x288
[   74.941406] [<ffff0000080ab0b4>] kvm_arch_vcpu_ioctl_run+0xfc/0x630
[   74.947766] [<ffff0000080a15bc>] kvm_vcpu_ioctl+0x2f4/0x710
[   74.953420] [<ffff0000082788a8>] do_vfs_ioctl+0xb0/0x728
[   74.958807] [<ffff000008278fb4>] SyS_ioctl+0x94/0xa8
[   74.963844] [<ffff000008083744>] el0_svc_naked+0x38/0x3c

Fixes: 0919e84c0
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Graf <agraf@suse.de>
---
 virt/kvm/arm/vgic/vgic.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index e83b7fe..9f312ba 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -645,6 +645,9 @@ next:
 /* Sync back the hardware VGIC state into our emulation after a guest's run. */
 void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 {
+	if (!vcpu->kvm->arch.vgic.enabled)
+		return;
+
 	vgic_process_maintenance_interrupt(vcpu);
 	vgic_fold_lr_state(vcpu);
 	vgic_prune_ap_list(vcpu);
@@ -653,6 +656,9 @@ void kvm_vgic_sync_hwstate(struct kvm_vcpu *vcpu)
 /* Flush our emulation state into the GIC hardware before entering the guest. */
 void kvm_vgic_flush_hwstate(struct kvm_vcpu *vcpu)
 {
+	if (!vcpu->kvm->arch.vgic.enabled)
+		return;
+
 	spin_lock(&vcpu->arch.vgic_cpu.ap_list_lock);
 	vgic_flush_lr_state(vcpu);
 	spin_unlock(&vcpu->arch.vgic_cpu.ap_list_lock);
-- 
2.6.6

