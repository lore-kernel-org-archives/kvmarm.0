From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: Potential deadlock in vgic
Date: Fri, 11 May 2018 15:29:43 +0100
Message-ID: <c243af13-a9c3-6808-6937-f1b882ce7a58@arm.com>
References: <20180504130854.GA14663@hc>
 <20180504151740.12165-1-andre.przywara@arm.com> <20180504163142.GC14663@hc>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 9EC1940458
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 May 2018 10:20:16 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xFEv24Mg5mFx for <kvmarm@lists.cs.columbia.edu>;
 Fri, 11 May 2018 10:19:54 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7580E4043C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 11 May 2018 10:19:54 -0400 (EDT)
In-Reply-To: <20180504163142.GC14663@hc>
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
To: Jan Glauber <jan.glauber@caviumnetworks.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Jan,

On 04/05/18 17:31, Jan Glauber wrote:
> On Fri, May 04, 2018 at 04:17:40PM +0100, Andre Przywara wrote:
>> Hi Jan,
>>
>> can you please test this patch with your setup, to see if it still
>> screams? That converts two forgotten irq_lock's over to be irqsafe,
>> plus lets lpi_list_lock join them (which you already did, IIUC).
>> That should appease lockdep, hopefully.
> 
> Hit send too soon, on halting the guest I get:

So I managed to finally wrap my head around this one.
I sent out a series [1], and failed Cc:ing you under the assumption that
Reported-by: would be picked up by git send-email. Apologies for that,
but you should be able to pick it from one of the lists.

Can you please confirm that the last two patches fix the splat below for
you?

Thanks for testing and reporting!
Andre.

[1]
http://lists.infradead.org/pipermail/linux-arm-kernel/2018-May/577054.html

> 
> [ 1025.694857] =============================
> [ 1025.694862] WARNING: suspicious RCU usage
> [ 1025.694868] 4.17.0-rc3-jang+ #73 Not tainted
> [ 1025.694873] -----------------------------
> [ 1025.694880] ./include/linux/kvm_host.h:575 suspicious rcu_dereference_check() usage!
> [ 1025.694884] 
>                other info that might help us debug this:
> 
> [ 1025.694890] 
>                rcu_scheduler_active = 2, debug_locks = 1
> [ 1025.694896] 18 locks held by qemu-system-aar/5540:
> [ 1025.694901]  #0: 000000005e03488a (&kvm->lock){+.+.}, at: vgic_its_set_attr+0x230/0x388
> [ 1025.694937]  #1: 000000004b1a3bb5 (&its->its_lock){+.+.}, at: vgic_its_set_attr+0x23c/0x388
> [ 1025.694965]  #2: 000000003ca8213c (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xc0
> [ 1025.694993]  #3: 00000000adb6ae51 (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xc0
> [ 1025.695021]  #4: 0000000000563df7 (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xc0
> [ 1025.695048]  #5: 00000000da16277a (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xc0
> [ 1025.695076]  #6: 00000000bf36d9aa (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xc0
> [ 1025.695103]  #7: 00000000607eaa4f (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xc0
> [ 1025.695130]  #8: 0000000046dadf65 (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xc0
> [ 1025.695157]  #9: 00000000197747b2 (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xc0
> [ 1025.695184]  #10: 00000000e4f1282c (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xc0
> [ 1025.695211]  #11: 000000007471b896 (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xc0
> [ 1025.695239]  #12: 000000005be54486 (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xc0
> [ 1025.695266]  #13: 000000000f1fa184 (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xc0
> [ 1025.695293]  #14: 0000000093fdb28b (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xc0
> [ 1025.695396]  #15: 0000000097cc103c (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xc0
> [ 1025.695426]  #16: 00000000d24dd32e (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xc0
> [ 1025.695453]  #17: 000000002606c3a7 (&vcpu->mutex){+.+.}, at: lock_all_vcpus+0x64/0xc0
> [ 1025.695482] 
>                stack backtrace:
> [ 1025.695489] CPU: 29 PID: 5540 Comm: qemu-system-aar Not tainted 4.17.0-rc3-jang+ #73
> [ 1025.695494] Hardware name: To be filled by O.E.M. Saber/To be filled by O.E.M., BIOS 0ACKL018 03/30/2018
> [ 1025.695499] Call trace:
> [ 1025.695505]  dump_backtrace+0x0/0x160
> [ 1025.695510]  show_stack+0x24/0x30
> [ 1025.695517]  dump_stack+0x9c/0xd4
> [ 1025.695524]  lockdep_rcu_suspicious+0xcc/0x118
> [ 1025.695537]  gfn_to_memslot+0x174/0x190
> [ 1025.695546]  kvm_read_guest+0x50/0xb0
> [ 1025.695553]  vgic_its_check_id.isra.0+0x114/0x148
> [ 1025.695560]  vgic_its_save_tables_v0+0x1a0/0x320
> [ 1025.695567]  vgic_its_set_attr+0x330/0x388
> [ 1025.695573]  kvm_device_ioctl_attr+0x9c/0xd8
> [ 1025.695579]  kvm_device_ioctl+0x8c/0xf8
> [ 1025.695587]  do_vfs_ioctl+0xc4/0x938
> [ 1025.695594]  ksys_ioctl+0x8c/0x98
> [ 1025.695601]  sys_ioctl+0x34/0x48
> [ 1025.695609]  el0_svc_naked+0x44/0x48
> 
> --Jan
> 
