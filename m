From: James Morse <james.morse@arm.com>
Subject: [PATCH 0/2] KVM: arm/arm64: Restore host physical timer access on
 panic
Date: Tue, 25 Apr 2017 18:02:43 +0100
Message-ID: <20170425170245.4294-1-james.morse@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 74D8840C49
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 13:00:57 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id va1jdFAdL3h0 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 25 Apr 2017 13:00:56 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E4ECA40C46
 for <kvmarm@lists.cs.columbia.edu>; Tue, 25 Apr 2017 13:00:55 -0400 (EDT)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi!

On arm64, with a single CPU when I trigger hyp_panic() with the guest
registers loaded, I get two traces:

[ 8736.164022] Kernel panic - not syncing: HYP panic:
[ 8736.164022] PS:600002c9 PC:0000800000a841e8 ESR:96000046
[ 8736.164022] FAR:0000000000000880 HPFAR:0000000000800800 PAR:1d00007edbadc0de
[ 8736.164022] VCPU:0000800974430000
[ 8736.164022]
[ 8736.187686] CPU: 0 PID: 2449 Comm: kvm-vcpu-0 Not tainted 4.11.0-rc7-00002-ga55c0ba01d81-dirty #7487
[ 8736.196869] Hardware name: ARM Juno development board (r1) (DT)
[ 8736.202822] Call trace:
[ 8736.205300] [<ffff000008089c80>] dump_backtrace+0x0/0x238
[ 8736.210736] [<ffff000008089ecc>] show_stack+0x14/0x20
[ 8736.215824] [<ffff00000847a274>] dump_stack+0xbc/0xf8
[ 8736.220912] [<ffff0000081e0e60>] panic+0x124/0x29c
[ 8736.225737] [<ffff0000081e0d3c>] panic+0x0/0x29c
[ 8736.230486] Kernel Offset: disabled
[ 8736.234024] Memory Limit: none
[ 8736.237127] ---[ end Kernel panic - not syncing: HYP panic:
[ 8736.237127] PS:600002c9 PC:0000800000a841e8 ESR:96000046
[ 8736.237127] FAR:0000000000000880 HPFAR:0000000000800800 PAR:1d00007edbadc0de
[ 8736.237127] VCPU:0000800974430000
[ 8736.237127]
[ 8736.259771] Kernel panic - not syncing: HYP panic:
[ 8736.259771] PS:200002c9 PC:0000200000080000 ESR:86000004
[ 8736.259771] FAR:0000200000080000 HPFAR:0000000000800800 PAR:0000000000000000
[ 8736.259771] VCPU:0000800974430000
[ 8736.259771]
[ 8736.281678] CPU: 0 PID: 2449 Comm: kvm-vcpu-0 Not tainted 4.11.0-rc7-00002-ga55c0ba01d81-dirty #7487
[ 8736.290811] Hardware name: ARM Juno development board (r1) (DT)
[ 8736.296726] Call trace:
[ 8736.299185] [<ffff000008089c80>] dump_backtrace+0x0/0x238
[ 8736.304588] [<ffff000008089ecc>] show_stack+0x14/0x20
[ 8736.309642] [<ffff00000847a274>] dump_stack+0xbc/0xf8
[ 8736.314698] [<ffff0000081e0e60>] panic+0x124/0x29c
[ 8736.319495] [<ffff0000081e0d3c>] panic+0x0/0x29c
[ 8736.324120] Kernel Offset: disabled
[ 8736.327611] Memory Limit: none
[ 8736.330687] ---[ end Kernel panic - not syncing: HYP panic:
[ 8736.330687] PS:200002c9 PC:0000200000080000 ESR:86000004
[ 8736.330687] FAR:0000200000080000 HPFAR:0000000000800800 PAR:0000000000000000
[ 8736.330687] VCPU:0000800974430000
[ 8736.330687]

This is because the physical timer access is still trapped to EL2, causing
a second __guest_exit(), this time without the host context on the stack.

Once I get 32bit hyp_panic() to restore the hosts banked registers, I get the
same:
[  164.799341] Kernel panic - not syncing:
[  164.799341] HYP panic: FIQ   PC:40010778 CPSR:900001d3
[  164.826708] CPU: 0 PID: 1933 Comm: qemu-system-arm Not tainted 4.11.0-rc6+ #196
[  164.848813] Hardware name: ARM-Versatile Express
[  164.862798] [<c022fbf8>] (unwind_backtrace) from [<c0229e40>] (show_stack+0x18/0x1c)
[  164.886218] [<c0229e40>] (show_stack) from [<c0516590>] (dump_stack+0x94/0xa8)
[  164.908071] [<c0516590>] (dump_stack) from [<c030a77c>] (panic+0xe4/0x270)
[  164.928864] [<c030a77c>] (panic) from [<c0213998>] (kvm_arch_vcpu_ioctl_run+0x1e4/0x6ac)
[  164.953332] [<c0213998>] (kvm_arch_vcpu_ioctl_run) from [<c020a3a0>] (kvm_vcpu_ioctl+0x2e4/0x808)
[  164.980184] [<c020a3a0>] (kvm_vcpu_ioctl) from [<c03806c8>] (do_vfs_ioctl+0xa8/0x7bc)
[  165.003880] [<c03806c8>] (do_vfs_ioctl) from [<c0380e18>] (SyS_ioctl+0x3c/0x64)
[  165.026002] [<c0380e18>] (SyS_ioctl) from [<c02259e0>] (ret_fast_syscall+0x0/0x34)
[  165.048911] ---[ end Kernel panic - not syncing:
[  165.048911] HYP panic: FIQ   PC:40010778 CPSR:900001d3
[  165.078657] Kernel panic - not syncing:
[  165.078657] HYP panic: PABRT PC:ee526000 CPSR:600000da
[  165.106031] CPU: 0 PID: 1933 Comm: qemu-system-arm Not tainted 4.11.0-rc6+ #196
[  165.128126] Hardware name: ARM-Versatile Express
[  165.142072] [<c022fbf8>] (unwind_backtrace) from [<c0229e40>] (show_stack+0x18/0x1c)
[  165.165511] [<c0229e40>] (show_stack) from [<c0516590>] (dump_stack+0x94/0xa8)
[  165.187351] [<c0516590>] (dump_stack) from [<c030a77c>] (panic+0xe4/0x270)
[  165.208151] [<c030a77c>] (panic) from [<c0213998>] (kvm_arch_vcpu_ioctl_run+0x1e4/0x6ac)
[  165.232630] [<c0213998>] (kvm_arch_vcpu_ioctl_run) from [<c020a3a0>] (kvm_vcpu_ioctl+0x2e4/0x808)
[  165.259464] [<c020a3a0>] (kvm_vcpu_ioctl) from [<c03806c8>] (do_vfs_ioctl+0xa8/0x7bc)
[  165.283150] [<c03806c8>] (do_vfs_ioctl) from [<c0380e18>] (SyS_ioctl+0x3c/0x64)
[  165.305247] [<c0380e18>] (SyS_ioctl) from [<c02259e0>] (ret_fast_syscall+0x0/0x34)
[  165.328163] ---[ end Kernel panic - not syncing:
[  165.328163] HYP panic: PABRT PC:ee526000 CPSR:600000da


Thanks,

James Morse (2):
  KVM: arm: Restore banked registers and physical timer access on
    hyp_panic()
  KVM: arm64: Restore host physical timer access on hyp_panic()

 arch/arm/kvm/hyp/switch.c   | 2 ++
 arch/arm64/kvm/hyp/switch.c | 1 +
 2 files changed, 3 insertions(+)

-- 
2.10.1
