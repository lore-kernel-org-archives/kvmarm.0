From: Andre Przywara <andre.przywara@arm.com>
Subject: Re: [PATCH 00/13] A bunch of vgic-its fixes
Date: Mon, 18 Jul 2016 18:47:21 +0100
Message-ID: <f2d8f9c9-9d0d-ee4a-8c24-c6e641488699@arm.com>
References: <1468857255-9543-1-git-send-email-marc.zyngier@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 3C38249B37
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 13:40:27 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id WvW66jK-IvzW for <kvmarm@lists.cs.columbia.edu>;
 Mon, 18 Jul 2016 13:40:26 -0400 (EDT)
Received: from cam-admin0.cambridge.arm.com (cam-admin0.cambridge.arm.com
 [217.140.96.50])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E13A849B36
 for <kvmarm@lists.cs.columbia.edu>; Mon, 18 Jul 2016 13:40:25 -0400 (EDT)
In-Reply-To: <1468857255-9543-1-git-send-email-marc.zyngier@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Marc Zyngier <marc.zyngier@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Eric Auger <eric.auger@redhat.com>
Cc: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu
List-Id: kvmarm@lists.cs.columbia.edu

Hi Marc,

On 18/07/16 16:54, Marc Zyngier wrote:
> As the ITS series has been posted 10 times now, and we're still
> finding issues, I've decided to directly fix things rather than
> commenting on them and waiting for a respin, as we are getting way too
> close to the merge window. So I sat over the weekend and started doing
> "stuff".
> 
> There is a bit of everything in there: some cosmetic things, but also
> some more severe bugs (indirect tables were completely foobar) and
> regressions (the cpuif stuff that Eric fixed).

I wonder if it's worth to squash:
- 01/13 into 09/17
- 02/13 into 07/17
- 04/13 into 15/17
with appropriate comments in the commit message to credit the bug fixes
and their authors?

That worked for me without further ado and would leave the git tree
bisectable - both in terms of compilability (every single commit
compiled for me with arm64/defconfig without warnings) and functionality
(tested new commit 17/17 with direct and indirect tables on the
model(ITS) and qemu and kvmtool on Juno).

It would be a pity if other people bisecting the kernel get punished for
my silly mistakes.

> Unless someone shouts at me, I intend to put that on top of Andre's
> series, and put the whole thing into -next. I've tested it on a LS2085
> with kvmtool, using both flat and indirect device tables.

I am fine with all those.

Thanks!
Andre.

> Eric Auger (1):
>   KVM: arm/arm64: Fix vGICv2 KVM_DEV_ARM_VGIC_GRP_CPU/DIST_REGS
> 
> Marc Zyngier (12):
>   irqchip/gicv3-its: Restore all cacheability attributes
>   KVM: arm64: vgic-its: Generalize use of vgic_get_irq_kref
>   KVM: arm64: vgic-its: Fix handling of indirect tables
>   KVM: arm64: vgic-its: Fix vgic_its_check_device_id BE handling
>   KVM: arm64: vgic-its: Fix misleading nr_entries in
>     vgic_its_check_device_id
>   KVM: arm64: vgic-its: Validate the device table L1 entry
>   KVM: arm64: vgic-its: Fix L2 entry validation for indirect tables
>   KVM: arm64: vgic-its: Add collection allocator/destructor
>   KVM: arm64: vgic-its: Add pointer to corresponding kvm_device
>   KVM: arm64: vgic-its: Turn device_id validation into generic ID
>     validation
>   KVM: arm64: vgic-its: Make vgic_its_cmd_handle_mapi similar to other
>     handlers
>   KVM: arm64: vgic-its: Simplify MAPI error handling
> 
>  include/kvm/arm_vgic.h             |   1 +
>  include/linux/irqchip/arm-gic-v3.h |  48 ++++++--
>  virt/kvm/arm/vgic/vgic-its.c       | 224 ++++++++++++++++++++-----------------
>  virt/kvm/arm/vgic/vgic-mmio-v2.c   |   2 +
>  virt/kvm/arm/vgic/vgic-mmio.c      |   4 +-
>  virt/kvm/arm/vgic/vgic.c           |  10 +-
>  virt/kvm/arm/vgic/vgic.h           |   8 ++
>  7 files changed, 175 insertions(+), 122 deletions(-)
> 
