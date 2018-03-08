From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 1/2] KVM: arm/arm64: vgic: Don't populate multiple LRs
 with the same vintid
Date: Thu, 8 Mar 2018 13:40:09 +0000
Message-ID: <b353bdde-36c8-78e9-70f1-df3f29be1edf@arm.com>
References: <20180307124055.13800-1-marc.zyngier@arm.com>
 <20180307124055.13800-2-marc.zyngier@arm.com>
 <CAEDV+gJoamQJX_hcwCNBo1gc7-NUT+m-N9n=00wCJ=_TD82EkQ@mail.gmail.com>
 <8e873168-110f-6781-506c-4ca89b7a4e0d@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <8e873168-110f-6781-506c-4ca89b7a4e0d@arm.com>
Content-Language: en-GB
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Christoffer Dall <cdall@kernel.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Andre Przywara <Andre.Przywara@arm.com>, kvmarm@lists.cs.columbia.edu, KVM General <kvm@vger.kernel.org>, Eric Auger <eric.auger@redhat.com>
List-Id: kvmarm@lists.cs.columbia.edu

On 08/03/18 10:19, Marc Zyngier wrote:
> On 07/03/18 23:34, Christoffer Dall wrote:
>> On Wed, Mar 7, 2018 at 12:40 PM, Marc Zyngier <marc.zyngier@arm.com> wrote:
>>> The vgic code is trying to be clever when injecting GICv2 SGIs,
>>> and will happily populate LRs with the same interrupt number if
>>> they come from multiple vcpus (after all, they are distinct
>>> interrupt sources).
>>>
>>> Unfortunately, this is against the letter of the architecture,
>>> and the GICv2 architecture spec says "Each valid interrupt stored
>>> in the List registers must have a unique VirtualID for that
>>> virtual CPU interface.". GICv3 has similar (although slightly
>>> ambiguous) restrictions.
>>>
>>> This results in guests locking up when using GICv2-on-GICv3, for
>>> example. The obvious fix is to stop trying so hard, and inject
>>> a single vcpu per SGI per guest entry. After all, pending SGIs
>>> with multiple source vcpus are pretty rare, and are mostly seen
>>> in scenario where the physical CPUs are severely overcomitted.
>>>
>>> Cc: stable@vger.kernel.org
>>> Fixes: 0919e84c0fc1 ("KVM: arm/arm64: vgic-new: Add IRQ sync/flush framework")
>>> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
>>> ---
>>>  virt/kvm/arm/vgic/vgic.c | 11 +----------
>>>  1 file changed, 1 insertion(+), 10 deletions(-)
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
>>> index c7c5ef190afa..1f7ff175f47b 100644
>>> --- a/virt/kvm/arm/vgic/vgic.c
>>> +++ b/virt/kvm/arm/vgic/vgic.c
>>> @@ -720,18 +720,9 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
>>>         list_for_each_entry(irq, &vgic_cpu->ap_list_head, ap_list) {
>>>                 spin_lock(&irq->irq_lock);
>>>
>>> -               if (unlikely(vgic_target_oracle(irq) != vcpu))
>>> -                       goto next;
>>> -
>>> -               /*
>>> -                * If we get an SGI with multiple sources, try to get
>>> -                * them in all at once.
>>> -                */
>>> -               do {
>>> +               if (likely(vgic_target_oracle(irq) == vcpu))
>>>                         vgic_populate_lr(vcpu, irq, count++);
>>
>> I think we need to change vgic_populate_lr to set the EOI maintenance
>> interrupt flag so that when the interrupt is deactivated, if there are
>> additional pending sources, we exit the guest and pick up the
>> interrupt.
> 
> Potentially. We need to be careful about about the semantics of EOI MI
> with non-level interrupts (see the other thread about EOI signalling).
> 
>> An alternative would be to set the underflow interrupt, but I don't
>> think that would be correct for multiple priorities, because the SGI
>> could have a higher priority than other pending interrupts we put in
>> the LR.
> 
> I don't think priorities are the issue (after all, we already sort the
> irqs in order of priority). My worry is that underflow is allowed to
> fire if there is one interrupt pending, which implies that you could
> end-up in a livelock scenario if you only have one SGI pending with
> multiple sources.
> 
> Another possibility would be to use ICH_HCR_EL2.NPIE (GICH_HCR.NPIE on
> GICv2), which delivers a a MI if no pending interrupts are present. Once
> the SGI has been activated, we're guaranteed to be able to inject a new
> pending one.
> 
> I like the latter, because it doesn't overload the rest of the code with
> new semantics. Thoughts?
To illustrate what I mean, here's a quickly hacked patch that implements
this idea:

diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index c00c4c33e432..b26eccc78fb1 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -503,6 +503,7 @@
 
 #define ICH_HCR_EN			(1 << 0)
 #define ICH_HCR_UIE			(1 << 1)
+#define ICH_HCR_NPIE			(1 << 3)
 #define ICH_HCR_TC			(1 << 10)
 #define ICH_HCR_TALL0			(1 << 11)
 #define ICH_HCR_TALL1			(1 << 12)
diff --git a/include/linux/irqchip/arm-gic.h b/include/linux/irqchip/arm-gic.h
index d3453ee072fc..68d8b1f73682 100644
--- a/include/linux/irqchip/arm-gic.h
+++ b/include/linux/irqchip/arm-gic.h
@@ -84,6 +84,7 @@
 
 #define GICH_HCR_EN			(1 << 0)
 #define GICH_HCR_UIE			(1 << 1)
+#define GICH_HCR_NPIE			(1 << 3)
 
 #define GICH_LR_VIRTUALID		(0x3ff << 0)
 #define GICH_LR_PHYSID_CPUID_SHIFT	(10)
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 0be616e4ee29..9a22b74f1550 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -37,6 +37,13 @@ void vgic_v2_init_lrs(void)
 		vgic_v2_write_lr(i, 0);
 }
 
+void vgic_v2_set_npie(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
+
+	cpuif->vgic_hcr |= GICH_HCR_NPIE;
+}
+
 void vgic_v2_set_underflow(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v2_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v2;
@@ -63,7 +70,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu)
 	int lr;
 	unsigned long flags;
 
-	cpuif->vgic_hcr &= ~GICH_HCR_UIE;
+	cpuif->vgic_hcr &= ~(GICH_HCR_UIE | GICH_HCR_NPIE);
 
 	for (lr = 0; lr < vgic_cpu->used_lrs; lr++) {
 		u32 val = cpuif->vgic_lr[lr];
diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
index c68352b8ed28..749da7624fba 100644
--- a/virt/kvm/arm/vgic/vgic-v3.c
+++ b/virt/kvm/arm/vgic/vgic-v3.c
@@ -26,6 +26,13 @@ static bool group1_trap;
 static bool common_trap;
 static bool gicv4_enable;
 
+void vgic_v3_set_npie(struct kvm_vcpu *vcpu)
+{
+	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
+
+	cpuif->vgic_hcr |= ICH_HCR_NPIE;
+}
+
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu)
 {
 	struct vgic_v3_cpu_if *cpuif = &vcpu->arch.vgic_cpu.vgic_v3;
@@ -46,7 +53,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu)
 	int lr;
 	unsigned long flags;
 
-	cpuif->vgic_hcr &= ~ICH_HCR_UIE;
+	cpuif->vgic_hcr &= ~(ICH_HCR_UIE | ICH_HCR_NPIE);
 
 	for (lr = 0; lr < vgic_cpu->used_lrs; lr++) {
 		u64 val = cpuif->vgic_lr[lr];
diff --git a/virt/kvm/arm/vgic/vgic.c b/virt/kvm/arm/vgic/vgic.c
index 07126a3b1908..2cd458fa8c12 100644
--- a/virt/kvm/arm/vgic/vgic.c
+++ b/virt/kvm/arm/vgic/vgic.c
@@ -710,6 +710,14 @@ static inline void vgic_set_underflow(struct kvm_vcpu *vcpu)
 		vgic_v3_set_underflow(vcpu);
 }
 
+static inline void vgic_set_npie(struct kvm_vcpu *vcpu)
+{
+	if (kvm_vgic_global_state.type == VGIC_V2)
+		vgic_v2_set_npie(vcpu);
+	else
+		vgic_v3_set_npie(vcpu);
+}
+
 /* Requires the ap_list_lock to be held. */
 static int compute_ap_list_depth(struct kvm_vcpu *vcpu)
 {
@@ -737,6 +745,7 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 	struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
 	struct vgic_irq *irq;
 	int count = 0;
+	bool npie = false;
 
 	DEBUG_SPINLOCK_BUG_ON(!spin_is_locked(&vgic_cpu->ap_list_lock));
 
@@ -749,6 +758,9 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 		if (likely(vgic_target_oracle(irq) == vcpu))
 			vgic_populate_lr(vcpu, irq, count++);
 
+		if (irq->source)
+			npie = true;
+
 		spin_unlock(&irq->irq_lock);
 
 		if (count == kvm_vgic_global_state.nr_lr) {
@@ -759,6 +771,9 @@ static void vgic_flush_lr_state(struct kvm_vcpu *vcpu)
 		}
 	}
 
+	if (npie)
+		vgic_set_npie(vcpu);
+
 	vcpu->arch.vgic_cpu.used_lrs = count;
 
 	/* Nuke remaining LRs */
diff --git a/virt/kvm/arm/vgic/vgic.h b/virt/kvm/arm/vgic/vgic.h
index 5b11859a1a1e..f5b8519e5546 100644
--- a/virt/kvm/arm/vgic/vgic.h
+++ b/virt/kvm/arm/vgic/vgic.h
@@ -160,6 +160,7 @@ void vgic_v2_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v2_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v2_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v2_set_underflow(struct kvm_vcpu *vcpu);
+void vgic_v2_set_npie(struct kvm_vcpu *vcpu);
 int vgic_v2_has_attr_regs(struct kvm_device *dev, struct kvm_device_attr *attr);
 int vgic_v2_dist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
 			 int offset, u32 *val);
@@ -189,6 +190,7 @@ void vgic_v3_fold_lr_state(struct kvm_vcpu *vcpu);
 void vgic_v3_populate_lr(struct kvm_vcpu *vcpu, struct vgic_irq *irq, int lr);
 void vgic_v3_clear_lr(struct kvm_vcpu *vcpu, int lr);
 void vgic_v3_set_underflow(struct kvm_vcpu *vcpu);
+void vgic_v3_set_npie(struct kvm_vcpu *vcpu);
 void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr);
 void vgic_v3_enable(struct kvm_vcpu *vcpu);

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
