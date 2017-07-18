From: Robin Murphy <robin.murphy@arm.com>
Subject: Re: [report] boot a vm that with PCI only hierarchy devices and with
 GICv3 , it's failed.
Date: Tue, 18 Jul 2017 12:22:48 +0100
Message-ID: <6d0f61dc-e5b8-6481-38c2-fc7af6b738bb@arm.com>
References: <596D8969.8060107@huawei.com>
 <dd59da6d-b775-4b2b-385c-ff8a909399d8@arm.com>
 <03cf57bf-a22a-c679-21d6-1ea174c4f809@arm.com> <596DEBF2.1050808@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5F09040A80
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 07:22:05 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id UGTjey9QGiRx for <kvmarm@lists.cs.columbia.edu>;
 Tue, 18 Jul 2017 07:22:03 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4AED040017
 for <kvmarm@lists.cs.columbia.edu>; Tue, 18 Jul 2017 07:22:02 -0400 (EDT)
In-Reply-To: <596DEBF2.1050808@huawei.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: wanghaibin <wanghaibin.wang@huawei.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, cdall@linaro.org, kvmarm@lists.cs.columbia.edu, wu.wubin@huawei.com
List-Id: kvmarm@lists.cs.columbia.edu

On 18/07/17 12:07, wanghaibin wrote:
> On 2017/7/18 18:02, Robin Murphy wrote:
> 
>> On 18/07/17 10:15, Marc Zyngier wrote:
>>> On 18/07/17 05:07, wanghaibin wrote:
>>>> Hi, all:
>>>>
>>>> I met a problem, I just try to test PCI only hierarchy devices model (qemu/docs/pcie.txt  sections 2.3)
>>>>
>>>> Here is part of qemu cmd:
>>>> -device i82801b11-bridge,id=pci.1,bus=pcie.0,addr=0x1 -device pci-bridge,chassis_nr=2,id=pci.2,bus=pci.1,addr=0x0 -device usb-ehci,id=usb,bus=pci.2,addr=0x2
>>>> -device virtio-scsi-pci,id=scsi0,bus=pci.2,addr=0x3 -netdev tap,fd=27,id=hostnet0,vhost=on,vhostfd=28 -device virtio-net-pci,netdev=hostnet0,id=net0,mac=52:54:00:60:6b:1d,bus=pci.2,addr=0x1
>>>> -vnc 0.0.0.0:0 -device virtio-gpu-pci,id=video0,bus=pci.2,addr=0x4
>>>>
>>>> A single DMI-PCI Bridge, a single PCI-PCI Bridge attached to it.  Four PCI_DEV legacy devices (usb, virtio-scsi-pci, virtio-gpu-pci, virtio-net-pci)attached to the PCI-PCI Bridge.
>>>> Boot the vm, it's failed.
>>
>> What's the nature of the failure? Does it hit some actual error case in
>> the GIC code, or does it simply hang up probing the virtio devices
>> because interrupts never arrive?
> 
> 
> Qemu cmdline, xml info, qemu version info, guest kernel version info at the bottom of this mail.
> 
> 
> Guest hang log:
> 
> [  242.740171] INFO: task kworker/u16:4:446 blocked for more than 120 seconds.
> [  242.741102]       Not tainted 4.12.0+ #18
> [  242.741619] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> [  242.742610] kworker/u16:4   D    0   446      2 0x00000000
> [  242.743339] Workqueue: scsi_tmf_0 scmd_eh_abort_handler
> [  242.744014] Call trace:
> [  242.744375] [<ffff0000080856bc>] __switch_to+0x94/0xa8
> [  242.745042] [<ffff00000892a3f8>] __schedule+0x1a0/0x5e0
> [  242.745716] [<ffff00000892a870>] schedule+0x38/0xa0
> [  242.746346] [<ffff00000892da84>] schedule_timeout+0x194/0x2b8
> [  242.747092] [<ffff00000892b438>] wait_for_common+0xa0/0x148
> [  242.747810] [<ffff00000892b4f4>] wait_for_completion+0x14/0x20
> [  242.748595] [<ffff0000085e78d8>] virtscsi_tmf.constprop.15+0x88/0xf0
> [  242.749408] [<ffff0000085e79dc>] virtscsi_abort+0x9c/0xb8
> [  242.750099] [<ffff0000085db4dc>] scmd_eh_abort_handler+0x5c/0x108
> [  242.750887] [<ffff0000080d8594>] process_one_work+0x124/0x2a8
> [  242.751618] [<ffff0000080d8774>] worker_thread+0x5c/0x3d8
> [  242.752330] [<ffff0000080de7b4>] kthread+0xfc/0x128
> [  242.752960] [<ffff000008082ec0>] ret_from_fork+0x10/0x50
> 
> But I still doubt the total vector count takes this problem in, I add some log in guest:
> In guest boot, pci_dev: 02:04:00(virtio-gpu-pci) first load, and only alloc 4 ITT entries, the log as follow:
> 
> [    0.986233] ~~its_pci_msi_prepare:pci dev: 2,32, nvec:3~~
> [    0.998952] ~~its_pci_msi_prepare:devid:8,alias count:4~~
> [    1.000028] **its_msi_prepare:devid:8, nves:4**
> [    1.001001] ##its_create_device:devid: 8, ITT 4 entries, 2 bits, lpi base:8192, nr:32##
> [    1.002585] **its_msi_prepare:ITT 4 entries, 2 bits**
> [    1.003593] !!msi_domain_alloc_irqs: to alloc: desc->nvec_used:1!!
> [    1.004880] ID:0 pID:8192 vID:52
> [    1.005529] !!msi_domain_alloc_irqs: to alloc: desc->nvec_used:1!!
> [    1.006777] ID:1 pID:8193 vID:53
> [    1.007437] !!msi_domain_alloc_irqs: to alloc: desc->nvec_used:1!!
> [    1.008718] ID:2 pID:8194 vID:54
> [    1.009366] !!msi_domain_alloc_irqs: to active!!
> [    1.010281] ^^^SEND mapti: hwirq:8192,event:0^^
> [    1.011224] !!msi_domain_alloc_irqs: to active!!
> [    1.012161] ^^^SEND mapti: hwirq:8193,event:1^^
> [    1.013095] !!msi_domain_alloc_irqs: to active!!
> [    1.014013] ^^^SEND mapti: hwirq:8194,event:2^^
> 
> and the guest booted continue, when load the pci_dev: 02:03:00 (virtio-scsi), the log shows it shared the same devid
> with virtio-gpu-pci, shared ite_dev, reusing ITT. So that, the  virtio-gpu-pci dev only alloc 4 ITT, and the virtio-scsi send
> mapti with eventid 5/6, this will be captured by Eric's commit:
> guest log:
> [    1.057978] !!msi_domain_alloc_irqs: to prepare: nvec:4!!
> [    1.072773] ~~its_pci_msi_prepare:devid:8,alias count:5~~
> [    1.073943] **its_msi_prepare:devid:8, nves:5**
> [    1.074850] **its_msi_prepare:Reusing ITT for devID:8**
> [    1.075873] !!msi_domain_alloc_irqs: to alloc: desc->nvec_used:1!!
> [    1.077154] ID:3 pID:8195 vID:55
> [    1.077813] !!msi_domain_alloc_irqs: to alloc: desc->nvec_used:1!!
> [    1.079044] ID:4 pID:8196 vID:56
> [    1.079683] !!msi_domain_alloc_irqs: to alloc: desc->nvec_used:1!!
> [    1.080947] ID:5 pID:8197 vID:57
> [    1.081592] !!msi_domain_alloc_irqs: to alloc: desc->nvec_used:1!!
> [    1.082825] ID:6 pID:8198 vID:58
> 
> 
> part of Eric's commit:
> 
> @@ -784,6 +788,9 @@ static int vgic_its_cmd_handle_mapi(struct kvm *kvm, struct vgic_its *its,
>         if (!device)
>                 return E_ITS_MAPTI_UNMAPPED_DEVICE;
> 
> +       if (event_id >= BIT_ULL(device->num_eventid_bits))
> +               return E_ITS_MAPTI_ID_OOR;
> 
> Thanks!
> 
>>
>>>> I try to debug this problem, and the info just as follow:
>>>> (1) Since Eric Auger commit (0d44cdb631ef53ea75be056886cf0541311e48df: KVM: arm64: vgic-its: Interpret MAPD Size field and check related errors), This problem has been exposed.
>>>>     Of course, I think this commit must be correct surely.
>>>>
>>>> (2) For guestOS, I notice Marc commit (e8137f4f5088d763ced1db82d3974336b76e1bd2: irqchip: gicv3-its: Iterate over PCI aliases to generate ITS configuration).  This commit brings in that the
>>>>     four PCI_DEV legacy devices shared the same devID, same its_dev, same ITT tables, but I think here calculate with wrong total msi vector count.
>>>>     (Currently, It seems the total count is the vector count of virtio-net-pci + PCI-PCI bridge + dmi-pci bridge, maybe here should be the total count of the four PCI_DEV legacy devices vector count),
>>>>     So that, any pci device using the over bounds eventID and mapti at a certain moment , the abnormal behavior will captured by Eric's commit.
>>
>> Now, at worst that patch *should* result in the same number of vectors
>> being reserved as before - never fewer. Does anything change with it
>> reverted?
>>
>>>> Actually, I don't understand very well about non-transparent bridge, PCI aliases. So just supply these message.
>>
>> Note that there are further issues with PCI RID to DevID mappings in the
>> face of aliases[1], but I think the current code does happen to work out
>> OK for the PCI-PCIe bridge case already.
>>
>>> +Robin, who is the author of that patch.

Oops, only now do I actually notice - e8137f4f5088 is the *original*
commit trying to do the right thing, but incorrectly. My patch fixing it
is actually 3403b0259d15 ("irqchip/gic-v3-its: Fix MSI alias
accounting"), and isn't in 4.12, which would explain things here. I
expect that cherry-picking 3403b0259d15 should lead to success, since it
looks like this is a case of the exact problem it was intended to solve.

Thanks,
Robin.

>>> Regarding (2), the number of MSIs should be the total number of devices
>>> that are going to generate the same DevID. Since the bridge is
>>> non-transparent, everything behind it aliases with it. So you should
>>> probably see all the virtio devices and the bridges themselves being
>>> counted. If that's not the case, then "we have a bug"(tm).
>>>
>>> Can you please post your full qemu cmd line so that we can reproduce it
>>> and investigate the issue?
>>
>> Yes, that would be good.
> 
> 
> 
> I used the qemu version: 2.9.50,
> guest linux version: Linux 4.12
> 
> xml :
> 
> <domain type='kvm' id='5'>
>   <name>abu</name>
>   <uuid>76365c65-7ee7-43ff-bb57-f0f80b75323a</uuid>
>   <memory unit='KiB'>8388608</memory>
>   <currentMemory unit='KiB'>8388608</currentMemory>
>   <vcpu placement='static'>8</vcpu>
>   <resource>
>     <partition>/machine</partition>
>   </resource>
>   <os>
>     <type arch='aarch64' machine='virt-2.9'>hvm</type>
>     <kernel>/mnt/wanghaibin/vm-res/src/open-sorce/linux-stable/arch/arm64/boot/Image</kernel>
>     <cmdline>console=ttyAMA0 root=/dev/sda2 earlyprintk=pl011,0x9000000 rw</cmdline>
>     <boot dev='hd'/>
>   </os>
>   <features>
>     <gic version='3'/>
>   </features>
>   <cpu mode='host-passthrough'/>
>   <clock offset='utc'>
>     <timer name='rtc' tickpolicy='catchup' track='guest'/>
>     <timer name='hpet' present='no'/>
>     <timer name='pit' tickpolicy='delay'/>
>   </clock>
>   <on_poweroff>destroy</on_poweroff>
>   <on_reboot>restart</on_reboot>
>   <on_crash>restart</on_crash>
>   <devices>
>     <emulator>/mnt/wanghaibin/vm-res/src/open-sorce/qemu/aarch64-softmmu/qemu-system-aarch64</emulator>
>     <disk type='file' device='disk'>
>       <driver name='qemu' type='raw' cache='none' io='native'/>
>       <source file='/mnt/wanghaibin/vm-res/euler_b500.raw'/>
>       <backingStore/>
>       <target dev='sda' bus='scsi'/>
>       <alias name='scsi0-0-0-0'/>
>       <address type='drive' controller='0' bus='0' target='0' unit='0'/>
>     </disk>
>     <controller type='usb' index='0' model='ehci'>
>       <alias name='usb'/>
>       <address type='pci' domain='0x0000' bus='0x02' slot='0x02' function='0x0'/>
>     </controller>
>     <controller type='scsi' index='0' model='virtio-scsi'>
>       <alias name='scsi0'/>
>       <address type='pci' domain='0x0000' bus='0x02' slot='0x03' function='0x0'/>
>     </controller>
>     <controller type='pci' index='0' model='pcie-root'>
>       <alias name='pcie.0'/>
>     </controller>
>     <controller type='pci' index='1' model='dmi-to-pci-bridge'>
>       <model name='i82801b11-bridge'/>
>       <alias name='pci.1'/>
>       <address type='pci' domain='0x0000' bus='0x00' slot='0x01' function='0x0'/>
>     </controller>
>     <controller type='pci' index='2' model='pci-bridge'>
>       <model name='pci-bridge'/>
>       <target chassisNr='2'/>
>       <alias name='pci.2'/>
>       <address type='pci' domain='0x0000' bus='0x01' slot='0x00' function='0x0'/>
>     </controller>
>     <interface type='bridge'>
>       <mac address='52:54:00:60:6b:1d'/>
>       <source bridge='br0'/>
>       <virtualport type='openvswitch'>
>         <parameters interfaceid='c216af51-9088-4bf8-ba04-cf6172cb3753'/>
>       </virtualport>
>       <target dev='vnet0'/>
>       <model type='virtio'/>
>       <driver name='vhost'/>
>       <alias name='net0'/>
>       <address type='pci' domain='0x0000' bus='0x02' slot='0x01' function='0x0'/>
>     </interface>
>     <serial type='pty'>
>       <source path='/dev/pts/2'/>
>       <target port='0'/>
>       <alias name='serial0'/>
>     </serial>
>     <console type='pty' tty='/dev/pts/2'>
>       <source path='/dev/pts/2'/>
>       <target type='serial' port='0'/>
>       <alias name='serial0'/>
>     </console>
>     <input type='tablet' bus='usb'>
>       <alias name='input0'/>
>     </input>
>     <input type='keyboard' bus='usb'>
>       <alias name='input1'/>
>     </input>
>     <graphics type='vnc' port='5900' autoport='yes' listen='0.0.0.0'>
>       <listen type='address' address='0.0.0.0'/>
>     </graphics>
>     <video>
>       <model type='virtio' heads='1' primary='yes'/>
>       <alias name='video0'/>
>       <address type='pci' domain='0x0000' bus='0x02' slot='0x04' function='0x0'/>
>     </video>
>   </devices>
>   <seclabel type='none' model='none'/>
>   <seclabel type='dynamic' model='dac' relabel='yes'>
>     <label>+0:+0</label>
>     <imagelabel>+0:+0</imagelabel>
>   </seclabel>
> </domain>
> 
> qemu cmdline :
> 
> /mnt/wanghaibin/vm-res/src/open-sorce/qemu/aarch64-softmmu/qemu-system-aarch64 -name guest=abu,debug-threads=on -S
> -object secret,id=masterKey0,format=raw,file=/var/lib/libvirt/qemu/domain-5-abu/master-key.aes -machine virt-2.9,accel=kvm,usb=off,gic-version=3
> -cpu host -m 8192 -realtime mlock=off -smp 8,sockets=8,cores=1,threads=1 -uuid 76365c65-7ee7-43ff-bb57-f0f80b75323a -no-user-config -nodefaults
> -chardev socket,id=charmonitor,path=/var/lib/libvirt/qemu/domain-5-abu/monitor.sock,server,nowait -mon chardev=charmonitor,id=monitor,mode=control
> -rtc base=utc,clock=vm,driftfix=slew -no-shutdown -boot strict=on -kernel /mnt/wanghaibin/vm-res/src/open-sorce/linux-stable/arch/arm64/boot/Image
> -append console=ttyAMA0 root=/dev/sda2 earlyprintk=pl011,0x9000000 rw -device i82801b11-bridge,id=pci.1,bus=pcie.0,addr=0x1
> -device pci-bridge,chassis_nr=2,id=pci.2,bus=pci.1,addr=0x0 -device usb-ehci,id=usb,bus=pci.2,addr=0x2 -device virtio-scsi-pci,id=scsi0,bus=pci.2,addr=0x3
> -drive file=/mnt/wanghaibin/vm-res/euler_b500.raw,format=raw,if=none,id=drive-scsi0-0-0-0,cache=none,aio=native
> -device scsi-hd,bus=scsi0.0,channel=0,scsi-id=0,lun=0,drive=drive-scsi0-0-0-0,id=scsi0-0-0-0,bootindex=1
> -netdev tap,fd=27,id=hostnet0,vhost=on,vhostfd=28 -device virtio-net-pci,netdev=hostnet0,id=net0,mac=52:54:00:60:6b:1d,bus=pci.2,addr=0x1
> -serial pty -device usb-tablet,id=input0 -device usb-kbd,id=input1 -vnc 0.0.0.0:0 -device virtio-gpu-pci,id=video0,bus=pci.2,addr=0x4 -msg timestamp=on
> 
> 
> Thanks
> 
>>
>> Robin.
>>
>> [1] https://patchwork.ozlabs.org/patch/769303/
>>
>>> Thanks,
>>>
>>> 	M.
>>>
>>
>>
>> .
>>
> 
> 
> 
