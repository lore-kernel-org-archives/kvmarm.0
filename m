From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 0/2] KVM: ARM: Enable vtimers with user space gic
Date: Fri, 16 Sep 2016 14:30:39 +0200
Message-ID: <20160916123039.GB14140@cbox>
References: <1474007187-18673-1-git-send-email-agraf@suse.de>
 <57DBC782.7080305@arm.com>
 <7beb406b-6194-8451-2d92-9a4394ef91dd@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7beb406b-6194-8451-2d92-9a4394ef91dd@redhat.com>
Sender: kvm-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Marc Zyngier <marc.zyngier@arm.com>, Alexander Graf <agraf@suse.de>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Sep 16, 2016 at 02:18:45PM +0200, Paolo Bonzini wrote:
> 
> 
> On 16/09/2016 12:20, Marc Zyngier wrote:
> > > This patch set allows user space to receive vtimer events as well as mask
> > > them, so that we can handle all vtimer related interrupt injection from user
> > > space, enabling us to use architected timer with user space gic emulation.
> >
> > I have already voiced my concerns in the past, including face to face,
> > and I'm going to repeat it: I not keen at all on adding a new userspace
> > interface that is going to bitrot extremely quickly.
> 
> You don't have automated tests set up?  It's not going to bitrot if you
> test it, either with kvm-unit-tests or just by smoke-testing Linux.
> It's _for_ the raspi, but it's not limited to it.
> 

Our automated testing situation is not great, no.  Something we're
looking at, but have resource problems with.

-Christoffer
