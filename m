From: Shannon Zhao <zhaoshenglong@huawei.com>
Subject: guest get stuck on stable 4.1.32
Date: Mon, 24 Oct 2016 20:03:33 +0800
Message-ID: <580DF895.1030701@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id B018B40870
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Oct 2016 08:04:13 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 0uASfGaE4iqT for <kvmarm@lists.cs.columbia.edu>;
 Mon, 24 Oct 2016 08:04:10 -0400 (EDT)
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [119.145.14.66])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 97EFE4080B
 for <kvmarm@lists.cs.columbia.edu>; Mon, 24 Oct 2016 08:04:02 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <Marc.Zyngier@arm.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

I have a testcase which fails on host linux kernel 4.1.32. The testcase
is that resetting the guest outside while rebooting inside at the same time.

By the way, the guest kernel is linux 4.4 with debian filesystem.

Here is the qemu command line:

qemu-kvm \
    -smp 4 \
    -enable-kvm \
    -m 1024 -M virt,gic-version=2 \
    -monitor telnet::5444,server,nowait \
    -cpu host -nographic \
    -device virtio-net-device,netdev=net0,mac="52:54:00:12:34:55" \
    -netdev type=tap,id=net0,script=./qemu-ifup,downscript=no \
    -drive file=debian.raw,if=none,id=drive-virtio-disk0,format=raw \
    -device virtio-blk-device,drive=drive-virtio-disk0,id=virtio-disk0 \
    -kernel Image-4.4 \
    -append "console=ttyAMA0 root=/dev/vda1 earlycon=pl011,0x9000000 rw
dhcp"

And the test command is:

# ssh guest_ip reboot;echo system_reset|nc host_ip 5444

After executing above command several times, the guest gets stuck. The
guest log as follow:

...
Architected cp15 timer(s) running at 66.00MHz (virt).
clocksource: arch_sys_counter: mask: 0xffffffffffffff max_cycles:
0xf38bc32cd, max_idle_ns: 440795204298 ns
sched_clock: 56 bits at 66MHz, resolution 15ns, wraps every 2199023255548ns
Console: colour dummy device 80x25
Calibrating delay loop (skipped), value calculated using timer
frequency.. 132.00 BogoMIPS (lpj=264000)
pid_max: default: 32768 minimum: 301
Security Framework initialized
Mount-cache hash table entries: 2048 (order: 2, 16384 bytes)
Mountpoint-cache hash table entries: 2048 (order: 2, 16384 bytes)
Initializing cgroup subsys memory
Initializing cgroup subsys hugetlb
EFI services will not be available.
ASID allocator initialised with 65536 entries

I found the guest is stuck at
while ((now = jiffies) == j) in the function do_xor_speed(). Looks like
there is no timer interrupt injected to guest any more.

And the kernel 4.6 has fixed this bug, but I'm not sure if there is some
way to fix this in stable 4.1.

Thanks,
-- 
Shannon
