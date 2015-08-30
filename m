From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH 0/3] KVM: arm64: Implement API for vGICv3 live migration
Date: Sun, 30 Aug 2015 18:29:19 +0200
Message-ID: <20150830162919.GC24113@cbox>
References: <cover.1440766141.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1440766141.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Aug 28, 2015 at 03:56:09PM +0300, Pavel Fedin wrote:
> This patchset adds necessary userspace API in order to support vGICv3 live
> migration. This includes accessing GIC distributor and redistributor memory
> regions using device attribute ioctls, and system registers of
> CPU interface using register get/set ioctls.

This obviously lacks a clear description of the API in
Documentation/virtual/kvm/devices/arm-vgic.txt

> 
> Pavel Fedin (3):
>   KVM: arm64: Implement vGICv3 distributor and redistributor access from
>     userspace
>   KVM: arm64: Allow to use accessors in KVM_SET_ONE_REG and
>     KVM_GET_ONE_REG
>   KVM: arm64: Implement accessors for vGIC CPU interface registers
> 
>  arch/arm64/include/uapi/asm/kvm.h  |   1 +
>  arch/arm64/kvm/sys_regs.c          | 223 ++++++++++++++++++++++++++++++++++++-
>  include/linux/irqchip/arm-gic-v3.h |  18 ++-
>  virt/kvm/arm/vgic-v3-emul.c        | 186 ++++++++++++++++++++++++++++---
>  4 files changed, 405 insertions(+), 23 deletions(-)
> 
> -- 
> 2.4.4
> 
