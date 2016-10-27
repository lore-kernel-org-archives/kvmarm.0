From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: guest get stuck on stable 4.1.32
Date: Thu, 27 Oct 2016 11:28:12 +0200
Message-ID: <20161027092812.GB14734@cbox>
References: <580DF895.1030701@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7F89D40419
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2016 05:28:14 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id djoocTGw+Wyw for <kvmarm@lists.cs.columbia.edu>;
 Thu, 27 Oct 2016 05:28:13 -0400 (EDT)
Received: from mail-lf0-f51.google.com (mail-lf0-f51.google.com
 [209.85.215.51])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 248E740402
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2016 05:28:13 -0400 (EDT)
Received: by mail-lf0-f51.google.com with SMTP id x79so25784408lff.0
 for <kvmarm@lists.cs.columbia.edu>; Thu, 27 Oct 2016 02:28:17 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <580DF895.1030701@huawei.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Shannon Zhao <zhaoshenglong@huawei.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Oct 24, 2016 at 08:03:33PM +0800, Shannon Zhao wrote:
> Hi,
> 
> I have a testcase which fails on host linux kernel 4.1.32. The testcase
> is that resetting the guest outside while rebooting inside at the same time.
> 
> By the way, the guest kernel is linux 4.4 with debian filesystem.
> 
> Here is the qemu command line:
> 
> qemu-kvm \
>     -smp 4 \
>     -enable-kvm \
>     -m 1024 -M virt,gic-version=2 \
>     -monitor telnet::5444,server,nowait \
>     -cpu host -nographic \
>     -device virtio-net-device,netdev=net0,mac="52:54:00:12:34:55" \
>     -netdev type=tap,id=net0,script=./qemu-ifup,downscript=no \
>     -drive file=debian.raw,if=none,id=drive-virtio-disk0,format=raw \
>     -device virtio-blk-device,drive=drive-virtio-disk0,id=virtio-disk0 \
>     -kernel Image-4.4 \
>     -append "console=ttyAMA0 root=/dev/vda1 earlycon=pl011,0x9000000 rw
> dhcp"
> 
> And the test command is:
> 
> # ssh guest_ip reboot;echo system_reset|nc host_ip 5444
> 
> After executing above command several times, the guest gets stuck. The
> guest log as follow:
> 
> ...
> Architected cp15 timer(s) running at 66.00MHz (virt).
> clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles:
> 0xf38bc32cd, max_idle_ns: 440795204298 ns
> sched_clock: 56 bits at 66MHz, resolution 15ns, wraps every 2199023255548ns
> Console: colour dummy device 80x25
> Calibrating delay loop (skipped), value calculated using timer
> frequency.. 132.00 BogoMIPS (lpj=264000)
> pid_max: default: 32768 minimum: 301
> Security Framework initialized
> Mount-cache hash table entries: 2048 (order: 2, 16384 bytes)
> Mountpoint-cache hash table entries: 2048 (order: 2, 16384 bytes)
> Initializing cgroup subsys memory
> Initializing cgroup subsys hugetlb
> EFI services will not be available.
> ASID allocator initialised with 65536 entries
> 
> I found the guest is stuck at
> while ((now = jiffies) == j) in the function do_xor_speed(). Looks like
> there is no timer interrupt injected to guest any more.
> 
> And the kernel 4.6 has fixed this bug, but I'm not sure if there is some
> way to fix this in stable 4.1.
> 

Hmmm, v4.1 still used edge-triggered semantics for the timer, which was
causing reset issues with UEFI, so I wonder if that's related?

You could attempt at backporting the rework of the timers:
https://lists.cs.columbia.edu/pipermail/kvmarm/2015-September/016588.html

You might also need these commits on top:
0e3dfda91d9fe8e2c4d0b5d21434b173a241eeaf
1c5631c73fc2261a5df64a72c155cb53dcdc0c45

Thanks,
-Christoffer
