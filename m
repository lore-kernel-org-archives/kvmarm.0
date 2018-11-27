From: Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v2 1/4] KVM: arm/arm64: vgic: Do not cond_resched_lock()
 with IRQs disabled
Date: Tue, 27 Nov 2018 06:57:28 +0000
Message-ID: <20181127065730.1A330208E4@mail.kernel.org>
References: <1543256807-9768-2-git-send-email-julien.thierry@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8CF1C4A306
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Nov 2018 01:57:32 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id hHE6IYnWeR2f for <kvmarm@lists.cs.columbia.edu>;
 Tue, 27 Nov 2018 01:57:31 -0500 (EST)
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 6BC224A2F1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 27 Nov 2018 01:57:31 -0500 (EST)
In-Reply-To: <1543256807-9768-2-git-send-email-julien.thierry@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Sasha Levin <sashal@kernel.org>, Julien Thierry <julien.thierry@arm.com>, linux-kernel@vger.kernel.org, kvmarm@lists.cs.columbia.edu
Cc: Marc Zyngier <marc.zyngier@arm.com>, stable@vger.kernel.org
List-Id: kvmarm@lists.cs.columbia.edu

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v4.19.4, v4.14.83, v4.9.140, v4.4.164, v3.18.126, 

v4.19.4: Build OK!
v4.14.83: Failed to apply! Possible dependencies:
    006df0f34930 ("KVM: arm/arm64: Support calling vgic_update_irq_pending from irq context")
    53692908b0f5 ("KVM: arm/arm64: vgic: Fix source vcpu issues for GICv2 SGI")
    67b5b673ad4d ("KVM: arm/arm64: vgic: Disallow Active+Pending for level interrupts")
    6c1b7521f4a0 ("KVM: arm/arm64: Factor out functionality to get vgic mmio requester_vcpu")
    df635c5b184d ("KVM: arm/arm64: Support VGIC dist pend/active changes for mapped IRQs")
    e40cc57bac79 ("KVM: arm/arm64: vgic: Support level-triggered mapped interrupts")
    f39d16cbabf9 ("KVM: arm/arm64: Guard kvm_vgic_map_is_active against !vgic_initialized")

v4.9.140: Failed to apply! Possible dependencies:
    006df0f34930 ("KVM: arm/arm64: Support calling vgic_update_irq_pending from irq context")
    2df903a89a81 ("KVM: arm/arm64: vgic: Implement support for userspace access")
    6c1b7521f4a0 ("KVM: arm/arm64: Factor out functionality to get vgic mmio requester_vcpu")
    8694e4da66a6 ("KVM: arm/arm64: Remove struct vgic_irq pending field")
    94574c9488e2 ("KVM: arm/arm64: vgic: Add distributor and redistributor access")
    9ce91c7234ff ("KVM: arm/arm64: vgic-its: rename itte into ite")
    d017d7b0bd7a ("KVM: arm/arm64: vgic: Implement VGICv3 CPU interface access")
    e96a006cb066 ("KVM: arm/arm64: vgic: Implement KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO ioctl")

v4.4.164: Failed to apply! Possible dependencies:
    05fb05a6ca25 ("KVM: arm/arm64: vgic-new: Removel harmful BUG_ON")
    0919e84c0fc1 ("KVM: arm/arm64: vgic-new: Add IRQ sync/flush framework")
    140b086dd197 ("KVM: arm/arm64: vgic-new: Add GICv2 world switch backend")
    35a2d58588f0 ("KVM: arm/arm64: vgic-new: Synchronize changes to active state")
    370a0ec18199 ("KVM: arm/arm64: Let vcpu thread modify its own active state")
    4493b1c4866a ("KVM: arm/arm64: vgic-new: Add MMIO handling framework")
    64a959d66e47 ("KVM: arm/arm64: vgic-new: Add acccessor to new struct vgic_irq instance")
    69b6fe0c6e7f ("KVM: arm/arm64: vgic-new: Add ACTIVE registers handlers")
    81eeb95ddbab ("KVM: arm/arm64: vgic-new: Implement virtual IRQ injection")
    8577370fb0cb ("KVM: Use simple waitqueue for vcpu->wq")
    96b298000db4 ("KVM: arm/arm64: vgic-new: Add PENDING registers handlers")
    b13216cf6010 ("KVM: arm/arm64: Provide functionality to pause and resume a guest")
    b18b57787f5e ("KVM: arm/arm64: vgic-new: Add data structure definitions")
    fb848db39661 ("KVM: arm/arm64: vgic-new: Add GICv2 MMIO handling framework")
    fd122e620983 ("KVM: arm/arm64: vgic-new: Add ENABLE registers handlers")

v3.18.126: Failed to apply! Possible dependencies:
    05bc8aafe664 ("arm/arm64: KVM: wrap 64 bit MMIO accesses with two 32 bit ones")
    35a2d58588f0 ("KVM: arm/arm64: vgic-new: Synchronize changes to active state")
    370a0ec18199 ("KVM: arm/arm64: Let vcpu thread modify its own active state")
    3caa2d8c3b2d ("arm/arm64: KVM: make the maximum number of vCPUs a per-VM value")
    59892136c40d ("arm/arm64: KVM: pass down user space provided GIC type into vGIC code")
    7f05db6a20fe ("kvm: drop unsupported capabilities, fix documentation")
    832158125d2e ("arm/arm64: KVM: add vgic.h header file")
    96415257a1bd ("arm/arm64: KVM: refactor vgic_handle_mmio() function")
    a0675c25d639 ("arm/arm64: KVM: add virtual GICv3 distributor emulation")
    ac3d373564d9 ("arm/arm64: KVM: allow userland to request a virtual GICv3")
    b13216cf6010 ("KVM: arm/arm64: Provide functionality to pause and resume a guest")
    b26e5fdac43c ("arm/arm64: KVM: introduce per-VM ops")
    c1426e4c5add ("KVM: arm/arm64: implement kvm_arch_intc_initialized")
    c32a42721ce6 ("kvm: Documentation: remove ia64")
    cc2d3216f53c ("irqchip: GICv3: ITS command queue")
    d97f683d0f4b ("arm/arm64: KVM: refactor MMIO accessors")
    ea2f83a7de9d ("arm/arm64: KVM: move kvm_register_device_ops() into vGIC probing")
    ef748917b529 ("arm/arm64: KVM: Remove 'config KVM_ARM_MAX_VCPUS'")
    f5c1434c217f ("irqchip: GICv3: rework redistributor structure")


How should we proceed with this patch?

--
Thanks,
Sasha
