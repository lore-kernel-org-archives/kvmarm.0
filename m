From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH] KVM: arm/arm64: vgic: Add debugfs vgic-state file
Date: Tue, 24 Jan 2017 12:25:25 +0000
Message-ID: <fde51e21-5f90-b2de-72a6-3ba04ed04893@arm.com>
References: <20170120103330.13858-1-christoffer.dall@linaro.org>
 <524751ae-8e17-f9a0-88c6-95d4614478af@arm.com> <20170124105833.GM15850@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 28F4440430
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Jan 2017 07:24:02 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 932PawHxB0Ij for <kvmarm@lists.cs.columbia.edu>;
 Tue, 24 Jan 2017 07:24:00 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 873834019A
 for <kvmarm@lists.cs.columbia.edu>; Tue, 24 Jan 2017 07:24:00 -0500 (EST)
In-Reply-To: <20170124105833.GM15850@cbox>
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
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

On 24/01/17 10:58, Christoffer Dall wrote:
> On Tue, Jan 24, 2017 at 10:23:57AM +0000, Andre Przywara wrote:
>> Hi,
>>
>> so I gave this patch (adapted to live without the soft_pending state)
>> some testing on my machines (Midway, Juno, GICv3 ITS h/w) and it seemed
>> to work well - at least if one is nice and starts only one process
>> accessing vgic-state (see below). I caught some IRQs red-handed and the
>> output looked plausible.
>> The only comment I have is that "MPIDR" is a misleading header name for
>> that column. It's actually a union with the GICv2 targets field, which
>> is a bitmask of the targetting VCPUs. So the output looks more like a
>> bitmask and not an MPIDR on many machines. But that's just cosmetic.
>>
>> Just discovered one thing: As soon as a second task is reading the file
>> (with "while [ 1 ]; do cat vgic-state > /dev/null; done &" in the
>> background, for instance), I get this splat on the host:
>>
>> [60796.007461] Unable to handle kernel NULL pointer dereference at
>> virtual address 00000008
>> [60796.015538] pgd = ffff800974e30000
>> [60796.018952] [00000008] *pgd=00000009f4d0a003[60796.023067] Internal
>> error: Oops: 96000006 [#1] PREEMPT SMP
>> [60796.028588] Modules linked in:
>> [60796.031626] CPU: 3 PID: 5690 Comm: cat Tainted: G        W
>> 4.9.0-00026-ge24503e-dirty #444
>> [60796.040326] Hardware name: ARM Juno development board (r0) (DT)
>> [60796.046190] task: ffff80097231ab00 task.stack: ffff800973894000
>> [60796.052059] PC is at iter_next+0x18/0x80
>> [60796.055946] LR is at debug_next+0x38/0x90
>> [60796.059917] pc : [<ffff0000080c4b38>] lr : [<ffff0000080c4bd8>]
>> pstate: 20000145
>> [60796.067240] sp : ffff800973897cc0
>> [60796.070522] x29: ffff800973897cc0 x28: ffff800973897d60
>> [60796.075805] x27: 0000000033c61000 x26: ffff800974e4dd40
>> [60796.081086] x25: 0000000000010000 x24: ffff800974da6380
>> [60796.086360] x23: ffff800973897eb8 x22: 0000000000000000
>> [60796.091634] x21: 0000000000000459 x20: ffff800973897d68
>> [60796.096908] x19: 0000000000000000 x18: 0000000000000001
>> [60796.102181] x17: 000000000041a1c8 x16: ffff000008275258
>> [60796.107456] x15: ffff800975546457 x14: 0000ffffa3912a94
>> [60796.112730] x13: 0000000000000000 x12: 0000000005f5e0ff
>> [60796.118004] x11: 0000000000000000 x10: 000000000000000c
>> [60796.123282] x9 : 000000000000000f x8 : ffff800973897b08
>> [60796.128555] x7 : 0000000000000004 x6 : ffff800975546459
>> [60796.133829] x5 : 0000000000000001 x4 : 0000000000000001
>> [60796.139103] x3 : ffff0000080c4ba0 x2 : ffff800973897d68
>> [60796.144377] x1 : ffff800972074000 x0 : ffff0000080c4bd8
>> [60796.149650]
>> [60796.151128] Process cat (pid: 5690, stack limit = 0xffff800973894020)
>> [60796.157508] Stack: (0xffff800973897cc0 to 0xffff800973898000)
>> [60796.163203] 7cc0: ffff800973897ce0 ffff0000080c4bd8 0000000000000000
>> ffff800974fc9a00
>> [60796.170962] 7ce0: ffff800973897d00 ffff0000082a14d0 ffff800974e4dd00
>> ffff800974fc9a00
>> [60796.178721] 7d00: ffff800973897d70 ffff000008415410 0000000000000000
>> ffff800974da6380
>> [60796.186479] 7d20: 0000000033c61000 0000000000010000 ffff800973897eb8
>> ffff0000090bc1a8
>> [60796.194237] 7d40: 0000000000000123 000000000000003f ffff000008b12000
>> ffff800973894000
>> [60796.201995] 7d60: 000000000000000d 000000000000000e ffff800973897dc0
>> ffff000008272d88
>> [60796.209753] 7d80: ffff800974da6380 ffff800973897eb8 0000000000010000
>> 0000000033c61000
>> [60796.217514] 7da0: 0000000060000000 0000000000000015 0000000000000000
>> 0000000100000000
>> [60796.225277] 7dc0: ffff800973897e50 ffff000008273d00 0000000000010000
>> ffff800974da6380
>> [60796.233035] 7de0: 0000000033c61000 ffff800973897eb8 ffff800973897e20
>> ffff000008273be8
>> [60796.240794] 7e00: ffff800974da6380 0000000000010000 0000000000000000
>> ffff800973897eb8
>> [60796.248552] 7e20: ffff800973897e50 ffff000008273cdc 0000000000010000
>> ffff800974da6380
>> [60796.256310] 7e40: 0000000033c61000 ffff800973897eb8 ffff800973897e80
>> ffff0000082752ac
>> [60796.264069] 7e60: ffff800974da6380 ffff800974da6380 0000000033c61000
>> 0000000000010000
>> [60796.271830] 7e80: 0000000000000000 ffff0000080836f0 0000000000000000
>> 000000000041a310
>> [60796.279588] 7ea0: ffffffffffffffff 0000ffffa39cd45c 0000000000000123
>> 0000000000000000
>> [60796.287346] 7ec0: 0000000000000003 0000000033c61000 0000000000010000
>> 0000000000000000
>> [60796.295103] 7ee0: 0000000000011011 0000000000000001 0000000000000011
>> 0000000000000002
>> [60796.302861] 7f00: 000000000000003f 1f3c201f7372686b 00000000ffffffff
>> 0000000000000030
>> [60796.310618] 7f20: 0000000000000038 0000000000000000 0000ffffa3912a94
>> 0000ffffa3a47588
>> [60796.318376] 7f40: 0000000000000000 000000000041a1c8 0000ffffe30bd910
>> 0000000000010000
>> [60796.326133] 7f60: 000000000041a310 0000000033c61000 0000000000000003
>> 000000007fffe000
>> [60796.333891] 7f80: 00000000004088d0 0000000000000000 0000000000000000
>> 0000000000000000
>> [60796.341649] 7fa0: 0000000000010000 0000ffffe30bdbb0 0000000000404dcc
>> 0000ffffe30bdbb0
>> [60796.349407] 7fc0: 0000ffffa39cd45c 0000000060000000 0000000000000003
>> 000000000000003f
>> [60796.357164] 7fe0: 0000000000000000 0000000000000000 0000000000000000
>> 0000000000000000
>> [60796.364917] Call trace:
>> [60796.367342] Exception stack(0xffff800973897af0 to 0xffff800973897c20)
>> [60796.373729] 7ae0:                                   0000000000000000
>> 0001000000000000
>> [60796.381492] 7b00: ffff800973897cc0 ffff0000080c4b38 ffff800973897b20
>> ffff000008de460f
>> [60796.389251] 7b20: ffff800973897ba0 ffff0000082a1a38 ffff800974e4dd00
>> ffff800973897c10
>> [60796.397009] 7b40: ffff000008de45d0 ffff800972234dc0 ffff800973897eb8
>> ffff800974da6380
>> [60796.404767] 7b60: 0000000000010000 ffff800974e4dd40 0000000033c61000
>> ffff800973897d60
>> [60796.412529] 7b80: 0000000000000002 ffff000008b633c8 ffff0000080c4bd8
>> ffff800972074000
>> [60796.420287] 7ba0: ffff800973897d68 ffff0000080c4ba0 0000000000000001
>> 0000000000000001
>> [60796.428045] 7bc0: ffff800975546459 0000000000000004 ffff800973897b08
>> 000000000000000f
>> [60796.435802] 7be0: 000000000000000c 0000000000000000 0000000005f5e0ff
>> 0000000000000000
>> [60796.443560] 7c00: 0000ffffa3912a94 ffff800975546457 ffff000008275258
>> 000000000041a1c8
>> [60796.451320] [<ffff0000080c4b38>] iter_next+0x18/0x80
>> [60796.456239] [<ffff0000080c4bd8>] debug_next+0x38/0x90
>> [60796.461247] [<ffff0000082a14d0>] seq_read+0x310/0x420
>> [60796.466256] [<ffff000008415410>] full_proxy_read+0x60/0x88
>> [60796.471693] [<ffff000008272d88>] __vfs_read+0x48/0x130
>> [60796.476784] [<ffff000008273d00>] vfs_read+0x88/0x140
>> [60796.481703] [<ffff0000082752ac>] SyS_read+0x54/0xb0
>> [60796.486538] [<ffff0000080836f0>] el0_svc_naked+0x24/0x28
>> [60796.491804] Code: f9000bf3 aa0003f3 aa1e03e0 d503201f (b9400a60)
>> [60796.498076] ---[ end trace 31bfd09d844bbfc9 ]---
>>
>> As I didn't understand the seq_* semantics in the first place, I didn't
>> have a look yet what could cause this.
> 
> Nice catch, I'll have a look at this.
> 
> Just so I'm sure, these are two processes reading the vgic-state file
> for the same single VM, right?

Yes, just one VM. I was about to write a small test program which is a
bit more nasty and launches <n> threads all doing lseek();read(); on the
same file in a loop, but it turned out that this isn't necessary ;-)
I have that now working, so I can give this a test later.

I was wondering if you could ditch that lseek / offset setting feature
at all? The smaller debugfs files don't support it as well (ESPIPE on
lseek()). Is that an option when setting up the seq interface?

Cheers,
Andre.
