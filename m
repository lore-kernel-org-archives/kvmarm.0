From: Itaru Kitayama <itaru.kitayama@riken.jp>
Subject: Unable to use perf in VM
Date: Wed, 30 Nov 2016 07:04:50 +0900
Message-ID: <70374841-ecb1-a6c3-ed43-0f39e2d5fec2@riken.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3764D40598
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2016 17:04:07 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id orExxWYMdcAQ for <kvmarm@lists.cs.columbia.edu>;
 Tue, 29 Nov 2016 17:04:05 -0500 (EST)
Received: from postman.riken.jp (postman4.riken.jp [134.160.33.86])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9A46A40542
 for <kvmarm@lists.cs.columbia.edu>; Tue, 29 Nov 2016 17:04:04 -0500 (EST)
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Hoan Tran <hotran@apm.com>, Tai Tri Nguyen <ttnguyen@apm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

In a VM (virsh controlled, KVM acceleration enabled) on a recent
kvmarm kernel host, I find I am unable to use perf to obtain
performance statistics for a complex task like kernel build.
(I've verified this is seen with a Fedora 25 VM and host combination
as well)
APM folks CC'ed think this might be caused by a bug in the core PMU 
framework code, thus I'd like to have experts opinion on this issue.

[root@localhost linux]# perf stat -B make
   CHK     include/config/kernel.release
[  119.617684] git[1144]: undefined instruction: pc=fffffc000808ff30
[  119.623040] Code: 51000442 92401042 d51b9ca2 d5033fdf (d53b9d40)
[  119.627607] Internal error: undefined instruction: 0 [#1] SMP
[  119.633600] Modules linked in: ip6t_rpfilter ip6t_REJECT 
nf_reject_ipv6 xt_conntrack ip_set nfnetlink ebtable_broute bridge stp 
llc ebtable_nat ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 
nf_nat_ipv6 ip6table_raw ip6table_mangle ip6table_security iptable_nat 
nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack 
iptable_raw iptable_mangle iptable_security ebtable_filter ebtables 
ip6table_filter ip6_tables vfat fat chipreg mtd virtio_net qemu_fw_cfg 
nfsd auth_rpcgss nfs_acl lockd grace sunrpc xfs libcrc32c virtio_console 
virtio_scsi gpio_keys virtio_mmio virtio_ring virtio
[  119.677249] CPU: 0 PID: 1144 Comm: git Tainted: P                4.8.0 #3
[  119.682480] Hardware name: QEMU KVM Virtual Machine, BIOS 0.0.0 
02/06/2015
[  119.687660] task: fffffe00ea96cb00 task.stack: fffffe00e6a60000
[  119.692167] PC is at armv8pmu_read_counter+0x30/0x68
[  119.695973] LR is at armpmu_event_update+0x34/0x98
[  119.699615] pc : [<fffffc000808ff30>] lr : [<fffffc00086fe6c4>] 
pstate: 800001c5
[  119.705137] sp : fffffe00e6a63790
[  119.707663] x29: fffffe00e6a63790 x28: fffffe00f275ca08
[  119.711875] x27: 0000000000000000 x26: 0000000000000001
[  119.716097] x25: fffffe00fff22328 x24: 000000001af18c08
[  119.720345] x23: fffffe00f275ca00 x22: fffffe00ff8d5c00
[  119.724589] x21: ffffffff87b2b5f5 x20: fffffe00e6a53800
[  119.728827] x19: fffffe00e6a539c0 x18: 0000000000000000
[  119.733018] x17: 000003ff8b323c20 x16: 0000000000000000
[  119.737274] x15: ffffffffffffffff x14: 726573752f656369
[  119.741395] x13: 6c732e726573752f x12: 0000000000000000
[  119.745596] x11: 0000000000010000 x10: 0000000000000001
[  119.749800] x9 : 0000000000000000 x8 : 0000000000000001
[  119.754042] x7 : 0000000000000000 x6 : 000000d2ea7d1b28
[  119.758232] x5 : 0000000000000002 x4 : 00000200f7220000
[  119.762446] x3 : 0000000000000000 x2 : 0000000000000000
[  119.766655] x1 : fffffc000808ff00 x0 : 0000000000000004
[  119.770757]
[  119.771947] Process git (pid: 1144, stack limit = 0xfffffe00e6a60020)
[  119.776829] Stack: (0xfffffe00e6a63790 to 0xfffffe00e6a64000)
[  119.781234] 3780:                                   fffffe00e6a637c0 
fffffc00086fe790
[  119.787139] 37a0: fffffe00e6a53800 fffffe00e6a53800 fffffe00ff8d5c00 
0000000000000001
[  119.793007] 37c0: fffffe00e6a637e0 fffffc00086fe7e4 fffffe00fff22210 
fffffe00e6a53800
[  119.798999] 37e0: fffffe00e6a63810 fffffc00081cc260 fffffe00e6a53800 
fffffe00e6a53800
[  119.804893] 3800: fffffe00fff22418 fffffe00fff2241c fffffe00e6a63860 
fffffc00081cc404
[  119.810826] 3820: fffffe00f275ca00 fffffe00e6a53800 fffffe00fff22418 
fffffe00fff2241c
[  119.816766] 3840: fffffe00f275ca00 fffffe00e6a53800 fffffe00fff22328 
0000000000000007
[  119.822690] 3860: fffffe00e6a638b0 fffffc00081cc900 fffffe00f275ca00 
fffffe00e6a53800
[  119.828597] 3880: fffffe00fff22328 fffffe00f275ca58 fffffe00f275ca48 
fffffe00ea96d3b0
[  119.834537] 38a0: fffffc0008d7ba00 fffffe00fff22328 fffffe00e6a638f0 
fffffc00081cca00
[  119.840379] 38c0: fffffc0008cf7000 fffffe00ea96d3a0 fffffc0008d7c2a0 
fffffe00f275ca00
[  119.846291] 38e0: fffffe00ea96cb00 fffffc00081ce554 fffffe00e6a63900 
fffffc00081ce560
[  119.852112] 3900: fffffe00e6a63990 fffffc000884655c fffffc0008d7ba00 
fffffe00fff1ad80
[  119.858904] 3920: fffffc0008d74000 fffffe00ea96cb00 fffffc00088469b0 
0000000000000000
[  119.864738] 3940: fffffe00ea96d108 fffffe00fff1ad80 0000000000000054 
fffffe00e44b39a8
[  119.870551] 3960: fffffc0008d7ba00 fffffe00fff1ad80 fffffc0008d74000 
fffffe00ea96cb00
[  119.876396] 3980: fffffc00088469b0 fffffe00fff1ad80 fffffe00e6a63a00 
fffffc00088469b0
[  119.882286] 39a0: fffffe00e6a60000 fffffc0008846208 fffffe00fff1b698 
7fffffffffffffff
[  119.888225] 39c0: fffffe00e6a63b70 fffffe00f296ca80 fffffdff80387c80 
fffffe00f27f3f00
[  119.894004] 39e0: 0000000000000054 fffffc00083c6dec fffffe00ee7e7e00 
00000000ffffffff
[  119.899745] 3a00: fffffe00e6a63a20 fffffc00088499ec 7fffffffffffffff 
fffffc00083c6df8
[  119.905577] 3a20: fffffe00e6a63ac0 fffffc0008846208 fffffe00fff1ad80 
0000000000000000
[  119.911378] 3a40: fffffe00fff1b698 7fffffffffffffff fffffe00e6a63b70 
fffffe00f296ca80
[  119.917247] 3a60: fffffdff80387c80 fffffe00f27f3f00 fffffe00e6a63aa0 
fffffc000818ac7c
[  119.923206] 3a80: fffffe00ebdb4d00 0000000000000000 fffffe00ffff5a50 
7fffffffffffffff
[  119.929031] 3aa0: fffffe00e6a63ac0 fffffc0008846200 0000000000000000 
0000000000000040
[  119.934854] 3ac0: fffffe00e6a63af0 fffffc0008847270 0000000000000082 
fffffe00e6a63b88
[  119.940671] 3ae0: fffffe00ffff5a50 fffffc0008847250 fffffe00e6a63b10 
fffffc0008846e54
[  119.946549] 3b00: 0000000000000082 fffffc0008847250 fffffe00e6a63b50 
fffffc00081dd688
[  119.952327] 3b20: 000000000000008a 003fffe000010001 fffffe00f27f3f00 
fffffe00f2754900
[  119.958198] 3b40: fffffe00e6a63cd0 fffffe00f296ca80 fffffe00e6a63bb0 
fffffc00081ddf4c
[  119.964079] 3b60: 0000000000000054 fffffdff80387c80 fffffdff80387c80 
0000000000000000
[  119.969913] 3b80: 0000000000000000 0000000000000000 fffffe00ea96cb00 
fffffc000810ce90
[  119.975650] 3ba0: fffffe00ffff5a58 fffffe00ffff5a58 fffffe00e6a63be0 
fffffc00081de310
[  119.981448] 3bc0: 0000000000000009 fffffe00e44b3b20 0000000000000004 
fffffe00e44b3b20
[  119.987351] 3be0: fffffe00e6a63c50 fffffc0000909ec4 fffffe00e6a63d68 
fffffe00e44b3840
[  119.993135] 3c00: fffffe00e44b39a8 fffffe00f296ca80 fffffe00e6a63cd0 
0000000000000024
[  119.998861] 3c20: 0000000000000054 fffffe00f296ca80 fffffe00f27f3f60 
0000000000020000
[  120.004540] 3c40: fffffe00e44b39a8 024000c0f296ca80 fffffe00e6a63c90 
fffffc0008211a68
[  120.010243] 3c60: fffffe00e6a63d68 fffffe00e6a63d60 0000000000000000 
0000000000000000
[  120.015886] 3c80: 0000000000000009 0000000000000040 fffffe00e6a63d00 
fffffc00082174e0
[  120.021599] 3ca0: fffffe00f296ca80 fffffe00f296ca80 0000000000000040 
0000000000000009
[  120.027289] 3cc0: fffffe00e6a63d68 fffffdff80387c40 024200ca00000054 
0000000000000009
[  120.032992] 3ce0: 000003ff7b940000 0000000000000000 0000000000000000 
000002aaf1820000
[  120.038714] 3d00: fffffe00e6a63da0 fffffc000884cd70 fffffe00e6a63ec0 
0000000092000007
[  120.044401] 3d20: fffffe00ea96cb00 000003ff7b940e54 fffffe00f27f3f00 
0000000000000024
[  120.050125] 3d40: 0000000000000054 fffffc00081d21d4 fffffe00e6a63d70 
fffffc000821a26c
[  120.055824] 3d60: 000003ff7b940e54 fffffe00f296ca80 000003ff7b940000 
0000000000000054
[  120.061514] 3d80: fffffe00e6a8ffd8 0000000000000000 0000000000000000 
0000000000000000
[  120.067304] 3da0: fffffe00e6a63e10 fffffc0008081344 fffffc00088900c8 
0000000092000007
[  120.073004] 3dc0: 000003ff7b940e54 fffffe00e6a63ec0 0000000020000000 
0000000000000024
[  120.078732] 3de0: 0000000092000007 000003ff7b940e54 0000000000000014 
fffffe00e6a60000
[  120.084436] 3e00: fffffe00e6a63e30 0000000000000007 0000000000000000 
fffffc0008083038
[  120.090209] 3e20: 0000000000000000 000002aaf17d5700 ffffffffffffffff 
000002aacbd75a6c
[  120.095903] 3e40: fffffe00e6a63e60 fffffc0008114c64 00000000000000d6 
0000000000000004
[  120.101618] 3e60: fffffe00e6a63e80 fffffc000821d310 000002aaf1820000 
00000000000000d6
[  120.107317] 3e80: fffffe00e6a63ea0 fffffc0008088644 0000000000000008 
fffffe00e6a63ec0
[  120.113005] 3ea0: 0000000000000000 fffffc00080832dc 0000000000000000 
0000000000000069
[  120.118725] 3ec0: 0000000000000000 000003ff7b940e54 0000000000000001 
000003ff7b8b0008
[  120.124410] 3ee0: 000003ffcd064400 ffffffff00000000 000002aacbe4718c 
000002aacbde3aa8
[  120.130144] 3f00: fefefeff64647173 0000000000000000 000002aaf17c6550 
0101010101010101
[  120.135836] 3f20: 0000000000000020 ffffffffffffffff ffffffff00000000 
ffffffffffffffff
[  120.141532] 3f40: 000002aacbe3f9e0 000003ff8b323c20 0000000000000000 
000002aacbe4718c
[  120.147249] 3f60: 000002aaf17d5700 000003ffcd064400 00000000000073b7 
000002aaf17d5700
[  120.152939] 3f80: 0000000000009a0f 0000000000004d60 000003ff7b8b0408 
0000000000000014
[  120.158650] 3fa0: 000002aacbe47000 000003ffcd0641a0 000002aacbd75e1c 
000003ffcd0641a0
[  120.164353] 3fc0: 000002aacbd75a6c 0000000020000000 0000000000000000 
ffffffffffffffff
[  120.170063] 3fe0: 0000000000000000 0000000000000000 0000000000000000 
0000000000000000
[  120.175744] Call trace:
[  120.177588] Exception stack(0xfffffe00e6a63630 to 0xfffffe00e6a63760)
[  120.182279] 3620:                                   fffffe00e6a539c0 
0000040000000000
[  120.187964] 3640: fffffe00e6a63790 fffffc000808ff30 00000000800001c5 
0000000000000080
[  120.193657] 3660: 0000000000000004 fffffc000808ff00 0000000000000000 
0000000000000000
[  120.199343] 3680: 00000200f7220000 0000000000000002 000000d2ea7d1b28 
0000000000000000
[  120.205011] 36a0: 0000000000000001 0000000000000000 0000000000000001 
0000000000010000
[  120.210698] 36c0: 0000000000000000 6c732e726573752f 726573752f656369 
ffffffffffffffff
[  120.216366] 36e0: 0000000000000000 000003ff8b323c20 0000000000000000 
fffffe00e6a539c0
[  120.222066] 3700: fffffe00e6a53800 ffffffff87b2b5f5 fffffe00ff8d5c00 
fffffe00f275ca00
[  120.227747] 3720: 000000001af18c08 fffffe00fff22328 0000000000000001 
0000000000000000
[  120.233426] 3740: fffffe00f275ca08 fffffe00e6a63790 fffffc00086fe6c4 
fffffe00e6a63790
[  120.239117] [<fffffc000808ff30>] armv8pmu_read_counter+0x30/0x68
[  120.243497] [<fffffc00086fe790>] armpmu_stop+0x38/0x50
[  120.247263] [<fffffc00086fe7e4>] armpmu_del+0x3c/0x78
[  120.250957] [<fffffc00081cc260>] event_sched_out.isra.49+0x140/0x2a0
[  120.255610] [<fffffc00081cc404>] group_sched_out+0x44/0xc0
[  120.259622] [<fffffc00081cc900>] ctx_sched_out+0x100/0x1d8
[  120.263629] [<fffffc00081cca00>] task_ctx_sched_out+0x28/0x58
[  120.267822] [<fffffc00081ce560>] __perf_event_task_sched_out+0x128/0x368
[  120.272704] [<fffffc000884655c>] __schedule+0x2ec/0x708
[  120.276527] [<fffffc00088469b0>] schedule+0x38/0x98
[  120.280114] [<fffffc00088499ec>] schedule_timeout+0x29c/0x3c0
[  120.284479] [<fffffc0008846208>] io_schedule_timeout+0xa0/0x108
[  120.288822] [<fffffc0008847270>] bit_wait_io+0x20/0x70
[  120.292584] [<fffffc0008846e54>] __wait_on_bit+0xac/0xe8
[  120.296448] [<fffffc00081dd688>] wait_on_page_bit_killable+0xe0/0xf0
[  120.301084] [<fffffc00081ddf4c>] __lock_page_or_retry+0xcc/0xf8
[  120.305416] [<fffffc00081de310>] filemap_fault+0x398/0x548
[  120.309680] [<fffffc0000909ec4>] xfs_filemap_fault+0x64/0x140 [xfs]
[  120.314278] [<fffffc0008211a68>] __do_fault+0x78/0x150
[  120.318045] [<fffffc00082174e0>] handle_mm_fault+0x5d0/0x9c0
[  120.322171] [<fffffc000884cd70>] do_page_fault+0x2f8/0x3b0
[  120.326178] [<fffffc0008081344>] do_mem_abort+0x54/0xb0
[  120.329987] Exception stack(0xfffffe00e6a63e20 to 0xfffffe00e6a63f50)
[  120.334670] 3e20: 0000000000000000 000002aaf17d5700 ffffffffffffffff 
000002aacbd75a6c
[  120.340351] 3e40: fffffe00e6a63e60 fffffc0008114c64 00000000000000d6 
0000000000000004
[  120.346050] 3e60: fffffe00e6a63e80 fffffc000821d310 000002aaf1820000 
00000000000000d6
[  120.351720] 3e80: fffffe00e6a63ea0 fffffc0008088644 0000000000000008 
fffffe00e6a63ec0
[  120.357387] 3ea0: 0000000000000000 fffffc00080832dc 0000000000000000 
0000000000000069
[  120.363089] 3ec0: 0000000000000000 000003ff7b940e54 0000000000000001 
000003ff7b8b0008
[  120.368760] 3ee0: 000003ffcd064400 ffffffff00000000 000002aacbe4718c 
000002aacbde3aa8
[  120.374561] 3f00: fefefeff64647173 0000000000000000 000002aaf17c6550 
0101010101010101
[  120.380260] 3f20: 0000000000000020 ffffffffffffffff ffffffff00000000 
ffffffffffffffff
[  120.385981] 3f40: 000002aacbe3f9e0 000003ff8b323c20
[  120.389526] [<fffffc0008083038>] el0_da+0x18/0x1c
[  120.392978] Code: 51000442 92401042 d51b9ca2 d5033fdf (d53b9d40)
