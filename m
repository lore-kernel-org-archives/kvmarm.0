From: Leo Yan <leo.yan@linaro.org>
Subject: Re: Question: KVM: Failed to bind vfio with PCI-e / SMMU on Juno-r2
Date: Mon, 11 Mar 2019 22:35:01 +0800
Message-ID: <20190311143501.GH13422@leoy-ThinkPad-X240s>
References: <20190311064248.GC13422@leoy-ThinkPad-X240s>
 <f6f56743-677c-61ff-1746-1c86eab054a4@redhat.com>
 <20190311093958.GF13422@leoy-ThinkPad-X240s>
 <762d54fb-b146-e591-d544-676cb5606837@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 452E54A408
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Mar 2019 10:35:10 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 456XfU62eZ+e for <kvmarm@lists.cs.columbia.edu>;
 Mon, 11 Mar 2019 10:35:09 -0400 (EDT)
Received: from mail-yw1-f68.google.com (mail-yw1-f68.google.com
 [209.85.161.68])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 307124A2E5
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Mar 2019 10:35:09 -0400 (EDT)
Received: by mail-yw1-f68.google.com with SMTP id j189so4006676ywd.13
 for <kvmarm@lists.cs.columbia.edu>; Mon, 11 Mar 2019 07:35:09 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <762d54fb-b146-e591-d544-676cb5606837@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>, Mark Rutland <mark.rutland@arm.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Eric,

[ + Mark Rutland ]

On Mon, Mar 11, 2019 at 10:47:22AM +0100, Auger Eric wrote:

[...]

> >>> P.s. I also checked the sysfs node and found it doesn't contain node
> >>> 'iommu_group':
> >>>
> >>> # ls /sys/bus/pci/devices/0000\:08\:00.0/iommu_group
> >>> ls: cannot access '/sys/bus/pci/devices/0000:08:00.0/iommu_group': No
> >>> such file or directory
> >>
> >> please can you give the output of the following command:
> >> find /sys/kernel/iommu_groups/
> > 
> > I get below result on Juno board:
> > 
> > root@debian:~# find /sys/kernel/iommu_groups/
> > /sys/kernel/iommu_groups/
> > /sys/kernel/iommu_groups/1
> > /sys/kernel/iommu_groups/1/devices
> > /sys/kernel/iommu_groups/1/devices/20070000.etr
> > /sys/kernel/iommu_groups/1/type
> > /sys/kernel/iommu_groups/1/reserved_regions
> > /sys/kernel/iommu_groups/0
> > /sys/kernel/iommu_groups/0/devices
> > /sys/kernel/iommu_groups/0/devices/7ffb0000.ohci
> > /sys/kernel/iommu_groups/0/devices/7ffc0000.ehci
> > /sys/kernel/iommu_groups/0/type
> > /sys/kernel/iommu_groups/0/reserved_regions
> > 
> > So the 'iommu_groups' is not created for pci-e devices, right?
> 
> Yes that's correct.

Juno's pci-e devices without 'iommu_groups' is caused by dt binding, in
dts file [1] it sets 'status = "disabled"' for 'smmu_pcie' node.  Thus
the SMMU device will not be enabled for pci-e devices.

@Mark Rutland, could you have chance to confirm this should be fixed in
juno-base.dtsi or juno-r1.dts/juno-r2.dts?

> > Will debug into dt binding and related code and keep posted at here.OK

So now I made some progress and can see the networking card is
pass-through to guest OS, though the networking card reports errors
now.  Below is detailed steps and info:

- Bind devices in the same IOMMU group to vfio driver:

  echo 0000:03:00.0 > /sys/bus/pci/devices/0000\:03\:00.0/driver/unbind
  echo 1095 3132 > /sys/bus/pci/drivers/vfio-pci/new_id

  echo 0000:08:00.0 > /sys/bus/pci/devices/0000\:08\:00.0/driver/unbind
  echo 11ab 4380 > /sys/bus/pci/drivers/vfio-pci/new_id

- Enable 'allow_unsafe_interrupts=1' for module vfio_iommu_type1;

- Use qemu to launch guest OS:

  qemu-system-aarch64 \
        -cpu host -M virt,accel=kvm -m 4096 -nographic \
        -kernel /root/virt/Image -append root=/dev/vda2 \
        -net none -device vfio-pci,host=08:00.0 \
        -drive if=virtio,file=/root/virt/qemu/debian.img \
        -append 'loglevel=8 root=/dev/vda2 rw console=ttyAMA0 earlyprintk ip=dhcp'

- Host log:

[  188.329861] vfio-pci 0000:08:00.0: enabling device (0000 -> 0003)

- Below is guest log, from log though the driver has been registered but
  it reports PCI hardware failure and the timeout for the interrupt.

  So is this caused by very 'slow' forward interrupt handling?  Juno
  board uses GICv2 (I think it has GICv2m extension).

[...]

[    1.024483] sky2 0000:00:01.0 eth0: enabling interface
[    1.026822] sky2 0000:00:01.0: error interrupt status=0x80000000
[    1.029155] sky2 0000:00:01.0: PCI hardware error (0x1010)
[    4.000699] sky2 0000:00:01.0 eth0: Link is up at 1000 Mbps, full duplex, flow control both
[    4.026116] Sending DHCP requests .
[    4.026201] sky2 0000:00:01.0: error interrupt status=0x80000000
[    4.030043] sky2 0000:00:01.0: PCI hardware error (0x1010)
[    6.546111] ..
[   14.118106] ------------[ cut here ]------------
[   14.120672] NETDEV WATCHDOG: eth0 (sky2): transmit queue 0 timed out
[   14.123555] WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:461 dev_watchdog+0x2b4/0x2c0
[   14.127082] Modules linked in:
[   14.128631] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.0.0-rc8-00061-ga98f9a047756-dirty #
[   14.132800] Hardware name: linux,dummy-virt (DT)
[   14.135082] pstate: 60000005 (nZCv daif -PAN -UAO)
[   14.137459] pc : dev_watchdog+0x2b4/0x2c0
[   14.139457] lr : dev_watchdog+0x2b4/0x2c0
[   14.141351] sp : ffff000010003d70
[   14.142924] x29: ffff000010003d70 x28: ffff0000112f60c0
[   14.145433] x27: 0000000000000140 x26: ffff8000fa6eb3b8
[   14.147936] x25: 00000000ffffffff x24: ffff8000fa7a7c80
[   14.150428] x23: ffff8000fa6eb39c x22: ffff8000fa6eafb8
[   14.152934] x21: ffff8000fa6eb000 x20: ffff0000112f7000
[   14.155437] x19: 0000000000000000 x18: ffffffffffffffff
[   14.157929] x17: 0000000000000000 x16: 0000000000000000
[   14.160432] x15: ffff0000112fd6c8 x14: ffff000090003a97
[   14.162927] x13: ffff000010003aa5 x12: ffff000011315878
[   14.165428] x11: ffff000011315000 x10: 0000000005f5e0ff
[   14.167935] x9 : 00000000ffffffd0 x8 : 64656d6974203020
[   14.170430] x7 : 6575657571207469 x6 : 00000000000000e3
[   14.172935] x5 : 0000000000000000 x4 : 0000000000000000
[   14.175443] x3 : 00000000ffffffff x2 : ffff0000113158a8
[   14.177938] x1 : f2db9128b1f08600 x0 : 0000000000000000
[   14.180443] Call trace:
[   14.181625]  dev_watchdog+0x2b4/0x2c0
[   14.183377]  call_timer_fn+0x20/0x78
[   14.185078]  expire_timers+0xa4/0xb0
[   14.186777]  run_timer_softirq+0xa0/0x190
[   14.188687]  __do_softirq+0x108/0x234
[   14.190428]  irq_exit+0xcc/0xd8
[   14.191941]  __handle_domain_irq+0x60/0xb8
[   14.193877]  gic_handle_irq+0x58/0xb0
[   14.195630]  el1_irq+0xb0/0x128
[   14.197132]  arch_cpu_idle+0x10/0x18
[   14.198835]  do_idle+0x1cc/0x288
[   14.200389]  cpu_startup_entry+0x24/0x28
[   14.202251]  rest_init+0xd4/0xe0
[   14.203804]  arch_call_rest_init+0xc/0x14
[   14.205702]  start_kernel+0x3d8/0x404
[   14.207449] ---[ end trace 65449acd5c054609 ]---
[   14.209630] sky2 0000:00:01.0 eth0: tx timeout
[   14.211655] sky2 0000:00:01.0 eth0: transmit ring 0 .. 3 report=0 done=0
[   17.906956] sky2 0000:00:01.0 eth0: Link is up at 1000 Mbps, full duplex, flow control both

Thanks,
Leo Yan

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/boot/dts/arm/juno-base.dtsi?h=v5.0#n46
