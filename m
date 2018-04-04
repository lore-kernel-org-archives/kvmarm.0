From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH] kvm: arm: remove BUG(preemptible()) check
Date: Wed, 4 Apr 2018 15:50:52 +0200
Message-ID: <20180404135052.jsduo4s4pxoelnn6@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, tglx@linutronix.de, Christoffer Dall <christoffer.dall@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

native KVM crashes on -RT:
|------------[ cut here ]------------
|kernel BUG virt/kvm/arm/arm.c:82!
|Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
|Modules linked in:
|CPU: 3 PID: 1527 Comm: qemu-system-aar Tainted: G        W       4.14.29-rt25+ #48
|Hardware name: Freescale Layerscape 2088A RDB Board (DT)
|PC is at kvm_arm_get_running_vcpu+0x48/0x50
|LR is at vgic_mmio_change_active.isra.1+0x2c/0xe0
|Process qemu-system-aar (pid: 1527, stack limit = 0xffff0000128c8000)
|Call trace:
| kvm_arm_get_running_vcpu+0x48/0x50
| vgic_mmio_change_active.isra.1+0x2c/0xe0
| __vgic_mmio_write_cactive+0x7c/0xd0
| vgic_mmio_uaccess_write_cactive+0xc/0x18
| vgic_uaccess+0xac/0xd8
| vgic_v2_dist_uaccess+0x3c/0x48
| vgic_v2_attr_regs_access.isra.3+0x144/0x158
| vgic_v2_set_attr+0xbc/0xe0
| kvm_device_ioctl_attr+0x80/0xb0
| kvm_device_ioctl+0x60/0xa8
| do_vfs_ioctl+0xa4/0xa18
| SyS_ioctl+0x44/0x80

vgic_mmio_change_active() holds &irq->irq_lock spin lock which makes
context not-preemptible. On -RT the same lock is a sleeping lock and
thus it remains preemptible but can not be migrated to another CPU.

I *think* that the BUG() statement in kvm_arm_get_running_vcpu() is to
ensure that we don't switch CPUs while accessing per-CPU variables.
__this_cpu_write() + __this_cpu_read() will trigger a warning (with
CONFIG_DEBUG_PREEMPT enabled) to spot such usage without crashing the
whole machine. Therefore I suggest to remove this check.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 virt/kvm/arm/arm.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/virt/kvm/arm/arm.c b/virt/kvm/arm/arm.c
index 3db4af5d0197..60a3f23927d9 100644
--- a/virt/kvm/arm/arm.c
+++ b/virt/kvm/arm/arm.c
@@ -69,7 +69,6 @@ static DEFINE_PER_CPU(unsigned char, kvm_arm_hardware_enabled);
 
 static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
 {
-	BUG_ON(preemptible());
 	__this_cpu_write(kvm_arm_running_vcpu, vcpu);
 }
 
@@ -79,7 +78,6 @@ static void kvm_arm_set_running_vcpu(struct kvm_vcpu *vcpu)
  */
 struct kvm_vcpu *kvm_arm_get_running_vcpu(void)
 {
-	BUG_ON(preemptible());
 	return __this_cpu_read(kvm_arm_running_vcpu);
 }
 
-- 
2.16.3
