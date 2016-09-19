From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [PATCH v3 0/2] KVM: ARM: Enable vtimers with user space gic
Date: Mon, 19 Sep 2016 13:41:38 +0200
Message-ID: <20160919114138.GA15852@cbox>
References: <1474007187-18673-1-git-send-email-agraf@suse.de>
 <57DBC782.7080305@arm.com>
 <7beb406b-6194-8451-2d92-9a4394ef91dd@redhat.com>
 <20160916123039.GB14140@cbox>
 <da8191ca-6fb1-f960-872c-d6bc27172db8@redhat.com>
 <20160916133027.GA27036@cbox>
 <43020f1f-6367-6f11-2534-b26ced13b540@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kvm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43020f1f-6367-6f11-2534-b26ced13b540@suse.de>
Sender: kvm-owner@vger.kernel.org
To: Alexander Graf <agraf@suse.de>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Marc Zyngier <marc.zyngier@arm.com>, kvmarm@lists.cs.columbia.edu, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org
List-Id: kvmarm@lists.cs.columbia.edu

On Mon, Sep 19, 2016 at 12:51:46PM +0200, Alexander Graf wrote:
> 
> 
> On 16.09.16 15:30, Christoffer Dall wrote:

[...]

> > 
> > That being said, I'm not categorically against these patches, but I
> > share Marc's view that we've already seen that non-vgic support had been
> > broken for multiple versions without anyone complaining, and without
> > automated testing or substantial interest in the work, the patches
> > really are likely to bit-rot.
> 
> I know that it's very hard to grasp from an upstream maintainer
> perspective, 

pfff

> but keep in mind where the bulk of execution of kernel code
> lies. The average life cycle of a "stable" Linux distribution's kernel
> is a few years.
> 
> So far all regressions in the user space gic code have been found within
> less than 1y of the respective code release. I'd say that counts for
> quite a well used feature.
> 

The only report I can think of about this was Pavel using an upstream
kernel for in-house Samsung development on non-public hardware.

But, again, I didn't look at the patches in detail yet, I'm not
categorically against them, I will take a careful look at them like I do
with all patches on the kvmarm list.  There's a risk they'll break in
mainline unless we sort out our testing story, and it may just be
something we'll have to live with.

> > But I haven't even looked at the patches in detail, I was just replying
> > to the comment about testing.
> 
> Also keep in mind that without the architected timer support (and/or
> without qemu patches than enable user space timers) the user space gic
> support is pretty unusable to most people, so you obviously get less
> reports.
>

I don't disagree with this.  I don't know what this has to do with the
part of my mail you're replying to, but I completely agree that the
current userspace irqchip support has limited value.

-Christoffer
