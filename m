From: Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: ARM64 KVM crash
Date: Fri, 12 Oct 2018 17:51:18 +0100
Message-ID: <b3355304-5144-b17a-c39c-866e197e3cc6@arm.com>
References: <alpine.LRH.2.02.1810121204120.16008@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A112A49E4C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Oct 2018 12:51:23 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id Eznu2Z-gMaM8 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 12 Oct 2018 12:51:22 -0400 (EDT)
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3DF3740A6E
 for <kvmarm@lists.cs.columbia.edu>; Fri, 12 Oct 2018 12:51:22 -0400 (EDT)
In-Reply-To: <alpine.LRH.2.02.1810121204120.16008@file01.intranet.prod.int.rdu2.redhat.com>
Content-Language: en-GB
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Mikulas Patocka <mpatocka@redhat.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Mikulas,

On 12/10/18 17:20, Mikulas Patocka wrote:
> Hi
> 
> I report this crash that happened on ARM64 in the host kernel when running 
> a workload in a virtual machine. The crash is not reproducible. Kernel 
> 4.18.12, board MacchiatoBin.
> 
> The call sequence that leads up to the crash: find_busiest_group -> 
> update_sd_lb_stats -> update_sg_lb_stats -> for_each_cpu_and -> 
> cpumask_next_and -> find_next_and_bit. The crash happened because the 
> first argument to find_next_and_bit is invalid pointer 0x2.

Right. But how is that related to KVM? See below:

> 
> Mikulas
> 
> 
> [75476.680487] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000003
> [75476.680498] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000040
> [75476.680521] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000002
> [75476.680522] Mem abort info:
> [75476.680524]   ESR = 0x96000005
> [75476.680526]   Exception class = DABT (current EL), IL = 32 bits
> [75476.680528]   SET = 0, FnV = 0
> [75476.680529]   EA = 0, S1PTW = 0
> [75476.680530] Data abort info:
> [75476.680531]   ISV = 0, ISS = 0x00000005
> [75476.680532]   CM = 0, WnR = 0
> [75476.680536] user pgtable: 4k pages, 39-bit VAs, pgdp = 0000000005d2fe31
> [75476.680537] [0000000000000002] pgd=0000000000000000, pud=0000000000000000
> [75476.680542] Internal error: Oops: 96000005 [#1] PREEMPT SMP
> [75476.680544] Modules linked in: vhost_net vhost tun bridge stp llc udlfb syscopyarea sysfillrect sysimgblt fb_sys_fops fb font autofs4 hid_generic usbhid hid binfmt_misc ip6t_REJECT nf_reject_ipv6 nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables ipt_MASQUERADE xt_nat iptable_nat nf_nat_ipv4 iptable_mangle xt_TCPMSS nf_conntrack_ipv4 nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4 xt_tcpudp xt_conntrack xt_multiport iptable_filter ip_tables x_tables pppoe pppox af_packet ppp_generic slhc nls_utf8 nls_cp852 vfat fat snd_usb_audio snd_hwdep snd_usbmidi_lib snd_rawmidi snd_pcm snd_timer snd soundcore nf_nat_ftp nf_conntrack_ftp nf_nat nf_conntrack ftdi_sio usbserial ipv6 aes_ce_blk crypto_simd cryptd aes_ce_cipher crc32_ce ghash_ce gf128mul aes_arm64 sha2_ce sha256_arm64 sha1_ce sha1_g
 eneric efivars
> [75476.680639]  xhci_plat_hcd xhci_hcd usbcore usb_common mvpp2 phylink unix
> [75476.680652] CPU: 2 PID: 9993 Comm: CPU 2/KVM Not tainted 4.18.12 #1
> [75476.680653] Hardware name: Marvell Armada 8040 MacchiatoBin/Armada 8040 MacchiatoBin, BIOS EDK II Jul 30 2018
> [75476.680656] pstate: 20000085 (nzCv daIf -PAN -UAO)
> [75476.680667] pc : find_next_and_bit+0xc/0x70
> [75476.680671] lr : cpumask_next_and+0x20/0x28
> [75476.680672] sp : ffffffc12c527690
> [75476.680673] x29: ffffffc12c527690 x28: ffffffc12c527728 
> [75476.680677] x27: 00000000ffffffff x26: fffffffffffffff8 
> [75476.680681] x25: ffffffc13b02f380 x24: 0000000000000000 
> [75476.680684] x23: ffffff80088696e4 x22: 0000000000000000 
> [75476.680687] x21: ffffffc13b02f3a0 x20: ffffffc12c5278d8 
> [75476.680690] x19: ffffff8008859c80 x18: 0000000000000400 
> [75476.680693] x17: 0000000000000000 x16: 0000000000000000 
> [75476.680696] x15: 0000000000000400 x14: 0000000000000400 
> [75476.680699] x13: 0000000000000400 x12: 0000000000000001 
> [75476.680702] x11: 000000000000027b x10: ffffffc13ff9ce88 
> [75476.680705] x9 : ffffffc13b025e00 x8 : ffffffc13b025e00 
> [75476.680708] x7 : 000044a5438be2c8 x6 : 0000000000000001 
> [75476.680711] x5 : 0000000000000000 x4 : 0000000000000000 
> [75476.680714] x3 : 0000000000000000 x2 : 0000000000000004 
> [75476.680717] x1 : ffffffc13ff9ce88 x0 : 0000000000000002 
> [75476.680721] Process CPU 2/KVM (pid: 9993, stack limit = 0x00000000f6dd03c5)
> [75476.680722] Call trace:
> [75476.680725]  find_next_and_bit+0xc/0x70
> [75476.680728]  find_busiest_group+0x128/0x938
> [75476.680730]  load_balance+0x148/0x848
> [75476.680732]  pick_next_task_fair+0x1d4/0x568
> [75476.680734]  __schedule+0xe8/0x4b0
> [75476.680736]  schedule+0x38/0xa0
> [75476.680739]  kvm_vcpu_block+0x88/0x180
> [75476.680742]  kvm_handle_wfx+0x80/0xb8
> [75476.680744]  handle_exit+0x138/0x1b8

The guest is exiting because it has executed a blocking WFI, so KVM's
job is done and we're calling schedule(). The scheduler then starts
doing its job of picking the next victim.

At this stage, the kernel indeed blows up. But this doesn't immediately
seem to be KVM's fault. It is far more likely that the scheduler has
messed something up in its own data structure, which is even worse :-(.

I'd suggest you get in touch with the scheduler guys to see if they have
any insight. Also, trying to come up with a reproducer would be
extremely useful.

Thanks,

	M.
-- 
Jazz is not dead. It just smells funny...
