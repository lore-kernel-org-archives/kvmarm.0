From: xu mike <upennmike@gmail.com>
Subject: Re: [Question] Can KVM run on Freescale IMX6 SABRE board?
Date: Thu, 25 Feb 2016 12:45:45 -0500
Message-ID: <CAPSnSYooB+QiTq9t1n_wXevsMZFVQbtsmAd2jERff05aFn+oYw@mail.gmail.com>
References: <CAPSnSYoxmmDm--vuigyHb2xPr1GpSf22meO59kDQh1s2HFySiA@mail.gmail.com>
 <CAFEAcA_Dt=swYzqmLMyok5SHWhfFP5Lsj42GnNg0tEg-JjGEyQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 94307410D7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2016 12:38:58 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 5ku-gwZcMeHR for <kvmarm@lists.cs.columbia.edu>;
 Thu, 25 Feb 2016 12:38:57 -0500 (EST)
Received: from mail-yw0-f181.google.com (mail-yw0-f181.google.com
 [209.85.161.181])
 by mm01.cs.columbia.edu (Postfix) with ESMTPS id AD7B740FA7
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2016 12:38:57 -0500 (EST)
Received: by mail-yw0-f181.google.com with SMTP id e63so48576112ywc.3
 for <kvmarm@lists.cs.columbia.edu>; Thu, 25 Feb 2016 09:45:46 -0800 (PST)
In-Reply-To: <CAFEAcA_Dt=swYzqmLMyok5SHWhfFP5Lsj42GnNg0tEg-JjGEyQ@mail.gmail.com>
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
Cc: "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>
List-Id: kvmarm@lists.cs.columbia.edu

Hi Peter,

2016-02-25 10:30 GMT-05:00 Peter Maydell <peter.maydell@linaro.org>:
>
> On 25 February 2016 at 15:17, xu mike <upennmike@gmail.com> wrote:
> > I'm a student from the University of Pennsylvania. I want to try KVM on ARM
> > boards.
> >
> > I have a Freescale IMX6 board [1] which has ARM Cortex A9 processors.
> > I'm wondering if KVM can run on the Freescale IMX6 board? or
> > Can KVM run on any ARM board with ARM Cortex A9 processors?
> >
> > I noticed at [2] that " KVM/ARM is designed specifically to work on ARM
> > processors with the virtualization extensions enabled to run unmodified
> > guest operating systems."
> > I'm wondering if this statement is still true?
>
> Yes, it is. You need a CPU with the virtualization extensions,
> and the A9 does not have them. You want (for instance) an A15
> or an A7. There are cheap A7-based development boards out there,
> for instance the CubieTruck (which is not very fast but can run
> a mainline Linux kernel and KVM so is a reasonable getting-started
> development platform).


Thank you very much for your quick reply!

I'm wondering if KVM community has any plan to make KVM compatible
with Cortex A9 processors?

If someone, with linux scheduler development experiment but without
porting experiment, wants to port KVM to Cortex A9,  how hard could it
be to port KVM onto Cortex A9 processor?

Best regards,

Meng
