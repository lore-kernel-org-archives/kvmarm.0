From: Mikulas Patocka <mpatocka@redhat.com>
Subject: ARM64 KVM crash
Date: Fri, 12 Oct 2018 12:20:59 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1810121204120.16008@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Christoffer Dall <christoffer.dall@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi

I report this crash that happened on ARM64 in the host kernel when running 
a workload in a virtual machine. The crash is not reproducible. Kernel 
4.18.12, board MacchiatoBin.

The call sequence that leads up to the crash: find_busiest_group -> 
update_sd_lb_stats -> update_sg_lb_stats -> for_each_cpu_and -> 
cpumask_next_and -> find_next_and_bit. The crash happened because the 
first argument to find_next_and_bit is invalid pointer 0x2.

Mikulas


[75476.680487] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000003
[75476.680498] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000040
[75476.680521] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000002
[75476.680522] Mem abort info:
[75476.680524]   ESR = 0x96000005
[75476.680526]   Exception class = DABT (current EL), IL = 32 bits
[75476.680528]   SET = 0, FnV = 0
[75476.680529]   EA = 0, S1PTW = 0
[75476.680530] Data abort info:
[75476.680531]   ISV = 0, ISS = 0x00000005
[75476.680532]   CM = 0, WnR = 0
[75476.680536] user pgtable: 4k pages, 39-bit VAs, pgdp = 0000000005d2fe31
[75476.680537] [0000000000000002] pgd=0000000000000000, pud=0000000000000000
[75476.680542] Internal error: Oops: 96000005 [#1] PREEMPT SMP
[75476.680544] Modules linked in: vhost_net vhost tun bridge stp llc udlfb syscopyarea sysfillrect sysimgblt fb_sys_fops fb font autofs4 hid_generic usbhid hid binfmt_misc ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipt_MASQUERADE xt_nat iptable_nat nf_nat_ipv4 iptable_mangle xt_TCPMSS nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_conntrack xt_multiport iptable_filter ip_tables x_tables pppoe pppox af_packet ppp_generic slhc nls_utf8 nls_cp852 vfat fat snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi snd_pcm snd_timer snd soundcore nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack ftdi_sio usbserial ipv6 aes_ce_blk crypto_simd cryptd aes_ce_cipher crc32_ce ghash_ce gf128mul aes_arm64 sha2_ce sha256_arm64 sha1_ce sha1_gen
 eric efivars
[75476.680639]  xhci_plat_hcd xhci_hcd usbcore usb_common mvpp2 phylink unix
[75476.680652] CPU: 2 PID: 9993 Comm: CPU 2/KVM Not tainted 4.18.12 #1
[75476.680653] Hardware name: Marvell Armada 8040 MacchiatoBin/Armada 8040 MacchiatoBin, BIOS EDK II Jul 30 2018
[75476.680656] pstate: 20000085 (nzCv daIf -PAN -UAO)
[75476.680667] pc : find_next_and_bit+0xc/0x70
[75476.680671] lr : cpumask_next_and+0x20/0x28
[75476.680672] sp : ffffffc12c527690
[75476.680673] x29: ffffffc12c527690 x28: ffffffc12c527728 
[75476.680677] x27: 00000000ffffffff x26: fffffffffffffff8 
[75476.680681] x25: ffffffc13b02f380 x24: 0000000000000000 
[75476.680684] x23: ffffff80088696e4 x22: 0000000000000000 
[75476.680687] x21: ffffffc13b02f3a0 x20: ffffffc12c5278d8 
[75476.680690] x19: ffffff8008859c80 x18: 0000000000000400 
[75476.680693] x17: 0000000000000000 x16: 0000000000000000 
[75476.680696] x15: 0000000000000400 x14: 0000000000000400 
[75476.680699] x13: 0000000000000400 x12: 0000000000000001 
[75476.680702] x11: 000000000000027b x10: ffffffc13ff9ce88 
[75476.680705] x9 : ffffffc13b025e00 x8 : ffffffc13b025e00 
[75476.680708] x7 : 000044a5438be2c8 x6 : 0000000000000001 
[75476.680711] x5 : 0000000000000000 x4 : 0000000000000000 
[75476.680714] x3 : 0000000000000000 x2 : 0000000000000004 
[75476.680717] x1 : ffffffc13ff9ce88 x0 : 0000000000000002 
[75476.680721] Process CPU 2/KVM (pid: 9993, stack limit = 0x00000000f6dd03c5)
[75476.680722] Call trace:
[75476.680725]  find_next_and_bit+0xc/0x70
[75476.680728]  find_busiest_group+0x128/0x938
[75476.680730]  load_balance+0x148/0x848
[75476.680732]  pick_next_task_fair+0x1d4/0x568
[75476.680734]  __schedule+0xe8/0x4b0
[75476.680736]  schedule+0x38/0xa0
[75476.680739]  kvm_vcpu_block+0x88/0x180
[75476.680742]  kvm_handle_wfx+0x80/0xb8
[75476.680744]  handle_exit+0x138/0x1b8
[75476.680746]  kvm_arch_vcpu_ioctl_run+0x2b0/0x5e8
[75476.680748]  kvm_vcpu_ioctl+0x330/0x7a8
[75476.680751]  do_vfs_ioctl+0xa4/0x7e8
[75476.680754]  ksys_ioctl+0x78/0xa8
[75476.680756]  sys_ioctl+0xc/0x18
[75476.680758]  el0_svc_naked+0x30/0x34
[75476.680761] Code: d65f03c0 eb03005f 54000329 d346fc64 (f8647806) 
[75476.680763] ---[ end trace 19bbd785127be262 ]---
[75476.680766] note: CPU 2/KVM[9993] exited with preempt_count 1
[75476.680802] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000002
[75476.680803] Mem abort info:
[75476.680804]   ESR = 0x96000005
[75476.680805]   Exception class = DABT (current EL), IL = 32 bits
[75476.680807]   SET = 0, FnV = 0
[75476.680808]   EA = 0, S1PTW = 0
[75476.680809] Data abort info:
[75476.680810]   ISV = 0, ISS = 0x00000005
[75476.680811]   CM = 0, WnR = 0
[75476.680813] user pgtable: 4k pages, 39-bit VAs, pgdp = 0000000005d2fe31
[75476.680814] [0000000000000002] pgd=0000000000000000, pud=0000000000000000
[75476.680818] Internal error: Oops: 96000005 [#2] PREEMPT SMP
[75476.680819] Modules linked in: vhost_net vhost tun bridge stp llc udlfb syscopyarea sysfillrect sysimgblt fb_sys_fops fb font autofs4 hid_generic usbhid hid binfmt_misc ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipt_MASQUERADE xt_nat iptable_nat nf_nat_ipv4 iptable_mangle xt_TCPMSS nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_conntrack xt_multiport iptable_filter ip_tables x_tables pppoe pppox af_packet ppp_generic slhc nls_utf8 nls_cp852 vfat fat snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi snd_pcm snd_timer snd soundcore nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack ftdi_sio usbserial ipv6 aes_ce_blk crypto_simd cryptd aes_ce_cipher crc32_ce ghash_ce gf128mul aes_arm64 sha2_ce sha256_arm64 sha1_ce sha1_gen
 eric efivars
[75476.680889]  xhci_plat_hcd xhci_hcd usbcore usb_common mvpp2 phylink unix
[75476.680898] CPU: 2 PID: 17426 Comm: kworker/2:1 Tainted: G      D           4.18.12 #1
[75476.680899] Hardware name: Marvell Armada 8040 MacchiatoBin/Armada 8040 MacchiatoBin, BIOS EDK II Jul 30 2018
[75476.680903] Workqueue:            (null) (events_power_efficient)
[75476.680907] pstate: 20000085 (nzCv daIf -PAN -UAO)
[75476.680910] pc : find_next_and_bit+0xc/0x70
[75476.680912] lr : cpumask_next_and+0x20/0x28
[75476.680913] sp : ffffffc07f977a30
[75476.680914] x29: ffffffc07f977a30 x28: ffffffc07f977b88 
[75476.680918] x27: 00000000ffffffff x26: fffffffffffffff8 
[75476.680921] x25: ffffffc13b02f200 x24: 0000000000000000 
[75476.680924] x23: ffffff80088696e4 x22: 0000000000000001 
[75476.680927] x21: ffffffc13b02f220 x20: ffffffc07f977c78 
[75476.680930] x19: ffffff8008859c80 x18: 0000000000000400 
[75476.680933] x17: 0000000000000001 x16: 0000000000000019 
[75476.680936] x15: 0000000000000400 x14: 0000000000000400 
[75476.680939] x13: 0000000000000400 x12: 0000000000000000 
[75476.680942] x11: 00000000000003dc x10: ffffffc13ff9ce88 
[75476.680946] x9 : ffffffc13b025e00 x8 : 0000000000000020 
[75476.680949] x7 : 0000000000000002 x6 : ffffffc13b02f220 
[75476.680952] x5 : 000000000000000c x4 : 0000000000000000 
[75476.680955] x3 : 0000000000000000 x2 : 0000000000000004 
[75476.680958] x1 : ffffffc13ff9ce88 x0 : 0000000000000002 
[75476.680961] Process kworker/2:1 (pid: 17426, stack limit = 0x0000000054b63590)
[75476.680962] Call trace:
[75476.680965]  find_next_and_bit+0xc/0x70
[75476.680967]  find_busiest_group+0x128/0x938
[75476.680969]  load_balance+0x148/0x848
[75476.680971]  pick_next_task_fair+0x1d4/0x568
[75476.680973]  __schedule+0xe8/0x4b0
[75476.680975]  schedule+0x38/0xa0
[75476.680977]  worker_thread+0xc8/0x440
[75476.680980]  kthread+0x124/0x128
[75476.680982]  ret_from_fork+0x10/0x18
[75476.680984] Code: d65f03c0 eb03005f 54000329 d346fc64 (f8647806) 
[75476.680986] ---[ end trace 19bbd785127be263 ]---
[75476.680988] note: kworker/2:1[17426] exited with preempt_count 1
[75476.681008] WARNING: CPU: 2 PID: 17426 at kernel/rcu/tree_plugin.h:330 rcu_note_context_switch+0x28/0x3a0
[75476.681009] Modules linked in: vhost_net vhost tun bridge stp llc udlfb syscopyarea sysfillrect sysimgblt fb_sys_fops fb font autofs4 hid_generic usbhid hid binfmt_misc ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipt_MASQUERADE xt_nat iptable_nat nf_nat_ipv4 iptable_mangle xt_TCPMSS nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_conntrack xt_multiport iptable_filter ip_tables x_tables pppoe pppox af_packet ppp_generic slhc nls_utf8 nls_cp852 vfat fat snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi snd_pcm snd_timer snd soundcore nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack ftdi_sio usbserial ipv6 aes_ce_blk crypto_simd cryptd aes_ce_cipher crc32_ce ghash_ce gf128mul aes_arm64 sha2_ce sha256_arm64 sha1_ce sha1_gen
 eric efivars
[75476.681079]  xhci_plat_hcd xhci_hcd usbcore usb_common mvpp2 phylink unix
[75476.681087] CPU: 2 PID: 17426 Comm: kworker/2:1 Tainted: G      D           4.18.12 #1
[75476.681089] Hardware name: Marvell Armada 8040 MacchiatoBin/Armada 8040 MacchiatoBin, BIOS EDK II Jul 30 2018
[75476.681092] Workqueue:            (null) (events_power_efficient)
[75476.681095] pstate: 20000085 (nzCv daIf -PAN -UAO)
[75476.681098] pc : rcu_note_context_switch+0x28/0x3a0
[75476.681100] lr : rcu_note_context_switch+0x18/0x3a0
[75476.681101] sp : ffffffc07f977570
[75476.681102] x29: ffffffc07f977570 x28: ffffffc13b048000 
[75476.681105] x27: 00000000ffffffff x26: 0000000000000000 
[75476.681108] x25: ffffffc04bd71700 x24: ffffff80080eaebc 
[75476.681111] x23: ffffff800884b018 x22: ffffffc04bd71700 
[75476.681114] x21: ffffff8008869828 x20: 0000000000000000 
[75476.681117] x19: ffffffc04bd71700 x18: ffffff800887929c 
[75476.681120] x17: 0000000000000001 x16: 0000000000000019 
[75476.681124] x15: ffffff8008879298 x14: 0000000000000000 
[75476.681127] x13: ffffffc071dfb478 x12: ffffffc071dfb4a0 
[75476.681130] x11: ffffffc071dfb531 x10: 0000000000000013 
[75476.681133] x9 : 000000000000000c x8 : 00000000400c2000 
[75476.681136] x7 : 0000000000210d00 x6 : ffffffc0440a0e60 
[75476.681139] x5 : ffffff80080c3968 x4 : 0000000000000000 
[75476.681142] x3 : 0000004137751000 x2 : 0000004137751000 
[75476.681145] x1 : ffffff800885a858 x0 : 0000000000000001 
[75476.681148] Call trace:
[75476.681150]  rcu_note_context_switch+0x28/0x3a0
[75476.681152]  __schedule+0x70/0x4b0
[75476.681155]  do_task_dead+0x44/0x48
[75476.681157]  do_exit+0x644/0x8e8
[75476.681159]  die+0x1b8/0x1c8
[75476.681161]  die_kernel_fault+0x60/0x70
[75476.681163]  __do_kernel_fault+0x94/0xb0
[75476.681165]  do_page_fault+0x1e0/0x458
[75476.681167]  do_translation_fault+0x64/0x70
[75476.681168]  do_mem_abort+0x3c/0xd0
[75476.681170]  el1_da+0x20/0x80
[75476.681172]  find_next_and_bit+0xc/0x70
[75476.681174]  find_busiest_group+0x128/0x938
[75476.681176]  load_balance+0x148/0x848
[75476.681178]  pick_next_task_fair+0x1d4/0x568
[75476.681180]  __schedule+0xe8/0x4b0
[75476.681181]  schedule+0x38/0xa0
[75476.681183]  worker_thread+0xc8/0x440
[75476.681185]  kthread+0x124/0x128
[75476.681187]  ret_from_fork+0x10/0x18
[75476.681188] ---[ end trace 19bbd785127be264 ]---
[75476.681192] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000040
[75476.681193] Mem abort info:
[75476.681194]   ESR = 0x96000005
[75476.681195]   Exception class = DABT (current EL), IL = 32 bits
[75476.681196]   SET = 0, FnV = 0
[75476.681198]   EA = 0, S1PTW = 0
[75476.681199] Data abort info:
[75476.681200]   ISV = 0, ISS = 0x00000005
[75476.681201]   CM = 0, WnR = 0
[75476.681203] user pgtable: 4k pages, 39-bit VAs, pgdp = 0000000005d2fe31
[75476.681204] [0000000000000040] pgd=0000000000000000, pud=0000000000000000
[75476.681208] Internal error: Oops: 96000005 [#3] PREEMPT SMP
[75476.681209] Modules linked in: vhost_net vhost tun bridge stp llc udlfb syscopyarea sysfillrect sysimgblt fb_sys_fops fb font autofs4 hid_generic usbhid hid binfmt_misc ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipt_MASQUERADE xt_nat iptable_nat nf_nat_ipv4 iptable_mangle xt_TCPMSS nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_conntrack xt_multiport iptable_filter ip_tables x_tables pppoe pppox af_packet ppp_generic slhc nls_utf8 nls_cp852 vfat fat snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi snd_pcm snd_timer snd soundcore nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack ftdi_sio usbserial ipv6 aes_ce_blk crypto_simd cryptd aes_ce_cipher crc32_ce ghash_ce gf128mul aes_arm64 sha2_ce sha256_arm64 sha1_ce sha1_gen
 eric efivars
[75476.681279]  xhci_plat_hcd xhci_hcd usbcore usb_common mvpp2 phylink unix
[75476.681287] CPU: 2 PID: 17426 Comm: kworker/2:1 Tainted: G      D W         4.18.12 #1
[75476.681288] Hardware name: Marvell Armada 8040 MacchiatoBin/Armada 8040 MacchiatoBin, BIOS EDK II Jul 30 2018
[75476.681291] Workqueue:            (null) (events_power_efficient)
[75476.681294] pstate: 00000085 (nzcv daIf -PAN -UAO)
[75476.681296] pc : set_next_entity+0x1c/0x130
[75476.681298] lr : pick_next_task_fair+0x4e8/0x568
[75476.681299] sp : ffffffc07f9774b0
[75476.681301] x29: ffffffc07f9774b0 x28: ffffffc13b048000 
[75476.681304] x27: 00000000ffffffff x26: ffffffc13ffaac80 
[75476.681307] x25: ffffffc04bd71bf0 x24: ffffffc13ffaad00 
[75476.681310] x23: ffffff8008869638 x22: ffffffc04bd71700 
[75476.681313] x21: ffffffc13ffaac80 x20: ffffffc13ffaad00 
[75476.681316] x19: 0000000000000000 x18: 0000000000000400 
[75476.681320] x17: 0000000000000001 x16: 0000000000000019 
[75476.681323] x15: 0000000000000400 x14: 0000000000000400 
[75476.681326] x13: 0000000000000400 x12: 0000000000000000 
[75476.681329] x11: 00000000000003dd x10: 0000000000000001 
[75476.681332] x9 : 0000000000000000 x8 : 0000000000000000 
[75476.681335] x7 : 000000000038b92b x6 : ffffffc13ffaad80 
[75476.681338] x5 : 00000000fa83b2da x4 : 0000000000000001 
[75476.681341] x3 : 0000000000000000 x2 : 0000000000000000 
[75476.681344] x1 : 0000000000000000 x0 : ffffffc13ffaad00 
[75476.681348] Process kworker/2:1 (pid: 17426, stack limit = 0x0000000054b63590)
[75476.681349] Call trace:
[75476.681351]  set_next_entity+0x1c/0x130
[75476.681353]  pick_next_task_fair+0x4e8/0x568
[75476.681355]  __schedule+0xe8/0x4b0
[75476.681357]  do_task_dead+0x44/0x48
[75476.681359]  do_exit+0x644/0x8e8
[75476.681361]  die+0x1b8/0x1c8
[75476.681363]  die_kernel_fault+0x60/0x70
[75476.681365]  __do_kernel_fault+0x94/0xb0
[75476.681367]  do_page_fault+0x1e0/0x458
[75476.681368]  do_translation_fault+0x64/0x70
[75476.681370]  do_mem_abort+0x3c/0xd0
[75476.681372]  el1_da+0x20/0x80
[75476.681374]  find_next_and_bit+0xc/0x70
[75476.681376]  find_busiest_group+0x128/0x938
[75476.681378]  load_balance+0x148/0x848
[75476.681380]  pick_next_task_fair+0x1d4/0x568
[75476.681382]  __schedule+0xe8/0x4b0
[75476.681384]  schedule+0x38/0xa0
[75476.681385]  worker_thread+0xc8/0x440
[75476.681387]  kthread+0x124/0x128
[75476.681389]  ret_from_fork+0x10/0x18
[75476.681391] Code: aa0003f4 aa0103f3 a9025bf5 d1020015 (b9404020) 
[75476.681394] ---[ end trace 19bbd785127be265 ]---
[75476.681395] Fixing recursive fault but reboot is needed!
[75476.689314] Mem abort info:
[75476.698134] Mem abort info:
[75476.706952]   ESR = 0x96000005
[75476.706954]   Exception class = DABT (current EL), IL = 32 bits
[75476.709755]   ESR = 0x96000005
[75476.709757]   Exception class = DABT (current EL), IL = 32 bits
[75476.712818]   SET = 0, FnV = 0
[75476.712820]   EA = 0, S1PTW = 0
[75476.718762]   SET = 0, FnV = 0
[75476.721824] Data abort info:
[75476.721826]   ISV = 0, ISS = 0x00000005
[75476.724975]   EA = 0, S1PTW = 0
[75476.724977] Data abort info:
[75476.727866]   CM = 0, WnR = 0
[75476.727868] user pgtable: 4k pages, 39-bit VAs, pgdp = 0000000005d2fe31
[75476.731715]   ISV = 0, ISS = 0x00000005
[75476.731717]   CM = 0, WnR = 0
[75476.734693] [0000000000000003] pgd=0000000000000000, pud=0000000000000000
[75476.741335] user pgtable: 4k pages, 39-bit VAs, pgdp = 0000000005d2fe31
[75476.748148] Internal error: Oops: 96000005 [#4] PREEMPT SMP
[75476.753740] [0000000000000040] pgd=0000000000000000
[75476.824732] Modules linked in:
[75476.831545] , pud=0000000000000000
[75476.837836]  vhost_net vhost tun bridge stp llc udlfb syscopyarea sysfillrect sysimgblt fb_sys_fops fb font autofs4 hid_generic usbhid hid binfmt_misc ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipt_MASQUERADE xt_nat iptable_nat nf_nat_ipv4 iptable_mangle xt_TCPMSS nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_conntrack xt_multiport iptable_filter ip_tables x_tables pppoe pppox af_packet ppp_generic slhc nls_utf8 nls_cp852 vfat fat snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi snd_pcm snd_timer snd soundcore nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack ftdi_sio usbserial ipv6 aes_ce_blk crypto_simd cryptd aes_ce_cipher crc32_ce ghash_ce gf128mul aes_arm64 sha2_ce sha256_arm64 sha1_ce sha1_generic efivars xhci_
 plat_hcd xhci_hcd
[75478.149128]  usbcore usb_common mvpp2 phylink unix
[75478.153944] CPU: 3 PID: 9994 Comm: CPU 3/KVM Tainted: G      D W         4.18.12 #1
[75478.161630] Hardware name: Marvell Armada 8040 MacchiatoBin/Armada 8040 MacchiatoBin, BIOS EDK II Jul 30 2018
[75478.171584] pstate: 20000085 (nzCv daIf -PAN -UAO)
[75478.176396] pc : find_next_and_bit+0xc/0x70
[75478.180594] lr : cpumask_next_and+0x20/0x28
[75478.184792] sp : ffffffc109ffb690
[75478.188118] x29: ffffffc109ffb690 x28: ffffffc109ffb728 
[75478.193452] x27: 00000000ffffffff x26: fffffffffffffff8 
[75478.198785] x25: ffffffc13b02f200 x24: 0000000000000000 
[75478.204119] x23: ffffff80088696e4 x22: 0000000000000000 
[75478.209453] x21: ffffffc13b02f220 x20: ffffffc109ffb8d8 
[75478.214786] x19: ffffff8008859c80 x18: 0000000000000400 
[75478.220120] x17: 0000000000000000 x16: 0000000000000000 
[75478.225454] x15: 0000000000000400 x14: 0000000000000400 
[75478.230787] x13: 0000000000000400 x12: 0000000000000001 
[75478.236121] x11: 000000000000027b x10: ffffffc13ffb5e88 
[75478.241455] x9 : ffffffc13b025f00 x8 : ffffffc13b025f00 
[75478.246789] x7 : 000044a545230be8 x6 : 0000000000000001 
[75478.252123] x5 : 0000000000000000 x4 : 0000000000000000 
[75478.257456] x3 : 0000000000000000 x2 : 0000000000000004 
[75478.262789] x1 : ffffffc13ffb5e88 x0 : 0000000000000003 
[75478.268124] Process CPU 3/KVM (pid: 9994, stack limit = 0x0000000021cd5396)
[75478.275113] Call trace:
[75478.277569]  find_next_and_bit+0xc/0x70
[75478.281419]  find_busiest_group+0x128/0x938
[75478.285618]  load_balance+0x148/0x848
[75478.289294]  pick_next_task_fair+0x1d4/0x568
[75478.293581]  __schedule+0xe8/0x4b0
[75478.296994]  schedule+0x38/0xa0
[75478.300146]  kvm_vcpu_block+0x88/0x180
[75478.303910]  kvm_handle_wfx+0x80/0xb8
[75478.307585]  handle_exit+0x138/0x1b8
[75478.311174]  kvm_arch_vcpu_ioctl_run+0x2b0/0x5e8
[75478.315809]  kvm_vcpu_ioctl+0x330/0x7a8
[75478.319659]  do_vfs_ioctl+0xa4/0x7e8
[75478.323247]  ksys_ioctl+0x78/0xa8
[75478.326573]  sys_ioctl+0xc/0x18
[75478.329725]  el0_svc_naked+0x30/0x34
[75478.333315] Code: d65f03c0 eb03005f 54000329 d346fc64 (f8647806) 
[75478.339432] ---[ end trace 19bbd785127be266 ]---
[75478.344067] Internal error: Oops: 96000005 [#5] PREEMPT SMP
[75478.344089] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000003
[75478.349661] Modules linked in: vhost_net vhost tun bridge stp
[75478.358486] Mem abort info:
[75478.358488]   ESR = 0x96000005
[75478.364254]  llc udlfb syscopyarea sysfillrect
[75478.367061]   Exception class = DABT (current EL), IL = 32 bits
[75478.370122]  sysimgblt fb_sys_fops fb font
[75478.374585]   SET = 0, FnV = 0
[75478.380524]  autofs4 hid_generic usbhid hid
[75478.384639]   EA = 0, S1PTW = 0
[75478.387700]  binfmt_misc ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6
[75478.391901] Data abort info:
[75478.395049]  nf_defrag_ipv6 ip6table_filter ip6_tables ipt_MASQUERADE
[75478.401518]   ISV = 0, ISS = 0x00000005
[75478.404404]  xt_nat iptable_nat nf_nat_ipv4 iptable_mangle
[75478.410873]   CM = 0, WnR = 0
[75478.414718]  xt_TCPMSS nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT
[75478.420229] user pgtable: 4k pages, 39-bit VAs, pgdp = 0000000005d2fe31
[75478.423203]  nf_reject_ipv4 xt_tcpudp xt_conntrack xt_multiport
[75478.429410] [0000000000000003] pgd=0000000000000000
[75478.436045]  iptable_filter ip_tables x_tables pppoe
[75478.441991] , pud=0000000000000000
[75478.446885]  pppox af_packet ppp_generic slhc
[75478.455280]  nls_utf8 nls_cp852 vfat fat snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi snd_pcm snd_timer snd soundcore nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack ftdi_sio usbserial ipv6 aes_ce_blk crypto_simd cryptd aes_ce_cipher crc32_ce ghash_ce gf128mul aes_arm64 sha2_ce sha256_arm64 sha1_ce sha1_generic efivars xhci_plat_hcd xhci_hcd usbcore usb_common mvpp2 phylink unix
[75478.493976] CPU: 0 PID: 9992 Comm: CPU 1/KVM Tainted: G      D W         4.18.12 #1
[75478.501663] Hardware name: Marvell Armada 8040 MacchiatoBin/Armada 8040 MacchiatoBin, BIOS EDK II Jul 30 2018
[75478.511617] pstate: 20000085 (nzCv daIf -PAN -UAO)
[75478.516431] pc : find_next_and_bit+0xc/0x70
[75478.520630] lr : cpumask_next_and+0x20/0x28
[75478.524829] sp : ffffffc137b5f690
[75478.528154] x29: ffffffc137b5f690 x28: ffffffc137b5f7e8 
[75478.533489] x27: 0000000000000001 x26: fffffffffffffff8 
[75478.538822] x25: ffffffc13b027f80 x24: 0000000000000000 
[75478.544156] x23: ffffff80088696e4 x22: 0000000000000001 
[75478.549489] x21: ffffffc13b027fa0 x20: ffffffc137b5f8d8 
[75478.554822] x19: ffffff8008859c80 x18: 0000000000000400 
[75478.560155] x17: 0000000000000000 x16: 0000000000000000 
[75478.565488] x15: 0000000000000400 x14: 0000000000000400 
[75478.570821] x13: 0000000000000400 x12: 0000000000000001 
[75478.576154] x11: 000000000000027a x10: 0000000000000000 
[75478.581488] x9 : 00000000002f6b4d x8 : 000000000033f2aa 
[75478.586822] x7 : 000000000000008d x6 : 0000000000000000 
[75478.592155] x5 : 0000000000000001 x4 : 0000000000000000 
[75478.597488] x3 : 0000000000000002 x2 : 0000000000000004 
[75478.602821] x1 : ffffffc13ff6ae88 x0 : 0000000000000040 
[75478.608155] Process CPU 1/KVM (pid: 9992, stack limit = 0x00000000db714d97)
[75478.615143] Call trace:
[75478.617599]  find_next_and_bit+0xc/0x70
[75478.621449]  find_busiest_group+0x128/0x938
[75478.625647]  load_balance+0x148/0x848
[75478.629322]  pick_next_task_fair+0x1d4/0x568
[75478.633609]  __schedule+0xe8/0x4b0
[75478.637023]  schedule+0x38/0xa0
[75478.640175]  kvm_vcpu_block+0x88/0x180
[75478.643938]  kvm_handle_wfx+0x80/0xb8
[75478.647614]  handle_exit+0x138/0x1b8
[75478.651202]  kvm_arch_vcpu_ioctl_run+0x2b0/0x5e8
[75478.655837]  kvm_vcpu_ioctl+0x330/0x7a8
[75478.659687]  do_vfs_ioctl+0xa4/0x7e8
[75478.663275]  ksys_ioctl+0x78/0xa8
[75478.666602]  sys_ioctl+0xc/0x18
[75478.669755]  el0_svc_naked+0x30/0x34
[75478.673344] Code: d65f03c0 eb03005f 54000329 d346fc64 (f8647806) 
[75478.679462] ---[ end trace 19bbd785127be267 ]---
[75478.684097] Internal error: Oops: 96000005 [#6] PREEMPT SMP
[75478.684130] note: CPU 1/KVM[9992] exited with preempt_count 1
[75478.689690] Modules linked in: vhost_net vhost tun bridge stp llc udlfb syscopyarea sysfillrect sysimgblt fb_sys_fops fb font autofs4 hid_generic usbhid hid binfmt_misc ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipt_MASQUERADE xt_nat iptable_nat nf_nat_ipv4 iptable_mangle xt_TCPMSS nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_conntrack xt_multiport iptable_filter ip_tables x_tables pppoe pppox af_packet ppp_generic slhc nls_utf8 nls_cp852 vfat fat snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi snd_pcm snd_timer snd soundcore nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack ftdi_sio usbserial ipv6 aes_ce_blk crypto_simd cryptd aes_ce_cipher crc32_ce ghash_ce gf128mul aes_arm64 sha2_ce sha256_arm64 sha1_ce sha1_gen
 eric efivars
[75478.697475] ------------[ cut here ]------------
[75478.766527]  xhci_plat_hcd xhci_hcd
[75478.771164] kernel BUG at arch/arm64/kvm/fpsimd.c:63!
[75478.771166]  usbcore usb_common mvpp2 phylink unix
[75478.784547] CPU: 3 PID: 9994 Comm: CPU 3/KVM Tainted: G      D W         4.18.12 #1
[75478.792233] Hardware name: Marvell Armada 8040 MacchiatoBin/Armada 8040 MacchiatoBin, BIOS EDK II Jul 30 2018
[75478.802187] pstate: 20000005 (nzCv daif -PAN -UAO)
[75478.806997] pc : find_next_and_bit+0xc/0x70
[75478.811196] lr : cpumask_next_and+0x20/0x28
[75478.815394] sp : ffffffc13ffc30f0
[75478.818720] x29: ffffffc13ffc30f0 x28: ffffffc13ffc3188 
[75478.824054] x27: 00000000ffffffff x26: 0000000000000008 
[75478.829387] x25: ffffffc13b02f200 x24: 0000000000000002 
[75478.834721] x23: ffffff80088696e4 x22: 0000000000000000 
[75478.840054] x21: ffffffc13b02f220 x20: ffffffc13ffc3338 
[75478.845388] x19: ffffff8008859c80 x18: 0000000000000400 
[75478.850721] x17: 0000000000000000 x16: 0000000000000000 
[75478.856055] x15: 0000000000000400 x14: 0000000000000400 
[75478.861388] x13: 0000000000000400 x12: 0000000000000001 
[75478.866723] x11: 00000000000000c9 x10: ffffffc13ffb5e88 
[75478.872056] x9 : ffffffc13b025f00 x8 : ffffffc13b025f00 
[75478.877389] x7 : 000044a59e8b3ae8 x6 : 0000000000000001 
[75478.882722] x5 : 0000000000000000 x4 : 0000000000000000 
[75478.888055] x3 : 0000000000000000 x2 : 0000000000000004 
[75478.893389] x1 : ffffffc13ffb5e88 x0 : 0000000000000003 
[75478.898723] Process CPU 3/KVM (pid: 9994, stack limit = 0x0000000021cd5396)
[75478.905711] Call trace:
[75478.908167]  find_next_and_bit+0xc/0x70
[75478.912017]  find_busiest_group+0x128/0x938
[75478.916215]  load_balance+0x148/0x848
[75478.919890]  rebalance_domains+0x184/0x290
[75478.924001]  run_rebalance_domains+0xf4/0x1f0
[75478.928374]  __do_softirq+0x104/0x1f8
[75478.932049]  irq_exit+0x9c/0xb8
[75478.935202]  __handle_domain_irq+0x64/0xb8
[75478.939313]  gic_handle_irq+0x50/0xa0
[75478.942988]  el1_irq+0xb0/0x128
[75478.946141]  _raw_spin_unlock_irq+0x18/0x48
[75478.950339]  exit_signals+0x188/0x218
[75478.954014]  do_exit+0xb0/0x8e8
[75478.957167]  die+0x1b8/0x1c8
[75478.960057]  die_kernel_fault+0x60/0x70
[75478.963908]  __do_kernel_fault+0x94/0xb0
[75478.967845]  do_page_fault+0x1e0/0x458
[75478.971607]  do_translation_fault+0x64/0x70
[75478.975805]  do_mem_abort+0x3c/0xd0
[75478.979305]  el1_da+0x20/0x80
[75478.982283]  find_next_and_bit+0xc/0x70
[75478.986133]  find_busiest_group+0x128/0x938
[75478.990331]  load_balance+0x148/0x848
[75478.994006]  pick_next_task_fair+0x1d4/0x568
[75478.998292]  __schedule+0xe8/0x4b0
[75479.001706]  schedule+0x38/0xa0
[75479.004858]  kvm_vcpu_block+0x88/0x180
[75479.008622]  kvm_handle_wfx+0x80/0xb8
[75479.012297]  handle_exit+0x138/0x1b8
[75479.015886]  kvm_arch_vcpu_ioctl_run+0x2b0/0x5e8
[75479.020521]  kvm_vcpu_ioctl+0x330/0x7a8
[75479.024370]  do_vfs_ioctl+0xa4/0x7e8
[75479.027958]  ksys_ioctl+0x78/0xa8
[75479.031285]  sys_ioctl+0xc/0x18
[75479.034438]  el0_svc_naked+0x30/0x34
[75479.038026] Code: d65f03c0 eb03005f 54000329 d346fc64 (f8647806) 
[75479.044143] ---[ end trace 19bbd785127be268 ]---
[75479.048778] Kernel panic - not syncing: Fatal exception in interrupt
[75479.055157] SMP: stopping secondary CPUs
[75480.102191] SMP: failed to stop secondary CPUs 0-3
[75480.106999] Kernel Offset: disabled
[75480.110499] CPU features: 0x01002000
[75480.114087] Memory Limit: none
[75480.117153] ---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---
