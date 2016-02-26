From: Christoffer Dall <christoffer.dall@linaro.org>
Subject: Re: [Question] Can KVM run on Freescale IMX6 SABRE board?
Date: Fri, 26 Feb 2016 08:54:41 +0100
Message-ID: <20160226075441.GA9352@cbox>
References: <CAPSnSYoxmmDm--vuigyHb2xPr1GpSf22meO59kDQh1s2HFySiA@mail.gmail.com>
 <CAFEAcA_Dt=swYzqmLMyok5SHWhfFP5Lsj42GnNg0tEg-JjGEyQ@mail.gmail.com>
 <CAPSnSYooB+QiTq9t1n_wXevsMZFVQbtsmAd2jERff05aFn+oYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id A50C448529
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 02:46:50 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id TDEpM4g5qJT6 for <kvmarm@lists.cs.columbia.edu>;
 Fri, 26 Feb 2016 02:46:49 -0500 (EST)
Received: from mail-wm0-f47.google.com (mail-wm0-f47.google.com [74.125.82.47])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id A31344130B
 for <kvmarm@lists.cs.columbia.edu>; Fri, 26 Feb 2016 02:46:49 -0500 (EST)
Received: by mail-wm0-f47.google.com with SMTP id g62so61217234wme.1
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2016 23:53:39 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CAPSnSYooB+QiTq9t1n_wXevsMZFVQbtsmAd2jERff05aFn+oYw@mail.gmail.com>
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

On Thu, Feb 25, 2016 at 12:45:45PM -0500, xu mike wrote:
> Hi Peter,
> 
> 2016-02-25 10:30 GMT-05:00 Peter Maydell <peter.maydell@linaro.org>:
> >
> > On 25 February 2016 at 15:17, xu mike <upennmike@gmail.com> wrote:
> > > I'm a student from the University of Pennsylvania. I want to try KVM on ARM
> > > boards.
> > >
> > > I have a Freescale IMX6 board [1] which has ARM Cortex A9 processors.
> > > I'm wondering if KVM can run on the Freescale IMX6 board? or
> > > Can KVM run on any ARM board with ARM Cortex A9 processors?
> > >
> > > I noticed at [2] that " KVM/ARM is designed specifically to work on ARM
> > > processors with the virtualization extensions enabled to run unmodified
> > > guest operating systems."
> > > I'm wondering if this statement is still true?
> >
> > Yes, it is. You need a CPU with the virtualization extensions,
> > and the A9 does not have them. You want (for instance) an A15
> > or an A7. There are cheap A7-based development boards out there,
> > for instance the CubieTruck (which is not very fast but can run
> > a mainline Linux kernel and KVM so is a reasonable getting-started
> > development platform).
> 
> 
> Thank you very much for your quick reply!
> 
> I'm wondering if KVM community has any plan to make KVM compatible
> with Cortex A9 processors?
> 

Not that I'm aware, no.

> If someone, with linux scheduler development experiment but without
> porting experiment, wants to port KVM to Cortex A9,  how hard could it
> be to port KVM onto Cortex A9 processor?

As Peter said, ARM is not a virtualizable architecture, so you need
hardware support for virtualization to run hypervisors on an ARM system.

Cortex-A9 does not have this support.

You could implement something using either binary translation or
paravirtualization, but neither is something we're immediately
interested in accepting in mainline Linux.

What is your use-case for running on A9 specifically, as opposed to a
CPU with virt support?

Thanks,
-Christoffer
