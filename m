From: Christoffer Dall <christoffer.dall@arm.com>
Subject: Re: [PATCH] kvm: arm/arm64 : fix vm's hanging at startup time
Date: Fri, 23 Nov 2018 11:03:02 +0100
Message-ID: <20181123100302.GB3331@e113682-lin.lund.arm.com>
References: <20181121110620.GC18678@e113682-lin.lund.arm.com>
 <201811231401560886603@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <201811231401560886603@zte.com.cn>
Sender: linux-kernel-owner@vger.kernel.org
To: peng.hao2@zte.com.cn
Cc: marc.zyngier@arm.com, andre.przywara@arm.com, linux-kernel@vger.kernel.org, leif.lindholm@linaro.org, ard.bieshseuvel@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Nov 23, 2018 at 02:01:56PM +0800, peng.hao2@zte.com.cn wrote:
> >Hi,
> >
> >On Wed, Nov 21, 2018 at 04:56:54PM +0800, peng.hao2@zte.com.cn wrote:
> >> >On 19/11/2018 09:10, Mark Rutland wrote:
> >> >> On Sat, Nov 17, 2018 at 10:58:37AM +0800, peng.hao2@zte.com.cn wrote:
> >> >>>> On 16/11/18 00:23, peng.hao2@zte.com.cn wrote:
> >> >>>>>> Hi,
> >> >>>>>>> When virtual machine starts, hang up.
> >> >>>>>>
> >> >>>>>> I take it you mean the *guest* hangs? Because it doesn't get a timer
> >> >>>>>> interrupt?
> >> >>>>>>
> >> >>>>>>> The kernel version of guest
> >> >>>>>>> is 4.16. Host support vgic_v3.
> >> >>>>>>
> >> >>>>>> Your host kernel is something recent, I guess?
> >> >>>>>>
> >> >>>>>>> It was mainly due to the incorrect vgic_irq's(intid=27) group value
> >> >>>>>>> during injection interruption. when kvm_vgic_vcpu_init is called,
> >> >>>>>>> dist is not initialized at this time. Unable to get vgic V3 or V2
> >> >>>>>>> correctly, so group is not set.
> >> >>>>>>
> >> >>>>>> Mmh, that shouldn't happen with (v)GICv3. Do you use QEMU (which
> >> >>>>>> version?) or some other userland tool?
> >> >>>>>>
> >> >>>>>
> >> >>>>> QEMU emulator version 3.0.50 .
> >> >>>>>
> >> >>>>>>> group is setted to 1 when vgic_mmio_write_group is invoked at some
> >> >>>>>>> time.
> >> >>>>>>> when irq->group=0 (intid=27), No ICH_LR_GROUP flag was set and
> >> >>>>>>> interrupt injection failed.
> >> >>>>>>>
> >> >>>>>>> Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
> >> >>>>>>> ---
> >> >>>>>>>   virt/kvm/arm/vgic/vgic-v3.c | 2 +-
> >> >>>>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
> >> >>>>>>>
> >> >>>>>>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> >> >>>>>>> index 9c0dd23..d101000 100644
> >> >>>>>>> --- a/virt/kvm/arm/vgic/vgic-v3.c
> >> >>>>>>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> >> >>>>>>> @@ -198,7 +198,7 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu,
> >> >>>>>>> struct vgic_irq *irq, int lr) if (vgic_irq_is_mapped_level(irq) &&
> >> >>>>>>> (val & ICH_LR_PENDING_BIT)) irq->line_level = false;
> >> >>>>>>>
> >> >>>>>>> -    if (irq->group)
> >> >>>>>>> +    if (model == KVM_DEV_TYPE_ARM_VGIC_V3)
> >> >>>>>>
> >> >>>>>> This is not the right fix, not only because it basically reverts the
> >> >>>>>> GICv3 part of 87322099052 (KVM: arm/arm64: vgic: Signal IRQs using
> >> >>>>>> their configured group).
> >> >>>>>>
> >> >>>>>> Can you try to work out why kvm_vgic_vcpu_init() is apparently called
> >> >>>>>> before dist->vgic_model is set, also what value it has?
> >> >>>>>> If I understand the code correctly, that shouldn't happen for a GICv3.
> >> >>>>>>
> >> >>>>> Even if the value of  group is correctly assigned in kvm_vgic_vcpu_init, the group is then written 0 through >vgic_mmio_write_group.
> >> >>>>>   If the interrupt comes at this time, the interrupt injection fails.
> >> >>>>
> >> >>>> Does that mean that the guest is configuring its interrupts as Group0?
> >> >>>> That sounds wrong, Linux should configure all it's interrupts as
> >> >>>> non-secure group1.
> >> >>>
> >> >>> no, I think that uefi dose this, not linux.
> >> >>> 1. kvm_vgic_vcpu_init
> >> >>> 2. vgic_create
> >> >>> 3. kvm_vgic_dist_init
> >> >>> 4.vgic_mmio_write_group: uefi as guest, write group=0
> >> >>> 5.vgic_mmio_write_group: linux as guest, write group=1
> >> >>
> >> >> Is this the same issue fixed by EDK2 commit:
> >> >>
> >> >> 66127011a544b90e ("ArmPkg/ArmGicDxe ARM: fix encoding for GICv3 interrupt acknowledge")
> >> >>
> >> >> ... where EDK2 would try to use IAR0 rather than IAR1?
> >> >>
> >> >> The commit messages notes this lead to a boot-time hang.
> >> >
> >> >I managed to trigger an issue with a really old EFI implementation that
> >> >doesn't configure its interrupts as Group1, and yet tries to ACK its
> >> >interrupts using the Group1 accessor. Guess what? It is not going to work.
> >> >
> >> >Commit c7fefb690661f2e38afcb8200bd318ecf38ab961 in the edk2 tree seems
> >> >to be the fix (I only assume it does, I haven't actually checked). A
> >> >recent build, as found in Debian Buster, works perfectly (tested with
> >> >both QEMU v2.12 and tip of tree).
> >> >
> >> >Now, I really don't get what you're saying about Linux not getting
> >> >interrupts. How do you get to booting Linux if EFI is not making any
> >> >forward progress? Are you trying them independently?
> >> >
> >> I start linux with bypassing uefi, the print info is the same.
> >> [507107.748908]  vgic_mmio_write_group:## intid/27 group=0
> >> [507107.752185]  vgic_mmio_write_group:## intid/27 group=0
> >> [507107.899566]  vgic_mmio_write_group:## intid/27 group=1
> >> [507107.907370]  vgic_mmio_write_group:## intid/27 group=1
> >> the command line is like this:
> >> /home/qemu-patch/linshi/qemu/aarch64-softmmu/qemu-system-aarch64  -machine virt-3.1,accel=kvm,usb=off,dump-guest-core=off,gic-version=3  -kernel /home/kernelboot/vmlinuz-4.16.0+ -initrd /home/kernelboot/initramfs-4.16.0+.img -append root=/dev/mapper/cla-root ro crashkernel=auto rd.lvm.lv=cla/root rd.lvm.lv=cla/swap.UTF-8  -drive file=/home/centos74-ph/boot.qcow2,format=qcow2,if=none,id=drive-scsi0-0-0-0 -device scsi-hd,bus=scsi0.0,channel=0,scsi-id=0,lun=0,drive=drive-scsi0-0-0-0,id=scsi0-0-0-0,bootindex=1  -vnc 0.0.0.0:0 -k en-us -device virtio-gpu-pci,id=video0,max_outputs=1,bus=pci.3,addr=0x0 -device pvpanic-mmio -msg >timestamp=on
> >>
> >> This is strange. That's probably the Linux 4.16  kernel setting group to 0, and I'll continue to track in guest.
> >
> >Could you try the following patch:
> >
> >diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
> >index c0c0b88af1d5..6fa858c7a5a6 100644
> >--- a/virt/kvm/arm/vgic/vgic-init.c
> >+++ b/virt/kvm/arm/vgic/vgic-init.c
> >@@ -231,13 +231,6 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
> >irq->config = VGIC_CONFIG_LEVEL;
> >}
> >-        /*
> >-         * GICv3 can only be created via the KVM_DEVICE_CREATE API and
> >-         * so we always know the emulation type at this point as it's
> >-         * either explicitly configured as GICv3, or explicitly
> >-         * configured as GICv2, or not configured yet which also
> >-         * implies GICv2.
> >-         */
> >if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
> >irq->group = 1;
> >else
> >@@ -298,6 +291,16 @@ int vgic_init(struct kvm *kvm)
> >if (ret)
> >goto out;
> >+    /* Initialize groups on CPUs created before the VGIC type was known */
> >+    kvm_for_each_vcpu(i, vcpu, kvm) {
> >+        struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
> >+
> >+        for (i = 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
> >+            struct vgic_irq *irq = &vgic_cpu->private_irqs[i];
> >+            irq->group = 1;
> >+        }
> >+    }
> >+
> >if (vgic_has_its(kvm)) {
> >ret = vgic_v4_init(kvm);
> >if (ret)
> >
> Sorry for the late reply. 
> I test the patch and it works. But I think there is randomness here.
> 1.vgic_init:  set intid/27 group=1
> 2.vgic_mmio_write_group:## intid/27 group=0
> 3.!!! receive a  vtimer irq   ----- it may exist.
> 4.vgic_mmio_write_group:## intid/27 group=1

Are these writes from userspace or from the guest?
(I assume they're from the guest.)

> 
> I made an attempt before:

Was this previous experiment using my patch or without my patch?

> 1. kvm_vgic_vcpu_init
>      according to if  kvm_vgic_global_state.type == VGIC_V3, set group=1
> 2.vgic_mmio_write_group:## intid/27 group=0
> 3.!!! receive a  vtimer irq   -----I really receive a vtimer irq, then the guest hangs.
> 

If the guest you're using is flipping the group of the interrupt and yet
enabling the device and interrupt while flipping the group, then it's
not expected to work and it's a guest bug.

My hunch here tells me that my patch is what we need for KVM, and either

  (1) You no longer have a problem but are tracing some guest
      initialization behavior which is fine, or

  (2) You still have a problem because you also have some broken guest
      code (guest UEFI or guest Linux) that also needs fixing.

If you can demonstrate that you still have a problem, with my path
applied to KVM, and with a recent guest Linux and guest UEFI, then I'll
be happy to have another look.  In that case, could you please provide
the exact versions of your guest Linux and UEFI, as well as the QEMU
version and command line.


Thanks,

    Christoffer
