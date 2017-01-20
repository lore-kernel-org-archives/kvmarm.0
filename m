From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v10 7/8] arm/arm64: vgic: Implement
 KVM_DEV_ARM_VGIC_GRP_LEVEL_INFO ioctl
Date: Fri, 20 Jan 2017 20:54:58 +0100
Message-ID: <20170120195458.GI13531@cbox>
References: <1480576187-5012-1-git-send-email-vijay.kilari@gmail.com>
 <1480576187-5012-8-git-send-email-vijay.kilari@gmail.com>
 <4272e489-7aa4-b77d-ec09-22b58af78336@redhat.com>
 <CAFEAcA-Ev4_949mRvagAa0wtMnUZBuQmMssWsMs3JPTBw_FviQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 8192D4092C
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jan 2017 14:55:06 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id CT-FUoDobXGH for <kvmarm@lists.cs.columbia.edu>;
 Fri, 20 Jan 2017 14:55:05 -0500 (EST)
Received: from mail-lf0-f52.google.com (mail-lf0-f52.google.com
 [209.85.215.52])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 5823D40783
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jan 2017 14:55:05 -0500 (EST)
Received: by mail-lf0-f52.google.com with SMTP id n124so64144747lfd.2
 for <kvmarm@lists.cs.columbia.edu>; Fri, 20 Jan 2017 11:55:05 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAFEAcA-Ev4_949mRvagAa0wtMnUZBuQmMssWsMs3JPTBw_FviQ@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Peter Maydell <peter.maydell@linaro.org>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Vijaya Kumar K <Vijaya.Kumar@cavium.com>, "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>, arm-mail-list <linux-arm-kernel@lists.infradead.org>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Dec 16, 2016 at 12:44:18PM +0000, Peter Maydell wrote:
> On 16 December 2016 at 12:07, Auger Eric <eric.auger@redhat.com> wrote:
> > Hi Vijaya,
> >
> > On 01/12/2016 08:09, vijay.kilari@gmail.com wrote:
> >> +void vgic_write_irq_line_level_info(struct kvm_vcpu *vcpu, u32 intid,
> >> +                                 const u64 val)
> >> +{
> >> +     int i;
> >> +
> >> +     for (i = 0; i < 32; i++) {
> >> +             struct vgic_irq *irq = vgic_get_irq(vcpu->kvm, vcpu, intid + i);
> >> +
> > same as above.
> >> +             spin_lock(&irq->irq_lock);
> >> +             if (val & (1U << i)) {
> >> +                     if (irq->config == VGIC_CONFIG_LEVEL) {
> >> +                             irq->line_level = true;
> >> +                             irq->pending = true;
> >> +                             vgic_queue_irq_unlock(vcpu->kvm, irq);
> >> +                     } else {
> >> +                             spin_unlock(&irq->irq_lock);
> >> +                     }
> >> +             } else {
> >> +                     if (irq->config == VGIC_CONFIG_EDGE ||
> > can't we just ignore VGIC_CONFIG_EDGE case for which line_level is not
> > modeled?
> >> +                         (irq->config == VGIC_CONFIG_LEVEL &&
> >> +                         !irq->soft_pending))
> >> +                             irq->line_level = false;
> > To me the line level does not depend on the soft_pending bit. The
> > pending state depends on both.
> 
> Without having looked at the details, it seems surprising to
> me that the implementation of "set line level to X" is not
> "set irq->line_level to X; figure out consequences and update
> other state as necessary"...
> 
Indeed.  Assuming you're ok with the API requiring config state to be
restored before the line level state, I think my suggestion in the
separate reply should work.

Of course, we need to clarify the ordering requirement in the API.

Thanks,
-Christoffer
