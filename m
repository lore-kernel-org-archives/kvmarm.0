From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [RFC PATCH v3 5/5] arm/arm64: vgic-new: Implement
 KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO ioctl
Date: Tue, 6 Sep 2016 21:20:32 +0200
Message-ID: <20160906192032.GN23592@cbox>
References: <1472037609-4164-1-git-send-email-vijay.kilari@gmail.com>
 <1472037609-4164-6-git-send-email-vijay.kilari@gmail.com>
 <20160830140034.GK10162@cbox>
 <CALicx6scWWykb9Zc45gVkKDo71nVMDRGoa0vo54xDC2FoLJZRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 1B4D749B4C
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 15:09:41 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id BXGYAV4AVPzO for <kvmarm@lists.cs.columbia.edu>;
 Tue,  6 Sep 2016 15:09:39 -0400 (EDT)
Received: from mail-wm0-f44.google.com (mail-wm0-f44.google.com [74.125.82.44])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id EE77649B40
 for <kvmarm@lists.cs.columbia.edu>; Tue,  6 Sep 2016 15:09:38 -0400 (EDT)
Received: by mail-wm0-f44.google.com with SMTP id 1so207833740wmz.1
 for <kvmarm@lists.cs.columbia.edu>; Tue, 06 Sep 2016 12:18:04 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CALicx6scWWykb9Zc45gVkKDo71nVMDRGoa0vo54xDC2FoLJZRg@mail.gmail.com>
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

On Tue, Sep 06, 2016 at 07:42:19PM +0530, Vijay Kilari wrote:
> On Tue, Aug 30, 2016 at 7:30 PM, Christoffer Dall
> <christoffer.dall@linaro.org> wrote:
> >
> > On Wed, Aug 24, 2016 at 04:50:09PM +0530, vijay.kilari@gmail.com wrote:
> > > From: Vijaya Kumar K <Vijaya.Kumar@cavium.com>
> > >  }
> > > diff --git a/virt/kvm/arm/vgic/vgic-mmio-v3.c b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> > > index 61abea0..fde1472 100644
> > > --- a/virt/kvm/arm/vgic/vgic-mmio-v3.c
> > > +++ b/virt/kvm/arm/vgic/vgic-mmio-v3.c
> > > @@ -789,3 +789,22 @@ int vgic_v3_redist_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> > >
> > >       return vgic_v3_uaccess(vcpu, dev, is_write, offset, val);
> > >  }
> > > +
> > > +int vgic_v3_line_level_info_uaccess(struct kvm_vcpu *vcpu, bool is_write,
> > > +                                 u32 intid, u32 *val)
> > > +{
> > > +     unsigned int len = 4;
> > > +     u8 buf[4];
> > > +     int ret;
> > > +
> > > +     if (is_write) {
> > > +             vgic_data_host_to_mmio_bus(buf, len, *val);
> >
> > why do you involve the mmio bus in this?
> 
> This is doing LE conversion. This is being done by vgic_uaccess function.
> IRC, This sys register access in not following vgic_uaccess path. Hence
> added it here.

See my e-mail on the other patch.  I think this is all just legacy from
the time where we didn't distinguish between uaccess and mmio
dispatches.

> >
> >
> > > +             ret = vgic_write_irq_line_level_info(vcpu, intid, len, buf);
> > > +     } else {
> > > +             ret = vgic_read_irq_line_level_info(vcpu, intid, len, buf);
> > > +             if (!ret)
> > > +                     *val = vgic_data_mmio_bus_to_host(buf, len);
> > > +     }
> > > +
> > > +     return ret;
> > > +}
> > > diff --git a/virt/kvm/arm/vgic/vgic-mmio.c b/virt/kvm/arm/vgic/vgic-mmio.c
> > > index 38f2c75..74d0449 100644
> > > --- a/virt/kvm/arm/vgic/vgic-mmio.c
> > > +++ b/virt/kvm/arm/vgic/vgic-mmio.c
> > > @@ -391,6 +391,40 @@ void vgic_mmio_write_config(struct kvm_vcpu *vcpu,
> > >       }
> > >  }
> > >
> > > +int vgic_read_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
> > > +                               unsigned int len, void *val)
> > > +{
> > > +     unsigned long data = 0;
> > > +     int i;
> > > +
> > > +     for (i = 0; i < len * 8; i++) {
> > > +             struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> > > +
> > > +             if (irq->line_level)
> > > +                     data |= (1U << i);
> > > +     }
> > > +     vgic_data_host_to_mmio_bus(val, len, data);
> >
> > why???
> 
> Same as above reason
> >
> >
> > > +
> > > +     return 0;
> > > +}
> > > +
> > > +int vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
> > > +                                unsigned int len, const void *val)
> > > +{
> > > +     int i;
> > > +     unsigned long data = vgic_data_mmio_bus_to_host(val, len);
> >
> > why???
> 
> Same as above reason

Thanks,
-Christoffer
