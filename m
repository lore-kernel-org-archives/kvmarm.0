From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: [GIT PULL 5/5] arm/arm64: KVM: Keep elrsr/aisr in sync with software model
Date: Mon, 16 Mar 2015 13:55:03 +0100
Message-ID: <1426510503-27995-6-git-send-email-christoffer.dall@linaro.org>
References: <1426510503-27995-1-git-send-email-christoffer.dall@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <1426510503-27995-1-git-send-email-christoffer.dall@linaro.org>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
List-Id: kvmarm@lists.cs.columbia.edu

There is an interesting bug in the vgic code, which manifests itself
when the KVM run loop has a signal pending or needs a vmid generation
rollover after having disabled interrupts but before actually switching
to the guest.

In this case, we flush the vgic as usual, but we sync back the vgic
state and exit to userspace before entering the guest.  The consequence
is that we will be syncing the list registers back to the software mode=
l
using the GICH_ELRSR and GICH_EISR from the last execution of the guest=
,
potentially overwriting a list register containing an interrupt.

This showed up during migration testing where we would capture a state
where the VM has masked the arch timer but there were no interrupts,
resulting in a hung test.

Cc: Marc Zyngier <marc.zyngier@arm.com>
Reported-by: Alex Bennee <alex.bennee@linaro.org>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
Signed-off-by: Alex Benn=C3=A9e <alex.bennee@linaro.org>
Acked-by: Marc Zyngier <marc.zyngier@arm.com>
Signed-off-by: Christoffer Dall <christoffer.dall@linaro.org>
---
 include/kvm/arm_vgic.h |  1 +
 virt/kvm/arm/vgic-v2.c |  8 ++++++++
 virt/kvm/arm/vgic-v3.c |  8 ++++++++
 virt/kvm/arm/vgic.c    | 16 ++++++++++++++++
 4 files changed, 33 insertions(+)

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index 7c55dd5..66203b2 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -114,6 +114,7 @@ struct vgic_ops {
 	void	(*sync_lr_elrsr)(struct kvm_vcpu *, int, struct vgic_lr);
 	u64	(*get_elrsr)(const struct kvm_vcpu *vcpu);
 	u64	(*get_eisr)(const struct kvm_vcpu *vcpu);
+	void	(*clear_eisr)(struct kvm_vcpu *vcpu);
 	u32	(*get_interrupt_status)(const struct kvm_vcpu *vcpu);
 	void	(*enable_underflow)(struct kvm_vcpu *vcpu);
 	void	(*disable_underflow)(struct kvm_vcpu *vcpu);
diff --git a/virt/kvm/arm/vgic-v2.c b/virt/kvm/arm/vgic-v2.c
index a0a7b5d..f9b9c7c 100644
--- a/virt/kvm/arm/vgic-v2.c
+++ b/virt/kvm/arm/vgic-v2.c
@@ -72,6 +72,8 @@ static void vgic_v2_sync_lr_elrsr(struct kvm_vcpu *vc=
pu, int lr,
 {
 	if (!(lr_desc.state & LR_STATE_MASK))
 		vcpu->arch.vgic_cpu.vgic_v2.vgic_elrsr |=3D (1ULL << lr);
+	else
+		vcpu->arch.vgic_cpu.vgic_v2.vgic_elrsr &=3D ~(1ULL << lr);
 }
=20
 static u64 vgic_v2_get_elrsr(const struct kvm_vcpu *vcpu)
@@ -84,6 +86,11 @@ static u64 vgic_v2_get_eisr(const struct kvm_vcpu *v=
cpu)
 	return vcpu->arch.vgic_cpu.vgic_v2.vgic_eisr;
 }
=20
+static void vgic_v2_clear_eisr(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.vgic_cpu.vgic_v2.vgic_eisr =3D 0;
+}
+
 static u32 vgic_v2_get_interrupt_status(const struct kvm_vcpu *vcpu)
 {
 	u32 misr =3D vcpu->arch.vgic_cpu.vgic_v2.vgic_misr;
@@ -148,6 +155,7 @@ static const struct vgic_ops vgic_v2_ops =3D {
 	.sync_lr_elrsr		=3D vgic_v2_sync_lr_elrsr,
 	.get_elrsr		=3D vgic_v2_get_elrsr,
 	.get_eisr		=3D vgic_v2_get_eisr,
+	.clear_eisr		=3D vgic_v2_clear_eisr,
 	.get_interrupt_status	=3D vgic_v2_get_interrupt_status,
 	.enable_underflow	=3D vgic_v2_enable_underflow,
 	.disable_underflow	=3D vgic_v2_disable_underflow,
diff --git a/virt/kvm/arm/vgic-v3.c b/virt/kvm/arm/vgic-v3.c
index 3a62d8a..dff0602 100644
--- a/virt/kvm/arm/vgic-v3.c
+++ b/virt/kvm/arm/vgic-v3.c
@@ -104,6 +104,8 @@ static void vgic_v3_sync_lr_elrsr(struct kvm_vcpu *=
vcpu, int lr,
 {
 	if (!(lr_desc.state & LR_STATE_MASK))
 		vcpu->arch.vgic_cpu.vgic_v3.vgic_elrsr |=3D (1U << lr);
+	else
+		vcpu->arch.vgic_cpu.vgic_v3.vgic_elrsr &=3D ~(1U << lr);
 }
=20
 static u64 vgic_v3_get_elrsr(const struct kvm_vcpu *vcpu)
@@ -116,6 +118,11 @@ static u64 vgic_v3_get_eisr(const struct kvm_vcpu =
*vcpu)
 	return vcpu->arch.vgic_cpu.vgic_v3.vgic_eisr;
 }
=20
+static void vgic_v3_clear_eisr(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.vgic_cpu.vgic_v3.vgic_eisr =3D 0;
+}
+
 static u32 vgic_v3_get_interrupt_status(const struct kvm_vcpu *vcpu)
 {
 	u32 misr =3D vcpu->arch.vgic_cpu.vgic_v3.vgic_misr;
@@ -192,6 +199,7 @@ static const struct vgic_ops vgic_v3_ops =3D {
 	.sync_lr_elrsr		=3D vgic_v3_sync_lr_elrsr,
 	.get_elrsr		=3D vgic_v3_get_elrsr,
 	.get_eisr		=3D vgic_v3_get_eisr,
+	.clear_eisr		=3D vgic_v3_clear_eisr,
 	.get_interrupt_status	=3D vgic_v3_get_interrupt_status,
 	.enable_underflow	=3D vgic_v3_enable_underflow,
 	.disable_underflow	=3D vgic_v3_disable_underflow,
diff --git a/virt/kvm/arm/vgic.c b/virt/kvm/arm/vgic.c
index 4b2c2e7..c9f60f5 100644
--- a/virt/kvm/arm/vgic.c
+++ b/virt/kvm/arm/vgic.c
@@ -883,6 +883,11 @@ static inline u64 vgic_get_eisr(struct kvm_vcpu *v=
cpu)
 	return vgic_ops->get_eisr(vcpu);
 }
=20
+static inline void vgic_clear_eisr(struct kvm_vcpu *vcpu)
+{
+	vgic_ops->clear_eisr(vcpu);
+}
+
 static inline u32 vgic_get_interrupt_status(struct kvm_vcpu *vcpu)
 {
 	return vgic_ops->get_interrupt_status(vcpu);
@@ -922,6 +927,7 @@ static void vgic_retire_lr(int lr_nr, int irq, stru=
ct kvm_vcpu *vcpu)
 	vgic_set_lr(vcpu, lr_nr, vlr);
 	clear_bit(lr_nr, vgic_cpu->lr_used);
 	vgic_cpu->vgic_irq_lr_map[irq] =3D LR_EMPTY;
+	vgic_sync_lr_elrsr(vcpu, lr_nr, vlr);
 }
=20
 /*
@@ -978,6 +984,7 @@ bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_s=
ource_id, int irq)
 			BUG_ON(!test_bit(lr, vgic_cpu->lr_used));
 			vlr.state |=3D LR_STATE_PENDING;
 			vgic_set_lr(vcpu, lr, vlr);
+			vgic_sync_lr_elrsr(vcpu, lr, vlr);
 			return true;
 		}
 	}
@@ -999,6 +1006,7 @@ bool vgic_queue_irq(struct kvm_vcpu *vcpu, u8 sgi_=
source_id, int irq)
 		vlr.state |=3D LR_EOI_INT;
=20
 	vgic_set_lr(vcpu, lr, vlr);
+	vgic_sync_lr_elrsr(vcpu, lr, vlr);
=20
 	return true;
 }
@@ -1136,6 +1144,14 @@ static bool vgic_process_maintenance(struct kvm_=
vcpu *vcpu)
 	if (status & INT_STATUS_UNDERFLOW)
 		vgic_disable_underflow(vcpu);
=20
+	/*
+	 * In the next iterations of the vcpu loop, if we sync the vgic state
+	 * after flushing it, but before entering the guest (this happens for
+	 * pending signals and vmid rollovers), then make sure we don't pick
+	 * up any old maintenance interrupts here.
+	 */
+	vgic_clear_eisr(vcpu);
+
 	return level_pending;
 }
=20
--=20
2.1.2.330.g565301e.dirty

