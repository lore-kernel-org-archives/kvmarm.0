From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [Question] Can KVM run on Freescale IMX6 SABRE board?
Date: Sat, 27 Feb 2016 13:06:21 +0100
Message-ID: <20160227120621.GA32621@cbox>
References: <CAPSnSYoxmmDm--vuigyHb2xPr1GpSf22meO59kDQh1s2HFySiA@mail.gmail.com>
 <CAFEAcA_Dt=swYzqmLMyok5SHWhfFP5Lsj42GnNg0tEg-JjGEyQ@mail.gmail.com>
 <CAPSnSYooB+QiTq9t1n_wXevsMZFVQbtsmAd2jERff05aFn+oYw@mail.gmail.com>
 <20160226075441.GA9352@cbox>
 <CAPSnSYqNAYVSve8KeEkAGH3iwf1tbNntTfp5MwEAG-QSfRg8FA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id D70BD40FA7
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Feb 2016 06:58:24 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id uPKl-LsfXDCe for <kvmarm@lists.cs.columbia.edu>;
 Sat, 27 Feb 2016 06:58:23 -0500 (EST)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com [74.125.82.46])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id B200240FA2
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Feb 2016 06:58:23 -0500 (EST)
Received: by mail-wm0-f46.google.com with SMTP id g62so102157768wme.0
 for <kvmarm@lists.cs.columbia.edu>; Sat, 27 Feb 2016 04:05:19 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAPSnSYqNAYVSve8KeEkAGH3iwf1tbNntTfp5MwEAG-QSfRg8FA@mail.gmail.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: xu mike <upennmike@gmail.com>
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

On Fri, Feb 26, 2016 at 10:53:44AM -0500, xu mike wrote:
> 2016-02-26 2:54 GMT-05:00 Christoffer Dall <christoffer.dall@linaro.org>:
> > On Thu, Feb 25, 2016 at 12:45:45PM -0500, xu mike wrote:
> >> Hi Peter,
> >>
> >> 2016-02-25 10:30 GMT-05:00 Peter Maydell <peter.maydell@linaro.org>:
> >> >
> >> > On 25 February 2016 at 15:17, xu mike <upennmike@gmail.com> wrote:
> >> > > I'm a student from the University of Pennsylvania. I want to try KVM on ARM
> >> > > boards.
> >> > >
> >> > > I have a Freescale IMX6 board [1] which has ARM Cortex A9 processors.
> >> > > I'm wondering if KVM can run on the Freescale IMX6 board? or
> >> > > Can KVM run on any ARM board with ARM Cortex A9 processors?
> >> > >
> >> > > I noticed at [2] that " KVM/ARM is designed specifically to work on ARM
> >> > > processors with the virtualization extensions enabled to run unmodified
> >> > > guest operating systems."
> >> > > I'm wondering if this statement is still true?
> >> >
> >> > Yes, it is. You need a CPU with the virtualization extensions,
> >> > and the A9 does not have them. You want (for instance) an A15
> >> > or an A7. There are cheap A7-based development boards out there,
> >> > for instance the CubieTruck (which is not very fast but can run
> >> > a mainline Linux kernel and KVM so is a reasonable getting-started
> >> > development platform).
> >>
> >>
> >> Thank you very much for your quick reply!
> >>
> >> I'm wondering if KVM community has any plan to make KVM compatible
> >> with Cortex A9 processors?
> >>
> >
> > Not that I'm aware, no.
> >
> >> If someone, with linux scheduler development experiment but without
> >> porting experiment, wants to port KVM to Cortex A9,  how hard could it
> >> be to port KVM onto Cortex A9 processor?
> >
> > As Peter said, ARM is not a virtualizable architecture, so you need
> > hardware support for virtualization to run hypervisors on an ARM system.
> >
> > Cortex-A9 does not have this support.
> >
> > You could implement something using either binary translation or
> > paravirtualization, but neither is something we're immediately
> > interested in accepting in mainline Linux.
> 
> Right. I couldn't estimate how hard it will be to achieve the
> paravirtualization/binary translation in KVM.. Probably it may involve
> a lot of (assembly) code, since it requires to de-privilege those
> privileged instructions. :-(
> 

I don't think you'd have to write a lot of assembly code, but writing an
in-kernel binary translator is simply beyond the scope of what KVM was
designed for, and making a binary translator efficient and adding
support for shadow page tables will be non-trivial.

If anything, but again, I stress that I would *not* accept this upstream,
you could build something that was paravirtualized with shadow page
table support.

> >
> > What is your use-case for running on A9 specifically, as opposed to a
> > CPU with virt support?
> 
> The reason why I have to use A9 is because A9 has the special cache
> controller, called PL310 cache controller, which is not supported in
> A7 or A15. I want to use the special cache controller in
> virtualization environment. That's why I'm so addicted to A9. :-(
> If there is some latest ARM processor that has the PL310 cache
> controller and virtulaizaiton extension support, that will be awesome!
> However, I'm unaware of the ideal ARM processors. :-( Do you happen to
> know?
> 

I have no idea, no.  I'm curious, why is it important for you to have a
PL310 cache controller in a VM?

Is this research or product oriented?

In any case, I would give up on A9 virtualization and use a proper piece
of hardware for virtualization on ARM.

-Christoffer
