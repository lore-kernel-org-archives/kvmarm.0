From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH v3 5/5] arm/arm64: vgic-new: Implement
 KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO ioctl
Date: Tue, 30 Aug 2016 16:07:05 +0200
Message-ID: <20160830140705.GL10162@cbox>
References: <1472037609-4164-1-git-send-email-vijay.kilari@gmail.com>
 <1472037609-4164-6-git-send-email-vijay.kilari@gmail.com>
 <20160830140034.GK10162@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id E9A57410EB
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 09:56:43 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id P86UNmJr5z+2 for <kvmarm@lists.cs.columbia.edu>;
 Tue, 30 Aug 2016 09:56:42 -0400 (EDT)
Received: from mail-wm0-f45.google.com (mail-wm0-f45.google.com [74.125.82.45])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 61F2840FA2
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 09:56:41 -0400 (EDT)
Received: by mail-wm0-f45.google.com with SMTP id o80so37865329wme.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 30 Aug 2016 07:04:47 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20160830140034.GK10162@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: vijay.kilari@gmail.com
Cc: marc.zyngier@arm.com, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Tue, Aug 30, 2016 at 04:00:34PM +0200, Christoffer Dall wrote:
> On Wed, Aug 24, 2016 at 04:50:09PM +0530, vijay.kilari@gmail.com wrote:
> > From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> > 
> > Userspace requires to store and restore of line_level for
> > level triggered interrupts. For this ioctl KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO
> > is defined.
> > 
> > Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> > ---
> >  arch/arm64/include/uapi/asm/kvm.h   |  6 +++++
> >  virt/kvm/arm/vgic/vgic-kvm-device.c | 44 ++++++++++++++++++++++++++++++++++++-
> >  virt/kvm/arm/vgic/vgic-mmio-v3.c    | 19 ++++++++++++++++
> >  virt/kvm/arm/vgic/vgic-mmio.c       | 34 ++++++++++++++++++++++++++++
> >  virt/kvm/arm/vgic/vgic-mmio.h       |  6 +++++
> >  virt/kvm/arm/vgic/vgic.h            |  3 +++
> >  6 files changed, 111 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/arm64/include/uapi/asm/kvm.h b/arch/arm64/include/uapi/asm/kvm.h
> > index b13c944..45c56d7 100644
> > --- a/arch/arm64/include/uapi/asm/kvm.h
> > +++ b/arch/arm64/include/uapi/asm/kvm.h
> > @@ -209,6 +209,12 @@ struct kvm_arch_memory_slot {
> >  #define KVM_DEV_ARM_VGIC_GRP_CTRL	4
> >  #define KVM_DEV_ARM_VGIC_GRP_REDIST_REGS 5
> >  #define KVM_DEV_ARM_VGIC_CPU_SYSREGS    6
> > +#define KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO 7
> > +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT	9
> 
> This should be 10, bits 0 through 9 gives you 10 to work with.
> 
> > +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_MASK \
> > +			(0x7fffffULL << KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_SHIFT)
> 
> this mask is also wrong, 32 - 10 == 22, not 23.
> 
> > +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INTID_MASK	0x1ff
> 
> this is also wrong, you have 10 bits, not 9 bits.
> 
> Hint: the max SPI number is around 1024.
> 
> > +#define KVM_DEV_ARM_VGIC_LINE_LEVEL_INFO_VAL	1
> 
> This should really be KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO_LEVEL.  Why is 0
> not a valid value?
> 

actually, the API documentation specifies that this should simply be
defined as VGIC_LEVEL_INFO_LINE_LEVEL.

-Christoffer
