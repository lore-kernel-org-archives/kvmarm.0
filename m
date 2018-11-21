From: Julien Thierry <julien.thierry@arm.com>
Subject: Re: [PATCH] kvm: arm/arm64 : fix vm's hanging at startup time
Date: Wed, 21 Nov 2018 15:53:03 +0000
Message-ID: <84693a4d-34a5-8847-818a-9c05461f0ac8@arm.com>
References: <01746207-c9bb-dc91-58d7-a66c0d971f88@arm.com>
 <201811211656540883310@zte.com.cn>
 <20181121110620.GC18678@e113682-lin.lund.arm.com>
 <26c4ad81-f808-5a84-c725-72db8de7cd2b@arm.com>
 <20181121152409.GC17441@e113682-lin.lund.arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181121152409.GC17441@e113682-lin.lund.arm.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@arm.com>
Cc: peng.hao2@zte.com.cn, marc.zyngier@arm.com, andre.przywara@arm.com, linux-kernel@vger.kernel.org, leif.lindholm@linaro.org, ard.bieshseuvel@linaro.org, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu



On 21/11/18 15:24, Christoffer Dall wrote:
> On Wed, Nov 21, 2018 at 12:17:45PM +0000, Julien Thierry wrote:
>>
>>
>> On 21/11/18 11:06, Christoffer Dall wrote:
>>> Hi,
>>>
>>> On Wed, Nov 21, 2018 at 04:56:54PM +0800, peng.hao2@zte.com.cn wrote:
>>>>> On 19/11/2018 09:10, Mark Rutland wrote:
>>>>>> On Sat, Nov 17, 2018 at 10:58:37AM +0800, peng.hao2@zte.com.cn wrote:
>>>>>>>> On 16/11/18 00:23, peng.hao2@zte.com.cn wrote:
>>>>>>>>>> Hi,
>>>>>>>>>>> When virtual machine starts, hang up.
>>>>>>>>>>
>>>>>>>>>> I take it you mean the *guest* hangs? Because it doesn't get a timer
>>>>>>>>>> interrupt?
>>>>>>>>>>
>>>>>>>>>>> The kernel version of guest
>>>>>>>>>>> is 4.16. Host support vgic_v3.
>>>>>>>>>>
>>>>>>>>>> Your host kernel is something recent, I guess?
>>>>>>>>>>
>>>>>>>>>>> It was mainly due to the incorrect vgic_irq's(intid=27) group value
>>>>>>>>>>> during injection interruption. when kvm_vgic_vcpu_init is called,
>>>>>>>>>>> dist is not initialized at this time. Unable to get vgic V3 or V2
>>>>>>>>>>> correctly, so group is not set.
>>>>>>>>>>
>>>>>>>>>> Mmh, that shouldn't happen with (v)GICv3. Do you use QEMU (which
>>>>>>>>>> version?) or some other userland tool?
>>>>>>>>>>
>>>>>>>>>
>>>>>>>>> QEMU emulator version 3.0.50 .
>>>>>>>>>
>>>>>>>>>>> group is setted to 1 when vgic_mmio_write_group is invoked at some
>>>>>>>>>>> time.
>>>>>>>>>>> when irq->group=0 (intid=27), No ICH_LR_GROUP flag was set and
>>>>>>>>>>> interrupt injection failed.
>>>>>>>>>>>
>>>>>>>>>>> Signed-off-by: Peng Hao <peng.hao2@zte.com.cn>
>>>>>>>>>>> ---
>>>>>>>>>>>    virt/kvm/arm/vgic/vgic-v3.c | 2 +-
>>>>>>>>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>>>>>>>
>>>>>>>>>>> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
>>>>>>>>>>> index 9c0dd23..d101000 100644
>>>>>>>>>>> --- a/virt/kvm/arm/vgic/vgic-v3.c
>>>>>>>>>>> +++ b/virt/kvm/arm/vgic/vgic-v3.c
>>>>>>>>>>> @@ -198,7 +198,7 @@ void vgic_v3_populate_lr(struct kvm_vcpu *vcpu,
>>>>>>>>>>> struct vgic_irq *irq, int lr) if (vgic_irq_is_mapped_level(irq) &&
>>>>>>>>>>> (val & ICH_LR_PENDING_BIT)) irq->line_level = false;
>>>>>>>>>>>
>>>>>>>>>>> -    if (irq->group)
>>>>>>>>>>> +    if (model == KVM_DEV_TYPE_ARM_VGIC_V3)
>>>>>>>>>>
>>>>>>>>>> This is not the right fix, not only because it basically reverts the
>>>>>>>>>> GICv3 part of 87322099052 (KVM: arm/arm64: vgic: Signal IRQs using
>>>>>>>>>> their configured group).
>>>>>>>>>>
>>>>>>>>>> Can you try to work out why kvm_vgic_vcpu_init() is apparently called
>>>>>>>>>> before dist->vgic_model is set, also what value it has?
>>>>>>>>>> If I understand the code correctly, that shouldn't happen for a GICv3.
>>>>>>>>>>
>>>>>>>>> Even if the value of  group is correctly assigned in kvm_vgic_vcpu_init, the group is then written 0 through vgic_mmio_write_group.
>>>>>>>>>    If the interrupt comes at this time, the interrupt injection fails.
>>>>>>>>
>>>>>>>> Does that mean that the guest is configuring its interrupts as Group0?
>>>>>>>> That sounds wrong, Linux should configure all it's interrupts as
>>>>>>>> non-secure group1.
>>>>>>>
>>>>>>> no, I think that uefi dose this, not linux.
>>>>>>> 1. kvm_vgic_vcpu_init
>>>>>>> 2. vgic_create
>>>>>>> 3. kvm_vgic_dist_init
>>>>>>> 4.vgic_mmio_write_group: uefi as guest, write group=0
>>>>>>> 5.vgic_mmio_write_group: linux as guest, write group=1
>>>>>>
>>>>>> Is this the same issue fixed by EDK2 commit:
>>>>>>
>>>>>> 66127011a544b90e ("ArmPkg/ArmGicDxe ARM: fix encoding for GICv3 interrupt acknowledge")
>>>>>>
>>>>>> ... where EDK2 would try to use IAR0 rather than IAR1?
>>>>>>
>>>>>> The commit messages notes this lead to a boot-time hang.
>>>>>
>>>>> I managed to trigger an issue with a really old EFI implementation that
>>>>> doesn't configure its interrupts as Group1, and yet tries to ACK its
>>>>> interrupts using the Group1 accessor. Guess what? It is not going to work.
>>>>>
>>>>> Commit c7fefb690661f2e38afcb8200bd318ecf38ab961 in the edk2 tree seems
>>>>> to be the fix (I only assume it does, I haven't actually checked). A
>>>>> recent build, as found in Debian Buster, works perfectly (tested with
>>>>> both QEMU v2.12 and tip of tree).
>>>>>
>>>>> Now, I really don't get what you're saying about Linux not getting
>>>>> interrupts. How do you get to booting Linux if EFI is not making any
>>>>> forward progress? Are you trying them independently?
>>>>>
>>>> I start linux with bypassing uefi, the print info is the same.
>>>> [507107.748908]  vgic_mmio_write_group:## intid/27 group=0
>>>> [507107.752185]  vgic_mmio_write_group:## intid/27 group=0
>>>> [507107.899566]  vgic_mmio_write_group:## intid/27 group=1
>>>> [507107.907370]  vgic_mmio_write_group:## intid/27 group=1
>>>> the command line is like this:
>>>> /home/qemu-patch/linshi/qemu/aarch64-softmmu/qemu-system-aarch64  -machine virt-3.1,accel=kvm,usb=off,dump-guest-core=off,gic-version=3  -kernel /home/kernelboot/vmlinuz-4.16.0+ -initrd /home/kernelboot/initramfs-4.16.0+.img -append root=/dev/mapper/cla-root ro crashkernel=auto rd.lvm.lv=cla/root rd.lvm.lv=cla/swap.UTF-8  -drive file=/home/centos74-ph/boot.qcow2,format=qcow2,if=none,id=drive-scsi0-0-0-0 -device scsi-hd,bus=scsi0.0,channel=0,scsi-id=0,lun=0,drive=drive-scsi0-0-0-0,id=scsi0-0-0-0,bootindex=1  -vnc 0.0.0.0:0 -k en-us -device virtio-gpu-pci,id=video0,max_outputs=1,bus=pci.3,addr=0x0 -device pvpanic-mmio -msg timestamp=on
>>>>
>>>> This is strange. That's probably the Linux 4.16  kernel setting group to 0, and I'll continue to track in guest.
>>>
>>> Could you try the following patch:
>>>
>>> diff --git a/virt/kvm/arm/vgic/vgic-init.c b/virt/kvm/arm/vgic/vgic-init.c
>>> index c0c0b88af1d5..6fa858c7a5a6 100644
>>> --- a/virt/kvm/arm/vgic/vgic-init.c
>>> +++ b/virt/kvm/arm/vgic/vgic-init.c
>>> @@ -231,13 +231,6 @@ int kvm_vgic_vcpu_init(struct kvm_vcpu *vcpu)
>>>   			irq->config = VGIC_CONFIG_LEVEL;
>>>   		}
>>> -		/*
>>> -		 * GICv3 can only be created via the KVM_DEVICE_CREATE API and
>>> -		 * so we always know the emulation type at this point as it's
>>> -		 * either explicitly configured as GICv3, or explicitly
>>> -		 * configured as GICv2, or not configured yet which also
>>> -		 * implies GICv2.
>>> -		 */
>>>   		if (dist->vgic_model == KVM_DEV_TYPE_ARM_VGIC_V3)
>>>   			irq->group = 1;
>>>   		else
>>> @@ -298,6 +291,16 @@ int vgic_init(struct kvm *kvm)
>>>   	if (ret)
>>>   		goto out;
>>> +	/* Initialize groups on CPUs created before the VGIC type was known */
>>> +	kvm_for_each_vcpu(i, vcpu, kvm) {
>>> +		struct vgic_cpu *vgic_cpu = &vcpu->arch.vgic_cpu;
>>> +
>>> +		for (i = 0; i < VGIC_NR_PRIVATE_IRQS; i++) {
>>> +			struct vgic_irq *irq = &vgic_cpu->private_irqs[i];
>>> +			irq->group = 1;
>>> +		}
>>> +	}
>>> +
>>>   	if (vgic_has_its(kvm)) {
>>>   		ret = vgic_v4_init(kvm);
>>>   		if (ret)
>>>
>>>
>>
>> If the value of dist->vgic_model is not properly initialized at the time we
>> call kvm_vgic_vcpu_init is call, won't we still overwrite the irq->group
>> when we get there?
> 
> I don't understand this question.  When we get where?

Sorry, I meant when we get to the irq->group initialization in 
kvm_vgic_vcpu_init.

> 
>> (I still haven't seen why we could consider
>> dist->vgic_model is initialized at that point).
> 
> Because there is no enforced ordering between creating VCPUs and
> creating the VGIC.

Hmmm, I think that's what I am saying, so we shouldn't look at the value 
of vgic_dist->vgic_model since it could be uninitialized (or 0).

> 
>>
>> Shouldn't we do the irq->group initialization somewhere in
>> kvm_arch_vcpu_ioctl_vcpu_init? (with some vgic_* function to encapsulate it
>> of course). At that point I believe we know that dist->vgic_model is
>> initialized.
>>
> 
> See above.  AFAICT we don't have a single point at which we can do
> everything because creation of the two components can be interleaved.
> 
> We could hook into kvm_vcpu_first_run_init(), but then userspace can
> observe uninitialized values if it looks at the GIC state prior to
> running the VCPUs, which is also not great.
> 
> In other words, I think the problem is that you can do:
> 
>    create_vcpu(0);
>    create_vgic(v3);
>    create_vcpu(2);
> 
> Now you'll have vcpu0 have its private IRQs set to group 0, and you'll
> have vcpu1 have its private IRQs set to group 1 (prior to my patch).
> 
> 
> Am I missing something?
> 

No, I just got confused between create_vgic and vgic_init. So the place 
looks fine. Sorry for the confusion.

The fact that we still check dist->vgic_model in kvm_vgic_vcpu_init 
(twice actually), however seems dodgy to me since it might not have been 
initialized.

Thanks,

-- 
Julien Thierry
