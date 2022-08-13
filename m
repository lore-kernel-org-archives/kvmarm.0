Return-Path: <kvmarm-bounces@lists.cs.columbia.edu>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mm01.cs.columbia.edu (mm01.cs.columbia.edu [128.59.11.253])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B40B1C19F2D
	for <kvmarm@archiver.kernel.org>; Sat, 13 Aug 2022 11:59:37 +0000 (UTC)
Received: from localhost (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 0782A4F4E8;
	Sat, 13 Aug 2022 07:59:37 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
	by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id C1gt8Yg07p1N; Sat, 13 Aug 2022 07:59:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu (localhost [127.0.0.1])
	by mm01.cs.columbia.edu (Postfix) with ESMTP id 578D44F4DF;
	Sat, 13 Aug 2022 07:59:35 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1978B4ECE1
 for <kvmarm@lists.cs.columbia.edu>; Sat, 13 Aug 2022 07:11:42 -0400 (EDT)
X-Virus-Scanned: at lists.cs.columbia.edu
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id oU5X4GH0DSuf for <kvmarm@lists.cs.columbia.edu>;
 Sat, 13 Aug 2022 07:11:40 -0400 (EDT)
Received: from vmicros1.altlinux.org (vmicros1.altlinux.org [194.107.17.57])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E0AC04ECC5
 for <kvmarm@lists.cs.columbia.edu>; Sat, 13 Aug 2022 07:11:39 -0400 (EDT)
Received: from imap.altlinux.org (imap.altlinux.org [194.107.17.38])
 by vmicros1.altlinux.org (Postfix) with ESMTP id 5416072C90B;
 Sat, 13 Aug 2022 14:11:38 +0300 (MSK)
Received: from altlinux.org (sole.flsd.net [185.75.180.6])
 by imap.altlinux.org (Postfix) with ESMTPSA id 314A54A46FE;
 Sat, 13 Aug 2022 14:11:38 +0300 (MSK)
Date: Sat, 13 Aug 2022 14:11:37 +0300
From: Vitaly Chikunov <vt@altlinux.org>
To: Marc Zyngier <maz@kernel.org>
Subject: Re: qemu-system-aarch64: Failed to retrieve host CPU features
Message-ID: <20220813111137.5plgwrfnosolj2bp@altlinux.org>
References: <20220812021427.cwenhciuftgtaj64@altlinux.org>
 <20220812084529.ur5qcyws5qvoyvuc@altlinux.org>
 <CAFEAcA9BuSe4SwpoWTALURaxoj-8U2y83k=und7oKrZBggLarQ@mail.gmail.com>
 <87h72hv71u.wl-maz@kernel.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87h72hv71u.wl-maz@kernel.org>
X-Mailman-Approved-At: Sat, 13 Aug 2022 07:59:34 -0400
Cc: qemu-arm@nongnu.org, "Dmitry V. Levin" <ldv@altlinux.org>,
 kvmarm <kvmarm@lists.cs.columbia.edu>, QEMU Developers <qemu-devel@nongnu.org>
X-BeenThere: kvmarm@lists.cs.columbia.edu
X-Mailman-Version: 2.1.14
Precedence: list
List-Id: Where KVM/ARM decisions are made <kvmarm.lists.cs.columbia.edu>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu

Marc,

On Fri, Aug 12, 2022 at 04:02:37PM +0100, Marc Zyngier wrote:
> On Fri, 12 Aug 2022 10:25:55 +0100,
> Peter Maydell <peter.maydell@linaro.org> wrote:
> > 
> > I've added some more relevant mailing lists to the cc.
> > 
> > On Fri, 12 Aug 2022 at 09:45, Vitaly Chikunov <vt@altlinux.org> wrote:
> > > On Fri, Aug 12, 2022 at 05:14:27AM +0300, Vitaly Chikunov wrote:
> > > > I noticed that we starting to get many errors like this:
> > > >
> > > >   qemu-system-aarch64: Failed to retrieve host CPU features
> > > >
> > > > Where many is 1-2% per run, depends on host, host is Kunpeng-920, and
> > > > Linux kernel is v5.15.59, but it started to appear months before that.
> > > >
> > > > strace shows in erroneous case:
> > > >
> > > >   1152244 ioctl(9, KVM_CREATE_VM, 0x30)   = -1 EINTR (Interrupted system call)
> > > >
> > > > And I see in target/arm/kvm.c:kvm_arm_create_scratch_host_vcpu:
> > > >
> > > >     vmfd = ioctl(kvmfd, KVM_CREATE_VM, max_vm_pa_size);
> > > >     if (vmfd < 0) {
> > > >         goto err;
> > > >     }
> > > >
> > > > Maybe it should restart ioctl on EINTR?
> > > >
> > > > I don't see EINTR documented in ioctl(2) nor in Linux'
> > > > Documentation/virt/kvm/api.rst for KVM_CREATE_VM, but for KVM_RUN it
> > > > says "an unmasked signal is pending".
> > >
> > > I am suggested that almost any blocking syscall could return EINTR, so I
> > > checked the strace log and it does not show evidence of arriving a signal,
> > > the log ends like this:
> > >
> > >   1152244 openat(AT_FDCWD, "/dev/kvm", O_RDWR|O_CLOEXEC) = 9
> > >   1152244 ioctl(9, KVM_CHECK_EXTENSION, KVM_CAP_ARM_VM_IPA_SIZE) = 48
> > >   1152244 ioctl(9, KVM_CREATE_VM, 0x30)   = -1 EINTR (Interrupted system call)
> > >   1152244 close(9)                        = 0
> > >   1152244 newfstatat(2, "", {st_dev=makedev(0, 0xd), st_ino=57869925, st_mode=S_IFIFO|0600, st_nlink=1, st_uid=517, st_gid=517, st_blksize=4096, st_blocks=0, st_size=0, st_atime=1660268019 /* 2022-08-12T01:33:39.850436293+0000 */, st_atime_nsec=850436293, st_mtime=1660268019 /* 2022-08-12T01:33:39.850436293+0000 */, st_mtime_nsec=850436293, st_ctime=1660268019 /* 2022-08-12T01:33:39.850436293+0000 */, st_ctime_nsec=850436293}, AT_EMPTY_PATH) = 0
> > >   1152244 write(2, "qemu-system-aarch64: Failed to r"..., 58) = 58
> > >   1152244 exit_group(1)                   = ?
> > >   1152245 <... clock_nanosleep resumed> <unfinished ...>) = ?
> > >   1152245 +++ exited with 1 +++
> > >   1152244 +++ exited with 1 +++
> > 
> > KVM folks: should we expect that KVM_CREATE_VM might fail EINTR
> > and need retrying?
> 
> In general, yes. But for this particular one, this is pretty odd.
> 
> The only path I can so far see that would match this behaviour is if
> mm_take_all_locks() (called from __mmu_notifier_register()) was
> getting interrupted by a signal (I'm looking at a 5.19-ish kernel,
> which may slightly differ from the 5.15 mentioned above).
> 
> But as Vitaly points out, it doesn't seem to be a signal delivered
> here.
> 
> Vitaly: could you please share your exact test case (full qemu command
> line), and instrument your kernel to see if mm_take_all_locks() is the
> one failing?

Full command is `qemu-system-aarch64 -M accel=kvm:tcg -m 4096M -smp
  cores=8 -nodefaults -nographic -no-reboot -fsdev
  local,id=root,path=/,security_model=none,multidevs=remap -device
  virtio-9p-pci,fsdev=root,mount_tag=/dev/root -device virtio-rng-pci
  -serial mon:stdio -kernel /boot/vmlinuz-5.18.16-un-def-alt1 -initrd
  /usr/src/tmp/initramfs-5.18.16-un-def-alt1.img -sandbox on,spawn=deny -M
  virt,gic-version=3 -cpu max -append 'console=ttyAMA0 mitigations=off
  nokaslr quiet panic=-1 SCRIPT=/usr/src/tmp/tmp.458pkF5r8d'`.

But a minified reproducer is `qemu-system-aarch64 -M virt,accel=kvm -cpu max -kernel qwe`. 

I traced with kprobe event tracer with the probes:

  echo 'p kvm_dev_ioctl'               > kprobe_events
  echo 'r kvm_dev_ioctl $retval'      >> kprobe_events
  echo 'p mm_take_all_locks'          >> kprobe_events
  echo 'r mm_take_all_locks $retval'  >> kprobe_events

Then run reproducer in the loop

  for ((i=0;i<100;i++));do echo $i; strace -fvo bb.$i qemu-system-aarch64 -M virt,accel=kvm -cpu max -kernel qwe 2>&1 | grep Failed && break; done

And on 97th iteration it's failed, strace log to check that PID is the same with
the following trace:

  3611463 ioctl(9, KVM_CREATE_VM, 0x30)   = -1 EINTR (Interrupted system call)

Event trace log:

  qemu-system-aar-3611463 [002] d.... 342920.535549: p_kvm_dev_ioctl_0: (kvm_dev_ioctl+0x0/0x910)
  qemu-system-aar-3611463 [002] d.... 342920.535635: p_mm_take_all_locks_0: (mm_take_all_locks+0x0/0x390)
  qemu-system-aar-3611463 [002] ..... 342920.535657: r_mm_take_all_locks_0: (__mmu_notifier_register+0x44/0x200 <- mm_take_all_locks) arg1=0xfffffffc
  qemu-system-aar-3611463 [002] ..... 342920.535695: r_kvm_dev_ioctl_0: (__arm64_sys_ioctl+0xcc/0x124 <- kvm_dev_ioctl) arg1=0xfffffffffffffffc

So that's mm_take_all_locks returns EINTR.

(I tried also to make C reproducer which opens /dev/kvm and call
`ioctl(kvm, KVM_CREATE_VM, 0)` in the loop and it does not reproduce the
problem, so it seems it's also something additional that QEMU does.)

Thanks,
_______________________________________________
kvmarm mailing list
kvmarm@lists.cs.columbia.edu
https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
