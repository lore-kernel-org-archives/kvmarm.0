From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [RFC PATCH 00/45] KVM: arm/arm64: Rework virtual GIC emulation
Date: Wed, 30 Mar 2016 12:52:27 +0100
Message-ID: <56FBBDFB.7080308@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <56FA7F29.4060005@arm.com> <56FBBBC2.6010602@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7BE8C411E3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2016 07:51:30 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 7qxA6O80L-uv for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Mar 2016 07:51:29 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 44A6940F9B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2016 07:51:29 -0400 (EDT)
In-Reply-To: <56FBBBC2.6010602@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Andre Przywara <andre.przywara@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Eric Auger <eric.auger@linaro.org>
Cc: kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, kvm@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

On 30/03/16 12:42, Vladimir Murzin wrote:
> On 29/03/16 14:12, Vladimir Murzin wrote:
>> Hi Andre,
>>
>> On 25/03/16 02:04, Andre Przywara wrote:
>>> Please have a look at the series, review it and give the code some
>>> serious testing (and possibly debugging). All feedback is appreciated.
>>
>> I see that with the new vgic implementation kvmtool starts throwing:
>>
>> kvm [1273]: Unable to register VGICv3 redist MMIO regions
>>
> 
> It comes from kvm_io_bus_register_dev()
> 
> if (bus->dev_count - bus->ioeventfd_count > NR_IOBUS_DEVS - 1)
> 	return -ENOSPC;
> 
> with bus->dev_count being 1000
> 
> [<ffffffc00009f93c>] kvm_io_bus_register_dev+0x130/0x148
> [<ffffffc0000ad274>] kvm_vgic_register_mmio_region+0xac/0xdc
> [<ffffffc0000ad4d4>] vgic_register_redist_regions+0xb8/0x158
> [<ffffffc0000abb90>] vgic_v3_map_resources+0x5c/0xf0
> [<ffffffc0000aae04>] kvm_vgic_map_resources+0x40/0x84
> [<ffffffc0000a23d0>] kvm_arch_vcpu_ioctl_run+0x3f0/0x400
> [<ffffffc00009d484>] kvm_vcpu_ioctl+0x2d4/0x6ec
> [<ffffffc0001c4eec>] do_vfs_ioctl+0xb4/0x760
> [<ffffffc0001c561c>] SyS_ioctl+0x84/0x98
> [<ffffffc000085d30>] el0_svc_naked+0x24/0x28
> 

and one more thing I've forgotten to mention... something odd happens on
destroy path

INFO: task kvm-vcpu-0:1123 blocked for more than 120 seconds.
      Tainted: G        W       4.5.0-rc6+ #432
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kvm-vcpu-0      D ffffffc000086bcc     0  1123   1114 0x00000008
Call trace:
[<ffffffc000086bcc>] __switch_to+0x90/0xa4
[<ffffffc0006c4390>] __schedule+0x188/0x59c
[<ffffffc0006c47e0>] schedule+0x3c/0xa0
[<ffffffc0006c4bf4>] schedule_preempt_disabled+0x20/0x38
[<ffffffc0006c618c>] __mutex_lock_slowpath+0xc4/0x148
[<ffffffc0006c6254>] mutex_lock+0x44/0x5c
[<ffffffc0000aacb8>] kvm_vgic_destroy+0x20/0xb0
[<ffffffc0000abbdc>] vgic_v3_map_resources+0xa8/0xf0
[<ffffffc0000aae04>] kvm_vgic_map_resources+0x40/0x84
[<ffffffc0000a23d0>] kvm_arch_vcpu_ioctl_run+0x3f0/0x400
[<ffffffc00009d484>] kvm_vcpu_ioctl+0x2d4/0x6ec
[<ffffffc0001c4eec>] do_vfs_ioctl+0xb4/0x760
[<ffffffc0001c561c>] SyS_ioctl+0x84/0x98
[<ffffffc000085d30>] el0_svc_naked+0x24/0x28

Vladimir

> Hope this helps...
> Vladimir
> 
>> for --cpus 58 and above, where with the old vgic it is quite happy with
>> up to 255 cpus.
>>
>> Cheers
>> Vladimir
>> _______________________________________________
>> kvmarm mailing list
>> kvmarm@lists.cs.columbia.edu
>> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
>>
>>
> 
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
> 
