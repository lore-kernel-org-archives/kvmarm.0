From: Vladimir Murzin <vladimir.murzin@arm.com>
Subject: Re: [RFC PATCH 00/45] KVM: arm/arm64: Rework virtual GIC emulation
Date: Wed, 30 Mar 2016 12:42:58 +0100
Message-ID: <56FBBBC2.6010602@arm.com>
References: <1458871508-17279-1-git-send-email-andre.przywara@arm.com>
 <56FA7F29.4060005@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id DC1FA411E3
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2016 07:42:07 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id xyJNHHAAq2Wf for <kvmarm@lists.cs.columbia.edu>;
 Wed, 30 Mar 2016 07:42:06 -0400 (EDT)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 7719A40F9B
 for <kvmarm@lists.cs.columbia.edu>; Wed, 30 Mar 2016 07:42:06 -0400 (EDT)
In-Reply-To: <56FA7F29.4060005@arm.com>
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

On 29/03/16 14:12, Vladimir Murzin wrote:
> Hi Andre,
> 
> On 25/03/16 02:04, Andre Przywara wrote:
>> Please have a look at the series, review it and give the code some
>> serious testing (and possibly debugging). All feedback is appreciated.
> 
> I see that with the new vgic implementation kvmtool starts throwing:
> 
> kvm [1273]: Unable to register VGICv3 redist MMIO regions
> 

It comes from kvm_io_bus_register_dev()

if (bus->dev_count - bus->ioeventfd_count > NR_IOBUS_DEVS - 1)
	return -ENOSPC;

with bus->dev_count being 1000

[<ffffffc00009f93c>] kvm_io_bus_register_dev+0x130/0x148
[<ffffffc0000ad274>] kvm_vgic_register_mmio_region+0xac/0xdc
[<ffffffc0000ad4d4>] vgic_register_redist_regions+0xb8/0x158
[<ffffffc0000abb90>] vgic_v3_map_resources+0x5c/0xf0
[<ffffffc0000aae04>] kvm_vgic_map_resources+0x40/0x84
[<ffffffc0000a23d0>] kvm_arch_vcpu_ioctl_run+0x3f0/0x400
[<ffffffc00009d484>] kvm_vcpu_ioctl+0x2d4/0x6ec
[<ffffffc0001c4eec>] do_vfs_ioctl+0xb4/0x760
[<ffffffc0001c561c>] SyS_ioctl+0x84/0x98
[<ffffffc000085d30>] el0_svc_naked+0x24/0x28

Hope this helps...
Vladimir

> for --cpus 58 and above, where with the old vgic it is quite happy with
> up to 255 cpus.
> 
> Cheers
> Vladimir
> _______________________________________________
> kvmarm mailing list
> kvmarm@lists.cs.columbia.edu
> https://lists.cs.columbia.edu/mailman/listinfo/kvmarm
> 
> 
