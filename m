From: Andrew Jones <drjones@redhat.com>
Subject: Re: [PATCH v3 0/2] KVM: ARM: Enable vtimers with user space gic
Date: Fri, 16 Sep 2016 15:46:19 +0200
Message-ID: <20160916134619.jjiaplhxgkkl5qri@kamzik.localdomain>
References: <1474007187-18673-1-git-send-email-agraf@suse.de>
 <57DBC782.7080305@arm.com>
 <7beb406b-6194-8451-2d92-9a4394ef91dd@redhat.com>
 <20160916123039.GB14140@cbox>
 <da8191ca-6fb1-f960-872c-d6bc27172db8@redhat.com>
 <20160916133027.GA27036@cbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 2D54549AF5
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 09:37:35 -0400 (EDT)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id li3ZfYlvs4Ef for <kvmarm@lists.cs.columbia.edu>;
 Fri, 16 Sep 2016 09:37:32 -0400 (EDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id 9F618499A1
 for <kvmarm@lists.cs.columbia.edu>; Fri, 16 Sep 2016 09:37:32 -0400 (EDT)
Content-Disposition: inline
In-Reply-To: <20160916133027.GA27036@cbox>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Christoffer Dall <christoffer.dall@linaro.org>
Cc: kvm@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>, Paolo Bonzini <pbonzini@redhat.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 16, 2016 at 03:30:27PM +0200, Christoffer Dall wrote:
> On Fri, Sep 16, 2016 at 02:31:42PM +0200, Paolo Bonzini wrote:
> > 
> > 
> > On 16/09/2016 14:30, Christoffer Dall wrote:
> > > > > > This patch set allows user space to receive vtimer events as well as mask
> > > > > > them, so that we can handle all vtimer related interrupt injection from user
> > > > > > space, enabling us to use architected timer with user space gic emulation.
> > > > >
> > > > > I have already voiced my concerns in the past, including face to face,
> > > > > and I'm going to repeat it: I not keen at all on adding a new userspace
> > > > > interface that is going to bitrot extremely quickly.
> > > > 
> > > > You don't have automated tests set up?  It's not going to bitrot if you
> > > > test it, either with kvm-unit-tests or just by smoke-testing Linux.
> > > > It's _for_ the raspi, but it's not limited to it.
> > > 
> > > Our automated testing situation is not great, no.  Something we're
> > > looking at, but have resource problems with.
> > 
> > But it's not a good reason to hold back a feature...
> > 
> 
> I didn't say that exactly, but choosing not to merge something we cannot
> maintain and which we're not paid to look after and where there's a
> minimal interest, is not entirely unreasonable.
> 
> That being said, I'm not categorically against these patches, but I
> share Marc's view that we've already seen that non-vgic support had been
> broken for multiple versions without anyone complaining, and without
> automated testing or substantial interest in the work, the patches
> really are likely to bit-rot.
> 
> But I haven't even looked at the patches in detail, I was just replying
> to the comment about testing.

This may be a great time to start encouraging feature writers to submit
kvm-unit-tests patches at the same time as the feature (Hi Alex :-) I'm
happy to help when a test isn't easy to write due to a lack of framework,
but don't have nearly enough bandwidth to write all the tests myself.

As for additional motivation for this series, I'll point out that it's
good for bug isolation. When a guest fails to boot over KVM I can try
TCG. If that works, then I've likely narrowed it to KVM. If I can
further try kernel_irqchip=no, then I may further narrow it down to
the vgic implementation.

Thanks,
drew
