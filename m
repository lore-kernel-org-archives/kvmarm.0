From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: Re: kvm [2087]: load/store instruction decoding not implemented
Date: Tue, 24 Feb 2015 12:27:06 +0000
Message-ID: <20150224122706.GK11603@redhat.com>
References: <20150224115935.GA26241@redhat.com> <20150224121605.GA21364@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E3C5E46005
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 07:21:31 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id i+9rGvXx3-80 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Feb 2015 07:21:30 -0500 (EST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 0644245FEB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Feb 2015 07:21:28 -0500 (EST)
Content-Disposition: inline
In-Reply-To: <20150224121605.GA21364@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Feb 24, 2015 at 01:16:05PM +0100, Christoffer Dall wrote:
> Hi Rich,
> 
> On Tue, Feb 24, 2015 at 11:59:35AM +0000, Richard W.M. Jones wrote:
> > 
> > https://bugzilla.redhat.com/show_bug.cgi?id=1194366
> > 
> > Has anyone seen this KVM error?  Or have suggestions how to debug it
> > further?
> > 
> >   kvm [2028]: load/store instruction decoding not implemented
> 
> This typically means either (a) you're running an ancient 32-bit guest

It's definitely not (a).

> or (b) your icache/dcache is poluted and you're executing the wrong
> instructions.

I don't know how to tell if it's this.  I debugged this further and it
appears to happen in (guest) __copy_to_user.  See:

https://bugzilla.redhat.com/show_bug.cgi?id=1194366#c8
https://bugzilla.redhat.com/show_bug.cgi?id=1194366#c9

> > 
> > Qemu prints this before crashing:
> > 
> >   error: kvm run failed Function not implemented
> >   (followed by a register dump)
> > 
> > It happens precisely when the guest loads the crc32-arm64.ko module.
> > 
> > Both the guest and host kernel are 4.0.0-0.rc1.git0.1.fc23.aarch64
> > 
> Which hardware is this?  Which distro/rootfs?

APM Mustang A3, Fedora Rawhide.

> Doing anything fancy like device passthrough etc.?  Can you share your
> QEMU cmdline?

Sure it's:

/usr/bin/qemu-system-aarch64 \
    -global virtio-blk-device.scsi=off \
    -nodefconfig \
    -enable-fips \
    -nodefaults \
    -display none \
    -M virt \
    -S \
    -s \
    -cpu host \
    -machine accel=kvm:tcg \
    -m 768 \
    -no-reboot \
    -rtc driftfix=slew \
    -global kvm-pit.lost_tick_policy=discard \
    -drive if=pflash,format=raw,file=/usr/share/AAVMF/AAVMF_CODE.fd,readonly \
    -drive if=pflash,format=raw,file=/tmp/libguestfsoDsxTU/AAVMF_VARS.fd.2 \
    -kernel /var/tmp/.guestfs-1000/appliance.d/kernel \
    -initrd /var/tmp/.guestfs-1000/appliance.d/initrd \
    -device virtio-scsi-device,id=scsi \
    -drive file=/tmp/libguestfsoDsxTU/scratch.1,cache=unsafe,format=raw,id=hd0,if=none \
    -device scsi-hd,drive=hd0 \
    -drive file=/var/tmp/.guestfs-1000/appliance.d/root,snapshot=on,id=appliance,cache=unsafe,if=none \
    -device scsi-hd,drive=appliance \
    -device virtio-serial-device \
    -serial stdio \
    -chardev socket,path=/tmp/libguestfsoDsxTU/guestfsd.sock,id=channel0 \
    -device virtserialport,chardev=channel0,name=org.libguestfs.channel.0 \
    -append 'panic=1 console=ttyAMA0 earlyprintk=pl011,0x9000000 ignore_loglevel efi-rtc=noprobe udevtimeout=6000 udev.event-timeout=6000 no_timer_check acpi=off printk.time=1 cgroup_disable=memory root=/dev/sdb selinux=0 guestfs_verbose=1 TERM=xterm-256color'

Rich.

-- 
Richard Jones, Virtualization Group, Red Hat http://people.redhat.com/~rjones
Read my programming and virtualization blog: http://rwmj.wordpress.com
virt-p2v converts physical machines to virtual machines.  Boot with a
live CD or over the network (PXE) and turn machines into KVM guests.
http://libguestfs.org/virt-v2v
