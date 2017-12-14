From: Jia He <hejianet@gmail.com>
Subject: Re: [PATCH] KVM: arm/arm64: don't set vtimer->cnt_ctl in
 kvm_arch_timer_handler
Date: Thu, 14 Dec 2017 23:28:04 +0800
Message-ID: <5615f3e1-756e-0537-f0b6-20ae8626ac87@gmail.com>
References: <1513148407-2611-1-git-send-email-hejianet@gmail.com>
 <20171213091803.GQ910@cbox> <dc95b58c-ee6c-e5c7-1f37-8f69c789a1fc@gmail.com>
 <20171214130954.GV910@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20171214130954.GV910@cbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu, linux-kernel@vger.kernel.org, Jia He <jia.he@hxt-semitech.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Christoffer


On 12/14/2017 9:09 PM, Christoffer Dall Wrote:
> On Thu, Dec 14, 2017 at 12:57:54PM +0800, Jia He wrote:
> Hi Jia,
>
>> I have tried your newer level-mapped-v7 branch, but bug is still there.
>>
>> There is no special load in both host and guest. The guest (kernel
>> 4.14) is often hanging when booting
>>
>> the guest kernel log
>>
>> [ OK ] Reached target Remote File Systems.
>> Starting File System Check on /dev/mapper/fedora-root...
>> [ OK ] Started File System Check on /dev/mapper/fedora-root.
>> Mounting /sysroot...
>> [ 2.670764] SGI XFS with ACLs, security attributes, no debug enabled
>> [ 2.678180] XFS (dm-0): Mounting V5 Filesystem
>> [ 2.740364] XFS (dm-0): Ending clean mount
>> [ OK ] Mounted /sysroot.
>> [ OK ] Reached target Initrd Root File System.
>> Starting Reload Configuration from the Real Root...
>> [ 61.288215] INFO: rcu_sched detected stalls on CPUs/tasks:
>> [ 61.290791] 1-...!: (0 ticks this GP) idle=574/0/0 softirq=5/5 fqs=1
>> [ 61.293664] (detected by 0, t=6002 jiffies, g=-263, c=-264, q=39760)
>> [ 61.296480] Task dump for CPU 1:
>> [ 61.297938] swapper/1 R running task 0 0 1 0x00000020
>> [ 61.300643] Call trace:
>> [ 61.301260] __switch_to+0x6c/0x78
>> [ 61.302095] cpu_number+0x0/0x8
>> [ 61.302867] rcu_sched kthread starved for 6000 jiffies!
>> g18446744073709551353 c18446744073709551352 f0x0 RCU_GP_WAIT_FQS(3)
>> ->state=0x402 ->cpu=1
>> [ 61.305941] rcu_sched I 0 8 2 0x00000020
>> [ 61.307250] Call trace:
>> [ 61.307854] __switch_to+0x6c/0x78
>> [ 61.308693] __schedule+0x268/0x8f0
>> [ 61.309545] schedule+0x2c/0x88
>> [ 61.310325] schedule_timeout+0x84/0x3b8
>> [ 61.311278] rcu_gp_kthread+0x4d4/0x7d8
>> [ 61.312213] kthread+0x134/0x138
>> [ 61.313001] ret_from_fork+0x10/0x1c
>>
>> Maybe my previous patch is not perfect enough, thanks for your comments.
>>
>> I digged it futher more, do you think below code logic is possibly
>> problematic?
>>
>>
>> vtimer_save_state           (vtimer->loaded = false, cntv_ctl is 0)
>>
>> kvm_arch_timer_handler        (read cntv_ctl and set vtimer->cnt_ctl = 0)
>>
>> vtimer_restore_state            (write vtimer->cnt_ctl to cntv_ctl,
>> then cntv_ctl will
>>
>>                         be 0 forever)
>>
>>
>> If above analysis is reasonable
> Yes, I think there's something there if the hardware doesn't retire the
> signal fast enough...
>
>> how about below patch? already
>> tested in my arm64 server.
>>
>> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
>> index f9555b1..ee6dd3f 100644
>> --- a/virt/kvm/arm/arch_timer.c
>> +++ b/virt/kvm/arm/arch_timer.c
>> @@ -99,7 +99,7 @@ static irqreturn_t kvm_arch_timer_handler(int irq,
>> void *dev_id)
>>          }
>>          vtimer = vcpu_vtimer(vcpu);
>>
>> -       if (!vtimer->irq.level) {
>> +       if (vtimer->loaded && !vtimer->irq.level) {
>>                  vtimer->cnt_ctl = read_sysreg_el0(cntv_ctl);
>>                  if (kvm_timer_irq_can_fire(vtimer))
>>                          kvm_timer_update_irq(vcpu, true, vtimer);
>>
> There's nothing really wrong with that patch, I just didn't think it
> would be necessary, as we really shouldn't see interrupts if the timer
> is not loaded.  Can you confirm that a WARN_ON(!vtimer->loaded) in
> kvm_arch_timer_handler() gives you a splat?
Please see the WARN_ON result (without my patch)
[   72.171706] WARNING: CPU: 24 PID: 1768 at 
arch/arm64/kvm/../../../virt/kvm/arm/arch_timer.c:101 
kvm_arch_timer_handler+0xc0/0xc8
[   72.182305] Modules linked in: vhost_net tap xt_CHECKSUM 
iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat 
nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack 
nf_conntrack ipt_REJECT nf_reject_ipv4 xt_tcpudp bridge stp llc 
ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter 
ip_tables x_tables vhost_scsi vhost tcm_qla2xxx qla2xxx nvme_fc 
nvme_fabrics tcm_fc libfc scsi_transport_fc ib_srpt ib_cm ib_core 
iscsi_target_mod tcm_loop target_core_file target_core_iblock 
target_core_pscsi target_core_mod binfmt_misc nls_iso8859_1 shpchp 
crc32_ce crct10dif_ce i2c_qup dm_multipath autofs4 btrfs zstd_decompress 
zstd_compress xxhash raid10 raid456 async_raid6_recov async_memcpy 
async_pq async_xor async_tx xor raid6_pq libcrc32c raid1 raid0 multipath 
linear at803x ixgbe
[   72.252877]  xhci_plat_hcd xhci_hcd usbcore qcom_emac mdio 
ahci_platform libahci_platform libahci
[   72.261733] CPU: 24 PID: 1768 Comm: qemu-system-aar Tainted: G        
W        4.15.0-rc3+ #128
[   72.270412] Hardware name: WIWYNN QDF2400 Reference Evaluation 
Platform CV90-LA115-P151/QDF2400 Customer Reference Board, BIOS 0ACJA425 
09/07/2017
[   72.283520] pstate: 80400085 (Nzcv daIf +PAN -UAO)
[   72.288295] pc : kvm_arch_timer_handler+0xc0/0xc8
[   72.292984] lr : handle_percpu_devid_irq+0x8c/0x230
[   72.297842] sp : ffff00000830ff00
[   72.301141] x29: ffff00000830ff00 x28: ffffc17b9feaff00
[   72.306436] x27: ffff2e7462531000 x26: ffff000008310000
[   72.311731] x25: ffff000008300000 x24: ffffc17b80069100
[   72.317026] x23: 0000000000000003 x22: ffff2e74632248e8
[   72.322321] x21: ffffc17b80054c00 x20: 0000000000000000
[   72.327616] x19: ffffc17b8ac37dc0 x18: 0000000000000010
[   72.332911] x17: 000000000000000a x16: 0000000000007fff
[   72.338207] x15: ffffffffffffffff x14: 6d202c6666666666
[   72.343502] x13: 6666667830203a73 x12: 656c6379635f7861
[   72.348797] x11: ffff000009395448 x10: ffff00000862b5b8
[   72.354092] x9 : 0000000000000040 x8 : ffffc17b60007238
[   72.359387] x7 : 0000000000000000 x6 : ffffc17b80054c00
[   72.364682] x5 : ffffc17b60007250 x4 : 0000930756ce0000
[   72.369977] x3 : ffff2e74619cfff0 x2 : 0000930756ce0000
[   72.375273] x1 : 0000000000000000 x0 : ffffc17b8ac399c0
[   72.380568] Call trace:
[   72.383000]  kvm_arch_timer_handler+0xc0/0xc8
[   72.387340]  handle_percpu_devid_irq+0x8c/0x230
[   72.391853]  generic_handle_irq+0x34/0x50
[   72.395846]  __handle_domain_irq+0x68/0xc0
[   72.399926]  gic_handle_irq+0xcc/0x188
[   72.403658]  el1_irq+0xd8/0x180
[   72.406785]  hrtimer_try_to_cancel+0x0/0x160
[   72.411037]  kvm_timer_vcpu_put+0x3c/0x50
[   72.415030]  kvm_arch_vcpu_put+0x20/0x50
[   72.418937]  vcpu_put+0x20/0x40
[   72.422061]  kvm_vcpu_ioctl+0x244/0x7b8
[   72.425882]  do_vfs_ioctl+0xc4/0x988
[   72.429440]  SyS_ioctl+0x94/0xa8
[   72.432652]  el0_svc_naked+0x20/0x24
[   72.436210] ---[ end trace 11d0c8bba284e766 ]---

> Also, could you give the following a try (without your patch):
>
> diff --git a/virt/kvm/arm/arch_timer.c b/virt/kvm/arm/arch_timer.c
> index 73d262c4712b..4751255345d1 100644
> --- a/virt/kvm/arm/arch_timer.c
> +++ b/virt/kvm/arm/arch_timer.c
> @@ -367,6 +367,7 @@ static void vtimer_save_state(struct kvm_vcpu *vcpu)
>   
>   	/* Disable the virtual timer */
>   	write_sysreg_el0(0, cntv_ctl);
> +	isb();
No luck， the bug is still there

Cheers,
Jia
