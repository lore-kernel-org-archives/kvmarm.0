From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH v3 1/8] arm64: KVM: Use static keys for selecting the GIC
 backend
Date: Fri, 9 Sep 2016 15:17:13 +0100
Message-ID: <57D2C469.1030006@arm.com>
References: <1473350810-10857-1-git-send-email-vladimir.murzin@arm.com>
 <1473350810-10857-2-git-send-email-vladimir.murzin@arm.com>
 <57D27EA7.2040500@arm.com> <57D281F1.5000902@arm.com>
 <57D2BCEB.3030306@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id C91354113E
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2016 10:08:45 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id eIQWK0I9n6Zo for <kvmarm@lists.cs.columbia.edu>;
 Fri,  9 Sep 2016 10:08:45 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D643F40F9B
 for <kvmarm@lists.cs.columbia.edu>; Fri,  9 Sep 2016 10:08:43 -0400 (EDT)
In-Reply-To: <57D2BCEB.3030306@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vladimir Murzin <vladimir.murzin@arm.com>, kvmarm@lists.cs.columbia.edu
Cc: andre.przywara@arm.com, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On 09/09/16 14:45, Vladimir Murzin wrote:
> On 09/09/16 10:33, Vladimir Murzin wrote:
>> Hi Marc,
>>
>> On 09/09/16 10:19, Marc Zyngier wrote:
>>>> Hi Vladimir,
>>>>
>> ...
>>>>>>  =

>>>>>> +extern struct static_key_false kvm_gicv3_cpuif;
>>>>
>>>> I think we should follow the model set by kvm_vgic_global_state, which
>>>> is declared in arm_vgic.h. Even better, we should *embed* the static k=
ey
>>>> in this structure. This will reduce the clutter and we wouldn't have to
>>>> deal with all the section stuff (the hyp_data thing is a good cleanup,
>>>> but I'd like to see it as a separate patch if possible).
>> Yes, it is what I was thinking about too, but was not sure about which
>> way to go, so hyp_data seemed me something we might reuse latter.
>> However, I agree that we can defer hyp_data thing...
>>
> =

> I've just tried it out and it seems that static keys are not happy to
> accept a key after kern_hyp_va is applied at &kvm_vgic_global_state:

Ah, there is a trick. You do not need kern_hyp_va at all, because this
is not evaluated as an expression at runtime (so the pointer doesn't matter=
).

>> In file included from ./include/linux/jump_label.h:105:0,
>>                  from arch/arm64/kvm/hyp/switch.c:19:
>> ./arch/arm64/include/asm/jump_label.h: In function =91__guest_run=92:
>> ./arch/arm64/include/asm/jump_label.h:31:2: warning: asm operand 0 proba=
bly doesn=92t match constraints
>>   asm goto("1: nop\n\t"
>>   ^
>> ./arch/arm64/include/asm/jump_label.h:31:2: warning: asm operand 0 proba=
bly doesn=92t match constraints
>>   asm goto("1: nop\n\t"
>>   ^
>> ./arch/arm64/include/asm/jump_label.h:31:2: error: impossible constraint=
 in =91asm=92
>>   asm goto("1: nop\n\t"
>>   ^
>> ./arch/arm64/include/asm/jump_label.h:31:2: error: impossible constraint=
 in =91asm=92
>>   asm goto("1: nop\n\t"
>>   ^
>> make[1]: *** [arch/arm64/kvm/hyp/switch.o] Error 1
>> make: *** [arch/arm64/kvm/hyp/switch.o] Error 2
> =

> it looks like we cannot avoid hyp_data thing... if you don't mind I can
> do hyp_data clean-up in separate patch. Alternatively, we can do
> conversion to static keys for both architectures later as an
> optimisation step.

Can you try the above first? I've just tried the same approach with my
vgic-trap series, and it compiles fine (untested though):

diff --git a/arch/arm64/kvm/hyp/switch.c b/arch/arm64/kvm/hyp/switch.c
index 194184c..397e240 100644
--- a/arch/arm64/kvm/hyp/switch.c
+++ b/arch/arm64/kvm/hyp/switch.c
@@ -301,7 +301,7 @@ again:
 	if (exit_code =3D=3D ARM_EXCEPTION_TRAP && !__populate_fault_info(vcpu))
 		goto again;
 =

-	if (static_branch_unlikely(&vgic_v2_cpuif_trap) &&
+	if (static_branch_unlikely(&kvm_vgic_global_state.vgic_v2_cpuif_trap) &&
 	    exit_code =3D=3D ARM_EXCEPTION_TRAP) {
 		bool valid;
 =

diff --git a/include/kvm/arm_vgic.h b/include/kvm/arm_vgic.h
index bb46c03..cc59a28 100644
--- a/include/kvm/arm_vgic.h
+++ b/include/kvm/arm_vgic.h
@@ -67,6 +67,9 @@ struct vgic_global {
 =

 	/* Only needed for the legacy KVM_CREATE_IRQCHIP */
 	bool			can_emulate_gicv2;
+
+	/* Trapping GICv2 GICV region? */
+	struct static_key_false	vgic_v2_cpuif_trap;
 };
 =

 extern struct vgic_global kvm_vgic_global_state;
@@ -269,8 +272,6 @@ struct vgic_cpu {
 	bool lpis_enabled;
 };
 =

-extern struct static_key_false vgic_v2_cpuif_trap;
-
 int kvm_vgic_addr(struct kvm *kvm, unsigned long type, u64 *addr, bool wri=
te);
 void kvm_vgic_early_init(struct kvm *kvm);
 int kvm_vgic_create(struct kvm *kvm, u32 type);
diff --git a/virt/kvm/arm/vgic/vgic-v2.c b/virt/kvm/arm/vgic/vgic-v2.c
index 0a063af..4af600e 100644
--- a/virt/kvm/arm/vgic/vgic-v2.c
+++ b/virt/kvm/arm/vgic/vgic-v2.c
@@ -278,7 +278,7 @@ int vgic_v2_map_resources(struct kvm *kvm)
 		goto out;
 	}
 =

-	if (!static_branch_unlikely(&vgic_v2_cpuif_trap)) {
+	if (!static_branch_unlikely(&kvm_vgic_global_state.vgic_v2_cpuif_trap)) {
 		ret =3D kvm_phys_addr_ioremap(kvm, dist->vgic_cpu_base,
 					    kvm_vgic_global_state.vcpu_base,
 					    KVM_VGIC_V2_CPU_SIZE, true);
@@ -296,8 +296,6 @@ out:
 	return ret;
 }
 =

-DEFINE_STATIC_KEY_FALSE(vgic_v2_cpuif_trap);
-
 /**
  * vgic_v2_probe - probe for a GICv2 compatible interrupt controller in DT
  * @node:	pointer to the DT node
@@ -314,6 +312,8 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 		return -ENXIO;
 	}
 =

+	kvm_vgic_global_state.vgic_v2_cpuif_trap =3D STATIC_KEY_FALSE_INIT;
+
 	if (!PAGE_ALIGNED(info->vcpu.start) ||
 	    !PAGE_ALIGNED(resource_size(&info->vcpu))) {
 		kvm_info("GICV region size/alignment is unsafe, using trapping (reduced =
performance)\n");
@@ -332,7 +332,7 @@ int vgic_v2_probe(const struct gic_kvm_info *info)
 			goto out;
 		}
 =

-		static_branch_enable(&vgic_v2_cpuif_trap);
+		static_branch_enable(&kvm_vgic_global_state.vgic_v2_cpuif_trap);
 	}
 =

 	kvm_vgic_global_state.vctrl_base =3D ioremap(info->vctrl.start,


Thanks,

	M.
-- =

Jazz is not dead. It just smells funny...
