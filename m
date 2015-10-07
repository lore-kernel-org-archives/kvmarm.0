From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v4 4/7] KVM: arm64: Implement vGICv3 distributor and
 redistributor access from userspace
Date: Wed, 7 Oct 2015 22:07:11 +0200
Message-ID: <20151007200711.GD14315@cbox>
References: <cover.1443451687.git.p.fedin@samsung.com>
 <9d42bb0fd6abf17bae0179c4233c45d267c25162.1443451687.git.p.fedin@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9d42bb0fd6abf17bae0179c4233c45d267c25162.1443451687.git.p.fedin@samsung.com>
Sender: kvm-owner@vger.kernel.org
To: Pavel Fedin <p.fedin@samsung.com>
Cc: kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, Peter Maydell <peter.maydell@linaro.org>, Marc Zyngier <marc.zyngier@arm.com>, Andre Przywara <andre.przywara@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Pavel,


On Mon, Sep 28, 2015 at 06:27:31PM +0300, Pavel Fedin wrote:
> The access is done similar to vGICv2, using KVM_DEV_ARM_VGIC_GRP_DIST_REGS
> and KVM_DEV_ARM_VGIC_GRP_REDIST_REGS with KVM_SET_DEVICE_ATTR and
> KVM_GET_DEVICE_ATTR ioctls. Since GICv3 can handle large number of CPUs,
> KVM_DEV_ARM_VGIC_CPUID_MASK has been extended to 20 bits. This is enough
> for 1048576 CPUs.
> 
> Some registers are 64-bit wide according to the specification.
> KVM_DEV_ARM_VGIC_64BIT flag is introduced, allowing to perform full 64-bit
> accesses. vgic_attr_regs_access() has also been fixed up in order to be
> able to perform 64-bit accesses correctly.
> 
Apologies for the long delay in responding to this.

We went over this and discussed this during Linaro Connect, and we came
up with an API that we believe considers the future, works well with how
things are going to be designed in QEMU, and follows the architecture.

I'm sorry to make you rework your patches at this stage, but I'd like
you to take a look at the patch for the API that I just sent out
(subject: KVM: arm/arm64: Add VGICv3 save/restore API documentation) and
adapt this patch set to use that API instead and then I'll review that.

Thanks,
-Christoffer
