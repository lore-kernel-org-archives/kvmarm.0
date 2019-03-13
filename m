From: Leo Yan <leo.yan@linaro.org>
Subject: Re: Question: KVM: Failed to bind vfio with PCI-e / SMMU on Juno-r2
Date: Wed, 13 Mar 2019 16:00:48 +0800
Message-ID: <20190313080048.GI13422@leoy-ThinkPad-X240s>
References: <20190311064248.GC13422@leoy-ThinkPad-X240s>
 <f6f56743-677c-61ff-1746-1c86eab054a4@redhat.com>
 <20190311093958.GF13422@leoy-ThinkPad-X240s>
 <762d54fb-b146-e591-d544-676cb5606837@redhat.com>
 <20190311143501.GH13422@leoy-ThinkPad-X240s>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 4B8AC4A36B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Mar 2019 04:01:00 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id sicgp-vRynog for <kvmarm@lists.cs.columbia.edu>;
 Wed, 13 Mar 2019 04:00:55 -0400 (EDT)
Received: from mail-yw1-f66.google.com (mail-yw1-f66.google.com
 [209.85.161.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 433774A2F8
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Mar 2019 04:00:55 -0400 (EDT)
Received: by mail-yw1-f66.google.com with SMTP id e76so684392ywa.9
 for <kvmarm@lists.cs.columbia.edu>; Wed, 13 Mar 2019 01:00:55 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20190311143501.GH13422@leoy-ThinkPad-X240s>
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

Hi Eric & all,

On Mon, Mar 11, 2019 at 10:35:01PM +0800, Leo Yan wrote:

[...]

> So now I made some progress and can see the networking card is
> pass-through to guest OS, though the networking card reports errors
> now.  Below is detailed steps and info:
> 
> - Bind devices in the same IOMMU group to vfio driver:
> 
>   echo 0000:03:00.0 > /sys/bus/pci/devices/0000\:03\:00.0/driver/unbind
>   echo 1095 3132 > /sys/bus/pci/drivers/vfio-pci/new_id
> 
>   echo 0000:08:00.0 > /sys/bus/pci/devices/0000\:08\:00.0/driver/unbind
>   echo 11ab 4380 > /sys/bus/pci/drivers/vfio-pci/new_id
> 
> - Enable 'allow_unsafe_interrupts=1' for module vfio_iommu_type1;
> 
> - Use qemu to launch guest OS:
> 
>   qemu-system-aarch64 \
>         -cpu host -M virt,accel=kvm -m 4096 -nographic \
>         -kernel /root/virt/Image -append root=/dev/vda2 \
>         -net none -device vfio-pci,host=08:00.0 \
>         -drive if=virtio,file=/root/virt/qemu/debian.img \
>         -append 'loglevel=8 root=/dev/vda2 rw console=ttyAMA0 earlyprintk ip=dhcp'
> 
> - Host log:
> 
> [  188.329861] vfio-pci 0000:08:00.0: enabling device (0000 -> 0003)
> 
> - Below is guest log, from log though the driver has been registered but
>   it reports PCI hardware failure and the timeout for the interrupt.
> 
>   So is this caused by very 'slow' forward interrupt handling?  Juno
>   board uses GICv2 (I think it has GICv2m extension).
> 
> [...]
> 
> [    1.024483] sky2 0000:00:01.0 eth0: enabling interface
> [    1.026822] sky2 0000:00:01.0: error interrupt status=0x80000000
> [    1.029155] sky2 0000:00:01.0: PCI hardware error (0x1010)
> [    4.000699] sky2 0000:00:01.0 eth0: Link is up at 1000 Mbps, full duplex, flow control both
> [    4.026116] Sending DHCP requests .
> [    4.026201] sky2 0000:00:01.0: error interrupt status=0x80000000
> [    4.030043] sky2 0000:00:01.0: PCI hardware error (0x1010)
> [    6.546111] ..
> [   14.118106] ------------[ cut here ]------------
> [   14.120672] NETDEV WATCHDOG: eth0 (sky2): transmit queue 0 timed out
> [   14.123555] WARNING: CPU: 0 PID: 0 at net/sched/sch_generic.c:461 dev_watchdog+0x2b4/0x2c0
> [   14.127082] Modules linked in:
> [   14.128631] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.0.0-rc8-00061-ga98f9a047756-dirty #
> [   14.132800] Hardware name: linux,dummy-virt (DT)
> [   14.135082] pstate: 60000005 (nZCv daif -PAN -UAO)
> [   14.137459] pc : dev_watchdog+0x2b4/0x2c0
> [   14.139457] lr : dev_watchdog+0x2b4/0x2c0
> [   14.141351] sp : ffff000010003d70
> [   14.142924] x29: ffff000010003d70 x28: ffff0000112f60c0
> [   14.145433] x27: 0000000000000140 x26: ffff8000fa6eb3b8
> [   14.147936] x25: 00000000ffffffff x24: ffff8000fa7a7c80
> [   14.150428] x23: ffff8000fa6eb39c x22: ffff8000fa6eafb8
> [   14.152934] x21: ffff8000fa6eb000 x20: ffff0000112f7000
> [   14.155437] x19: 0000000000000000 x18: ffffffffffffffff
> [   14.157929] x17: 0000000000000000 x16: 0000000000000000
> [   14.160432] x15: ffff0000112fd6c8 x14: ffff000090003a97
> [   14.162927] x13: ffff000010003aa5 x12: ffff000011315878
> [   14.165428] x11: ffff000011315000 x10: 0000000005f5e0ff
> [   14.167935] x9 : 00000000ffffffd0 x8 : 64656d6974203020
> [   14.170430] x7 : 6575657571207469 x6 : 00000000000000e3
> [   14.172935] x5 : 0000000000000000 x4 : 0000000000000000
> [   14.175443] x3 : 00000000ffffffff x2 : ffff0000113158a8
> [   14.177938] x1 : f2db9128b1f08600 x0 : 0000000000000000
> [   14.180443] Call trace:
> [   14.181625]  dev_watchdog+0x2b4/0x2c0
> [   14.183377]  call_timer_fn+0x20/0x78
> [   14.185078]  expire_timers+0xa4/0xb0
> [   14.186777]  run_timer_softirq+0xa0/0x190
> [   14.188687]  __do_softirq+0x108/0x234
> [   14.190428]  irq_exit+0xcc/0xd8
> [   14.191941]  __handle_domain_irq+0x60/0xb8
> [   14.193877]  gic_handle_irq+0x58/0xb0
> [   14.195630]  el1_irq+0xb0/0x128
> [   14.197132]  arch_cpu_idle+0x10/0x18
> [   14.198835]  do_idle+0x1cc/0x288
> [   14.200389]  cpu_startup_entry+0x24/0x28
> [   14.202251]  rest_init+0xd4/0xe0
> [   14.203804]  arch_call_rest_init+0xc/0x14
> [   14.205702]  start_kernel+0x3d8/0x404
> [   14.207449] ---[ end trace 65449acd5c054609 ]---
> [   14.209630] sky2 0000:00:01.0 eth0: tx timeout
> [   14.211655] sky2 0000:00:01.0 eth0: transmit ring 0 .. 3 report=0 done=0
> [   17.906956] sky2 0000:00:01.0 eth0: Link is up at 1000 Mbps, full duplex, flow control both

I am stucking at the network card cannot receive interrupts in guest
OS.  So took time to look into the code and added some printed info to
help me to understand the detailed flow, below are two main questions
I am confused with them and need some guidance:

- The first question is about the msi usage in network card driver;
  when review the sky2 network card driver [1], it has function
  sky2_test_msi() which is used to decide if can use msi or not.

  The interesting thing is this function will firstly request irq for
  the interrupt and based on the interrupt handler to read back
  register and then can make decision if msi is avalible or not.

  This can work well for host OS, but if we want to passthrough this
  device to guest OS, since the KVM doesn't prepare the interrupt for
  sky2 drivers (no injection or forwarding) thus at this point the
  interrupt handle will not be invorked.  At the end the driver will
  not set flag 'hw->flags |= SKY2_HW_USE_MSI' and this results to not
  use msi in guest OS and rollback to INTx mode.

  My first impression is if we passthrough the devices to guest OS in
  KVM, the PCI-e device can directly use msi;  I tweaked a bit for the
  code to check status value after timeout, so both host OS and guest
  OS can set the flag for msi.

  I want to confirm, if this is the recommended mode for
  passthrough PCI-e device to use msi both in host OS and geust OS?
  Or it's will be fine for host OS using msi and guest OS using
  INTx mode?

- The second question is for GICv2m.  If I understand correctly, when
  passthrough PCI-e device to guest OS, in the guest OS we should
  create below data path for PCI-e devices:
                                                            +--------+
                                                         -> | Memory |
    +-----------+    +------------------+    +-------+  /   +--------+
    | Net card  | -> | PCI-e controller | -> | IOMMU | -
    +-----------+    +------------------+    +-------+  \   +--------+
                                                         -> | MSI    |
                                                            | frame  |
                                                            +--------+

  Since now the master is network card/PCI-e controller but not CPU,
  thus there have no 2 stages for memory accessing (VA->IPA->PA).  In
  this case, if we configure IOMMU (SMMU) for guest OS for address
  translation before switch from host to guest, right?  Or SMMU also
  have two stages memory mapping?

  Another thing confuses me is I can see the MSI frame is mapped to
  GIC's physical address in host OS, thus the PCI-e device can send
  message correctly to msi frame.  But for guest OS, the MSI frame is
  mapped to one IPA memory region, and this region is use to emulate
  GICv2 msi frame rather than the hardware msi frame; thus will any
  access from PCI-e to this region will trap to hypervisor in CPU
  side so KVM hyperviso can help emulate (and inject) the interrupt
  for guest OS?

  Essentially, I want to check what's the expected behaviour for GICv2
  msi frame working mode when we want to passthrough one PCI-e device
  to guest OS and the PCI-e device has one static msi frame for it.

I will continue to look into the code and post at here.  Thanks a lot
for any comment and suggestion!
Leo Yan

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/marvell/sky2.c#n4859
