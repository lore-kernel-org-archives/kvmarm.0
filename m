From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v10 6/8] arm/arm64: vgic: Implement VGICv3 CPU interface
 access
Date: Fri, 20 Jan 2017 20:27:27 +0100
Message-ID: <20170120192727.GF13531@cbox>
References: <1480576187-5012-1-git-send-email-vijay.kilari@gmail.com>
 <1480576187-5012-7-git-send-email-vijay.kilari@gmail.com>
 <182d7293-f0f1-e043-4c70-a3d70a41a5a4@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 841A04095A
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jan 2017 14:27:34 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id nTG6zO1kgSWf for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Jan 2017 14:27:33 -0500 (EST)
Received: from mail-lf0-f52.google.com (mail-lf0-f52.google.com
 [209.85.215.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5FE8C40783
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jan 2017 14:27:33 -0500 (EST)
Received: by mail-lf0-f52.google.com with SMTP id k86so63769822lfi.0
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jan 2017 11:27:33 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <182d7293-f0f1-e043-4c70-a3d70a41a5a4@redhat.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Auger Eric <eric.auger@redhat.com>
Cc: marc.zyngier@arm.com, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Dec 19, 2016 at 06:05:33PM +0100, Auger Eric wrote:
> Hi Vijaya, Christoffer,
> 
> On 01/12/2016 08:09, vijay.kilari@gmail.com wrote:
> > From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> > 
> > VGICv3 CPU interface registers are accessed using
> > KVM_DEV_ARM_VGIC_CPU_SYSREGS ioctl. These registers are accessed
> > as 64-bit. The cpu MPIDR value is passed along with register id.
> > is used to identify the cpu for registers access.
> > 
> > The VM that supports SEIs expect it on destination machine to handle
> > guest aborts and hence checked for ICC_CTLR_EL1.SEIS compatibility.
> > Similarly, VM that supports Affinity Level 3 that is required for AArch64
> > mode, is required to be supported on destination machine. Hence checked
> > for ICC_CTLR_EL1.A3V compatibility.
> > 
> > The arch/arm64/kvm/vgic-sys-reg-v3.c handles read and write of VGIC
> > CPU registers for AArch64.
> > 
> > For AArch32 mode, arch/arm/kvm/vgic-v3-coproc.c file is created but
> > APIs are not implemented.
> > 
> > Updated arch/arm/include/uapi/asm/kvm.h with new definitions
> > required to compile for AArch32.
> > 
> > The version of VGIC v3 specification is define here
> > Documentation/virtual/kvm/devices/arm-vgic-v3.txt
> > 
> > Signed-off-by: Pavel Fedin <p.fedin@samsung.com>
> > Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> > ---
> >  arch/arm/include/uapi/asm/kvm.h     |   2 +
> >  arch/arm/kvm/Makefile               |   4 +-
> >  arch/arm/kvm/vgic-v3-coproc.c       |  35 ++++
> >  arch/arm64/include/uapi/asm/kvm.h   |   3 +
> >  arch/arm64/kvm/Makefile             |   3 +-
> >  arch/arm64/kvm/vgic-sys-reg-v3.c    | 338 ++++++++++++++++++++++++++++++++++++
> >  include/kvm/arm_vgic.h              |   9 +
> >  virt/kvm/arm/vgic/vgic-kvm-device.c |  28 +++
> >  virt/kvm/arm/vgic/vgic-mmio-v3.c    |  18 ++
> >  virt/kvm/arm/vgic/vgic-v3.c         |   8 +
> >  virt/kvm/arm/vgic/vgic.h            |   4 +
> >  11 files changed, 449 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm/include/uapi/asm/kvm.h b/arch/arm/include/uapi/asm/kvm.h
> > index 0ae6035..98658d9d 100644
> > --- a/arch/arm/include/uapi/asm/kvm.h
> > +++ b/arch/arm/include/uapi/asm/kvm.h
> > @@ -186,9 +186,11 @@ struct kvm_arch_memory_slot {
> >  			(0xffffffffULL << KVM_DEV_ARM_VGIC_V3_MPIDR_SHIFT)
> >  #define   KVM_DEV_ARM_VGIC_OFFSET_SHIFT	0
> >  #define   KVM_DEV_ARM_VGIC_OFFSET_MASK	(0xffffffffULL << KVM_DEV_ARM_VGIC_OFFSET_SHIFT)
> > +#define   KVM_DEV_ARM_VGIC_SYSREG_INSTR_MASK (0xffff)
> >  #define KVM_DEV_ARM_VGIC_GRP_NR_IRQS	3
> >  #define KVM_DEV_ARM_VGIC_GRP_CTRL       4
> >  #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
> > +#define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
> nit: arm-vgic-v3.txt spec uses that name. To be homogeneous with other
> groups, shouldn't we correct this into KVM_DEV_ARM_VGIC_GRP_CPU_SYSREGS?

Yeah, probably, as long as we use the same naming scheme and have the
docs and code in sync, I'm fine with this.

Thanks,
-Christoffer
