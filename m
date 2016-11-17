From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v8 5/7] arm/arm64: vgic: Introduce VENG0 and VENG1 fields
 to vmcr struct
Date: Thu, 17 Nov 2016 17:01:54 +0100
Message-ID: <20161117160154.GA23588@cbox>
References: <1478258013-6669-1-git-send-email-vijay.kilari@gmail.com>
 <1478258013-6669-6-git-send-email-vijay.kilari@gmail.com>
 <20161116185227.GE3811@cbox>
 <CALicx6vP8FyaGa3f=T6RdC+Qd0iYMWiQ5g+g0_KQG6kzoJtzFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8D3F4402EC
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 11:01:29 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id VO1om64qJJ9Q for <kvmarm@lists.cs.columbia.edu>;
 Thu, 17 Nov 2016 11:01:27 -0500 (EST)
Received: from mail-qk0-f180.google.com (mail-qk0-f180.google.com
 [209.85.220.180])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AAC13401BF
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 11:01:27 -0500 (EST)
Received: by mail-qk0-f180.google.com with SMTP id q130so226451019qke.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 17 Nov 2016 08:02:00 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CALicx6vP8FyaGa3f=T6RdC+Qd0iYMWiQ5g+g0_KQG6kzoJtzFA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Vijay Kilari <vijay.kilari@gmail.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, kvmarm@lists.cs.columbia.edu, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Thu, Nov 17, 2016 at 06:12:39PM +0530, Vijay Kilari wrote:
> On Thu, Nov 17, 2016 at 12:22 AM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> > On Fri, Nov 04, 2016 at 04:43:31PM +0530, vijay.kilari@gmail.com wrote:
> >> From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> >>
> >> ICC_VMCR_EL2 supports virtual access to ICC_IGRPEN1_EL1.Enable
> >> and ICC_IGRPEN0_EL1.Enable fields. Add grpen0 and grpen1 member
> >> variables to struct vmcr to support read and write of these fields.
> >>
> >> Also refactor vgic_set_vmcr and vgic_get_vmcr() code.
> >> Drop ICH_VMCR_CTLR_SHIFT and ICH_VMCR_CTLR_MASK macros and instead
> >> use ICH_VMCR_EOI* and ICH_VMCR_CBPR* macros
> >> .
> >> Signed-off-by: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> >> ---
> >>  include/linux/irqchip/arm-gic-v3.h |  2 --
> >>  virt/kvm/arm/vgic/vgic-mmio-v2.c   | 16 ----------------
> >>  virt/kvm/arm/vgic/vgic-mmio.c      | 16 ++++++++++++++++
> >>  virt/kvm/arm/vgic/vgic-v3.c        | 10 ++++++++--
> >>  virt/kvm/arm/vgic/vgic.h           |  5 +++++
> >>  5 files changed, 29 insertions(+), 20 deletions(-)
> >>
> >> diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
> >> index d48d886..61646aa 100644
> >> --- a/include/linux/irqchip/arm-gic-v3.h
> >> +++ b/include/linux/irqchip/arm-gic-v3.h
> >> @@ -404,8 +404,6 @@
> >>  #define ICH_HCR_EN                   (1 << 0)
> >>  #define ICH_HCR_UIE                  (1 << 1)
> >>
> >> -#define ICH_VMCR_CTLR_SHIFT          0
> >> -#define ICH_VMCR_CTLR_MASK           (0x21f << ICH_VMCR_CTLR_SHIFT)
> >>  #define ICH_VMCR_CBPR_SHIFT          4
> >>  #define ICH_VMCR_CBPR_MASK           (1 << ICH_VMCR_CBPR_SHIFT)
> >>  #define ICH_VMCR_EOIM_SHIFT          9
> >> diff --git a/virt/kvm/arm/vgic/vgic-mmio-v2.c b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> >> index 2cb04b7..ad353b5 100644
> >> --- a/virt/kvm/arm/vgic/vgic-mmio-v2.c
> >> +++ b/virt/kvm/arm/vgic/vgic-mmio-v2.c
> >> @@ -212,22 +212,6 @@ static void vgic_mmio_write_sgipends(struct kvm_vcpu *vcpu,
> >>       }
> >>  }
> >>
> >> -static void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
> >> -{
> >> -     if (kvm_vgic_global_state.type == VGIC_V2)
> >> -             vgic_v2_set_vmcr(vcpu, vmcr);
> >> -     else
> >> -             vgic_v3_set_vmcr(vcpu, vmcr);
> >> -}
> >> -
> >> -static void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
> >> -{
> >> -     if (kvm_vgic_global_state.type == VGIC_V2)
> >> -             vgic_v2_get_vmcr(vcpu, vmcr);
> >> -     else
> >> -             vgic_v3_get_vmcr(vcpu, vmcr);
> >> -}
> >> -
> >>  #define GICC_ARCH_VERSION_V2 0x2
> >>
> >>  /* These are for userland accesses only, there is no guest-facing emulation. */
> >> diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> >> index 9939d1d..173d6f0 100644
> >> --- a/virt/kvm/arm/vgic/vgic-mmio.c
> >> +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> >> @@ -416,6 +416,22 @@ int vgic_validate_mmio_region_addr(struct kvm_device *dev,
> >>       return -ENXIO;
> >>  }
> >>
> >> +void vgic_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
> >> +{
> >> +     if (kvm_vgic_global_state.type == VGIC_V2)
> >> +             vgic_v2_set_vmcr(vcpu, vmcr);
> >> +     else
> >> +             vgic_v3_set_vmcr(vcpu, vmcr);
> >> +}
> >> +
> >> +void vgic_get_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcr)
> >> +{
> >> +     if (kvm_vgic_global_state.type == VGIC_V2)
> >> +             vgic_v2_get_vmcr(vcpu, vmcr);
> >> +     else
> >> +             vgic_v3_get_vmcr(vcpu, vmcr);
> >> +}
> >> +
> >>  /*
> >>   * kvm_mmio_read_buf() returns a value in a format where it can be converted
> >>   * to a byte array and be directly observed as the guest wanted it to appear
> >> diff --git a/virt/kvm/arm/vgic/vgic-v3.c b/virt/kvm/arm/vgic/vgic-v3.c
> >> index 9f0dae3..967c295 100644
> >> --- a/virt/kvm/arm/vgic/vgic-v3.c
> >> +++ b/virt/kvm/arm/vgic/vgic-v3.c
> >> @@ -175,10 +175,13 @@ void vgic_v3_set_vmcr(struct kvm_vcpu *vcpu, struct vgic_vmcr *vmcrp)
> >>  {
> >>       u32 vmcr;
> >>
> >> -     vmcr  = (vmcrp->ctlr << ICH_VMCR_CTLR_SHIFT) & ICH_VMCR_CTLR_MASK;
> >> +     vmcr  = (vmcrp->ctlr << ICH_VMCR_CBPR_SHIFT) & ICH_VMCR_CBPR_MASK;
> >> +     vmcr |= (vmcrp->ctlr << ICH_VMCR_EOIM_SHIFT) & ICH_VMCR_EOIM_MASK;
> >
> > This looks weird:  The EOImode field is bit[2] in the CTLR, and VEOIM is
> > bit[9] in the ICH_VMCR, but you're just shifting the ctlr field left by
> > 9 and then masking off everything by bit 9, so you'll end with never
> > being able to set VEOIM I think...
> >
> OK
> > Also, we do we now forget about VFIQEn and VAckCtl?  The latter I can
> > understand because it's deprecated, but why the first?  This particular
> > piece of information would be very nice to have in the commit message.
> 
> I understand that group 0 interrupts are not handled. So vFIQEn can be ignored.
> Spec says, if SRE=1 (non-secure) this bit is RES1 also it is alias to
> ICC_CTLR_EL1
> if SRE is 1. However there is no bit in ICC_CTLR_EL1 for FIQen. It is defined
> only in GICV_CTLR which is used when SRE=0.

So you should add a comment or the very least add to the commit message
that we ignore the FIQen bit, because our GIC emulation always implies
SRE=1 which means the vFIQEn bit is also RES1 (if I got this right).

-Christoffer
